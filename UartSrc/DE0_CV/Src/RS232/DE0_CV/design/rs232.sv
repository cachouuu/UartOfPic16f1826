module rs232(
		input logic clk, 
		input logic rst,
		input [13:0] r_LPF_threshold,
		input [1:0] buad_setting,
		input logic rx,
		
		output logic tx,
		output [7:0] data_debug
		//tx_data,
		//tx_end_flag        	
);

	logic [7:0] head;
	logic [7:0] addr;
	logic [7:0] data;
	logic [7:0] r_w;
	logic [7:0] chk_sum;
	logic [7:0] tail;
	logic [7:0] tx_data;
	logic pkg_ready;
	logic tx_ack;
	logic tx_req;
	
	rs232_rx rx0(
		.clk(clk), 
		.rst(rst),
		.rx(rx), 
		.baud_setting(buad_setting), 
		.head(head), 
		.addr(addr), 
		.data(data), 
		.r_w(r_w), 
		.chk_sum(chk_sum), 
		.tail(tail), 
		.pkg_ready(pkg_ready), 
		.tx_data(tx_data), 
		.tx_ack(tx_ack), 
		.tx_req(tx_req)
	);
	
	rs232_tx tx0(
		.clk(clk), 
		.rst(rst), 
		.baud_setting(buad_setting),  
		.tx_data(tx_data),
		.tx_req(tx_req), 
		.tx(tx), 
		.tx_ack(tx_ack)
	);

endmodule
