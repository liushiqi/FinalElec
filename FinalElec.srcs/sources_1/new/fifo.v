`timescale 1ns / 1ps

/**
 * FIFO chip.
 * @param clk clock input.
 * @param rst reset signal.
 * @param dir direction of fifo, will be changed when rst received.
 * @param narrow_port the 4-bit wide port, if direction is 1, it is input port, otherwise is output port.
 * @param wide_port the wide port, behavior is different from narrow_port.
 */
module fifo(
  input clk, rst, dir,
  inout [3:0] narrow_port,
  inout [7:0] wide_port,
  input input_valid, output_enable,
  output reg input_enable, output_valid
);
  reg [63:0] buffer;
  reg [64:0] width;
  reg [7:0] narrow_buffer;
  reg [8:0] narrow_width;
  reg direction;
  reg [3:0] narrow_port_data;
  reg [7:0] wide_port_data;

  assign narrow_port = narrow_port_data;
  assign wide_port = wide_port_data;

  /**
   * Reset part
   */
  always @(posedge rst) begin
    direction <= dir;
    input_enable <= 1;
    output_valid <= 0;
    buffer <= 0;
    width <= 1;
    narrow_buffer <= 0;
    narrow_width <= 1;
  end

  /**
   * Clock part.
   */
  always @(posedge clk) begin
    /**
     * direction equals 1, narrow is input.
     * direction equals 0, wide is input.
     */
    if (direction) begin
      if (input_valid & input_enable) begin
        narrow_buffer <= narrow_buffer >> 4;
        narrow_buffer[7:4] <= narrow_port;
        narrow_width <= narrow_width << 4;
        if (narrow_width[8]) begin
          buffer <= buffer << 8;
          width <= width << 8;
          buffer[7:0] <= narrow_buffer;
          narrow_buffer <= 0;
          narrow_width <= 1;
          if (width[64]) begin
            input_enable <= 0;
            output_valid <= 1;
            width <= 1;
          end
        end
      end else if (output_valid & output_enable) begin
        wide_port_data <= buffer[63:56];
        buffer <= buffer << 8;
        width <= width << 8;
        if (width[64]) begin
          input_enable <= 1;
          output_valid <= 0;
          width <= 1;
        end
      end
    end else begin
      if (input_valid & input_enable) begin
        buffer <= buffer << 8;
        width <= width << 8;
        buffer[7:0] <= wide_port;
        if (width[64]) begin
          input_enable <= 0;
          output_valid <= 1;
          width <= 1;
        end
      end else if (output_valid & output_enable) begin
        if (narrow_width[8]) begin
          narrow_buffer <= buffer[63:56];
          buffer <= buffer << 8;
          width <= width << 8;
        end
        narrow_port_data <= narrow_buffer[3:0];
        narrow_buffer <= narrow_buffer >> 4;
        narrow_width <= narrow_width << 4;
        if (width[64]) begin
          input_enable <= 1;
          output_valid <= 0;
          width <= 1;
        end
      end
    end
  end
endmodule // fifo
