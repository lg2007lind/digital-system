// vga_sync: VGA 640x480@60Hz timing generator
//
// Horizontal timing (pixels):   Sync=96  Back=48  Disp=640  Front=16  Total=800
// Vertical timing   (lines):    Sync=2   Back=33  Disp=480  Front=10  Total=525
//
// Pixel clock: 25.175MHz nominal (25MHz acceptable for most monitors)
// hsync/vsync are active-low per VGA standard

module vga_sync(
    input            clk_25M,
    input            rst,
    output wire      hsync,
    output wire      vsync,
    output wire      video_on,
    output wire [9:0] x_pos,
    output wire [9:0] y_pos
);

    // VGA 640x480@60Hz timing parameters
    localparam H_SYNC  = 96;
    localparam H_BACK  = 48;
    localparam H_DISP  = 640;
    localparam H_FRONT = 16;
    localparam H_TOTAL = 800;
    localparam V_SYNC  = 2;
    localparam V_BACK  = 33;
    localparam V_DISP  = 480;
    localparam V_FRONT = 10;
    localparam V_TOTAL = 525;

    // Pixel and line counters
    reg [9:0] h_cnt;
    reg [9:0] v_cnt;

    // Horizontal counter: 0 ~ H_TOTAL-1
    always @(posedge clk_25M or posedge rst) begin
        if (rst)
            h_cnt <= 10'd0;
        else if (h_cnt == H_TOTAL - 1)
            h_cnt <= 10'd0;
        else
            h_cnt <= h_cnt + 1'b1;
    end

    // Vertical counter: increments when h_cnt rolls over
    always @(posedge clk_25M or posedge rst) begin
        if (rst)
            v_cnt <= 10'd0;
        else if (h_cnt == H_TOTAL - 1) begin
            if (v_cnt == V_TOTAL - 1)
                v_cnt <= 10'd0;
            else
                v_cnt <= v_cnt + 1'b1;
        end
    end

    // Sync signals: active-low (standard VGA polarity)
    assign hsync = ~(h_cnt < H_SYNC);
    assign vsync = ~(v_cnt < V_SYNC);

    // Active display region
    wire h_active = (h_cnt >= (H_SYNC + H_BACK)) &&
                    (h_cnt <  (H_SYNC + H_BACK + H_DISP));

    wire v_active = (v_cnt >= (V_SYNC + V_BACK)) &&
                    (v_cnt <  (V_SYNC + V_BACK + V_DISP));

    assign video_on = h_active && v_active;

    // Pixel coordinates within the active display area
    assign x_pos = video_on ? (h_cnt - (H_SYNC + H_BACK)) : 10'd0;
    assign y_pos = video_on ? (v_cnt - (V_SYNC + V_BACK)) : 10'd0;

endmodule
