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
 
 
 


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ice_core IS
  PORT
    (
      --DDR4 PORT0 PHY interface
      c0_sys_clk_p     : IN    STD_LOGIC;
      c0_sys_clk_n     : IN    STD_LOGIC;
      c0_ddr4_adr      : OUT   STD_LOGIC_VECTOR(16 DOWNTO 0);
      c0_ddr4_ba       : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_cke      : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_cs_n     : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_dm_dbi_n : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_dq       : INOUT STD_LOGIC_VECTOR(71 DOWNTO 0);
      c0_ddr4_dqs_c    : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_dqs_t    : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_odt      : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_bg       : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_reset_n  : OUT   STD_LOGIC;
      c0_ddr4_act_n    : OUT   STD_LOGIC;
      c0_ddr4_ck_c     : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      c0_ddr4_ck_t     : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      --DDR4 PORT1 PHY interface
      c1_sys_clk_p     : IN    STD_LOGIC;
      c1_sys_clk_n     : IN    STD_LOGIC;
      c1_ddr4_adr      : OUT   STD_LOGIC_VECTOR(16 DOWNTO 0);
      c1_ddr4_ba       : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_cke      : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_cs_n     : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_dm_dbi_n : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c1_ddr4_dq       : INOUT STD_LOGIC_VECTOR(71 DOWNTO 0);
      c1_ddr4_dqs_c    : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c1_ddr4_dqs_t    : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c1_ddr4_odt      : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_bg       : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_reset_n  : OUT   STD_LOGIC;
      c1_ddr4_act_n    : OUT   STD_LOGIC;
      c1_ddr4_ck_c     : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      c1_ddr4_ck_t     : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);

      --    -- -----------------------------------
      -- DLX to TLX Parser Interface
      -- -----------------------------------
      dlx_tlx_flit_valid          : IN  STD_ULOGIC;
      dlx_tlx_flit                : IN  STD_ULOGIC_VECTOR(511 DOWNTO 0);
      dlx_tlx_flit_crc_err        : IN  STD_ULOGIC;
      dlx_tlx_link_up             : IN  STD_ULOGIC;
      -- -----------------------------------
      -- TLX Framer to DLX Interface
      -- -----------------------------------
      dlx_tlx_init_flit_depth     : IN  STD_ULOGIC_VECTOR(2 DOWNTO 0);
      dlx_tlx_flit_credit         : IN  STD_ULOGIC;
      tlx_dlx_flit_valid          : OUT STD_ULOGIC;
      tlx_dlx_flit                : OUT STD_ULOGIC_VECTOR(511 DOWNTO 0);
      tlx_dlx_debug_encode        : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_dlx_debug_info          : OUT STD_ULOGIC_VECTOR(31 DOWNTO 0);
      dlx_tlx_dlx_config_info     : IN  STD_ULOGIC_VECTOR(31 DOWNTO 0);
      --------------------------------------
      -- trap reg output to i2c
      --------------------------------------
      ice_perv_lem0               : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_trap0              : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_trap1              : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_trap2              : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_trap3              : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_trap4              : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_ecid               : out STD_ULOGIC_VECTOR(63 downto 0);
      perv_mmio_pulse             : in STD_ULOGIC;
      --EDPL
      reg_04_val                  : out  STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_04_hwwe                 : in STD_ULOGIC;
      reg_04_update               : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_05_hwwe                 : in STD_ULOGIC;
      reg_05_update               : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_06_hwwe                 : in STD_ULOGIC;
      reg_06_update               : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_07_hwwe                 : in STD_ULOGIC;
      reg_07_update               : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      -- -----------------------------------
      -- Miscellaneous Ports
      -- -----------------------------------
      tlxafu_ready                : OUT STD_ULOGIC;
      clock_400mhz                : IN  STD_ULOGIC;
      reset                       : IN  STD_ULOGIC;
      mig_reset_n                 : IN  STD_ULOGIC
      );

END ice_core;

ARCHITECTURE ice_core OF ice_core IS
 
  -- -----------------------------------
  -- MC User Interface
  -- -----------------------------------
  --PORT0 user interface
  SIGNAL c0_ddr4_ui_clk            : STD_LOGIC;                        -- [IN]
  SIGNAL c0_ddr4_ui_clk_sync_rst   : STD_LOGIC;                        -- [IN]
  SIGNAL c0_ddr4_app_en            : STD_LOGIC;                        -- [OUT]
  SIGNAL c0_ddr4_app_hi_pri        : STD_LOGIC;                        -- [OUT]
  SIGNAL c0_ddr4_app_wdf_end       : STD_LOGIC;                        -- [OUT]
  SIGNAL c0_ddr4_app_wdf_wren      : STD_LOGIC;                        -- [OUT]
  SIGNAL c0_ddr4_app_rd_data_end   : STD_LOGIC;                        -- [IN]
  SIGNAL c0_ddr4_app_rd_data_valid : STD_LOGIC;                        -- [IN]
  SIGNAL c0_ddr4_app_rdy           : STD_LOGIC;                        -- [IN]
  SIGNAL c0_ddr4_app_wdf_rdy       : STD_LOGIC;                        -- [IN]
  SIGNAL c0_ddr4_app_addr          : STD_LOGIC_VECTOR(30 DOWNTO 0);    -- [OUT]
  SIGNAL c0_ddr4_app_cmd           : STD_LOGIC_VECTOR(2 DOWNTO 0);     -- [OUT]
  SIGNAL c0_ddr4_app_wdf_data      : STD_LOGIC_VECTOR(575 DOWNTO 0);   -- [OUT]
  SIGNAL c0_ddr4_app_rd_data       : STD_LOGIC_VECTOR(575 DOWNTO 0);   -- [IN]
  SIGNAL c0_init_calib_complete    : STD_LOGIC;                        -- [IN]
 -- SIGNAL c0_dbg_clk                : STD_LOGIC;                        -- [IN]
 -- SIGNAL c0_dbg_bus                : STD_LOGIC_VECTOR(511 DOWNTO 0);   -- [IN]
  --PORT1 user interface
  SIGNAL c1_ddr4_ui_clk            : STD_LOGIC;                        -- [IN]
  SIGNAL c1_ddr4_ui_clk_sync_rst   : STD_LOGIC;                        -- [IN]
  SIGNAL c1_ddr4_app_en            : STD_LOGIC;                        -- [OUT]
  SIGNAL c1_ddr4_app_hi_pri        : STD_LOGIC;                        -- [OUT]
  SIGNAL c1_ddr4_app_wdf_end       : STD_LOGIC;                        -- [OUT]
  SIGNAL c1_ddr4_app_wdf_wren      : STD_LOGIC;                        -- [OUT]
  SIGNAL c1_ddr4_app_rd_data_end   : STD_LOGIC;                        -- [IN]
  SIGNAL c1_ddr4_app_rd_data_valid : STD_LOGIC;                        -- [IN]
  SIGNAL c1_ddr4_app_rdy           : STD_LOGIC;                        -- [IN]
  SIGNAL c1_ddr4_app_wdf_rdy       : STD_LOGIC;                        -- [IN]
  SIGNAL c1_ddr4_app_addr          : STD_LOGIC_VECTOR(30 DOWNTO 0);    -- [OUT]
  SIGNAL c1_ddr4_app_cmd           : STD_LOGIC_VECTOR(2 DOWNTO 0);     -- [OUT]
  SIGNAL c1_ddr4_app_wdf_data      : STD_LOGIC_VECTOR(575 DOWNTO 0);   -- [OUT]
  SIGNAL c1_ddr4_app_rd_data       : STD_LOGIC_VECTOR(575 DOWNTO 0);   -- [IN]
  SIGNAL c1_init_calib_complete    : STD_LOGIC;                        -- [IN]
--  SIGNAL c1_dbg_clk                : STD_LOGIC;                        -- [IN]
--  SIGNAL c1_dbg_bus                : STD_LOGIC_VECTOR(511 DOWNTO 0);   -- [IN]
  SIGNAL reset_n                   : STD_ULOGIC; 
  SIGNAL resetn_sync_400mhz        : STD_ULOGIC;
--  signal    reset_n_d              : STD_ULOGIC;
--  signal    reset_n_q              : STD_ULOGIC;

  signal  init_calib_complete       : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  signal  force_recal               : STD_ULOGIC;
  signal  auto_recal_disable        : STD_ULOGIC;
  signal  cal_retry_cnt             : STD_ULOGIC_VECTOR(7 DOWNTO 0);
  signal  cal_reset_n               : STD_ULOGIC;
  signal  cal_mig_reset_n           : STD_ULOGIC;
BEGIN
  reset_n <= not reset;
--  cal_mig_reset_n <= cal_reset_n AND mig_reset_n;            
  cal_mig_reset_n <= cal_reset_n;            
  afu_mac: entity work.ice_afu_mac
      PORT MAP (
        --    -- -----------------------------------
        -- DLX to TLX Parser Interface
        -- -----------------------------------
        dlx_tlx_flit_valid        => dlx_tlx_flit_valid,         -- [IN  STD_ULOGIC]
        dlx_tlx_flit              => dlx_tlx_flit,               -- [IN  STD_ULOGIC_VECTOR(511 DOWNTO 0)]
        dlx_tlx_flit_crc_err      => dlx_tlx_flit_crc_err,       -- [IN  STD_ULOGIC]
        dlx_tlx_link_up           => dlx_tlx_link_up,            -- [IN  STD_ULOGIC]
        -- -----------------------------------
        -- TLX Framer to DLX Interface
        -- -----------------------------------
        dlx_tlx_init_flit_depth   => dlx_tlx_init_flit_depth,    -- [IN  STD_ULOGIC_VECTOR(2 DOWNTO 0)]
        dlx_tlx_flit_credit       => dlx_tlx_flit_credit,        -- [IN  STD_ULOGIC]
        tlx_dlx_flit_valid        => tlx_dlx_flit_valid,         -- [OUT STD_ULOGIC]
        tlx_dlx_flit              => tlx_dlx_flit,               -- [OUT STD_ULOGIC_VECTOR(511 DOWNTO 0)]
        tlx_dlx_debug_encode      => tlx_dlx_debug_encode,       -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
        tlx_dlx_debug_info        => tlx_dlx_debug_info,         -- [OUT STD_ULOGIC_VECTOR(31 DOWNTO 0)]
        dlx_tlx_dlx_config_info   => dlx_tlx_dlx_config_info,    -- [IN  STD_ULOGIC_VECTOR(31 DOWNTO 0)]
        -- -----------------------------------
        -- MC User Interface
        -- -----------------------------------
        --PORT0 user interface
        c0_ddr4_ui_clk            => c0_ddr4_ui_clk,             -- [IN  STD_LOGIC]
        c0_ddr4_ui_clk_sync_rst   => c0_ddr4_ui_clk_sync_rst,    -- [IN  STD_LOGIC]
        c0_ddr4_app_en            => c0_ddr4_app_en,             -- [OUT STD_LOGIC]
        c0_ddr4_app_hi_pri        => c0_ddr4_app_hi_pri,         -- [OUT STD_LOGIC]
        c0_ddr4_app_wdf_end       => c0_ddr4_app_wdf_end,        -- [OUT STD_LOGIC]
        c0_ddr4_app_wdf_wren      => c0_ddr4_app_wdf_wren,       -- [OUT STD_LOGIC]
        c0_ddr4_app_rd_data_end   => c0_ddr4_app_rd_data_end,    -- [IN  STD_LOGIC]
        c0_ddr4_app_rd_data_valid => c0_ddr4_app_rd_data_valid,  -- [IN  STD_LOGIC]
        c0_ddr4_app_rdy           => c0_ddr4_app_rdy,            -- [IN  STD_LOGIC]
        c0_ddr4_app_wdf_rdy       => c0_ddr4_app_wdf_rdy,        -- [IN  STD_LOGIC]
        c0_ddr4_app_addr          => c0_ddr4_app_addr,           -- [OUT STD_LOGIC_VECTOR(30 DOWNTO 0)]
        c0_ddr4_app_cmd           => c0_ddr4_app_cmd,            -- [OUT STD_LOGIC_VECTOR(2 DOWNTO 0)]
        c0_ddr4_app_wdf_data      => c0_ddr4_app_wdf_data,       -- [OUT STD_LOGIC_VECTOR(575 DOWNTO 0)]
        c0_ddr4_app_rd_data       => c0_ddr4_app_rd_data,        -- [IN  STD_LOGIC_VECTOR(575 DOWNTO 0)]
        c0_init_calib_complete    => c0_init_calib_complete,     -- [IN  STD_LOGIC]
--        c0_dbg_clk                => c0_dbg_clk,                 -- [IN  STD_LOGIC]
--        c0_dbg_bus                => c0_dbg_bus,                 -- [IN  STD_LOGIC_VECTOR(511 DOWNTO 0)]
        --PORT1 user interface
        c1_ddr4_ui_clk            => c1_ddr4_ui_clk,             -- [IN  STD_LOGIC]
        c1_ddr4_ui_clk_sync_rst   => c1_ddr4_ui_clk_sync_rst,    -- [IN  STD_LOGIC]
        c1_ddr4_app_en            => c1_ddr4_app_en,             -- [OUT STD_LOGIC]
        c1_ddr4_app_hi_pri        => c1_ddr4_app_hi_pri,         -- [OUT STD_LOGIC]
        c1_ddr4_app_wdf_end       => c1_ddr4_app_wdf_end,        -- [OUT STD_LOGIC]
        c1_ddr4_app_wdf_wren      => c1_ddr4_app_wdf_wren,       -- [OUT STD_LOGIC]
        c1_ddr4_app_rd_data_end   => c1_ddr4_app_rd_data_end,    -- [IN  STD_LOGIC]
        c1_ddr4_app_rd_data_valid => c1_ddr4_app_rd_data_valid,  -- [IN  STD_LOGIC]
        c1_ddr4_app_rdy           => c1_ddr4_app_rdy,            -- [IN  STD_LOGIC]
        c1_ddr4_app_wdf_rdy       => c1_ddr4_app_wdf_rdy,        -- [IN  STD_LOGIC]
        c1_ddr4_app_addr          => c1_ddr4_app_addr,           -- [OUT STD_LOGIC_VECTOR(30 DOWNTO 0)]
        c1_ddr4_app_cmd           => c1_ddr4_app_cmd,            -- [OUT STD_LOGIC_VECTOR(2 DOWNTO 0)]
        c1_ddr4_app_wdf_data      => c1_ddr4_app_wdf_data,       -- [OUT STD_LOGIC_VECTOR(575 DOWNTO 0)]
        c1_ddr4_app_rd_data       => c1_ddr4_app_rd_data,        -- [IN  STD_LOGIC_VECTOR(575 DOWNTO 0)]
        c1_init_calib_complete    => c1_init_calib_complete,     -- [IN  STD_LOGIC]
--        c1_dbg_clk                => c1_dbg_clk,                 -- [IN  STD_LOGIC]
--        c1_dbg_bus                => c1_dbg_bus,                 -- [IN  STD_LOGIC_VECTOR(511 DOWNTO 0)]
        ice_perv_lem0             => ice_perv_lem0,              -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]
        ice_perv_trap0            => ice_perv_trap0,             -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]  
        ice_perv_trap1            => ice_perv_trap1,             -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]   
        ice_perv_trap2            => ice_perv_trap2,             -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]   
        ice_perv_trap3            => ice_perv_trap3,             -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]   
        ice_perv_trap4            => ice_perv_trap4,             -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]
        ice_perv_ecid             => ice_perv_ecid,
        perv_mmio_pulse           => perv_mmio_pulse,
        force_recal               => force_recal, --            : OUT STD_ULOGIC;
        auto_recal_disable        => auto_recal_disable, --            : in STD_ULOGIC;
        --EDPL
        reg_04_val              => reg_04_val,  --    : out  STD_ULOGIC_VECTOR(31 DOWNTO 0);
        reg_04_hwwe             => reg_04_hwwe,  --   : in STD_ULOGIC;
        reg_04_update           => reg_04_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
        reg_05_hwwe             => reg_05_hwwe,  --   : in STD_ULOGIC;
        reg_05_update           => reg_05_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
        reg_06_hwwe             => reg_06_hwwe,  --   : in STD_ULOGIC;
        reg_06_update           => reg_06_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
        reg_07_hwwe             => reg_07_hwwe,  --   : in STD_ULOGIC;
        reg_07_update           => reg_07_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
        -- -----------------------------------
        -- Miscellaneous Ports
        -- -----------------------------------
        init_calib_complete       => init_calib_complete,     -- [OUT STD_LOGIC_VECTOR]
        cal_retry_cnt             => cal_retry_cnt,          -- [in STD_ULOGIC_VECTOR(7 DOWNTO 0)]
        tlxafu_ready              => tlxafu_ready,               -- [OUT STD_ULOGIC]
        clock_400mhz              => clock_400mhz,               -- [IN  STD_ULOGIC]
        reset_n                   => resetn_sync_400mhz);                   -- [IN STD_ULOGIC]

  cal_retry: entity work.ice_cal_retry
    PORT MAP (
      clock                     => clock_400mhz,                  -- [IN  STD_ULOGIC]
      force_recal               => force_recal, --            : in STD_ULOGIC;
      auto_recal_disable        => auto_recal_disable, --            : in STD_ULOGIC;
      mig_reset_n               => mig_reset_n,            -- [IN  STD_ULOGIC]
      c0_init_calib_complete    => c0_init_calib_complete,     -- [in STD_LOGIC]
      c1_init_calib_complete    => c1_init_calib_complete,     -- [in STD_LOGIC]
      o_init_calib_complete     => init_calib_complete,     -- [OUT STD_LOGIC_VECTOR]
      cal_retry_cnt             => cal_retry_cnt,          -- [out STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      cal_reset_n               => cal_reset_n);           -- [out STD_ULOGIC]

  mc: entity work.ice_mc_top
    PORT MAP (
      --DDR4 PORT0 PHY interface
      c0_sys_clk_p              => c0_sys_clk_p,               -- [IN  STD_LOGIC]
      c0_sys_clk_n              => c0_sys_clk_n,               -- [IN  STD_LOGIC]
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
      --PORT0 user interface
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
      c0_ddr4_app_rd_data       => c0_ddr4_app_rd_data,        -- [OUT STD_LOGIC_VECTOR(575 DOWNTO 0)]
      c0_init_calib_complete    => c0_init_calib_complete,     -- [OUT STD_LOGIC]
--      c0_dbg_clk                => c0_dbg_clk,                 -- [OUT STD_LOGIC]
--      c0_dbg_bus                => c0_dbg_bus,                 -- [OUT STD_LOGIC_VECTOR(511 DOWNTO 0)]
      --DDR4 PORT1 PHY interface
      c1_sys_clk_p              => c1_sys_clk_p,               -- [IN  STD_LOGIC]
      c1_sys_clk_n              => c1_sys_clk_n,               -- [IN  STD_LOGIC]
      c1_ddr4_adr               => c1_ddr4_adr,                -- [OUT STD_LOGIC_VECTOR(16 DOWNTO 0)]
      c1_ddr4_ba                => c1_ddr4_ba,                 -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c1_ddr4_cke               => c1_ddr4_cke,                -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c1_ddr4_cs_n              => c1_ddr4_cs_n,               -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c1_ddr4_dm_dbi_n          => c1_ddr4_dm_dbi_n,           -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c1_ddr4_dq                => c1_ddr4_dq,                 -- [INOUT STD_LOGIC_VECTOR(71 DOWNTO 0)]
      c1_ddr4_dqs_c             => c1_ddr4_dqs_c,              -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c1_ddr4_dqs_t             => c1_ddr4_dqs_t,              -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c1_ddr4_odt               => c1_ddr4_odt,                -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c1_ddr4_bg                => c1_ddr4_bg,                 -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c1_ddr4_reset_n           => c1_ddr4_reset_n,            -- [OUT STD_LOGIC]
      c1_ddr4_act_n             => c1_ddr4_act_n,              -- [OUT STD_LOGIC]
      c1_ddr4_ck_c              => c1_ddr4_ck_c,               -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]
      c1_ddr4_ck_t              => c1_ddr4_ck_t,               -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]
      --PORT1 user interface
      c1_ddr4_ui_clk            => c1_ddr4_ui_clk,             -- [OUT STD_LOGIC]
      c1_ddr4_ui_clk_sync_rst   => c1_ddr4_ui_clk_sync_rst,    -- [OUT STD_LOGIC]
      c1_ddr4_app_en            => c1_ddr4_app_en,             -- [IN  STD_LOGIC]
      c1_ddr4_app_hi_pri        => c1_ddr4_app_hi_pri,         -- [IN  STD_LOGIC]
      c1_ddr4_app_wdf_end       => c1_ddr4_app_wdf_end,        -- [IN  STD_LOGIC]
      c1_ddr4_app_wdf_wren      => c1_ddr4_app_wdf_wren,       -- [IN  STD_LOGIC]
      c1_ddr4_app_rd_data_end   => c1_ddr4_app_rd_data_end,    -- [OUT STD_LOGIC]
      c1_ddr4_app_rd_data_valid => c1_ddr4_app_rd_data_valid,  -- [OUT STD_LOGIC]
      c1_ddr4_app_rdy           => c1_ddr4_app_rdy,            -- [OUT STD_LOGIC]
      c1_ddr4_app_wdf_rdy       => c1_ddr4_app_wdf_rdy,        -- [OUT STD_LOGIC]
      c1_ddr4_app_addr          => c1_ddr4_app_addr,           -- [IN  STD_LOGIC_VECTOR(30 DOWNTO 0)]
      c1_ddr4_app_cmd           => c1_ddr4_app_cmd,            -- [IN  STD_LOGIC_VECTOR(2 DOWNTO 0)]
      c1_ddr4_app_wdf_data      => c1_ddr4_app_wdf_data,       -- [IN  STD_LOGIC_VECTOR(575 DOWNTO 0)]
      c1_ddr4_app_rd_data       => c1_ddr4_app_rd_data,        -- [OUT STD_LOGIC_VECTOR(575 DOWNTO 0)]
      c1_init_calib_complete    => c1_init_calib_complete,     -- [OUT STD_LOGIC]
--      c1_dbg_clk                => c1_dbg_clk,                 -- [OUT STD_LOGIC]
--      c1_dbg_bus                => c1_dbg_bus,                 -- [OUT STD_LOGIC_VECTOR(511 DOWNTO 0)]
      reset_n                   => cal_mig_reset_n);                   -- [IN STD_ULOGIC]

--  reset_n_d <= reset_n;
  reset_sync : ENTITY work.ice_gmc_asynclat
      PORT MAP (
         i_clk          => clock_400mhz,
         i_data(0)      => reset_n,
         o_data(0)      => resetn_sync_400mhz);

-- latch : PROCESS
--  BEGIN
--    WAIT UNTIL clock_400mhz'event AND Clock_400mhz = '1';
--       reset_n_q <= reset_n_d;
--  END PROCESS;
END ice_core;
