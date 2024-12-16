`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 01:46:34 PM
// Design Name: 
// Module Name: fact_top
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


module fact_top(
    input  wire        clk,
    input  wire        rst,
    input  wire        WE,
    input  wire  [1:0] A,
    input  wire [31:0] WD,
    output wire [31:0] RD
    );
    
    wire        WE1; 
    wire        WE2; 
    wire  [1:0] RdSel; 
    wire        GoPulseCmb; 
    wire  [3:0] n; 
    wire        go; 
    wire        go_pulse; 
    wire        done; 
    wire        err; 
    wire [3:10] nf; 
    wire        res_done; 
    wire        res_err; 
    wire [3:10] res; 
    
    assign GoPulseCmb = WD[0] & WE2; 
    
    fact_ad addr (
            .A          (A), 
            .WE         (WE), 
            .WE1        (WE1), 
            .WE2        (WE2), 
            .RdSel      (RdSel)
    );
    
    dreg_en #(4) n_reg (
            .clk        (clk), 
            .rst        (rst), 
            .en         (WE2), 
            .d          (WD[3:0]), 
            .q          (n)
    ); 
    
    dreg_en #(1) go_reg (
            .clk        (clk), 
            .rst        (rst), 
            .en         (WE2), 
            .d          (WD[0]), 
            .q          (go)
    ); 
    
    dreg #(1) pulse_reg (
            .clk        (clk), 
            .rst        (rst), 
            .d          (GoPulseCmb), 
            .q          (go_pulse)
    ); 
    
    factorial_accelerator fact_acc (
            .clk        (clk), 
            .go         (go), 
            .n          (WD[3:0]),
            .rst        (rst),
            .error      (err), 
            .done       (done), 
            .result     (nf)
    );
    
    sr_latch done_latch (
            .clk        (clk), 
            .rst        (rst), 
            .S          (done), 
            .R          (GoPulseCmb), 
            .Q          (res_done)
    );
    
    sr_latch err_latch (
            .clk        (clk), 
            .rst        (rst), 
            .S          (err), 
            .R          (GoPulseCmb), 
            .Q          (res_err)
    );
    
    dreg_en #(32) res_reg (
            .clk        (clk), 
            .rst        (rst), 
            .en         (done), 
            .d          (nf), 
            .q          (res)
    ); 
    
    fact_mux4 fact_mux (
            .RdSel      (RdSel), 
            .n          (n), 
            .go         (go), 
            .res        (res), 
            .res_done   (res_done), 
            .res_err    (res_err), 
            .RD         (RD)
    ); 
    
    
endmodule
