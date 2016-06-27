`timescale 1ns / 1ns // `timescale time_unit/time_precision

module p2(SW, KEY, LEDR, HEX0, HEX4, HEX5);
   wire t0, clock;
   wire [2:0] Func;
   wire [3:0] A, B, C;
   wire [7:0] AplusB;
   reg [7:0]  register = 0;
   input [3:0] KEY;
   input [9:0] SW;
   output [6:0] HEX0, HEX4, HEX5;
   output [7:0] LEDR;

   assign clock = KEY[0];
   assign Func = KEY[3:1];

   assign A = SW[3:0];
   assign B = register[3:0];
   rippleCarryAdder4 a(.X(A), .Y(B), .Cin(1'b0), .Cout(t0), .S(C));
   assign AplusB = {3'b000, t0, C};
   
   assign LEDR = register;
   HEX h0(.data(A            ), .HEX0(HEX0));
   HEX h4(.data(register[3:0]), .HEX0(HEX4));
   HEX h5(.data(register[7:4]), .HEX0(HEX5));
   
   always@(posedge clock) begin
      if (SW[9])
        register[3:0] <= 4'b1111;
      case (Func)
        3'b000: register <= AplusB;
        3'b001: register <= {4'b0000, A} + {4'b0000, B};
        3'b010: register <= {A | B, A ^ B};
        3'b011:
          if (A | B)
            register <= 8'b00000001;
        3'b100:
          if ((A & B) == 4'b1111)
            register <= 8'b00000001;
        3'b101: register <= {4'b0000, B} >> A;
        3'b110: register <= {4'b0000, B} << A;
        3'b111: register <= {4'b0000, A} * {4'b0000, B};
        default: ;
      endcase // case (KEY[3:1])
   end // always@ (posedge clock)
   
endmodule // p2

module fullAdder(X, Y, Z, C, S);
   input X, Y, Z;
   output C, S;
   
   assign C = (X & Y) | ((X ^ Y) & Z);
   assign S = X ^ Y ^ Z;
endmodule // fullAdder

module rippleCarryAdder4(X, Y, Cin, Cout, S);
   input [3:0] X, Y;
   input       Cin;
   output      Cout;
   output [3:0] S;
   wire         c1, c2, c3;
   
   fullAdder a0(.X(X[0]), .Y(Y[0]), .Z(Cin), .C(c1  ), .S(S[0]));
   fullAdder a1(.X(X[1]), .Y(Y[1]), .Z(c1 ), .C(c2  ), .S(S[1]));
   fullAdder a2(.X(X[2]), .Y(Y[2]), .Z(c2 ), .C(c3  ), .S(S[2]));
   fullAdder a3(.X(X[3]), .Y(Y[3]), .Z(c3 ), .C(Cout), .S(S[3]));
endmodule // rippleCarryAdder4

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
