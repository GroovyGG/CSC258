`timescale 1ns / 1ns // `timescale time_unit/time_precision

module p2(SW, KEY, LEDR, HEX0, HEX4, HEX5);   
   input [9:0] SW;
   input [3:0] KEY;
   output reg [7:0] LEDR;
   output reg [6:0] HEX0, HEX4, HEX5;
   reg              A, B, register;

   always @(posedge KEY[0]) // every time the clock changes
     begin

        A = SW;
        
        if (SW[9] == 0) // reset_b == 0
          B = 4'b0000;
        else
          B = register[3:0];

        register = 8b'00000000;

        case (KEY[3:1]);
          0'b000: adder add(.O(A), .P(B), .Y(register[3:0]), .C(register[4]));
          0'b001: register = {4b'0000, A} + {4b'0000, B};
          0'b010: register = {A | B, A ^ B};
          0'b011: register[0] = (A | B) != 4b'0000;
          0'b100: register[0] = (A & B) == 4b'1111;
          0'b101: register = {4b'0000, B} << A;
          0'b110: register = {4b'0000, B} >> A;
          0'b111: register = {4b'0000, A} * {4b'0000, B};
          default: register = 8b'00000000;
        endcase

        LEDR = register;
        HEX hex0(.SW(A), .HEX0(HEX0));
        HEX hex1(.SW(register[3:0]), .HEX0(HEX4));
        HEX hex1(.SW(register[7:4]), .HEX0(HEX5));
        
     end

endmodule // p2

module adder(O, P, Y, C);
   input [3:0] O, P;
   output [3:0] Y;
   output       C;
   wire         c0, c1, c2;
   
   addbit add1(.A(O[0]), .B(P[0]), .C( 0), .S(Y[0]), .X(c0));
   addbit add2(.A(O[1]), .B(P[1]), .C(c0), .S(Y[1]), .X(c1));
   addbit add3(.A(O[2]), .B(P[2]), .C(c1), .S(Y[2]), .X(c2));
   addbit add4(.A(O[3]), .B(P[3]), .C(c2), .S(Y[3]), .X(C ));

endmodule // adder

module addbit(A, B, C, S, X);
   input A, B, C;
   output S, X;
   wire   w;

   assign w = A & ~B | ~A & B;
   assign S = C & ~w | ~C & w;
   assign X = ~w & B | w & C;

endmodule // adder1

module HEX(SW, HEX0);
   input [3:0] SW;
   output [6:0] HEX0;
   wire         c0, c1, c2 , c3;

   assign c0 = SW[0];
   assign c1 = SW[1];
   assign c2 = SW[2];
   assign c3 = SW[3];
   
   assign HEX0[0] = ~c0 & ~c1 & ~c2 &  c3 | ~c0 &  c1 & ~c2 & ~c3 | c0 & ~c1 &  c2 &  c3 |  c0 &  c1 & ~c2 &  c3;
   assign HEX0[1] =  c0 &  c1 &  c2 |  c1 &  c2 & ~c3 |  c0 &  c2 & c3 |  c0 &  c1 & ~c2 & ~c3 | ~c0 &  c1 & ~c2 & c3;
   assign HEX0[2] =  c0 &  c1 &  c2 | ~c0 & ~c1 &  c2 & ~c3 |  c0 & c1 & ~c2 & ~c3;
   assign HEX0[3] = ~c0 & ~c1 & ~c2 &  c3 | ~c0 &  c1 & ~c2 & ~c3 | c1 &  c2 &  c3 |  c0 & ~c1 &  c2 & ~c3;
   assign HEX0[4] = ~c0 &  c3 | ~c0 &  c1 & ~c2 | ~c1 & ~c2 &  c3;
   assign HEX0[5] = ~c0 & ~c1 &  c3 | ~c0 & ~c1 &  c2 | ~c0 &  c2 & c3 |  c0 &  c1 & ~c2 &  c3;
   assign HEX0[6] = ~c0 & ~c1 & ~c2 | ~c0 &  c1 &  c2 &  c3 |  c0 & c1 & ~c2 & ~c3;

endmodule // HEX
