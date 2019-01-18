`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/16/2019 08:00:57 PM
// Design Name:
// Module Name: dma
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


module dma(
    input clk, reset, dir,
    input [3:0] mem_data_out,
    input [7:0] cpu_data_out,
    input mem_to_dma_valid, mem_to_dma_enable, cpu_to_dma_valid, cpu_to_dma_enable,
    output [3:0] mem_data_in,
    output [7:0] cpu_data_in,
    output dma_to_mem_enable, dma_to_mem_valid, dma_to_cpu_enable, dma_to_cpu_valid,
    output [63:0] buff1, buff2,
    output [7:0] data_out1, data_out2
);

    parameter mem_to_cpu = 0, cpu_to_mem = 1, buff_size = 64;
    reg direction, flag;    // flag == 0: input-->buffer1, buffer2-->output; flag == 1: input-->buffer2, buffer1-->output

    always @(posedge reset) begin
        direction = dir;
        flag = 0;
    end

    wire [7:0] data_in;
    wire input_valid, input_valid1, input_valid2, output_enable, output_enable1, output_enable2;
    wire input_enable1, input_enable2, output_valid1, output_valid2;
    wire [6:0] blk1, blk2;

    assign data_in = (direction == cpu_to_mem)? cpu_data_out: {4'b0, mem_data_out};
    assign input_valid = (direction == cpu_to_mem)? cpu_to_dma_valid: mem_to_dma_valid;
    assign output_enable = (direction == cpu_to_mem)? mem_to_dma_enable: cpu_to_dma_enable;
    assign input_valid1 = input_valid & !flag;
    assign input_valid2 = input_valid & flag;
    assign output_enable1 = output_enable & flag;
    assign output_enable2 = output_enable & !flag;

    buffer
    buffer1(
        .clk(clk), .reset(reset), .dir(direction), .data_in(data_in), .input_valid(input_valid1), .output_enable(output_enable1),
        .data_out(data_out1), .input_enable(input_enable1), .output_valid(output_valid1), .blk(blk1),
        .buffer(buff1)),
    buffer2(
        .clk(clk), .reset(reset), .dir(direction), .data_in(data_in), .input_valid(input_valid2), .output_enable(output_enable2),
        .data_out(data_out2), .input_enable(input_enable2), .output_valid(output_valid2), .blk(blk2),
        .buffer(buff2));

    always @(posedge clk) begin
        if (!flag) begin
            if (blk1 == buff_size && blk2 == 0) begin
                flag = 1;
            end
        end else begin
            if (blk2 == buff_size && blk1 == 0) begin
                flag = 0;
            end
        end
    end

    assign cpu_data_in = (flag? data_out1: data_out2);
    assign mem_data_in = (flag? data_out1[3:0]: data_out2[3:0]);

    assign dma_to_mem_enable = (direction == mem_to_cpu) && (flag? input_enable2: input_enable1);
    assign dma_to_cpu_valid = (direction == mem_to_cpu) && (flag? output_valid1: output_valid2);
    assign dma_to_cpu_enable = (direction == cpu_to_mem) && (flag? input_enable2: input_enable1);
    assign dma_to_mem_valid = (direction == cpu_to_mem) && (flag? output_valid1: output_valid2);

endmodule
