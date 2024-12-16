`timescale 1ns / 1ps 

module datapath (
        input  wire        clk,
        input  wire        rst,
        input  wire        branch,
        input  wire        jump,
        input  wire        reg_dst,
        input  wire        we_reg,
        input  wire        we_dm, 
        input  wire        alu_src,
        input  wire        dm2reg,
        input  wire [3:0]  alu_ctrl, // EDIT: CHANGED NUMBER OF BITS 
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire [31:0] pc_current,
//        output wire [31:0] alu_out,
//        output wire [31:0] wd_dm,
        output wire [31:0] rd3,
        // EDIT: ADDED NEW INPUT SIGNALS 
//       input  wire [4:0]  shamt, 
        input  wire        jal, 
        input  wire        jr,  
        input  wire        mfhi,  
        input  wire        mflo,
        // EDIT 2: NEW OUTPUT SIGNALS 
        output wire        we_dmM,
        output wire [31:0] wd_dmM,
        // EDIT 2: SIGNALS NEEDED FOR OTHER MODULES 
        output wire        pc_src,
        input  wire        stallF, 
        input  wire        stallD, 
        input  wire        flushE, 
        output wire        dm2regE, 
        output wire [31:0] instrI, 
        output wire [31:0] instrE, 
        input  wire  [1:0] forwardAE, 
        input  wire  [1:0] forwardBE, 
        output wire        we_regM, 
        output wire        we_regW, 
        output wire [31:0] alu_outM, 
        output wire  [4:0] wa_rfM, 
        output wire  [4:0] wa_rfW
        
    );
    
    // wires in IF stage
    wire  [4:0] wa_rf;
    wire [31:0] pc_plus4;
    
    // wires in ID stage 
    wire [31:0] pc_plus4I;
    wire [31:0] sext_immI;
    wire [31:0] alu_paI;
    wire [31:0] rd1I; 
    wire [31:0] rd2I; 
    
    
    // wires in EX stage 
    wire        branchE; 
    wire        alu_srcE; 
    wire        we_dmE; 
    wire  [3:0] alu_ctrlE; 
    wire        reg_dstE; 
    wire        jumpE; 
    wire        jrE; 
    wire        jalE; 
    wire        mfloE; 
    wire        mfhiE; 
    wire [31:0] pc_plus4E;
    wire [31:0] sext_immE;
    wire [31:0] ba;
    wire [31:0] btaE;
    wire [31:0] jtaE;
    wire [31:0] alu_paE;
    wire [31:0] alu_pb;
    wire [31:0] alu_outE; 
    wire        zero;
    wire [31:0] alu_hi;
    wire [31:0] alu_lo;
//    wire [31:0] pc_pre_preE; 
    wire  [4:0] wa_rf_pre;
    wire [31:0] hi_regE; // EDIT 2: CHANGED NAMES 
    wire [31:0] lo_regE; // EDIT2: CHANGED NAMES 
    wire        we_regE; 
    wire [31:0] wd_dmE; 
    wire [31:0] rd1E; 
    wire [31:0] rd2E; 
    
    
    // wires in MEM stage 
    wire        dm2regM; 
    wire        branchM; 
    wire        jumpM; 
    wire        jrM; 
    wire        jalM; 
    wire        mfloM; 
    wire        mfhiM; 
    wire [31:0] pc_plus4M;
    wire [31:0] btaM; 
    wire [31:0] pc_pre;
    wire [31:0] pc_next_pre; 
    wire [31:0] pc_next;
    wire [31:0] jtaM;
    wire [31:0] alu_paM; 
    wire [31:0] lo_regM; 
    wire [31:0] hi_regM; 
//    wire [31:0] pc_pre_preM; 
    wire        zeroM; 
    
    
    // wires in WB stage 
    wire        dm2regW; 
    wire        jalW; 
    wire        mfloW; 
    wire        mfhiW; 
    wire [31:0] pc_plus4W;
    wire [31:0] alu_outW; 
    wire [31:0] lo_regW; 
    wire [31:0] hi_regW; 
    wire [31:0] wd_rf;
    wire [31:0] wd_rf_pre;
    wire [31:0] wd_rf_alum; 
    wire [31:0] wd_rf_pre_pre; 
    wire [31:0] rd_dmW;
    
    
    
    assign pc_src = (branchM & zeroM) | jumpM | jrM;
    assign ba = {sext_immE[29:0], 2'b00}; // EDIT 2: ADJUSTED WIRE NAMES AS NEEDED
    assign jtaE = {pc_plus4E[31:28], instrE[25:0], 2'b00}; // EDIT2: CHANGED NAME OF WIRES
    
    
    // --- PC Logic --- //
    // EDIT 2: CHANGED pc_reg TO HAVE AN ENABLE BIT
    dreg_en pc_reg (
            .clk            (clk),
            .rst            (rst),
            .en             (!stallF), 
            .d              (pc_next),
            .q              (pc_current)
        );

    adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4) // EDIT 2: WIRE NAME CHANGE
        );

    adder pc_plus_br (
            .a              (pc_plus4E), // EDIT 2: WIRE NAME CHANGE
            .b              (ba),
            .y              (btaE)
        );

    mux2 #(32) pc_src_mux (
            .sel            (pc_src),
            .a              (pc_plus4),
            .b              (pc_next_pre),
            .y              (pc_next)
        );
    
    // EDIT 2: MOVED JUMP AND JR TO MEM STAGE
    
    // EDIT 2: PIPELINE IF/ID
    pipeline_reg_if_id if_id (
            .clk            (clk),
            .rst            (rst),
            .stallD         (stallD),
            .pc_plus4_in    (pc_plus4),
            .instr_in       (instr),
            .pc_plus4_out   (pc_plus4I), 
            .instr_out      (instrI)
    );
     

    // --- RF Logic --- //
    // EDIT 2: MOVED MUXES TO WB STAGE
    
    
    regfile rf (
            .clk            (clk),
            .we             (we_regW), 
            .ra1            (instrI[25:21]), // EDIT 2: SPLIT
            .ra2            (instrI[20:16]), // EDIT 2: SPLIT
            .ra3            (ra3),
            .wa             (wa_rfW),
            .wd             (wd_rf),
            .rd1            (rd1I), // EDIT 2: SPLIT
            .rd2            (rd2I), 
            .rd3            (rd3),
            .rst            (rst)
        );

    signext se (
            .a              (instrI[15:0]), // EDIT 2: SPLIT
            .y              (sext_immI)
        );

    // EDIT 2: ID/EXE PIPELINE 
    pipeline_reg_id_ex id_ex (
            .clk            (clk),
            .rst            (rst),
            .flushE         (flushE), 
            .dm2reg_in      (dm2reg),
            .we_dm_in       (we_dm),
            .branch_in      (branch),
            .alu_src_in     (alu_src),
            .alu_ctrl_in    (alu_ctrl),
            .we_reg_in      (we_reg),
            .reg_dst_in     (reg_dst),
            .jump_in        (jump),
            .jr_in          (jr),
            .jal_in         (jal),
            .mflo_in        (mflo),
            .mfhi_in        (mfhi),
            .pc_plus4_in    (pc_plus4I),
            .sext_imm_in    (sext_immI),
            .rd1_in         (rd1I),
            .rd2_in         (rd2I),
            .instr_in       (instrI), 
            .dm2reg_out     (dm2regE),
            .we_dm_out      (we_dmE),
            .branch_out     (branchE),
            .alu_src_out    (alu_srcE),
            .alu_ctrl_out   (alu_ctrlE),
            .we_reg_out     (we_regE),
            .reg_dst_out    (reg_dstE),
            .jump_out       (jumpE),
            .jr_out         (jrE),
            .jal_out        (jalE),
            .mflo_out       (mfloE),
            .mfhi_out       (mfhiE),
            .pc_plus4_out   (pc_plus4E),
            .sext_imm_out   (sext_immE),
            .rd1_out        (rd1E),
            .rd2_out        (rd2E),
            .instr_out      (instrE)
    );    
    
    // EX stage
    mux2 #(5) wa_rf_mux (
            .sel            (reg_dstE), // EDIT 2: SPLIT
            .a              (instrE[20:16]), // EDIT 2: SPLIT
            .b              (instrE[15:11]), // EDIT 2: SPLIT
            .y              (wa_rf_pre) // EDIT: NEW WIRE 
        );
    
    // EDIT: ADDED MUXES FOR jal 
    mux2 #(5) wa_rf_jal_mux (
            .sel            (jalE), // EDIT 2: SPLIT
            .a              (wa_rf_pre),
            .b              (5'd31),
            .y              (wa_rf)
        );
    
    // EDIT 2: ADDED FORWARDING LOGIC 
    mux3 #(32) forwardALUA (
            .sel            (forwardAE), 
            .a              (rd1E), 
            .b              (wd_rf_pre), 
            .c              (alu_outM), 
            .y              (alu_paE)
            
        ); 
    mux3 #(32) forwardALUB (
            .sel            (forwardBE), 
            .a              (rd2E), 
            .b              (wd_rf_pre), 
            .c              (alu_outM), 
            .y              (wd_dmE)
            
        ); 


    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (
            .sel            (alu_srcE),
            .a              (wd_dmE),
            .b              (sext_immE),
            .y              (alu_pb)
        );

    // EDIT: ADDED alu_hi AND alu_lo 
    alu alu (
            .op             (alu_ctrlE),
            .shamt          (instrE[10:6]), 
            .a              (alu_paE),
            .b              (alu_pb),
            .zero           (zero),
            .y              (alu_outE),
            .hi             (alu_hi),
            .lo             (alu_lo)
        );
    // EDIT 2: MOVED MUXES DOWN TO WB STAGE
    
    dreg hi_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (alu_hi),
            .q              (hi_regE)
        );
    dreg lo_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (alu_lo),
            .q              (lo_regE)
        );
        
    // EDIT 2: EX/MEM PIPELINE    
    pipeline_reg_ex_mem ex_mem (
            .clk            (clk),
            .rst            (rst),
            .dm2reg_in      (dm2regE),
            .we_dm_in       (we_dmE),
            .we_reg_in      (we_regE),
            .branch_in      (branchE), 
            .jump_in        (jumpE),
            .jr_in          (jrE),
            .jal_in         (jalE),
            .mflo_in        (mfloE),
            .mfhi_in        (mfhiE),
            .pc_plus4_in    (pc_plus4E),
            .bta_in         (btaE), 
            .jta_in         (jtaE),
            .zero_in        (zero), 
            .alu_out_in     (alu_outE),
            .lo_reg_in      (lo_regE),
            .hi_reg_in      (hi_regE),
            .wd_dm_in       (wd_dmE),
            .wa_rf_in       (wa_rf), 
            .alu_pa_in      (alu_paE), 
            .dm2reg_out     (dm2regM),
            .we_dm_out      (we_dmM),
            .we_reg_out     (we_regM),
            .branch_out     (branchM), 
            .jump_out       (jumpM),
            .jr_out         (jrM),
            .jal_out        (jalM),
            .mflo_out       (mfloM),
            .mfhi_out       (mfhiM),
            .pc_plus4_out   (pc_plus4M),
            .bta_out        (btaM),
            .jta_out        (jtaM),
            .zero_out       (zeroM),
            .alu_out_out    (alu_outM),
            .lo_reg_out     (lo_regM),
            .hi_reg_out     (hi_regM),
            .wd_dm_out      (wd_dmM), 
            .wa_rf_out      (wa_rfM), 
            .alu_pa_out     (alu_paM)
    );

    // --- MEM Logic --- //
    // EDIT 2: MOVED HERE 
    mux2 #(32) pc_jmp_mux (
            .sel            (jumpM),
            .a              (pc_pre),
            .b              (jtaM),
            .y              (pc_next_pre)
        );
        
    // EDIT: ADDED MUX FOR jr
    mux2 #(32) pc_jr_mux (
            .sel            (jrM),
            .a              (btaM),
            .b              (alu_paM),
            .y              (pc_pre)
        );
    
    
    // EDIT: CHANGED OUTPUT NAME
    mux2 #(32) wd_rf_mux (
            .sel            (dm2regW),
            .a              (alu_outW),
            .b              (rd_dmW),
            .y              (wd_rf_alum)
        );
        
    // EDIT 2: MEM/WB PIPELINE 
    pipeline_reg_mem_wb mem_wb (
            .clk            (clk),
            .rst            (rst),
            .dm2reg_in      (dm2regM),
            .we_reg_in      (we_regM),
            .wa_rf_in       (wa_rfM),
            .jal_in         (jalM),
            .mfhi_in        (mfhiM),
            .mflo_in        (mfloM),
            .pc_plus4_in    (pc_plus4M),
            .rd_dm_in       (rd_dm), 
            .alu_out_in     (alu_outM),
            .lo_reg_in      (lo_regM),
            .hi_reg_in      (hi_regM),
            .dm2reg_out     (dm2regW),
            .we_reg_out     (we_regW),
            .wa_rf_out      (wa_rfW),
            .jal_out        (jalW),
            .mfhi_out       (mfhiW),
            .mflo_out       (mfloW),
            .pc_plus4_out    (pc_plus4W),
            .rd_dm_out      (rd_dmW),
            .alu_out_out    (alu_outW),
            .lo_reg_out     (lo_regW),
            .hi_reg_out     (hi_regW)
    );
        
        
    // EDIT 2: NEW STAGE
    // --- WB STAGE --- //
    // FROM ALU
    // EDIT: MUXES AND REGS FOR MULT/MFHI/MFLO 
    mux2 #(32) rf_wd_hi_mux (
            .sel            (mfhi),
            .a              (wd_rf_alum),
            .b              (hi_regW),
            .y              (wd_rf_pre_pre)
        );
    mux2 #(32) rf_wd_lo_mux (
            .sel            (mflo),
            .a              (wd_rf_pre_pre),
            .b              (lo_regW),
            .y              (wd_rf_pre)
        );
    
    // FROM REGFILES
    
    mux2 #(32) wd_rf_jal_mux (
            .sel            (jalW), // EDIT 2: SPLIT
            .a              (wd_rf_pre),
            .b              (pc_plus4W),
            .y              (wd_rf)
        ); 

endmodule