## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];

## SPI Interface
# SPI serial clock
set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { sclk }]; #IO_L11P_T1_SRCC_15 Sch=jb_p[1]
create_clock -add -name spi_sclk_pin -period 18.52 [get_ports { sclk }]; #54MHz
# SPI serial data
set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { mosi }]; #IO_L12P_T1_MRCC_15 Sch=jb_p[2]
# Handshaking with SPI Master
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { ready }]; #IO_0_15 Sch=ja[1]

## USB-UART Interface
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { u_tx }]; #IO_L19N_T3_VREF_16 Sch=uart_rxd_out

## Reset signal (Active-low)
set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { rst_n }]; #IO_L16P_T2_35 Sch=ck_rst