module scan_codes (
    input clk,
    input rst_n,
    input [15:0] code,
    input status,
    output control,
    output [3:0] num
);

    reg control_d, control_q;
    reg [3:0] num_d, num_q;
    reg [15:0] last_code_d, last_code_q;

    assign control = control_q;
    assign num = num_q;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            control_q <= 1'b0;
            num_q <= 4'd0;
            last_code_q <= 16'h0000;
        end else begin
            control_q <= control_d;
            num_q <= num_d;
            last_code_q <= last_code_d;
        end
    end

    always @(*) begin
        control_d = control_q;
        num_d = num_q;
        last_code_d = last_code_q;

        if (status && last_code_q != code) begin
            if (code[15:8] == 8'hF0) begin
                case (code[7:0])
                    8'h45: num_d = 4'd0;
                    8'h16: num_d = 4'd1;
                    8'h1E: num_d = 4'd2;
                    8'h26: num_d = 4'd3;
                    8'h25: num_d = 4'd4;
                    8'h2E: num_d = 4'd5;
                    8'h36: num_d = 4'd6;
                    8'h3D: num_d = 4'd7;
                    8'h3E: num_d = 4'd8;
                    8'h46: num_d = 4'd9;
                    default: num_d = num_q;
                endcase
                if (code[7:0] == 8'h45 || code[7:0] == 8'h16 || code[7:0] == 8'h1E ||
                    code[7:0] == 8'h26 || code[7:0] == 8'h25 || code[7:0] == 8'h2E ||
                    code[7:0] == 8'h36 || code[7:0] == 8'h3D || code[7:0] == 8'h3E ||
                    code[7:0] == 8'h46) begin
                    control_d = 1'b1;
                end
            end else begin
                control_d = 1'b0;
            end
            last_code_d = code;
        end else begin
            control_d = 1'b0;
        end
    end

endmodule