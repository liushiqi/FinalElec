//% @file buffer.v
//% @brief Buffer模块文件，为一个可以输入或输出的存储部件。
//% 
//% @author 杨程远<yangchengyuan17@mails.ucas.ac.cn>
//% @version 0.1.0
//% @date 2019-01-18

`timescale 1ns / 1ps

//% 一个buffer，可以存储64位数据，为先进先出。
module buffer(
    //% 内部状态将在每次时钟周期后改变。
    //% 时钟信号输入
    input clk,
    //% 在上升沿，被触发时，buffer将被重置，清除存储的数据。
    //% 重置信号
    input reset,
    //% 若设为1，将从宽端传输数据到窄端，否则，从窄端到宽端。
    //% 方向信号
    input dir,
    //% 即将被存入的数据。若输入为4字节，忽略高4位。
    input [7:0] data_in,
    //% 输入是否有效
    input input_valid,
    //% 输出是否有效
    input output_enable,
    //% 输出的数据，若输出为4字节，则高位补零。
    output [7:0] data_out,
    //% buffer是否准备好接受输入。
    output input_enable,
    //% buffer是否准备好进行输出。
    output output_valid,
    //% buffer中的内容（测试用）
    output [63:0] buffer,
    //% buffer的位置（测试用）
    output [6:0] blk
);
    parameter mem_to_cpu = 0, cpu_to_mem = 1;

    wire input_valid48, input_enable48, output_valid48, output_enable48;
    wire input_valid84, input_enable84, output_valid84, output_enable84;
    wire [6:0] blk48, blk84;
    wire [63:0] buff48, buff84;
    wire [7:0] data48;
    wire [3:0] data84;

    assign input_valid48 = input_valid && (dir == mem_to_cpu);
    assign input_valid84 = input_valid && (dir == cpu_to_mem);
    assign output_enable48 = output_enable && (dir == mem_to_cpu);
    assign output_enable84 = output_enable && (dir == cpu_to_mem);

    //% 从4位读，写到8位的FIFO芯片，若dir为0则启用。
    fifo_4_to_8 buf48(
        .clk(clk), .reset(reset), .data_in(data_in[3:0]), .input_valid(input_valid48), .output_enable(output_enable48),
        .data_out(data48), .input_enable(input_enable48), .output_valid(output_valid48), .blk(blk48), .buffer(buff48)
    );

    //% 从8位读，写到4位的FIFO芯片，若dir为1则启用。
    fifo_8_to_4 buf84(
        .clk(clk), .reset(reset), .data_in(data_in), .input_valid(input_valid84), .output_enable(output_enable84),
        .data_out(data84), .input_enable(input_enable84), .output_valid(output_valid84), .blk(blk84), .buffer(buff84)
    );

    assign data_out = (dir == cpu_to_mem) ? {4'b0, data84} : data48;
    assign input_enable = (dir == cpu_to_mem) ? input_enable84 : input_enable48;
    assign output_valid = (dir == cpu_to_mem) ? output_valid84 : output_valid48;
    assign blk = (dir == cpu_to_mem) ? blk84 : blk48;
    assign buffer = (dir == cpu_to_mem) ? buff84 : buff48;
endmodule
