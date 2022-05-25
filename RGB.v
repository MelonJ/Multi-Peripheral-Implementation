`timescale 1ns / 1ps


module RGB(clk, BGR);

input clk;
output [2:0] BGR;

reg [2:0]BGR;     //BGR
reg [2:0]state = 3'b000; //uses 3 bits to express 8 combo




  always @(posedge clk) //takes clock signal from 1 Hz
  begin
  state <= state + 1;
  end
  
  always @(state)
  begin
  case(state)//depends on current state
  3'b000: BGR <= 3'b001; //000->R
  
  3'b001: BGR <= 3'b010; //R -> G
  3'b010: BGR <= 3'b011; //G -> GR
  3'b011: BGR <= 3'b100; //GR -> B
  3'b100: BGR <= 3'b101; //B ->BR
  3'b101: BGR <= 3'b110; //BR->BG
  3'b110: BGR <= 3'b111; //BG->BGR
  3'b111: BGR <= 3'b000; //BGR->000 
  endcase
  
  end
    

 
endmodule
