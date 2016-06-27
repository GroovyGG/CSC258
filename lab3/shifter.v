`timescale 1ns / 1ns // `timescale time_unit/time_precision

module shifter(SW, KEY, LEDR);

   input [9:0] SW;
   input [3:0] KEY;
   output [7:0] LEDR;

   wire         in, out7, out6, out5, out4, out3, out2, out1, out0; // initial in and outputs
   assign in = KEY[3] & SW[7];

   always @(posedge KEY[0])
     begin

        bitShifter B7(.L(SW[7]), .I(in  ), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(out7));
        bitShifter B6(.L(SW[6]), .I(out7), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(out6));
        bitShifter B5(.L(SW[5]), .I(out6), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(out5));
        bitShifter B4(.L(SW[4]), .I(out5), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(out4));
        bitShifter B3(.L(SW[3]), .I(out4), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(out3));
        bitShifter B2(.L(SW[2]), .I(out3), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(out2));
        bitShifter B1(.L(SW[1]), .I(out2), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(out1));
        bitShifter B0(.L(SW[0]), .I(out1), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(out0));

        assign LERD[7] = out7;
        assign LERD[6] = out6;
        assign LERD[5] = out5;
        assign LERD[4] = out4;
        assign LERD[3] = out3;
        assign LERD[2] = out2;
        assign LERD[1] = out1;
        assign LERD[0] = out0;

     end;

endmodule // shifter

module bitShifter(L, I, S, N, C, R, O);
   // L is load_value, I is input, S is shift, N is load_n, C is clock, R is reset_n, O is output
   input L, I, N;
   output O;
   wire   m1, m2;

   mux2to1 M1(.x(O), .y(I), .s(S), .m(m1));
   mux2to1 M2(.x(L), .y(m1), .s(N), .m(m2));
   Dflipflop F0(
                .d(m2) //input to flip flop
                .q(O) //output from flip flop
                .clock(C) //clock signal
                .reset_n(R) //synchronous active low reset
                );
endmodule // bitShifter

module mux2to1(x, y, s, m);
   input x; //selected when s is 0
   input y; //selected when s is 1
   input s; //select signal
   output m; //output

   assign m = s & y | ~s & x;
   // OR
   // assign m = s ? y : x;
endmodule // mux2to1

module Dflipflop(d, q, clock, reset_n)
  // Triggered every time clock rises
  //always @(posedge clock)
  if (reset_n = = 1’b0) // when reset_n is 0 (note this is tested on every rising clock edge)
    q <= 0; // q is set to 0. Note that the assignment uses <=
  else // when reset_n is not 0
    q <= d; // value of d passes through to output q
endmodule // Dflipflop
