`timescale 1ns / 1ps


module cdc_test_tb();
    
    reg clk, rst_n;
    wire cout;
    cdc_test uut(clk, rst_n, cout);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst_n <= 0;
        #10;
        rst_n <= 1;
        
        #100_000;
        $finish;
    end
    
endmodule
