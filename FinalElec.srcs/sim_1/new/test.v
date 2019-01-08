`timescale 1ns / 1ps

module test();
  reg clk, rst;

  initial begin
    clk = 0;
    rst = 0;
  end

  always #1 clk = ~clk;
endmodule // test
