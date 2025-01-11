timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module MAC_Unit #(   
    parameter DATA_WIDTH = 16,   
    parameter ACC_WIDTH = 32,    
    parameter LUT_SIZE = 256    
) 

(
    input logic clk,                    
    input logic reset,                   
    input logic signed [DATA_WIDTH-1:0] multiplier,  
    input logic signed [DATA_WIDTH-1:0] multiplicand, 
    input logic valid,                   
    input logic clear,                   
    output logic signed [ACC_WIDTH-1:0] result   
);

    logic signed [DATA_WIDTH*2-1:0] product; // intermediate product
    logic signed [ACC_WIDTH-1:0] accumulator; // accumulator register

    // LUT to store precomputed partial products
    logic signed [ACC_WIDTH-1:0] lut [0:LUT_SIZE-1]; 

    // initialize LUT with precomputed values (this would typically be done at compile-time)
    initial begin
        // precompute LUT entries for all possible bit combinations (for demo purposes)
        for (int i = 0; i < LUT_SIZE; i++) begin
            lut[i] = i;  // simplified LUT values for demonstration
        end
    end

    // Pipeline stage 1: process multiplier and multiplicand through the LUT
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            product <= '0;
        end else if (valid) begin
            // use a combination of bits from multiplier and multiplicand to form the LUT index
            // example, combining lower 8 bits from multiplier and multiplicand to form the index
            product <= lut[{multiplier[7:0], multiplicand[7:0]}];  // Adjust size as needed
        end
    end
    
    // Pipeline stage 2: ccumulate the result
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            accumulator <= '0;
        end else if (clear) begin
            accumulator <= '0;
        end else if (valid) begin
            accumulator <= accumulator + product;
        end
    end
    
    // output assignment
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= '0;
        end else begin
            result <= accumulator;
        end
    end

endmodule
