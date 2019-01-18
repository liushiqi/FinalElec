`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/16/2019 06:22:37 PM
// Design Name:
// Module Name: BUF
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


module buffer(
    input clk, reset, dir,
    input [7:0] data_in,
    input input_valid, output_enable,
    output [7:0] data_out,
    output input_enable, output_valid,
    output [63:0] buffer,
    output [6:0] blk
);
    parameter mem_to_cpu = 0, cpu_to_mem = 1;

    wire input_valid48, input_enable48, output_valid48, output_enable48;
    wire input_valid84, input_enable84, output_valid84, output_enable84;
    wire [6:0] blk48, blk84;
    wire [63:0] buff48, buff84;
    wire [7:0] data48;
    wire [3:0] data84;

    assign input_valid48 = input_valid && (dir == mem_to_cpu);
    assign input_valid84 = input_valid && (dir == cpu_to_mem);
    assign output_enable48 = output_enable && (dir == mem_to_cpu);
    assign output_enable84 = output_enable && (dir == cpu_to_mem);

    fifo_4_to_8 buf48(
        .clk(clk), .reset(reset), .data_in(data_in[3:0]), .input_valid(input_valid48), .output_enable(output_enable48),
        .data_out(data48), .input_enable(input_enable48), .output_valid(output_valid48), .blk(blk48), .buffer(buff48)
    );

    fifo_8_to_4 buf84(
        .clk(clk), .reset(reset), .data_in(data_in), .input_valid(input_valid84), .output_enable(output_enable84),
        .data_out(data84), .input_enable(input_enable84), .output_valid(output_valid84), .blk(blk84), .buffer(buff84)
    );

    assign data_out = (dir == cpu_to_mem) ? {4'b0, data84} : data48;
    assign input_enable = (dir == cpu_to_mem) ? input_enable84 : input_enable48;
    assign output_valid = (dir == cpu_to_mem) ? output_valid84 : output_valid48;
    assign blk = (dir == cpu_to_mem) ? blk84 : blk48;
    assign buffer = (dir == cpu_to_mem) ? buff84 : buff48;
endmodule
