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

-- IP VLNV: xilinx.com:ip:ddr4:2.2
-- IP Revision: 6

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT ddr4_0
  PORT (
    c0_init_calib_complete : OUT STD_LOGIC;
    dbg_clk : OUT STD_LOGIC;
    c0_sys_clk_p : IN STD_LOGIC;
    c0_sys_clk_n : IN STD_LOGIC;
    dbg_bus : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
    c0_ddr4_adr : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
    c0_ddr4_ba : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    c0_ddr4_cke : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    c0_ddr4_cs_n : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    c0_ddr4_dm_dbi_n : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
    c0_ddr4_dq : INOUT STD_LOGIC_VECTOR(71 DOWNTO 0);
    c0_ddr4_dqs_c : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
    c0_ddr4_dqs_t : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
    c0_ddr4_odt : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    c0_ddr4_bg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    c0_ddr4_reset_n : OUT STD_LOGIC;
    c0_ddr4_act_n : OUT STD_LOGIC;
    c0_ddr4_ck_c : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    c0_ddr4_ck_t : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    c0_ddr4_ui_clk : OUT STD_LOGIC;
    c0_ddr4_ui_clk_sync_rst : OUT STD_LOGIC;
    c0_ddr4_app_en : IN STD_LOGIC;
    c0_ddr4_app_hi_pri : IN STD_LOGIC;
    c0_ddr4_app_wdf_end : IN STD_LOGIC;
    c0_ddr4_app_wdf_wren : IN STD_LOGIC;
    c0_ddr4_app_rd_data_end : OUT STD_LOGIC;
    c0_ddr4_app_rd_data_valid : OUT STD_LOGIC;
    c0_ddr4_app_rdy : OUT STD_LOGIC;
    c0_ddr4_app_wdf_rdy : OUT STD_LOGIC;
    c0_ddr4_app_addr : IN STD_LOGIC_VECTOR(30 DOWNTO 0);
    c0_ddr4_app_cmd : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    c0_ddr4_app_wdf_data : IN STD_LOGIC_VECTOR(575 DOWNTO 0);
    c0_ddr4_app_wdf_mask : IN STD_LOGIC_VECTOR(71 DOWNTO 0);
    c0_ddr4_app_rd_data : OUT STD_LOGIC_VECTOR(575 DOWNTO 0);
    sys_rst : IN STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : ddr4_0
  PORT MAP (
    c0_init_calib_complete => c0_init_calib_complete,
    dbg_clk => dbg_clk,
    c0_sys_clk_p => c0_sys_clk_p,
    c0_sys_clk_n => c0_sys_clk_n,
    dbg_bus => dbg_bus,
    c0_ddr4_adr => c0_ddr4_adr,
    c0_ddr4_ba => c0_ddr4_ba,
    c0_ddr4_cke => c0_ddr4_cke,
    c0_ddr4_cs_n => c0_ddr4_cs_n,
    c0_ddr4_dm_dbi_n => c0_ddr4_dm_dbi_n,
    c0_ddr4_dq => c0_ddr4_dq,
    c0_ddr4_dqs_c => c0_ddr4_dqs_c,
    c0_ddr4_dqs_t => c0_ddr4_dqs_t,
    c0_ddr4_odt => c0_ddr4_odt,
    c0_ddr4_bg => c0_ddr4_bg,
    c0_ddr4_reset_n => c0_ddr4_reset_n,
    c0_ddr4_act_n => c0_ddr4_act_n,
    c0_ddr4_ck_c => c0_ddr4_ck_c,
    c0_ddr4_ck_t => c0_ddr4_ck_t,
    c0_ddr4_ui_clk => c0_ddr4_ui_clk,
    c0_ddr4_ui_clk_sync_rst => c0_ddr4_ui_clk_sync_rst,
    c0_ddr4_app_en => c0_ddr4_app_en,
    c0_ddr4_app_hi_pri => c0_ddr4_app_hi_pri,
    c0_ddr4_app_wdf_end => c0_ddr4_app_wdf_end,
    c0_ddr4_app_wdf_wren => c0_ddr4_app_wdf_wren,
    c0_ddr4_app_rd_data_end => c0_ddr4_app_rd_data_end,
    c0_ddr4_app_rd_data_valid => c0_ddr4_app_rd_data_valid,
    c0_ddr4_app_rdy => c0_ddr4_app_rdy,
    c0_ddr4_app_wdf_rdy => c0_ddr4_app_wdf_rdy,
    c0_ddr4_app_addr => c0_ddr4_app_addr,
    c0_ddr4_app_cmd => c0_ddr4_app_cmd,
    c0_ddr4_app_wdf_data => c0_ddr4_app_wdf_data,
    c0_ddr4_app_wdf_mask => c0_ddr4_app_wdf_mask,
    c0_ddr4_app_rd_data => c0_ddr4_app_rd_data,
    sys_rst => sys_rst
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file ddr4_0.vhd when simulating
-- the core, ddr4_0. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

