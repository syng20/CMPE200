`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 11:24:35 PM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(
    input  wire       dm2regE,
    input  wire [4:0] rsD,
    input  wire [4:0] rtD,
    input  wire [4:0] rtE,
    input  wire       pc_src, 
    output reg        stallF,
    output reg        stallD,
    output reg        flushE
    );
    
    wire lwstall; 
    
    assign lwstall = ((rsD == rtE) || (rtD == rtE)) && dm2regE;
    
    always @(lwstall, pc_src) begin
    
        stallF = lwstall; 
        stallD = lwstall; 
        flushE = lwstall | pc_src; 
    
    end 
    
endmodule
