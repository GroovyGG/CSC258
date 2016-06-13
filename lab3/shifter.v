module shifter(SW, KEY, LEDR)
  input [9:0] SW;
  input [3:0] KEY;
  output [7:0] LEDR;

  wire in; // initial in
  assign in = KEY[3] & SW[7];

  bitShifter B7(.L(SW[7]), .I(in), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(LEDR[7]);
  bitShifter B6(.L(SW[6]), .I(LEDR[7]), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(LEDR[6]);
  bitShifter B5(.L(SW[5]), .I(LEDR[6]), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(LEDR[5]);
  bitShifter B4(.L(SW[4]), .I(LEDR[5]), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(LEDR[4]);
  bitShifter B3(.L(SW[3]), .I(LEDR[4]), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(LEDR[3]);
  bitShifter B2(.L(SW[2]), .I(LEDR[3]), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(LEDR[2]);
  bitShifter B1(.L(SW[1]), .I(LEDR[2]), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(LEDR[1]);
  bitShifter B0(.L(SW[0]), .I(LEDR[1]), .S(KEY[2]), .N(KEY[1]), .C(KEY[0]), .R(SW[9]), .O(LEDR[0]);
endmodule

module bitShifter(L, I, S, N, C, R, O);
  // L is load_value, I is input, S is shift, N is load_n, C is clock, R is reset_n, O is output
  input L, I, N;
  output O;
  wire m1, m2;

  mux2to1 M1(.x(O), .y(I), .s(S), .m(m1));
  mux2to1 M2(.x(L), .y(m1), .s(N), .m(m2));
  Dflipflop F0(
    .d(m2) //input to flip flop
    .q(O) //output from flip flop
    .clock(C) //clock signal
    .reset_n(R) //synchronous active low reset
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

module Dflipflop(d, q, clock, reset_n)
  always @(posedge clock) // Triggered every time clock rises
  begin
    if (reset_n = = 1’b0) // when reset_n is 0 (note this is tested on every rising clock edge)
      q <= 0; // q is set to 0. Note that the assignment uses <=
    else // when reset_n is not 0
      q <= d; // value of d passes through to output q
end