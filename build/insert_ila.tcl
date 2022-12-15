# Source: https://forums.xilinx.com/t5/Vivado-TCL-Community/Vivado-TCL-script-to-insert-ILA/td-p/421619
######################################################################
# Automatically inserts ILA instances


proc insert_ila {} {

    variable DESIGN
    set cwd [file dirname [file normalize [info script]]]
    set logfile  $cwd/$DESIGN/insert_ila.log

    ##################################################################
    # sequence through debug nets and organize them by clock in the
    # clock_list array. Also create max and min array for bus indices
    set dbgs [get_nets -hierarchical -filter {MARK_DEBUG}]
    if {[llength $dbgs] == 0} {
        return
    }

    #temporarily limit warining messages to 10
    set_msg_config -id {[Timing 38-164]} -limit 10
    set_msg_config -id {[Vivado 12-975]} -limit 10

    puts "----------------------- adding debug nets -----------------------"
    foreach d $dbgs {
        # name is root name of a bus, index is the bit index in the
        # bus
        set name [regsub {\[[[:digit:]]+\]$} $d {}]
        set index [regsub {^.*\[([[:digit:]]+)\]$} $d {\1}]
        if {[string is integer -strict $index]} {
            if {![info exists max($name)]} {
                set max($name) $index
                set min($name) $index
            } elseif {$index > $max($name)} {
                set max($name) $index
            } elseif {$index < $min($name)} {
                set min($name) $index
            }
        } else {
            set max($name) -1
        }
        if {![info exists clocks($name)]} {
            set paths [get_timing_paths -through $d]
            if {[llength $paths] > 0} {
                set clocks($name) [get_property ENDPOINT_CLOCK [lindex $paths 0]]
                if {![info exists clock_list($clocks($name))]} {
                    # found a new clock
                    set clock_list($clocks($name)) [list $name]
                } else {
                    lappend clock_list($clocks($name)) $name
                }
            }
        }
    }

    set_msg_config -id {[Timing 38-164]} -limit 100
    set_msg_config -id {[Vivado 12-975]} -limit 100

    foreach c [array names clock_list] {
        set clk [get_clocks $c]
        if {$clk ne ""} {
            set name [regsub {\[[[:digit:]]+\]} $clk {}]
            set ila_inst u_ila_$name
            set clk_net [get_nets -of_objects [get_pins [get_property SOURCE_PINS $clk]]]
            if {$ila_inst eq "u_ila_txoutclk_out_1"} {
                break
            }
            puts "                        Creating ILA $ila_inst"
            ##################################################################
            # create ILA and connect its clock
            create_debug_core  $ila_inst              ila >> $logfile
            set_property       C_DATA_DEPTH           2048 [get_debug_cores $ila_inst]
            set_property       C_INPUT_PIPE_STAGES    2 [get_debug_cores $ila_inst]
            set_property       port_width 1           [get_debug_ports $ila_inst/clk]
            # CRITICAL WARNING: [Chipscope 16-3] Cannot debug net 'hss0/hss_phy/example_wrapper_inst/DLx_phy_inst/inst/gen_gtwizard_gtye4_top.gtwizard_ultrascale_0_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[6].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/txoutclk_out[0]'; it is connected with RX/TXOUTCLK pins of GTH/Y cell, which can only drive BUFG_GT load and is not debuggable.
            if {$clk_net eq "hss0/hss_phy/example_wrapper_inst/DLx_phy_inst/inst/gen_gtwizard_gtye4_top.gtwizard_ultrascale_0_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[6].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/txoutclk_out[0]"} {
                set clk_net cclk_a
            }
            connect_debug_port $ila_inst/clk          $clk_net
            ##################################################################
            # add probes
            set nprobes 0
            foreach n [lsort $clock_list($c)] {
                puts "                          Connecting net $n"
                set nets {}
                if {$max($n) < 0} {
                    lappend nets [get_nets $n]
                } else {
                    # n is a bus name
                    for {set i $min($n)} {$i <= $max($n)} {incr i} {
                        lappend nets [get_nets $n[$i]]
                    }
                }
                set prb probe$nprobes
                if {$nprobes > 0} {
                    create_debug_port $ila_inst probe >> $logfile
                }
                set_property port_width [llength $nets] [get_debug_ports $ila_inst/$prb]
                connect_debug_port $ila_inst/$prb $nets >> $logfile
                incr nprobes
            }
        } else {
            puts "                        Cannot find ILA clock"
            foreach n [lsort $clock_list($c)] {
                puts "                        Skipping net $n"
            }
        }
    }
}
