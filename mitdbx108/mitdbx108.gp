set terminal pdf size 20cm,4cm
set output "mitdbx108.pdf"
set datafile commentschars "#@"
unset key
unset tics
unset border
plot "mitdbx108.arff" u 2 notitle w lines lt -1, \
	"mitdbx108.arff" u ($0):($4>0?$2:1/0) notitle w lines lc rgb 'red' lw 3

