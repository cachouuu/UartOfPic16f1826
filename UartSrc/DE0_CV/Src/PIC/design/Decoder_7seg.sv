module Decoder_7seg(
	input [3:0] A,
	output logic [6:0] res
);
	
	always_comb
	begin
		case(A) //按照真值表填入7segment明或暗
			4'b0000:begin
						res[6] = 1; 
						res[5] = 0;
						res[4] = 0;
						res[3] = 0;
						res[2] = 0;
						res[1] = 0;
						res[0] = 0;						
					end
			4'b0001:begin
						res[6] = 1; 
						res[5] = 1;
						res[4] = 1;
						res[3] = 1;
						res[2] = 0;
						res[1] = 0;
						res[0] = 1;						
					end
			4'b0010:begin
						res[6] = 0; 
						res[5] = 1;
						res[4] = 0;
						res[3] = 0;
						res[2] = 1;
						res[1] = 0;
						res[0] = 0;						
					end
			4'b0011:begin
						res[6] = 0; 
						res[5] = 1;
						res[4] = 1;
						res[3] = 0;
						res[2] = 0;
						res[1] = 0;
						res[0] = 0;						
					end
			4'b0100:begin
						res[6] = 0; 
						res[5] = 0;
						res[4] = 1;
						res[3] = 1;
						res[2] = 0;
						res[1] = 0;
						res[0] = 1;						
					end
			4'b0101:begin
						res[6] = 0; 
						res[5] = 0;
						res[4] = 1;
						res[3] = 0;
						res[2] = 0;
						res[1] = 1;
						res[0] = 0;						
					end
			4'b0110:begin
						res[6] = 0; 
						res[5] = 0;
						res[4] = 0;
						res[3] = 0;
						res[2] = 0;
						res[1] = 1;
						res[0] = 0;						
					end
			4'b0111:begin
						res[6] = 1; 
						res[5] = 1;
						res[4] = 1;
						res[3] = 1;
						res[2] = 0;
						res[1] = 0;
						res[0] = 0;						
					end
			4'b1000:begin
						res[6] = 0; 
						res[5] = 0;
						res[4] = 0;
						res[3] = 0;
						res[2] = 0;
						res[1] = 0;
						res[0] = 0;						
					end
			4'b1001:begin
						res[6] = 0; 
						res[5] = 0;
						res[4] = 1;
						res[3] = 0;
						res[2] = 0;
						res[1] = 0;
						res[0] = 0;						
					end
			4'b1010:begin
						res[6] = 0; 
						res[5] = 0;
						res[4] = 0;
						res[3] = 1;
						res[2] = 0;
						res[1] = 0;
						res[0] = 0;						
					end
			4'b1011:begin
						res[6] = 0; 
						res[5] = 0;
						res[4] = 0;
						res[3] = 0;
						res[2] = 0;
						res[1] = 1;
						res[0] = 1;						
					end
			4'b1100:begin
						res[6] = 1; 
						res[5] = 0;
						res[4] = 0;
						res[3] = 0;
						res[2] = 1;
						res[1] = 1;
						res[0] = 0;						
					end
			4'b1101:begin
						res[6] = 0; 
						res[5] = 1;
						res[4] = 0;
						res[3] = 0;
						res[2] = 0;
						res[1] = 0;
						res[0] = 1;						
					end
			4'b1110:begin
						res[6] = 0; 
						res[5] = 0;
						res[4] = 0;
						res[3] = 0;
						res[2] = 1;
						res[1] = 1;
						res[0] = 0;						
					end
			4'b1111:begin
						res[6] = 0; 
						res[5] = 0;
						res[4] = 0;
						res[3] = 1;
						res[2] = 1;
						res[1] = 1;
						res[0] = 0;						
					end
		endcase
	end		

endmodule

