`timescale 1ns / 1ps

`include "fifo.v"

module dma(
  input clk, rst, dir, mem_to_dma_enable, cpu_to_dma_enable,
  output mem_to_dma_valid, cpu_to_dma_valid,
  input [3:0] mem_data_input,
  input [7:0] cpu_data_input,
  output reg [3:0] mem_data_output,
  output reg [7:0] cpu_data_output
);
  reg direction;

  reg fifo_01_status;
  reg fifo_02_status;
  
  wire [3:0] mem_data_fifo_01;
  wire [7:0] cpu_data_fifo_01;
  wire [3:0] mem_data_fifo_02;
  wire [7:0] cpu_data_fifo_02;

  wire fifo_enable_input_01;
  wire fifo_valid_output_01;
  wire fifo_valid_input_01;
  wire fifo_enable_output_01;
  wire fifo_enable_input_02;
  wire fifo_valid_output_02;
  wire fifo_valid_input_02;
  wire fifo_enable_output_02;

  assign fifo_valid_input_01 = fifo_01_status & (direction ? mem_to_dma_enable : cpu_to_dma_enable);
  assign fifo_enable_output_01 = !fifo_01_status & (direction ? cpu_to_dma_enable : cpu_to_dma_valid);
  assign fifo_valid_input_02 = fifo_02_status & (direction ? mem_to_dma_enable : cpu_to_dma_enable);
  assign fifo_enable_output_02 = !fifo_02_status & (direction ? cpu_to_dma_enable : cpu_to_dma_valid);

  assign mem_to_dma_valid = direction ? (fifo_01_status ? fifo_valid_output_02 : fifo_valid_output_01) : (fifo_01_status ? fifo_enable_input_02 : fifo_enable_input_01);
  assign cpu_to_dma_valid = direction ? (fifo_01_status ? fifo_enable_input_02 : fifo_enable_input_01) : (fifo_01_status ? fifo_valid_output_02 : fifo_valid_output_01);

  fifo fifo_01(.clk(clk), .rst(rst), .dir(dir), .narrow_port_in(mem_data_input), .wide_port_in(cpu_data_input), .narrow_port_out(mem_data_fifo_01), .wide_port_out(cpu_data_fifo_01), .input_valid(fifo_valid_input_01), .output_enable(fifo_enable_output_01), .input_enable(fifo_enable_input_01), .output_valid(fifo_valid_output_01)),
       fifo_02(.clk(clk), .rst(rst), .dir(dir), .narrow_port_in(mem_data_input), .wide_port_in(cpu_data_input), .narrow_port_out(mem_data_fifo_02), .wide_port_out(cpu_data_fifo_02), .input_valid(fifo_valid_input_02), .output_enable(fifo_enable_output_02), .input_enable(fifo_enable_input_02), .output_valid(fifo_valid_output_02));

  always @(posedge rst) begin
    direction <= dir;
    mem_data_output <= 0;
    cpu_data_output <= 0;
    fifo_01_status <= 1;
    fifo_02_status <= 0;
  end

  always @(posedge clk) begin
    if (fifo_01_status) begin
      mem_data_output <= mem_data_fifo_02;
      cpu_data_output <= cpu_data_fifo_02;
      if (fifo_valid_output_01 & fifo_enable_input_02) begin
        fifo_01_status <= ~fifo_01_status;
        fifo_02_status <= ~fifo_02_status;
      end
    end else begin
      mem_data_output <= mem_data_fifo_01;
      cpu_data_output <= cpu_data_fifo_01;
      if (fifo_enable_input_01 & fifo_valid_output_02) begin
        fifo_01_status <= !fifo_01_status;
        fifo_02_status <= ~fifo_02_status;
      end
    end
  end
endmodule // dma
