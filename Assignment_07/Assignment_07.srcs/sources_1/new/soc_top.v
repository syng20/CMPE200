`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2024 10:24:09 PM
// Design Name: 
// Module Name: soc_top
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

module soc_top (
        input  wire        clk,
        input  wire        rst,
        input  wire  [4:0] ra3,
        input  wire [31:0] gpI1,
        input  wire [31:0] gpI2,
        output wire        we_dm,
        output wire [31:0] pc_current,
        output wire [31:0] instr,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd_dm,
        output wire [31:0] rd3,
        output wire [31:0] gpO1,
        output wire [31:0] gpO2
    );

    
    
    wire        WEM; 
    wire        WE1; 
    wire        WE2; 
    wire  [1:0] RdSel; 
    wire [31:0] dmem_data; 
    wire [31:0] fact_data; 
    wire [31:0] gpio_data; 
    wire [31:0] DONT_USE;

    mips mips (
            .clk            (clk),
            .rst            (rst),
            .ra3            (ra3),
            .instr          (instr),
            .rd_dm          (rd_dm),
            .we_dmM         (we_dm),
            .pc_current     (pc_current),
            .alu_outM       (alu_out),
            .wd_dmM         (wd_dm),
            .rd3            (rd3)
    );

    imem imem (
            .a              (pc_current[7:2]),
            .y              (instr)
    );

    dmem dmem (
            .clk            (clk),
            .we             (we_dm),
            .a              (alu_out[7:2]),
            .d              (wd_dm),
            .q              (dmem_data),
            .rst            (rst)
    );
        
    addr_dec addr (
            .A          (alu_out[11:0]), 
            .WE         (we_dm), 
            .WEM        (WEM), 
            .WE1        (WE1), 
            .WE2        (WE2), 
            .RdSel      (RdSel)
    );
        
    
    fact_top fa (
            .clk        (clk), 
            .rst        (rst), 
            .WE         (WE1), 
            .A          (alu_out[3:2]), 
            .WD         (wd_dm[3:0]), 
            .RD         (fact_data)
    );
    
    
    gpio_top gpio (
            .clk        (clk), 
            .rst        (rst), 
            .WE         (WE1), 
            .A          (alu_out[3:2]), 
            .gpI1       (gpI1), 
            .gpI2       (gpI2), 
            .WD         (wd_dm[3:0]), 
            .RD         (gpio_data),
            .gpO1       (gpO1), 
            .gpO2       (gpO2)
    ); 
    
    
    mux4 rd_mux (
            .RdSel      (RdSel), 
            .a          (dmem_data), 
            .b          (dmem_data), 
            .c          (fact_data), 
            .d          (gpio_data), 
            .y          (rd_dm)
    );
        

endmodule