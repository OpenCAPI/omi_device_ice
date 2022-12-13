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

#############################################################################
# create_ICE_IPs was coded to get rid of xci calls too dependent on frequency and vivado release
# IPs are configured as in ice_astra_b20b168(333MHz) and ice_astra_a032d32(400MHz)
#############################################################################

#############################################################################
# create_ICE_IPs was coded to get rid of xci calls too dependent on frequency and vivado release
# IPs are configured as in ice_astra_b20b168_400
#############################################################################
proc create_ICE_IPs {} {
    variable OMI_FREQ
    variable DESIGN
    set cwd [file dirname [file normalize [info script]]]
    set ip_dir   $cwd/../ip_created_for_$DESIGN
    if {[catch {file mkdir $ip_dir} err opts] != 0} {
        puts $err
    }
    set log_file $cwd/$DESIGN/create_ip.log

  puts "                        generating IP axi_iic_0"
  create_ip -name axi_iic -vendor xilinx.com -library ip -version 2.* -module_name axi_iic_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                  \
                      CONFIG.AXI_ACLK_FREQ_MHZ {67}         \
                      CONFIG.C_SCL_INERTIAL_DELAY {8}       \
                      CONFIG.C_SDA_INERTIAL_DELAY {8}       \
                      ] [get_ips axi_iic_0]

  set_property generate_synth_checkpoint false [get_files $ip_dir/axi_iic_0/axi_iic_0.xci]   
  generate_target {instantiation_template}     [get_files $ip_dir/axi_iic_0/axi_iic_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/axi_iic_0/axi_iic_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/axi_iic_0/axi_iic_0.xci] -no_script  >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/axi_iic_0/axi_iic_0.xci] -directory $ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP jtag_axi_0"
  create_ip -name jtag_axi -vendor xilinx.com -library ip -version 1.2 -module_name jtag_axi_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                \
                      CONFIG.PROTOCOL {2}                 \
                      CONFIG.M_AXI_ADDR_WIDTH {64}        \
                      ] [get_ips jtag_axi_0]
  set_property generate_synth_checkpoint false [get_files $ip_dir/jtag_axi_0/jtag_axi_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/jtag_axi_0/jtag_axi_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/jtag_axi_0/jtag_axi_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/jtag_axi_0/jtag_axi_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/jtag_axi_0/jtag_axi_0.xci] -directory $ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP in_system_ibert_0"
  create_ip -name in_system_ibert -vendor xilinx.com -library ip -version 1.0 -module_name DLx_phy_in_system_ibert_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                                           \
                      CONFIG.C_GT_TYPE {GTY}                                         \
                      CONFIG.C_GTS_USED { X0Y11 X0Y10 X0Y9 X0Y8 X0Y7 X0Y6 X0Y5 X0Y4} \
                      CONFIG.C_ENABLE_INPUT_PORTS {true}                             \
                      ] [get_ips DLx_phy_in_system_ibert_0]

  set_property generate_synth_checkpoint false [get_files $ip_dir/DLx_phy_in_system_ibert_0/DLx_phy_in_system_ibert_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/DLx_phy_in_system_ibert_0/DLx_phy_in_system_ibert_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/DLx_phy_in_system_ibert_0/DLx_phy_in_system_ibert_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/DLx_phy_in_system_ibert_0/DLx_phy_in_system_ibert_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/DLx_phy_in_system_ibert_0/DLx_phy_in_system_ibert_0.xci] -directory $ip_dir/ip_user_files/sim_scripts -force >> $log_file

  puts "                        generating IP ddr4_0"

  create_ip -name ddr4 -vendor xilinx.com -library ip -version 2.2 -module_name ddr4_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                       \
                      CONFIG.C0.DDR4_TimePeriod {938}            \
                      CONFIG.C0.DDR4_InputClockPeriod {8256}     \
                      CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5}          \
                      CONFIG.C0.DDR4_MemoryPart {DDR4_CUSTOM}    \
                      CONFIG.C0.DDR4_DataWidth {72}              \
                      CONFIG.C0.DDR4_CasLatency {16}             \
                      CONFIG.C0.DDR4_CasWriteLatency {11}        \
                      CONFIG.C0.DDR4_CustomParts {../../ice/src/csv/custom_parts_ddr4_mt_x8_16Gb_2133mhz.csv}  \
                      CONFIG.C0.DDR4_isCustom {true}             \
                      CONFIG.C0.CKE_WIDTH {2}                    \
                      CONFIG.C0.CS_WIDTH {2}                     \
                      CONFIG.C0.ODT_WIDTH {2}                    \
                      ] [get_ips ddr4_0]

  set_property generate_synth_checkpoint false [get_files $ip_dir/ddr4_0/ddr4_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/ddr4_0/ddr4_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/ddr4_0/ddr4_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/ddr4_0/ddr4_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/ddr4_0/ddr4_0.xci] -directory $ip_dir/ip_user_files/sim_scripts -force >> $log_file


  if { $OMI_FREQ == "333" } {
     puts "                        generating IP gtwizard_ultrascale_0 for 333MHz"
  } elseif { $OMI_FREQ == "400" } {
     puts "                        generating IP gtwizard_ultrascale_0 for 400MHz"
  } else {
     puts "ERROR:                  unrecognized frequency for IP gtwizard_ultrascale_0"
     exit
  }
  create_ip -name gtwizard_ultrascale -vendor xilinx.com -library ip -version 1.7 -module_name gtwizard_ultrascale_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                                               \
                      CONFIG.GT_TYPE {GTY}                                               \
                      CONFIG.CHANNEL_ENABLE {X0Y11 X0Y10 X0Y9 X0Y8 X0Y7 X0Y6 X0Y5 X0Y4}  \
                      CONFIG.TX_MASTER_CHANNEL {X0Y7}                                    \
                      CONFIG.RX_MASTER_CHANNEL {X0Y7}                                    \
                      CONFIG.TX_DATA_ENCODING {64B66B}                                   \
                      CONFIG.TX_USER_DATA_WIDTH {64}                                     \
                      CONFIG.TX_INT_DATA_WIDTH {64}                                      \
                      CONFIG.RX_DATA_DECODING {64B66B}                                   \
                      CONFIG.RX_USER_DATA_WIDTH {64}                                     \
                      CONFIG.RX_INT_DATA_WIDTH {64}                                      \
                      CONFIG.RX_JTOL_FC {10}                                             \
                      CONFIG.RX_CB_MAX_LEVEL {4}                                         \
                      CONFIG.LOCATE_IN_SYSTEM_IBERT_CORE {EXAMPLE_DESIGN}                \
                      CONFIG.TX_OUTCLK_SOURCE {TXPROGDIVCLK}                             \
                      CONFIG.ENABLE_OPTIONAL_PORTS {rxpolarity_in}                       \
                      ] [get_ips gtwizard_ultrascale_0]
  if { $OMI_FREQ == "333" } {
    set_property -dict [list                                                             \
                      CONFIG.TX_LINE_RATE {21.333333328}                                 \
                      CONFIG.TX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.RX_LINE_RATE {21.333333328}                                 \
                      CONFIG.RX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.TXPROGDIV_FREQ_VAL {333.3333333}                            \
                      CONFIG.RX_REFCLK_SOURCE {X0Y11 clk1+1 X0Y10 clk1+1 X0Y9 clk1+1 X0Y8 clk1+1}  \
                      CONFIG.TX_REFCLK_SOURCE {X0Y11 clk1+1 X0Y10 clk1+1 X0Y9 clk1+1 X0Y8 clk1+1}  \
                      CONFIG.FREERUN_FREQUENCY {67}                                      \
                      ] [get_ips gtwizard_ultrascale_0]

  } elseif { $OMI_FREQ == "400" } {
    set_property -dict [list                                                             \
                      CONFIG.TX_LINE_RATE {25.6}                                         \
                      CONFIG.TX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.RX_LINE_RATE {25.6}                                         \
                      CONFIG.RX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.TXPROGDIV_FREQ_VAL {400}                                    \
                      CONFIG.RX_REFCLK_SOURCE {X0Y11 clk1+1 X0Y10 clk1+1 X0Y9 clk1+1 X0Y8 clk1+1}                                         \
                      CONFIG.TX_REFCLK_SOURCE {X0Y11 clk1+1 X0Y10 clk1+1 X0Y9 clk1+1 X0Y8 clk1+1}                                         \
                      CONFIG.FREERUN_FREQUENCY {67}                                      \
                      ] [get_ips gtwizard_ultrascale_0]
  }

  set_property generate_synth_checkpoint false [get_files $ip_dir/gtwizard_ultrascale_0/gtwizard_ultrascale_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/gtwizard_ultrascale_0/gtwizard_ultrascale_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/gtwizard_ultrascale_0/gtwizard_ultrascale_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/gtwizard_ultrascale_0/gtwizard_ultrascale_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/gtwizard_ultrascale_0/gtwizard_ultrascale_0.xci] -directory $ip_dir/ip_user_files/sim_scripts -force >> $log_file

  puts "                        generating IP DLx_phy_vio_0"
  create_ip -name vio -vendor xilinx.com -library ip -version 3.0 -module_name DLx_phy_vio_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                       \
                      CONFIG.C_PROBE_OUT6_INIT_VAL {0x1}         \
                      CONFIG.C_PROBE_OUT2_INIT_VAL {0x1}         \
                      CONFIG.C_PROBE_OUT1_INIT_VAL {0x1}         \
                      CONFIG.C_PROBE_IN6_WIDTH {8}               \
                      CONFIG.C_PROBE_IN5_WIDTH {8}               \
                      CONFIG.C_PROBE_IN4_WIDTH {8}               \
                      CONFIG.C_PROBE_IN3_WIDTH {4}               \
                      CONFIG.C_NUM_PROBE_OUT {7}                 \
                      CONFIG.C_NUM_PROBE_IN {13}                 \
                      ] [get_ips DLx_phy_vio_0]
  
  set_property generate_synth_checkpoint false [get_files $ip_dir/DLx_phy_vio_0/DLx_phy_vio_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/DLx_phy_vio_0/DLx_phy_vio_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/DLx_phy_vio_0/DLx_phy_vio_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/DLx_phy_vio_0/DLx_phy_vio_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/DLx_phy_vio_0/DLx_phy_vio_0.xci] -directory $ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP vio_reset_n"
  create_ip -name vio -vendor xilinx.com -library ip -version 3.0 -module_name vio_reset_n -dir $ip_dir >> $log_file
  set_property -dict [list                                      \
                      CONFIG.C_PROBE_OUT0_INIT_VAL {0x1}        \
                      CONFIG.C_NUM_PROBE_OUT {2}                \
                      CONFIG.C_NUM_PROBE_IN {2}                 \
                      ] [get_ips vio_reset_n]
  
  set_property generate_synth_checkpoint false [get_files $ip_dir/vio_reset_n/vio_reset_n.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/vio_reset_n/vio_reset_n.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/vio_reset_n/vio_reset_n.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/vio_reset_n/vio_reset_n.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/vio_reset_n/vio_reset_n.xci] -directory $ip_dir/ip_user_files/sim_scripts -force >> $log_file

puts "----------------------- Creating a projet example based on gtwizard_ultrascale -------------"
open_example_project -force -quiet -dir $ip_dir [get_ips  gtwizard_ultrascale_0]
puts "----------------------- Project example creation completed ---------------------------------"
puts "                            Preparing DLx Files from gtwizard_ultrascale_0_ex project"
exec bash -c "cp $ip_dir/../scripts/* $ip_dir/gtwizard_ultrascale_0_ex/imports"
exec bash -c "cd $ip_dir/gtwizard_ultrascale_0_ex/imports; ./all_shells4ice.sh"
exec bash -c "rm $ip_dir/gtwizard_ultrascale_0_ex/imports/dlx_phy_wrap_ref.v"
# exec bash -c "rm $ip_dir/gtwizard_ultrascale_0_ex/imports/DLx_phy_example_wrapper_ref.v"
puts "                            Copying verilog DLx files into ../$DESIGN/src/verilog/"
exec bash -c "cp $ip_dir/gtwizard_ultrascale_0_ex/imports/DLx_phy_example* $ip_dir/../$DESIGN/src/verilog/"
puts "                            Copying verilog top files into ../$DESIGN/src/verilog/dlx_phy_wrapxx"
exec bash -c "cp $ip_dir/gtwizard_ultrascale_0_ex/imports/dlx_phy* $ip_dir/../$DESIGN/src/verilog/"

puts "                            Moving wrapper functions into new ../$DESIGN/src/headers/ directory"

if {[catch {file mkdir $ip_dir/../$DESIGN/src/headers} err opts] != 0} {
    puts $err
}
exec bash -c "mv $ip_dir/../$DESIGN/src/verilog/DLx_phy_example_wrapper_functions.v $ip_dir/../$DESIGN/src/headers/"



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

