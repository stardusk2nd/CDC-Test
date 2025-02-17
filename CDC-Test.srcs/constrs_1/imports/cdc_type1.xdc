## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk_a }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk_a }];

set_clock_groups -asynchronous \
-group [get_clocks -of_objects [get_pins clk_wiz_inst/clk_out1]] \
-group [get_clocks -of_objects [get_pins clk_wiz_inst/clk_in1]]

## Output clock
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { clk_b }]; #IO_0_15 Sch=ja[1]

## Reset signal (Active-low)
set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { rst_n }]; #IO_L16P_T2_35 Sch=ck_rst