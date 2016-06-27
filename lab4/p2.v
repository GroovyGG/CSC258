`timescale 1ns / 1ns // `timescale time_unit/time_precision

module p2(CLOCK_50, SW, HEX);
   input CLOCK_50;
   input [9:0] SW;
   output [6:0] HEX;
   wire En;
   wire [3:0] Q;
   wire [27:0] b;

   SWcounter c0(.SW(SW), .C(CLOCK_50), .En(En));

   counter c(.Cl(1'b1), .Pl(1'b0), .En(En), .C(CLOCK_50), .D(4'b0000), .Q(Q));

   HEX h(.data(Q), .HEX0(HEX));

endmodule // p2

module SWcounter(SW, C, En);
   input C;
   input [1:0] SW;
   output      En;
   wire [27:0] r0, r1, r2, r3;
   reg [1:0]   R = 2'b11;
   reg [27:0]  Rate, RateDivider = 0;

   assign r0 = 28'b0000000000000000000000000000;
   /*
   assign r1 = 28'b0010111110101111000001111111;
   assign r2 = 28'b0101111101011110000011111111;
   assign r3 = 28'b1011111010111100000111111111;
    */
   assign r1 = 28'b0000000000000000000000000011;
   assign r2 = 28'b0000000000000000000000000111;
   assign r3 = 28'b0000000000000000000000001111;

   assign En = (RateDivider == 28'b0000000000000000000000000000) ? 1 : 0;

   always@(posedge C) begin
      if (SW != R) begin
         R <= SW;
         RateDivider <= 28'b0000000000000000000000000000;
         
         case(SW)
           2'b00: Rate <= r0;
           2'b01: Rate <= r1;
           2'b10: Rate <= r2;
           2'b11: Rate <= r3;
         endcase // case (SW)
      end
      else if (RateDivider == Rate)
        RateDivider <= 28'b0000000000000000000000000000;
      else
        RateDivider <= RateDivider + 1'b1;
   end // always@ (posedge C)
endmodule // RateDivider

module counter(Cl, Pl, En, C, D, Q);
   input Cl, Pl, En, C;
   input [3:0] D;
   output reg [3:0] Q = 0;

   always@(posedge C)
     if (Cl == 1'b0)
       Q <= 0;
     else if (Pl == 1'b1)
       Q <= D;
     else if (Q == 4'b1111)
       Q <= 0;
     else if (En == 1'b1)
       Q <= Q + 1'b1;
endmodule // counter

module HEX(data, HEX0);
   input [3:0] data;
   output [6:0] HEX0;
   wire         c0, c1, c2 , c3;

   assign c0 = data[3];
   assign c1 = data[2];
   assign c2 = data[1];
   assign c3 = data[0];
   
   assign HEX0[0] = ~c0 & ~c1 & ~c2 &  c3 | ~c0 &  c1 & ~c2 & ~c3 | c0 & ~c1 &  c2 &  c3 |  c0 &  c1 & ~c2 &  c3;
   assign HEX0[1] =  c0 &  c1 &  c2 |  c1 &  c2 & ~c3 |  c0 &  c2 & c3 |  c0 &  c1 & ~c2 & ~c3 | ~c0 &  c1 & ~c2 & c3;
   assign HEX0[2] =  c0 &  c1 &  c2 | ~c0 & ~c1 &  c2 & ~c3 |  c0 & c1 & ~c2 & ~c3;
   assign HEX0[3] = ~c0 & ~c1 & ~c2 &  c3 | ~c0 &  c1 & ~c2 & ~c3 | c1 &  c2 &  c3 |  c0 & ~c1 &  c2 & ~c3;
   assign HEX0[4] = ~c0 &  c3 | ~c0 &  c1 & ~c2 | ~c1 & ~c2 &  c3;
   assign HEX0[5] = ~c0 & ~c1 &  c3 | ~c0 & ~c1 &  c2 | ~c0 &  c2 & c3 |  c0 &  c1 & ~c2 &  c3;
   assign HEX0[6] = ~c0 & ~c1 & ~c2 | ~c0 &  c1 &  c2 &  c3 |  c0 & c1 & ~c2 & ~c3;
endmodule // HEX

