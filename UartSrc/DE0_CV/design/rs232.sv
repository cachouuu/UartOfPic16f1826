module rs232(
	input logic 		 	clk, 
	input logic 			rst,
	input logic 			rx,
	input logic		[1:0] 	baud_setting,
	input logic		[13:0] 	r_LPF_threshold,
	input logic		[7:0] 	tx_data, 
	input logic				tx_req, 
	
	output logic 			tx,
	output logic 			rx_end_flag,
	output logic	[7:0]	rx_data      	
);

//=======================================================
//  REG/WIRE declarations
//=======================================================	
	
	
//=======================================================
//  SPI RX
//=======================================================
	
	rs232_rx rx0(
		
		//input
		.clk(clk), 
		.rst(rst), 
		.rx(rx),   
		.baud_setting(baud_setting),
		.tx_ack(tx_ack),
		
		//output
		.rx_finish(rx_end_flag),
		.rx_data(rx_data)
	);
		
		
//=======================================================
//  SPI TX
//=======================================================
	
	rs232_tx tx0(
		
		//input
		.clk(clk), 
		.rst(rst), 
		.baud_setting(baud_setting),  
		.tx_data(tx_data),
		.tx_req(tx_req),
		
		//output
		.tx(tx), 
		.tx_ack()
	);
	
//=======================================================
//  FIFO
//=======================================================

	//always_ff@ (negedge clk) begin
	//	if(rst) begin
	//		wr_req_neg	  	<= 0;
	//		rd_req_neg		<= 0;
	//		rx_data_neg 	<= 0;
	//	end
	//	else begin
	//		wr_req_neg	   	<= wr_req;
	//		rd_req_neg		<= rd_req;
	//		rx_data_neg 	<= rx_data;
	//	end
	//end
	
	//fifo fifo1(
	//	
	//	//input
	//	.clock(clk), 
	//	.sclr(rst),
	//	.aclr(), 
	//	.data(rx_data_neg), 
	//	.rdreq(rd_req_neg),  
	//	.wrreq(wr_req_neg),
	//	
	//	//output
	//	.empty(empty), 
	//	.full(full), 
	//	.q(fifo_data), 
	//	.usedw(usedw)
	//	);

endmodule
