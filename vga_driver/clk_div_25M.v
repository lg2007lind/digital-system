// clk_div_25M: 100MHz -> 25MHz clock divider
// Uses a 2-bit counter to toggle clk_25M every 2 cycles of clk_100M
// clk_25M period = 4 * 10ns = 40ns -> 25MHz

module clk_div_25M(
    input        clk_100M,
    input        rst,
    output reg   clk_25M
);

    reg [1:0] cnt;

    always @(posedge clk_100M or posedge rst) begin
        if (rst) begin
            cnt     <= 2'b00;
            clk_25M <= 1'b0;
        end else begin
            if (cnt == 2'b01) begin
                cnt     <= 2'b00;
                clk_25M <= ~clk_25M;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule
