module alu (
        input  wire [3:0]  op,
        input  wire [31:0] a,
        input  wire [31:0] b,
        output wire        zero,
        output reg  [31:0] y,
        // EDIT: ADDED NEW INPUT AND OUTPUTS 
        input  wire [4:0] shamt, 
        output reg  [31:0] hi, 
        output reg  [31:0] lo
    );

    assign zero = (y == 0);

    always @ (op, a, b, shamt) begin
        case (op)
            4'b0000: y = a & b;
            4'b0001: y = a | b;
            4'b0010: y = a + b;
            4'b0110: y = a - b;
            4'b0111: y = (a < b) ? 1 : 0;
            // EDIT: ADDED NEW OPERATIONS 
            4'b0011: {hi, lo} = a * b; // mult 
            4'b1000: y = b << shamt; // sll 
            4'b1001: y = b >> shamt; // srl
            
            default: begin y = 0; 
                            hi = 0; 
                            lo = 0; 
                        end
        endcase
    end

endmodule