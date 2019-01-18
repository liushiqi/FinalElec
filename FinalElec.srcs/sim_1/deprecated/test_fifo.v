`timescale 1ns / 1ps

`include "../../sources_1/new/fifo.v"

module test_fifo();
  reg clk, rst, dir;
  reg [3:0] narrow_in;
  wire [3:0] narrow_out;
  reg [7:0] wide_in;
  wire [7:0] wide_out;
  reg input_valid, output_enable;
  wire input_enable, output_valid;
  integer i;

  initial begin
    clk = 0;
    rst = 1;
    dir = 1;
    narrow_in = 0;
    wide_in = 0;
    input_valid = 1;
    output_enable = 0;
    i = 0;
    #1 rst = 0;
    #999 begin
      dir = 0;
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
    if (i <= 500) begin
      narrow_in = narrow_in + 1;
    end else begin
      wide_in = wide_in + 1;
    end
    i = i + 1;
  end

  fifo fifo(clk, rst, dir, narrow_in, wide_in, narrow_out, wide_out, input_valid, output_enable, input_enable, output_valid);
endmodule // test
