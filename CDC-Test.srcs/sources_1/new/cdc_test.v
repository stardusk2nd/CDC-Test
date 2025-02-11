`timescale 1ns / 1ps

`include "config.vh"

module cdc_test(
    input clk_a,
    input rst_n,
    output clk_b
    );
    
    parameter CE_PERIOD = 500;
    
    reg [$clog2(CE_PERIOD)-1:0] cnt;    // count
    always @(posedge clk_a) begin
        if(!rst_n)
            cnt <= 0;
        else
            cnt <= (cnt < CE_PERIOD-1)? cnt + 1 : 0;
    end
    
    wire ce = (cnt < CE_PERIOD/2);  // clock enable
    
    wire clk_33m;
    wire ce_q;
    d_ff_chain d_ff_chain_inst(
        clk_a, clk_33m, `ifdef SYNC_RST rst_n,`endif ce, ce_q 
    );
    
    clk_wiz_0 clk_wiz_inst(
        .clk_out1   (clk_33m),
        .resetn     (rst_n),
        .locked     (), // can be disabled in IP config
        .clk_in1    (clk_a)
    );
    
    // tri-state buffer
    BUFGCE #(
        // set the device version (can be omitted for synthesis, but need for simulation)
        .SIM_DEVICE("7SERIES") 
    )
    BUFGCE_inst(
        .O  (clk_b),
        .CE (ce_q),
        .I  (clk_33m)
    );
    
endmodule
