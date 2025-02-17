`timescale 1ns / 1ps

module cdc_type3_tb();
    
    parameter DATA_WIDTH = 8;
    
    reg clk, rst_n, sclk, mosi;
    wire ready, u_tx;
    cdc_type3 uut(
        clk, rst_n, sclk, mosi, ready, u_tx
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end
    
    initial begin
        rst_n <= 0;
        mosi <= 0;
    end
    
    parameter real SCLK_FREQ = 54e-3;   // 54MHz
    parameter real SCLK_PERIOD = 1 / SCLK_FREQ; 
    
    reg cs = 1;
    always @(*) begin
        if(!cs)
            #(SCLK_PERIOD/2) sclk <= ~sclk;
        else
            sclk <= 0;
    end
    
    initial begin
        #5;
        rst_n <= 1;
        #1500;
        
        send(8'ha5);
        send(8'h5a);
        
        #30000;
        $finish;
    end
    
    task send;
        input [DATA_WIDTH-1:0] buffer;
        begin
            if(ready) begin
                cs <= 0;
                repeat(DATA_WIDTH) begin
                    mosi <= buffer[DATA_WIDTH-1];
                    buffer <= {buffer[DATA_WIDTH-2:0], 1'b0};
                    #(SCLK_PERIOD);
                end
                cs <= 1;
            end
        end
    endtask
    
endmodule
