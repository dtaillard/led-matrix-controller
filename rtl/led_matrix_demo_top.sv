`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: led_matrix_demo_top
// 
//////////////////////////////////////////////////////////////////////////////////

module led_matrix_demo_top(
    input clk,
    input btnC,
    output m_clk,
    output m_oe,
    output m_latch,
    output [3:0] m_row_sel,
    output [2:0] m_color1,
    output [2:0] m_color2
);

    wire clk_5mhz;
    
    wire [23:0] pixel_data;
    wire [10:0] pixel_addr;

    wire rst_external = btnC;

    clk_wiz_0 clk_wiz_0_0 (
        .clk_out1(clk_5mhz),
        .clk_in1(clk)
    );

    single_port_ram_sync #(
        .ADDR_WIDTH(11),
        .DATA_WIDTH(24),
        .INIT_FILE("matrix_data.mem")
    ) pixel_ram (
        .clk(clk_5mhz),
        .we(1'b0),
        .addr(pixel_addr),
        .dout(pixel_data),
        .din(12'b0)
    );

    led_matrix_controller #(
        .MATRIX_COLS(64),
        .MATRIX_ROWS(32),
        .PWM_BITS(8)
    ) led_matrix_0 (
        .i_clk(clk_5mhz),
        .rst(rst_external),
        .i_pixel_data(pixel_data),
        .o_pixel_addr(pixel_addr),
        .o_clk(m_clk),
        .o_oe(m_oe),
        .o_latch(m_latch),
        .o_row_sel(m_row_sel),
        .o_color1(m_color1),
        .o_color2(m_color2)
    );
endmodule
