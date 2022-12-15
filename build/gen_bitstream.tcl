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
# Arguments
################################################################################
# Pick results from an implementation strategy
if {$argc > 0} {
    variable strategy_index [lindex $argv 0]
    puts "                    Running with results from implementation strategy $strategy_index."
} else {
    variable strategy_index 1
    puts "                    Running with results from default implementation strategy $strategy_index."
}

################################################################################
# Project Settings
################################################################################
# Source Directory
#  Path to source directory containing vhdl/ and verilog/ directories
variable SRC_DIR $::env(SRC_DIR)

# Output Directory
variable OUTPUT_DIR $::env(OUTPUT_PREFIX)

# Design Selected
variable DESIGN $::env(DESIGN)
set cwd [file dirname [file normalize [info script]]]
variable TRACE_MODE $::env(TRACE_MODE)
#if {( $TRACE_MODE == "no")} {
  set logfile  $cwd/$DESIGN/gen_bitstream_script.log
#}
#
################################################################################
# Open Routing Checkpoint
################################################################################
puts "                    Opening post route design checkpoint ./impl_$strategy_index/post_route.dcp"
open_checkpoint $OUTPUT_DIR/impl_$strategy_index/post_route.dcp  >> $logfile

################################################################################
# Generate Bitstream
################################################################################
puts "                    Writing bitstream "
write_bitstream -force $OUTPUT_DIR/$DESIGN.bit >> $logfile
puts "                    Writing debug probes"
write_debug_probes -force $OUTPUT_DIR/$DESIGN.ltx >> $logfile
