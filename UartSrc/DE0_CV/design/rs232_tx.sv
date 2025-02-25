module rs232_tx(
	input logic 			clk, 
	input logic 			rst, 
	input logic		[1:0] 	baud_setting,  
	input logic 	[7:0] 	tx_data,
	input logic 			tx_req,
	
	output logic 			tx, 
	output logic 			tx_ack
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
	
	logic baud_cnt_rst;
	logic baud_cnt_en;
	logic bit_cnt_rst;
	logic bit_cnt_en;
	logic bit_flag;
	logic load_tx_data;
	logic send_tx_data;
	
	logic [15:0] baud_rate;
	logic [15:0] baud_cnt;
	logic [3:0]  bit_cnt;
	logic [9:0]  data;
	
	typedef enum {
		IDLE, 
		CHK_REQ, 
		LOAD, 
		CHK_BIT_CNT, 
		TRANS, 
		COMPLETE
	} tx_state;
	
	tx_state tx_ps, tx_ns;
	
//=======================================================
//  Structural coding
//=======================================================
	
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

//data transfer
always_ff@ (posedge clk) begin
	if(rst)
		data <= 10'h3ff;
	else if(load_tx_data)
		data <= {1'b1, tx_data, 1'b0}; // {end_bit, data, start_bit}
	else if(bit_flag)
		data <= {1'b1, data[9:1]};
end

//output
always_ff@ (posedge clk) begin
	if(rst | tx_ack)
		tx <= 1;
	else if(send_tx_data)	
		tx <= data[0];
end

//fsm
always_ff@ (posedge clk) begin
	if(rst)
		tx_ps <= IDLE;
	else
		tx_ps <= tx_ns;
end

always_comb begin
	baud_cnt_rst 	= 0;
	baud_cnt_en	 	= 0;
	bit_cnt_rst  	= 0;
	bit_cnt_en   	= 0;
	bit_flag	 	= 0;
	load_tx_data 	= 0; 
	send_tx_data 	= 0;
	tx_ack		 	= 0;
	tx_ns			= tx_ps;
	unique case(tx_ps)
		IDLE: begin
			tx_ns = CHK_BIT_CNT;
		end
		CHK_REQ: begin
			if(tx_req)
				tx_ns = LOAD;
		end
		LOAD: begin
			load_tx_data = 1;
			tx_ns			 = CHK_BIT_CNT;
		end
		CHK_BIT_CNT: begin
			baud_cnt_rst = 1;
			send_tx_data = 1;
			if(bit_cnt == 10) tx_ns = COMPLETE;
			else			  tx_ns = TRANS;
		end
		TRANS: begin
			send_tx_data = 1;
			baud_cnt_en  = 1;
			if(baud_cnt>baud_rate*2) begin
				bit_flag   = 1;
				bit_cnt_en = 1;
				tx_ns		   = CHK_BIT_CNT;
			end
		end
		COMPLETE: begin
			bit_cnt_rst = 1;
			tx_ack		= 1;
			tx_ns		= CHK_REQ;
		end
	endcase
end
endmodule