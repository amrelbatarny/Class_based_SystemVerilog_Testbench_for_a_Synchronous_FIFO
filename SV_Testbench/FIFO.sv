////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT FIFOif);
 
localparam max_fifo_addr = $clog2(FIFOif.FIFO_DEPTH);

reg [FIFOif.FIFO_WIDTH-1:0] mem [FIFOif.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr+1:0] count;										//modified_code(1)		/*to allow count to reach FIFO_DEPTH*/

always @(posedge FIFOif.clk or negedge FIFOif.rst_n) begin
	if (!FIFOif.rst_n) begin
		wr_ptr <= 0;
		FIFOif.overflow <= 0;										//added_code (1)		/*overflow must asynchronously be resetted (sequential)*/
	end
	else if (FIFOif.wr_en && count < FIFOif.FIFO_DEPTH) begin 				
		mem[wr_ptr] <= FIFOif.data_in;
		FIFOif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		FIFOif.overflow <= 0;										//added_code (2)		/*overflow should be deasserted in the case of writing*/
	end
	else begin 
		FIFOif.wr_ack <= 0; 
		if (FIFOif.full & FIFOif.wr_en)
			FIFOif.overflow <= 1;
		else
			FIFOif.overflow <= 0;
	end
end

always @(posedge FIFOif.clk or negedge FIFOif.rst_n) begin
	if (!FIFOif.rst_n) begin
		FIFOif.data_out <= 0;										//added_code (3)		/*data_out must asynchronously be resetted (sequential)*/								
		rd_ptr <= 0;
		FIFOif.underflow <= 0;										//added_code (4)		/*underflow must asynchronously be resetted (sequential)*/
	end
	else if (FIFOif.rd_en && count != 0) begin
		FIFOif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		FIFOif.underflow <= 0;										//added_code (5)		/*underflow should be deasserted in the case of reading*/
	end
	else begin 
		if (FIFOif.empty & FIFOif.rd_en)							//added_code (6) begin 	/*added the sequential implementation of underflow*/
			FIFOif.underflow <= 1;									//******************//
		else														//******************//
			FIFOif.underflow <= 0;									//******************//
	end 															//added_code (6) end
end

always @(posedge FIFOif.clk or negedge FIFOif.rst_n) begin
	if (!FIFOif.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({FIFOif.wr_en, FIFOif.rd_en} == 2'b10) && !FIFOif.full) 
			count <= count + 1;
		else if ( ({FIFOif.wr_en, FIFOif.rd_en} == 2'b01) && !FIFOif.empty)
			count <= count - 1;
		else if ({FIFOif.wr_en, FIFOif.rd_en} == 2'b11) begin 		//added_code (7) begin 	/*added the part that handles simultaneous read-write*/
			case ({FIFOif.full, FIFOif.empty})						//******************//
				2'b01: count <= count + 1;							//******************//		
				2'b10: count <= count - 1;							//******************//
			endcase 												//******************//
		end 														//added_code (7) end
	end
end

assign FIFOif.full = (count == FIFOif.FIFO_DEPTH)? 1 : 0;
assign FIFOif.empty = (count == 0)? 1 : 0;
//assign FIFOif.underflow = (FIFOif.empty && FIFOif.rd_en)? 1 : 0; 	//removed_code			/*underflow is sequential and not combinational*/
assign FIFOif.almostfull = (count == FIFOif.FIFO_DEPTH-1)? 1 : 0; 	//modified_code (2)		/*FIFO is almostfull when count reaches FIFO_DEPTH-1 not FIFO_DEPTH-2 as 0 is not included*/
assign FIFOif.almostempty = (count == 1)? 1 : 0;

`ifdef SIM

	//Assertions
	
	//Assertions to the combinational flags
	always_comb begin
		if(count == FIFOif.FIFO_DEPTH)
			assert_full:  assert final (FIFOif.full == 1) else $error("Mismatch: full_tb (%0d) != full_ref (1)", FIFOif.full);
	
		if(count == 0)
			assert_empty:  assert final (FIFOif.empty == 1) else $error("Mismatch: empty_tb (%0d) != empty_ref (1)", FIFOif.empty);
	
		if(count == FIFOif.FIFO_DEPTH-1)
			assert_almostfull:  assert final (FIFOif.almostfull == 1) else $error("Mismatch: almostfull_tb (%0d) != almostfull_ref (1)", FIFOif.almostfull);
	
		if(count == 1)
			assert_almostempty:  assert final (FIFOif.almostempty == 1) else $error("Mismatch: almostempty_tb (%0d) != almostempty_ref (1)", FIFOif.almostempty);
	end
	
	//Assertions to the sequential flags
	assert_overflow: assert property (@(posedge FIFOif.clk) disable iff (!FIFOif.rst_n) (FIFOif.wr_en && FIFOif.full) |=> (FIFOif.overflow == 1));
	assert_underflow: assert property (@(posedge FIFOif.clk) disable iff (!FIFOif.rst_n) (FIFOif.rd_en && FIFOif.empty) |=> (FIFOif.underflow == 1));
	assert_wr_ack: assert property (@(posedge FIFOif.clk) disable iff (!FIFOif.rst_n) (FIFOif.wr_en && !FIFOif.full) |=> (FIFOif.wr_ack == 1));
	
	property count_plus;
		@(posedge FIFOif.clk)
		disable iff (!FIFOif.rst_n)
		(FIFOif.wr_en && !FIFOif.full && !FIFOif.rd_en) || (FIFOif.wr_en && !FIFOif.full && FIFOif.rd_en && FIFOif.empty) |=> (count == $past(count) + 1);
	endproperty
	
	property count_minus;
		@(posedge FIFOif.clk)
		disable iff (!FIFOif.rst_n)
		(FIFOif.rd_en && !FIFOif.empty && !FIFOif.wr_en) || (FIFOif.rd_en && !FIFOif.empty && FIFOif.wr_en && FIFOif.full) |=> (count == $past(count) - 1);
	endproperty
	
	property wr_ptr_plus;
		@(posedge FIFOif.clk)
		disable iff (!FIFOif.rst_n)
		(FIFOif.wr_en && !FIFOif.full) |=> (wr_ptr == $past(wr_ptr) + 1) || (wr_ptr == 0);
	endproperty
	
	property rd_ptr_plus;
		@(posedge FIFOif.clk)
		disable iff (!FIFOif.rst_n)
		(FIFOif.rd_en && !FIFOif.empty) |=> (rd_ptr == $past(rd_ptr) + 1) || (rd_ptr == 0);
	endproperty
	
	//Assertions to the counters
	assert_count_incr: assert property (count_plus);
	assert_count_decr: assert property (count_minus);
	assert_wr_ptr_incr: assert property (wr_ptr_plus);
	assert_rd_ptr_incr: assert property (rd_ptr_plus);
	
	always_comb begin
		if(~FIFOif.rst_n) begin
			assert_count_rst: assert final (count == 0);
			assert_wr_ptr_rst: assert final (wr_ptr == 0);
			assert_rd_ptr_rst: assert final (rd_ptr == 0);
		end
	end

`endif
endmodule