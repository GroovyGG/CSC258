module top (O, P, Q, Y);
  input [0:3] O, P;
  input Q;
  output Y;

  adder add1(.A(O[0]), .B(P[0]), .C(Q), .S(zero), .X(next1));
  adder add2(.A(O[1]), .B(P[1]), .C(next1), .S(one), .X(next2));
  adder add3(.A(O[2]), .B(P[2]), .C(next2), .S(two), .X(next3));
  adder add4(.A(O[3]), .B(P[3]), .C(next3), .S(three), .X(Y));
endmodule
