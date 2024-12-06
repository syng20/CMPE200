`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 01:46:34 PM
// Design Name: 
// Module Name: addr_dec
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


module addr_dec(
    input  wire        WE,
    input  wire [11:0] A,
    output reg         WEM,
    output reg         WE1,
    output reg         WE2,
    output reg   [1:0] RdSel
    );
    
    wire [1:0] c; 
    
    // 0 vs 8 vs 9 
    assign c = {A[11], A[8]}; 
    
    always @(WE, A) begin
        // send to mux 
        RdSel = c; 
        // which memory to enable 
        case (c) 
            2'b00: begin 
                WEM = 1; 
                WE1 = 0; 
                WE2 = 0; 
            end 
            2'b10: begin 
                WEM = 0; 
                WE1 = 1; 
                WE2 = 0; 
            end 
            2'b11: begin 
                WEM = 0; 
                WE1 = 0; 
                WE2 = 1; 
            end 
            default: begin 
                WEM = 0; 
                WE1 = 0; 
                WE2 = 0; 
            end  
        endcase
    end 
    
endmodule
