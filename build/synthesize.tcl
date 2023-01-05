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
# current design
variable OMI_FREQ $::env(OMI_FREQ)
variable DESIGN $::env(DESIGN)
variable BOARD $::env(BOARD)
variable OMI_PORTS $::env(OMI_PORTS)
variable XILINX_VERSION $::env(XILINX_VERSION)
variable DEBUG_MODE $::env(DEBUG_MODE)
variable TRACE_MODE $::env(TRACE_MODE)

# Top Level Block
#  Name of vhdl file with top level of design
variable TOP_LEVEL $::env(TOP_LEVEL)

# Source Directory
#  Path to source directory containing vhdl/ and verilog/ directories
#  DLX files are stored separately because they are shared
variable SRC_DIR $::env(SRC_DIR)
variable BRD_DIR $::env(BRD_DIR)
variable DLX_DIR $::env(DLX_DIR)

# Output Directory
variable OUTPUT_DIR $::env(OUTPUT_PREFIX)/synth_1

################################################################################
# Procedures
################################################################################

# Assemble a list of library paths and files used from those
# libraries, and then read them in to the respective library.
proc setup_lib {} {

    set cwd [file dirname [file normalize [info script]]]

    # Set library path(s)
    dict set libraries ibm [list $cwd/../ibm]
    dict set libraries support [list $cwd/../support]

    # Loop through the list of desired library files and pull them into their namespace
    foreach { library filename } [ list \
                                       ibm synthesis_support \
                                       ibm std_ulogic_support \
                                       ibm std_ulogic_function_support \
                                       ibm std_ulogic_unsigned \
                                       support logic_support_pkg \
                                      ] {
        set path_list [dict get $libraries $library]
        set found 0
        foreach path $path_list {
            if { [file exists $path/$filename.vhdl] } {
                read_vhdl -library $library [ glob $path/$filename.vhdl ]
                set found 1
            }
        }
        if { $found == 0 } {
            puts "ERROR: Couldn't find $filename in library $library"
            exit 1
        }
    }
}


proc yesNoPrompt {} {
  set data ""
  set valid 0 
  while {!$valid} {
    gets stdin data
    set valid [expr {($data == y) || ($data == n)}]
    if {!$valid} {
        puts "Choose either y or n"
    }
  }

  if {$data == y} {
          return 1
  } elseif {$data == n} {
          return 0
  }
}

variable DESIGN
variable BOARD
variable OMI_PORTS
################################################################################
# Display configuration
################################################################################
set cwd [file dirname [file normalize [info script]]]
#if {( $TRACE_MODE == "no")} {
  set logfile  $cwd/$DESIGN/synthesize_script.log
#}

#get vivado release
set vivado_major_release [exec vivado -nolog -nojournal -version | grep "Vivado v" | cut -d "." -f1 | tr -d "Vivado "]
set vivado_minor_release [exec vivado -nolog -nojournal -version | grep "Vivado v" | cut -d "." -f2 | cut -d " " -f1]
set vivado_release $vivado_major_release.$vivado_minor_release
#puts "vivado_release is $vivado_release"

puts "    ==================================================================="
puts "    == CONFIGURATION parameters used to build the image ('run' file) =="
puts "     Design is   : $DESIGN"
puts "     Vivado used : $vivado_release"
puts "     Frequency   : $OMI_FREQ MHz"
puts "     Xilinx FPGA : $XILINX_PART"
puts "     Debug mode  : $DEBUG_MODE"
puts "     Trace mode  : $TRACE_MODE"
puts "    ==================================================================="
#puts " Is it ok to start the build process? (y/n)"
flush stdout
#if { [yesNoPrompt] == 1} {
#  puts "Start building process"
#} else {
#  exit
#}
#
# Generate version information
puts [exec $cwd/write_git_meta.sh]
set ip_dir   $cwd/../ip_created_for_$DESIGN

################################################################################
# Create Project
################################################################################

file mkdir $OUTPUT_DIR

if {( $DEBUG_MODE == "yes")} {
  puts "                    Creating project $DESIGN"
  create_project $DESIGN\_$XILINX_VERSION -force -part $XILINX_PART  >> $logfile
} else {
  puts "                    Creating project $DESIGN in memory"
  create_project -in_memory -part $XILINX_PART  >> $logfile
}

################################################################################
# Add Design Sources
################################################################################

if {( $DESIGN == "fire")} {
  #unused for ice 
  setup_lib 
}
#=======================================
# Rather than using xci files, regenerate the xci depending on the OMI frequency and the vivado release
#read_ip [ glob $SRC_DIR/ip/*/*/*.xci ]
set OMI_IPs_exist_filename [concat .OMI_IPs_$DESIGN\_$vivado_release\_$OMI_FREQ\MHZ\_$XILINX_PART]
#puts "looking for file $OMI_IPs_exist_filename"
set previous_OMI_IPs [glob -types f -nocomplain exists .OMI_IPs_$DESIGN\_* ]

if { [file exists $OMI_IPs_exist_filename] } {
  puts "                    OMI IPs are already created"
  puts "                        reading IPs from ../ip_created_for_$DESIGN"
  read_ip [ glob $ip_dir/*/*.xci ] >> $logfile
} else {
  #if { [glob -types f -nocomplain exists .OMI_IPs_$DESIGN\_* ] != "" } 
  if { $previous_OMI_IPs != "" } {
    puts "      OMI IPs have been created for a different frequency or vivado release:"
    puts "          ($previous_OMI_IPs)"
    puts "      Do you want to delete these old IP generated ? (y/n): "
    flush stdout
    if { [yesNoPrompt] == 1} {
      file delete -force $ip_dir 
      file delete {*}[glob .OMI_IPs_$DESIGN\_*]
      puts "      Recreating IPs"
    } else {
      puts "      OK keeping IPs in $ip_dir. Exiting"
      exit
    }
  } else {
    puts "                    OMI IPs have not been created yet"
    puts "                        creating them in ../ip_created_for_$DESIGN directory:"
  }
  if {( $DESIGN == "ice")} {
    source ./create_ip_ice.tcl
    create_ICE_IPs
  } else {
    source ./create_ip_fire.tcl
    create_FIRE_IPs
  }
  # if the IP have been succesfully created then a hidden file .OMI_IPs_... will be created
  exec touch $OMI_IPs_exist_filename
  puts "                    All IPs successully created"
}
#=======================================

puts "                    reading all verilog and vhdl sources files"
if {( $DESIGN == "ice")} {
  read_vhdl [ glob $BRD_DIR/ice_top.vhdl ]
} else {
  read_vhdl [ glob $BRD_DIR/fire_top.vhdl ]
}
read_vhdl [ glob $SRC_DIR/vhdl/*.vhdl ]
if {( $DESIGN == "ice")} {
  set_property file_type "VHDL 2008" [ get_files [ glob $SRC_DIR/vhdl/ice_gmc_arb.vhdl ] ]
  set_property file_type "VHDL 2008" [ get_files [ glob $SRC_DIR/vhdl/ice_gmc_xfifo.vhdl ] ]
}
read_verilog [ glob $SRC_DIR/headers/*.v ]
set_property file_type "Verilog Header" [ get_files [ glob $SRC_DIR/headers/*.v ] ]
read_verilog [ glob $DLX_DIR/*.v ]
read_verilog [ glob $SRC_DIR/verilog/*.v ]
puts "                    reading timings constraints (timing.xdc)"
read_xdc [ glob $BRD_DIR/timing.xdc ]

if {( $DEBUG_MODE == "yes")} {
   #add pins constraints file so that it is contained in the xpr project in debug mode
   #This file is usually added and used in implementation script
   read_xdc [ glob $BRD_DIR/pins.xdc ]
}

################################################################################
# Run Synthesis & Generate Reports
################################################################################
# Out-Of-Context synthesis for IPs
foreach ip [get_ips] {
    set ip_filename [get_property IP_FILE $ip]
    set ip_dcp [file rootname $ip_filename]
    append ip_dcp ".dcp"
    set ip_xml [file rootname $ip_filename]
    append ip_xml ".xml"
    puts "                        synthesizing IP $ip"

    if {([file exists $ip_dcp] == 0) || [expr {[file mtime $ip_filename ] > [file mtime $ip_dcp ]}]} {

        # remove old files of IP, if still existing
        reset_target all $ip
        file delete $ip_xml

        # re-generate the IP
        generate_target all $ip >> $logfile
        set_property generate_synth_checkpoint true [get_files $ip_filename] >> $logfile
        synth_ip $ip >> $logfile
    }
}

# Settings from Flow_PerfOptimized_high strategy (see UG904 for more details)
if {( $DEBUG_MODE == "yes")} {
  set_property strategy Flow_PerfOptimized_high [get_runs synth_1] >> $logfile
}
puts "                    Synthesizing design"
synth_design -top $TOP_LEVEL -part $XILINX_PART -fanout_limit 400 -fsm_extraction one_hot -shreg_min_size 5 >> $logfile

# For some reason this doesn't show up in the output directory automatically
if {[file exists fsm_encoding.os]} {
    file rename -force fsm_encoding.os $OUTPUT_DIR/fsm_encoding.os >> $logfile
}

# ILA sometimes causes problems, so checkpoint here for easier debug
#puts "                    Write checkpoint before ILA insertion (pre_ila)"
#write_checkpoint -force $OUTPUT_DIR/pre_ila >> $logfile

#=====================
source "$cwd/insert_ila.tcl" 
puts "                    Insert ila automatically generated"
insert_ila
puts "----------------------- ILA insertion process completed ---------"

##An option is to use predefined signals
#read_xdc [ glob $BRD_DIR/ila.xdc ]

#=====================
puts "                    Write checkpoint after ILA insertion (../synth_1/post_synth.dcp)"
write_checkpoint -force $OUTPUT_DIR/post_synth >> $logfile
puts "                    Generating post synthesis timing report"
report_timing_summary -file $OUTPUT_DIR/post_synth_timing_summary.rpt >> $logfile
puts "                    Generating post synthesis power report"
report_power -file $OUTPUT_DIR/post_synth_power.rpt >> $logfile
