`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2019 06:22:37 PM
// Design Name: 
// Module Name: BUF
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


module buffer(
        input clk, reset, dir,
        input [7:0] Data_in,
        input Input_valid, Output_enable,
        output [7:0] Data_out,
        output Input_enable, Output_valid,
        output [63:0] buff,
        output [6:0] blk
    );
    parameter mem_to_cpu = 0, cpu_to_mem = 1;

    wire Inval48, Inen48, Outval48, Outen48;
    wire Inval84, Inen84, Outval84, Outen84;
    wire [6:0] blk48, blk84;
    wire [63:0] buff48, buff84;
    wire [7:0] Data48;
    wire [3:0] Data84;

    assign Inval48 = Input_valid && (dir == mem_to_cpu);
    assign Inval84 = Input_valid && (dir == cpu_to_mem);
    assign Outen48 = Output_enable && (dir == mem_to_cpu);
    assign Outen84 = Output_enable && (dir == cpu_to_mem);

    fifo_4_to_8 buf48(
        .clk(clk), .reset(reset), .Data_in(Data_in[3:0]), .Input_valid(Inval48), .Output_enable(Outen48),
        .Data_out(Data48), .Input_enable(Inen48), .Output_valid(Outval48), .blk(blk48), .buff(buff48)
    );
    fifo_8_to_4 buf84(
        .clk(clk), .reset(reset), .Data_in(Data_in), .Input_valid(Inval84), .Output_enable(Outen84),
        .Data_out(Data84), .Input_enable(Inen84), .Output_valid(Outval84), .blk(blk84), .buff(buff84)
    );

    assign Data_out = (dir == cpu_to_mem)? {4'b0, Data84}: Data48;
    assign Input_enable = (dir == cpu_to_mem)? Inen84: Inen48;
    assign Output_valid = (dir == cpu_to_mem)? Outval84: Outval48;
    assign blk = (dir == cpu_to_mem)? blk84: blk48;
    assign buff = (dir == cpu_to_mem)? buff84: buff48;
endmodule
