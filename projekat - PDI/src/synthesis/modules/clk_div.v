module clk_div #(
    parameter DIVISOR = 50_000_000
)(
    input clk,
    input rst_n,
    output out
);
    reg out_next, out_reg;
    integer cnt_next, cnt_reg;
    
    assign out = out_reg;
    
    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            out_reg <= 1'b0;
            cnt_reg <= 0;
        end
        else begin
            out_reg <= out_next;
            cnt_reg <= cnt_next;
        end
    
    always @(*) begin
        out_next = out_reg;
        cnt_next = cnt_reg;
        
        if (cnt_reg == DIVISOR/2 - 1) begin
            out_next = ~out_reg;
            cnt_next = 0;
        end
        else
            cnt_next = cnt_reg + 1;
    end
endmodule