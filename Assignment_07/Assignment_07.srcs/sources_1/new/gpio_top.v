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
    input  wire        clk,
    input  wire        rst,
    input  wire        WE,
    input  wire  [1:0] A,
    input  wire [31:0] WD,
    input  wire [31:0] gpI1,
    input  wire [31:0] gpI2,
    output wire [31:0] RD,
    output wire [31:0] gpO1,
    output wire [31:0] gpO2
    );
    
    wire        WE1; 
    wire        WE2; 
    wire  [1:0] RdSel; 
    
    gpio_ad addr (
            .A          (A), 
            .WE         (WE), 
            .WE1        (WE1), 
            .WE2        (WE2), 
            .RdSel      (RdSel)
    );
    
    dreg_en #(32) gp1_reg (
            .clk        (clk), 
            .rst        (rst), 
            .en         (WE1), 
            .d          (WD), 
            .q          (gpO1)
    ); 
    
    dreg_en #(32) gp2_reg (
            .clk        (clk), 
            .rst        (rst), 
            .en         (WE2), 
            .d          (WD), 
            .q          (gpO2)
    ); 
    
    mux4 gpio_mux (
            .RdSel      (RdSel), 
            .a          (gpI1), 
            .b          (gpI2), 
            .c          (gpO1), 
            .d          (gpO2), 
            .y          (RD)
    ); 
    
    
endmodule
