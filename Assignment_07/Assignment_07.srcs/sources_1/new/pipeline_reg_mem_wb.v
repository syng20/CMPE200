`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 05:29:15 PM
// Design Name: 
// Module Name: pipeline_reg_mem_wb
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


module pipeline_reg_mem_wb(
    input  wire        clk,
    input  wire        rst,
    input  wire        dm2reg_in,
    input  wire        we_reg_in,
    input  wire  [4:0] wa_rf_in,
    input  wire        jal_in,
    input  wire        mfhi_in,
    input  wire        mflo_in,
    input  wire [31:0] pc_plus4_in,
    input  wire [31:0] rd_dm_in,
    input  wire [31:0] alu_out_in,
    input  wire [31:0] lo_reg_in, 
    input  wire [31:0] hi_reg_in, 
    output reg         dm2reg_out,
    output reg         we_reg_out,
    output reg   [4:0] wa_rf_out, 
    output reg         jal_out,
    output reg         mfhi_out,
    output reg         mflo_out,
    output reg  [31:0] pc_plus4_out,
    output reg  [31:0] rd_dm_out,
    output reg  [31:0] alu_out_out,
    output reg  [31:0] lo_reg_out, 
    output reg  [31:0] hi_reg_out
    );
    
    always @(posedge clk, posedge rst) begin 
        
        if (rst) begin 
            dm2reg_out = 0; 
            we_reg_out = 0; 
            wa_rf_out = 0; 
            jal_out = 0; 
            mfhi_out = 0; 
            mflo_out = 0; 
            pc_plus4_out = 0; 
            rd_dm_out = 0; 
            alu_out_out = 0; 
            lo_reg_out = 0; 
            hi_reg_out = 0; 
        end 
        else begin 
            dm2reg_out = dm2reg_in;
            we_reg_out = we_reg_in;
            wa_rf_out = wa_rf_in; 
            jal_out = jal_in;
            mfhi_out = mfhi_in;
            mflo_out = mflo_in;
            pc_plus4_out = pc_plus4_in; 
            rd_dm_out = rd_dm_in; 
            alu_out_out = alu_out_in; 
            lo_reg_out = lo_reg_in; 
            hi_reg_out = hi_reg_in; 
        end 
        
    end 
    
endmodule
