`timescale 1ns / 1ps
`include "config.vh"

module d_ff_chain(
    input clk_a, clk_b,
    `ifdef SYNC_RST
    input rst_n,
    `endif
    input i_async,
    output o_sync
    );
    
    wire [2:0] q;
    assign o_sync = q[2];
    
    `ifdef SYNC_RST
        d_ff_rst d_ff_a(
            clk_a, rst_n, d, q[0]
        );
        d_ff_rst d_ff_b[1:0](
            clk_b, rst_n, q[0], q[1]
        );
    `else
        d_ff d_ff_a(
            clk_a, d, q[0]
        );
        d_ff d_ff_b[1:0](
            clk_b, q[0], q[1]
        );
    `endif
    
endmodule
