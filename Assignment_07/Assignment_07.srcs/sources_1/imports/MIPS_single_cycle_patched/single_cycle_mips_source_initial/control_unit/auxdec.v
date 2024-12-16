`timescale 1ns / 1ps 

module auxdec (
        input  wire [1:0] alu_op,
        input  wire [5:0] funct,
        output wire [3:0] alu_ctrl, // EDIT: CHANGED NUMBER OF BITS 
        // EDIT: ADDED NEW OUTPUTS 
        output wire       jr, 
        output wire       mfhi, 
        output wire       mflo
    );

    reg [6:0] ctrl;

    assign {alu_ctrl, jr, mfhi, mflo} = ctrl;

    always @ (alu_op, funct) begin
        case (alu_op)
            2'b00: ctrl = 7'b0010_0_0_0;          // ADD
            2'b01: ctrl = 7'b0110_0_0_0;          // SUB
            default: case (funct)
                6'b10_0100: ctrl = 7'b0000_0_0_0; // AND
                6'b10_0101: ctrl = 7'b0001_0_0_0; // OR
                6'b10_0000: ctrl = 7'b0010_0_0_0; // ADD
                6'b10_0010: ctrl = 7'b0110_0_0_0; // SUB
                6'b10_1010: ctrl = 7'b0111_0_0_0; // SLT
                // EDIT: ADDED MORE FUNCT CASES 
                6'b00_1000: ctrl = 7'bxxxx_1_x_x; // JR 
                6'b01_1001: ctrl = 7'b0011_0_0_0; // MULT 
                6'b01_0000: ctrl = 7'bxxxx_0_1_0; // MFHI 
                6'b01_0010: ctrl = 7'bxxxx_0_0_1; // MFLO
                6'b00_0000: ctrl = 7'b1000_0_0_0; // SLL 
                6'b00_0010: ctrl = 7'b1001_0_0_0; // SRL
                default:    ctrl = 7'bxxxx_x_x_x;
            endcase
        endcase
    end

endmodule