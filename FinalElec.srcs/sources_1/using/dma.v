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
    output [7:0] Data_out1, Data_out2
);

    parameter mem_to_cpu = 0, cpu_to_mem = 1, buff_size = 64;
    reg direction, flag;    // flag == 0: input-->BUF1, BUF2-->output; flag == 1: input-->BUF2, BUF1-->output
    always @(*) begin
        if (reset) begin
            direction = dir;
            flag = 0;
        end
    end

    wire [7:0] Data_in;
    wire Input_valid, Input_valid1, Input_valid2, Output_enable, Output_enable1, Output_enable2;
    wire Input_enable1, Input_enable2, Output_valid1, Output_valid2;
    wire [6:0] blk1, blk2;

    assign Data_in = (direction == cpu_to_mem)? cpu_data_out: {4'b0, mem_data_out};
    assign Input_valid = (direction == cpu_to_mem)? cpu_to_dma_valid: mem_to_dma_valid;
    assign Output_enable = (direction == cpu_to_mem)? mem_to_dma_enable: cpu_to_dma_enable;
    assign Input_valid1 = Input_valid & !flag;
    assign Input_valid2 = Input_valid & flag;
    assign Output_enable1 = Output_enable & flag;
    assign Output_enable2 = Output_enable & !flag;

    buffer
    BUF1(
        .clk(clk), .reset(reset), .dir(direction), .Data_in(Data_in), .Input_valid(Input_valid1), .Output_enable(Output_enable1),
        .Data_out(Data_out1), .Input_enable(Input_enable1), .Output_valid(Output_valid1), .blk(blk1),
        .buff(buff1)
    ),
    BUF2(
        .clk(clk), .reset(reset), .dir(direction), .Data_in(Data_in), .Input_valid(Input_valid2), .Output_enable(Output_enable2),
        .Data_out(Data_out2), .Input_enable(Input_enable2), .Output_valid(Output_valid2), .blk(blk2),
        .buff(buff2)
    );

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

    assign cpu_data_in = (flag? Data_out1: Data_out2);
    assign mem_data_in = (flag? Data_out1[3:0]: Data_out2[3:0]);

    assign dma_to_mem_enable = (direction == mem_to_cpu) && (flag? Input_enable2: Input_enable1);
    assign dma_to_cpu_valid = (direction == mem_to_cpu) && (flag? Output_valid1: Output_valid2);
    assign dma_to_cpu_enable = (direction == cpu_to_mem) && (flag? Input_enable2: Input_enable1);
    assign dma_to_mem_valid = (direction == cpu_to_mem) && (flag? Output_valid1: Output_valid2);

endmodule
