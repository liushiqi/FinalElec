`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2019 04:31:41 PM
// Design Name: 
// Module Name: fifo48_tb
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


module fifo48_tb(

    );
	reg clk, reset, Input_valid, Output_enable;
	reg [3:0] Data_in;
	wire [7:0] Data_out;
	wire Input_enable, Output_valid;

	fifo_4_to_8 uut48(
			.clk(clk), .reset(reset),
			.Data_in(Data_in), .Input_valid(Input_valid), .Output_enable(Output_enable),
			.Data_out(Data_out), .Input_enable(Input_enable), .Output_valid(Output_valid)
		    );

	always #10 clk = ~clk;
	initial begin
		clk = 0; reset = 1;
		Input_valid = 0; Output_enable = 0;
		#1 reset = 0;
	end

	always @ (posedge clk) begin
		{Input_valid, Output_enable} = {$random};
		Data_in = {$random};
	end
endmodule
