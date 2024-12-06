`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 06:07:36 PM
// Design Name: 
// Module Name: dreg_en
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


module dreg_en # (parameter WIDTH = 32) (
        input  wire             clk,
        input  wire             rst,
        input  wire             en, 
        input  wire [WIDTH-1:0] d,
        output reg  [WIDTH-1:0] q
    );

    always @ (posedge clk, posedge rst, negedge en) begin
        if (rst) q <= 0;
        else if (!en) q <= d; 
    end
endmodule
