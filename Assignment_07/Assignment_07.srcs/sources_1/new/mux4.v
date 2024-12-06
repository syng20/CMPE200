`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 01:46:34 PM
// Design Name: 
// Module Name: mux4
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


module mux4 #(parameter WIDTH = 8)(
    input  wire [1:0]       RdSel,
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [WIDTH-1:0] c,
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] y
    );
    
    always @(RdSel) begin 
        case(RdSel) 
            2'b00: y = a; 
            2'b01: y = b; 
            2'b10: y = c; 
            2'b11: y = d; 
            default: y = a; 
        endcase
    end 
    
    
    
endmodule
