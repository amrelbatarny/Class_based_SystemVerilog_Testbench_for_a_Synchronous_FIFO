module FIFO_top ();
	bit clk;

	initial begin
		forever #10 clk = ~clk;
	end

	FIFO_if FIFOif(clk);
	FIFO DUT(FIFOif);
	FIFO_ref REF(FIFOif);
	FIFO_tb TEST(FIFOif);
	FIFO_monitor MONITOR(FIFOif);
endmodule : FIFO_top