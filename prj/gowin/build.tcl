add_file -type verilog "src/dvi_tx/dvi_tx.v"
add_file -type verilog "src/gowin_pllvr/GW_PLLVR.v"
add_file -type verilog "src/gowin_pllvr/TMDS_PLLVR.v"
add_file -type verilog "src/hyperram_memory_interface/hyperram_memory_interface.v"
add_file -type verilog "src/ov2640/I2C_Interface.v"
add_file -type verilog "src/ov2640/OV2640_Controller.v"
add_file -type verilog "src/ov2640/OV2640_Registers.v"
add_file -type verilog "src/syn_code/syn_gen.v"
add_file -type verilog "src/video_frame_buffer/video_frame_buffer.v"
add_file -type verilog "src/canny_top.v"
add_file -type cst "src/canny.cst"
add_file -type sdc "src/canny.sdc"

set_device GW1NSR-LV4CQN48PC6/I5 -name GW1NSR-4C

set_option -output_base_name canny

set_option -verilog_std v2001

set_option -place_option 1
set_option -route_option 1

run all
