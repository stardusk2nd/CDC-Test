`timescale 1ns / 1ps

/* Using Vivado's Async FIFO IP (Independedt Clock FIFO) version */
module cdc_type3(
    input clk, rst_n,
    input sclk,
    input mosi,
    output ready,
    output u_tx
    );
    
    wire clk_spi;
    clk_wiz_1 clk_wiz_inst(
        .clk_out1   (clk_spi),
        .resetn     (rst_n),
        .clk_in1    (clk)
    );
    
    parameter DATA_WIDTH = 8;
    
    wire [DATA_WIDTH-1:0] rx_shift;
    wire rx_done;
    spi_rx_alter spi_rx_inst(
        .clk        (clk_spi),
        .rst_n      (rst_n),
        .sclk       (sclk),
        .mosi       (mosi),
        .rx_shift   (rx_shift),
        .rx_done    (rx_done)
    );
    
    wire rd_en;
    wire [DATA_WIDTH-1:0] dout;
    wire full, empty;
    assign ready = ~full;
    // vivado ip
    fifo_generator_0 independent_fifo_inst(
        .rst    (~rst_n),
        .wr_clk (clk_spi),
        .rd_clk (clk),
        .din    (rx_shift),
        .wr_en  (rx_done),
        .rd_en  (rd_en),
        .dout   (dout),
        .full   (full),
        .empty  (empty)
    );
    
    uart_tx uart_tx_inst(
        .clk    (clk),
        .rst_n  (rst_n),
        .i_valid(~empty),
        .i_data (dout),
        .rd_en  (rd_en),
        .u_tx   (u_tx)
    );
    
endmodule