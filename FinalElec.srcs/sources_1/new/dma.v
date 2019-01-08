`timescale 1ns / 1ps

`include "fifo.v"

/**
 * @param clk clock input
 * @param rst reset input
 * @param float_direction
 */
module dma(
  input clk, rst, dir, float_direction, mem_to_dma_valid, mem_to_dma_enable, cpu_to_dma_valid, cpu_to_dma_enable,
  output dma_to_mem_valid, dma_to_mem_enable, dma_to_cpu_valid, dma_to_cpu_enable,
  input [3:0]mem_data_out,
  input [7:0]cpu_data_out,
  output reg [3:0]mem_data_in,
  output reg [7:0]cpu_data_in
);
  fifo buffer_cpu_to_mem(.clk(clk), .rst(rst), .dir(dir), .input_valid(cpu_to_dma_valid), .output_valid(dma_to_cpu_valid), .input_enable(cpu_to_dma_enable), .output_enable(dma_to_cpu_enable), .narrow(mem_data_in));
  reg [2:0] buffer_valid_cpu_to_mem, buffer_valid_mem_to_cpu;
  reg buffer_empty_cpu_to_mem, buffer_empty_mem_to_cpu;
endmodule // dma
