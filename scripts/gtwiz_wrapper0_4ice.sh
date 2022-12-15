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

# First we generate a reference file, that will be used to create a wrapper for the device port
# Before output, removing the comma helps avoiding misinterpretation
# We also need to escape : "," "[" with an "\" otherwise we can't replace the desired lines.
# When appending, before the appended string a "\" is required to take into account the space of the line beginning
# First we make a general replacement
# Then we "append" (a) the clk3 line
# Comment the rx section
# Remove the gtpowergood "wire" line
# We use " char instead of ' char when we already use ' char in strings !
# We finally save created file into a reference wrapper file.

echo "Creating DLx_phy_example_wrapper_ref.v"
sed -e 's/gtwizard_ultrascale_0/DLx_phy/g' \
    -e "s/gtrefclk00/gtrefclk01/g" \
    -e "s/qpll0/qpll1/g" \
    -e '/output wire \[0\:0\] gtwiz_userclk_tx_usrclk2_out/a\ ,output wire \[0\:0\] gtwiz_userclk_tx_usrclk3_out'\
    -e '/output wire \[0\:0\] gtwiz_userclk_rx_usrclk_out/s/^/\/\//'\
    -e '/output wire \[0\:0\] gtwiz_userclk_rx_usrclk2_out/s/^/\/\//'\
    -e '/output wire \[7\:0\] gtpowergood_out/d'\
    -e '/output wire \[7\:0\] txprgdivresetdone_out/s/^/\/\//'\
    -e '/example_gtwiz_userclk_rx/,+6 s/^/\/\//' \
    -e "s/.*localparam \[191\:0\] P_CHANNEL_ENABLE = 192.*/  localparam \[191\:0\] P_CHANNEL_ENABLE = 192\'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111000000000000;/"\
    -e 's/calc_pk_mc_idx(7)/calc_pk_mc_idx(16)/'\
    -e "/wire \[7\:0\] txoutclk_int/a\  wire gtwiz_userclk_tx_active_int;"\
    -e "/gtwiz_userclk_tx_usrclk2_out (gtwiz_userclk_tx_usrclk2_out),/a\    .gtwiz_userclk_tx_usrclk3_out (gtwiz_userclk_tx_usrclk3_out),\n    .gtwiz_userclk_tx_active_out  (gtwiz_userclk_tx_active_int)"\
    -e '/gtwiz_userclk_tx_active_out  (gtwiz_userclk_tx_active_out)/d'\
    -e '/.gtwiz_userclk_tx_usrclk3_out (gtwiz_userclk_tx_usrclk3_out),/c\    .gtwiz_userclk_tx_active_out  (gtwiz_userclk_tx_active_int)/'\
    -e "/assign txusrclk2_int = {8{gtwiz_userclk_tx_usrclk2_out}}/a\  assign gtwiz_userclk_tx_active_out = gtwiz_userclk_tx_active_int;"\
    -e 's/rxoutclk_int\[P_RX_MASTER_CH_PACKED_IDX\]/txoutclk_int\[P_RX_MASTER_CH_PACKED_IDX\]/'\
    -e '/Drive RXUSRCLK and RXUSRCLK2/a \  /*'\
    -e "/wire \[7:0\] gtpowergood_int;/d"\
    -e '/Required assignment to expose the GTPOWERGOOD/,+1 s/^/\/\//' \
    -e "/wire \[7\:\0] gtpowergood_int;/a\  wire [7:0] txprgdivresetdone_out;"\
    -e "/,.gtwiz_userclk_tx_active_in /a\    ,.gtpowergood_out                         (gtpowergood_out)"\
    -e "s/active_in              (gtwiz_userclk_rx_active_out)/active_in              (gtwiz_userclk_tx_active_int)/"\
    -e '/gtpowergood_out                         (gtpowergood_int)/d'\
    -e 's/(rxusrclk/(txusrclk/'\
    -e "/,.gtrefclk01_in                           (gtrefclk01_in)/,+2 d"\
    -e "/,.gtwiz_userdata_rx_out                   (gtwiz_userdata_rx_out)/a\   ,.gtrefclk00_in                           (gtrefclk01_in)\n\
   ,.qpll0outclk_out                         (qpll1outclk_out)\n\
   ,.qpll0outrefclk_out                      (qpll1outrefclk_out)"\
    -e "/wire \[7:0\] gtpowergood_out;/a\  wire \[7:0\] txprgdivresetdone_out;\n"\
  ./gtwizard_ultrascale_0_example_wrapper.v  > DLx_phy_example_wrapper_ref.v

#    -e '/(rxrate_in)/ s/^/\/\//' \
#    -e "/,.gtwiz_userclk_rx_active_in              (gtwiz_userclk_rx_active_out)/s/^/\/\//"\
#    -e '/txprgdivresetdone_out                   (txprgdivresetdone_out)/d';a\,.rxpolarity_in                           (rxpolarity_in)\

sed -i '/assign gtwiz_userclk_rx_active_out = gtwiz_userclk_tx_active_int;/r adding_fire1' DLx_phy_example_wrapper_ref.v
sed -i '/assign rxusrclk2_int = {8{gtwiz_userclk_rx_usrclk2_out}}/r adding_ice7' DLx_phy_example_wrapper_ref.v
#echo "Reference wrapper written"

#    -e "/txoutclk_int/a  wire gtwiz_userclk_tx_active_int"\    
# Tuning the reference wrapper for port 0
sed -e 's/module DLx_phy_example_wrapper/module DLx_phy_example_wrapper0/'\
    -e 's/ DLx_phy DLx_phy_inst (/gtwizard_ultrascale_0 DLx_phy (/g' \
     DLx_phy_example_wrapper_ref.v > ./DLx_phy_example_wrapper0.v


# AC : the following is actually just a simple copy
 sed -e 's/gtwizard_ultrascale_0/DLx_phy/g' \
      ./gtwizard_ultrascale_0_example_wrapper_functions.v  > DLx_phy_example_wrapper_functions.v

