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
# Pick an implementation strategy, with settings derived from the GUI
if {$argc > 0} {
    variable strategy_index [lindex $argv 0]
    puts "                    Running with implementation strategy $strategy_index."
} else {
    variable strategy_index 1
    puts "                    Running with default implementation strategy $strategy_index."
}

################################################################################
# Project Settings
################################################################################
# Source Directory
#  Path to source directory containing vhdl/ and verilog/ directories
variable SRC_DIR $::env(SRC_DIR)
variable BRD_DIR $::env(BRD_DIR)

# Output Directory
variable OUTPUT_DIR $::env(OUTPUT_PREFIX)/impl_$strategy_index

# Target FPGA
variable XILINX_PART $::env(XILINX_PART)

set cwd [file dirname [file normalize [info script]]]
variable TRACE_MODE $::env(TRACE_MODE)
variable DESIGN $::env(DESIGN)
#if {( $TRACE_MODE == "no")} {
  set logfile  $cwd/$DESIGN/implement_script.log
#}

################################################################################
# Implementation Strategies => List is available in UG904
################################################################################
set strategies [dict create]

# 1 - Performance_Explore (Vivado Implementation 2017)
dict set strategies  1 [dict create                                                                 \
                            opt_design       "opt_design -directive Explore"                        \
                            place_design     "place_design -directive Explore"                      \
                            phys_opt_design  "phys_opt_design -directive Explore"                   \
                            route_design     "route_design -directive Explore"
                       ]

# 2 - Performance_ExplorePostRoutePhysOpt (Vivado Implementation 2017)
dict set strategies  2 [dict create                                                                 \
                            opt_design       "opt_design -directive Explore"                        \
                            place_design     "place_design -directive Explore"                      \
                            phys_opt_design  "phys_opt_design -directive Explore"                   \
                            route_design     "route_design -directive Explore -tns_cleanup"         \
                            phys_opt_design2 "phys_opt_design -directive Explore"
                       ]

# 3 - Performance_WLBlockPlacement (Vivado Implementation 2017)
dict set strategies  3 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive WLDrivenBlockPlacement"       \
                            phys_opt_design  "phys_opt_design -directive AlternateReplication"      \
                            route_design     "route_design -directive Explore"
                       ]

# 4 - Performance_WLBlockPlacementFanoutOpt (Vivado Implementation 2017)
dict set strategies  4 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive WLDrivenBlockPlacement"       \
                            phys_opt_design  "phys_opt_design -directive AggressiveFanoutOpt"       \
                            route_design     "route_design -directive Explore"
                       ]

# 5 - Performance_EarlyBlockPlacement (Vivado Implementation 2017)
dict set strategies  5 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive EarlyBlockPlacement"          \
                            phys_opt_design  "phys_opt_design -directive Explore"                   \
                            route_design     "route_design -directive Explore"
                       ]

# 6 - Performance_NetDelay_high (Vivado Implementation 2017)
dict set strategies  6 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive ExtraNetDelay_high"           \
                            phys_opt_design  "phys_opt_design -directive AggressiveExplore"         \
                            route_design     "route_design -directive Explore"
                       ]

# 7 - Performance_NetDelay_low (Vivado Implementation 2017)
dict set strategies  7 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive ExtraNetDelay_low"            \
                            phys_opt_design  "phys_opt_design -directive AggressiveExplore"         \
                            route_design     "route_design -directive Explore"
                       ]
                            
# 8 - Performance_Retiming (Vivado Implementation 2017)
dict set strategies  8 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive ExtraPostPlacementOpt"        \
                            phys_opt_design  "phys_opt_design -directive AlternateFlowWithRetiming" \
                            route_design     "route_design -directive Explore"
                       ]

# 9 - Performance_NetDelay_low (Vivado Implementation 2017)
dict set strategies  9 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive ExtraNetDelay_low"            \
                            phys_opt_design  "phys_opt_design -directive AggressiveExplore"         \
                            route_design     "route_design -directive Explore"
                       ]

# 10 - Performance_RefinePlacement (Vivado Implementation 2017)
dict set strategies 10 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive ExtraPostPlacementOpt"        \
                            phys_opt_design  "phys_opt_design -directive Explore"                   \
                            route_design     "route_design -directive Explore"
                       ]

# 11 - Performance_SpreadSLLs (Vivado Implementation 2017)
dict set strategies 11 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive SSI_SpreadSLLs"               \
                            phys_opt_design  "phys_opt_design -directive Explore"                   \
                            route_design     "route_design -directive Explore"
                       ]

# 12 - Performance_BalanceSLLs (Vivado Implementation 2017)
dict set strategies 12 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive SSI_BalanceSLLs"              \
                            phys_opt_design  "phys_opt_design -directive Explore"                   \
                            route_design     "route_design -directive Explore"
                       ]

# 13 - Congestion_SpreadLogic_high (Vivado Implementation 2017)
dict set strategies 13 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive AltSpreadLogic_high"          \
                            phys_opt_design  "phys_opt_design -directive AggressiveExplore"         \
                            route_design     "route_design -directive AlternateCLBRouting"
                       ]

# 14 - Congestion_SpreadLogic_medium (Vivado Implementation 2017)
dict set strategies 14 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive AltSpreadLogic_medium"        \
                            phys_opt_design  "phys_opt_design -directive Explore"                   \
                            route_design     "route_design -directive AlternateCLBRouting"
                       ]

# 15 - Congestion_SpreadLogic_low (Vivado Implementation 2017)
dict set strategies 15 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive AltSpreadLogic_low"           \
                            phys_opt_design  "phys_opt_design -directive Explore"                   \
                            route_design     "route_design -directive AlternateCLBRouting"
                       ]

# 16 - Congestion_SpreadLogic_Explore (Vivado Implementation 2017)
dict set strategies 16 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive AltSpreadLogic_high"          \
                            phys_opt_design  "phys_opt_design -directive AggressiveExplore"         \
                            route_design     "route_design -directive Explore"
                       ]

# 17 - Performance_ExtraTimingOpt (Vivado Implementation 2021.2)
dict set strategies 17 [dict create                                                                 \
                            opt_design       "opt_design"                                           \
                            place_design     "place_design -directive ExtraTimingOpt"               \
                            phys_opt_design  "phys_opt_design -directive Explore"         \
                            route_design     "route_design -directive NoTimingRelaxation"
                       ]


variable current_strategy [dict get $strategies $strategy_index]

# Don't make the output directory until we know we have a valid strategy argument.
file mkdir $OUTPUT_DIR

################################################################################
# Open Synthesis Checkpoint
################################################################################
puts "                    opening checkpoint ./synth_1/post_synth.dcp"
open_checkpoint $OUTPUT_DIR/../synth_1/post_synth.dcp >> $logfile
puts "                    reading pins constraints (pins.xdc)"
read_xdc [ glob $BRD_DIR/pins.xdc ] >> $logfile


################################################################################
# opt_design
################################################################################
variable command [dict get $current_strategy "opt_design"]
#puts $command
puts "                    Running $command"
eval $command >> $logfile

################################################################################
# place_design
################################################################################
variable command [dict get $current_strategy "place_design"]
#puts $command
puts "                    Running $command"
eval $command >> $logfile

################################################################################
# phys_opt_design
################################################################################
variable command [dict get $current_strategy "phys_opt_design"]
#puts $command
puts "                    Running $command"
eval $command >> $logfile

puts "                    generating post placement timing summary"
report_timing_summary -file $OUTPUT_DIR/post_place_timing_summary.rpt >> $logfile

################################################################################
# route_design
################################################################################
variable command [dict get $current_strategy "route_design"]
#puts $command
puts "                    Running $command"
eval $command >> $logfile

################################################################################
# phys_opt_design2 (if needed)
################################################################################
if [dict exists $current_strategy "phys_opt_design2"] {
    variable command [dict get $current_strategy "phys_opt_design2"]
    #puts $command
    puts "                    Running $command"
    eval $command >> $logfile
}

puts "                    writing post route checkpoint ./impl_$strategy_index/post_route.dcp"
write_checkpoint -force $OUTPUT_DIR/post_route >> $logfile
puts "                    generating post route timing summary report"
report_timing_summary -file $OUTPUT_DIR/post_route_timing_summary.rpt >> $logfile
report_timing -sort_by group -max_paths 100 -path_type summary -file $OUTPUT_DIR/post_route_timing.rpt >> $logfile
puts "                    generating post route clocking utilization summary report"
report_clock_utilization -file $OUTPUT_DIR/clock_util.rpt >> $logfile
puts "                    generating post route utilization summary report"
report_utilization -file $OUTPUT_DIR/post_route_util.rpt >> $logfile
puts "                    generating post route power summary"
report_power -file $OUTPUT_DIR/post_route_power.rpt >> $logfile
puts "                    generating post implementation drc report"
report_drc -file $OUTPUT_DIR/post_imp_drc.rpt >> $logfile
puts "                    writing file bft_impl_netlist.v"
write_verilog -force $OUTPUT_DIR/bft_impl_netlist.v >> $logfile
puts "                    writing file bft_impl.xdc"
write_xdc -no_fixed_only -force $OUTPUT_DIR/bft_impl.xdc >> $logfile
