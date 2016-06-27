`timescale 1ns / 1ns // `timescale time_unit/time_precision

module p1(KEY, SW, HEX0, HEX1);
   input [3:0] KEY;
   input [9:0] SW;
   output [6:0] HEX0, HEX1;
   wire [7:0]   Q, Q_;

   HEX h0(.data(Q[7:4]), .HEX0(HEX0));
   HEX h1(.data(Q[3:0]), .HEX0(HEX1));

   counter c(.En(SW[1]), .Cb(SW[0]), .C(KEY[0]), .Q(Q), .Q_(Q_));
endmodule // p1

module counter(En, Cb, C, Q, Q_);
   input En, Cb, C;
   output [7:0] Q, Q_;
   wire         w1, w2, w3, w4, w5, w6, w7;

   assign w1 = En & Q[0];
   assign w2 = w1 & Q[1];
   assign w3 = w2 & Q[2];
   assign w4 = w3 & Q[3];
   assign w5 = w4 & Q[4];
   assign w6 = w5 & Q[5];
   assign w7 = w6 & Q[6];
   Tflipflop t0(.T(En), .Cb(Cb), .C(C), .Q(Q[0]), .Q_(Q_[0]));
   Tflipflop t1(.T(w1), .Cb(Cb), .C(C), .Q(Q[1]), .Q_(Q_[1]));
   Tflipflop t2(.T(w2), .Cb(Cb), .C(C), .Q(Q[2]), .Q_(Q_[2]));
   Tflipflop t3(.T(w3), .Cb(Cb), .C(C), .Q(Q[3]), .Q_(Q_[3]));
   Tflipflop t4(.T(w4), .Cb(Cb), .C(C), .Q(Q[4]), .Q_(Q_[4]));
   Tflipflop t5(.T(w5), .Cb(Cb), .C(C), .Q(Q[5]), .Q_(Q_[5]));
   Tflipflop t6(.T(w6), .Cb(Cb), .C(C), .Q(Q[6]), .Q_(Q_[6]));
   Tflipflop t7(.T(w7), .Cb(Cb), .C(C), .Q(Q[7]), .Q_(Q_[7]));
endmodule // counter   

module Tflipflop(T, Cb, C, Q, Q_);
   input T, Cb, C;
   output reg Q, Q_;

   always@(posedge C, negedge Cb) begin
      if (T) begin
         Q <= ~Q;
         Q_ <= Q;
      end
      if (~Cb) begin
         Q <= 0;
         Q_ <= 1;
      end
   end
endmodule // Tflipflop

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

