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

# the following already appears later in the file
# sed -i "/bit_synchronizer_vio_gtwiz_reset_tx_done_0_inst/{N;N;N;N; a \ \n\
#  \/\/ Synchronize gtwiz_buffbypass_rx_done into the free-running clock domain for VIO usage\n\
#  wire [0:0] gtwiz_buffbypass_rx_done_vio_sync;\n\
#\n\
#  DLx_phy_example_bit_synchronizer bit_synchronizer_vio_gtwiz_buffbypass_rx_done_0_inst (\n\
#   \.clk_in (hb_gtwiz_reset_clk_freerun_buf_int),\n\
#   \.i_in  (gtwiz_reset_rx_done_int[0]),\n\
#   \.o_out  (gtwiz_buffbypass_rx_done_vio_sync[0])\n\
#  );\n
#} " dlx_phy_wrap_ref.v

# Preparing ICE DDIMM attachment
# \nparameter GEMINI_NOT_APOLLO = 0\n) (
sed -e 's/DLx_phy_example_wrapper/DLx_phy_example_wrapper0/' \
    -e 's/module DLx_phy_example_top /module dlx_phy_wrap0 #(\nparameter GEMINI_NOT_APOLLO = 0\n) /'   ./dlx_phy_wrap_ref.v > dlx_phy_wrap0.v
