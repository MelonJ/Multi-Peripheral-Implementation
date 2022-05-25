`timescale 1ns / 1ps

module Project_tb();

    reg [3:0] switch;
    wire [6:0] segment_out;
    
    Seg_Decoder1 SD(switch, segment_out);
    
    initial begin switch = 4'b0000; end //set initial input to display 0
    
    initial begin
        #1 CHECK_SEGMENT_OUT(7'b000_0001); //checking 0
        
        #9 switch = 4'b0001;
        #1 CHECK_SEGMENT_OUT(7'b100_1111); //checking 1
        
        
        #9 switch = 4'b0010;
        #1 CHECK_SEGMENT_OUT(7'b001_0010); //checking 2
        
        
        #9 switch = 4'b0011;
        #1 CHECK_SEGMENT_OUT(7'b000_0110); //checking 3
        
        
        #9 switch = 4'b0100;
        #1 CHECK_SEGMENT_OUT(7'b100_1100); //checking 4
        
        
        #9 switch = 4'b0101;
        #1 CHECK_SEGMENT_OUT(7'b010_0100); //checking 5
        
        
        #9 switch = 4'b0110;
        #1 CHECK_SEGMENT_OUT(7'b010_0000); //checking 6
        
        
        #9 switch = 4'b0111;
        #1 CHECK_SEGMENT_OUT(7'b000_1111); //checking 7
        
        
        #9 switch = 4'b1000;
        #1 CHECK_SEGMENT_OUT(7'b000_0000); //checking 8
        
        
        #9 switch = 4'b1001;
        #1 CHECK_SEGMENT_OUT(7'b000_1100); //checking 9
           
        #9 switch = 4'b1010;
        #1 CHECK_SEGMENT_OUT(7'b000_1000); //checking A
        
        #9 switch = 4'b1011;
        #1 CHECK_SEGMENT_OUT(7'b110_0000); //checking B
        
        #9 switch = 4'b1100;
        #1 CHECK_SEGMENT_OUT(7'b011_0001); //checking C
        
        #9 switch = 4'b1101;
        #1 CHECK_SEGMENT_OUT(7'b100_0010); //checking D
        
        #9 switch = 4'b1110;
        #1 CHECK_SEGMENT_OUT(7'b011_0000); //checking E
        
        #9 switch = 4'b1111;
        #1 CHECK_SEGMENT_OUT(7'b011_1000); //checking F
        
        #9 switch = 4'b0000;
        #1 CHECK_SEGMENT_OUT(7'b000_0000); //checking wrong output for 0
        
        #9 switch = 4'b1110;
        #1 CHECK_SEGMENT_OUT(7'b101_1111); //checking wrong output for E
        
        #9 switch = 4'b0110;
        #1 CHECK_SEGMENT_OUT(7'b111_1111); //checking wrong output for 6
        
        end

//-----------------------------------------------------------------------------------------

task CHECK_SEGMENT_OUT; //task to display signal values and check for inconsistency in the output value
input [6:0] NEXT_SEGMENT_OUT; 
begin $display("switch input = %b\tSegment output = %b", switch, segment_out); 
      if(NEXT_SEGMENT_OUT != segment_out) $display("ERROR at time=%d ns, Error value = %b", $time, segment_out); //throw error is output value is incorrect
end
endtask


