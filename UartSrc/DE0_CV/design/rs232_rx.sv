module rs232_rx(
	input logic 			clk, 
	input logic 			rst, 
	input logic 			rx,  
	input logic 			tx_ack, 
	input logic		[1:0] 	baud_setting,
	
	output logic 			rx_finish,
	output logic 	[7:0] 	rx_data
);

//=======================================================
//  REG/WIRE declarations
//=======================================================	

	logic 			s_signal;
	logic 			d_signal;
	logic 			rx_neg;
	logic 			baud_cnt_rst;
	logic 			bit_cnt_rst;
	logic 			tx_idx_rst;
	logic 			baud_cnt_en;
	logic 			bit_cnt_en;
	logic 			tx_idx_inc;
	logic 			bit_flag;
	logic [15:0] 	baud_rate;
	logic [15:0] 	baud_cnt;
	logic [5:0] 	bit_cnt;
	logic [7:0] 	shift_data;
	

	typedef enum {
		START, 
		RX_START, 
		NUM_BITS,
		RECEIVE, 
		COMPLETE,
		TX_REQ, 
		TX_ACK
	} rx_state;
	
	rx_state rx_ps, rx_ns;
	
//=======================================================
//  Structural coding
//=======================================================
	
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
		shift_data[7:0] <= 8'b00000000;
	else if(bit_flag)
		shift_data[7:0] <= {rx, shift_data[7:1]};
end

//rx_data register
always_ff@ (posedge clk) begin
	if(rst)
		rx_data[7:0] <= 8'b00000000;
	else if(rx_finish)
		rx_data[7:0] <= shift_data;
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
	tx_idx_rst	 = 0;
	baud_cnt_en	 = 0;
	bit_cnt_en	 = 0;
	tx_idx_inc	 = 0;
	bit_flag	 = 0;
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
			if(baud_cnt>baud_rate*2)	rx_ns = RECEIVE;
		end
	end
	RECEIVE: begin
		baud_cnt_rst = 1;
		bit_flag 	 = 1;
		bit_cnt_en   = 1;
		rx_ns		 = NUM_BITS;
	end
	COMPLETE: begin
		bit_cnt_rst		= 1;
		rx_finish	 	= 1;
		rx_ns 			= RX_START;
	end
	
	//TX_REQ: begin
	//	tx_req 	   	= 1;
	//	tx_idx_inc 	= 1;
	//	rx_ns		= TX_ACK;
	//end
	//TX_ACK: begin
	//	if(tx_ack) begin
	//		if(tx_idx==4) rx_ns = RX_START;
	//		else		  rx_ns = TX_REQ;
	//	end
	
	endcase
end
endmodule
