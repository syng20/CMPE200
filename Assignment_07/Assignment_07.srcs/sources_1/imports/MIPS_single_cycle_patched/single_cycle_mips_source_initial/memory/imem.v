module imem (
        input  wire [5:0]  a,
        output wire [31:0] y
    );

    reg [31:0] rom [0:63];

    initial begin
        $readmemh ("D:/H L/Sam/Assignment_07/Assignment_07/Assignment_07.srcs/sim_1/imports/MIPS_single_cycle_patched/single_cycle_mips_source_initial/memdat.dat", rom);
    end

    assign y = rom[a];
    
endmodule