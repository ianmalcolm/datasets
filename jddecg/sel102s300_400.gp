set terminal pdf
set output "sel102s300_400.pdf"
set datafile commentschars "#@"
set xtics ('300' 1, '310' 3601, '320' 7201, '330' 10801, '340' 14401, '350' 18001, '360' 21601, '370' 25201, '380' 28801, '390' 32401, '400' 36001)
set ytics -0.8,0.4,1.2
set multiplot layout 3,1
plot "sel102s300_400.arff" u 2 notitle w lines lt -1, \
	"sel102s300_400.arff" u ($0):($3>0?$2:1/0) notitle w lines lc rgb 'red' lw 5
plot "sel102s300_400.arff" u 2 notitle w lines lt -1, \
	"sel102s300_400.arff" u ($0):($5>0?$2:1/0) notitle w lines lc rgb 'red' lw 5
plot "sel102s300_400.arff" u 2 notitle w lines lt -1, \
	"sel102s300_400.arff" u ($0):($4>0?$2:1/0) notitle w lines lc rgb 'red' lw 5
unset multiplot

