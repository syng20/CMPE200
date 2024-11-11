module datapath (
        input  wire        clk,
        input  wire        rst,
        input  wire        branch,
        input  wire        jump,
        input  wire        reg_dst,
        input  wire        we_reg,
        input  wire        alu_src,
        input  wire        dm2reg,
        input  wire [8:0]  alu_ctrl, // EDIT: CHANGED NUMBER OF BITS 
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3,
        // EDIT: ADDED NEW INPUT SIGNALS 
        input  wire        jal, 
        input  wire        jr,  
        input  wire        mfhi,  
        input  wire        mflo
        
    );

    wire [4:0]  wa_rf;
    wire        pc_src;
    wire [31:0] pc_plus4;
    wire [31:0] pc_pre;
    wire [31:0] pc_next;
    wire [31:0] sext_imm;
    wire [31:0] ba;
    wire [31:0] bta;
    wire [31:0] jta;
    wire [31:0] alu_pa;
    wire [31:0] alu_pb;
    wire [31:0] wd_rf;
    wire        zero;
    // new wires 
    wire [31:0] pc_pre_pre; 
    wire [4:0]  wa_rf_pre;
    wire [31:0] wd_rf_pre;
    wire [31:0] alu_hi;
    wire [31:0] alu_lo;
    wire [31:0] wd_rf_alum; 
    wire [31:0] wd_rf_pre_pre; 
    wire [31:0] alu_hi_out; 
    wire [31:0] alu_lo_out; 
    
    assign pc_src = branch & zero;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta = {pc_plus4[31:28], instr[25:0], 2'b00}; // EDIT: CHANGED NAME OF WIRE
    
    
    // --- PC Logic --- //
    dreg pc_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (pc_next),
            .q              (pc_current)
        );

    adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4)
        );

    adder pc_plus_br (
            .a              (pc_plus4),
            .b              (ba),
            .y              (bta)
        );

    mux2 #(32) pc_src_mux (
            .sel            (pc_src),
            .a              (pc_plus4),
            .b              (bta),
            .y              (pc_pre_pre)
        );
    
    mux2 #(32) pc_jmp_mux (
            .sel            (jump),
            .a              (pc_pre),
            .b              (jta),
            .y              (pc_next)
        );
        
    // EDIT: ADDED MUX FOR jr
    mux2 #(32) pc_jr_mux (
            .sel            (jr),
            .a              (jta),
            .b              (alu_pa),
            .y              (pc_pre)
        );
    
     

    // --- RF Logic --- //
    mux2 #(5) wa_rf_mux (
            .sel            (reg_dst),
            .a              (instr[20:16]),
            .b              (instr[15:11]),
            .y              (wa_rf)
        );
    
    // EDIT: ADDED MUXES FOR jal 
    mux2 #(5) wa_rf_jal_mux (
            .sel            (jal),
            .a              (wa_rf_pre),
            .b              (5'd31),
            .y              (wa_rf)
        );
    mux2 #(32) rf_wd_jal_mux (
            .sel            (jal),
            .a              (wd_rf_pre),
            .b              (pc_plus_4),
            .y              (wd_rf)
        );
    
    regfile rf (
            .clk            (clk),
            .we             (we_reg),
            .ra1            (instr[25:21]),
            .ra2            (instr[20:16]),
            .ra3            (ra3),
            .wa             (wa_rf),
            .wd             (wd_rf),
            .rd1            (alu_pa),
            .rd2            (wd_dm),
            .rd3            (rd3),
            .rst            (rst)
        );

    signext se (
            .a              (instr[15:0]),
            .y              (sext_imm)
        );

    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (
            .sel            (alu_src),
            .a              (wd_dm),
            .b              (sext_imm),
            .y              (alu_pb)
        );

    // EDIT: ADDED alu_hi AND alu_lo 
    alu alu (
            .op             (alu_ctrl),
            .shamt          (shamt), 
            .a              (alu_pa),
            .b              (alu_pb),
            .zero           (zero),
            .y              (alu_out),
            .hi             (alu_hi),
            .lo             (alu_lo)
        );
    // EDIT: MUXES AND REGS FOR MULT/MFHI/MFLO 
    mux2 #(32) rf_wd_hi_mux (
            .sel            (mfhi),
            .a              (wd_rf_alum),
            .b              (alu_hi_out),
            .y              (wd_rf_pre_pre)
        );
    mux2 #(32) rf_wd_lo_mux (
            .sel            (mflo),
            .a              (wd_rf_pre_pre),
            .b              (alu_lo_out),
            .y              (wd_rf_pre)
        );
    dreg hi_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (alu_hi),
            .q              (alu_hi_out)
        );
    dreg lo_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (alu_lo),
            .q              (alu_lo_out)
        );

    // --- MEM Logic --- //
    // EDIT: CHANGED OUTPUT NAME
    mux2 #(32) wd_rf_mux (
            .sel            (dm2reg),
            .a              (alu_out),
            .b              (rd_dm),
            .y              (wd_rf_alum)
        );

endmodule