`timescale 1ns / 1ps 

module mips (
        input  wire        clk,
        input  wire        rst,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire        we_dmM,
        output wire [31:0] pc_current,
        output wire [31:0] alu_outM,
        output wire [31:0] wd_dmM,
        output wire [31:0] rd3
    );
    
    wire        branch;
    wire        jump;
    wire        reg_dst;
    wire        we_reg;
    wire        alu_src;
    wire        dm2reg;
    wire  [3:0] alu_ctrl;
    // EDIT: CREATED NEW WIRES 
    wire        jal;
    wire        jr;
    wire        mfhi;
    wire        mflo;
    // EDIT 2: MORE WIRES 
    wire        we_dm; 
    wire        pc_src; 
    wire        stallF;
    wire        stallD; 
    wire        flushE; 
    wire        dm2regE; 
    wire [31:0] instrI; 
    wire [31:0] instrE; 
    wire  [1:0] forwardAE; 
    wire  [1:0] forwardBE; 
    wire        we_regM; 
    wire        we_regW; 
    wire  [4:0] wa_rfM; 
    wire  [4:0] wa_rfW; 

    datapath dp (
            .clk            (clk),
            .rst            (rst),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .we_dm          (we_dm), // new
            .alu_src        (alu_src),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl),
            .ra3            (ra3),
            .instr          (instr),
            .rd_dm          (rd_dm),
            .pc_current     (pc_current),
//            .alu_out        (alu_out),
//            .wd_dm          (wd_dm),
            .rd3            (rd3),
            // EDIT: ADDED NEW INPUT SIGNALS 
//            .shamt          (instr[10:6]), 
            .jal            (jal), 
            .jr             (jr), 
            .mfhi           (mfhi), 
            .mflo           (mflo), 
            .we_dmM         (we_dmM), // new from here down
            .wd_dmM         (wd_dmM), 
            .pc_src         (pc_src),
            .stallF         (stallF), 
            .stallD         (stallD), 
            .flushE         (flushE),    
            .dm2regE        (dm2regE),   
            .instrI         (instrI),    
            .instrE         (instrE),    
            .forwardAE      (forwardAE), 
            .forwardBE      (forwardBE), 
            .we_regM        (we_regM), 
            .we_regW        (we_regW), 
            .alu_outM       (alu_outM),  
            .wa_rfM         (wa_rfM),    
            .wa_rfW         (wa_rfW)
        );

    controlunit cu (
            .opcode         (instrI[31:26]),
            .funct          (instrI[5:0]),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .we_dm          (we_dm),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl), 
            // EDIT: ADDED NEW INPUT AND OUTPUS 
            .jal            (jal), 
            .jr             (jr), 
            .mfhi           (mfhi), 
            .mflo           (mflo)
        );
    
    // EDIT 2: NEW HAZARD UNIT AND FORWARDING LOGIC 
        
    hazard_unit hu (
            .dm2regE        (dm2regE), 
            .rsD            (instrI[25:21]),     
            .rtD            (instrI[20:16]),     
            .rtE            (instrE[20:16]),     
            .pc_src         (pc_src),
            .stallF         (stallF),  
            .stallD         (stallD),  
            .flushE         (flushE)
        ); 
    
    forward_unit fu(
            .rsE            (instrE[25:21]),      
            .rtE            (instrE[20:16]),      
            .we_regM        (we_regM),  
            .wa_rfM         (wa_rfM),   
            .we_regW        (we_regW),  
            .wa_rfW         (wa_rfW),   
            .forwardAE      (forwardAE),
            .forwardBE      (forwardBE) 
    
    ); 

endmodule