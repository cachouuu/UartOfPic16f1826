module Decoder4x16(
    input 	logic	[3:0] 	data,
    output 	logic 	[6:0] 	hex_out
);

always_comb
begin
    case(data)
        4'b0000: hex_out = 7'b100_0000;
        4'b0001: hex_out = 7'b111_1001;
        4'b0010: hex_out = 7'b010_0100;
        4'b0011: hex_out = 7'b011_0000;
        4'b0100: hex_out = 7'b001_1001;
        4'b0101: hex_out = 7'b001_0010;
        4'b0110: hex_out = 7'b000_0010;
        4'b0111: hex_out = 7'b111_1000;
        4'b1000: hex_out = 7'b000_0000;
        4'b1001: hex_out = 7'b001_0000;
        4'b1010: hex_out = 7'b000_1000;
        4'b1011: hex_out = 7'b000_0011;
        4'b1100: hex_out = 7'b100_0110;
        4'b1101: hex_out = 7'b010_0001;
        4'b1110: hex_out = 7'b000_0110;
        4'b1111: hex_out = 7'b000_1110;
        default: hex_out = 7'bx;
    endcase
end
endmodule
    
    