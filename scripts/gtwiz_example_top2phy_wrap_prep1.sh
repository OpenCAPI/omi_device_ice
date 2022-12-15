#!/bin/bash
##
## Copyright 2022 International Business Machines
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
## http://www.apache.org/licenses/LICENSE-2.0
##
## The patent license granted to you in Section 3 of the License, as applied
## to the "Work," hereby includes implementations of the Work in physical form.
##
## Unless required by applicable law or agreed to in writing, the reference design
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
## The background Specification upon which this is based is managed by and available from
## the OpenCAPI Consortium.  More information can be found at https://opencapi.org.
##

# This script takes the output of the Xilinx wizard generated Ultrascale GTY example
# and tunes files for ASTRA design.
# Few tricks:
# When '' can't be used, "" are used to avoid escaping (for ex in "1b'0" case)
# At the end of the last append (a) command, we need to have a carriage return before the terminating bracket }"
# To find a pattern and replace part of the lines containing hb0, hb1, etc ...: ".*" replaces 0, 1, 2, etc .... and then {s/xx/yy/} replaces item in these lines.
# /assign hb.*_gtwiz_userdata_rx_int/{s/_gtwiz_userdata_rx_int/_gtwiz_userdata_rx/}" \
# Remove from 868 up to 1142 after "PRBS STIMULUS, CHECKING, AND LINK MANAGEMENT" is found
# When a long text has to be inserted, addingx files associated with r (read) command are used.
# Pay attention that when using "{" to group command, it requires a CR. So we decided to move this specific command into separated 
# sed command lines at the end of the script.

sed -e 's/gtwizard_ultrascale_0/DLx_phy/g' \
-e "/DONT_TOUCH/d" \
-e 's/mgtrefclk0_x0y6/mgtrefclk0_x0y0/g' \
-e 's/mgtrefclk0_x0y7/mgtrefclk0_x0y1/g' \
-e 's/mgtrefclk0_x0y5/mgtrefclk0_x0y1/g' \
-e 's/MGTREFCLK0_X0Y6/MGTREFCLK0_X0Y0/g' \
-e 's/MGTREFCLK0_X0Y7/MGTREFCLK0_X0Y1/g' \
-e 's/MGTREFCLK0_X0Y5/MGTREFCLK0_X0Y1/g' \
-e "/input  wire mgtrefclk0_x0y1_n,/a\\
    \n  \/\/ Clocking\n\
  output wire cclk,\n\
  output wire rclk,\n\
  input  wire hb_gtwiz_reset_clk_freerun_buf_int,\n\
  output wire tx_clk_402MHz,\n"  \
-e "/wire \[0\:\0] gtwiz_userclk_rx_usrclk_int/,+2 s/^/\/\//" \
-e "/wire \[0\:\0] hb0_gtwiz_userclk_rx_usrclk2_int/,+1 s/^/\/\//" \
-e "/input  wire hb_gtwiz_reset_clk_freerun_in/,+3 s/^/\/\//" \
-e "/input  wire link_down_latched_reset_in/,+2 s/^/\/\//" \
-e '/bit_synchronizer_vio_gtpowergood_/,+4 s/^/\/\//' \
-e "/wire \[0\:0\] gtwiz_reset_tx_pll_and_datapath_int/{n;s/^/  \/\//;n; s/^/  \/\//}" \
-e "/wire \[0\:0\] gtwiz_reset_tx_datapath_int/{n;s/^/  \/\//;n; s/^/  \/\//}" \
-e "/wire \[63\:0\] hb0_gtwiz_userdata_tx_int/,+7 d" \
-e "/\] = hb.*_gtwiz_userdata_tx_int/{s/_gtwiz_userdata_tx_int/_gtwiz_userdata_tx/}" \
-e "/\] hb.*_gtwiz_userdata_rx_int/d" \
-e "/assign hb.*_gtwiz_userdata_rx_int/{s/_gtwiz_userdata_rx_int/_gtwiz_userdata_rx/}" \
-e "/PRBS STIMULUS, CHECKING, AND LINK MANAGEMENT/,+274 d" \
-e "/wire \[79\:0\] drpaddr_int;/,+23 d" \
-e "/wire \[0\:\0] ch.*_rxgearboxslip_int;/,+7 d" \
-e "/assign rxgearboxslip_int.*_rxgearboxslip_int;/{s/_rxgearboxslip_int/_rxgearboxslip/}" \
-e "/wire \[7\:0\] rxlpmen_int;/,+1 d" \
-e "/wire \[23\:0\] rxrate_int;/,+1 d" \
-e "/wire \[39\:0\] txdiffctrl_int;/,+1 d" \
-e "/wire \[5\:0\] ch.*_txheader_int;/ d" \
-e "/assign txheader_int.* = ch.*_txheader_int/{s/ch/\{4'b0000, ch/};s/txheader_int/txheader\}/2" \
-e "/wire \[39\:0\] txp/,+2 d" \
-e "/wire \[39\:0\] txp/,+2 d" \
-e "/wire \[6\:0\] ch.*_txsequence_int;/ d" \
-e "/assign txsequence_int.* = ch.*_txsequence_int;/{s/ch/\{1'b0, ch/};s/txsequence_int/txsequence\}/2" \
-e "/assign ch7_rxdatavalid_int = rxdatavalid_int\[15\:14\];/a\  assign ch0_rxdatavalid = ch0_rxdatavalid_int\[0\];\n\
  assign ch1_rxdatavalid = ch1_rxdatavalid_int\[0\];\n\
  assign ch2_rxdatavalid = ch2_rxdatavalid_int\[0\];\n\
  assign ch3_rxdatavalid = ch3_rxdatavalid_int\[0\];\n\
  assign ch4_rxdatavalid = ch4_rxdatavalid_int\[0\];\n\
  assign ch5_rxdatavalid = ch5_rxdatavalid_int\[0\];\n\
  assign ch6_rxdatavalid = ch6_rxdatavalid_int\[0\];\n\
  assign ch7_rxdatavalid = ch7_rxdatavalid_int\[0\];" \
-e "/assign ch7_rxheader_int = rxheader_int\[47\:42\];/a\  assign ch0_rxheader = ch0_rxheader_int\[1\:0\];\n\
  assign ch1_rxheader = ch1_rxheader_int\[1\:0\];\n\
  assign ch2_rxheader = ch2_rxheader_int\[1\:0\];\n\
  assign ch3_rxheader = ch3_rxheader_int\[1\:0\];\n\
  assign ch4_rxheader = ch4_rxheader_int\[1\:0\];\n\
  assign ch5_rxheader = ch5_rxheader_int\[1\:0\];\n\
  assign ch6_rxheader = ch6_rxheader_int\[1\:0\];\n\
  assign ch7_rxheader = ch7_rxheader_int\[1\:0\];" \
-e "/wire \[127\:0\] drpdo_int;/,+55 d" \
-e "/wire hb_gtwiz_reset_all_vio_int;/,+1 s/^/  \/\//" \
-e "/IBUF ibuf_hb_gtwiz_reset_all_inst (/,+3 d" \
-e "/wire hb_gtwiz_reset_all_int;/a\ \n  wire hb_gtwiz_reset_all_DLx_reset;" \
-e "/assign hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_buf_int/{s/^/  \/\//}" \
-e "/assign hb_gtwiz_reset_all_int =/a\  assign hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_DLx_reset || hb_gtwiz_reset_all_init_int;" \
-e "/wire hb_gtwiz_reset_clk_freerun_buf_int;/s/^/  \/\//" \
-e "/  wire mgtrefclk0_x0y0_int/a\  wire reset_clk_156_25MHz;\n" \
-e "/  BUFG bufg_clk_freerun_inst (/,+3 s/^/  \/\//" \
-e "/  assign hb0_gtwiz_userclk_tx_reset_int = ~(/s/^/  \/\//" \
-e "/  assign hb0_gtwiz_userclk_tx_reset_int = ~(/a\  assign hb0_gtwiz_userclk_tx_reset_int = ~( &txpmaresetdone_int);  " \
-e "/wire       init_done_int;/,+6 s/^/  \/\//" \
-e "/wire hb_gtwiz_reset_rx_datapath_init_int;/a\  wire hb_gtwiz_reset_rx_datapath_DLx_int; // Josh added to retrain the transceiver's receiver" \
-e "/assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath/s/^/  \/\//"  \
-e "/assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath/a\  assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath_init_int || hb_gtwiz_reset_rx_datapath_DLx_int;" \
-e "s/.rx_data_good_in (sm_link)/    .rx_data_good_in (gtwiz_reset_rx_done_int ), \/\/ if you get through bufferbypasss assume data is good.    /" \
-e "/wire \[7\:0\] gtpowergood_vio_sync;/s/^/  \/\//" \
-e "/.i_in   (txprgdivresetdone_int\[0\]),/s/^/  \/\//"  \
-e "/.i_in   (txprgdivresetdone_int\[0\]),/a\    .i_in   (1\'b0),"  \
-e "/wire \[0\:0\] gtwiz_reset_tx_done_vio_sync/s/^/  \/\//"  \
-e "/wire \[0\:0\] gtwiz_reset_rx_done_vio_sync/s/^/  \/\//"  \
-e "/wire \[0\:0\] gtwiz_buffbypass_tx_done_vio_sync/ s/^/  \/\//" \
-e "/wire \[0\:0\] gtwiz_buffbypass_tx_error_vio_sync/s/^/  \/\//" \
-e "/wire \[0\:0\] gtwiz_buffbypass_rx_error_vio_sync/s/^/  \/\//" \
-e "/.gtwiz_userclk_tx_usrclk2_out            (gtwiz_userclk_tx_usrclk2_int)/a\   ,.gtwiz_userclk_tx_usrclk3_out            (gtwiz_userclk_tx_usrclk3_int)" \
-e "/.gtwiz_userclk_rx_usrclk_out             (gtwiz_userclk_rx_usrclk_int)/,+1 s/^/  \/\//" \
-e "/.gtpowergood_out                         (gtpowergood_int)/s/^/  \/\//" \
-e "/.txprgdivresetdone_out                   (txprgdivresetdone_int)/s/^/  \/\//" \
\
-e '/phy_vio_0/,+20 s/^/\/\//' \
-e '/in_system_ibert_0/,+64 s/^/\/\//' \
-e "/bit_synchronizer_vio_gtwiz_buffbypass_tx_error_0_inst/{N;N;N;N; a \ \n\
  \/\/ Synchronize gtwiz_buffbypass_rx_error into the free-running clock domain for VIO usage\n\
  wire [0:0] gtwiz_buffbypass_rx_error_vio_sync;\n\
\n\
  DLx_phy_example_bit_synchronizer bit_synchronizer_vio_gtwiz_buffbypass_rx_error_0_inst (\n\
   \.clk_in (hb_gtwiz_reset_clk_freerun_buf_int),\n\
    \/\/ \.i_in   (gtwiz_buffbypass_rx_error_int[0]),\n\
   \.i_in   (1'b0),\n\
   \.o_out  (gtwiz_buffbypass_rx_error_vio_sync[0])\n\
  );\n
} " ./gtwizard_ultrascale_0_example_top.v  > dlx_phy_wrap_ref.v

# if apollo (identified here because ports are x0y5 and x0y6)) then swap back ports done by the previous sed
grep -q mgtrefclk0_x0y5_p ./gtwizard_ultrascale_0_example_top.v
if [ $? -eq 0 ]
then 
  sed -i "s/mgtrefclk0_x0y1/mgtrefclk0_x0y2/g" dlx_phy_wrap_ref.v
  sed -i "s/mgtrefclk0_x0y0/mgtrefclk0_x0y1/g" dlx_phy_wrap_ref.v
  sed -i "s/mgtrefclk0_x0y2/mgtrefclk0_x0y0/g" dlx_phy_wrap_ref.v
  sed -i "s/MGTREFCLK0_X0Y1/MGTREFCLK0_X0Y2/g" dlx_phy_wrap_ref.v
  sed -i "s/MGTREFCLK0_X0Y0/MGTREFCLK0_X0Y1/g" dlx_phy_wrap_ref.v
  sed -i "s/MGTREFCLK0_X0Y2/MGTREFCLK0_X0Y0/g" dlx_phy_wrap_ref.v
fi

sed -i "s/wire \[0\:0\] gtwiz_reset_tx_pll_and_datapath_int;/wire \[0\:0\] gtwiz_reset_tx_pll_and_datapath_int = 1\'b0;/" dlx_phy_wrap_ref.v

sed -i "s/wire \[0\:0\] gtwiz_reset_tx_datapath_int;/wire \[0\:0\] gtwiz_reset_tx_datapath_int = 1\'b0;/"  dlx_phy_wrap_ref.v

sed -i '/output reg  link_down_latched_out =/r adding_fire2'  dlx_phy_wrap_ref.v

sed -i '/assign hb0_gtwiz_buffbypass_tx_error_int = gtwiz_buffbypass_tx_error_int/r adding_fire3' dlx_phy_wrap_ref.v

sed -i '/.o_out  (gtwiz_buffbypass_tx_done_vio_sync/{n;n;r adding_fire4
}' dlx_phy_wrap_ref.v

sed -i '/o_out  (gtwiz_buffbypass_rx_error_vio_sync/{n;n;r adding_fire5
}' dlx_phy_wrap_ref.v
