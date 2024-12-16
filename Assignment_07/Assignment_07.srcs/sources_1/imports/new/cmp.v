`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2024 12:33:55 PM
// Design Name: 
// Module Name: cmp
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


module cmp(
    input [3:0] A,
    input [3:0] B,
    output GT
    );
    
    assign GT = (A > B) ? 1:0; 
    
    
endmodule
