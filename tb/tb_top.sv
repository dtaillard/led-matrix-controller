`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: tb_top
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_top();
    reg clk;
    reg rst;
    wire [23:0] pixel_data;
    wire [10:0] pixel_addr;
    wire m_clk;
    wire m_oe;
    wire m_latch;
    wire [3:0] m_row_sel;
    wire [2:0] m_color1;
    wire [2:0] m_color2;
    
    reg [5:0] test_cnt;
    
    single_port_ram_sync #(
        .ADDR_WIDTH(11),
        .DATA_WIDTH(24),
        .INIT_FILE("matrix_data.mem")
    ) pixel_ram (
        .clk(clk),
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
        .i_clk(clk),
        .rst(rst),
        .i_pixel_data(pixel_data),
        .o_pixel_addr(pixel_addr),
        .o_clk(m_clk),
        .o_oe(m_oe),
        .o_latch(m_latch),
        .o_row_sel(m_row_sel),
        .o_color1(m_color1),
        .o_color2(m_color2)
    );
    
    initial
    begin
        clk = 0;
        forever
            #100 clk = ~clk;
    end
    
    initial
    begin
        test_cnt = 0;
        rst = 1;
        #200 rst = 0;
    end
    
    always @(posedge m_clk)
    begin
        test_cnt = test_cnt + 1;
    end
endmodule
