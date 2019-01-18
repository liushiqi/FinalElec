`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/16/2019 08:51:15 PM
// Design Name:
// Module Name: dma_tb
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


module dma_test();
    reg clk, reset, dir, mem_to_dma_valid, mem_to_dma_enable, cpu_to_dma_valid, cpu_to_dma_enable;
    reg [3:0] mem_data_out;
    reg [7:0] cpu_data_out;
    wire [3:0] mem_data_in;
    wire [7:0] cpu_data_in, Data_out1, Data_out2;
    wire dma_to_mem_enable, dma_to_mem_valid, dma_to_cpu_enable, dma_to_cpu_valid;
    wire [63:0] buff1, buff2;

    dma uut_dma(
        .clk(clk), .reset(reset), .dir(dir), .mem_data_out(mem_data_out), .cpu_data_out(cpu_data_out),
        .mem_to_dma_valid(mem_to_dma_valid), .mem_to_dma_enable(mem_to_dma_enable),
        .cpu_to_dma_valid(cpu_to_dma_valid), .cpu_to_dma_enable(cpu_to_dma_enable),
        .mem_data_in(mem_data_in), .cpu_data_in(cpu_data_in),
        .dma_to_mem_enable(dma_to_mem_enable), .dma_to_mem_valid(dma_to_mem_valid),
        .dma_to_cpu_enable(dma_to_cpu_enable), .dma_to_cpu_valid(dma_to_cpu_valid),
        .buff1(buff1), .buff2(buff2),
        .Data_out1(Data_out1), .Data_out2(Data_out2)
    );

    always #10 clk = ~clk;
    initial begin
        clk = 0; reset = 1; dir = 1;
        mem_to_dma_valid = 0; mem_to_dma_enable = 0;
        cpu_to_dma_valid = 0; cpu_to_dma_enable = 0;
        #1 reset = 0;
    end

    always @(posedge clk) begin
        {mem_to_dma_valid, mem_to_dma_enable, cpu_to_dma_valid, cpu_to_dma_enable} = {$random};
        mem_data_out = {$random};
        cpu_data_out = {$random};
    end
endmodule
