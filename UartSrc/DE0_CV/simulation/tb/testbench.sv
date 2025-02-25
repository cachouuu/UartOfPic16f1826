`timescale 1ns/100ps
module testbench;
	
	logic			clk, rst;
	logic 	[13:0] 	r_LPF_threshold;
	logic	[1:0]	baud_setting;  			//0:9600 1:19200 2:38400
	logic			rx, tx_flag; 	
	logic 			rx_end_flag;	
	logic 			tx_end_flag; 	
	logic 	[7:0] 	send_data;
	logic 	[7:0]	rx_data;
	logic 	[7:0]	tx_data;
	logic	[7:0] 	W_q;
	logic 	[7:0]   port_b_out;
	logic			tx_req;
	
	integer	i;
	integer	j;
	
	//rx signal
	logic 	[7:0] 	send_package_w0 [0:1] = {8'h3C, 8'h30};
	logic 	[7:0] 	send_package_w1 [0:1] = {8'h1E, 8'h18};
	logic 	[7:0] 	send_package_w2 [0:1] = {8'h04, 8'h02};
	logic 	[7:0] 	send_package_w3 [0:1] = {8'h12, 8'h0B};
	logic 	[7:0] 	send_package_w4 [0:1] = {8'hC8, 8'h32};
	
	
	//LPF
	assign r_LPF_threshold	= 14'd200;
	parameter BAUD_CNT_MAX_9600  = 5208	;  // = 50000000 / 9600
	parameter BAUD_CNT_MAX_19200 = 2604	;  // = 50000000 / 19200
	parameter BAUD_CNT_MAX_38400 = 1302	;  // = 50000000 / 38400 
	

	//module
	rs232 	rs232_1(
				.clk(clk),                          
				.rst(rst), 
				.rx	(rx),      
				.baud_setting(baud_setting),     
				.r_LPF_threshold(r_LPF_threshold),
				.tx_data(tx_data), 
				.tx_req(tx_req),
				
				.tx	(tx),
				.rx_end_flag(rx_end_flag),
				.rx_data(rx_data)
			); 
			
	cpu 	cpu1(
				.clk(clk),
				.rst(rst),
				.rx_end_flag(rx_end_flag), 
				.rx_data(rx_data),
				.ir(), 
				.W_q(W_q), 
				.port_b_out(port_b_out),
				.tx_data(tx_data), 
				.tx_req(tx_req)
			);
					
	//function
	task reset_task ; begin
			#(10); rst = 1;
			#(40); rst = 0;
			end 
	endtask
	
	
	task tx_task; begin  //寫
			#(1302 * 20)	rx = 1'b0;  //start bit
			
			for (i=0; i<8; i=i+1) 
				#(1302 * 20)	rx = send_data[i];  //start bit
			
			#(1302 * 20) 	rx = 1'b1;  //end bit
			end
	endtask
	
	//time control
	always	#10 clk = ~clk;
	
	initial begin
		rx 				= 1'b1; 
		clk 			= 0;
		baud_setting 	= 2'b10; 
		tx_flag 		= 0; 
		rst 			= 1;
		
		#1000 rst = 0;
		
		//------------write data---------------
		
		for (j=0; j<2; j=j+1) begin 
				send_data = send_package_w0[j];  //start bit
				tx_task;
				#200;
		end
		
		//-----------interval time------------
		
		send_data = 8'bx;
		#(1302 * 20 * 27)
		
		//------------write data---------------
		
		
		for (j=0; j<2; j=j+1) begin 
				send_data = send_package_w1[j];  //start bit
				tx_task;
				#200;
		end
		
		//-----------interval time------------
		
		send_data = 8'bx;
		#(1302 * 20 * 27)
		
		//------------write data---------------
		
		
		for (j=0; j<2; j=j+1) begin 
				send_data = send_package_w2[j];  //start bit
				tx_task;
				#200;
		end
		
		//-----------interval time------------
		
		send_data = 8'bx;
		#(1302 * 20 * 27)
		
		//------------write data---------------
		
		
		for (j=0; j<2; j=j+1) begin 
				send_data = send_package_w3[j];  //start bit
				tx_task;
				#200;
		end
		
		//-----------interval time------------
		
		send_data = 8'bx;
		#(1302 * 20 * 27)
		
		//------------write data---------------
		
		
		for (j=0; j<2; j=j+1) begin 
				send_data = send_package_w4[j];  //start bit
				tx_task;
				#200;
		end
		
		#(1302 * 40 * 25) $stop;
	
	end
	
	
endmodule

