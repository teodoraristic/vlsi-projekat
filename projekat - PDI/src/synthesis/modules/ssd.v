module ssd (
    input [3:0] in,
    output reg [6:0] out
);
    always @(*)
        case (in)
            4'b0000: out = 7'h3F;  // 0
            4'b0001: out = 7'h06;  // 1
            4'b0010: out = 7'h5B;  // 2
            4'b0011: out = 7'h4F;  // 3
            4'b0100: out = 7'h66;  // 4
            4'b0101: out = 7'h6D;  // 5
            4'b0110: out = 7'h7D;  // 6
            4'b0111: out = 7'h07;  // 7
            4'b1000: out = 7'h7F;  // 8
            4'b1001: out = 7'h6F;  // 9
            4'b1010: out = 7'h77;  // A
            4'b1011: out = 7'h7C;  // b
            4'b1100: out = 7'h39;  // C
            4'b1101: out = 7'h5E;  // d
            4'b1110: out = 7'h79;  // E
            4'b1111: out = 7'h71;  // F
            default: out = 7'h00;
        endcase
endmodule