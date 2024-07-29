package FIFO_transaction_pkg;

	class FIFO_transaction;
		parameter FIFO_WIDTH = 16;
		parameter FIFO_DEPTH = 8;
		
		rand bit [FIFO_WIDTH-1:0] data_in;
		rand bit rst_n, wr_en, rd_en;
		rand bit [FIFO_WIDTH-1:0] data_out;
		rand bit wr_ack, overflow;
		rand bit full, empty, almostfull, almostempty, underflow;

		int WR_EN_ON_DIST, RD_EN_ON_DIST, RST_ON_DIST;

		constraint Reset_Constraint {
			rst_n dist {1:=(100-RST_ON_DIST), 0:=RST_ON_DIST};
		}

		constraint General_Constraints {
			wr_en dist {1:=WR_EN_ON_DIST, 0:=(100-WR_EN_ON_DIST)};
			rd_en dist {1:=RD_EN_ON_DIST, 0:=(100-RD_EN_ON_DIST)};
			(full == 1)  -> wr_en dist {1:=90, 0:=10};
			(empty == 1) -> rd_en dist {1:=90, 0:=10};
			unique {data_in};
		}

		constraint Simultaneous_Read_Write {
			(wr_en && rd_en) dist {1:=90, 0:=10};
			(full == 1)  -> wr_en dist {1:=90, 0:=10};
			(empty == 1) -> rd_en dist {1:=90, 0:=10};
			unique {data_in};
		}

		function new(int RST_ON_DIST = 5, int WR_EN_ON_DIST = 70, int RD_EN_ON_DIST = 30);
			this.RST_ON_DIST	= RST_ON_DIST;
			this.WR_EN_ON_DIST 	= WR_EN_ON_DIST;
			this.RD_EN_ON_DIST 	= RD_EN_ON_DIST;
		endfunction : new
	endclass : FIFO_transaction
	
endpackage : FIFO_transaction_pkg