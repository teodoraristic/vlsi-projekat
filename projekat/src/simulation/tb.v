module top;
    integer i;
    
    reg clk;
    reg we;
    reg [5:0] addr;
    reg [15:0] data;
    wire [15:0] out;
    
    dut dut_memory (
        .clk(clk),
        .we(we),
        .addr(addr),
        .data(data),
        .out(out)
    );

    always begin
        #5;
        clk = ~clk;
    end
    

    always @(posedge clk) begin
        $strobe("t=%0t | clk: %b, we: %b, addr: %d, data: %d, out: %d", 
                $time, clk, we, addr, data, out);
    end
    
    initial begin
        clk = 1'b0;
        {addr, data} = 22'd0;
        
        we = 1'b1; 
        for (i = 0; i < 64; i = i + 1) begin
            data = $urandom_range(2**16);
            addr = i;
            #10;
        end
        
        $stop;  
        
        we = 1'b0;  
        repeat(100) begin
            addr = $urandom % 64;
            #10;
        end
        
        $finish;
    end

endmodule
