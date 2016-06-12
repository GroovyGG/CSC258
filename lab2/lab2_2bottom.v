module adder(A, B, C, S, X);
  input A, B, C;
  output S, X;

  wire select, xorABC, notSelect, bSelect, cSelect;
  assign select = A & ~B | B & ~A;
  assign S = select & ~B | B & ~select;
  assign notSelect = ~select;
  assign bSelect = B & notSelect;
  assign cSelect = C & notSelect;
  assign X = bSelect | cSelect;

endmodule
