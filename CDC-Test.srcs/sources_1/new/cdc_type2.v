`timescale 1ns / 1ps

/* Application of type1: SPI Slave version*/
// "Receive only" SPI Slave Module
module cdc_type2 #(
    parameter DATA_WIDTH = 8
    )(
    input sysclk,   // fpga system clock
    // spi signals
    input cs,       // chip select (slave select)
    input sclk,     // spi serial clock
    input mosi,     // spi serial data: master out slave in
    // output signals
    output reg [DATA_WIDTH-1:0] rx_data,    // output data
    output reg rx_valid                     // data valid timing (single pulse)
    );
    
    reg [DATA_WIDTH-1:0] rx_shift, async_rx_data;
    reg [$clog2(DATA_WIDTH)-1:0] mosi_cnt;
    reg rx_done;
    always @(posedge sclk or posedge cs) begin
        // active-low cs logic
        if(cs) begin
            mosi_cnt <= 0;
            rx_done <= 0;
        end
        // MSB first data sampling
        else begin
            mosi_cnt <= mosi_cnt + 1;
            if(mosi_cnt == DATA_WIDTH-1) begin
                rx_done <= 1;
                async_rx_data <= {rx_shift[DATA_WIDTH-2:0], mosi};
            end
            else begin
                rx_done <= 0;
                rx_shift <= {rx_shift[DATA_WIDTH-2:0], mosi};
            end
        end
    end
    
    // re-synchronization
    reg [2:0] cdc_ff;
    always @(posedge sysclk) begin
        cdc_ff[2] <= cdc_ff[1];
        cdc_ff[1] <= cdc_ff[0];
        cdc_ff[0] <= rx_done;
    end
    // edge detection
    wire rx_done_pe = (cdc_ff[1] && !cdc_ff[2]);    // posedge
    
    always @(posedge sysclk) begin
        // 1 clock cycle delay
        rx_valid <= rx_done_pe;
        if(rx_done_pe)
            rx_data <= async_rx_data;
    end
    
    /* note:
    Unlike 'rx_done', 'async_rx_data' is a level signal.
    And it never crosses the clock domain while in a metastable state. So re-synchronization is unnecessary.
    */
    
endmodule