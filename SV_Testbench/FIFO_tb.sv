import shared_pkg::*;
import FIFO_transaction_pkg::*;

module FIFO_tb(FIFO_if.TEST FIFOif);
	FIFO_transaction FIFO_tr = new();

	//Sequence Items
	FIFO_transaction tr_wr = new(5, 95, 5);		//Only_Write
	FIFO_transaction tr_rd = new(5, 5, 95);		//Only_Read
	FIFO_transaction tr_sm = new(5, 90, 90);	//Simultaneous_Read_Write
	FIFO_transaction tr_wf = new(5, 90, 10);	//Write_Full
	FIFO_transaction tr_re = new(5, 10, 90);	//Read_Empty
	FIFO_transaction tr_rs = new(50, 70, 30);	//Reset
	FIFO_transaction tr_sf = new(5, 100, 100);	//Simultaneous_Read_Write_Full


	initial begin
		//Customizing the constraints for each test case
		prepare_items();

		//Initialize the design
		reset();

		//Only_Write
		repeat(500) begin
			randomize_then_assign(tr_wr);
			@(negedge FIFOif.clk);
		end

		//Only_Read
		repeat(500) begin
			randomize_then_assign(tr_rd);
			@(negedge FIFOif.clk);
		end

		//Concurrent_Write_Read
		repeat(100) begin
			repeat(10) begin
				randomize_then_assign(tr_wr);
				@(negedge FIFOif.clk);
			end
			repeat(10) begin
				randomize_then_assign(tr_rd);
				@(negedge FIFOif.clk);
			end
		end

		//Simultaneous_Read_Write
		repeat(500) begin
			randomize_then_assign(tr_sm);
			@(negedge FIFOif.clk);
		end

		//Reset
		repeat(500) begin
			randomize_then_assign(tr_rs);
			@(negedge FIFOif.clk);
		end

		test_finished = 1;
	end

	task reset();
		FIFOif.rst_n = 0;
		@(negedge FIFOif.clk);
		FIFOif.rst_n = 1;
	endtask : reset

	function void randomize_then_assign(FIFO_transaction tr);
		FIFO_tr = tr;
	 	assert(FIFO_tr.randomize());
		//Assigning inputs
		FIFOif.data_in = FIFO_tr.data_in;
		FIFOif.wr_en = FIFO_tr.wr_en;
		FIFOif.rd_en = FIFO_tr.rd_en;
		FIFOif.rst_n = FIFO_tr.rst_n;
	endfunction : randomize_then_assign

	task fill_FIFO();
		FIFOif.rst_n = 1;
		FIFOif.wr_en = 1;
		FIFOif.rd_en = 0;
		repeat(10) begin
			FIFOif.data_in = $random();
			@(negedge FIFOif.clk);
		end
	endtask : fill_FIFO

	task empty_FIFO();
		FIFOif.rst_n = 1;
		FIFOif.wr_en = 0;
		FIFOif.rd_en = 1;
		repeat(10) begin
			FIFOif.data_in = $random();
			@(negedge FIFOif.clk);
		end
	endtask : empty_FIFO

	task prepare_items();
		tr_wr.constraint_mode(0);
		tr_wr.Reset_Constraint.constraint_mode(1);
		tr_wr.General_Constraints.constraint_mode(1);

		tr_rd.constraint_mode(0);
		tr_rd.Reset_Constraint.constraint_mode(1);
		tr_rd.General_Constraints.constraint_mode(1);

		tr_sm.constraint_mode(0);
		tr_sm.Reset_Constraint.constraint_mode(1);
		tr_sm.Simultaneous_Read_Write.constraint_mode(1);

		tr_rs.constraint_mode(0);
		tr_rs.Reset_Constraint.constraint_mode(1);
		tr_rs.General_Constraints.constraint_mode(1);
	endtask : prepare_items
	
endmodule : FIFO_tb