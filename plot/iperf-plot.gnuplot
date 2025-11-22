reset

set xlabel "Epoche time"
set ylabel "kBytes/s"
set grid
set autoscale x
#set key box outside below

# DG 300 Basic
# 300kBit/s -> 38400 kBytes/s
# 150kBit/s -> 19200 kBytes/S

set yrange [0:45000]

# Needed for horizontal lines
# stores min/max for time
stats 'iperf_measurement_dl.log' using 1:4 name "A"
xmin = A_min_x
xmax = A_max_x

set xdata time
set timefmt "%s"
# set xtics 3600
set format x "%H:%M:%S"

set arrow from xmin,38400 to xmax,38400 nohead lc rgb 'green' dt 2
set arrow from xmin,38400/2 to xmax,38400/2 nohead lc rgb 'red' dt 2
plot 'iperf_measurement_ul.log' using 1:4 w points pt 5 lc rgb 'red' title 'Upload [kBytes/s]',  'iperf_measurement_dl.log' using 1:4 w points pt 5 lc rgb 'green' title 'Download [kBytes/s]'
