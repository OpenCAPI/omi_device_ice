-- *!***************************************************************************
-- *! Copyright 2019 International Business Machines
-- *!
-- *! Licensed under the Apache License, Version 2.0 (the "License");
-- *! you may not use this file except in compliance with the License.
-- *! You may obtain a copy of the License at
-- *! http://www.apache.org/licenses/LICENSE-2.0
-- *!
-- *! The patent license granted to you in Section 3 of the License, as applied
-- *! to the "Work," hereby includes implementations of the Work in physical form.
-- *!
-- *! Unless required by applicable law or agreed to in writing, the reference design
-- *! distributed under the License is distributed on an "AS IS" BASIS,
-- *! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- *! See the License for the specific language governing permissions and
-- *! limitations under the License.
-- *!
-- *! The background Specification upon which this is based is managed by and available from
-- *! the OpenCAPI Consortium.  More information can be found at https://opencapi.org.
-- *!***************************************************************************
 
 
 


LIBRARY ieee, work;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ice_mc_top IS
  PORT
    (
      --DDR4 PORT0 PHY interface
      c0_sys_clk_p              : IN    STD_LOGIC;
      c0_sys_clk_n              : IN    STD_LOGIC;
      c0_ddr4_adr               : OUT   STD_LOGIC_VECTOR(16 DOWNTO 0);
      c0_ddr4_ba                : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_cke               : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_cs_n              : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_dm_dbi_n          : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_dq                : INOUT STD_LOGIC_VECTOR(71 DOWNTO 0);
      c0_ddr4_dqs_c             : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_dqs_t             : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_odt               : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_bg                : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_reset_n           : OUT   STD_LOGIC;
      c0_ddr4_act_n             : OUT   STD_LOGIC;
      c0_ddr4_ck_c              : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      c0_ddr4_ck_t              : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      --PORT0 user interface
      c0_ddr4_ui_clk            : OUT   STD_LOGIC;
      c0_ddr4_ui_clk_sync_rst   : OUT   STD_LOGIC;
      c0_ddr4_app_en            : IN    STD_LOGIC;
      c0_ddr4_app_hi_pri        : IN    STD_LOGIC;
      c0_ddr4_app_wdf_end       : IN    STD_LOGIC;
      c0_ddr4_app_wdf_wren      : IN    STD_LOGIC;
      c0_ddr4_app_rd_data_end   : OUT   STD_LOGIC;
      c0_ddr4_app_rd_data_valid : OUT   STD_LOGIC;
      c0_ddr4_app_rdy           : OUT   STD_LOGIC;
      c0_ddr4_app_wdf_rdy       : OUT   STD_LOGIC;
      c0_ddr4_app_addr          : IN    STD_LOGIC_VECTOR(30 DOWNTO 0);
      c0_ddr4_app_cmd           : IN    STD_LOGIC_VECTOR(2 DOWNTO 0);
      c0_ddr4_app_wdf_data      : IN    STD_LOGIC_VECTOR(575 DOWNTO 0);
      c0_ddr4_app_rd_data       : OUT   STD_LOGIC_VECTOR(575 DOWNTO 0);
      c0_init_calib_complete    : OUT   STD_LOGIC;
      c0_dbg_clk                : OUT   STD_LOGIC;
      c0_dbg_bus                : OUT   STD_LOGIC_VECTOR(511 DOWNTO 0);
      --DDR4 PORT1 PHY interface
      c1_sys_clk_p              : IN    STD_LOGIC;
      c1_sys_clk_n              : IN    STD_LOGIC;
      c1_ddr4_adr               : OUT   STD_LOGIC_VECTOR(16 DOWNTO 0);
      c1_ddr4_ba                : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_cke               : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_cs_n              : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_dm_dbi_n          : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c1_ddr4_dq                : INOUT STD_LOGIC_VECTOR(71 DOWNTO 0);
      c1_ddr4_dqs_c             : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c1_ddr4_dqs_t             : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c1_ddr4_odt               : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_bg                : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_reset_n           : OUT   STD_LOGIC;
      c1_ddr4_act_n             : OUT   STD_LOGIC;
      c1_ddr4_ck_c              : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      c1_ddr4_ck_t              : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      --PORT1 user interface
      c1_ddr4_ui_clk            : OUT   STD_LOGIC;
      c1_ddr4_ui_clk_sync_rst   : OUT   STD_LOGIC;
      c1_ddr4_app_en            : IN    STD_LOGIC;
      c1_ddr4_app_hi_pri        : IN    STD_LOGIC;
      c1_ddr4_app_wdf_end       : IN    STD_LOGIC;
      c1_ddr4_app_wdf_wren      : IN    STD_LOGIC;
      c1_ddr4_app_rd_data_end   : OUT   STD_LOGIC;
      c1_ddr4_app_rd_data_valid : OUT   STD_LOGIC;
      c1_ddr4_app_rdy           : OUT   STD_LOGIC;
      c1_ddr4_app_wdf_rdy       : OUT   STD_LOGIC;
      c1_ddr4_app_addr          : IN    STD_LOGIC_VECTOR(30 DOWNTO 0);
      c1_ddr4_app_cmd           : IN    STD_LOGIC_VECTOR(2 DOWNTO 0);
      c1_ddr4_app_wdf_data      : IN    STD_LOGIC_VECTOR(575 DOWNTO 0);
      c1_ddr4_app_rd_data       : OUT   STD_LOGIC_VECTOR(575 DOWNTO 0);
      c1_init_calib_complete    : OUT   STD_LOGIC;
      --c1_dbg_clk                : OUT   STD_LOGIC;
     -- c1_dbg_bus                : OUT   STD_LOGIC_VECTOR(511 DOWNTO 0);
      reset_n                   : IN    STD_LOGIC
      );

END ice_mc_top;

ARCHITECTURE ice_mc_top OF ice_mc_top IS

  COMPONENT ddr4_0
    PORT (
      c0_init_calib_complete    : OUT   STD_LOGIC;
      dbg_clk                   : OUT   STD_LOGIC;
      c0_sys_clk_p              : IN    STD_LOGIC;
      c0_sys_clk_n              : IN    STD_LOGIC;
      dbg_bus                   : OUT   STD_LOGIC_VECTOR(511 DOWNTO 0);
      c0_ddr4_adr               : OUT   STD_LOGIC_VECTOR(16 DOWNTO 0);
      c0_ddr4_ba                : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_cke               : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_cs_n              : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_dm_dbi_n          : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_dq                : INOUT STD_LOGIC_VECTOR(71 DOWNTO 0);
      c0_ddr4_dqs_c             : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_dqs_t             : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_odt               : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_bg                : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_reset_n           : OUT   STD_LOGIC;
      c0_ddr4_act_n             : OUT   STD_LOGIC;
      c0_ddr4_ck_c              : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      c0_ddr4_ck_t              : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      c0_ddr4_ui_clk            : OUT   STD_LOGIC;
      c0_ddr4_ui_clk_sync_rst   : OUT   STD_LOGIC;
      c0_ddr4_app_en            : IN    STD_LOGIC;
      c0_ddr4_app_hi_pri        : IN    STD_LOGIC;
      c0_ddr4_app_wdf_end       : IN    STD_LOGIC;
      c0_ddr4_app_wdf_wren      : IN    STD_LOGIC;
      c0_ddr4_app_rd_data_end   : OUT   STD_LOGIC;
      c0_ddr4_app_rd_data_valid : OUT   STD_LOGIC;
      c0_ddr4_app_rdy           : OUT   STD_LOGIC;
      c0_ddr4_app_wdf_rdy       : OUT   STD_LOGIC;
      c0_ddr4_app_addr          : IN    STD_LOGIC_VECTOR(30 DOWNTO 0);
      c0_ddr4_app_cmd           : IN    STD_LOGIC_VECTOR(2 DOWNTO 0);
      c0_ddr4_app_wdf_data      : IN    STD_LOGIC_VECTOR(575 DOWNTO 0);
      c0_ddr4_app_wdf_mask      : IN    STD_LOGIC_VECTOR(71 DOWNTO 0);
      c0_ddr4_app_rd_data       : OUT   STD_LOGIC_VECTOR(575 DOWNTO 0);
      sys_rst                   : IN    STD_LOGIC
      );
  END COMPONENT;

  signal sys_rst               : std_logic;
  signal c0_ddr4_app_wdf_mask : STD_LOGIC_VECTOR(71 DOWNTO 0);
  signal c1_ddr4_app_wdf_mask : STD_LOGIC_VECTOR(71 DOWNTO 0);

BEGIN

  sys_rst <= NOT reset_n;
  c0_ddr4_app_wdf_mask <= (OTHERS => '0'); 
  c1_ddr4_app_wdf_mask <= (OTHERS => '0'); 

  ddr4_p0 : ddr4_0
    PORT MAP (
      c0_init_calib_complete    => c0_init_calib_complete,     -- [OUT STD_LOGIC]
      dbg_clk                   => open,                 -- [OUT STD_LOGIC]
      c0_sys_clk_p              => c0_sys_clk_p,               -- [IN  STD_LOGIC]
      c0_sys_clk_n              => c0_sys_clk_n,               -- [IN  STD_LOGIC]
      dbg_bus                   => open,                 -- [OUT STD_LOGIC_VECTOR(511 DOWNTO 0)]
      c0_ddr4_adr               => c0_ddr4_adr,                -- [OUT STD_LOGIC_VECTOR(16 DOWNTO 0)]
      c0_ddr4_ba                => c0_ddr4_ba,                 -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_cke               => c0_ddr4_cke,                -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_cs_n              => c0_ddr4_cs_n,               -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_dm_dbi_n          => c0_ddr4_dm_dbi_n,           -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c0_ddr4_dq                => c0_ddr4_dq,                 -- [INOUT STD_LOGIC_VECTOR(71 DOWNTO 0)]
      c0_ddr4_dqs_c             => c0_ddr4_dqs_c,              -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c0_ddr4_dqs_t             => c0_ddr4_dqs_t,              -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c0_ddr4_odt               => c0_ddr4_odt,                -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_bg                => c0_ddr4_bg,                 -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_reset_n           => c0_ddr4_reset_n,            -- [OUT STD_LOGIC]
      c0_ddr4_act_n             => c0_ddr4_act_n,              -- [OUT STD_LOGIC]
      c0_ddr4_ck_c              => c0_ddr4_ck_c,               -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]
      c0_ddr4_ck_t              => c0_ddr4_ck_t,               -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]
      c0_ddr4_ui_clk            => c0_ddr4_ui_clk,             -- [OUT STD_LOGIC]
      c0_ddr4_ui_clk_sync_rst   => c0_ddr4_ui_clk_sync_rst,    -- [OUT STD_LOGIC]
      c0_ddr4_app_en            => c0_ddr4_app_en,             -- [IN  STD_LOGIC]
      c0_ddr4_app_hi_pri        => c0_ddr4_app_hi_pri,         -- [IN  STD_LOGIC]
      c0_ddr4_app_wdf_end       => c0_ddr4_app_wdf_end,        -- [IN  STD_LOGIC]
      c0_ddr4_app_wdf_wren      => c0_ddr4_app_wdf_wren,       -- [IN  STD_LOGIC]
      c0_ddr4_app_rd_data_end   => c0_ddr4_app_rd_data_end,    -- [OUT STD_LOGIC]
      c0_ddr4_app_rd_data_valid => c0_ddr4_app_rd_data_valid,  -- [OUT STD_LOGIC]
      c0_ddr4_app_rdy           => c0_ddr4_app_rdy,            -- [OUT STD_LOGIC]
      c0_ddr4_app_wdf_rdy       => c0_ddr4_app_wdf_rdy,        -- [OUT STD_LOGIC]
      c0_ddr4_app_addr          => c0_ddr4_app_addr,           -- [IN  STD_LOGIC_VECTOR(30 DOWNTO 0)]
      c0_ddr4_app_cmd           => c0_ddr4_app_cmd,            -- [IN  STD_LOGIC_VECTOR(2 DOWNTO 0)]
      c0_ddr4_app_wdf_data      => c0_ddr4_app_wdf_data,       -- [IN  STD_LOGIC_VECTOR(575 DOWNTO 0)]
      c0_ddr4_app_wdf_mask      => c0_ddr4_app_wdf_mask,       -- [IN  STD_LOGIC_VECTOR(71 DOWNTO 0)]
      c0_ddr4_app_rd_data       => c0_ddr4_app_rd_data,        -- [OUT STD_LOGIC_VECTOR(575 DOWNTO 0)]
      sys_rst                   => sys_rst);                   -- [IN STD_LOGIC]

  ddr4_p1 : ddr4_0
    PORT MAP (
      c0_init_calib_complete    => c1_init_calib_complete,     -- [OUT STD_LOGIC]
      dbg_clk                   => open,                 -- [OUT STD_LOGIC]
      c0_sys_clk_p              => c1_sys_clk_p,               -- [IN  STD_LOGIC]
      c0_sys_clk_n              => c1_sys_clk_n,               -- [IN  STD_LOGIC]
      dbg_bus                   => open,                 -- [OUT STD_LOGIC_VECTOR(511 DOWNTO 0)]
      c0_ddr4_adr               => c1_ddr4_adr,                -- [OUT STD_LOGIC_VECTOR(16 DOWNTO 0)]
      c0_ddr4_ba                => c1_ddr4_ba,                 -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_cke               => c1_ddr4_cke,                -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_cs_n              => c1_ddr4_cs_n,               -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_dm_dbi_n          => c1_ddr4_dm_dbi_n,           -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c0_ddr4_dq                => c1_ddr4_dq,                 -- [INOUT STD_LOGIC_VECTOR(71 DOWNTO 0)]
      c0_ddr4_dqs_c             => c1_ddr4_dqs_c,              -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c0_ddr4_dqs_t             => c1_ddr4_dqs_t,              -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c0_ddr4_odt               => c1_ddr4_odt,                -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_bg                => c1_ddr4_bg,                 -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_reset_n           => c1_ddr4_reset_n,            -- [OUT STD_LOGIC]
      c0_ddr4_act_n             => c1_ddr4_act_n,              -- [OUT STD_LOGIC]
      c0_ddr4_ck_c              => c1_ddr4_ck_c,               -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]
      c0_ddr4_ck_t              => c1_ddr4_ck_t,               -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]
      c0_ddr4_ui_clk            => c1_ddr4_ui_clk,             -- [OUT STD_LOGIC]
      c0_ddr4_ui_clk_sync_rst   => c1_ddr4_ui_clk_sync_rst,    -- [OUT STD_LOGIC]
      c0_ddr4_app_en            => c1_ddr4_app_en,             -- [IN  STD_LOGIC]
      c0_ddr4_app_hi_pri        => c1_ddr4_app_hi_pri,         -- [IN  STD_LOGIC]
      c0_ddr4_app_wdf_end       => c1_ddr4_app_wdf_end,        -- [IN  STD_LOGIC]
      c0_ddr4_app_wdf_wren      => c1_ddr4_app_wdf_wren,       -- [IN  STD_LOGIC]
      c0_ddr4_app_rd_data_end   => c1_ddr4_app_rd_data_end,    -- [OUT STD_LOGIC]
      c0_ddr4_app_rd_data_valid => c1_ddr4_app_rd_data_valid,  -- [OUT STD_LOGIC]
      c0_ddr4_app_rdy           => c1_ddr4_app_rdy,            -- [OUT STD_LOGIC]
      c0_ddr4_app_wdf_rdy       => c1_ddr4_app_wdf_rdy,        -- [OUT STD_LOGIC]
      c0_ddr4_app_addr          => c1_ddr4_app_addr,           -- [IN  STD_LOGIC_VECTOR(30 DOWNTO 0)]
      c0_ddr4_app_cmd           => c1_ddr4_app_cmd,            -- [IN  STD_LOGIC_VECTOR(2 DOWNTO 0)]
      c0_ddr4_app_wdf_data      => c1_ddr4_app_wdf_data,       -- [IN  STD_LOGIC_VECTOR(575 DOWNTO 0)]
      c0_ddr4_app_wdf_mask      => c1_ddr4_app_wdf_mask,       -- [IN  STD_LOGIC_VECTOR(71 DOWNTO 0)]
      c0_ddr4_app_rd_data       => c1_ddr4_app_rd_data,        -- [OUT STD_LOGIC_VECTOR(575 DOWNTO 0)]
      sys_rst                   => sys_rst);                   -- [IN STD_LOGIC]

END ice_mc_top;
