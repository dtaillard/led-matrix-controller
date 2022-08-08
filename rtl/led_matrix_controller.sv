`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: led_matrix_controller.sv
//
//////////////////////////////////////////////////////////////////////////////////


module led_matrix_controller
  #(parameter MATRIX_COLS = 64,
    parameter MATRIX_ROWS = 32,
    parameter PWM_BITS = 1
  )
   (input  logic i_clk,
    input  logic rst,

    // Pixel address and data buses
    input  logic [(3*PWM_BITS)-1:0] i_pixel_data,
    output logic [$clog2(MATRIX_COLS*MATRIX_ROWS)-1:0] o_pixel_addr,

    // Signals output to the LED matrix
    output logic [$clog2(MATRIX_ROWS/2)-1:0] o_row_sel,
    output logic o_clk,
    output logic o_oe,
    output logic o_latch,
    output logic [2:0] o_color1,
    output logic [2:0] o_color2
  );

    enum logic[1:0] {
        STATE_DISPLAY_1,
        STATE_DISPLAY_2,
        STATE_BLANK
    } fsm_state;

    logic [$clog2(MATRIX_ROWS/2)-1:0] row_sel_next;

    logic [$clog2(MATRIX_COLS):0] pixel_counter;
    logic [PWM_BITS-1:0] pwm_counter;

    logic [(3*PWM_BITS)-1:0] pixel_1;
    logic [(3*PWM_BITS)-1:0] pixel_2;
    logic [(3*PWM_BITS)-1:0] temp_pixel;

    logic data_valid;

    function [2:0] pwm_output(input logic [(3*PWM_BITS)-1:0] pixel);
        return {
            (pwm_counter < pixel[PWM_BITS-1:0]),
            (pwm_counter < pixel[(2*PWM_BITS)-1:PWM_BITS]),
            (pwm_counter < pixel[(3*PWM_BITS)-1:2*PWM_BITS])
        };
    endfunction

    assign o_color1 = pwm_output(pixel_1);
    assign o_color2 = pwm_output(pixel_2);

    assign o_latch = data_valid && fsm_state == STATE_DISPLAY_2 && pixel_counter == 1;
    assign o_oe = data_valid && (fsm_state == STATE_BLANK || o_latch);

    assign row_sel_next = o_row_sel + 1;

    always_ff @(posedge i_clk) begin
        if(rst) begin
            o_row_sel     <= '1;

            pixel_1       <= '0;
            pixel_2       <= '0;
            temp_pixel    <= '0;

            pixel_counter <= '0;
            pwm_counter   <= '0;
            data_valid    <= '0;

            fsm_state <= STATE_BLANK;
        end
        else
            case(fsm_state)
                STATE_BLANK: begin
                    temp_pixel <= i_pixel_data;

                    if(data_valid) begin
                        pixel_counter <= 1;

                        o_row_sel <= row_sel_next;
                        if(row_sel_next == '0) begin
                            pwm_counter <= pwm_counter + 1;
                        end

                        fsm_state <= STATE_DISPLAY_2;
                    end
                    else begin
                        fsm_state <= STATE_DISPLAY_1;
                    end
                end
                STATE_DISPLAY_1: begin
                    temp_pixel <= i_pixel_data;

                    if(pixel_counter < MATRIX_COLS) begin
                        pixel_counter <= pixel_counter + 1;
                        fsm_state <= STATE_DISPLAY_2;
                    end
                    else begin
                        fsm_state <= STATE_BLANK;
                    end
                end
                STATE_DISPLAY_2: begin
                    data_valid <= 1;
                    pixel_1 <= temp_pixel;
                    pixel_2 <= i_pixel_data;

                    fsm_state <= STATE_DISPLAY_1;
                end
                default: begin
                    data_valid <= 0;
                    fsm_state <= STATE_BLANK;
                end
            endcase
    end

    // Drive the clock
    always_ff @(posedge i_clk) begin
        if(!rst) begin
            o_clk <= data_valid && fsm_state == STATE_DISPLAY_1;
        end
        else begin
            o_clk <= 0;
        end
    end

    // Drive the pixel address bus
    always_comb begin
        o_pixel_addr = pixel_counter + MATRIX_COLS*row_sel_next;
        if((fsm_state == STATE_DISPLAY_1 && pixel_counter < MATRIX_COLS) || (fsm_state == STATE_BLANK && data_valid)) begin
            o_pixel_addr += MATRIX_COLS*MATRIX_ROWS/2;
        end
    end
endmodule
