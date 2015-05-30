import os
import sys
#argv_1 the jar file to run
#argv_2 how many times each case to run to get average performance
le = ['1000', '2000', '4000', '8000', '16000', '32000', '-1']
fi = ['ERP/erp.arff', 'tickwise/tickwise.arff', 'koski/koski.arff', 'qtdbsel102/qtdbsel102.arff']
jar = sys.argv[1]
tm = int(sys.argv[2])

def avg():
    f = open('tmp.txt')
    total = 0
    for i in range(tm):
        s = f.readline()
        total += int(s)
    f.close()
    os.remove('tmp.txt')
    return total/tm

for f in fi:
    for l in le:
        cmd = 'java -jar '+jar+' -len ' +l+ ' -fil ' +f+ ' >> tmp.txt'
        for i in range(tm):
            os.system(cmd)
        t = avg()
        print(f, l, t)
