`timescale 1ns / 1ps

module LED_LIGHTSHOW(clk, LED0, LED1, keypad_entry);

input clk, keypad_entry;
output [7:0] LED0, LED1; 

wire clk, keypad_entry; //entry from keypad
reg [7:0] LED0, LED1; //LED buses. Each bit is an individual LED
reg [25:0] count; //counter for the clock divider
reg [19:0] count2 = 0; //counter for the duty cycle
reg clkout;
reg led_switch = 0; //switch that determines which LED has high duty cycle and which one has low
reg[19:0] on5 = 943718; //what number the count has to count up to for the LED to have 5% duty cycle
reg[19:0] on90 = 52429; //what number the count has to count up to for the LED to have a 90% duty cycle
parameter ON = 8'b1111_1111; //constant for on
   parameter OFF = 8'b0000_0000; //constant for off (all 0's)

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

//switches between which LEDS will be 90% and which will be 5%
always@(posedge clkout)
begin
    led_switch = ~led_switch;
end

//counter for PWM 
always@(posedge clk)
begin
    count2 <= count2 + 1;
end    


always@(posedge clk)
begin
   if(keypad_entry == 1) //if this module was selected then perform the light show
   begin
        if(led_switch == 1) //if LED 1 was selected
        begin
            
            LED0 <= (on5 >= count2)?ON:OFF; //LED0 has 5% duty cycle
            LED1 <= (on90 >= count2)?ON:OFF; //LED1 has 90% duty cycle
                
        end
        
        else if(led_switch == 0) //otherwise do the opposite
        begin
            
            LED0 <= (on90 >= count2)?ON:OFF; //LED0 has 90% duty cycle
            LED1 <= (on5 >= count2)?ON:OFF;  //LED1 has 5% duty cycle
        end
            
   end  
            
   else if(keypad_entry == 0) //if this module wasnt selected then both LED's should be off
   begin
        
        LED1 <= OFF;
        LED0 <= OFF;
   end
    
end

endmodule


