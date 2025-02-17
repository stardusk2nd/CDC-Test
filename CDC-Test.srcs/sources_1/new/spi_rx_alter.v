`timescale 1ns / 1ps
`include "config.vh"

/* SPI slave alter version */
module spi_rx_alter #(
    parameter DATA_WIDTH = 8
    )(
    input clk,                              // system clock
    input rst_n,                            // active-low, async reset
    input sclk,                             // spi serial clcok
    input mosi,                             // master out slave in
    output reg [DATA_WIDTH-1:0] rx_shift,   // 1-clk delay, axi4-lite output
    output reg rx_done                      // 1-clk delay, interrupt signal
    );
    
    reg mosi_1d;
    always @(posedge clk) mosi_1d <= mosi;
    
    // edge detection
    generate
        wire sclk_e_1d;
        case(`SPI_SLAVE_MODE)
            0,3: begin  // rising edge of sclk
                // 2-stage d ff chain to prvent metastable
                edge_detector_sync #(.EDGE("RISING")) scl_edge_detection(
                    .clk        (clk),
                    .rst_n      (rst_n),
                    .signal_in  (sclk),
                    .edge_out   (sclk_e_1d)
                );
            end
            1,2: begin  // falling edge of sclk
                edge_detector_sync #(.EDGE("FALLING")) scl_edge_detection(
                    .clk        (clk),
                    .rst_n      (rst_n),
                    .signal_in  (sclk),
                    .edge_out   (sclk_e_1d)
                );
            end
        endcase
    endgenerate
    
    reg [$clog2(DATA_WIDTH)-1:0] mosi_cnt;
    always @(posedge clk) begin
        if(!rst_n) begin
//            rx_shift <= 8'bx;
            mosi_cnt <= 0;
            rx_done <= 0;
        end
        // active-low cs logic
        else begin
            if(sclk_e_1d) begin
                if(mosi_cnt == DATA_WIDTH - 1) begin
                    mosi_cnt <= 0;
                    rx_done <= 1;
                end
                else
                    mosi_cnt <= mosi_cnt + 1;
                // MSB first
                rx_shift <= {rx_shift[DATA_WIDTH-2:0], mosi_1d};
            end
            if(rx_done)
                rx_done <= 0;
        end
    end
    
endmodule