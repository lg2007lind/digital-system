// vga_top: VGA Display Top-Level Module
//
// Block diagram:
//   clk_100M --> clk_div_25M --> clk_25M --> vga_sync --> hsync, vsync
//                                                |
//                                                +--> video_on, x_pos, y_pos
//                                                |
//                                                v
//                                            vga_disp --> vga_r, vga_g, vga_b

`timescale 1ns / 1ps

module vga_top(
    input            clk_100M,
    input            rst,
    output wire      hsync,
    output wire      vsync,
    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b
);

    // Internal interconnect signals
    wire        clk_25M;
    wire        video_on;
    wire [9:0]  x_pos;
    wire [9:0]  y_pos;

    // Clock divider: 100MHz -> 25MHz
    clk_div_25M u_clk_div (
        .clk_100M (clk_100M),
        .rst      (rst),
        .clk_25M  (clk_25M)
    );

    // VGA sync timing generator
    vga_sync u_vga_sync (
        .clk_25M  (clk_25M),
        .rst      (rst),
        .hsync    (hsync),
        .vsync    (vsync),
        .video_on (video_on),
        .x_pos    (x_pos),
        .y_pos    (y_pos)
    );

    // VGA display content generator
    vga_disp u_vga_disp (
        .video_on  (video_on),
        .x_pos     (x_pos),
        .y_pos     (y_pos),
        .vga_r     (vga_r),
        .vga_g     (vga_g),
        .vga_b     (vga_b)
    );

endmodule
