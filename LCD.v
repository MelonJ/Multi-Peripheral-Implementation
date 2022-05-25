`timescale 1ns / 1ps

module LCD(clk,reset,DATA,E,RS, R_nW);

    input clk;
    input reset;
    output DATA;
    output E;
    output RS;
    output R_nW;
    
    //external signals
    wire clk, reset;
    reg[7:0] DATA;
    
    reg E, RS, R_nW;
    reg LED1, LED2, LED3, LED4, LED5, LED6;
    
    //internal signals
    reg[19:0] count;
    reg [15:0] timerCount; //delay count timer
    reg clkout;
    reg [4:0] write_tracker = 5'b01110;
    reg delayOk; //delay finished flag
    reg[4:0] curr_state;
    reg[4:0] next_state;
    
    //defining state machine states
    parameter[4:0]
    wake_up = 1,
    PowerOn = 2,
    PowerOn_delay = 3,
    FunctionSet = 4,
    FunctionSet_delay = 5,
    DisplayCtrl_set = 6,
    DisplayCtrl_set_delay = 7,
    DisplayClear = 8,
    DisplayClear_delay = 9,
    Finished_delay = 10,
    IDLE = 11,
    WRITE = 12,
    write_delay = 13,
    
    //character write states
    WRITE_H = 14,
    WRITE_E = 15,
    WRITE_L = 16,
    WRITE_sL = 17,
    WRITE_O = 18,
    WRITE_SPACE = 19,
    WRITE_W = 20,
    WRITE_sO = 21,
    WRITE_R = 22,
    WRITE_tL = 23,
    WRITE_D = 24;
    
    //1 MHz clock
    always @(posedge clk or posedge reset)
        begin
            if(reset)
                begin
                    count <= 0;
                    clkout <=1'b0;
                end 
            
            else if(count == 50) //50 used to get to a 1 MHz clk
                begin
                    count <= 0;
                    clkout <= ~clkout; //toggle clk out
                end
            
            else count <= (count + 1); //increment clock
            
        end
    
            
    
    //1 MHz counter. Timer for Delays
    always@(posedge clkout or posedge reset)
        begin
            if(reset)
                begin
                    timerCount <= 0;
                end
            else if(curr_state == PowerOn_delay || curr_state <= wake_up) begin
                
                if(timerCount == 40000) 
                    begin
                        timerCount <= 0;
                        delayOk <= 1; //set delayOK 1 to if the count has ended
                    end
            
                else timerCount <= (timerCount + 1);
           
            end 
            
            else if(curr_state == FunctionSet_delay || curr_state == DisplayCtrl_set_delay) begin
                
                
                if(timerCount == 40000) 
                    begin
                        timerCount <= 0;
                        delayOk <= 1; //set delayOK 1 to if the count has ended
                    end
            
                 else timerCount <= (timerCount + 1);
                
            end
            
            else if(curr_state == DisplayClear_delay || curr_state == write_delay) begin
            
                
                if(timerCount == 40000) 
                    begin
                        timerCount <= 0;
                        delayOk <= 1; //set delayOK 1 to if the count has ended
                    end
            
                else timerCount <= (timerCount + 1);
                
            end
            
            else
            begin 
                delayOk <= 0;
                timerCount <= 0;
            end
            
        end
        
        //defining state transition
        always@(posedge clkout or posedge reset)
            begin
                if(reset) curr_state <= wake_up; //reset to initial condition
                
                else curr_state <= next_state; //otherwise increment the next state
            end
        
        //state machine path    
        always@(curr_state or delayOk)
            begin
                case(curr_state)
                    
                    //wake up state to wait for the LCD to reach the Vcc output
                    wake_up:
                        begin
                            if(delayOk == 1'b1) 
                                begin
                                    next_state <= PowerOn;
                                   
                                end
                            
                            else next_state <= wake_up;
                        end
                    
                    PowerOn: 
                        begin
                             //go to the PowerOn_delay state
                             next_state <= PowerOn_delay;
                             LED1 <= 1; 
                             
                        end
                        
                    PowerOn_delay:
                        begin
                            //if delay has happend, go to next state
                            if(delayOk == 1'b1)  
                                begin
                                       next_state <= FunctionSet;
                                     
                                end
                            
                            //otherwise the delay is still happening and wait here
                            else next_state <= PowerOn_delay;
                        end
                        
                    FunctionSet:
                        
                        begin
                            //go to the delay state
                            next_state <= FunctionSet_delay;
                            LED2 <= 1; 
                        end
                        
                    FunctionSet_delay:
                        
                        begin
                        
                            //if delay has happend, go to next state
                            if(delayOk == 1'b1) 
                            begin
                                next_state <= DisplayCtrl_set;
        
                            end
                            
                            //otherwise stay here since the delay is still happening
                            else next_state <= FunctionSet_delay;
                            
                        end
                        
                    DisplayCtrl_set: 
                        
                        begin
                            //go to the displayCTRL state
                            next_state <= DisplayCtrl_set_delay;
                            LED3 <= 1; 
                        end
                        
                        
                    DisplayCtrl_set_delay:
                        
                        begin
                            //if delay is done, go the next state
                           if(delayOk == 1'b1) 
                           begin
                                next_state <= DisplayClear;
                           end
                            
                           //otherwise, stay here since delay is still happening 
                           else next_state <= DisplayCtrl_set_delay;
                        end
                        
                    DisplayClear:
                        
                        begin
                            //go to clear screen delay
                            next_state <= DisplayClear_delay;
                            LED4 <= 1; 
                        end
                     
                     
                     DisplayClear_delay: 
                        
                        begin
                            if(delayOk == 1'b1) 
                            begin
                                next_state <= Finished_delay;
                            end
                            
                            //otherwise delay is still happening
                            else next_state <= DisplayClear_delay;
                        end
                        
                     //One initialization is finished, go to idle   
                     Finished_delay:
                        begin
                            if(delayOk == 1'b1) 
                            begin
                                next_state <= WRITE_H;
                            end
                            
                            else next_state <= Finished_delay;
                        end
                        
                     IDLE: //Idle state after all commands are finished
                        begin
                            next_state <= IDLE;
                            LED5 <= 1; 
                        end
                     
                     //not needed but was used for testing
                     WRITE:
                        begin
                            
                            next_state <= write_delay;
                                        
                        end
                     
                     /*
                        The following states are all for writing characters
                     */   
                     WRITE_H: next_state <= write_delay;
                     
                     WRITE_E: next_state <= write_delay;
                     
                     WRITE_L: next_state <= write_delay;
                     
                     WRITE_sL: next_state <= write_delay;
                     
                     WRITE_O: next_state <= write_delay;
                     
                     WRITE_SPACE: next_state <= write_delay;
                     
                     WRITE_W: next_state <= write_delay;
                     
                     WRITE_sO: next_state <= write_delay;
                     
                     WRITE_R: next_state <= write_delay;
                     
                     WRITE_tL: next_state <= write_delay;
                     
                     WRITE_D: next_state <= IDLE; //once done, go to idle
                         
                    write_delay:
                        begin
                            if(delayOk == 1'b1) //if delay done, move on to next state
                            begin
                                next_state <= write_tracker;
                            end
                            
                            else next_state <= write_delay; //otherwise, stay in this state
                        end
                        
                    //if in none of these states, go to PowerOn
                    default: next_state <= PowerOn;
                    
                 endcase   
            end
            
    always@(posedge clkout or posedge reset)
        begin
            if(reset) DATA <= 8'h3C;
            
            else if(curr_state == PowerOn)
                begin
                    E<= 1'b1;
                    RS<= 1'b0;
                    R_nW<=1'b0;
                    DATA <= 8'h3C;
                    
                end
            
            //commands for function set    
            else if(curr_state == FunctionSet)
                begin
                    E<= 1'b1;
                    RS<= 1'b0;
                    R_nW<=1'b0;
                    DATA <= 8'h3C;
                 
                 end
                 
            //commands for display control             
            else if(curr_state == DisplayCtrl_set)
                begin
                    E<= 1'b1;
                    RS<=1'b0;
                    R_nW<=1'b0;
                    DATA <= 8'h0F; //may be 8'H0C
                  
                end
             
             //commands for display clear           
             else if(curr_state == DisplayClear)
                begin
                    E<= 1'b1;      
                    RS<=1'b0;
                    R_nW<=1'b0;
                    DATA <= 8'h01;
                    
                end    
                
             //not needed but used for testing   
             else if(curr_state == WRITE)
                begin
                    E<= 1'b1;
                    RS <= 1'b1; 
                                    
                end
             
             /*
                All of the following conditionals are used for testing
             */   
             else if(curr_state == WRITE_H)
                begin
                  E<= 1'b1;
                  RS <= 1'b1;
                  DATA <= "H";
                  write_tracker <= write_tracker + 1'b1;
                end  
                
             else if(curr_state == WRITE_E)
                begin
                  E<= 1'b1;
                  RS <= 1'b1;
                  DATA <= "E";
                  write_tracker <= write_tracker + 1'b1;
                end
                
             else if(curr_state == WRITE_L)
                begin
                  E<= 1'b1;
                  RS <= 1'b1;
                  DATA <= "L";
                  write_tracker <= write_tracker + 1'b1;
                end
                
             else if(curr_state == WRITE_sL)
                begin
                  E<= 1'b1;
                  RS <= 1'b1;
                  DATA <= "L";
                  write_tracker <= write_tracker + 1'b1;
                end
                
              else if(curr_state == WRITE_O)
                begin
                  E<= 1'b1;
                  RS <= 1'b1;
                  DATA <= "O";
                  write_tracker <= write_tracker + 1'b1;
                  LED6 <= 1;
                end
                
              else if(curr_state == WRITE_SPACE)
                begin
                  E<= 1'b1;
                  RS <= 1'b1;
                  DATA <= " ";
                  write_tracker <= write_tracker + 1'b1;
                end
                
              else if(curr_state == WRITE_W)
                begin
                  E<= 1'b1;
                  RS <= 1'b1;
                  DATA <= "W";
                  write_tracker <= write_tracker + 1'b1;
                end
                
              else if(curr_state == WRITE_sO)
                begin
                  E<= 1'b1;
                  RS <= 1'b1;
                  DATA <= "O";
                  write_tracker <= write_tracker + 1'b1;
                end
                
              else if(curr_state == WRITE_R)
                begin
                  E<= 1'b1;
                  RS <= 1'b1;
                  DATA <= "R";
                   write_tracker <= write_tracker + 1'b1;
                end
                
              else if(curr_state == WRITE_tL)
                begin
                  E<= 1'b1;
                  RS <= 1'b1;
                  DATA <= "L";
                   write_tracker <= write_tracker + 1'b1;
                end
                
              else if(curr_state == WRITE_D)
                begin
                  E<= 1'b1;
                  RS <= 1'b1;
                  DATA <= "D";
                   write_tracker <= write_tracker + 1'b1;
                end
              
              // idle state that sets outputs all to low and stays in idle  
              else if(curr_state == IDLE)
                begin
                  E<= 1'b0;
                  RS <= 1'b0;
                end
                   
              
              //setting enable to LOW for all delays
              else if(curr_state == PowerOn_delay)
                begin
                    E<=1'b0;
                end
                
              else if(curr_state == FunctionSet_delay)
                begin
                    E<=1'b0;
                end
                
              else if(curr_state == DisplayCtrl_set_delay)
                begin
                    E<=1'b0;
                end
                
              else if(curr_state == DisplayClear_delay)
                begin
                    E<=1'b0;
                end
                
              else if(curr_state == Finished_delay) 
                begin
                    E<=1'b0;
                end
                
              else if(curr_state == wake_up)
                begin
                    E<=1'b0;
                end
                
              else if(curr_state == write_delay)
                begin
                    E<=1'b0;
                    
                end
                
              
              else DATA <= DATA;
              
              
      end          
                

endmodule
