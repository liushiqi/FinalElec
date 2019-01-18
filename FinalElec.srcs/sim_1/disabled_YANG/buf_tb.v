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


module buf_tb(

    );
	reg clk, reset, Input_valid, Output_enable, dir;
	reg [7:0] Data_in;
	wire [3:0] Data_out;
	wire Input_enable, Output_valid;
    wire [6:0] blk;
    wire [63:0] buff;

	buffer uut_buf(
			.clk(clk), .reset(reset), .dir(dir),
			.Data_in(Data_in), .Input_valid(Input_valid), .Output_enable(Output_enable),
			.Data_out(Data_out), .Input_enable(Input_enable), .Output_valid(Output_valid),
            .blk(blk), .buff(buff)
		    );

	always #10 clk = ~clk;
	initial begin
		clk = 0; reset = 1; dir = 1;
		Input_valid = 0; Output_enable = 0;
		#1 reset = 0;
	end

	always @ (posedge clk) begin
		{Input_valid, Output_enable} = {$random};
		Data_in = {$random};
	end
endmodule
