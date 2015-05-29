set terminal pdf
set output "exnoise.pdf"
set datafile commentschars "#@"
set multiplot layout 3,1
plot "exnoise.arff" using 1 notitle with lines linetype -1, \
	"exnoise.arff" using ($0):($2>0?$1:1/0) notitle with lines linecolor rgb 'red' linewidth 5
plot "exnoise.arff" using 1 notitle with lines linetype -1, \
	"exnoise.arff" using ($0):($4>0?$1:1/0) notitle with lines linecolor rgb 'red' linewidth 5
plot "exnoise.arff" using 1 notitle with lines linetype -1, \
	"exnoise.arff" using ($0):($3>0?$1:1/0) notitle with lines linecolor rgb 'red' linewidth 5
unset multiplot
