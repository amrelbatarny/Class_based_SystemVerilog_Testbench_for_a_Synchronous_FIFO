vlib work
vlog -f src_files.list -mfcu +define+SIM +cover
vsim -voptargs=+acc work.FIFO_top -cover
add wave -position 1   -color red	sim:/FIFO_top/FIFOif/clk
add wave -position 2    			sim:/FIFO_top/FIFOif/rst_n
add wave -position 3    			sim:/FIFO_top/FIFOif/wr_en
add wave -position 4    			sim:/FIFO_top/FIFOif/rd_en
add wave -position 5    			sim:/FIFO_top/FIFOif/data_in
add wave -position 6   -color cyan 	sim:/FIFO_top/FIFOif/data_out
add wave -position 7   -color gold  sim:/FIFO_top/FIFOif/data_out_ref
add wave -position 8   -color cyan 	sim:/FIFO_top/FIFOif/wr_ack
add wave -position 9   -color gold  sim:/FIFO_top/FIFOif/wr_ack_ref
add wave -position 10  -color cyan 	sim:/FIFO_top/FIFOif/full
add wave -position 11  -color gold  sim:/FIFO_top/FIFOif/full_ref
add wave -position 12  -color cyan 	sim:/FIFO_top/FIFOif/empty
add wave -position 13  -color gold  sim:/FIFO_top/FIFOif/empty_ref
add wave -position 14  -color cyan 	sim:/FIFO_top/FIFOif/almostfull
add wave -position 15  -color gold  sim:/FIFO_top/FIFOif/almostfull_ref
add wave -position 16  -color cyan 	sim:/FIFO_top/FIFOif/almostempty
add wave -position 17  -color gold  sim:/FIFO_top/FIFOif/almostempty_ref
add wave -position 18  -color cyan 	sim:/FIFO_top/FIFOif/overflow
add wave -position 19  -color gold  sim:/FIFO_top/FIFOif/overflow_ref
add wave -position 20  -color cyan 	sim:/FIFO_top/FIFOif/underflow
add wave -position 21  -color gold  sim:/FIFO_top/FIFOif/underflow_ref
add wave -position 22  -color blue	sim:/FIFO_top/DUT/mem
add wave -position 23  -color blue 	sim:/FIFO_top/DUT/count
add wave -position 24  -color blue 	sim:/FIFO_top/DUT/wr_ptr
add wave -position 25  -color blue 	sim:/FIFO_top/DUT/rd_ptr
add wave -position 26  			 	sim:/FIFO_top/DUT/assert_full
add wave -position 27  			 	sim:/FIFO_top/DUT/assert_empty
add wave -position 28  			 	sim:/FIFO_top/DUT/assert_almostfull
add wave -position 29  			 	sim:/FIFO_top/DUT/assert_almostempty
add wave -position 30  			 	sim:/FIFO_top/DUT/assert_overflow
add wave -position 31  			 	sim:/FIFO_top/DUT/assert_underflow
add wave -position 32  			 	sim:/FIFO_top/DUT/assert_wr_ack
add wave -position 33  			 	sim:/FIFO_top/DUT/assert_count_incr
add wave -position 34  			 	sim:/FIFO_top/DUT/assert_count_decr
add wave -position 35  			 	sim:/FIFO_top/DUT/assert_wr_ptr_incr
add wave -position 36  			 	sim:/FIFO_top/DUT/assert_rd_ptr_incr
add wave -position 37  			 	sim:/FIFO_top/DUT/assert_count_rst
add wave -position 38  			 	sim:/FIFO_top/DUT/assert_wr_ptr_rst
add wave -position 39  			 	sim:/FIFO_top/DUT/assert_rd_ptr_rst
.vcop Action toggleleafnames
coverage save FIFO_tb.ucdb -onexit -du FIFO
run -all
coverage report -detail -cvg -directive -comments -output fcover_report.txt {}
#quit -sim
#vcover report FIFO_tb.ucdb -details -annotate -all -output coverage_rpt.txt