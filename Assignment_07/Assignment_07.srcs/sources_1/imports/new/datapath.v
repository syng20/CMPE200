`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2024 11:07:38 PM
// Design Name: 
// Module Name: datapath
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


module fact_datapath(
    input [5:0] control_signals, 
    input clk,
    output reg [31:0] factorial,
    output done,
    output error
    );
    
    // wires 
    wire go; 
    wire [3:0] n; 
    wire en; 
    wire [3:0] sel_n; 
    wire [3:0] n_prime; 
    wire [31:0] prod_curr; 
    wire [31:0] prod_to_save; 
    wire [31:0] prod_next; 
    
    // assignment 
    assign en = control_signals[5]; 
    assign n = control_signals[4:1]; 
    assign go = control_signals[0];
    
    
    // initial comparator, check for error 
    cmp exceed_twelve (.A(n), .B(12), .GT(error));
    mux which_n (.one(1), .zero(n), .sel(error), .choice(sel_n)); 
    
    // main meat 
    down_count cnt (.D(sel_n), .load_cnt(go), .EN(!go), .clk(clk), .Q(n_prime)); 
    cmp below_one (.A(1), .B(n_prime), .GT(done)); 
    mul multiply (.X(n_prime), .Y(prod_curr), .Z(prod_next)); 
    mux if_one (.one(1), .zero(prod_next), .sel(go), .choice(prod_to_save)); 
    clocked_reg save_prod (.D(prod_to_save), .load_reg(en), .clk(clk), .Q(prod_curr)); 
    
    always @(posedge clk) begin 
        if (done) factorial <= prod_curr; 
    end 
    
    
endmodule
