`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2024 09:31:10 PM
// Design Name: 
// Module Name: fact_mux4
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


module fact_mux4 (
    input  wire  [1:0] RdSel,
    input  wire  [3:0] n,
    input  wire        go,
    input  wire [31:0] res,
    input  wire        res_done,
    input  wire        res_err,
    output reg  [31:0] RD
    );
    
    always @(*) begin 
        case(RdSel) 
            2'b00: RD = {28'b0, n}; 
            2'b01: RD = {31'b0, go}; 
            2'b10: RD = {30'b0, res_err, res_done}; 
            2'b11: RD = res; 
            default: RD = 32'bx;  
        endcase
    end 
    
endmodule
