`timescale 1ns / 1ps

module buffer_test();
    reg clk, reset, input_valid, output_enable, dir;
    reg [7:0] data_in;
    wire [3:0] data_out;
    wire input_enable, output_valid;
    wire [6:0] blk;
    wire [63:0] buff;

    buffer uut_buf(
        .clk(clk), .reset(reset), .dir(dir),
        .data_in(data_in), .input_valid(input_valid), .output_enable(output_enable),
        .data_out(data_out), .input_enable(input_enable), .output_valid(output_valid),
        .blk(blk), .buff(buff)
    );

    always #10 clk = ~clk;
    initial begin
        clk = 0; reset = 1; dir = 1;
        input_valid = 0; output_enable = 0;
        #1 reset = 0;
    end

    always @ (posedge clk) begin
        {input_valid, output_enable} = {$random};
        data_in = {$random};
    end
endmodule
