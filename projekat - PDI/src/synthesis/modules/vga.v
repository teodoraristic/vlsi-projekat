// vga.v
module vga (
    input clk,
    input rst_n,
    input [23:0] code,
    output reg hsync,
    output reg vsync,
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
);
    // 800x600 @ 60Hz, 40MHz pixel clock
    localparam H_VISIBLE = 800;
    localparam H_FRONT_PORCH = 40;
    localparam H_SYNC = 128;
    localparam H_BACK_PORCH = 88;
    localparam H_TOTAL = 1056;

    localparam V_VISIBLE = 600;
    localparam V_FRONT_PORCH = 1;
    localparam V_SYNC = 4;
    localparam V_BACK_PORCH = 23;
    localparam V_TOTAL = 628;

    localparam hsync_polarity = ~1'b1;
    localparam vsync_polarity = ~1'b1;

    reg [11:0] h_cnt, h_cnt_next;
    reg [11:0] v_cnt, v_cnt_next;

    reg hsync_next, vsync_next;
    reg [3:0] red_next, green_next, blue_next;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            h_cnt <= 12'd0;
            v_cnt <= 12'd0;
            hsync <= hsync_polarity;
            vsync <= vsync_polarity;
            red <= 4'd0;
            green <= 4'd0;
            blue <= 4'd0;
        end else begin
            h_cnt <= h_cnt_next;
            v_cnt <= v_cnt_next;
            hsync <= hsync_next;
            vsync <= vsync_next;
            red <= red_next;
            green <= green_next;
            blue <= blue_next;
        end
    end

    always @(*) begin
        h_cnt_next = h_cnt;
        v_cnt_next = v_cnt;
        hsync_next = hsync_polarity;
        vsync_next = vsync_polarity;
        red_next = 4'd0;
        green_next = 4'd0;
        blue_next = 4'd0;

        if (h_cnt == H_TOTAL - 1) begin
            h_cnt_next = 12'd0;
            if (v_cnt == V_TOTAL - 1)
                v_cnt_next = 12'd0;
            else
                v_cnt_next = v_cnt + 12'd1;
        end else begin
            h_cnt_next = h_cnt + 12'd1;
            v_cnt_next = v_cnt;
        end

        if ((h_cnt >= (H_VISIBLE + H_FRONT_PORCH)) && (h_cnt < (H_VISIBLE + H_FRONT_PORCH + H_SYNC))) 
            hsync_next = ~hsync_polarity;

        if ((v_cnt >= (V_VISIBLE + V_FRONT_PORCH)) && (v_cnt < (V_VISIBLE + V_FRONT_PORCH + V_SYNC))) 
            vsync_next = ~vsync_polarity;

        if (h_cnt < H_VISIBLE && v_cnt < V_VISIBLE) begin
            if (h_cnt < H_VISIBLE / 2) begin
                red_next = code[23:20];
                green_next = code[19:16];
                blue_next = code[15:12];
            end else begin
                red_next = code[11:8];
                green_next = code[7:4];
                blue_next = code[3:0];
            end
        end

    end

endmodule