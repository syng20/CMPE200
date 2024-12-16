`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2024 12:33:55 PM
// Design Name: 
// Module Name: clocked_reg
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


module clocked_reg(
    input [31:0] D,
    input load_reg,
    input clk,
    output reg [31:0] Q
    );
    
    reg [31:0] internal; 
    
    always @(posedge clk) begin
    
        if (load_reg) begin 
            internal <= D; 
            Q <= D; 
        end else begin 
            Q <= internal; 
        end 
        
    end
    
endmodule
