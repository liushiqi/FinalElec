`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/16/2019 07:18:28 PM
// Design Name:
// Module Name: buf_tb
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


module buffer_test();
    reg clk, reset, input_valid, output_enable, dir;
    reg [7:0] data_in;
    wire [3:0] Data_out;
    wire input_enable, output_valid;
    wire [6:0] blk;
    wire [63:0] buff;

    buffer uut_buf(
        .clk(clk), .reset(reset), .dir(dir),
        .data_in(data_in), .input_valid(input_valid), .output_enable(output_enable),
        .Data_out(Data_out), .input_enable(input_enable), .output_valid(output_valid),
        .blk(blk), .buff(buff)
    );

    always #10 clk = ~clk;
    initial begin
        clk = 0; reset = 1; dir = 1;
        input_valid = 0; output_enable = 0;
        #1 reset = 0;
    end

    always @ (posedge clk) begin
        {input_valid, output_enable} = {$random};
        data_in = {$random};
    end
endmodule
