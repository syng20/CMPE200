`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 03:23:50 PM
// Design Name: 
// Module Name: mux3
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


module mux3 #(parameter WIDTH = 8)(
    input  wire [1:0]       sel,
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [WIDTH-1:0] c,
    output reg  [WIDTH-1:0] y
    );
    
    always @(sel, a, b, c) begin 
        case(sel) 
            2'b00: y = a; 
            2'b01: y = b; 
            2'b10: y = c; 
            default: y = a; 
        endcase
    end 
    
endmodule
