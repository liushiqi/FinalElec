`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/16/2019 04:20:58 PM
// Design Name:
// Module Name: fifo_y
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module fifo_4_to_8(
    input clk, reset,
    input [3:0] data_in,
    input input_valid, output_enable,
    output reg [7:0] data_out,
    output reg input_enable, output_valid,
    output reg [63:0] buffer,
    output reg [6:0] blk
);
    reg flag;
    parameter in = 0, out = 1, buff_size = 64, out_size = 8, in_size = 4;

    always @(posedge reset) begin
        blk = 0;
        buffer = 0;
        flag = in;
        data_out = 0;
        input_enable = 1;
        output_valid = 0;
    end

    always @(posedge clk) begin	// detect whether the buffer becomes full/empty; change the flag of direction
        if (flag == in) begin
            if (blk == buff_size) begin
                flag = out;
            end
        end else begin
            if (blk == 0) begin
                flag = in;
            end
        end
    end

    always @(posedge clk) begin
        if (flag == in) begin
            if (input_valid) begin
                input_enable = 1; output_valid = 0;
                buffer[buff_size-1:in_size] <= buffer;
                buffer[in_size-1:0] <= data_in;
                blk <= blk+in_size;
            end else begin
                input_enable = 0; output_valid = 0;
            end
        end else begin
            if (output_enable) begin
                input_enable = 0; output_valid = 1;
                buffer <= buffer << out_size;
                data_out <= buffer[buff_size-1:buff_size-out_size];
                blk <= blk-out_size;
            end else begin
                input_enable = 0; output_valid = 0;
            end
        end
    end
endmodule

module fifo_8_to_4(
    input clk, reset,
    input [7:0] data_in,
    input input_valid, output_enable,
    output reg [3:0] data_out,
    output reg input_enable, output_valid,
    output reg [63:0] buffer,
    output reg [6:0] blk
);
    reg flag;
    parameter in = 0, out = 1, buff_size = 64, out_size = 4, in_size = 8;

    always @(posedge reset) begin
        blk = 0;
        buffer = 0;
        flag = in;
        data_out = 0;
        input_enable = 1;
        output_valid = 0;
    end

    always @(posedge clk) begin	// detect whether the buffer becomes full/empty; change the flag of direction
        if (flag == in) begin
            if (blk == buff_size) begin
                flag = out;
            end
        end else begin
            if (blk == 0) begin
                flag = in;
            end
        end
    end

    always @ (posedge clk) begin
        if (flag == in) begin
            if (input_valid) begin
                input_enable = 1; output_valid = 0;
                buffer[buff_size-1:in_size] <= buffer;
                buffer[in_size-1:0] <= data_in;
                blk <= blk+in_size;
            end else begin
                input_enable = 0; output_valid = 0;
            end
        end else begin
            if (output_enable) begin
                input_enable = 0; output_valid = 1;
                buffer <= buffer << out_size;
                data_out <= buffer[buff_size-1:buff_size-out_size];
                blk <= blk-out_size;
            end else begin
                input_enable = 0; output_valid = 0;
            end
        end
    end
endmodule
