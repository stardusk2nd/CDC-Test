`timescale 1ns / 1ps

module spi_rx_tb();
    
    parameter MODE = 1;
    
    reg clk, rst_n, sclk, mosi;
    wire [15:0] rx_shift;
    wire rx_done;
    spi_rx #(
        .DATA_WIDTH(16),
        .MODE(MODE)
    )
    uut(
        clk, rst_n,
        sclk, mosi,
        rx_shift, rx_done
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end
    
    initial begin
        rst_n <= 0;
        mosi <= 0;
    end
    
    parameter SCLK_FREQ = 27e-3;
    parameter real SCLK_PERIOD = 1 / SCLK_FREQ; 
    
    reg cs = 1;
    generate
        case(MODE)
            0,3: begin
                always @(*) begin
                    if(!cs)
                        #(SCLK_PERIOD/2) sclk <= ~sclk;
                    else
                        sclk <= 0;
                end
            end
            1,2: begin
                always @(*) begin
                    if(!cs)
                        #(SCLK_PERIOD/2) sclk <= ~sclk;
                    else
                        sclk <= 1;
                end
            end
        endcase
    endgenerate
    
    initial begin
        #15;
        rst_n <= 1;
        
        send(16'ha5a5);
        #100;
        
        $finish;
    end
    
    task send;
        input [15:0] buffer;
        begin
            cs <= 0;
            repeat(16) begin
                mosi <= buffer[15];
                buffer <= {buffer[14:0], 1'b0};
                #(SCLK_PERIOD);
            end
            cs <= 1;
        end
    endtask
    
endmodule