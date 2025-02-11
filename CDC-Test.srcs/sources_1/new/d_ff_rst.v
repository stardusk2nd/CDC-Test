`timescale 1ns / 1ps

/* D Flip-flop with Sync Reset Signal */
module d_ff_rst(
    input clk, rst_n,
    input d,
    output reg q
    );
    
    always @(posedge clk) begin
        if(!rst_n)  // sycn reset
            q <= 0;
        else
            q <= d;
    end
    
endmodule
