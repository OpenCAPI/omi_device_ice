
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

################################################################################
# Project Settings
################################################################################

# Target FPGA
variable XILINX_PART $::env(XILINX_PART)
variable DESIGN $::env(DESIGN)

# Output Directory
variable OUTPUT_DIR $::env(SRC_DIR)/ip

################################################################################
# Create Project
################################################################################
create_project managed_ip_project $OUTPUT_DIR/managed_ip_project -part $XILINX_PART -ip -force
add_files -norecurse [ glob $OUTPUT_DIR/../../../ip_created_for_$DESIGN/*/*.xci ]
start_gui
