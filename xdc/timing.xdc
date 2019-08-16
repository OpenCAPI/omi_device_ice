
#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins core/mc/ddr4_p1/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst/CLKOUT0]]
#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins core/mc/ddr4_p0/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst/CLKOUT0]]
#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {dlx_phy/example_wrapper_inst/DLx_phy_inst/inst/gen_gtwizard_gtye4_top.DLx_phy_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[2].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
#set_clock_groups -asynchronous -group mmcm_clkout0
#set_clock_groups -asynchronous -group mmcm_clkout0_1
#set_clock_groups -asynchronous -group txoutclk_out[0]_1
#set_clock_groups -asynchronous -group FREERUN_CLK_P
#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins dlx_phy/BUFGCE_DIV_inst/O]] -group [get_clocks FREERUN_CLK_P]
#set_clock_groups -asynchronous -group [get_clocks VIRTUAL_s_dclk] -group [get_clocks -of_objects [get_pins dlx_phy/BUFGCE_DIV_inst/O]]
set_property MAX_FANOUT 214 [get_nets core/afu_mac/main/afu_mmio_resp_ack_q]





####################################################################################
# Constraints from file : 'xpm_cdc_gray.tcl'
####################################################################################


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
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins dlx_phy/BUFGCE_DIV_inst/O]]
set_clock_groups -asynchronous -group [get_clocks VIRTUAL_s_dclk]
set_clock_groups -asynchronous -group [get_clocks VIRTUAL_mmcm_clkout0]

set_false_path -from [get_pins {vio/inst/PROBE_OUT_ALL_INST/G_PROBE_OUT[0].PROBE_OUT0_INST/Probe_out_reg[0]/C}] -to [get_pins dlx_phy/ocx_dlx_top_inst/tx/ctl/*_reg/D]
set_false_path -from [get_pins {vio/inst/PROBE_OUT_ALL_INST/G_PROBE_OUT[6].PROBE_OUT0_INST/Probe_out_reg[0]/C}] -to [get_pins dlx_phy/ocx_dlx_top_inst/tx/ctl/*_reg/D]
set_false_path -from [get_pins {vio/inst/PROBE_OUT_ALL_INST/G_PROBE_OUT[2].PROBE_OUT0_INST/Probe_out_reg[0]/C}] -to [get_pins dlx_phy/ocx_dlx_top_inst/tx/ctl/*_reg/D]

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
set_max_delay -from [get_pins core/mc/*/inst/div_clk_rst_r1_reg_replica/C] -to [get_pins {core/afu_mac/ui/gmc/*/WD_XFIFO/gMtrue.RMETAW/meta_1q_reg[*]/D}] 2.500
set_max_delay -from [get_pins core/mc/ddr4_p0/inst/div_clk_rst_r1_reg_replica/C] -to [get_pins {core/afu_mac/ui/gmc/MC0/WD_XFIFO/gMtrue.RMETAW/meta_1q_reg[0]/D}] 2.500

set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/CM_XFIFO/gMtrue.Meta_Wa_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/CM_XFIFO/gMtrue.WAMETA/meta_1q_reg[*]/D}] 3.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/RD_XFIFO/gMtrue.Meta_Ra_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/RD_XFIFO/gMtrue.RAMETA/meta_1q_reg[*]/D}] 3.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/WD_XFIFO/gMtrue.Meta_Wa_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/WD_XFIFO/gMtrue.WAMETA/meta_1q_reg[*]/D}] 3.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/WS_XFIFO/gMtrue.Meta_Ra_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/WS_XFIFO/gMtrue.RAMETA/meta_1q_reg[*]/D}] 3.500
set_max_delay -from [get_pins {core/afu_mac/ui/gmc/*/RS_XFIFO/gMtrue.Meta_Ra_q_reg[*]/C}] -to [get_pins {core/afu_mac/ui/gmc/*/RS_XFIFO/gMtrue.RAMETA/meta_1q_reg[*]/D}] 3.500
