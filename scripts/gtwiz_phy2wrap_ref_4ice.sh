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


# -e "/DONT_TOUCH/d" \

sed -e 's/gtwizard_ultrascale_0/DLx_phy/g' \
-e 's/mgtrefclk0_x0y1/mgtrefclk1_x0y0/g' \
-e 's/mgtrefclk1_x0y3/mgtrefclk1_x0y1/g' \
-e "/input  wire mgtrefclk1_x0y1_n/a\\
  \n  input  wire freerun_clk_p,\n\
  input  wire freerun_clk_n,\n\
\n\n\
  output wire freerun_clk_out,\n\
  output wire dlx_reset," \
-e '/ User-provided ports for reset helper block(s)/,+7 d' \
-e "/wire \[0\:\0] gtwiz_userclk_rx_usrclk_int/,+2 s/^/\/\//" \
-e "/wire \[0\:\0] hb0_gtwiz_userclk_rx_usrclk2_int/,+1 s/^/\/\//" \
-e "s/wire \[0\:0\] gtwiz_reset_tx_pll_and_datapath_int/wire \[0\:0\] gtwiz_reset_tx_pll_and_datapath_int = 1\'b0/" \
-e "/wire \[0\:0\] gtwiz_reset_tx_pll_and_datapath_int/{n;s/^/  \/\//;n; s/^/  \/\//}" \
-e "s/wire \[0\:0\] gtwiz_reset_tx_datapath_int/wire \[0\:0\] gtwiz_reset_tx_datapath_int = 1\'b0/" \
-e "/wire \[0\:0\] gtwiz_reset_tx_datapath_int/{n;s/^/  \/\//;n; s/^/  \/\//}" \
   -e "s/assign gtwiz_userdata_tx_int\[63:0\] = hb0/assign gtwiz_userdata_tx_int\[63:0\]    = hb7/" \
 -e "s/assign gtwiz_userdata_tx_int\[127:64\] = hb1/assign gtwiz_userdata_tx_int\[127:64\]  = hb6/" \
-e "s/assign gtwiz_userdata_tx_int\[191:128\] = hb2/assign gtwiz_userdata_tx_int\[191:128\] = hb5/" \
-e "s/assign gtwiz_userdata_tx_int\[255:192\] = hb3/assign gtwiz_userdata_tx_int\[255:192\] = hb4/" \
-e "s/assign gtwiz_userdata_tx_int\[319:256\] = hb4/assign gtwiz_userdata_tx_int\[319:256\] = hb3/" \
-e "s/assign gtwiz_userdata_tx_int\[383:320\] = hb5/assign gtwiz_userdata_tx_int\[383:320\] = hb2/" \
-e "s/assign gtwiz_userdata_tx_int\[447:384\] = hb6/assign gtwiz_userdata_tx_int\[447:384\] = hb1/" \
-e "s/assign gtwiz_userdata_tx_int\[511:448\] = hb7/assign gtwiz_userdata_tx_int\[511:448\] = hb0/" \
   -e "s/assign hb0_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[63:0\]/assign hb7_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[63:0\]/" \
 -e "s/assign hb1_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[127:64\]/assign hb6_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[127:64\]/" \
-e "s/assign hb2_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[191:128\]/assign hb5_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[191:128\]/" \
-e "s/assign hb3_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[255:192\]/assign hb4_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[255:192\]/" \
-e "s/assign hb4_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[319:256\]/assign hb3_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[319:256\]/" \
-e "s/assign hb5_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[383:320\]/assign hb2_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[383:320\]/" \
-e "s/assign hb6_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[447:384\]/assign hb1_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[447:384\]/" \
-e "s/assign hb7_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[511:448\]/assign hb0_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int\[511:448\]/" \
-e "s/gtrefclk00/gtrefclk01/g" \
-e "s/qpll0/qpll1/g" \
-e "/wire \[79\:0\] drpaddr_int;/,+23 d" \
-e "/wire \[0\:\0] ch.*_rxgearboxslip_int;/{s/\[0:0\]/     /}" \
-e "s/assign rxgearboxslip_int\[0:0\] = ch0_rxgearboxslip_int;/assign rxgearboxslip_int\[0:0\] = ch7_rxgearboxslip_int;/" \
-e "s/assign rxgearboxslip_int\[1:1\] = ch1_rxgearboxslip_int;/assign rxgearboxslip_int\[1:1\] = ch6_rxgearboxslip_int;/" \
-e "s/assign rxgearboxslip_int\[2:2\] = ch2_rxgearboxslip_int;/assign rxgearboxslip_int\[2:2\] = ch5_rxgearboxslip_int;/" \
-e "s/assign rxgearboxslip_int\[3:3\] = ch3_rxgearboxslip_int;/assign rxgearboxslip_int\[3:3\] = ch4_rxgearboxslip_int;/" \
-e "s/assign rxgearboxslip_int\[4:4\] = ch4_rxgearboxslip_int;/assign rxgearboxslip_int\[4:4\] = ch3_rxgearboxslip_int;/" \
-e "s/assign rxgearboxslip_int\[5:5\] = ch5_rxgearboxslip_int;/assign rxgearboxslip_int\[5:5\] = ch2_rxgearboxslip_int;/" \
-e "s/assign rxgearboxslip_int\[6:6\] = ch6_rxgearboxslip_int;/assign rxgearboxslip_int\[6:6\] = ch1_rxgearboxslip_int;/" \
-e "s/assign rxgearboxslip_int\[7:7\] = ch7_rxgearboxslip_int;/assign rxgearboxslip_int\[7:7\] = ch0_rxgearboxslip_int;/" \
-e '/wire \[7:0\] rxlpmen_int;/,+3 d' \
-e '/wire \[23:0\] rxrate_int;/,+3 d' \
-e '/wire \[39:0\] txdiffctrl_int;/,+3 d' \
  -e "s/assign txheader_int\[5:0\] = ch0_txheader_int;/assign txheader_int[5:0]   = ch7_txheader_int;/" \
 -e "s/assign txheader_int\[11:6\] = ch1_txheader_int;/assign txheader_int[11:6]  = ch6_txheader_int;/" \
-e "s/assign txheader_int\[17:12\] = ch2_txheader_int;/assign txheader_int[17:12] = ch5_txheader_int;/" \
-e "s/assign txheader_int\[23:18\] = ch3_txheader_int;/assign txheader_int[23:18] = ch4_txheader_int;/" \
-e "s/assign txheader_int\[29:24\] = ch4_txheader_int;/assign txheader_int[29:24] = ch3_txheader_int;/" \
-e "s/assign txheader_int\[35:30\] = ch5_txheader_int;/assign txheader_int[35:30] = ch2_txheader_int;/" \
-e "s/assign txheader_int\[41:36\] = ch6_txheader_int;/assign txheader_int[41:36] = ch1_txheader_int;/" \
-e "s/assign txheader_int\[47:42\] = ch7_txheader_int;/assign txheader_int[47:42] = ch0_txheader_int;/" \
-e "/  wire \[39:0\] txp*/,+2 d" \
  -e "s/assign txsequence_int\[6:0\] = ch0_txsequence_int;/assign txsequence_int\[6:0\]   = ch7_txsequence_int;/" \
 -e "s/assign txsequence_int\[13:7\] = ch1_txsequence_int;/assign txsequence_int\[13:7\]  = ch6_txsequence_int;/" \
-e "s/assign txsequence_int\[20:14\] = ch2_txsequence_int;/assign txsequence_int\[20:14\] = ch5_txsequence_int;/" \
-e "s/assign txsequence_int\[27:21\] = ch3_txsequence_int;/assign txsequence_int\[27:21\] = ch4_txsequence_int;/" \
-e "s/assign txsequence_int\[34:28\] = ch4_txsequence_int;/assign txsequence_int\[34:28\] = ch3_txsequence_int;/" \
-e "s/assign txsequence_int\[41:35\] = ch5_txsequence_int;/assign txsequence_int\[41:35\] = ch2_txsequence_int;/" \
-e "s/assign txsequence_int\[48:42\] = ch6_txsequence_int;/assign txsequence_int\[48:42\] = ch1_txsequence_int;/" \
-e "s/assign txsequence_int\[55:49\] = ch7_txsequence_int;/assign txsequence_int\[55:49\] = ch0_txsequence_int;/" \
-e "/wire \[127:0\] drpdo_int;/,+54 d" \
-e "s/assign ch0_rxdatavalid_int = rxdatavalid_int\[1:0\];/assign ch7_rxdatavalid_int = rxdatavalid_int\[1:0\];/" \
-e "s/assign ch1_rxdatavalid_int = rxdatavalid_int\[3:2\];/assign ch6_rxdatavalid_int = rxdatavalid_int\[3:2\];/" \
-e "s/assign ch2_rxdatavalid_int = rxdatavalid_int\[5:4\];/assign ch5_rxdatavalid_int = rxdatavalid_int\[5:4\];/" \
-e "s/assign ch3_rxdatavalid_int = rxdatavalid_int\[7:6\];/assign ch4_rxdatavalid_int = rxdatavalid_int\[7:6\];/" \
-e "s/assign ch4_rxdatavalid_int = rxdatavalid_int\[9:8\];/assign ch3_rxdatavalid_int = rxdatavalid_int\[9:8\];/" \
-e "s/assign ch5_rxdatavalid_int = rxdatavalid_int\[11:10\];/assign ch2_rxdatavalid_int = rxdatavalid_int\[11:10\];/" \
-e "s/assign ch6_rxdatavalid_int = rxdatavalid_int\[13:12\];/assign ch1_rxdatavalid_int = rxdatavalid_int\[13:12\];/" \
-e "s/assign ch7_rxdatavalid_int = rxdatavalid_int\[15:14\];/assign ch0_rxdatavalid_int = rxdatavalid_int\[15:14\];/" \
    -e "s/assign ch0_rxheader_int = rxheader_int\[5:0\];/assign ch7_rxheader_int = rxheader_int\[5:0\];/" \
   -e "s/assign ch1_rxheader_int = rxheader_int\[11:6\];/assign ch6_rxheader_int = rxheader_int\[11:6\];/" \
  -e "s/assign ch2_rxheader_int = rxheader_int\[17:12\];/assign ch5_rxheader_int = rxheader_int\[17:12\];/" \
  -e "s/assign ch3_rxheader_int = rxheader_int\[23:18\];/assign ch4_rxheader_int = rxheader_int\[23:18\];/" \
  -e "s/assign ch4_rxheader_int = rxheader_int\[29:24\];/assign ch3_rxheader_int = rxheader_int\[29:24\];/" \
  -e "s/assign ch5_rxheader_int = rxheader_int\[35:30\];/assign ch2_rxheader_int = rxheader_int\[35:30\];/" \
  -e "s/assign ch6_rxheader_int = rxheader_int\[41:36\];/assign ch1_rxheader_int = rxheader_int\[41:36\];/" \
  -e "s/assign ch7_rxheader_int = rxheader_int\[47:42\];/assign ch0_rxheader_int = rxheader_int\[47:42\];/" \
-e "/wire hb_gtwiz_reset_all_vio_int;/,+1 s/^/  \/\//" \
-e "/IBUF ibuf_hb_gtwiz_reset_all_inst (/,+3 d" \
-e "/wire hb_gtwiz_reset_all_int;/a\ \n  wire hb_gtwiz_reset_all_DLx_reset;" \
-e "/assign hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_buf_int/{s/^/  \/\//}" \
-e "/assign hb_gtwiz_reset_all_int =/a\  assign hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_DLx_reset || hb_gtwiz_reset_all_init_int;" \
-e "/wire hb_gtwiz_reset_clk_freerun_buf_int;/s/^/  \/\//" \
-e "/  BUFG bufg_clk_freerun_inst (/,+3 s/^/  \/\//" \
-e "/  wire mgtrefclk1_x0y0_int/a\  wire reset_clk_156_25MHz;  \n" \
-e "s/MGTREFCLK0_X0Y1/MGTREFCLK0_X0Y0/" \
-e "s/MGTREFCLK1_X0Y3/MGTREFCLK0_X0Y1/" \
-e "/  assign hb0_gtwiz_userclk_tx_reset_int = ~(/s/^/  \/\//" \
-e "/  assign hb0_gtwiz_userclk_tx_reset_int = ~(/a\  assign hb0_gtwiz_userclk_tx_reset_int = ~( &txpmaresetdone_int);  " \
-e "/PRBS STIMULUS, CHECKING, AND LINK MANAGEMENT/,+274 d" \
-e "/wire       init_done_int;/,+6 s/^/  \/\//" \
-e "/wire hb_gtwiz_reset_rx_datapath_init_int;/a\  wire hb_gtwiz_reset_rx_datapath_DLx_int; // Josh added to retrain the transceiver's receiver" \
-e "/assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath/s/^/  \/\//"  \
-e "/assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath/a\  assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath_init_int || hb_gtwiz_reset_rx_datapath_DLx_int;" \
-e "s/.rx_data_good_in (sm_link)/.rx_data_good_in (gtwiz_reset_rx_done_int ), \/\/ if you get through bufferbypasss assume data is good.    /" \
-e "/ Synchronize gtpowergood into the free-running clock domain for VIO usage/,+58 d" \
-e "/.i_in   (txprgdivresetdone_int\[0\]),/s/^/  \/\//"  \
-e "/.i_in   (txprgdivresetdone_int\[0\]),/a\    .i_in   (1\'b0),"  \
-e "/wire \[0\:0\] gtwiz_reset_tx_done_vio_sync/s/^/  \/\//"  \
-e "/wire \[0\:0\] gtwiz_reset_rx_done_vio_sync/s/^/  \/\//"  \
-e "/Instantiate the VIO IP/,+100 d" \
-e "s/example_wrapper_inst/example_wrapper0_inst/" \
-e "/.gtwiz_userclk_tx_usrclk2_out            (gtwiz_userclk_tx_usrclk2_int)/a\   ,.gtwiz_userclk_tx_usrclk3_out            (gtwiz_userclk_tx_usrclk3_int)" \
-e "/.gtwiz_userclk_rx_usrclk_out             (gtwiz_userclk_rx_usrclk_int)/,+1 s/^/  \/\//" \
-e "/.txprgdivresetdone_out                   (txprgdivresetdone_int)/s/^/  \/\//" \
-e "/.gtpowergood_out                         (gtpowergood_int)/s/^/  \/\//" \
-e "/.txprgdivresetdone_out                         (txprgdivresetdone_out)/s/^/  \/\//" \
-e "/.rxbufstatus_t                         (rxbufstatus_)/s/^/  \/\//" \
-e "/.rxbufreset_in                         (rxbufreset_in)/s/^/  \/\//" \
-e "/,.drpaddr_in                              (drpaddr_int)/,+25 d" \
./gtwizard_ultrascale_0_example_top.v  > dlx_phy_wrap_ref.v



sed -i '/output wire ch7_gtytxp_out,/{n;n;r adding_ice1
}' dlx_phy_wrap_ref.v

sed -i '/assign hb0_gtwiz_userclk_rx_active_int = gtwiz_userclk_rx_active_int/{n;n;r adding_ice2
}' dlx_phy_wrap_ref.v

sed -i '/IBUFDS_GTE4_MGTREFCLK0_X0Y0_INST/{n;n;n;n;n;n;n;r adding_ice3
}' dlx_phy_wrap_ref.v

sed -i '/assign hb0_gtwiz_userclk_rx_reset_int = ~(/{n;n;n;r adding_ice4
}' dlx_phy_wrap_ref.v

sed -i '/.o_out  (gtwiz_reset_rx_done_vio_sync\[0\])/{n;n;r adding_ice5
}' dlx_phy_wrap_ref.v

sed -i '/,.qpll1outrefclk_out                      (qpll1outrefclk_int)/{r adding_ice6
}' dlx_phy_wrap_ref.v
