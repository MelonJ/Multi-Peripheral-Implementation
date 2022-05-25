`timescale 1ns / 1ps

module LCD_Keypad_Top(clk,reset,DATA,E,RS,R_nW,Anode,Segout,Row,Col);

    input clk;
    input reset;
    output DATA;
    output E;
    output RS;
    output R_nW;
    output Anode;
    output Segout;
    inout Row;
    inout Col;
    
    wire clk, reset;
    wire [7:0] DATA;
    wire E, RS, R_nW;
    wire [3:0] Row, Col, Anode;
    wire [6:0] Segout;
    
    LCD L1(clk,reset,DATA,E,RS, R_nW);
    Keypad_Top K1(clk, reset, Row, Col, Anode, Segout); 
    
endmodule
