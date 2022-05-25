`timescale 1ns / 1ps

module BGR_Top(clk,out);

input clk;
output [2:0] out;


reg [2:0] out;
wire w1; //connect divider and RGB


  divider_1Hz D1(clk,w1);
  RGB R1(w1,out);
  
endmodule
