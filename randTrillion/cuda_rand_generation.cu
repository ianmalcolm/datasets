#include "cuda_rand_generation.h"

#include <curand.h>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <locale>
#include <stdio.h>
#include <string>
#include <thrust/copy.h>
#include <thrust/distance.h>
#include <thrust/fill.h>
#include <thrust/for_each.h>
#include <thrust/functional.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/scan.h>
#include <thrust/transform_reduce.h>
#include <time.h>

typedef unsigned long long ulonglong;

using namespace std;

// Comma grouping for number output.
struct GroupedNumbers : public std::numpunct<char> {
 protected:
  string do_grouping() const { return "\003"; }
};

template <typename T>
struct shift_functor
{
    explicit shift_functor(T shift) : shift_(shift) {}

    T shift_;

    __device__
    T operator()(const T& x) const { 
      return x + shift_;
    }
};

CUDARandaomWalkGenerator::CUDARandaomWalkGenerator(
  const ulonglong seed, const float lastValue, const ulonglong offset,
  const bool generateFiles) : kGenerateFiles_(generateFiles) {
  // Get properties of default device.
  cudaDeviceProp properties;
  cudaError_t status = cudaGetDeviceProperties(&properties, 0);
  if (status != cudaSuccess) {
    // TODO(Bilson): Do something later about unsupported devices.
  }
  
  if (kGenerateFiles_)
    hostData = new float[kBatchSizeInterval];

  cout.imbue(locale(cout.getloc(), new GroupedNumbers));
  // Allocation of device memory with an extra location for random walk
  // initialization.
  status = cudaMalloc((void **)&devData, kBatchSizeInterval * sizeof(float));
  if (status != cudaSuccess) {
    std::cout << "Error in device allocation.\n";
    // TODO(Bilson): Need to do something about this failure.
  }

  lastValue_ = lastValue;
  nextOffset_ = offset;

  // Next file prefix number.
  nextFileNumber_ = 0;

  // CURAND library random number generator (RNG).
   // Create generator.
  if (curandCreateGenerator(&gen_, CURAND_RNG_PSEUDO_DEFAULT) !=
      CURAND_STATUS_SUCCESS) {
    std::cout << "Error in creating generator.\n";
    // TODO(Bilson): Need to do something about this failure.
  }
  // Set seed.
  if (curandSetPseudoRandomGeneratorSeed(gen_, seed) !=
      CURAND_STATUS_SUCCESS) {
    std::cout << "Error in setting seed.\n";
    // TODO(Bilson): Need to do something about this failure.
  }
  // Set offset.
  if (curandSetGeneratorOffset(gen_, nextOffset_) !=
      CURAND_STATUS_SUCCESS) {
    std::cout << "Error in setting seed.\n";
  }
}

CUDARandaomWalkGenerator::~CUDARandaomWalkGenerator() {
  if (kGenerateFiles_)
    delete[] hostData;

  if (cudaFree(devData) != cudaSuccess) {
    std::cout << "Error in device allocation.\n";
    // TODO(Bilson): Need to do something about this failure.
  }

  if (curandDestroyGenerator(gen_) != CURAND_STATUS_SUCCESS) {
    std::cout << "Error in creating numbers.\n";
    // TODO(Bilson): Need to do something about this failure.
  }
}

void CUDARandaomWalkGenerator::GenerateFilename(const char *filePrefix,
                                                const unsigned int index,
                                                char *fileName) {
  sprintf(fileName, "%s%05u", filePrefix, index);
}

ulonglong CUDARandaomWalkGenerator::GenerateRandomWalkArray(
    const ulonglong points, float *buffer) {
  // Thrust pointer.
  thrust::device_ptr<float> thrustPtr(devData);
  ulonglong pointsGenerated = 0;
  while (pointsGenerated < points) {
    ulonglong currentBatchCount =
      pointsGenerated + kBatchSizeInterval > points ?
        points - pointsGenerated : kBatchSizeInterval;

    const bool kIsOdd = currentBatchCount & 0x00000001;
    if (kIsOdd) {
      // Must be a multiple of two.
      currentBatchCount++;
    }

    // Create random numbers.
    curandStatus_t status =
      curandGenerateNormal(gen_, devData, currentBatchCount, 0, 1);
    if (status != CURAND_STATUS_SUCCESS) {
      std::cout << "Error in creating numbers.\n";
      return false;
    }
    
    // Dont need the extra random value.
    if (kIsOdd)
      currentBatchCount--;

    // Prefix sum for random walk.
    thrust::inclusive_scan(thrustPtr, thrustPtr + currentBatchCount,
                           thrustPtr);

    // Shift by initial value.
    thrust::transform(thrustPtr, thrustPtr + currentBatchCount, thrustPtr,
      shift_functor<float>(lastValue_));

    // Copy new segment back to host.
    if (cudaMemcpy(buffer + pointsGenerated, devData,
        currentBatchCount * sizeof(float), cudaMemcpyDeviceToHost)
        != cudaSuccess) {
      std::cout << "Error in copying data to host.\n";
      return false;
    }

    // Save last value for next segment.
    lastValue_ = buffer[pointsGenerated + currentBatchCount - 1];

    pointsGenerated += currentBatchCount;
  }
  nextOffset_ += pointsGenerated + 1;
  return pointsGenerated;
}

bool CUDARandaomWalkGenerator::GenerateRandomWalkFile(
    const char* filePrefix, const ulonglong fileCount,
    const ulonglong pointsPerFile) {
  char *fileName = new char[512];

  clock_t start = clock();
  cout << "Creating " << fileCount << " files.\n";
  for (int i = 0; i < fileCount; ++i) {
    GenerateFilename(filePrefix, nextFileNumber_++, fileName);
    cout << "Beginning file " << fileName << endl;
    // Create file and update next offset value.
    nextOffset_ += PopulateFile(fileName, pointsPerFile) + 1;
  }

  clock_t end = clock();

  // Report times and clean up.
  cout << "Elapsed generation minutes: "
       << (end - start) / (double) CLOCKS_PER_SEC / 60.0
       << endl;
  delete[] fileName;

  cout << "Last point: " << lastValue_ << endl;
  cout << "Next offset: " << nextOffset_ << endl;
  return true;
}

ulonglong CUDARandaomWalkGenerator::PopulateFile(const char* fileName,
                                                 const ulonglong points) {
  // Thrust pointer.
  thrust::device_ptr<float> thrustPtr(devData);
  // Output stream.
  ofstream outfile(fileName, ofstream::out | ofstream::binary);
  ulonglong pointsGenerated = 0;
  cout << "Creating " << points << " points.\n";
  while (pointsGenerated < points) {
    ulonglong currentBatchCount =
      pointsGenerated + kBatchSizeInterval > points ?
        points - pointsGenerated :
        kBatchSizeInterval;
    
    const bool kIsOdd = currentBatchCount & 0x00000001;
    if (kIsOdd) {
      // Must be a multiple of two.
      currentBatchCount++;
    }

    // Create random numbers.
    if (curandGenerateNormal(gen_, devData, currentBatchCount, 0, 1) !=
          CURAND_STATUS_SUCCESS) {
      std::cout << "Error in creating numbers.\n";
      return false;
    }

    // Dont need the extra random value.
    if (kIsOdd)
      currentBatchCount--;

    // Prefix sum for random walk.
    thrust::inclusive_scan(thrustPtr, thrustPtr + currentBatchCount,
                           thrustPtr);

    // Shift by initial value.
    thrust::transform(thrustPtr, thrustPtr + currentBatchCount, thrustPtr,
      shift_functor<float>(lastValue_));

    // Copy new segment back to host.
    if (cudaMemcpy(hostData, devData, currentBatchCount * sizeof(float),
                   cudaMemcpyDeviceToHost)
          != cudaSuccess) {
      std::cout << "Error in copying data to host.\n";
      return false;
    }

    // Save last value for next segment.
    lastValue_ = hostData[currentBatchCount - 1];

    outfile.write(reinterpret_cast<char *>(hostData),
                  currentBatchCount * sizeof(float));
    pointsGenerated += currentBatchCount;
    cout << "\rPoints generated: " << pointsGenerated;
  }
  cout << endl;
  outfile.close();
  return pointsGenerated;
}
