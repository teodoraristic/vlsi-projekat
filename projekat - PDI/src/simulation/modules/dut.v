module dut (
    input clk,
    input we,
    input [5:0] addr,
    input [15:0] data,
    output [15:0] out
);

    wire [7:0] out_low;
    
    memory mem_low (
        .clk(clk),
        .we(we),
        .addr(addr),
        .data(data[7:0]),
        .out(out_low)
    );
    

    wire [7:0] out_high;
    
    memory mem_high (
        .clk(clk),
        .we(we),
        .addr(addr),
        .data(data[15:8]),
        .out(out_high)
    );
    
    assign out = {out_high, out_low};

endmodule