//% @file fifo.v
//% @brief First in first out memory module.
//% 
//% @author Liu Shiqi<liushiqi17@mails.ucas.ac.cn>,
//%         Li Feidong
//% @version 0.1.0
//% @date 2019-01-08

`timescale 1ns / 1ps

//% FIFO chip of fifferent data width with two directions. The direction will be determined when rst is set to 1.
//% if direction is 0, data will be sent from narrow_port to wide_port, if direction is 1, the behavior is different.
module fifo(
  //% the status of fifo will be updated at the edge of clock signal.
  //% clock input.
  input clk,
  //% The buffer will be set to 0 if reset. direction will be changed.
  //% reset signal.
  input rst,
  //% if is 0, data will flow from wide to narrow. if is 1, data will flow from narrow to wide.
  //% controls the direction of fifo.
  input dir,
  //% the input narrow port with 4 bits.
  input [3:0] narrow_port_in,
  //% the input wide port with 8 bits.
  input [7:0] wide_port_in,
  //% the output narrow port with 4 bits.
  output reg [3:0] narrow_port_out,
  //% the output wide port with 8 bits.
  output reg [7:0] wide_port_out,
  //% indicating whether enable input.
  input input_valid,
  //% indicating whether enable output.
  input output_enable,
  //% indicate whether the input could be used.
  output reg input_enable,
  //% indicate whether the output could be used.
  output reg output_valid
);
  //% the buffer storage.
  reg [63:0] buffer;
  //% indicate the position recent reading.
  reg [56:0] width;
  //% the temprary buffer storaging some part of data.
  reg [7:0] narrow_buffer;
  //% the position of temprary storage.
  reg [8:0] narrow_width;
  reg direction;

  //% the reg direction will be set to the input dir.
  //% Reset part.
  always @(posedge rst) begin
    direction <= dir;
    input_enable <= 1;
    output_valid <= 0;
    buffer <= 0;
    width <= 1;
    narrow_buffer <= 0;
    narrow_width <= 1;
    narrow_port_out <= 0;
    wide_port_out <= 0;
  end

  //% if direction equals 1, narrow is input.
  //% if direction equals 0, wide is input.
  //% Clock part.
  always @(posedge clk) begin
    if (direction) begin
      if (input_valid & input_enable) begin
        narrow_buffer <= narrow_buffer >> 4;
        narrow_buffer[7:4] <= narrow_port_in;
        narrow_width <= narrow_width << 4;
        if (narrow_width[8]) begin
          width <= width << 8;
          buffer <= buffer << 8;
          buffer[7:0] <= narrow_buffer;
          narrow_buffer[7:4] <= narrow_port_in;
          narrow_width <= 0'b000010000;
          if (width[56]) begin
            input_enable <= 0;
            output_valid <= 1;
            width <= 1;
          end
        end
        narrow_port_out <= 0;
        wide_port_out <= 0;
      end else if (output_valid & output_enable) begin
        wide_port_out <= buffer[63:56];
        buffer <= buffer << 8;
        width <= width << 8;
        if (width[56]) begin
          input_enable <= 1;
          output_valid <= 0;
          width <= 1;
        end
      end else begin
        narrow_port_out <= 0;
        wide_port_out <= 0;
      end
      narrow_port_out <= 0;
    end else begin
      if (input_valid & input_enable) begin
        buffer <= buffer << 8;
        width <= width << 8;
        buffer[7:0] <= wide_port_in;
        if (width[56]) begin
          input_enable <= 0;
          output_valid <= 1;
          width <= 1;
        end
        narrow_port_out <= 0;
        wide_port_out <= 0;
      end else if (output_valid & output_enable) begin
        if (narrow_width[0]) begin
          narrow_buffer = buffer[63:56];
          narrow_width = 9'b100000000;
          buffer <= buffer << 8;
          width <= width << 8;
          if (width[56]) begin
            input_enable <= 1;
            output_valid <= 0;
            width <= 1;
          end
        end
        narrow_port_out <= narrow_buffer[3:0];
        narrow_buffer <= narrow_buffer >> 4;
        narrow_width <= narrow_width >> 4;
        wide_port_out <= 0;
      end else begin
        narrow_port_out <= 0;
        wide_port_out <= 0;
      end
    end
  end
endmodule // fifo