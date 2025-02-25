module cpu(
	
	//----------------input------------------
	input logic 		clk			,
	input logic 		rst			,
	input logic			rx_end_flag	, 
	input logic	 [7:0]	rx_data		, 
	
	//----------------output------------------
	output logic [13:0] ir			,
	output logic [7:0]	W_q			,
	output logic [7:0]	port_b_out	, 
	output logic [7:0]  tx_data		, 
	output logic		tx_req
	
	);
	
//=======================================================
//  REG/WIRE declarations
//=======================================================
	
	//instruction set
	logic ADDWF, ANDWF, CLRF, CLRW, COMF, DECF, GOTO, MOVLW, ADDLW, IORLW, ANDLW, SUBLW, XORLW			;
	logic INCF, IORWF, MOVF, MOVWF, SUBWF, XORWF														;
	logic ASRF, LSLF, LSRF, RLF, RRF, SWAPF																; 
	logic BCF, BSF, BTFSC, BTFSS, DECFSZ, INCFSZ														;
	logic BRA, BRW, NOP																					;
	logic CALL, RETURN																					;

	//datapath		
	logic [10:0] 	pc_next, pc_q, mar_q, stack_q														;
	logic 			load_pc, load_mar, load_ir, rst_pc, rst_ir, rst_mar, load_w, load_port_b			;
	logic			load_tx, load_rx																	;
	logic [7:0] 	alu_q, ram_out, mux1_out, data_bus, ram_mux, bcf_mux, bsf_mux						;                         
	logic 			ram_en, sel_bus																		;
	logic 			push, pop																			;
	logic [2:0] 	sel_pc																				;
	logic [1:0] 	sel_ram_mux, sel_alu																;    
	logic [2:0] 	sel_bit																				;   
	logic [13:0] 	rom_out																				;
	logic [4:0] 	op																					;
	logic [7:0]		RCREG, TXREG																		;
	logic [7:0] 	PIR1																				;
	
	assign d 					= ir[7]																	;	
	assign w_change 			= {3'b0, W_q}															;	//W_q>0: sign_bit<=0
	assign k_change 			= {ir[8], ir[8], ir[8:0]}												; 	//MSB SignExtension
	assign btfsc_skip_bit 		= (ram_out[ir[9:7]] == 0)												;	//conditional jump
	assign btfss_skip_bit 		= (ram_out[ir[9:7]] == 1)  | (PIR1[5]==1)								;	//RCREG polling jump
	assign btfsc_btfss_skip_bit = (BTFSC & btfsc_skip_bit) | (BTFSS & btfss_skip_bit)					;	
	assign tx_req				= load_tx																;
	
	//spr addr
	assign addr_port_b 			= (ir[6:0] == 7'h0d)													; 	//portB port
	assign addr_rc_reg			= (ir[6:0] == 7'h19)													;	//RCREG port
	assign addr_tx_reg			= (ir[6:0] == 7'h1A)													;	//TXREG port
	assign addr_pir1			= (ir[6:0] == 7'h11)													;	//PIR1[5]=RCIF
	assign RCREG				= rx_data																;
	assign tx_data				= TXREG																	;
	
	//fsm
	logic [2:0] pic_ps, pic_ns;
	
//=======================================================
//  Structural coding
//=======================================================	
	
	//program counter
	always_ff@ (posedge clk) begin
		if(rst)
			pc_q <= 0;
		else if (load_pc)
			pc_q <= pc_next;
	end
	
	//memory address register
	always_ff@ (posedge clk) begin
		if(rst) 			mar_q <= 0;
		else if (load_mar)	mar_q <= pc_q;		
	end
	
	//W reg
	always_ff@ (posedge clk) begin
		if(rst)		W_q <= 8'b0;
		if(load_w) 	W_q <= alu_q;
	end
	
	//interrupt control register
	always_ff@ (posedge clk) begin
		if(rst)					PIR1	<= 8'b0;
		else if(rx_end_flag)	PIR1[5] <= 1'b1;
		else if(load_rx)		PIR1[5] <= 1'b0;
	end
	
	//port_b reg
	always_ff@ (posedge clk) begin
		if(rst) 			 port_b_out <= 0;
		else if(load_port_b) port_b_out <= data_bus;
	end
	
	//TXREG
	always_ff@ (posedge clk) begin
		if(rst)				TXREG <= 0;
		else if(load_tx) 	TXREG <= data_bus;
	end
	
	//Program_Rom
	Program_Rom rom1(
		.Rom_data_out	(rom_out		),
		.Rom_addr_in	(mar_q			)
	);
	
	//single_port_ram_128x8
	single_port_ram_128x8 ram1(
		.data			(data_bus		),
		.addr			(ir[6:0]		),
		.ram_en			(ram_en			),
		.clk			(clk			),
		.q				(ram_out		)
	);
	
	//Stack
	Stack stack1(
		.stack_out		(stack_q		),
		.stack_in		(pc_q			),
		.push			(push			),
		.pop			(pop			),
		.reset			(rst			),
		.clk			(clk			)
	);
	
	//ir reg
	always_ff@ (posedge clk) begin
		if (rst)			ir <= 0;
		else if (load_ir)	ir <= rom_out;
	end
	
	//ALU
	assign alu_zero = (alu_q == 0);
	always_comb begin
		case(op)
			0		: alu_q = mux1_out[7:0] + W_q				;	//accumulate
			1		: alu_q = mux1_out[7:0] - W_q				;
			2		: alu_q = mux1_out[7:0] & W_q				;
			3		: alu_q = mux1_out[7:0] | W_q				;
			4		: alu_q = mux1_out[7:0] ^ W_q				;
			5		: alu_q = mux1_out[7:0]						;
			6		: alu_q = mux1_out[7:0] + 1					;
			7		: alu_q = mux1_out[7:0] - 1					;
			8		: alu_q = 0									;
			9		: alu_q = ~mux1_out[7:0]					;	
			10		: alu_q = W_q								;
			11		: alu_q = {mux1_out[7], mux1_out[7:1]}		;	//left shift arithmatic
			12		: alu_q = {mux1_out[6:0], 1'b0}				;	//right shift
			13		: alu_q = {1'b0, mux1_out[7:1]}				;	//left shift logic
			14		: alu_q = {mux1_out[6:0], mux1_out[7]}		;	//left rotate
			15		: alu_q = {mux1_out[0], mux1_out[7:1]}		;	//right rotate
			16		: alu_q = {mux1_out[3:0], mux1_out[7:4]}	;	//high low transfer
			default	: alu_q = mux1_out[7:0] + W_q				;
		endcase
	end
	
	//mux_alu
	always_comb begin
		case(sel_alu)
			0:mux1_out = ir[7:0];
			1:mux1_out = ram_mux[7:0];
			2:mux1_out = RCREG;
		endcase
	end
	
	//mux_pc
	always_comb begin
		case(sel_pc)
			0:pc_next = pc_q + 1;
			1:pc_next = ir[10:0];
			2:pc_next = stack_q;
			3:pc_next = pc_q + k_change;
			4:pc_next = pc_q + w_change;
		endcase
	end
	
	//mux before port_b_out
	always_comb begin
		case(sel_bus)
			0:data_bus = alu_q;
			1:data_bus = W_q;
		endcase
	end
	
	//ram_out to ram_mux
	always_comb begin
		case(sel_ram_mux)
			0:ram_mux = ram_out;
			1:ram_mux = bcf_mux;
			2:ram_mux = bsf_mux;
		endcase
	end
	
	//選擇ram_out[7:0]其中一根腳
	assign sel_bit = ir[9:7];
	
	//ram_out其中一根腳要被強制清為0，使用AND邏輯set
	always_comb begin
		case(sel_bit)
			0:bcf_mux = ram_out & 8'b1111_1110;
			1:bcf_mux = ram_out & 8'b1111_1101;
			2:bcf_mux = ram_out & 8'b1111_1011;
			3:bcf_mux = ram_out & 8'b1111_0111;
			4:bcf_mux = ram_out & 8'b1110_1111;
			5:bcf_mux = ram_out & 8'b1101_1111;
			6:bcf_mux = ram_out & 8'b1011_1111;
			7:bcf_mux = ram_out & 8'b0111_1111;
		endcase
	end
	
	//ram_out其中一根腳要被強制設為1，使用OR邏輯mask
	always_comb begin
		case(sel_bit)
			0:bsf_mux = ram_out | 8'b0000_0001;
			1:bsf_mux = ram_out | 8'b0000_0010;
			2:bsf_mux = ram_out | 8'b0000_0100;
			3:bsf_mux = ram_out | 8'b0000_1000;
			4:bsf_mux = ram_out | 8'b0001_0000;
			5:bsf_mux = ram_out | 8'b0010_0000;
			6:bsf_mux = ram_out | 8'b0100_0000;
			7:bsf_mux = ram_out | 8'b1000_0000;
		endcase
	end
	
	//instruction decoder
	assign MOVLW 	= (	ir[13:8] 	== 6'h30					);
	assign ADDLW 	= (	ir[13:8] 	== 6'h3e					);
	assign IORLW 	= (	ir[13:8] 	== 6'h38					);
	assign ANDLW 	= (	ir[13:8] 	== 6'h39					);
	assign SUBLW 	= (	ir[13:8] 	== 6'h3c					);
	assign XORLW 	= (	ir[13:8] 	== 6'h3a					);
	assign ADDWF 	= (	ir[13:8] 	== 6'h07					);
	assign ANDWF 	= (	ir[13:8] 	== 6'h05					);
	assign CLRF 	= (	ir[13:7] 	== {6'h01, 1'h1}			);
	assign CLRW 	= (	ir[13:2] 	== {6'h01, 6'h0}			);
	assign COMF 	= (	ir[13:8] 	== 6'h09					);
	assign DECF 	= (	ir[13:8] 	== 6'h03					);
	assign GOTO 	= (	ir[13:11] 	== {2'h2, 1'h1}				);		

	assign INCF 	= (	ir[13:8] 	== 6'h0a					);
	assign IORWF 	= (	ir[13:8] 	== 6'h04					);
	assign MOVF 	= (	ir[13:8] 	== 6'h08					);
	assign MOVWF 	= (	ir[13:7] 	== {6'h0, 1'h1}				);
	assign SUBWF 	= (	ir[13:8] 	== 6'h02					);
	assign XORWF 	= (	ir[13:8] 	== 6'h06					);

	assign BCF 		= (	ir[13:10] 	== 4'b0100					);
	assign BSF 		= (	ir[13:10] 	== 4'b0101					);
	assign BTFSC 	= (	ir[13:10] 	== 4'b0110					);
	assign BTFSS 	= (	ir[13:10] 	== 4'b0111					);
	assign DECFSZ 	= (	ir[13:8] 	== 6'b001011				);
	assign INCFSZ 	= (	ir[13:8] 	== 6'b001111				);
	
	assign ASRF 	= (	ir[13:8] 	== 6'b110111				);
	assign LSLF 	= (	ir[13:8] 	== 6'b110101				);
	assign LSRF 	= (	ir[13:8] 	== 6'b110110				);
	assign RLF 		= (	ir[13:8] 	== 6'b001101				);
	assign RRF 		= (	ir[13:8] 	== 6'b001100				);
	assign SWAPF 	= (	ir[13:8] 	== 6'b001110				);

	assign CALL 	= (	ir[13:11] 	== 3'b100					);
	assign RETURN 	= (	ir 			== {10'b0, 1'b1, 3'b0}		);
	assign BRA 		= (	ir[13:9] 	== 5'b11001					); 
	assign BRW 		= (	ir 			== {10'b0, 4'b1011}			);
	assign NOP 		= (	ir 			== 14'b0					);
	
	//fsm
	always_ff@ (posedge clk) begin
		if (rst) 	pic_ps <= 0;
		else		pic_ps <= pic_ns;
	end
	
	//controller
	always_comb begin
		op 				= 0;
		sel_alu 		= 0;
		sel_pc 			= 0;
		sel_bus 		= 0;
		sel_ram_mux 	= 0;
		ram_en 			= 0;
		load_pc 		= 0;
		load_mar 		= 0;  
		load_ir 		= 0;
		load_w 			= 0;
		load_rx			= 0;
		load_tx			= 0;
		load_port_b 	= 0;
		pop 			= 0;
		push 			= 0;
		pic_ns 			= pic_ps;
		case(pic_ps)
		0:
		begin
		pic_ns = 1;
		end
		1:
		begin
		load_mar = 1;  	//MAR = PC
		pic_ns = 2;
		end
		2:
		begin
		load_pc = 1; 	//PC = PC + 1
		pic_ns = 3;
		end
		3:
		begin
		load_ir = 1;	//ir = ROM[MAR]
		pic_ns = 4;
		end
		4:
		begin
		if (ADDWF)
		begin
			op = 0;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end
		else if (ANDWF)
		begin
			op = 2;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end
		else if (CLRW)
		begin
			op = 8;
			load_w = 1;
		end
		else if (CLRF)
		begin
			op = 8;
			ram_en = 1;
		end
		else if (COMF)
		begin
			op = 9;
			sel_alu = 1;
			ram_en = 1;
		end
		else if (DECF)
		begin
			op = 7;
			sel_alu = 1;
			ram_en = 1;
		end
		else if (GOTO)
		begin
			sel_pc = 1;
			load_pc = 1;
		end
		else if (MOVLW)	
		begin               
			op = 5;         
			sel_alu = 0;    
			load_w = 1;     
		end                 
		else if (ADDLW)         
		begin
			op = 0;
			sel_alu = 0;
			load_w = 1;
		end
		else if (IORLW)
		begin
			op = 3;
			sel_alu = 0;
			load_w = 1;
		end
		else if (ANDLW)
		begin
			op = 2;
			sel_alu = 0;
			load_w = 1;
		end
		else if (SUBLW)
		begin
			op = 1;
			sel_alu = 0;
			load_w = 1;
		end
		else if (XORLW)
		begin
			op = 4;
			sel_alu = 0;
			load_w = 1;
		end
		else if (INCF)
		begin
			op = 6;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end
		else if (IORWF)
		begin
			op = 3;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end
		else if (MOVF)
		begin
			op = 5;
			if(addr_rc_reg) begin
				sel_alu = 2;
				load_rx = 1;
				load_w  = 1;
			end
			else begin
				sel_alu = 1;
				if(d)	ram_en = 1;
				else	load_w = 1;
			end
		end
		else if (MOVWF)
		begin
			op = 10;
			sel_bus = 1;
			if(addr_port_b)			load_port_b = 1;	//portB<=W_q
			else if(addr_tx_reg)	load_tx		= 1;	//TXREG<=W_q
			else					ram_en 		= 1;	//ram[ir[6:0]]<=W_q
		end
		else if (SUBWF)
		begin
			op = 1;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end
		else if (XORWF)
		begin
			op = 4;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end
		else if (BCF)
		begin
			op = 5;
			sel_ram_mux = 1;
			sel_alu = 1;
			ram_en = 1;
			sel_bus = 0;
		end
		else if (BSF)
		begin
			op = 5;
			sel_ram_mux = 2;
			sel_alu = 1;
			ram_en = 1;
			sel_bus = 0;
		end
		else if (BTFSC)
		begin
			if(btfsc_btfss_skip_bit)
			begin
				load_pc = 1;
				sel_pc = 0;
			end
		end
		else if (BTFSS)
		begin
			if(btfsc_btfss_skip_bit)
			begin
				load_pc = 1;
				sel_pc  = 0;
			end
		end
		else if(DECFSZ)
		begin
			if(d)
			begin
				sel_alu = 1;
				op = 7;
				ram_en = 1;
				sel_bus = 0;
				if(alu_zero)
				begin
					load_pc = 1;
					sel_pc = 0;
				end
			end
			else
			begin
				sel_alu = 1;
				op = 7;
				load_w = 1;
				if(alu_zero)
				begin
					load_pc = 1;
					sel_pc = 0;
				end
			end
		end
		else if(INCFSZ)
		begin
			if(d)
			begin
				sel_alu = 1;
				op = 6;
				ram_en = 1;
				sel_bus = 0;
				if(alu_zero)
				begin
					load_pc = 1;
					sel_pc = 0;
				end
			end
			else
			begin
				sel_alu = 1;
				op = 6;
				load_w = 1;
				if(alu_zero)
				begin
					load_pc = 1;
					sel_pc = 0;
				end
			end
		end
		else if (ASRF)
		begin
			op = 11;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end
		else if (LSLF)
		begin
			op = 12;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end
		else if (LSRF)
		begin
			op = 13;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end
		else if (RLF)
		begin
			op = 14;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end
		else if (RRF)
		begin
			op = 15;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end 
		else if (SWAPF)
		begin
			op = 16;
			sel_alu = 1;
			if(d)
				ram_en = 1;
			else
				load_w = 1;
		end
		else if (CALL)
		begin
			sel_pc = 1;
			load_pc = 1;
			push = 1;
		end
		else if (RETURN)
		begin
			sel_pc = 2;
			load_pc = 1;
			pop = 1;
		end
		else if (BRA)
		begin
			load_pc = 1;
			sel_pc = 3;
		end
		else if (BRW)
		begin
			load_pc = 1;
			sel_pc = 4;
		end
		else if (NOP)
		begin
		end
		pic_ns = 5;
		end
		5:
		begin
		pic_ns = 6;
		end
		6:
		begin
		pic_ns = 1;
		end
		endcase
	end
	
endmodule	
	
	