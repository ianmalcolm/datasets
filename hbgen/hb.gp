set terminal pdf
set output "hb.pdf"
set datafile commentschars "#@"
set xtics ('0' 1, '17' 101, '33' 201, '50' 301, '67' 401, '84' 501, '100' 601, '117' 701, '133' 801, '150' 901, '167' 1001)
#set ytics 3500,100,4000
#set multiplot layout 3,1
plot "hb.arff" u 6 notitle w lines lt -1, \
	"hb.arff" u ($0):($4>0?$6:1/0) notitle w lines lc rgb 'red' lw 5
#plot "hb.arff" u 2 notitle w lines lt -1, \
#	"hb.arff" u ($0):($5>0?$2:1/0) notitle w lines lc rgb 'red' lw 2
#plot "hb.arff" u 2 notitle w lines lt -1, \
#	"hb.arff" u ($0):($4>0?$2:1/0) notitle w lines lc rgb 'red' lw 2
#unset multiplot
