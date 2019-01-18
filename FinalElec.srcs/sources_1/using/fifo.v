//% @file fifo.v
//% @brief FIFO模块文件。在本文件中，共定义了两个FIFO，其中一个为4位输入8位输出，用于承载从内存到cpu的数据。
//%        另一个为8位输入4位输出，用于承载从cpu到内存的数据。文档由李非东编写。
//% 
//% @author 杨程远 <yangchengyuan17@mails.ucas.ac.cn>,
//% @version 0.1.0
//% @date 2019-01-18

`timescale 1ns / 1ps

//% 4位输入8位输出的fifo模块
module fifo_4_to_8(
    //% fifo的时钟传入
    //% 时钟接口
    input clk,
    //% 重置fifo内部数据，同时，会改变Flag。
    //% 重置接口
    input reset,
    //% 数据传入通道
    input [3:0] data_in,
    //% 来自外部的有效信号，用于控制数据传入
    //% 传入引脚
    input input_valid,
    //% 来自外部的有效信号，用于控制数据传出
    //% 传入引脚
    input output_enable,
    //% 用于数据传出
    //% 数据传出通道
    output reg [7:0] data_out,
    //% 来自fifo的信号，用于表示可以接受数据
    //% 传出引脚
    output reg input_enable,
    //% 来自fifo的信号，用于表示可以传出数据
    //% 传出引脚
    output reg output_valid,
    //% buffer
    output reg [63:0] buffer,
    //% 用于标记数据顶端的指针性质变量
    //% 数据指针
    output reg [6:0] blk
);
    //% 用于翻转fifo模块的输入/输出模式
    //% 翻转指示变量
    reg flag;

    //% 记录了状态信息，位宽信息
    //% 状态指标
    parameter in = 0, out = 1, buff_size = 64, out_size = 8, in_size = 4;

    //% reset部分，等待时钟信号，用于重置fifo的数据。
    always @(posedge reset) begin
        blk = 0;
        buffer = 0;
        flag = in;
        data_out = 0;
        input_enable = 1;
        output_valid = 0;
    end

    //% 读取指针信息，用于翻转输入/输出状态
    always @(posedge clk) begin
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

    //% 数据读写部分
    always @(posedge clk) begin
        #0.1 if (flag == in) begin
            if (input_valid) begin
                input_enable = 1; output_valid = 0;
                buffer[buff_size-1:in_size] <= buffer;
                buffer[in_size-1:0] <= data_in;
                blk <= blk+in_size;
            end else begin
                input_enable = 0; output_valid = 0;
            end
        end else begin
            if (output_enable) begin
                input_enable = 0; output_valid = 1;
                buffer <= buffer << out_size;
                data_out <= buffer[buff_size-1:buff_size-out_size];
                blk <= blk-out_size;
            end else begin
                input_enable = 0; output_valid = 0;
            end
        end
    end
endmodule

//% 8位输入4位输出的fifo模块
module fifo_8_to_4(
    //% fifo的时钟传入
    //% 时钟接口
    input clk,
    //% 重置fifo内部数据，同时，会改变Flag。
    //% 重置接口
    input reset,
    //% 数据传入通道
    input [7:0] data_in,
    //% 来自外部的有效信号，用于控制数据传入
    //% 传入引脚
    input input_valid,
    //% 来自外部的有效信号，用于控制数据传出
    //% 传入引脚
    input output_enable,
    //% 用于数据传出
    //% 数据传出通道
    output reg [3:0] data_out,
    //% 来自fifo的信号，用于表示可以接受数据
    //% 传出引脚
    output reg input_enable,
    //% 来自fifo的信号，用于表示可以传出数据
    //% 传出引脚
    output reg output_valid,
    //% buffer
    output reg [63:0] buffer,
    //% 用于标记数据顶端的指针性质变量
    //% 数据指针
    output reg [6:0] blk
);
    //% 用于翻转fifo模块的输入/输出模式
    //% 翻转指示变量
    reg flag;

    //% 记录了状态信息，位宽信息
    //% 状态指标
    parameter in = 0, out = 1, buff_size = 64, out_size = 4, in_size = 8;

    //% reset部分，等待时钟信号，用于重置fifo的数据
    always @(posedge reset) begin
        blk = 0;
        buffer = 0;
        flag = in;
        data_out = 0;
        input_enable = 1;
        output_valid = 0;
    end
    
    //% 读取指针信息，用于翻转输入/输出状态
    always @(posedge clk) begin	
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
    
    //% 数据读写部分
    always @ (posedge clk) begin
        #0.1 if (flag == in) begin
            if (input_valid) begin
                input_enable = 1; output_valid = 0;
                buffer[buff_size-1:in_size] <= buffer;
                buffer[in_size-1:0] <= data_in;
                blk <= blk+in_size;
            end else begin
                input_enable = 0; output_valid = 0;
            end
        end else begin
            if (output_enable) begin
                input_enable = 0; output_valid = 1;
                buffer <= buffer << out_size;
                data_out <= buffer[buff_size-1:buff_size-out_size];
                blk <= blk-out_size;
            end else begin
                input_enable = 0; output_valid = 0;
            end
        end
    end
endmodule
