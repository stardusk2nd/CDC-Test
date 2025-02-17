`timescale 1ns / 1ps
`include "config.vh"

module uart_tx #(parameter DATA_WIDTH = 8) (
    input clk, rst_n,
    input i_valid,
    input [DATA_WIDTH-1:0] i_data,
    output reg rd_en,
    output reg u_tx
    );
    
    localparam S_IDLE = 2'b00;
    localparam S_HOLD = 2'b01;
    localparam S_SEND = 2'b10;
    
    reg [1:0] state, n_state;
    always @(posedge clk) begin
        if(!rst_n)
            state <= S_IDLE;
        else
            state <= n_state;
    end
    
    localparam U_DATA_SIZE = DATA_WIDTH + 2; // start, stop bit
    localparam PSC = `SYSCLK_FREQ / `BAUD_RATE;

    reg [$clog2(PSC)-1:0] u_cnt;
    reg [$clog2(U_DATA_SIZE)-1:0] sda_cnt;
    reg u_load;
    always @(*) begin
        n_state = state;
        rd_en = 0;
        u_load = 0;
        case(state)
            S_IDLE: begin
                if(i_valid) begin
                    rd_en = 1;
                    n_state = S_HOLD;
                end
            end
            // fifo output delay (1 cycle)
            S_HOLD: begin
                n_state = S_SEND;
            end
            S_SEND: begin
                if(u_cnt == PSC - 1) begin
                    u_load = 1;
                    if(sda_cnt == U_DATA_SIZE - 1)
                        n_state = S_IDLE;
                end
            end
        endcase
    end
    
    always @(posedge clk) begin
        if(!rst_n)
            u_cnt <= 0;
        else
            u_cnt <= (state == S_SEND)? ((u_cnt == PSC - 1)? 0 : u_cnt + 1) : 0;
    end
    
    reg [U_DATA_SIZE-1:0] tx_shift;
    always @(posedge clk) begin
        if(!rst_n) begin
            sda_cnt <= 0;
            u_tx <= 1;  // start bit: low
        end
        else begin
            if(state == S_HOLD)
                tx_shift <= {1'b1, i_data, 1'b0};
            if(u_load) begin
                u_tx <= tx_shift[0];
                // LSB First
                tx_shift <= {1'b0, tx_shift[U_DATA_SIZE-1:1]};
                sda_cnt <= (sda_cnt == U_DATA_SIZE - 1)? 0 : sda_cnt + 1;
            end
        end
    end
    
endmodule
