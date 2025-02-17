`timescale 1ns / 1ps

/* async fifo module*/
// developing...
module async_fifo #(
    parameter WIDTH = 16,
    parameter DEPTH = 1024
    )(
    input wr_clk,
    input rd_clk,
    input rst_n,
    
    input [WIDTH-1:0] din,
    );
endmodule
