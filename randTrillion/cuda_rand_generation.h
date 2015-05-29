// This class generates a random walk time series using CUDA capable GPUs.
// If generating files, each file generated contains at least the specified
// number of points. Files are numbered monotonically from zero.
// The period of the generation function is ~2^192. File generation or buffer
// population mode has to be specified according to planned usage.
//
// Example usage. Creating random walk to float buffer:
//
// CUDARandaomWalkGenerator gen(seed, lastValue, offset, false);
// const unsigned long long kTimeSeriesLength = 10000;
// const unsigned long long kBufferSize = 512;
// float *buffer = new float[kBufferSize];
// unsigned long long pointsGenerated = 0;
//
// while (pointsGenerated < kTimeSeriesLength) {
//   pointsGenerated += gen.GenerateRandomWalkArray(kBufferSize, buffer);
//   // ...
//   // Do something with buffer.
//   // ...
// }

#ifndef __CUDA_RAND_GENERATION_H__
#define __CUDA_RAND_GENERATION_H__

#include <curand.h>

typedef unsigned long long ulonglong;

using namespace std;

class CUDARandaomWalkGenerator {
 public:
  CUDARandaomWalkGenerator(const ulonglong seed,
                           const float lastValue,
                           const ulonglong offset,
                           const bool generateFiles);
  ~CUDARandaomWalkGenerator();
  
  // Loads the supplied buffer with a random walk time series. Repeated calls
  // to this function will continue the time series.
  ulonglong GenerateRandomWalkArray(const ulonglong points, float *buffer);
  // Generates a random walk time series to file. Repeated calls will continue
  // the time series.
  bool GenerateRandomWalkFile(const char* filePrefix,
                              const ulonglong fileCount,
                              const ulonglong pointsPerFile);
  // Generates the filename of the corresponding data file index.
  static void GenerateFilename(const char *filePrefix,
                               const unsigned int index,
                               char *fileName);

 private:
  // Generates the next random walk segment starting from the initial value.
  // Returns the number of points generated.
  ulonglong PopulateFile(const char* fileName, const ulonglong points);

  // Local data buffer.
  float *hostData;
  // Device data buffer.
  float *devData;
  // Last computed point.
  float lastValue_;
  // Next point index.
  ulonglong nextOffset_;
  // Next generated file suffix.
  ulonglong nextFileNumber_;
  // CURAND generator.
  curandGenerator_t gen_;
  // Flag for generating in-memory or file time series.
  const bool kGenerateFiles_;

  // We'll use batch sizes of multiples of 10 million to the GPU.
  static const size_t kBatchSizeInterval = 10000000;
};

#endif
