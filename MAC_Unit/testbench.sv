`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module MAC_Unit_tb;

    parameter DATA_WIDTH = 16;
    parameter ACC_WIDTH = 32;
    parameter LUT_SIZE = 256;

    logic clk;
    logic reset;
    logic signed [DATA_WIDTH-1:0] multiplier;
    logic signed [DATA_WIDTH-1:0] multiplicand;
    logic valid;
    logic clear;
    logic signed [ACC_WIDTH-1:0] result;

    logic signed [ACC_WIDTH-1:0] expected_result;
    logic signed [DATA_WIDTH*2-1:0] expected_product;

    MAC_Unit #(DATA_WIDTH, ACC_WIDTH, LUT_SIZE) dut (
        .clk(clk),
        .reset(reset),
        .multiplier(multiplier),
        .multiplicand(multiplicand),
        .valid(valid),
        .clear(clear),
        .result(result)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task apply_inputs(input signed [DATA_WIDTH-1:0] mult1, 
                      input signed [DATA_WIDTH-1:0] mult2, 
                      input bit clr, input bit val);
        begin
            multiplier = mult1;
            multiplicand = mult2;
            clear = clr;
            valid = val;
            #10;
        end
    endtask

    initial begin
        reset = 1;
        multiplier = 0;
        multiplicand = 0;
        valid = 0;
        clear = 0;
        expected_result = 0;
        #15 reset = 0;

        apply_inputs(16'sd10, 16'sd20, 0, 1);
        expected_product = 10 * 20;
        expected_result += expected_product;
        assert(result == expected_result) else $fatal("Test failed: result = %0d, expected = %0d", result, expected_result);

        apply_inputs(-16'sd15, 16'sd25, 0, 1);
        expected_product = -15 * 25;
        expected_result += expected_product;
        assert(result == expected_result) else $fatal("Test failed: result = %0d, expected = %0d", result, expected_result);

        apply_inputs(16'sd5, -16'sd8, 0, 1);
        expected_product = 5 * -8;
        expected_result += expected_product;
        assert(result == expected_result) else $fatal("Test failed: result = %0d, expected = %0d", result, expected_result);

        apply_inputs(0, 0, 1, 1);
        expected_result = 0;
        assert(result == expected_result) else $fatal("Test failed after clear: result = %0d, expected = %0d", result, expected_result);

        apply_inputs(-16'sd30, -16'sd2, 0, 1);
        expected_product = -30 * -2;
        expected_result += expected_product;
        assert(result == expected_result) else $fatal("Test failed: result = %0d, expected = %0d", result, expected_result);

        valid = 0;
        #20;

        $display("All tests passed!");
        $stop;
    end

endmodule
