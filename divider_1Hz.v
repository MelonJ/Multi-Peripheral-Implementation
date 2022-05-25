`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2022 08:38:21 PM
// Design Name: 
// Module Name: divider_1Hz
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


module divider_1Hz(clk,clkout);
input clk;
output clkout;


wire clk;
reg clkout;
reg [25:0] count;


always @(posedge clk) //Sensitivity list depends on clk
begin

   if(count == 50000000)    //count 50 miilion
   begin 
      count <= 0;
      clkout <= ~clkout; //toggles every 50 million
   end
      
   else
   begin
   count <= count + 1;       //otherwise keep counting... :(
   end
   
   
end
endmodule
