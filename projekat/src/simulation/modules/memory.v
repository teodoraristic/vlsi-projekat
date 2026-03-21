module memory (
    input clk,
    input we,
    input [5:0] addr,
    input [7:0] data,
    output [7:0] out
);

    reg [7:0] mem [63:0];
    reg [7:0] out_reg;
    
    assign out = out_reg;
    
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data;
        end
        out_reg <= mem[addr];
    end

endmodule