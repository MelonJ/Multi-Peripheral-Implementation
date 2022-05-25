`timescale 1ns / 1ps

module LED_SHOW_TOP(clk, LED0, LED1, keypad_entry);

input clk, keypad_entry;
output LED0, LED1;

wire clk, keypad_entry;
wire [7:0] LED0, LED1;

LED_LIGHTSHOW LED(clk, LED0, LED1, keypad_entry); //intstantiate the LED show module
endmodule


