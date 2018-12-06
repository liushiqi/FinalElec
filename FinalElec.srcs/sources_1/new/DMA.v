`timescale 1ns / 1ps

module DMA(
clk,
rst,
float_direction,
mem_to_dma_valid,
mem_to_dma_enable,
cpu_to_dma_valid,
cpu_to_dma_enable,
dma_to_mem_valid,
dma_to_mem_enable,
dma_to_cpu_valid,
dma_to_cpu_enable,
mem_data_in,
mem_data_out,
cpu_data_in,
cpu_data_out);
reg [63:0]BUF1,BUF2;
input
clk,
rst,
float_direction,
mem_to_dma_valid,
mem_to_dma_enable,
cpu_to_dma_valid,
cpu_to_dma_enable;
output
dma_to_mem_valid,
dma_to_mem_enable,
dma_to_cpu_valid,
dma_to_cpu_enable;
output [3:0]mem_data_in;
input [3:0]mem_data_out;
output [7:0]cpu_data_in;
input [7:0]cpu_data_out;
reg [2:0]BUF1Valid,BUF2Valid;
reg BUF1Empty,BUF2Empty;

endmodule


module rst(BUF1,BUF2);
inout [63:0] BUF1,BUF2;
assign BUF1=0;
assign BUF2=0;
endmodule
