`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2024 10:45:53 PM
// Design Name: 
// Module Name: tb_soc_top
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


module tb_soc_top;


    reg         clk;
    reg         rst;
    wire        we_dm;
    wire [31:0] pc_current;
    wire [31:0] instr;
    wire [31:0] alu_out;
    wire [31:0] wd_dm;
    wire [31:0] rd_dm;
    wire [31:0] DONT_USE;
    wire [31:0] result;
    wire [31:0] DONT_USE_2; 
    
    integer i;
    
    soc_top DUT (
            .clk            (clk),
            .rst            (rst),
            .ra3            (5'h0),
            .gpI1           (32'h4), 
            .gpI2           (32'h0), 
            .we_dm          (we_dm),
            .pc_current     (pc_current),
            .instr          (instr),
            .alu_out        (alu_out),
            .wd_dm          (wd_dm),
            .rd_dm          (rd_dm),
            .rd3            (DONT_USE), 
            .gpO1           (result), 
            .gpO2           (DONT_USE_2) 
        );
    
    task tick; 
    begin 
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end
    endtask

    task reset;
    begin 
        rst = 1'b0; #5;
        rst = 1'b1; #5;
        rst = 1'b0;
    end
    endtask
    
    initial begin
        reset;
        for(i = 0; i < 13; i = i + 1) tick;
        reset;
        i = 0; 
        while(pc_current != 32'h3058) tick;
        tick; 
        tick; 
        tick;
        tick;
        $finish;
    end

endmodule