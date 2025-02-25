module top(
	input clk, 
	input rst, 
	output logic [7:0] W_q
);

logic [1:0] ps, ns;
logic [3:0] a;
logic [3:0] b;
logic [3:0] c;
logic [3:0] d;
logic [7:0] x;
logic [7:0] y;
logic [7:0] S;
logic [7:0] cnt;
logic sel_mult_1;
logic [1:0] sel_mult;
logic [3:0] pc_next, pc_q;
logic [1:0] op;
logic rst_pc,load_pc,load_reg,load_w,cntt;
logic [15:0] rom_out; //把ROM的輸出指派給IR

assign pc_next = pc_q + 1;
assign rst_pc = rst;

//pc
always_ff @(posedge clk)
begin
	if (rst_pc)
		pc_q <= #1 0;
	else if (load_pc)
		pc_q <= #1 pc_next;
end
//ROM
	Program_Rom r1(
	.Rom_data_out(rom_out),
	.Rom_addr_in(pc_q)
	);	
always_ff@(posedge clk)
	begin
		if(rst) cnt <=  0;
		else if(cntt) cnt <=  cnt + 1;
	end	
always_ff@(posedge clk)
	begin	
		if(load_reg) a <=  rom_out [3:0];
	end
always_ff@(posedge clk)
	begin	
		if(load_reg) b <=  rom_out [7:4];
	end
always_ff@(posedge clk)
	begin	
		if(load_reg) c <=  rom_out [11:8];
	end
always_ff@(posedge clk)
	begin	
		if(load_reg) d <=  rom_out [15:12];
	end


always_ff@(posedge clk)
	begin
		
		if(load_w) W_q <= #1 S;
	end

always_ff@(posedge clk)
begin
	if(rst) ps <= #1 0;
	else  ps <= #1 ns;
end

always_comb
	begin
		case(sel_mult_1) //Mux邏輯
			1'b0: x = W_q;
			1'b1: x = {4'b0,a};
			default:x = 8'bx;
		endcase
	end
always_comb
	begin
		case(sel_mult)//Mux邏輯
			2'b00: y = {4'b0,b};
			2'b01: y = {4'b0,c};
			2'b10: y = {4'b0,d};
			default: y = 8'bx;
		endcase
	end		
	

	
always_comb //ALU運算
begin
	case(op) 
			2'b00: S = x + y;
			2'b01: S = x - y;
			2'b10: S = x * y;
			2'b11: S = x / y;
	endcase
end

always_comb 
begin
	sel_mult_1 = 0;
	sel_mult = 0;
	load_w = 0;
	load_reg = 0;
	load_pc = 0;
	ns = 0;
	cntt = 0; 
	case(ps) 	//(a + d) * b - c 		(a*b)+(b*c)-(e*4) 	(b*c)-(c*d)+(f/2)
			0: 
			begin
				cntt = 1;
				load_reg = 1;
				load_pc = 1;
				ns = 1;
			end
			1:
			begin
				cntt = 1;
				op = 0;
				sel_mult_1 = 1;
				sel_mult = 2;
				load_w = 1;
				ns = 2;
			end
			2:
			begin
				cntt = 1;
				op = 2;
				sel_mult_1 = 0;
				sel_mult = 0;
				load_w = 1;
				ns = 3;
			end
			3:
			begin
				cntt = 1;
				op = 1;
				sel_mult_1 = 0;
				sel_mult = 1;
				load_w = 1;
				load_reg = 1;
				load_pc = 1;
				ns = 1;
			end
	endcase
end



endmodule