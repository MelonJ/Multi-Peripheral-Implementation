`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2022 08:54:19 PM
// Design Name: 
// Module Name: Top
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


module Top(clk,display);

input clk;
output [2:0]display;


wire [2:0]display;
wire w1; //connect divider and RGB


  divider_1Hz D1(clk,w1);
  RGB R1(w1,display);
  
endmodule

