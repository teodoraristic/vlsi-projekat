module top;

reg [2:0] oc;
reg [3:0] a, b;
wire [3:0] f;

reg clk;
reg rst_n;
reg cl, ld;
reg [3:0] in;
reg inc, dec;
reg sr, ir;
reg sl, il;
wire [3:0] reg_out;

alu alu_inst(
    .oc(oc),
    .a(a),
    .b(b),
    .f(f)
);

register register_inst(
    .clk(clk),
    .rst_n(rst_n),
    .cl(cl),
    .ld(ld),
    .in(in),
    .inc(inc),
    .dec(dec),
    .sr(sr),
    .ir(ir),
    .sl(sl),
    .il(il),
    .out(reg_out)
);

always #5 clk = ~clk;

task test_alu_all;
    integer i, j, k;
    begin

        for (k = 0; k < 8; k=k+1) begin          
            oc = k;
            for (i = 0; i < 16; i=i+1) begin     
                a = i;
                for (j = 0; j < 16; j=j+1) begin 
                    b = j;
                    #1;
                    $display("%0t\t%3b\t%4b\t%4b\t%4b", $time, oc, a, b, f);
                end
            end
        end
    end
endtask

task test_register_random;
    integer i;
    begin
        rst_n = 1'b0;
        {cl, ld, inc, dec, sr, ir, sl, il} = 8'b0;
        in = 4'h0;
        
        #2 rst_n = 1'b1;
        
        for (i = 0; i < 1000; i=i+1) begin
            #10;
            
            {cl, ld, inc, dec, sr, ir, sl, il} = $random;

            in = {$random} % 16;
            
            $display("%0t\t%0b\t%0b\t%4b\t%0b\t%0b\t%0b\t%0b\t%0b\t%0b\t%4b",
                    $time, cl, ld, in, inc, dec, sr, ir, sl, il, reg_out);
        end
    end
endtask

initial begin
    oc = 0;
    a = 0;
    b = 0;
    clk = 0;
    rst_n = 1;
    cl = 0;
    ld = 0;
    in = 0;
    inc = 0;
    dec = 0;
    sr = 0;
    ir = 0;
    sl = 0;
    il = 0;
    
    test_alu_all;

    $stop;

    test_register_random;
    
    $finish;
end

endmodule