`timescale 1ns / 1ps
`include "config.vh"

/* Simple D flip-flops chain to re-synchronize 1-bit signal */
module cdc_type1(
    input rst_n,
    input clk_a,
    output clk_b
    );
    
    parameter CE_PERIOD = 500;
    
    reg [$clog2(CE_PERIOD)-1:0] cnt;    // count
    always @(posedge clk_a) begin
        if(!rst_n)
            cnt <= 0;
        else
            cnt <= (cnt == CE_PERIOD-1)? 0 : cnt + 1;
    end
    
    wire ce = (cnt < CE_PERIOD/2);  // clock enable
    
    wire clk_33m;
    wire ce_q;
    /* note:
    A general data path (such as a chain of D flip-flops) can omit the reset signal.
    Because, other values are normalized by the first 'd'.
    */
    d_ff_chain d_ff_chain_inst(
        clk_a, clk_33m, ce, ce_q 
    );
    
    clk_wiz_0 clk_wiz_inst(
        .clk_out1   (clk_33m),
        .resetn     (rst_n),
        .locked     (),     // can be disabled in IP config
        .clk_in1    (clk_a)
    );
    
    // clcok buffer
    BUFGCE #(
        // set the device version (can be omitted for synthesis, but needed for simulation)
        .SIM_DEVICE("7SERIES") 
    ) BUFGCE_inst(
        .O  (clk_b),
        .CE (ce_q),
        .I  (clk_33m)
    );
    
endmodule
