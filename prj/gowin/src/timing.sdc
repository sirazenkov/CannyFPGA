//Copyright (C)2014-2021 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.7.02 Beta
//Created Time: 2021-06-01 10:34:02

create_clock -name iclk -period 37.037 -waveform {0 18.518} [get_ports {iclk}]
create_clock -name PIXCLK -period 27.78 -waveform {0 13.890} [get_ports {PIXCLK}]

create_generated_clock -name serial_clk
                       -source [get_ports {iclk}]
                       -master_clock iclk
                       -multiply_by 37
                       -divide_by 5
                       [get_pins {TMDS_PLLVR_inst/pllvr_inst/CLKOUT}]

create_generated_clock -name clk_20M
                       -source [get_pins {TMDS_PLLVR_inst/pllvr_inst/CLKOUT}]
                       -master_clock serial_clk
                       -divide_by 10
                       [get_pins {TMDS_PLLVR_inst/pllvr_inst/CLKOUTD}]

create_generated_clock -name pix_clk
                       -source [get_pins {TMDS_PLLVR_inst/pllvr_inst/CLKOUT}]
                       -master_clock serial_clk
                       -divide_by 5
                       [get_pins {u_clkdiv/CLKOUT}]

create_generated_clock -name memory_clk
                       -source [get_ports {iclk}]
                       -master_clock iclk
                       -multiply_by 3
                       [get_pins {GW_PLLVR_inst/pllvr_inst/CLKOUT}]

create_generated_clock -name dma_clk
                       -source [get_pins {GW_PLLVR_inst/pllvr_inst/CLKOUT}]
                       -master_clock memory_clk
                       -divide_by 2
                       [get_pins {HyperRAM_Memory_Interface_Top_inst/u_hpram_top/clkdiv/CLKOUT}]

set_clock_groups -asynchronous -group [get_clocks {dma_clk}] -group [get_clocks {PIXCLK}]
set_clock_groups -asynchronous -group [get_clocks {dma_clk}] -group [get_clocks {pix_clk}]
