`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2024 09:11:51 PM
// Design Name: 
// Module Name: sr_latch
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


module sr_latch(
    input  wire        clk,
    input  wire        rst,
    input  wire        S,
    input  wire        R,
    output reg         Q
    );
    
    always @(posedge clk, posedge rst) begin 
    
        if (rst) Q <= 1'b0; 
        else Q <= (~R) & (S | R); 
    
    end 
    
    
endmodule
