module myFunction(
  input [0:3] A, B, key,
  output [0:7] out
);

  wire outputThree, outputFour, sum, lower, upper;
  always @(*)
  begin
    if (A[0] | A[1] | A[2] | A[3] | A[4] | A[5] | A[6] | A[7] | B[0] | B[1] | B[2] | B[3] | B[4] | B[5] | B[6] | B[7] )
      outputThree = 8'b00000001;
    else
      outputThree = 1'b0;
  end
  always @(*)
  begin
    if (A[0] & A[1] & A[2] & A[3] & A[4] & A[5] & A[6] & A[7] & B[0] & B[1] & B[2] & B[3] & B[4] & B[5] & B[6] & B[7])
      outputFour = 8'b00000001;
    else
      outputFour = 1'b0;
  end
  top add1(.O(A), .P(B), .Q(1'b0), .Y(sum));
  assign lower = {A[0]^B[0], A[1]^B[1], A[2]^B[2], A[3]^B[3]};
  assign upper = {A[0] | B[0], A[1] | B[1], A[2] | B[2], A[3] | B[3]};

  always @(*)
  begin
    case (key)
      3’b000 : out = sum;
      3’b001 : out = A + B;
      3’b010 : out = {lower, upper};
      3’b011 : out = outputThree;
      3'b100 : out = outputFour;
      3'b101 : out = {A, B};
      default: out = 1'b0;
    endcase
  end
endmodule
