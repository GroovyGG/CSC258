`timescale 1ns / 1ns // `timescale time_unit/time_precision

module p3(CLOCK_50, SW, KEY, LEDR);
   input CLOCK_50;
   input [9:0] SW;
   input [1:0] KEY;
   wire        disp, reset, En, code;
   reg [0:11]  pattern;
   output reg [7:0] LEDR = 0;

   assign disp = KEY[1];
   assign reset = KEY[0];
   counter c(.C(CLOCK_50), .En(En));
   assign code = LEDR[0];
   
   always@(posedge CLOCK_50, posedge disp, posedge reset) begin
      if (!reset) begin
         pattern <= 0;
      end
      else if (disp) begin
         case(SW)
           3'b000: pattern <= 12'b101110000000;
           3'b001: pattern <= 12'b111010101000;
           3'b010: pattern <= 12'b111010111010;
           3'b011: pattern <= 12'b111010100000;
           3'b100: pattern <= 12'b100000000000;
           3'b101: pattern <= 12'b101011101000;
           3'b110: pattern <= 12'b111011101000;
           3'b111: pattern <= 12'b101010100000;
           default: ;
         endcase // case (SW)  
      end
      else if (En) begin
         LEDR[0] <= pattern[0];
         pattern <= pattern << 1;
      end
   end // always@ (posedge CLOCK_50, posedge disp, posedge reset)

endmodule // p3

module counter(C, En);
   input C;
   output      En;
   wire [24:0] Rate;
   reg [24:0]  RateDivider = 0;

   //assign Rate = 25'b1011111010111100000111111;
   assign Rate = 25'b0000000000000000000000010;
   assign En = (RateDivider == 28'b0000000000000000000000000000) ? 1 : 0;

   always@(posedge C) begin
      if (RateDivider == Rate)
        RateDivider <= 28'b0000000000000000000000000000;
      else
        RateDivider <= RateDivider + 1'b1;
   end // always@ (posedge C)
endmodule // RateDivider
