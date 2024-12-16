`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2024 03:22:04 PM
// Design Name: 
// Module Name: control_unit
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


module fact_controlunit(
    input clk, 
    input go, 
    input [3:0] n, 
    input rst, 
    input done_in, 
    input error_in,
    output reg [5:0] control_signal
    );
    
    
    reg [3:0] state; 
    
    
    always @(posedge clk) begin 
    
        if (rst) state = 3'b000; 
        else begin 
    
            case (state) 
                // send out n 
                3'b000: begin 
                    control_signal[5] <= 1; 
                    control_signal[4:1] <= n; 
                    control_signal[0] <= 1; 
                    if (go == 1) state <= 3'b001; 
                    else state <= 3'b000; 
                end 
                
                // send out go 
                3'b001: begin 
                    control_signal[0] <= !go; 
                    state <= 3'b010; 
                end 
                
                // wait for either done or error 
                3'b010: begin 
                    if (done_in) state <= 3'b011; 
                    else if (error_in) state <= 3'b100; 
                    else state <= 3'b010; 
                end 
                
                // done, put go high 
                3'b011: begin 
                    control_signal[5] <= 0; 
                    control_signal[0] <= 1; 
                    state <= 3'b000; 
                end 
                
                // error, put n = 0 and put go high 
                3'b100: begin 
                    control_signal[5] <= 0; 
                    control_signal[4:1] <= 0; 
                    control_signal[0] <= 1; 
                    if (error_in) state <= 3'b100; 
                    else state <= 3'b000; 
                end 
                
                default: begin 
                    state <= 3'b000; 
                end 
            
            endcase
            
            
        end 
    
    end 
    
    
endmodule
