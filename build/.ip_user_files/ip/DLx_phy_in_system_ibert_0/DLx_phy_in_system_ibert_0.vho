-- (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:ip:in_system_ibert:1.0
-- IP Revision: 8

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT DLx_phy_in_system_ibert_0
  PORT (
    drpclk_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    gt0_drpen_o : OUT STD_LOGIC;
    gt0_drpwe_o : OUT STD_LOGIC;
    gt0_drpaddr_o : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt0_drpdi_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt0_drprdy_i : IN STD_LOGIC;
    gt0_drpdo_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt1_drpen_o : OUT STD_LOGIC;
    gt1_drpwe_o : OUT STD_LOGIC;
    gt1_drpaddr_o : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt1_drpdi_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt1_drprdy_i : IN STD_LOGIC;
    gt1_drpdo_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt2_drpen_o : OUT STD_LOGIC;
    gt2_drpwe_o : OUT STD_LOGIC;
    gt2_drpaddr_o : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt2_drpdi_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt2_drprdy_i : IN STD_LOGIC;
    gt2_drpdo_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt3_drpen_o : OUT STD_LOGIC;
    gt3_drpwe_o : OUT STD_LOGIC;
    gt3_drpaddr_o : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt3_drpdi_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt3_drprdy_i : IN STD_LOGIC;
    gt3_drpdo_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt4_drpen_o : OUT STD_LOGIC;
    gt4_drpwe_o : OUT STD_LOGIC;
    gt4_drpaddr_o : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt4_drpdi_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt4_drprdy_i : IN STD_LOGIC;
    gt4_drpdo_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt5_drpen_o : OUT STD_LOGIC;
    gt5_drpwe_o : OUT STD_LOGIC;
    gt5_drpaddr_o : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt5_drpdi_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt5_drprdy_i : IN STD_LOGIC;
    gt5_drpdo_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt6_drpen_o : OUT STD_LOGIC;
    gt6_drpwe_o : OUT STD_LOGIC;
    gt6_drpaddr_o : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt6_drpdi_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt6_drprdy_i : IN STD_LOGIC;
    gt6_drpdo_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt7_drpen_o : OUT STD_LOGIC;
    gt7_drpwe_o : OUT STD_LOGIC;
    gt7_drpaddr_o : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    gt7_drpdi_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gt7_drprdy_i : IN STD_LOGIC;
    gt7_drpdo_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    eyescanreset_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    rxrate_o : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    txdiffctrl_o : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);
    txprecursor_o : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);
    txpostcursor_o : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);
    rxlpmen_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    rxrate_i : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    txdiffctrl_i : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
    txprecursor_i : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
    txpostcursor_i : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
    rxlpmen_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    drpclk_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    rxoutclk_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : DLx_phy_in_system_ibert_0
  PORT MAP (
    drpclk_o => drpclk_o,
    gt0_drpen_o => gt0_drpen_o,
    gt0_drpwe_o => gt0_drpwe_o,
    gt0_drpaddr_o => gt0_drpaddr_o,
    gt0_drpdi_o => gt0_drpdi_o,
    gt0_drprdy_i => gt0_drprdy_i,
    gt0_drpdo_i => gt0_drpdo_i,
    gt1_drpen_o => gt1_drpen_o,
    gt1_drpwe_o => gt1_drpwe_o,
    gt1_drpaddr_o => gt1_drpaddr_o,
    gt1_drpdi_o => gt1_drpdi_o,
    gt1_drprdy_i => gt1_drprdy_i,
    gt1_drpdo_i => gt1_drpdo_i,
    gt2_drpen_o => gt2_drpen_o,
    gt2_drpwe_o => gt2_drpwe_o,
    gt2_drpaddr_o => gt2_drpaddr_o,
    gt2_drpdi_o => gt2_drpdi_o,
    gt2_drprdy_i => gt2_drprdy_i,
    gt2_drpdo_i => gt2_drpdo_i,
    gt3_drpen_o => gt3_drpen_o,
    gt3_drpwe_o => gt3_drpwe_o,
    gt3_drpaddr_o => gt3_drpaddr_o,
    gt3_drpdi_o => gt3_drpdi_o,
    gt3_drprdy_i => gt3_drprdy_i,
    gt3_drpdo_i => gt3_drpdo_i,
    gt4_drpen_o => gt4_drpen_o,
    gt4_drpwe_o => gt4_drpwe_o,
    gt4_drpaddr_o => gt4_drpaddr_o,
    gt4_drpdi_o => gt4_drpdi_o,
    gt4_drprdy_i => gt4_drprdy_i,
    gt4_drpdo_i => gt4_drpdo_i,
    gt5_drpen_o => gt5_drpen_o,
    gt5_drpwe_o => gt5_drpwe_o,
    gt5_drpaddr_o => gt5_drpaddr_o,
    gt5_drpdi_o => gt5_drpdi_o,
    gt5_drprdy_i => gt5_drprdy_i,
    gt5_drpdo_i => gt5_drpdo_i,
    gt6_drpen_o => gt6_drpen_o,
    gt6_drpwe_o => gt6_drpwe_o,
    gt6_drpaddr_o => gt6_drpaddr_o,
    gt6_drpdi_o => gt6_drpdi_o,
    gt6_drprdy_i => gt6_drprdy_i,
    gt6_drpdo_i => gt6_drpdo_i,
    gt7_drpen_o => gt7_drpen_o,
    gt7_drpwe_o => gt7_drpwe_o,
    gt7_drpaddr_o => gt7_drpaddr_o,
    gt7_drpdi_o => gt7_drpdi_o,
    gt7_drprdy_i => gt7_drprdy_i,
    gt7_drpdo_i => gt7_drpdo_i,
    eyescanreset_o => eyescanreset_o,
    rxrate_o => rxrate_o,
    txdiffctrl_o => txdiffctrl_o,
    txprecursor_o => txprecursor_o,
    txpostcursor_o => txpostcursor_o,
    rxlpmen_o => rxlpmen_o,
    rxrate_i => rxrate_i,
    txdiffctrl_i => txdiffctrl_i,
    txprecursor_i => txprecursor_i,
    txpostcursor_i => txpostcursor_i,
    rxlpmen_i => rxlpmen_i,
    drpclk_i => drpclk_i,
    rxoutclk_i => rxoutclk_i,
    clk => clk
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file DLx_phy_in_system_ibert_0.vhd when simulating
-- the core, DLx_phy_in_system_ibert_0. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

