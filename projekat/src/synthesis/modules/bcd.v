module bcd (
    input  [5:0] in,
    output [3:0] ones,
    output [3:0] tens
);
    assign tens = (in >= 50) ? 4'd5 :
                  (in >= 40) ? 4'd4 :
                  (in >= 30) ? 4'd3 :
                  (in >= 20) ? 4'd2 :
                  (in >= 10) ? 4'd1 : 4'd0;
    assign ones = in - (tens * 10);
endmodule