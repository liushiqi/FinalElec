`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2019 04:20:58 PM
// Design Name: 
// Module Name: fifo_y
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


module fifo_4_to_8(
		input clk, reset,
		input [3:0] Data_in,
		input Input_valid, Output_enable,
		output reg [7:0] Data_out,
		output reg Input_enable, Output_valid,
		output reg [63:0] buff,
		output reg [6:0] blk
    );
	reg flag;
	parameter in = 0, out = 1, buff_size = 64, out_size = 8, in_size = 4;
	always @ (*)
		if (reset) begin
            blk = 0;
			buff = 0;
			flag = in;
		end
	always @ (*) begin	// detect whether the buffer becomes full/empty; change the flag of direction
		if (flag == in) begin
			if (blk == buff_size) begin
				flag = out;
			end
		end else begin
			if (blk == 0) begin
				flag = in;
			end
		end
	end
	always @ (posedge clk) begin
		if (flag == in) begin
			if (Input_valid) begin
				Input_enable = 1; Output_valid = 0;
				buff[buff_size-1:in_size] <= buff;
			    buff[in_size-1:0] <= Data_in;
				blk <= blk+in_size;
			end else begin
			    Input_enable = 0; Output_valid = 0;
			end
		end else begin
			if (Output_enable) begin
				Input_enable = 0; Output_valid = 1;
				buff <= buff << out_size;
				Data_out <= buff[buff_size-1:buff_size-out_size];
				blk <= blk-out_size;
			end else begin
			    Input_enable = 0; Output_valid = 0;
			end
		end
	end
endmodule

module fifo_8_to_4(
		input clk, reset,
		input [7:0] Data_in,
		input Input_valid, Output_enable,
		output reg [3:0] Data_out,
		output reg Input_enable, Output_valid,
		output reg [63:0] buff,
		output reg [6:0] blk
    );
	reg flag;
	parameter in = 0, out = 1, buff_size = 64, out_size = 4, in_size = 8;
	always @ (*)
	   if (reset) begin
            blk = 0;
			buff = 0;
			flag = in;
		end
	always @ (*) begin	// detect whether the buffer becomes full/empty; change the flag of direction
		if (flag == in) begin
			if (blk == buff_size) begin
				flag = out;
			end
		end else begin
			if (blk == 0) begin
				flag = in;
			end
		end
	end
	always @ (posedge clk) begin
		if (flag == in) begin
			if (Input_valid) begin
				Input_enable = 1; Output_valid = 0;
				buff[buff_size-1:in_size] <= buff;
			    buff[in_size-1:0] <= Data_in;
				blk <= blk+in_size;
			end else begin
			    Input_enable = 0; Output_valid = 0;
			end
		end else begin
			if (Output_enable) begin
				Input_enable = 0; Output_valid = 1;
				buff <= buff << out_size;
				Data_out <= buff[buff_size-1:buff_size-out_size];
				blk <= blk-out_size;
			end else begin
			    Input_enable = 0; Output_valid = 0;
			end
		end
	end
endmodule
