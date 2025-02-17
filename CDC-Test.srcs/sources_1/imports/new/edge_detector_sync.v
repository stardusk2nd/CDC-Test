`timescale 1ns / 1ps

module edge_detector_sync #(parameter EDGE = "RISING")(
    input clk, rst_n,
    input signal_in,
    output edge_out
    );
    
    reg ff_master, ff_slave;
    always @(posedge clk) begin
        if(!rst_n) begin
            ff_master <= 0;
            ff_slave <= 0;
        end
        else begin
            ff_slave <= ff_master;
            ff_master <= signal_in;
        end
    end
    
    generate
        if(EDGE == "RISING")
            assign edge_out = (!ff_slave && ff_master);
        if(EDGE == "FALLING")
            assign edge_out = (!ff_master && ff_slave);
    endgenerate
    
endmodule