`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2022 08:42:39 PM
// Design Name: 
// Module Name: BGR_Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BGR_Top(clk,out);

input clk;
output [2:0] out;


reg [2:0] out;
wire w1; //connect divider and RGB


  divider_1Hz D1(clk,w1);
  RGB R1(w1,out);
  
endmodule
