`timescale 1ns / 1ps

module fifo48_test();
    reg clk, reset, input_valid, output_enable;
    reg [3:0] data_in;
    wire [7:0] data_out;
    wire input_enable, output_valid;

    fifo_4_to_8 uut48(
        .clk(clk), .reset(reset),
        .data_in(data_in), .input_valid(input_valid), .output_enable(output_enable),
        .data_out(data_out), .input_enable(input_enable), .output_valid(output_valid)
    );

    always #10 clk = ~clk;
    initial begin
        clk = 0; reset = 1;
        input_valid = 0; output_enable = 0;
        #1 reset = 0;
    end

    always @ (posedge clk) begin
        {input_valid, output_enable} = {$random};
        data_in = {$random};
    end
endmodule
