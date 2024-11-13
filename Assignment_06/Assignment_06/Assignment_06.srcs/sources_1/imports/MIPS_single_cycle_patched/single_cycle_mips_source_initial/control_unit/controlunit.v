module controlunit (
        input  wire [5:0]  opcode,
        input  wire [5:0]  funct,
        output wire        branch,
        output wire        jump,
        output wire        reg_dst,
        output wire        we_reg,
        output wire        alu_src,
        output wire        we_dm,
        output wire        dm2reg,
        output wire [3:0]  alu_ctrl, // EDIT: CHANGED NUMBER OF BITS 
        // EDIT: ADDED NEW INPUT AND OUTPUTS 
        input  wire [4:0]  shamt,
        output wire        jal,
        output wire        jr,
        output wire        mfhi,
        output wire        mflo
    );
    
    wire [1:0] alu_op;

    // EDIT: ADDED NEW OUTPUT 
    maindec md (
        .opcode         (opcode),
        .branch         (branch),
        .jump           (jump),
        .reg_dst        (reg_dst),
        .we_reg         (we_reg),
        .alu_src        (alu_src),
        .we_dm          (we_dm),
        .dm2reg         (dm2reg),
        .alu_op         (alu_op), 
        .jal            (jal)
    );

    // EDIT: ADDED NEW INPUT AND OUTPUTS 
    auxdec ad (
        .alu_op         (alu_op),
        .funct          (funct),
        .alu_ctrl       (alu_ctrl), 
        .jr             (jr), 
        .mfhi           (mfhi), 
        .mflo           (mflo)
    );

endmodule