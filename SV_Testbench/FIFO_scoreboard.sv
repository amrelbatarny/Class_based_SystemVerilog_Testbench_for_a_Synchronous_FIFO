package FIFO_scoreboard_pkg;
	import FIFO_transaction_pkg::*;
	import shared_pkg::*;

	class FIFO_scoreboard;
		FIFO_transaction F_sb_txn = new();

		parameter FIFO_WIDTH = 16;
		parameter FIFO_DEPTH = 8;

		bit [FIFO_WIDTH-1:0] data_out_ref;
		bit wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

		bit [FIFO_WIDTH-1:0] FIFO_model[$]; //golden model for the FIFO
		
		task check_data(FIFO_transaction F_txn);
			F_sb_txn = F_txn;

			if (F_sb_txn.data_out == data_out_ref)
				correct_count++;
			else begin
				$error("Mismatch: data_out (%0d) != data_out_ref (%0d)", F_sb_txn.data_out, data_out_ref);
				error_count++;
			end

			if (F_sb_txn.full == full_ref)
				correct_count++;
			else begin
				$error("Mismatch: full (%0d) != full_ref (%0d)", F_sb_txn.full, full_ref);
				error_count++;
			end

			if (F_sb_txn.empty == empty_ref)
				correct_count++;
			else begin
				$error("Mismatch: empty (%0d) != empty_ref (%0d)", F_sb_txn.empty, empty_ref);
				error_count++;
			end

			if (F_sb_txn.almostfull == almostfull_ref)
				correct_count++;
			else begin
				$error("Mismatch: almostfull (%0d) != almostfull_ref (%0d)", F_sb_txn.almostfull, almostfull_ref);
				error_count++;
			end

			if (F_sb_txn.almostempty == almostempty_ref)
				correct_count++;
			else begin
				$error("Mismatch: almostempty (%0d) != almostempty_ref (%0d)", F_sb_txn.almostempty, almostempty_ref);
				error_count++;
			end

			if (F_sb_txn.overflow == overflow_ref)
				correct_count++;
			else begin
				$error("Mismatch: overflow (%0d) != overflow_ref (%0d)", F_sb_txn.overflow, overflow_ref);
				error_count++;
			end

			if (F_sb_txn.underflow == underflow_ref)
				correct_count++;
			else begin
				$error("Mismatch: underflow (%0d) != underflow_ref (%0d)", F_sb_txn.underflow, underflow_ref);
				error_count++;
			end

			if (F_sb_txn.wr_ack == wr_ack_ref)
				correct_count++;
			else begin
				$error("Mismatch: wr_ack (%0d) != wr_ack_ref (%0d)", F_sb_txn.wr_ack, wr_ack_ref);
				error_count++;
			end
		endtask : check_data

	endclass : FIFO_scoreboard
	
endpackage : FIFO_scoreboard_pkg