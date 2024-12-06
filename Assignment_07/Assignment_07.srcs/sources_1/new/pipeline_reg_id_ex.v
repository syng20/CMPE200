`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 05:29:15 PM
// Design Name: 
// Module Name: pipeline_reg_id_ex
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


module pipeline_reg_id_ex(
    input  wire        clk,
    input  wire        rst,
    input  wire        flushE, 
    input  wire        dm2reg_in,
    input  wire        we_dm_in,
    input  wire        branch_in,
    input  wire        alu_src_in,
    input  wire  [3:0] alu_ctrl_in,
    input  wire        we_reg_in,
    input  wire        reg_dst_in,
    input  wire        jump_in,
    input  wire        jr_in,
    input  wire        jal_in,
    input  wire        mflo_in,
    input  wire        mfhi_in,
    input  wire [31:0] pc_plus4_in,
    input  wire [31:0] sext_imm_in,
    input  wire [31:0] rd1_in,
    input  wire [31:0] rd2_in,
    input  wire [31:0] instr_in, 
    output reg         dm2reg_out,
    output reg         we_dm_out,
    output reg         branch_out,
    output reg         alu_src_out,
    output reg   [3:0] alu_ctrl_out,
    output reg         we_reg_out,
    output reg         reg_dst_out,
    output reg         jump_out,
    output reg         jr_out,
    output reg         jal_out,
    output reg         mflo_out,
    output reg         mfhi_out,
    output reg  [31:0] pc_plus4_out,
    output reg  [31:0] sext_imm_out,
    output reg  [31:0] rd1_out,
    output reg  [31:0] rd2_out,
    output reg  [31:0] instr_out
    );    
    
    always @(posedge clk, posedge rst, posedge flushE) begin
        
        if (rst || flushE) begin 
            dm2reg_out = 0; 
            we_dm_out = 0; 
            branch_out = 0; 
            alu_src_out = 0; 
            alu_ctrl_out = 3'b0; 
            we_reg_out = 0; 
            reg_dst_out = 0; 
            jump_out = 0; 
            jr_out = 0; 
            jal_out = 0; 
            mflo_out = 0; 
            mfhi_out = 0; 
            pc_plus4_out = 32'b0;
            sext_imm_out = 0; 
            rd1_out = 0; 
            rd2_out = 0; 
            instr_out = 32'b0; 
        end 
        else begin 
            dm2reg_out = dm2reg_in; 
            we_dm_out = we_dm_in;
            branch_out = branch_in;
            alu_src_out = alu_src_in;
            alu_ctrl_out = alu_ctrl_in;
            we_reg_out = we_reg_in;
            reg_dst_out = reg_dst_in;
            jump_out = jump_in;
            jr_out = jr_in;
            jal_out = jal_in;
            mflo_out = mflo_in;
            mfhi_out = mfhi_in;
            pc_plus4_out = pc_plus4_in;
            sext_imm_out = sext_imm_in;
            rd1_out = rd1_in;
            rd2_out = rd2_in;
            instr_out = instr_in;
        end 
        
    end 
    
endmodule
