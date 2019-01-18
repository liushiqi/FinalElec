`timescale 1ns / 1ps

`include "../../sources_1/new/dma.v"

module test();
  reg clk, rst, dir;
  reg [3:0] mem_to_dma_in;
  wire [3:0] dma_to_mem_out;
  reg [7:0] cpu_to_dma_in;
  wire [7:0] dma_to_cpu_out;
  reg mem_to_dma_enable, cpu_to_dma_enable;
  wire mem_to_dma_valid, cpu_to_dma_valid;
  integer i;

  initial begin
    clk = 0;
    rst = 1;
    dir = 1;
    mem_to_dma_in = 0;
    cpu_to_dma_in = 0;
    mem_to_dma_enable = 1;
    cpu_to_dma_enable = 1;
    i = 0;
    #1 rst = 0;
    #999 begin
      dir = 0;
      rst = 1;
      #1 rst = 0;
    end
  end

  always #1 clk = ~clk;

  always @(posedge clk) begin
    if (i <= 500) begin
      mem_to_dma_in = mem_to_dma_in + 1;
    end else begin
      cpu_to_dma_in = cpu_to_dma_in + 1;
    end
    i = i + 1;
  end

  dma dma(clk, rst, dir, mem_to_dma_enable, cpu_to_dma_enable, mem_to_dma_valid, cpu_to_dma_valid, mem_to_dma_in, cpu_to_dma_in, dma_to_mem_out, dma_to_cpu_out);
endmodule // test
