module mux(
  input [0:6] Input,
  input [0:2] select,
  output reg out
);
  always @(*) begin
    case (select)
      3’b000 : out = Input[0];
      3’b001 : out = Input[1];
      3’b010 : out = Input[2];
      3’b011 : out = Input[3];
      3’b100 : out = Input[4];
      3’b101 : out = Input[5];
      3’b110 : out = Input[6];
      default : out = Input[0];
    endcase
  end
endmodule
