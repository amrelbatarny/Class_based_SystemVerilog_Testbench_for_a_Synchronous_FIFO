package FIFO_coverage_pkg;
	import FIFO_transaction_pkg::*;
	
	class FIFO_coverage;
		FIFO_transaction F_cvg_txn = new();

		covergroup FIFO_cvg_gp;
			//Labeling coverpoints to be visible in the functional coverage report
			write_cp: 					coverpoint F_cvg_txn.wr_en 		 		{bins wr_en[] 		 		 = {[0:1]};}
			read_cp: 					coverpoint F_cvg_txn.rd_en 		 		{bins rd_en[] 		 		 = {[0:1]};}
			full_cp: 					coverpoint F_cvg_txn.full  		 		{bins full[]  		 		 = {[0:1]};}
			empty_cp: 					coverpoint F_cvg_txn.empty 		 		{bins empty[] 		 		 = {[0:1]};}
			almostfull_cp: 				coverpoint F_cvg_txn.almostfull  		{bins almostfull[]   		 = {[0:1]};}
			almostempty_cp: 			coverpoint F_cvg_txn.almostempty 		{bins almostempty[]  		 = {[0:1]};}
			overflow_cp: 				coverpoint F_cvg_txn.overflow	 		{bins overflow[] 	 		 = {[0:1]};}
			underflow_cp: 				coverpoint F_cvg_txn.underflow	 		{bins underflow[] 	 		 = {[0:1]};}
			wr_ack_cp: 					coverpoint F_cvg_txn.wr_ack 	 		{bins wr_ack[] 	 	 		 = {[0:1]};}
			not_to_empty_cp: 			coverpoint F_cvg_txn.empty				{bins not_to_empty 	 		 = (0=>1);}
	
 				 	
			write_seq_cp:				coverpoint F_cvg_txn.wr_en 		 		{bins write_seq	 	 		 = (0=>1[*8]=>0);}
			read_seq_cp:				coverpoint F_cvg_txn.rd_en 		 		{bins read_seq	 	 		 = (0=>1[*8]=>0);}
			empty_to_not_cp: 			coverpoint F_cvg_txn.empty				{bins empty_to_not 	 		 = (1=>0);}
			full_to_not_cp: 			coverpoint F_cvg_txn.full				{bins full_to_not 	 		 = (1=>0);}
			write_read_simlt_cp:		cross write_cp, read_cp 				{bins write_read_simlt 		 = binsof(write_cp.wr_en[1]) && binsof(read_cp.rd_en[1]); option.cross_auto_bin_max = 0;}
			full_to_empty_cp:			cross not_to_empty_cp, full_to_not_cp 	{bins full_to_empty 		 = binsof(full_to_not_cp) && binsof(not_to_empty_cp); option.cross_auto_bin_max = 0;}
			write_read_simlt_full_cp:	cross write_read_simlt_cp, full_cp 		{bins write_read_simlt_full  = binsof(write_read_simlt_cp) && binsof(full_cp.full[1]); option.cross_auto_bin_max = 0;}
			write_read_simlt_empty_cp:	cross write_read_simlt_cp, empty_cp 	{bins write_read_simlt_empty = binsof(write_read_simlt_cp) && binsof(empty_cp.empty[1]); option.cross_auto_bin_max = 0;}
			write_nor_read_cp:			cross write_cp, read_cp 				{bins write_read_simlt 		 = binsof(write_cp.wr_en[0]) && binsof(read_cp.rd_en[0]); option.cross_auto_bin_max = 0;}

			write_cross_states: cross write_cp, full_cp, empty_cp, almostfull_cp, almostempty_cp, overflow_cp, underflow_cp, wr_ack_cp {
				bins write_full = 		 binsof(write_cp) && binsof(full_cp);
				bins write_empty = 		 binsof(write_cp) && binsof(empty_cp);
				bins write_almostfull =  binsof(write_cp) && binsof(almostfull_cp);
				bins write_almostempty = binsof(write_cp) && binsof(almostempty_cp);
				bins write_overflow = 	 binsof(write_cp) && binsof(overflow_cp);
				bins write_underflow = 	 binsof(write_cp) && binsof(underflow_cp);
				bins write_wr_ack = 	 binsof(write_cp) && binsof(wr_ack_cp);
			}

			read_cross_states: cross read_cp, full_cp, empty_cp, almostfull_cp, almostempty_cp, overflow_cp, underflow_cp, wr_ack_cp {
				bins read_full = 		 binsof(read_cp) && binsof(full_cp);
				bins read_empty = 		 binsof(read_cp) && binsof(empty_cp);
				bins read_almostfull =   binsof(read_cp) && binsof(almostfull_cp);
				bins read_almostempty =  binsof(read_cp) && binsof(almostempty_cp);
				bins read_overflow = 	 binsof(read_cp) && binsof(overflow_cp);
				bins read_underflow = 	 binsof(read_cp) && binsof(underflow_cp);
				bins read_wr_ack = 		 binsof(read_cp) && binsof(wr_ack_cp);
			}
			
		endgroup : FIFO_cvg_gp

		function void sample_data(FIFO_transaction F_txn);
			F_cvg_txn = F_txn;
			FIFO_cvg_gp.sample();
		endfunction : sample_data

		function new();
    		FIFO_cvg_gp = new();
    	endfunction : new
	endclass : FIFO_coverage
endpackage : FIFO_coverage_pkg