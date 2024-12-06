`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 05:29:15 PM
// Design Name: 
// Module Name: pipeline_reg_if_id
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


module pipeline_reg_if_id(
    input  wire        clk,
    input  wire        rst,
    input  wire        stallD,
    input  wire [31:0] pc_plus4_in,
    input  wire [31:0] instr_in,
    output reg  [31:0] pc_plus4_out,
    output reg  [31:0] instr_out
    );
    
    always @(posedge clk, posedge rst, posedge stallD) begin 
    
        if (rst) begin 
            pc_plus4_out = 31'b0; 
            instr_out = 31'b0; 
        end 
        else begin
            if (!stallD) begin
                pc_plus4_out = pc_plus4_in; 
                instr_out = instr_in; 
            end 
        end 
         
    end 
    
endmodule
