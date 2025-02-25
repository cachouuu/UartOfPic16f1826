module testbench;

	logic clk, rst;
	logic [13:0] IR;
	logic [7:0] W_q;
	logic [7:0]	port_b_out;
	
	cpu top1(
		.clk(clk), 
		.rst(rst),
		.IR(IR),
		.W_q(W_q),
		.port_b_out(port_b_out)
	);
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 0; rst = 1;
	#10 rst = 0;
	#1100000 $stop;
	end
	
endmodule
