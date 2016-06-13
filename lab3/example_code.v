`timescale 1ns / 1ns // `timescale time_unit/time_precision

// Example code for CSC258 Summer 2016.
// The 7-segment displays HEX0 and HEX1 will display the hexadecimal numbers
// from SW[3:0] and SW[7:4] respectively.
// The LEDR[7:0] will display the 8-bit output of the single instance of our dummy_alu module.

module example_code(SW, LEDR, HEX0, HEX1);

    input [9:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1;
    
    wire [7:0] alu_out;
    
    dummy_alu alu1(.A(SW[7:4]), .B(SW[3:0]), 
	                .alu_function(SW[9:8]), .result(alu_out));
    
    assign LEDR = {2'b00, alu_out};
    hex_decoder h1(.hex_digit(SW[3:0]), .segments(HEX0));
    hex_decoder h2(.hex_digit(SW[7:4]), .segments(HEX1));
    

endmodule

// This is a dummy_alu module. Notice how we instantiate the
// logic_block1 module *outside* our always block and use the 8-bit wide net 
// l1_connection when alu_function is 0.
// This is similar to what you needed to do for Lab 2 where you were asked to 
// use your previously implemented full adder in your ALU.

module dummy_alu(A, B, alu_function, result);

    input [3:0] A;
    input [3:0] B;
    input [1:0] alu_function;
    output reg [7:0] result;

    wire [7:0] l1_connection;
    logic_block1 l1(.C(A), .D(B), .Y(l1_connection));    
    
    always @(*)
    begin
        case (alu_function)
            2'd0: result = l1_connection;
            2'd1: result = 8'hFF;
            default: result = 8'h00;
        endcase
    end        
    
endmodule

// This module is instantiated within the dummy_alu module. 
module logic_block1(C, D, Y);
    input [3:0] C;
    input [3:0] D;
    output [7:0] Y;
    
    assign Y = {C, D}; // Using concatenation.
endmodule

// One implementation of a hex decoder module using a case statement in an 
// always block. 

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule


    