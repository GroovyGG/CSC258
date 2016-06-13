`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module mux(LEDR, SW);
   input [9:0] SW;
   output [9:0] LEDR;

   mux2to1 u0(
              .x(SW[0]),
              .y(SW[1]),
              .s(SW[9]),
              .m(LEDR[0])
              );
endmodule

module mux2to1(x, y, s, m);
   input x; //selected when s is 0
   input y; //selected when s is 1
   input s; //select signal
   output m; //output
   
   assign m = s & y | ~s & x;
   // OR
   // assign m = s ? y : x;

endmodule


module mux4to1(u, v, w, x, s0, s1, m);
   input u, v, w, x;
   input s0, s1;
   output m;
   wire   m0, m1;

   mux2to1 u0(
              .x(u),
              .y(v),
              .s(s0),
              .m(m0)
              );
   mux2to1 u1(
              .x(w),
              .y(x),
              .s(s0),
              .m(m1)
              );
   mux2to1 u2(
              .x(m0),
              .y(m1),
              .s(s1),
              .m(m)
              );

endmodule
