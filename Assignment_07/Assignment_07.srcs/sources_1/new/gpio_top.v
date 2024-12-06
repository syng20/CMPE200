`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 01:46:34 PM
// Design Name: 
// Module Name: gpio_top
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


module gpio_top(
    input clk,
    input rst,
    input WE,
    input [1:0] A,
    input [31:0] WD,
    input [31:0] gpI1,
    input [31:0] gpI2,
    output [31:0] RD,
    output [31:0] gpO1,
    output [31:0] gpO2
    );
endmodule
