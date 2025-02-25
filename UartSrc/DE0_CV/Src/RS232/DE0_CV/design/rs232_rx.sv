module rs232_rx(
	input logic clk, 
	input logic rst, 
	input logic rx, 
	input [1:0] baud_setting, 
	input logic tx_ack, 
	
	output reg [7:0] head, 
	output reg [7:0] addr, 
	output reg [7:0] data,
	output reg [7:0] r_w,
	output reg [7:0] chk_sum,
	output reg [7:0] tail, 
	output logic pkg_ready, 
	
	output reg [7:0] tx_data,
	output logic tx_req 
);

	logic s_signal;
	logic d_signal;
	logic rx_neg;
	logic baud_cnt_rst;
	logic bit_cnt_rst;
	logic pkg_cnt_rst;
	logic pkg_rst;
	logic chk_sum_rst;
	logic tx_idx_rst;
	logic baud_cnt_en;
	logic bit_cnt_en;
	logic chk_sum_en;
	logic tx_idx_inc;
	logic bit_flag;
	logic rx_finish;
	logic read;
	logic write;
	
	logic [15:0] baud_rate;
	logic [15:0] baud_cnt;
	logic [5:0] bit_cnt;
	logic [2:0] pkg_cnt;
	logic [7:0] rx_data;
	logic [7:0] reg_data;
	logic [7:0] addr1;
	logic [7:0] addr2;
	logic [7:0] data1;
	logic [7:0] data2;
	reg   [7:0] rx_sum;
	logic [2:0] tx_idx;
	
	logic [7:0] reg_file [255:0];
	logic [7:0] tx_data_temp [3:0];

	typedef enum {
		START, 
		RX_START, 
		NUM_BITS,
		WAIT, 
		RECEIVE, 
		COMPLETE,
		CHK_SUM, 
		RW_REG_F, 
		PKG_RDY, 
		PKG_WRONG, 
		TX_REQ, 
		TX_ACK
	} rx_state;
	
	rx_state rx_ps, rx_ns;
	
//negative edge detector
always_ff @(posedge clk) begin
	if(rst) begin
		s_signal <= 1;
		d_signal <= 1;
		rx_neg	 <= 0;
	end
	else begin
		{d_signal, s_signal} <= {s_signal, rx};
		rx_neg <= ~s_signal & d_signal;
	end
end

//shift register
always_ff@ (posedge clk) begin
	if(rst)
		rx_data[7:0] <= 8'b00000000;
	else if(bit_flag)
		rx_data[7:0] <= {rx, rx_data[7:1]};
end
	
//baud_rate calc
always_comb begin
	case(baud_setting)
	2'b00: begin
		baud_rate = 5208;
		baud_rate = baud_rate/2;
	end
	2'b01: begin
		baud_rate = 2604;
		baud_rate = baud_rate/2;
	end
	2'b10: begin
		baud_rate = 1302;
		baud_rate = baud_rate/2;
	end
	default: begin
		baud_rate = 1302;
		baud_rate = baud_rate/2;
	end
	endcase
end

//baud counter
always_ff @(posedge clk) begin
	if(rst | baud_cnt_rst)
		baud_cnt <= 0;
	else if(baud_cnt_en)
		baud_cnt = baud_cnt + 1;
end

//bit counter
always_ff @(posedge clk) begin
	if(rst | bit_cnt_rst)
		bit_cnt <= 0;
	else if(bit_cnt_en)
		bit_cnt <= bit_cnt + 1;
end 

//package counter
always_ff @(posedge clk) begin 
	if(rst | pkg_cnt_rst)
		pkg_cnt <= 0;
	else if(rx_finish)
		pkg_cnt <= pkg_cnt + 1;
end

//package shift register
assign addr = {addr1[3:0], addr2[3:0]};
assign data = {data1[3:0], data2[3:0]};

always_ff@ (posedge clk) begin 
	if(rst | pkg_rst) begin
		head 	<= 0;
		addr1	<= 0;
		addr2	<= 0;
		data1 	<= 0;
		data2 	<= 0;
		r_w	 	<= 0;
		chk_sum <= 0;
		tail 	<= 0;
	end
	else if(rx_finish)
		{head, addr1, addr2, data1, data2, r_w, chk_sum, tail} 
			<= {addr1, addr2, data1, data2, r_w, chk_sum, tail, rx_data};
end

//check sum counter
always_ff@ (posedge clk) begin
	if(rst | pkg_ready | chk_sum_rst)
		rx_sum <= 0;
	else if(chk_sum_en)
		rx_sum <= rx_sum + rx_data;
end

//register file
always_ff@ (posedge clk) begin
	if(write) 
		reg_file[addr] <= data;
end

assign reg_data = reg_file[addr];

//output reg_file
assign tx_data_temp[0] = 8'h02;
assign tx_data_temp[1] = {4'h3, reg_data[7:4]};
assign tx_data_temp[2] = {4'h3, reg_data[3:0]};
assign tx_data_temp[3] = 8'h03;

always_ff@ (posedge clk) begin
	if(rst | tx_idx_rst) begin
		tx_data <= 8'h02;
		tx_idx	<= 0;
	end
	else if(tx_idx_inc) begin
		tx_data <= tx_data_temp[tx_idx];
		tx_idx  <= tx_idx + 1;
	end
end

//fsm
always_ff @(posedge clk) begin
	if(rst)
		rx_ps <= START;
	else
		rx_ps <= rx_ns;
end

always_comb begin
	rx_finish	 = 0;
	baud_cnt_rst = 0;
	bit_cnt_rst	 = 0;
	pkg_cnt_rst  = 0;
	pkg_rst		 = 0;
	chk_sum_rst  = 0;
	tx_idx_rst	 = 0;
	baud_cnt_en	 = 0;
	bit_cnt_en	 = 0;
	tx_idx_inc	 = 0;
	bit_flag	 = 0;
	pkg_ready	 = 0;
	chk_sum_en	 = 0;
	read		 = 0;
	write		 = 0;
	tx_req		 = 0;
	rx_ns		 = rx_ps;
	case(rx_ps)
	START: begin
		rx_ns = RX_START;
	end
	RX_START: begin
		if(rx_neg) begin
			rx_ns = NUM_BITS;
		end
	end
	NUM_BITS: begin
		if(bit_cnt>7)
			rx_ns = COMPLETE;
		else if(bit_cnt == 0) begin
			baud_cnt_en = 1;
			if(baud_cnt>baud_rate*3)
				rx_ns = RECEIVE;
		end
		else begin
			baud_cnt_en = 1;
			if(baud_cnt>baud_rate*2)
				rx_ns = RECEIVE;
		end
	end
	RECEIVE: begin
		baud_cnt_rst = 1;
		bit_flag 	 = 1;
		bit_cnt_en   = 1;
		rx_ns		 = NUM_BITS;
	end
	COMPLETE: begin
		bit_cnt_rst  = 1;
		rx_finish	 = 1;
		if(pkg_cnt<6) 
			chk_sum_en = 1;
		if(pkg_cnt==7) 		rx_ns = CHK_SUM;
		else if(pkg_cnt<7) 	rx_ns = RX_START;
	end
	CHK_SUM: begin
		if(rx_sum == chk_sum) rx_ns	= PKG_RDY;
		else 				  rx_ns = PKG_WRONG;
	end
	RW_REG_F: begin
		tx_idx_rst = 1;
		if(r_w==8'h00) begin
			read  = 1;
			rx_ns	  = TX_REQ;
		end
		else if(r_w==8'h01) begin
			write = 1;
			rx_ns = RX_START;
		end
	end
	PKG_RDY: begin
		pkg_cnt_rst = 1;
		pkg_ready 	= 1;
		rx_ns		= RW_REG_F;
	end
	PKG_WRONG: begin
		pkg_cnt_rst = 1;
		pkg_rst 	= 1;
		chk_sum_rst = 1;
		rx_ns		= RX_START;
	end
	TX_REQ: begin
		tx_req 	   = 1;
		tx_idx_inc = 1;
		rx_ns		   = TX_ACK;
	end
	TX_ACK: begin
		if(tx_ack) begin
			if(tx_idx==4) rx_ns = RX_START;
			else		  rx_ns = TX_REQ;
		end
	end
	endcase
end

endmodule
