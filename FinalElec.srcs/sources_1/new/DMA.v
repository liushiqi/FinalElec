`timescale 1ns / 1ps

module dma(
  input clk, rst, float_direction, mem_to_dma_valid, mem_to_dma_enable, cpu_to_dma_valid, cpu_to_dma_enable,
  output dma_to_mem_valid, dma_to_mem_enable, dma_to_cpu_valid, dma_to_cpu_enable,
  input [3:0]mem_data_out,
  input [7:0]cpu_data_out,
  output [3:0]mem_data_in,
  output [7:0]cpu_data_in
);
  
endmodule // dma
