`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2024 09:53:28 PM
// Design Name: 
// Module Name: factorial_accelerator
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


module factorial_accelerator(
    input clk, 
    input go, 
    input [3:0] n,
    input rst,  
    output wire error, 
    output wire done, 
    output wire [31:0] result 
    );
    
    // internal var  
    wire [5:0] ctrl_sig; 
    wire done_sig; 
    wire error_sig; 
    wire [31:0] res_sig; 
    
    assign error = error_sig; 
    assign done = done_sig;
    assign result = res_sig;
    
    // modules 
    fact_controlunit CU(
            .clk                (clk), 
            .go                 (go), 
            .n                  (n), 
            .rst                (rst), 
            .done_in            (done_sig), 
            .error_in           (error_sig), 
            .control_signal     (ctrl_sig)
    );
    
    fact_datapath DP(
            .control_signals    (ctrl_sig), 
            .clk                (clk), 
            .factorial          (res_sig), 
            .done               (done_sig), 
            .error              (error_sig)
    );
            
    
endmodule
