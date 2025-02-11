`timescale 1ns / 1ps

/* D Flip-flop */
module d_ff(
    input clk,
    input d,
    output reg q
    );
    
    always @(posedge clk) q <= d;
    
endmodule
