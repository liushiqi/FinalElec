`timescale 1ns / 1ps

`include "../../sources_1/new/fifo.v"

module test();
  reg clk, rst, dir;
  reg [3:0] narrow_buffer;
  wire [3:0] narrow;
  reg [7:0] wide_buffer;
  wire [7:0] wide;
  reg input_valid, output_enable;
  wire input_enable, output_valid;
  integer i;

  assign narrow = narrow_buffer;
  assign wide = wide_buffer;

  initial begin
    clk = 0;
    rst = 1;
    dir = 0;
    narrow_buffer = 0;
    wide_buffer = 0;
    i = 0;
    #1 rst = 0;
    #999 begin
      dir = 1;
      rst = 1;
      #1 rst = 0;
    end
  end
 
  always #10 begin
    input_valid = !input_valid;
    #1 output_enable = !output_enable;
  end

  always #1 clk = ~clk;

  always @(posedge clk) begin
    if (i <= 1000) begin
      narrow_buffer = narrow_buffer + 1;
    end else begin
      wide_buffer = wide_buffer + 1;
    end
    i = i + 1;
  end

  fifo fifo(clk, rst, dir, narrow_buffer, wide_buffer, input_valid, output_enable, input_enable, output_valid);
endmodule // test
