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

# Preparing first DDIMM attachment
sed -e 's/DLx_phy_example_wrapper/DLx_phy_example_wrapper0/' \
    -e 's/module DLx_phy_example_top /module dlx_phy_wrap0/'   ./dlx_phy_wrap_ref.v > dlx_phy_wrap0.v
 
# Preparing second DDIMM attachment
if [ -d "../../gtwizard_ultrascale_1" ]; then
sed -e 's/DLx_phy_example_wrapper/DLx_phy_example_wrapper1/' \
    -e 's/module DLx_phy_example_top /module dlx_phy_wrap1/' ./dlx_phy_wrap_ref.v > dlx_phy_wrap1.v
fi

if [ -d "../../gtwizard_ultrascale_2" ]; then
# Preparing third DDIMM attachment if any
sed -e 's/DLx_phy_example_wrapper/DLx_phy_example_wrapper2/' \
    -e 's/module DLx_phy_example_top /module dlx_phy_wrap2/' ./dlx_phy_wrap_ref.v > dlx_phy_wrap2.v
fi

if [ -d "../../gtwizard_ultrascale_3" ]; then
# Preparing forth DDIMM attachment if any
sed -e 's/DLx_phy_example_wrapper/DLx_phy_example_wrapper3/' \
    -e 's/module DLx_phy_example_top /module dlx_phy_wrap3/' ./dlx_phy_wrap_ref.v > dlx_phy_wrap3.v
fi
