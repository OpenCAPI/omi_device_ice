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

sed -e 's/gtwizard_ultrascale_0/DLx_phy/g' \
-e '/parameter integer P_FREQ_RATIO_USRCLK_TO_USRCLK2 = 1/ c \  parameter integer P_FREQ_RATIO_USRCLK_TO_USRCLK2 = 1,\n  parameter integer P_FREQ_RATIO_USRCLK_TO_USRCLK3 = 2' \
-e '64 a \  parameter integer P_FREQ_RATIO_USRCLK_TO_USRCLK3 = 2' \
-e '/output wire gtwiz_userclk_tx_usrclk2_out,/ a \  output wire gtwiz_userclk_tx_usrclk3_out,' \
-e '/P_USRCLK2_DIV     =/ a\  localparam integer P_USRCLK3_INT_DIV = (P_FREQ_RATIO_SOURCE_TO_USRCLK * P_FREQ_RATIO_USRCLK_TO_USRCLK3) - 1;\n  localparam   [2:0] P_USRCLK3_DIV     = P_USRCLK3_INT_DIV[2:0];' \
-e "124 i \      if (P_FREQ_RATIO_USRCLK_TO_USRCLK3 == 1)\n\
        assign gtwiz_userclk_tx_usrclk3_out = gtwiz_userclk_tx_usrclk_out;\n\
      else begin\n\
        BUFG_GT bufg_gt_usrclk3_inst (\n\
          .CE      (1'b1),\n\
          .CEMASK  (1'b0),\n\
          .CLR     (gtwiz_userclk_tx_reset_in),\n\
          .CLRMASK (1'b0),\n\
          .DIV     (P_USRCLK3_DIV),\n\
          .I       (gtwiz_userclk_tx_srcclk_in),\n\
          .O       (gtwiz_userclk_tx_usrclk3_out)\n\
        );\n\
      end\n"  ./gtwizard_ultrascale_0_example_gtwiz_userclk_tx.v  > DLx_phy_example_gtwiz_userclk_tx.v
