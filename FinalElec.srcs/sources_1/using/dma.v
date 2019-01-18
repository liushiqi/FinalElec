//% @file dma.v
//% @brief DMA模块文件, DMA的主要功能在这个文件里面定义。在Deprecated目录中，有一个被废弃的DMA实现，由刘士祺编写。
//%        在讨论后，我们决定采用杨程远写的DMA。文档由刘士祺编写。
//% 
//% @author 杨程远<yangchengyuan17@mails.ucas.ac.cn>
//% @version 0.1.0
//% @date 2019-01-18

`timescale 1ns / 1ps

//% DMA数据交换模块，用于在快速存储与低速存储设备之间交换数据，如内存与cpu。
module dma(
    //% 内部状态将在每次时钟周期后改变。
    //% 时钟信号输入
    input clk,
    //% 在上升沿，被触发时，DMA的状态将被重置。
    //% 重置信号
    input reset,
    //% 若设为1，将从CPU传输数据到内存，否则，从内存到CPU。
    //% 方向信号
    input dir,
    //% 从内存获取的数据
    input [3:0] mem_data_out,
    //% 从CPU获取的数据
    input [7:0] cpu_data_out,
    //% 从内存中传入的数据是否有效。
    input mem_to_dma_valid,
    //% 内存是否准备好接收数据。
    input mem_to_dma_enable,
    //% CPU传入的数据是否有效。
    input cpu_to_dma_valid,
    //% CPU是否准备好接收数据。 
    input cpu_to_dma_enable,
    //% 向内存传出的数据。
    output [3:0] mem_data_in,
    //% 向CPU传出的数据。
    output [7:0] cpu_data_in,
    //% DMA是否准备好向内存写数据。
    output dma_to_mem_enable,
    //% DMA向内存写的数据是否有效。
    output dma_to_mem_valid,
    //% DMA是否准备好向CPU写数据。
    output dma_to_cpu_enable,
    //% DMA向CPU写的数据是否有效。
    output dma_to_cpu_valid,
    //% 第一个Buffer。（测试用）
    output [63:0] buff1,
    //% 第二个Buffer。（测试用）
    output [63:0] buff2,
    //% 第一个Buffer的输出（测试用）
    output [7:0] data_out1,
    //% 第二个Buffer的输出（测试用）
    output [7:0] data_out2
);
    //% buffer_size为buffer的大小。
    parameter mem_to_cpu = 0, cpu_to_mem = 1, buff_size = 64;

    //% 记录了传输方向，0为内存到CPU，1为CPU到内存。
    reg direction;

    //% 如果flag为0，buffer1读取输入, buffer2进行输出，若flag为1，buffer2读取输入, buffer1进行输出
    reg flag;

    //% 当reset信号收到时，重置DMA状态并将方向设为dir输入值。
    always @(posedge reset) begin
        direction = dir;
        flag = 0;
    end

    wire [7:0] data_in;
    wire input_valid, input_valid1, input_valid2, output_enable, output_enable1, output_enable2;
    wire input_enable1, input_enable2, output_valid1, output_valid2;
    wire [6:0] blk1, blk2;

    assign data_in = (direction == cpu_to_mem) ? cpu_data_out: {4'b0, mem_data_out};
    assign input_valid = (direction == cpu_to_mem) ? cpu_to_dma_valid: mem_to_dma_valid;
    assign output_enable = (direction == cpu_to_mem) ? mem_to_dma_enable: cpu_to_dma_enable;
    assign input_valid1 = input_valid & !flag;
    assign input_valid2 = input_valid & flag;
    assign output_enable1 = output_enable & flag;
    assign output_enable2 = output_enable & !flag;

    //% 第一个buffer，将被先使用。
    buffer buffer1(
        .clk(clk), .reset(reset), .dir(direction), .data_in(data_in), .input_valid(input_valid1), .output_enable(output_enable1),
        .data_out(data_out1), .input_enable(input_enable1), .output_valid(output_valid1), .blk(blk1),
        .buffer(buff1));

    //% 第一个buffer，在第一个buffer满了后启用，buffer1将向外界输出。
    buffer buffer2(
        .clk(clk), .reset(reset), .dir(direction), .data_in(data_in), .input_valid(input_valid2), .output_enable(output_enable2),
        .data_out(data_out2), .input_enable(input_enable2), .output_valid(output_valid2), .blk(blk2),
        .buffer(buff2));

    //% 若两个buffer，一个满了，另一个空了，将交换buffer的输入输出。
    always @(posedge clk) begin
        if (!flag) begin
            if (blk1 == buff_size && blk2 == 0) begin
                flag = 1;
            end
        end else begin
            if (blk2 == buff_size && blk1 == 0) begin
                flag = 0;
            end
        end
    end

    assign cpu_data_in = direction ? 0 : (flag ? data_out1 : data_out2);
    assign mem_data_in = direction ? (flag ? data_out1[3:0] : data_out2[3:0]) : 0;

    assign dma_to_mem_enable = (direction == mem_to_cpu) && (flag ? input_enable2: input_enable1);
    assign dma_to_cpu_valid = (direction == mem_to_cpu) && (flag ? output_valid1: output_valid2);
    assign dma_to_cpu_enable = (direction == cpu_to_mem) && (flag ? input_enable2: input_enable1);
    assign dma_to_mem_valid = (direction == cpu_to_mem) && (flag ? output_valid1: output_valid2);
endmodule
