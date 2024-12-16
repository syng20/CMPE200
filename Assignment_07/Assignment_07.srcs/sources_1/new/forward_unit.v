`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 11:24:35 PM
// Design Name: 
// Module Name: forward_unit
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


module forward_unit(
    input  wire  [4:0] rsE,
    input  wire  [4:0] rtE,
    input  wire        we_regM,
    input  wire  [4:0] wa_rfM,
    input  wire        we_regW,
    input  wire  [4:0] wa_rfW,
    output reg   [1:0] forwardAE,
    output reg   [1:0] forwardBE
    );
    
    
    always @(rsE, rtE, we_regM, wa_rfM, we_regW, wa_rfW) begin
        
        // forwardAE
        if (rsE != 0) begin 
            if (we_regM && (wa_rfM == rsE)) forwardAE = 2; 
            else if (we_regW && (wa_rfW == rsE)) forwardAE = 1; 
        end 
        else forwardAE = 0; 
        // forwardBE
        if (rtE != 0) begin 
            if (we_regM && (wa_rfM == rtE)) forwardBE = 2; 
            else if (we_regW && (wa_rfW == rtE)) forwardBE = 1; 
        end 
        else forwardBE = 0; 
    
    end
    
    
endmodule
