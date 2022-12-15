#uncommented all set_clock_groups by BM
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins core/mc/ddr4_p1/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins core/mc/ddr4_p0/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst/CLKOUT0]]
#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {dlx_phy/example_wrapper_inst/DLx_phy_inst/inst/gen_gtwizard_gtye4_top.DLx_phy_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[2].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
#set_clock_groups -asynchronous -group mmcm_clkout0
#set_clock_groups -asynchronous -group mmcm_clkout0_1
#set_clock_groups -asynchronous -group txoutclk_out[0]_1
#set_clock_groups -asynchronous -group drpclk_int[0]
#set_clock_groups -asynchronous -group FREERUN_CLK_P
#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins dlx_phy/BUFGCE_DIV_inst/O]] -group [get_clocks FREERUN_CLK_P]
#set_clock_groups -asynchronous -group [get_clocks VIRTUAL_s_dclk] -group [get_clocks -of_objects [get_pins dlx_phy/BUFGCE_DIV_inst/O]]

set_property MAX_FANOUT 214 [get_nets core/afu_mac/main/afu_mmio_resp_ack_q]




####################################################################################
# Constraints from file : 'xpm_cdc_gray.tcl'
####################################################################################













#set_max_delay -from [get_pins core/mc/*/inst/div_clk_rst_r1_reg_replica/C] -to [get_pins {core/afu_mac/ui/gmc/*/WD_XFIFO/gMtrue.RMETAW/meta_1q_reg[*]/D}] 2.500
#set_max_delay -from [get_pins core/mc/ddr4_p0/inst/div_clk_rst_r1_reg_replica/C] -to [get_pins {core/afu_mac/ui/gmc/MC0/WD_XFIFO/gMtrue.RMETAW/meta_1q_reg[0]/D}] 2.500



####################################################################################
# Constraints from file : 'pins.xdc'
####################################################################################



####################################################################################
# Constraints from file : 'pins.xdc'
####################################################################################

create_pblock pblock_tx
add_cells_to_pblock [get_pblocks pblock_tx] [get_cells -quiet [list dlx_phy/ocx_dlx_top_inst/tx]]
resize_pblock [get_pblocks pblock_tx] -add {CLOCKREGION_X0Y3:CLOCKREGION_X0Y3}

create_pblock pblock_rx
add_cells_to_pblock [get_pblocks pblock_rx] [get_cells -quiet [list dlx_phy/ocx_dlx_top_inst/rx]]
resize_pblock [get_pblocks pblock_rx] -add {CLOCKREGION_X0Y4:CLOCKREGION_X0Y5}


####################################################################################
# Constraints from file : 'pins.xdc'
####################################################################################



####################################################################################
# Constraints from file : 'pins.xdc'
####################################################################################


set_false_path -from [get_pins {vio/inst/PROBE_OUT_ALL_INST/G_PROBE_OUT[0].PROBE_OUT0_INST/Probe_out_reg[0]/C}] -to [list [get_pins {dlx_phy/ocx_dlx_top_inst/tx/ctl/EDPL_reset_cnts_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/EDPL_thres_reached_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/block_locked_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/det_sync_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/dl_reset_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/flt_ready_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_rx_insides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_rx_outsides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_tx_insides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_tx_outsides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/reset_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/reset_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/start_retrain_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/sync_pattern_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tick_1us_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts1_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts2_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts3_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts4_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state2_to_3_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state2_to_3_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state4_to_5_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state4_to_5_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state6_to_1_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state6_to_1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg/D}] [get_pins {dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_1/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_2/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_3/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_4/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_5/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_6/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_7/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_8/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_9/D}]]
set_false_path -from [get_pins {vio/inst/PROBE_OUT_ALL_INST/G_PROBE_OUT[6].PROBE_OUT0_INST/Probe_out_reg[0]/C}] -to [list [get_pins {dlx_phy/ocx_dlx_top_inst/tx/ctl/EDPL_reset_cnts_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/EDPL_thres_reached_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/block_locked_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/det_sync_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/dl_reset_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/flt_ready_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_rx_insides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_rx_outsides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_tx_insides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_tx_outsides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/reset_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/reset_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/start_retrain_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/sync_pattern_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tick_1us_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts1_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts2_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts3_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts4_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state2_to_3_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state2_to_3_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state4_to_5_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state4_to_5_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state6_to_1_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state6_to_1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg/D}] [get_pins {dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_1/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_2/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_3/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_4/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_5/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_6/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_7/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_8/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_9/D}]]
set_false_path -from [get_pins {vio/inst/PROBE_OUT_ALL_INST/G_PROBE_OUT[2].PROBE_OUT0_INST/Probe_out_reg[0]/C}] -to [list [get_pins {dlx_phy/ocx_dlx_top_inst/tx/ctl/EDPL_reset_cnts_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/EDPL_thres_reached_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/block_locked_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/det_sync_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/dl_reset_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/flt_ready_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_rx_insides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_rx_outsides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_tx_insides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/good_tx_outsides_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/reset_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/reset_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/start_retrain_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/sync_pattern_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tick_1us_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts1_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts2_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts3_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/ts4_done_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state2_to_3_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state2_to_3_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state4_to_5_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state4_to_5_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state6_to_1_d1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/tsm_state6_to_1_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg/D}] [get_pins {dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_1/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_2/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_3/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_4/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_5/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_6/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_7/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_8/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_9/D}]]
set_max_delay -from [get_pins core/mc/ddr4_p0/inst/u_ddr4_mem_intfc/u_ddr_cal_top/calDone_gated_reg/C] -to [get_pins {core/cal_retry/cal_sync/meta_1q_reg[1]/D}] 2.500
set_max_delay -from [get_pins core/mc/ddr4_p1/inst/u_ddr4_mem_intfc/u_ddr_cal_top/calDone_gated_reg/C] -to [get_pins {core/cal_retry/cal_sync/meta_1q_reg[0]/D}] 2.500
create_clock -period 7.500 -name {CAPI_FPGA_REFCLK_P[0]} -waveform {0.000 3.750} [get_ports {CAPI_FPGA_REFCLK_P[0]}]
create_clock -period 7.500 -name {CAPI_FPGA_REFCLK_P[1]} -waveform {0.000 3.750} [get_ports {CAPI_FPGA_REFCLK_P[1]}]
create_clock -period 7.500 -name FREERUN_CLK_P -waveform {0.000 3.750} [get_ports FREERUN_CLK_P]
create_clock -period 20.000 -name VIRTUAL_s_dclk -waveform {0.000 10.000}
create_clock -period 3.753 -name VIRTUAL_mmcm_clkout0 -waveform {0.000 1.876}
set_input_delay -clock [get_clocks FREERUN_CLK_P] -min -add_delay 0.200 [get_ports RESETN]
set_input_delay -clock [get_clocks FREERUN_CLK_P] -max -add_delay 1.000 [get_ports RESETN]
set_input_delay -clock [get_clocks VIRTUAL_s_dclk] -min -add_delay 0.200 [get_ports RESETN]
set_input_delay -clock [get_clocks VIRTUAL_s_dclk] -max -add_delay 1.000 [get_ports RESETN]
set_input_delay -clock [get_clocks FREERUN_CLK_P] -min -add_delay 0.200 [get_ports SCL_IO]
set_input_delay -clock [get_clocks FREERUN_CLK_P] -max -add_delay 1.000 [get_ports SCL_IO]
set_input_delay -clock [get_clocks FREERUN_CLK_P] -min -add_delay 0.200 [get_ports SDA_IO]
set_input_delay -clock [get_clocks FREERUN_CLK_P] -max -add_delay 1.000 [get_ports SDA_IO]
set_output_delay -clock [get_clocks FREERUN_CLK_P] -min -add_delay -0.400 [get_ports SCL_IO]
set_output_delay -clock [get_clocks FREERUN_CLK_P] -max -add_delay 0.200 [get_ports SCL_IO]
set_output_delay -clock [get_clocks FREERUN_CLK_P] -min -add_delay -0.400 [get_ports SDA_IO]
set_output_delay -clock [get_clocks FREERUN_CLK_P] -max -add_delay 0.200 [get_ports SDA_IO]
set_output_delay -clock [get_clocks VIRTUAL_mmcm_clkout0] -min -add_delay -0.400 [get_ports c0_ddr4_reset_n]
set_output_delay -clock [get_clocks VIRTUAL_mmcm_clkout0] -max -add_delay 0.200 [get_ports c0_ddr4_reset_n]
set_output_delay -clock [get_clocks VIRTUAL_mmcm_clkout0] -min -add_delay -0.400 [get_ports c1_ddr4_reset_n]
set_output_delay -clock [get_clocks VIRTUAL_mmcm_clkout0] -max -add_delay 0.200 [get_ports c1_ddr4_reset_n]
set_clock_groups -asynchronous -group [get_clocks FREERUN_CLK_P]
set_clock_groups -asynchronous -group [get_clocks VIRTUAL_s_dclk]
set_false_path -from [get_pins {vio/inst/PROBE_OUT_ALL_INST/G_PROBE_OUT[2].PROBE_OUT0_INST/Probe_out_reg[0]/C}] -to [list [get_pins dlx_phy/ocx_dlx_top_inst/tx/ctl/*_reg/D] [get_pins {dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg_replica/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg_replica_1/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg_replica_2/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg_replica_3/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg_replica_4/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg_replica_5/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg_replica_6/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg_replica_7/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg_replica_8/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x4_not_x8_tx_mode_q_reg_replica_9/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_1/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_2/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_3/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_4/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_5/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_6/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_7/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_8/D dlx_phy/ocx_dlx_top_inst/tx/ctl/x2_tx_mode_q_reg_replica_9/D}]]
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/RS_XFIFO/gMtrue.Meta_Wa_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/RS_XFIFO/gMtrue.WAMETA/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/RS_XFIFO/bWrite.ETRAP/err_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/FIFOERRXLAT/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/WD_XFIFO/bRead.ETRAP/err_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/FIFOERRXLAT/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/WD_XFIFO/gMtrue.Meta_Ra_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/WD_XFIFO/gMtrue.RAMETA/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/WS_XFIFO/gMtrue.Meta_Wa_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/WS_XFIFO/gMtrue.WAMETA/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/WS_XFIFO/bWrite.ETRAP/err_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/FIFOERRXLAT/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/RD_XFIFO/bWrite.ETRAP/err_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/FIFOERRXLAT/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/RD_XFIFO/gMtrue.Meta_Wa_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/RD_XFIFO/gMtrue.WAMETA/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/CM_XFIFO/bRead.ETRAP/err_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/FIFOERRXLAT/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/CM_XFIFO/gMtrue.Meta_Ra_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/CM_XFIFO/gMtrue.RAMETA/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins core/mc/*/inst/div_clk_rst_r1_reg/C] -to [get_pins {core/afu_mac/ui/gmc/*/RS_XFIFO/gMtrue.RMETAR/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins core/mc/*/inst/div_clk_rst_r1_reg/C] -to [get_pins {core/afu_mac/ui/gmc/*/RD_XFIFO/gMtrue.RMETAR/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins core/mc/*/inst/div_clk_rst_r1_reg/C] -to [get_pins {core/afu_mac/ui/gmc/*/WS_XFIFO/gMtrue.RMETAR/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins core/mc/*/inst/div_clk_rst_r1_reg/C] -to [get_pins {core/afu_mac/ui/gmc/*/WD_XFIFO/gMtrue.RMETAR/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins core/mc/*/inst/div_clk_rst_r1_reg/C] -to [get_pins {core/afu_mac/ui/gmc/*/CM_XFIFO/gMtrue.RMETAW/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins core/mc/*/inst/div_clk_rst_r1_reg/C] -to [get_pins {core/afu_mac/ui/gmc/*/WD_XFIFO/gMtrue.RMETAW/meta_1q_reg[0]/D}] 2.500
set_max_delay -from [get_pins core/mc/ddr4_p1/inst/div_clk_rst_r1_reg/C] -to [get_pins {core/afu_mac/ui/gmc/MC1/WD_XFIFO/gMtrue.RMETAW/meta_1q_reg[0]/D}] 2.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/CM_XFIFO/gMtrue.Meta_Wa_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/CM_XFIFO/gMtrue.WAMETA/meta_1q_reg[*]/D}] 3.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/RD_XFIFO/gMtrue.Meta_Ra_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/RD_XFIFO/gMtrue.RAMETA/meta_1q_reg[*]/D}] 3.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/WD_XFIFO/gMtrue.Meta_Wa_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/WD_XFIFO/gMtrue.WAMETA/meta_1q_reg[*]/D}] 3.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/WS_XFIFO/gMtrue.Meta_Ra_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/WS_XFIFO/gMtrue.RAMETA/meta_1q_reg[*]/D}] 3.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/RS_XFIFO/gMtrue.Meta_Ra_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/RS_XFIFO/gMtrue.RAMETA/meta_1q_reg[*]/D}] 3.500
set_false_path -from [get_pins {core/mc/ddr4_p1/inst/u_ddr4_mem_intfc/u_ddr_cal_top/cal_RESET_n_reg[0]/C}] -to [get_ports c1_ddr4_reset_n]
set_false_path -from [get_pins {core/mc/ddr4_p0/inst/u_ddr4_mem_intfc/u_ddr_cal_top/cal_RESET_n_reg[0]/C}] -to [get_ports c0_ddr4_reset_n]

####################################################################################
# Constraints from file : 'pins.xdc'
####################################################################################

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets hb_gtwiz_reset_clk_freerun_buf_int]
