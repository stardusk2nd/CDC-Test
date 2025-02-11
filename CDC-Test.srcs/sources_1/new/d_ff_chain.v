`timescale 1ns / 1ps

`include "config.vh"

module d_ff_chain(
    input clk_a, clk_b,
    `ifdef SYNC_RST
    input rst_n,
    `endif
    input d,
    output q
    );
    
    wire q_a;
    wire [1:0] q_b;
    
    `ifdef SYNC_RST
    d_ff_rst d_ff_a(
        clk_a, rst_n, d, q_a
    );
    d_ff_rst d_ff_b_0(
        clk_b, rst_n, q_a, q_b[0]
    );
    d_ff_rst d_ff_b_1(
        clk_b, rst_n, q_b[0], q_b[1]
    );
    `else
    d_ff d_ff_a(
        clk_a, d, q_a
    );
    d_ff d_ff_b_0(
        clk_b, q_a, q_b[0]
    );
    d_ff d_ff_b_1(
        clk_b, q_b[0], q_b[1]
    );
    `endif
    
    assign q = q_b[1];
    
endmodule
