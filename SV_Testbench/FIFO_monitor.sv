import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;

module FIFO_monitor (FIFO_if FIFOif);
	FIFO_transaction FIFO_tr = new();
	FIFO_scoreboard FIFO_sb = new();
	FIFO_coverage FIFO_cvg = new();

	initial begin
		forever @(negedge FIFOif.clk) begin
			//Assigning inputs
			FIFO_tr.data_in = FIFOif.data_in;
			FIFO_tr.wr_en = FIFOif.wr_en;
			FIFO_tr.rd_en = FIFOif.rd_en;
			FIFO_tr.rst_n = FIFOif.rst_n;

			//Assigning outputs
			FIFO_tr.full = FIFOif.full; 
			FIFO_tr.empty = FIFOif.empty; 
			FIFO_tr.almostfull = FIFOif.almostfull; 
			FIFO_tr.almostempty = FIFOif.almostempty;
			FIFO_tr.wr_ack = FIFOif.wr_ack; 
			FIFO_tr.overflow = FIFOif.overflow; 
			FIFO_tr.underflow = FIFOif.underflow; 
			FIFO_tr.data_out = FIFOif.data_out;

			//Assigning Reference Outputs
			FIFO_sb.full_ref = FIFOif.full_ref; 
			FIFO_sb.empty_ref = FIFOif.empty_ref; 
			FIFO_sb.almostfull_ref = FIFOif.almostfull_ref; 
			FIFO_sb.almostempty_ref = FIFOif.almostempty_ref; 
			FIFO_sb.wr_ack_ref = FIFOif.wr_ack_ref; 
			FIFO_sb.overflow_ref = FIFOif.overflow_ref; 
			FIFO_sb.underflow_ref = FIFOif.underflow_ref; 
			FIFO_sb.data_out_ref = FIFOif.data_out_ref;
	
			fork
				begin
					FIFO_cvg.sample_data(FIFO_tr);
				end

				begin
					FIFO_sb.check_data(FIFO_tr);
				end
			join

			if(test_finished) begin
				$display("FIFO's test has been successfuly finished\nerror_count = %0d\ncorrect_count = %0d", error_count, correct_count);
				$stop;
			end
			
		end
	end
endmodule : FIFO_monitor