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

# This executes several scripts. They assume Xilinx example has been prepared and will create the corresponding device ICE files.
./gtwiz_phy2wrap_ref_4ice.sh
./gtwiz_wrap_ref2wrap0_4ice.sh
./gtwiz_reset.sh
./gtwiz_userclk_tx_dlx.sh
./gtwiz_bit_sync.sh
./gtwiz_init_dlx.sh
./gtwiz_wrapper0_4ice.sh
