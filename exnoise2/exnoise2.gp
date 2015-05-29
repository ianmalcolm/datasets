set terminal pdf
set output "exnoise2.pdf"
set datafile commentschars "#@"
set multiplot layout 2,1
set size 1,0.4
set origin 0,0.6
plot "exnoise2.arff" u ($0):1 notitle with lines linetype -1, \
	"exnoise2.arff" u ($0):($2>0 && $0<50 ?$1:1/0) notitle w lines lc rgb 'red' lw 5, \
	"exnoise2.arff" u ($0):($2>0 && $0>50 ?$1:1/0) notitle w lines lc rgb 'green' lw 5, \
	"exnoise2.arff" u ($0):1:4 notitle w labels offset 1.5
set size 1,0.6
set origin 0,0
plot "exnoise2.arff" using 1:3 notitle with points pointtype 6 lc rgb 'black', \
	"exnoise2.arff" u ($1):($2>0 && $0<50 ?$3:1/0) notitle w points pt 7 lc rgb 'red', \
	"exnoise2.arff" u ($1):($2>0 && $0>50 ?$3:1/0) notitle w points pt 7 lc rgb 'green', \
	"exnoise2.arff" u 1:3:4 notitle w labels offset 1.5
unset multiplot
