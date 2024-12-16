`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2024 12:33:55 PM
// Design Name: 
// Module Name: down_count
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


module down_count(
    input [3:0] D,
    input load_cnt,
    input EN,
    input clk,
    output reg [3:0] Q
    );
    
    // reg [3:0] stored_D; 
    
    // l = load in new 
    // e = count down from loaded
    
    always @(posedge clk) begin 
           
        if (load_cnt) begin 
            Q <= D; 
        end 
        else begin 
            if (EN) begin 
                Q <= Q - 1; 
            end else begin 
                Q <= Q; 
            end
        end 
        
    end 
    
    
endmodule
