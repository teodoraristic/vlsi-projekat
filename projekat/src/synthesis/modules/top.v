module top #(
    parameter DIVISOR = 50000000,
    parameter FILE_NAME = "mem_init.mif",
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input rst_n,
    input [2:0] btn,
    input [8:0] sw,
    output [9:0] led,
    output [27:0] hex
);

    wire slow_clk;

    wire we;
    wire [ADDR_WIDTH-1:0] addr;
    wire [DATA_WIDTH-1:0] data;
    wire [ADDR_WIDTH-1:0] pc;
    wire [ADDR_WIDTH-1:0] sp;
    wire [DATA_WIDTH-1:0] cpu_in;

    assign cpu_in = {{DATA_WIDTH-4{1'b0}}, sw[3:0]};

    wire [DATA_WIDTH-1:0] mem_out;

    wire [3:0] pc_ones, pc_tens;
    wire [3:0] sp_ones, sp_tens;


    clk_div #(
        .DIVISOR(DIVISOR)
    ) CLK_DIV (
        .clk(clk),
        .rst_n(rst_n),
        .out(slow_clk)
    );

    memory #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .FILE_NAME (FILE_NAME)
    ) MEMORY (
        .clk(slow_clk),
        .rst_n(rst_n),
        .we(we),
        .addr(addr),
        .data(data),
        .out(mem_out)
    );

    cpu #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) CPU (
        .clk(slow_clk),
        .rst_n(rst_n),
        .in(cpu_in),
        .mem(mem_out),
        .we(we),
        .addr(addr),
        .data(data),
        .pc(pc),
        .sp(sp),
        .out(led[4:0])
    );

    assign led[9:5] = 5'b0;

    bcd BCD_PC (
        .in(pc),
        .ones(pc_ones),
        .tens(pc_tens)
    );

    bcd BCD_SP (
        .in(sp),
        .ones(sp_ones),
        .tens(sp_tens)
    );

    ssd SSD0 (
        .in(pc_ones),
        .out(hex[6:0])
    );

    ssd SSD1 (
        .in(pc_tens),
        .out(hex[13:7])
    );

    ssd SSD2 (
        .in(sp_ones),
        .out(hex[20:14])
    );

    ssd SSD3 (
        .in(sp_tens),
        .out(hex[27:21])
    );


endmodule