************
* ICE FPGA *
************

All necessary files needed to generate ICE FPGA project are included in the package. 
All Xilinx IPs were generated using Vivado 2018.3.1
############################################################################################################################
To build an ICE project with OPENCAPI line rate at 21.33GHz and with core speed running at 333MHz (Recommended)
1. Create Vivado 2018.3.1 FPGA projects and select FPGA part xczu19eg-ffvc1760-2-i
2. Import following source file directories. 
    dlx/ headers/ ip_2133/ verilog/ vhdl/
2. Import constrain files
    xdc/ila.xdc xdc/pins.xdc xdc/timing.xdc
3. set following Non-module source files to "Verilog Header"
    DLx_phy_example_wrapper_functions.v
    cfg_func0_init.v
    cfg_func_init.v
4. set following source files to VHDL 2008 
     ice_gmc_arb.vhdl
     ice_gmc_xfifo.vhdl
5. Run Synthesis and Implementation (Flow_PerfOptimized_high and Performance_ExtraTimingOpt run Strategies are recommended)
############################################################################################################################

############################################################################################################################
To build an ICE project with OPENCAPI line rate at 25.6GHz and with core speed running at 400MHz
1. Create Vivado 2018.3.1 FPGA projects and select FPGA part xczu19eg-ffvc1760-2-i
2. Import following source file directories. 
    dlx/ headers/ ip_256/ verilog/ vhdl/
2. Import constrain files 
    xdc/ila.xdc xdc/pins.xdc xdc/timing.xdc
3. set following Non-module source files to "Verilog Header"
    DLx_phy_example_wrapper_functions.v
    cfg_func0_init.v
    cfg_func_init.v
4. set following source files to VHDL 2008 
     ice_gmc_arb.vhdl
     ice_gmc_xfifo.vhdl
5. Run Synthesis and Implementation 
############################################################################################################################
    
# License

Copyright 2019 International Business Machines

Licensed under the Apache License, Version 2.0 (the "License");
you may not use the files in this repository except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0 

The patent license granted to you in Section 3 of the License, as applied
to the "Work," hereby includes implementations of the Work in physical form.  

Unless required by applicable law or agreed to in writing, the reference design
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

The background Specification upon which this is based is managed by and available from
the OpenCAPI Consortium.  More information can be found at https://opencapi.org.
