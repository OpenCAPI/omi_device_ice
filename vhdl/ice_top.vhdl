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

ENTITY ice_top IS
  PORT
    (
      --DDR4 PORT0 PHY interface
      c0_sys_clk_p       : IN    STD_LOGIC;
      c0_sys_clk_n       : IN    STD_LOGIC;
      c0_ddr4_adr        : OUT   STD_LOGIC_VECTOR(16 DOWNTO 0);
      c0_ddr4_ba         : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_cke        : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_cs_n       : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_dm_dbi_n   : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_dq         : INOUT STD_LOGIC_VECTOR(71 DOWNTO 0);
      c0_ddr4_dqs_c      : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_dqs_t      : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c0_ddr4_odt        : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_bg         : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c0_ddr4_reset_n    : OUT   STD_LOGIC;
      c0_ddr4_act_n      : OUT   STD_LOGIC;
      c0_ddr4_ck_c       : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      c0_ddr4_ck_t       : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      --DDR4 PORT1 PHY interface
      c1_sys_clk_p       : IN    STD_LOGIC;
      c1_sys_clk_n       : IN    STD_LOGIC;
      c1_ddr4_adr        : OUT   STD_LOGIC_VECTOR(16 DOWNTO 0);
      c1_ddr4_ba         : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_cke        : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_cs_n       : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_dm_dbi_n   : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c1_ddr4_dq         : INOUT STD_LOGIC_VECTOR(71 DOWNTO 0);
      c1_ddr4_dqs_c      : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c1_ddr4_dqs_t      : INOUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      c1_ddr4_odt        : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_bg         : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      c1_ddr4_reset_n    : OUT   STD_LOGIC;
      c1_ddr4_act_n      : OUT   STD_LOGIC;
      c1_ddr4_ck_c       : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      c1_ddr4_ck_t       : OUT   STD_LOGIC_VECTOR(0 DOWNTO 0);
      ---------------------------------------------------------------------------
      -- OpenCAPI Channels
      ---------------------------------------------------------------------------
      CAPI_FPGA_LANE_N   : IN    STD_ULOGIC_VECTOR(7 DOWNTO 0);
      CAPI_FPGA_LANE_P   : IN    STD_ULOGIC_VECTOR(7 DOWNTO 0);
      FPGA_CAPI_LANE_N   : OUT   STD_ULOGIC_VECTOR(7 DOWNTO 0);
      FPGA_CAPI_LANE_P   : OUT   STD_ULOGIC_VECTOR(7 DOWNTO 0);
      CAPI_FPGA_REFCLK_N : IN    STD_ULOGIC_VECTOR(1 DOWNTO 0);
      CAPI_FPGA_REFCLK_P : IN    STD_ULOGIC_VECTOR(1 DOWNTO 0);
      ---------------------------------------------------------------------------
      -- I2C
      ---------------------------------------------------------------------------
      SCL_IO             : INOUT STD_LOGIC;
      SDA_IO             : INOUT STD_LOGIC;
      ---------------------------------------------------------------------------
      -- Clocking & Reset
      ---------------------------------------------------------------------------
      RESETN             : IN    STD_ULOGIC;
      FREERUN_CLK_N      : IN    STD_ULOGIC;
      FREERUN_CLK_P      : IN    STD_ULOGIC
      );

END ice_top;

ARCHITECTURE ice_top OF ice_top IS

  COMPONENT vio_reset_n
    PORT (
      clk        : IN  STD_LOGIC;
      probe_in0  : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_in1  : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT DLx_phy_vio_0
    PORT (
      clk        : IN  STD_LOGIC;
      probe_in0  : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_in1  : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_in2  : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_in3  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      probe_in4  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      probe_in5  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      probe_in6  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      probe_in7  : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_in8  : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_in9  : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_in10 : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_in11 : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_in12 : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out3 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out4 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out5 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out6 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT DLx_phy_in_system_ibert_0
    PORT (
      drpclk_o       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      gt0_drpen_o    : OUT STD_LOGIC;
      gt0_drpwe_o    : OUT STD_LOGIC;
      gt0_drpaddr_o  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      gt0_drpdi_o    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt0_drprdy_i   : IN  STD_LOGIC;
      gt0_drpdo_i    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt1_drpen_o    : OUT STD_LOGIC;
      gt1_drpwe_o    : OUT STD_LOGIC;
      gt1_drpaddr_o  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      gt1_drpdi_o    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt1_drprdy_i   : IN  STD_LOGIC;
      gt1_drpdo_i    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt2_drpen_o    : OUT STD_LOGIC;
      gt2_drpwe_o    : OUT STD_LOGIC;
      gt2_drpaddr_o  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      gt2_drpdi_o    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt2_drprdy_i   : IN  STD_LOGIC;
      gt2_drpdo_i    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt3_drpen_o    : OUT STD_LOGIC;
      gt3_drpwe_o    : OUT STD_LOGIC;
      gt3_drpaddr_o  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      gt3_drpdi_o    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt3_drprdy_i   : IN  STD_LOGIC;
      gt3_drpdo_i    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt4_drpen_o    : OUT STD_LOGIC;
      gt4_drpwe_o    : OUT STD_LOGIC;
      gt4_drpaddr_o  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      gt4_drpdi_o    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt4_drprdy_i   : IN  STD_LOGIC;
      gt4_drpdo_i    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt5_drpen_o    : OUT STD_LOGIC;
      gt5_drpwe_o    : OUT STD_LOGIC;
      gt5_drpaddr_o  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      gt5_drpdi_o    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt5_drprdy_i   : IN  STD_LOGIC;
      gt5_drpdo_i    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt6_drpen_o    : OUT STD_LOGIC;
      gt6_drpwe_o    : OUT STD_LOGIC;
      gt6_drpaddr_o  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      gt6_drpdi_o    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt6_drprdy_i   : IN  STD_LOGIC;
      gt6_drpdo_i    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt7_drpen_o    : OUT STD_LOGIC;
      gt7_drpwe_o    : OUT STD_LOGIC;
      gt7_drpaddr_o  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      gt7_drpdi_o    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      gt7_drprdy_i   : IN  STD_LOGIC;
      gt7_drpdo_i    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      eyescanreset_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      rxrate_o       : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      txdiffctrl_o   : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);
      txprecursor_o  : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);
      txpostcursor_o : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);
      rxlpmen_o      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      rxrate_i       : IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
      txdiffctrl_i   : IN  STD_LOGIC_VECTOR(39 DOWNTO 0);
      txprecursor_i  : IN  STD_LOGIC_VECTOR(39 DOWNTO 0);
      txpostcursor_i : IN  STD_LOGIC_VECTOR(39 DOWNTO 0);
      rxlpmen_i      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      drpclk_i       : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      rxoutclk_i     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      clk            : IN  STD_LOGIC
      );
  END COMPONENT;

  COMPONENT dlx_phy_wrap
    generic (GEMINI_NOT_APOLLO : natural);
    PORT (
      --EDPL
      reg_04_val    : IN  STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_04_hwwe   : out STD_ULOGIC;
      reg_04_update : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_05_hwwe   : out STD_ULOGIC;
      reg_05_update : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_06_hwwe   : out STD_ULOGIC;
      reg_06_update : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_07_hwwe   : out STD_ULOGIC;
      reg_07_update : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      -- Differential reference clock inputs
      tsm_state2_to_3                            : IN  STD_ULOGIC;
      tsm_state4_to_5                            : IN  STD_ULOGIC;
      tsm_state6_to_1                            : IN  STD_ULOGIC;
      dlx_reset                                  : OUT STD_ULOGIC;
      mgtrefclk1_x0y0_p                          : IN  STD_ULOGIC;
      mgtrefclk1_x0y0_n                          : IN  STD_ULOGIC;
      mgtrefclk1_x0y1_p                          : IN  STD_ULOGIC;
      mgtrefclk1_x0y1_n                          : IN  STD_ULOGIC;
      freerun_clk_p                              : IN  STD_ULOGIC;
      freerun_clk_n                              : IN  STD_ULOGIC;
      freerun_clk_out                            : OUT STD_ULOGIC;
      -- Serial data ports for transceiver channel 0-7
      ch0_gtyrxn_in                              : IN  STD_ULOGIC;
      ch0_gtyrxp_in                              : IN  STD_ULOGIC;
      ch0_gtytxn_out                             : OUT STD_ULOGIC;
      ch0_gtytxp_out                             : OUT STD_ULOGIC;
      ch1_gtyrxn_in                              : IN  STD_ULOGIC;
      ch1_gtyrxp_in                              : IN  STD_ULOGIC;
      ch1_gtytxn_out                             : OUT STD_ULOGIC;
      ch1_gtytxp_out                             : OUT STD_ULOGIC;
      ch2_gtyrxn_in                              : IN  STD_ULOGIC;
      ch2_gtyrxp_in                              : IN  STD_ULOGIC;
      ch2_gtytxn_out                             : OUT STD_ULOGIC;
      ch2_gtytxp_out                             : OUT STD_ULOGIC;
      ch3_gtyrxn_in                              : IN  STD_ULOGIC;
      ch3_gtyrxp_in                              : IN  STD_ULOGIC;
      ch3_gtytxn_out                             : OUT STD_ULOGIC;
      ch3_gtytxp_out                             : OUT STD_ULOGIC;
      ch4_gtyrxn_in                              : IN  STD_ULOGIC;
      ch4_gtyrxp_in                              : IN  STD_ULOGIC;
      ch4_gtytxn_out                             : OUT STD_ULOGIC;
      ch4_gtytxp_out                             : OUT STD_ULOGIC;
      ch5_gtyrxn_in                              : IN  STD_ULOGIC;
      ch5_gtyrxp_in                              : IN  STD_ULOGIC;
      ch5_gtytxn_out                             : OUT STD_ULOGIC;
      ch5_gtytxp_out                             : OUT STD_ULOGIC;
      ch6_gtyrxn_in                              : IN  STD_ULOGIC;
      ch6_gtyrxp_in                              : IN  STD_ULOGIC;
      ch6_gtytxn_out                             : OUT STD_ULOGIC;
      ch6_gtytxp_out                             : OUT STD_ULOGIC;
      ch7_gtyrxn_in                              : IN  STD_ULOGIC;
      ch7_gtyrxp_in                              : IN  STD_ULOGIC;
      ch7_gtytxn_out                             : OUT STD_ULOGIC;
      ch7_gtytxp_out                             : OUT STD_ULOGIC;
      -- output       hb0_gtwiz_userclk_rx_usrclk2_int,
      hb_gtwiz_reset_clk_freerun_buf_int         : OUT STD_ULOGIC;
      init_done_int                              : OUT STD_ULOGIC;
      init_retry_ctr_int                         : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0);
      gtwiz_reset_tx_done_vio_sync               : OUT STD_ULOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_reset_rx_done_vio_sync               : OUT STD_ULOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_buffbypass_tx_done_vio_sync          : OUT STD_ULOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_buffbypass_rx_done_vio_sync          : OUT STD_ULOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_buffbypass_tx_error_vio_sync         : OUT STD_ULOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_buffbypass_rx_error_vio_sync         : OUT STD_ULOGIC_VECTOR(0 DOWNTO 0);
      hb_gtwiz_reset_all_vio_int                 : IN  STD_ULOGIC_VECTOR(0 DOWNTO 0);
      hb0_gtwiz_reset_tx_pll_and_datapath_int    : IN  STD_ULOGIC_VECTOR(0 DOWNTO 0);
      hb0_gtwiz_reset_tx_datapath_int            : IN  STD_ULOGIC_VECTOR(0 DOWNTO 0);
      hb_gtwiz_reset_rx_pll_and_datapath_vio_int : IN  STD_ULOGIC_VECTOR(0 DOWNTO 0);
      hb_gtwiz_reset_rx_datapath_vio_int         : IN  STD_ULOGIC_VECTOR(0 DOWNTO 0);
      --@ Josh Andersen added port declarations to interface with DLx drivers
      dlx_config_info                            : OUT STD_ULOGIC_VECTOR(31 DOWNTO 0);
      ro_dlx_version                             : OUT STD_ULOGIC_VECTOR(31 DOWNTO 0);
      dlx_tlx_init_flit_depth                    : OUT STD_ULOGIC_VECTOR(2 DOWNTO 0);
      dlx_tlx_flit                               : OUT STD_ULOGIC_VECTOR(511 DOWNTO 0);
      dlx_tlx_flit_crc_err                       : OUT STD_ULOGIC;
      dlx_tlx_flit_credit                        : OUT STD_ULOGIC;
      dlx_tlx_flit_valid                         : OUT STD_ULOGIC;
      dlx_tlx_link_up                            : OUT STD_ULOGIC;
      tlx_dlx_debug_encode                       : IN  STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_dlx_debug_info                         : IN  STD_ULOGIC_VECTOR(31 DOWNTO 0);
      tlx_dlx_flit                               : IN  STD_ULOGIC_VECTOR(511 DOWNTO 0);
      tlx_dlx_flit_valid                         : IN  STD_ULOGIC;
      send_first                                 : IN  STD_ULOGIC;
      ocde                                       : IN  STD_ULOGIC;
      tx_clk_402MHz                              : OUT STD_ULOGIC;
      tx_clk_201MHz                              : OUT STD_ULOGIC;
      -- // IBERT Logic
      drpaddr_in                                 : IN  STD_ULOGIC_VECTOR(79 DOWNTO 0);
      drpclk_in                                  : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      drpdi_in                                   : IN  STD_ULOGIC_VECTOR(127 DOWNTO 0);
      drpen_in                                   : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      drpwe_in                                   : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      eyescanreset_in                            : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      rxlpmen_in                                 : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      rxrate_in                                  : IN  STD_ULOGIC_VECTOR(23 DOWNTO 0);
      txdiffctrl_in                              : IN  STD_ULOGIC_VECTOR(39 DOWNTO 0);
      txpostcursor_in                            : IN  STD_ULOGIC_VECTOR(39 DOWNTO 0);
      txprecursor_in                             : IN  STD_ULOGIC_VECTOR(39 DOWNTO 0);
      drpdo_out                                  : OUT STD_ULOGIC_VECTOR(127 DOWNTO 0);
      drprdy_out                                 : OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)

      );
  END COMPONENT;
  -- -----------------------------------
  -- Miscellaneous Ports
  -- -----------------------------------
  SIGNAL dlx_reset            : STD_ULOGIC;
  SIGNAL clock_400mhz         : STD_ULOGIC;  -- [IN]
  SIGNAL reset_n              : STD_ULOGIC;  -- [IN]
  SIGNAL send_first           : STD_ULOGIC;  -- [IN]
  SIGNAL tlxafu_ready         : STD_ULOGIC;  -- [IN]
  SIGNAL vio_out_reset_n      : STD_ULOGIC;  -- [IN]
  SIGNAL vio_trigger          : STD_LOGIC;   -- [IN]
  SIGNAL mux_select           : STD_ULOGIC;  -- [IN]
  SIGNAL ocde_vio             : STD_ULOGIC;  -- [IN]
  SIGNAL ocde                 : STD_ULOGIC;  -- [IN]
  SIGNAL freerun_sync_RESETN  : STD_ULOGIC := '1';
--  SIGNAL RESETN               : STD_ULOGIC;

  -- Differential reference clock inputs
  SIGNAL mgtrefclk1_x0y0_p                          : STD_ULOGIC;                     -- [IN]
  SIGNAL mgtrefclk1_x0y0_n                          : STD_ULOGIC;                     -- [IN]
  SIGNAL mgtrefclk1_x0y1_p                          : STD_ULOGIC;                     -- [IN]
  SIGNAL mgtrefclk1_x0y1_n                          : STD_ULOGIC;                     -- [IN]
  SIGNAL freerun_clk                                : STD_ULOGIC;
  --SIGNAL freerun_clk_p                              : STD_ULOGIC;  -- [IN]
  --SIGNAL freerun_clk_n                              : STD_ULOGIC;  -- [IN]
  -- Serial data ports for transceiver channel 0-7
  SIGNAL ch0_gtyrxn_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch0_gtyrxp_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch0_gtytxn_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch0_gtytxp_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch1_gtyrxn_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch1_gtyrxp_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch1_gtytxn_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch1_gtytxp_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch2_gtyrxn_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch2_gtyrxp_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch2_gtytxn_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch2_gtytxp_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch3_gtyrxn_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch3_gtyrxp_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch3_gtytxn_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch3_gtytxp_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch4_gtyrxn_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch4_gtyrxp_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch4_gtytxn_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch4_gtytxp_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch5_gtyrxn_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch5_gtyrxp_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch5_gtytxn_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch5_gtytxp_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch6_gtyrxn_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch6_gtyrxp_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch6_gtytxn_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch6_gtytxp_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch7_gtyrxn_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch7_gtyrxp_in                              : STD_ULOGIC;                     -- [IN]
  SIGNAL ch7_gtytxn_out                             : STD_ULOGIC;                     -- [OUT]
  SIGNAL ch7_gtytxp_out                             : STD_ULOGIC;                     -- [OUT]
  -- output       hb0_gtwiz_userclk_rx_usrclk2_int,
  SIGNAL hb_gtwiz_reset_clk_freerun_buf_int         : STD_ULOGIC;                     -- [OUT]
  SIGNAL init_done_int                              : STD_ULOGIC;                     -- [OUT]
  SIGNAL init_retry_ctr_int                         : STD_ULOGIC_VECTOR(3 DOWNTO 0);  -- [OUT]
  SIGNAL gtwiz_reset_tx_done_vio_sync               : STD_ULOGIC_VECTOR(0 DOWNTO 0);  -- [OUT]
  SIGNAL gtwiz_reset_rx_done_vio_sync               : STD_ULOGIC_VECTOR(0 DOWNTO 0);  -- [OUT]
  SIGNAL gtwiz_buffbypass_tx_done_vio_sync          : STD_ULOGIC_VECTOR(0 DOWNTO 0);  -- [OUT]
  SIGNAL gtwiz_buffbypass_rx_done_vio_sync          : STD_ULOGIC_VECTOR(0 DOWNTO 0);  -- [OUT]
  SIGNAL gtwiz_buffbypass_tx_error_vio_sync         : STD_ULOGIC_VECTOR(0 DOWNTO 0);  -- [OUT]
  SIGNAL gtwiz_buffbypass_rx_error_vio_sync         : STD_ULOGIC_VECTOR(0 DOWNTO 0);  -- [OUT]
  SIGNAL hb_gtwiz_reset_all_vio_int                 : STD_LOGIC_VECTOR(0 DOWNTO 0);  -- [IN]
  SIGNAL hb0_gtwiz_reset_tx_pll_and_datapath_int    : STD_LOGIC_VECTOR(0 DOWNTO 0);  -- [IN]
  SIGNAL hb0_gtwiz_reset_tx_datapath_int            : STD_LOGIC_VECTOR(0 DOWNTO 0);  -- [IN]
  SIGNAL hb_gtwiz_reset_rx_pll_and_datapath_vio_int : STD_LOGIC_VECTOR(0 DOWNTO 0);  -- [IN]
  SIGNAL hb_gtwiz_reset_rx_datapath_vio_int         : STD_LOGIC_VECTOR(0 DOWNTO 0);  -- [IN]

  -- -----------------------------------
  -- DLX to TLX Parser Interface
  -- -----------------------------------
  SIGNAL dlx_tlx_flit_valid      : STD_ULOGIC;                       -- [IN]
  SIGNAL dlx_tlx_flit            : STD_ULOGIC_VECTOR(511 DOWNTO 0);  -- [IN]
  SIGNAL dlx_tlx_flit_crc_err    : STD_ULOGIC;                       -- [IN]
  SIGNAL dlx_tlx_link_up         : STD_ULOGIC;                       -- [IN]
  -- -----------------------------------
  -- TLX Framer to DLX Interface
  -- -----------------------------------
  SIGNAL dlx_tlx_init_flit_depth : STD_ULOGIC_VECTOR(2 DOWNTO 0);    -- [IN]
  SIGNAL dlx_tlx_flit_credit     : STD_ULOGIC;                       -- [IN]
  SIGNAL tlx_dlx_flit_valid      : STD_ULOGIC;                       -- [OUT]
  SIGNAL tlx_dlx_flit            : STD_ULOGIC_VECTOR(511 DOWNTO 0);  -- [OUT]
  SIGNAL tlx_dlx_debug_encode    : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [OUT]
  SIGNAL tlx_dlx_debug_info      : STD_ULOGIC_VECTOR(31 DOWNTO 0);   -- [OUT]
  SIGNAL dlx_tlx_dlx_config_info : STD_ULOGIC_VECTOR(31 DOWNTO 0);   -- [IN]

  -- // IBERT Logic
  SIGNAL gt0_drpen_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt0_drpwe_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt0_drpaddr_o : STD_LOGIC_VECTOR(9 DOWNTO 0);   -- [OUT]
  SIGNAL gt0_drpdi_o   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [OUT]
  SIGNAL gt0_drprdy_i  : STD_LOGIC;                      -- [IN]
  SIGNAL gt0_drpdo_i   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [IN]
  SIGNAL gt1_drpen_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt1_drpwe_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt1_drpaddr_o : STD_LOGIC_VECTOR(9 DOWNTO 0);   -- [OUT]
  SIGNAL gt1_drpdi_o   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [OUT]
  SIGNAL gt1_drprdy_i  : STD_LOGIC;                      -- [IN]
  SIGNAL gt1_drpdo_i   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [IN]
  SIGNAL gt2_drpen_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt2_drpwe_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt2_drpaddr_o : STD_LOGIC_VECTOR(9 DOWNTO 0);   -- [OUT]
  SIGNAL gt2_drpdi_o   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [OUT]
  SIGNAL gt2_drprdy_i  : STD_LOGIC;                      -- [IN]
  SIGNAL gt2_drpdo_i   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [IN]
  SIGNAL gt3_drpen_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt3_drpwe_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt3_drpaddr_o : STD_LOGIC_VECTOR(9 DOWNTO 0);   -- [OUT]
  SIGNAL gt3_drpdi_o   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [OUT]
  SIGNAL gt3_drprdy_i  : STD_LOGIC;                      -- [IN]
  SIGNAL gt3_drpdo_i   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [IN]
  SIGNAL gt4_drpen_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt4_drpwe_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt4_drpaddr_o : STD_LOGIC_VECTOR(9 DOWNTO 0);   -- [OUT]
  SIGNAL gt4_drpdi_o   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [OUT]
  SIGNAL gt4_drprdy_i  : STD_LOGIC;                      -- [IN]
  SIGNAL gt4_drpdo_i   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [IN]
  SIGNAL gt5_drpen_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt5_drpwe_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt5_drpaddr_o : STD_LOGIC_VECTOR(9 DOWNTO 0);   -- [OUT]
  SIGNAL gt5_drpdi_o   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [OUT]
  SIGNAL gt5_drprdy_i  : STD_LOGIC;                      -- [IN]
  SIGNAL gt5_drpdo_i   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [IN]
  SIGNAL gt6_drpen_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt6_drpwe_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt6_drpaddr_o : STD_LOGIC_VECTOR(9 DOWNTO 0);   -- [OUT]
  SIGNAL gt6_drpdi_o   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [OUT]
  SIGNAL gt6_drprdy_i  : STD_LOGIC;                      -- [IN]
  SIGNAL gt6_drpdo_i   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [IN]
  SIGNAL gt7_drpen_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt7_drpwe_o   : STD_LOGIC;                      -- [OUT]
  SIGNAL gt7_drpaddr_o : STD_LOGIC_VECTOR(9 DOWNTO 0);   -- [OUT]
  SIGNAL gt7_drpdi_o   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [OUT]
  SIGNAL gt7_drprdy_i  : STD_LOGIC;                      -- [IN]
  SIGNAL gt7_drpdo_i   : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- [IN]

  SIGNAL drpaddr_int : STD_ULOGIC_VECTOR(79 DOWNTO 0);   -- [IN]
  SIGNAL drpclk_int  : STD_LOGIC_VECTOR(7 DOWNTO 0);     -- [IN]
  SIGNAL drpdi_int   : STD_ULOGIC_VECTOR(127 DOWNTO 0);  -- [IN]
  SIGNAL drpen_int   : STD_ULOGIC_VECTOR(7 DOWNTO 0);    -- [IN]
  SIGNAL drpwe_int   : STD_ULOGIC_VECTOR(7 DOWNTO 0);    -- [IN]
  SIGNAL drpdo_int   : STD_ULOGIC_VECTOR(127 DOWNTO 0);  -- [OUT]
  SIGNAL drprdy_int  : STD_ULOGIC_VECTOR(7 DOWNTO 0);    -- [OUT]

  SIGNAL eyescanreset_int : STD_LOGIC_VECTOR(7 DOWNTO 0);   -- [OUT]
  SIGNAL rxrate_int       : STD_LOGIC_VECTOR(23 DOWNTO 0);  -- [OUT]
  SIGNAL txdiffctrl_int   : STD_LOGIC_VECTOR(39 DOWNTO 0);  -- [OUT]
  SIGNAL txprecursor_int  : STD_LOGIC_VECTOR(39 DOWNTO 0);  -- [OUT]
  SIGNAL txpostcursor_int : STD_LOGIC_VECTOR(39 DOWNTO 0);  -- [OUT]
  SIGNAL rxlpmen_int      : STD_LOGIC_VECTOR(7 DOWNTO 0);   -- [OUT]

  SIGNAL drpclk_i   : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL rxoutclk_i : STD_LOGIC_VECTOR(7 DOWNTO 0);
  
  SIGNAL ice_perv_lem0  : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL ice_perv_trap0 : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL ice_perv_trap1 : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL ice_perv_trap2 : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL ice_perv_trap3 : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL ice_perv_trap4 : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL ice_perv_ecid  : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL perv_mmio_pulse : STD_LOGIC;
  SIGNAL tsm_state2_to_3 : STD_ULOGIC;
  SIGNAL tsm_state4_to_5 : STD_ULOGIC;
  SIGNAL tsm_state6_to_1 : STD_ULOGIC;
      --EDPL
  signal reg_04_val    : STD_ULOGIC_VECTOR(31 DOWNTO 0);
  signal reg_04_hwwe   : STD_ULOGIC;
  signal reg_04_update : STD_ULOGIC_VECTOR(31 DOWNTO 0);
  signal reg_05_hwwe   : STD_ULOGIC;
  signal reg_05_update : STD_ULOGIC_VECTOR(31 DOWNTO 0);
  signal reg_06_hwwe   : STD_ULOGIC;
  signal reg_06_update : STD_ULOGIC_VECTOR(31 DOWNTO 0);
  signal reg_07_hwwe   : STD_ULOGIC;
  signal reg_07_update : STD_ULOGIC_VECTOR(31 DOWNTO 0);

  attribute mark_debug : string;
  attribute mark_debug of perv_mmio_pulse : signal is "true"; 
  attribute mark_debug of dlx_tlx_flit    : signal is "true"; 
  attribute mark_debug of tsm_state6_to_1    : signal is "true"; 
  attribute mark_debug of txdiffctrl_int    : signal is "true"; 
BEGIN

  mgtrefclk1_x0y0_p        <= CAPI_FPGA_REFCLK_P(0); 
  mgtrefclk1_x0y1_p        <= CAPI_FPGA_REFCLK_P(1); 

  mgtrefclk1_x0y0_n        <= CAPI_FPGA_REFCLK_N(0);
  mgtrefclk1_x0y1_n        <= CAPI_FPGA_REFCLK_N(1);

  drpclk_i <= To_StdLogicVector(hb_gtwiz_reset_clk_freerun_buf_int
                                       & hb_gtwiz_reset_clk_freerun_buf_int
                                       & hb_gtwiz_reset_clk_freerun_buf_int
                                       & hb_gtwiz_reset_clk_freerun_buf_int
                                       & hb_gtwiz_reset_clk_freerun_buf_int
                                       & hb_gtwiz_reset_clk_freerun_buf_int
                                       & hb_gtwiz_reset_clk_freerun_buf_int
                                       & hb_gtwiz_reset_clk_freerun_buf_int);
  rxoutclk_i <= To_StdLogicVector(clock_400mhz
                                       & clock_400mhz
                                       & clock_400mhz
                                       & clock_400mhz
                                       & clock_400mhz
                                       & clock_400mhz
                                       & clock_400mhz
                                       & clock_400mhz);
  send_first <= '0';                    -- '0' = receive data before sending, '1' = send data immediately after reset
  --reset_n    <= vio_out_reset_n AND dlx_tlx_link_up;
  --reset_n <= '1';
 -- reset_n <= vio_out_reset_n;
  reset_n <= RESETN;
  ocde       <= (NOT mux_select AND freerun_sync_RESETN) OR (mux_select AND freerun_sync_RESETN AND ocde_vio);
 -- RESETN  <= '1';
  mux_select <= '0';

  counter : entity work.counter
    port map (
      clock => clock_400mhz,
      reset => dlx_reset,
      tsm_state6_to_1 => tsm_state6_to_1
      );

  --ocde       <= (NOT mux_select AND RESETN) OR (mux_select AND RESETN AND ocde_vio);
  ch7_gtyrxn_in <= CAPI_FPGA_LANE_N(7);
  ch6_gtyrxn_in <= CAPI_FPGA_LANE_N(6);
  ch5_gtyrxn_in <= CAPI_FPGA_LANE_N(5);
  ch4_gtyrxn_in <= CAPI_FPGA_LANE_N(4);
  ch3_gtyrxn_in <= CAPI_FPGA_LANE_N(3);
  ch2_gtyrxn_in <= CAPI_FPGA_LANE_N(2);
  ch1_gtyrxn_in <= CAPI_FPGA_LANE_N(1);
  ch0_gtyrxn_in <= CAPI_FPGA_LANE_N(0);
  ch7_gtyrxp_in <= CAPI_FPGA_LANE_P(7);
  ch6_gtyrxp_in <= CAPI_FPGA_LANE_P(6);
  ch5_gtyrxp_in <= CAPI_FPGA_LANE_P(5);
  ch4_gtyrxp_in <= CAPI_FPGA_LANE_P(4);
  ch3_gtyrxp_in <= CAPI_FPGA_LANE_P(3);
  ch2_gtyrxp_in <= CAPI_FPGA_LANE_P(2);
  ch1_gtyrxp_in <= CAPI_FPGA_LANE_P(1);
  ch0_gtyrxp_in <= CAPI_FPGA_LANE_P(0);

  FPGA_CAPI_LANE_N(7 DOWNTO 0) <= ch7_gtytxn_out &
                                  ch6_gtytxn_out &
                                  ch5_gtytxn_out &
                                  ch4_gtytxn_out &
                                  ch3_gtytxn_out &
                                  ch2_gtytxn_out &
                                  ch1_gtytxn_out &
                                  ch0_gtytxn_out;
  FPGA_CAPI_LANE_P(7 DOWNTO 0) <= ch7_gtytxp_out &
                                  ch6_gtytxp_out &
                                  ch5_gtytxp_out &
                                  ch4_gtytxp_out &
                                  ch3_gtytxp_out &
                                  ch2_gtytxp_out &
                                  ch1_gtytxp_out &
                                  ch0_gtytxp_out;

  gt0_drpdo_i  <= To_StdLogicVector(drpdo_int(15 DOWNTO 0));
  gt1_drpdo_i  <= To_StdLogicVector(drpdo_int(31 DOWNTO 16));
  gt2_drpdo_i  <= To_StdLogicVector(drpdo_int(47 DOWNTO 32));
  gt3_drpdo_i  <= To_StdLogicVector(drpdo_int(63 DOWNTO 48));
  gt4_drpdo_i  <= To_StdLogicVector(drpdo_int(79 DOWNTO 64));
  gt5_drpdo_i  <= To_StdLogicVector(drpdo_int(95 DOWNTO 80));
  gt6_drpdo_i  <= To_StdLogicVector(drpdo_int(111 DOWNTO 96));
  gt7_drpdo_i  <= To_StdLogicVector(drpdo_int(127 DOWNTO 112));
  gt0_drprdy_i <= drprdy_int(0);
  gt1_drprdy_i <= drprdy_int(1);
  gt2_drprdy_i <= drprdy_int(2);
  gt3_drprdy_i <= drprdy_int(3);
  gt4_drprdy_i <= drprdy_int(4);
  gt5_drprdy_i <= drprdy_int(5);
  gt6_drprdy_i <= drprdy_int(5);
  gt7_drprdy_i <= drprdy_int(7);

  drpaddr_int <= To_StdULogicVector(
    gt7_drpaddr_o
    & gt6_drpaddr_o
    & gt5_drpaddr_o
    & gt4_drpaddr_o
    & gt3_drpaddr_o
    & gt2_drpaddr_o
    & gt1_drpaddr_o
    & gt0_drpaddr_o);

  drpen_int <= To_StdULogicVector(
    gt7_drpen_o
    & gt6_drpen_o
    & gt5_drpen_o
    & gt4_drpen_o
    & gt3_drpen_o
    & gt2_drpen_o
    & gt1_drpen_o
    & gt0_drpen_o);

  drpwe_int <= To_StdULogicVector(
    gt7_drpwe_o
    & gt6_drpwe_o
    & gt5_drpwe_o
    & gt4_drpwe_o
    & gt3_drpwe_o
    & gt2_drpwe_o
    & gt1_drpwe_o
    & gt0_drpwe_o);

  drpdi_int <= To_StdULogicVector(
    gt7_drpdi_o
    & gt6_drpdi_o
    & gt5_drpdi_o
    & gt4_drpdi_o
    & gt3_drpdi_o
    & gt2_drpdi_o
    & gt1_drpdi_o
    & gt0_drpdi_o);


  core : ENTITY work.ice_core
    PORT MAP (
      --DDR4 PORT0 PHY interface
      c0_sys_clk_p            => c0_sys_clk_p,             -- [IN  STD_LOGIC]
      c0_sys_clk_n            => c0_sys_clk_n,             -- [IN  STD_LOGIC]
      c0_ddr4_adr             => c0_ddr4_adr,              -- [OUT STD_LOGIC_VECTOR(16 DOWNTO 0)]
      c0_ddr4_ba              => c0_ddr4_ba,               -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_cke             => c0_ddr4_cke,              -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_cs_n            => c0_ddr4_cs_n,             -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_dm_dbi_n        => c0_ddr4_dm_dbi_n,         -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c0_ddr4_dq              => c0_ddr4_dq,               -- [INOUT STD_LOGIC_VECTOR(71 DOWNTO 0)]
      c0_ddr4_dqs_c           => c0_ddr4_dqs_c,            -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c0_ddr4_dqs_t           => c0_ddr4_dqs_t,            -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c0_ddr4_odt             => c0_ddr4_odt,              -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_bg              => c0_ddr4_bg,               -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c0_ddr4_reset_n         => c0_ddr4_reset_n,          -- [OUT STD_LOGIC]
      c0_ddr4_act_n           => c0_ddr4_act_n,            -- [OUT STD_LOGIC]
      c0_ddr4_ck_c            => c0_ddr4_ck_c,             -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]
      c0_ddr4_ck_t            => c0_ddr4_ck_t,             -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]
      --DDR4 PORT1 PHY interface
      c1_sys_clk_p            => c1_sys_clk_p,             -- [IN  STD_LOGIC]
      c1_sys_clk_n            => c1_sys_clk_n,             -- [IN  STD_LOGIC]
      c1_ddr4_adr             => c1_ddr4_adr,              -- [OUT STD_LOGIC_VECTOR(16 DOWNTO 0)]
      c1_ddr4_ba              => c1_ddr4_ba,               -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c1_ddr4_cke             => c1_ddr4_cke,              -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c1_ddr4_cs_n            => c1_ddr4_cs_n,             -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c1_ddr4_dm_dbi_n        => c1_ddr4_dm_dbi_n,         -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c1_ddr4_dq              => c1_ddr4_dq,               -- [INOUT STD_LOGIC_VECTOR(71 DOWNTO 0)]
      c1_ddr4_dqs_c           => c1_ddr4_dqs_c,            -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c1_ddr4_dqs_t           => c1_ddr4_dqs_t,            -- [INOUT STD_LOGIC_VECTOR(8 DOWNTO 0)]
      c1_ddr4_odt             => c1_ddr4_odt,              -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c1_ddr4_bg              => c1_ddr4_bg,               -- [OUT STD_LOGIC_VECTOR(1 DOWNTO 0)]
      c1_ddr4_reset_n         => c1_ddr4_reset_n,          -- [OUT STD_LOGIC]
      c1_ddr4_act_n           => c1_ddr4_act_n,            -- [OUT STD_LOGIC]
      c1_ddr4_ck_c            => c1_ddr4_ck_c,             -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]
      c1_ddr4_ck_t            => c1_ddr4_ck_t,             -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]
      -- -----------------------------------
      -- DLX to TLX Parser Interface
      -- -----------------------------------
      dlx_tlx_flit_valid      => dlx_tlx_flit_valid,       -- [IN  STD_ULOGIC]
      dlx_tlx_flit            => dlx_tlx_flit,             -- [IN  STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      dlx_tlx_flit_crc_err    => dlx_tlx_flit_crc_err,     -- [IN  STD_ULOGIC]
      dlx_tlx_link_up         => dlx_tlx_link_up,          -- [IN  STD_ULOGIC]
      -- -----------------------------------
      -- TLX Framer to DLX Interface
      -- -----------------------------------
      dlx_tlx_init_flit_depth => dlx_tlx_init_flit_depth,  -- [IN  STD_ULOGIC_VECTOR(2 DOWNTO 0)]
      dlx_tlx_flit_credit     => dlx_tlx_flit_credit,      -- [IN  STD_ULOGIC]
      tlx_dlx_flit_valid      => tlx_dlx_flit_valid,       -- [OUT STD_ULOGIC]
      tlx_dlx_flit            => tlx_dlx_flit,             -- [OUT STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      tlx_dlx_debug_encode    => tlx_dlx_debug_encode,     -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_dlx_debug_info      => tlx_dlx_debug_info,       -- [OUT STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      dlx_tlx_dlx_config_info => dlx_tlx_dlx_config_info,  -- [IN  STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      ice_perv_lem0           => ice_perv_lem0,            -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]
      ice_perv_trap0          => ice_perv_trap0,           -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]  
      ice_perv_trap1          => ice_perv_trap1,           -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]   
      ice_perv_trap2          => ice_perv_trap2,           -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]   
      ice_perv_trap3          => ice_perv_trap3,           -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]   
      ice_perv_trap4          => ice_perv_trap4,           -- [OUT STD_LOGIC_VECTOR(63 DOWNTO 0)]
      ice_perv_ecid           => ice_perv_ecid,
      perv_mmio_pulse         => perv_mmio_pulse,       
        -- -----------------------------------

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
      tlxafu_ready => tlxafu_ready,     -- [OUT STD_ULOGIC]
      clock_400mhz => clock_400mhz,     -- [IN  STD_ULOGIC]
      reset        => dlx_reset,
      mig_reset_n  => reset_n);         -- [IN STD_ULOGIC]

  dlx_phy : dlx_phy_wrap
    GENERIC MAP (GEMINI_NOT_APOLLO => 1)
    PORT MAP (
      --EDPL
      reg_04_val                        => reg_04_val,  --    : IN  STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_04_hwwe                       => reg_04_hwwe,  --   : out STD_ULOGIC;
      reg_04_update                     => reg_04_update,  -- : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_05_hwwe                       => reg_05_hwwe,  --   : out STD_ULOGIC;
      reg_05_update                     => reg_05_update,  -- : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_06_hwwe                       => reg_06_hwwe,  --   : out STD_ULOGIC;
      reg_06_update                     => reg_06_update,  -- : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_07_hwwe                       => reg_07_hwwe,  --   : out STD_ULOGIC;
      reg_07_update                     => reg_07_update,  -- : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      -- Differential reference clock inputs
      tsm_state2_to_3                    => tsm_state2_to_3,
      tsm_state4_to_5                    => tsm_state4_to_5,
      tsm_state6_to_1                    => tsm_state6_to_1,
      dlx_reset                          => dlx_reset,
      mgtrefclk1_x0y0_p                  => mgtrefclk1_x0y0_p,                   -- [IN  STD_ULOGIC]
      mgtrefclk1_x0y0_n                  => mgtrefclk1_x0y0_n,                   -- [IN  STD_ULOGIC]
      mgtrefclk1_x0y1_p                  => mgtrefclk1_x0y1_p,                   -- [IN  STD_ULOGIC]
      mgtrefclk1_x0y1_n                  => mgtrefclk1_x0y1_n,                   -- [IN  STD_ULOGIC]
      freerun_clk_p                      => freerun_clk_p,                       -- [IN  STD_ULOGIC]
      freerun_clk_n                      => freerun_clk_n,                       -- [IN  STD_ULOGIC]
      freerun_clk_out                    => freerun_clk,                         -- [OUT STD_ULOGIC]
      -- Serial data ports for transceiver channel 0-7
      ch0_gtyrxn_in                      => ch0_gtyrxn_in,                       -- [IN  STD_ULOGIC]
      ch0_gtyrxp_in                      => ch0_gtyrxp_in,                       -- [IN  STD_ULOGIC]
      ch0_gtytxn_out                     => ch0_gtytxn_out,                      -- [OUT STD_ULOGIC]
      ch0_gtytxp_out                     => ch0_gtytxp_out,                      -- [OUT STD_ULOGIC]
      ch1_gtyrxn_in                      => ch1_gtyrxn_in,                       -- [IN  STD_ULOGIC]
      ch1_gtyrxp_in                      => ch1_gtyrxp_in,                       -- [IN  STD_ULOGIC]
      ch1_gtytxn_out                     => ch1_gtytxn_out,                      -- [OUT STD_ULOGIC]
      ch1_gtytxp_out                     => ch1_gtytxp_out,                      -- [OUT STD_ULOGIC]
      ch2_gtyrxn_in                      => ch2_gtyrxn_in,                       -- [IN  STD_ULOGIC]
      ch2_gtyrxp_in                      => ch2_gtyrxp_in,                       -- [IN  STD_ULOGIC]
      ch2_gtytxn_out                     => ch2_gtytxn_out,                      -- [OUT STD_ULOGIC]
      ch2_gtytxp_out                     => ch2_gtytxp_out,                      -- [OUT STD_ULOGIC]
      ch3_gtyrxn_in                      => ch3_gtyrxn_in,                       -- [IN  STD_ULOGIC]
      ch3_gtyrxp_in                      => ch3_gtyrxp_in,                       -- [IN  STD_ULOGIC]
      ch3_gtytxn_out                     => ch3_gtytxn_out,                      -- [OUT STD_ULOGIC]
      ch3_gtytxp_out                     => ch3_gtytxp_out,                      -- [OUT STD_ULOGIC]
      ch4_gtyrxn_in                      => ch4_gtyrxn_in,                       -- [IN  STD_ULOGIC]
      ch4_gtyrxp_in                      => ch4_gtyrxp_in,                       -- [IN  STD_ULOGIC]
      ch4_gtytxn_out                     => ch4_gtytxn_out,                      -- [OUT STD_ULOGIC]
      ch4_gtytxp_out                     => ch4_gtytxp_out,                      -- [OUT STD_ULOGIC]
      ch5_gtyrxn_in                      => ch5_gtyrxn_in,                       -- [IN  STD_ULOGIC]
      ch5_gtyrxp_in                      => ch5_gtyrxp_in,                       -- [IN  STD_ULOGIC]
      ch5_gtytxn_out                     => ch5_gtytxn_out,                      -- [OUT STD_ULOGIC]
      ch5_gtytxp_out                     => ch5_gtytxp_out,                      -- [OUT STD_ULOGIC]
      ch6_gtyrxn_in                      => ch6_gtyrxn_in,                       -- [IN  STD_ULOGIC]
      ch6_gtyrxp_in                      => ch6_gtyrxp_in,                       -- [IN  STD_ULOGIC]
      ch6_gtytxn_out                     => ch6_gtytxn_out,                      -- [OUT STD_ULOGIC]
      ch6_gtytxp_out                     => ch6_gtytxp_out,                      -- [OUT STD_ULOGIC]
      ch7_gtyrxn_in                      => ch7_gtyrxn_in,                       -- [IN  STD_ULOGIC]
      ch7_gtyrxp_in                      => ch7_gtyrxp_in,                       -- [IN  STD_ULOGIC]
      ch7_gtytxn_out                     => ch7_gtytxn_out,                      -- [OUT STD_ULOGIC]
      ch7_gtytxp_out                     => ch7_gtytxp_out,                      -- [OUT STD_ULOGIC]
      -- output       hb0_gtwiz_userclk_rx_usrclk2_int,
      ------------------------------------
      -- XILINX PHY VIO
      ------------------------------------
      hb_gtwiz_reset_clk_freerun_buf_int => hb_gtwiz_reset_clk_freerun_buf_int,  -- [OUT STD_ULOGIC]
      init_done_int                      => init_done_int,                       -- [OUT STD_ULOGIC]
      init_retry_ctr_int                 => init_retry_ctr_int,                  -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      gtwiz_reset_tx_done_vio_sync       => gtwiz_reset_tx_done_vio_sync,        -- [OUT STD_ULOGIC_VECTOR(0 DOWNTO 0)]
      gtwiz_reset_rx_done_vio_sync       => gtwiz_reset_rx_done_vio_sync,        -- [OUT STD_ULOGIC_VECTOR(0 DOWNTO 0)]
      gtwiz_buffbypass_tx_done_vio_sync  => gtwiz_buffbypass_tx_done_vio_sync,   -- [OUT STD_ULOGIC_VECTOR(0 DOWNTO 0)]
      gtwiz_buffbypass_rx_done_vio_sync  => gtwiz_buffbypass_rx_done_vio_sync,   -- [OUT STD_ULOGIC_VECTOR(0 DOWNTO 0)]
      gtwiz_buffbypass_tx_error_vio_sync => gtwiz_buffbypass_tx_error_vio_sync,  -- [OUT STD_ULOGIC_VECTOR(0 DOWNTO 0)]
      gtwiz_buffbypass_rx_error_vio_sync => gtwiz_buffbypass_rx_error_vio_sync,  -- [OUT STD_ULOGIC_VECTOR(0 DOWNTO 0)]

      hb_gtwiz_reset_all_vio_int                 => To_StdULogicVector(hb_gtwiz_reset_all_vio_int),                  -- [IN  STD_ULOGIC_VECTOR(0 DOWNTO 0)]
      hb0_gtwiz_reset_tx_pll_and_datapath_int    => To_StdULogicVector(hb0_gtwiz_reset_tx_pll_and_datapath_int),     -- [IN  STD_ULOGIC_VECTOR(0 DOWNTO 0)]
      hb0_gtwiz_reset_tx_datapath_int            => To_StdULogicVector(hb0_gtwiz_reset_tx_datapath_int),             -- [IN  STD_ULOGIC_VECTOR(0 DOWNTO 0)]
      hb_gtwiz_reset_rx_pll_and_datapath_vio_int => To_StdULogicVector(hb_gtwiz_reset_rx_pll_and_datapath_vio_int),  -- [IN  STD_ULOGIC_VECTOR(0 DOWNTO 0)]
      hb_gtwiz_reset_rx_datapath_vio_int         => To_StdULogicVector(hb_gtwiz_reset_rx_datapath_vio_int),          -- [IN  STD_ULOGIC_VECTOR(0 DOWNTO 0)]

      --@ Josh Andersen added port declarations to interface with DLx drivers
      dlx_config_info         => dlx_tlx_dlx_config_info,         -- [OUT STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      --          ro_dlx_version          => ro_dlx_version,           -- [OUT STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      dlx_tlx_init_flit_depth => dlx_tlx_init_flit_depth,         -- [OUT STD_ULOGIC_VECTOR(2 DOWNTO 0)]
      dlx_tlx_flit            => dlx_tlx_flit,                    -- [OUT STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      dlx_tlx_flit_crc_err    => dlx_tlx_flit_crc_err,            -- [OUT STD_ULOGIC]
      dlx_tlx_flit_credit     => dlx_tlx_flit_credit,             -- [OUT STD_ULOGIC]
      dlx_tlx_flit_valid      => dlx_tlx_flit_valid,              -- [OUT STD_ULOGIC]
      dlx_tlx_link_up         => dlx_tlx_link_up,                 -- [OUT STD_ULOGIC]
      tlx_dlx_debug_encode    => tlx_dlx_debug_encode,            -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_dlx_debug_info      => tlx_dlx_debug_info,              -- [IN  STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      tlx_dlx_flit            => tlx_dlx_flit,                    -- [IN  STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      tlx_dlx_flit_valid      => tlx_dlx_flit_valid,              -- [IN  STD_ULOGIC]
      send_first              => send_first,                      -- [IN  STD_ULOGIC]
      ocde                    => ocde,                            -- [IN  STD_ULOGIC]
      tx_clk_402MHz           => clock_400MHz,                    -- [OUT STD_ULOGIC]
      --tx_clk_201MHz           => tx_clk_201MHz,            -- [OUT STD_ULOGIC]
      -- // IBERT Logic
      drpaddr_in              => drpaddr_int,                     -- [IN  STD_ULOGIC_VECTOR(79 DOWNTO 0)]
      drpclk_in               => To_StduLogicVector(drpclk_int),  -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      drpdi_in                => drpdi_int,                       -- [IN  STD_ULOGIC_VECTOR(127 DOWNTO 0)]
      drpen_in                => drpen_int,                       -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      drpwe_in                => drpwe_int,                       -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]

      eyescanreset_in => To_StduLogicVector(eyescanreset_int),  -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      rxrate_in       => To_StduLogicVector(rxrate_int),        -- [IN  STD_ULOGIC_VECTOR(23 DOWNTO 0)]
      txdiffctrl_in   => To_StduLogicVector(txdiffctrl_int),    -- [IN  STD_ULOGIC_VECTOR(39 DOWNTO 0)]
      txpostcursor_in => To_StduLogicVector(txpostcursor_int),  -- [IN  STD_ULOGIC_VECTOR(39 DOWNTO 0)]
      txprecursor_in  => To_StduLogicVector(txprecursor_int),   -- [IN  STD_ULOGIC_VECTOR(39 DOWNTO 0)]
      rxlpmen_in      => To_StduLogicVector(rxlpmen_int),       -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]

      drpdo_out  => drpdo_int,          -- [OUT STD_ULOGIC_VECTOR(127 DOWNTO 0)]
      drprdy_out => drprdy_int);        -- [OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)]



  
  ibert : DLx_phy_in_system_ibert_0
    PORT MAP (
      drpclk_o      => drpclk_int,      -- [OUT STD_LOGIC_VECTOR(7 DOWNTO 0)]
      gt0_drpen_o   => gt0_drpen_o,     -- [OUT STD_LOGIC]
      gt0_drpwe_o   => gt0_drpwe_o,     -- [OUT STD_LOGIC]
      gt0_drpaddr_o => gt0_drpaddr_o,   -- [OUT STD_LOGIC_VECTOR(9 DOWNTO 0)]
      gt0_drpdi_o   => gt0_drpdi_o,     -- [OUT STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt0_drprdy_i  => gt0_drprdy_i,    -- [IN  STD_LOGIC]
      gt0_drpdo_i   => gt0_drpdo_i,     -- [IN  STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt1_drpen_o   => gt1_drpen_o,     -- [OUT STD_LOGIC]
      gt1_drpwe_o   => gt1_drpwe_o,     -- [OUT STD_LOGIC]
      gt1_drpaddr_o => gt1_drpaddr_o,   -- [OUT STD_LOGIC_VECTOR(9 DOWNTO 0)]
      gt1_drpdi_o   => gt1_drpdi_o,     -- [OUT STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt1_drprdy_i  => gt1_drprdy_i,    -- [IN  STD_LOGIC]
      gt1_drpdo_i   => gt1_drpdo_i,     -- [IN  STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt2_drpen_o   => gt2_drpen_o,     -- [OUT STD_LOGIC]
      gt2_drpwe_o   => gt2_drpwe_o,     -- [OUT STD_LOGIC]
      gt2_drpaddr_o => gt2_drpaddr_o,   -- [OUT STD_LOGIC_VECTOR(9 DOWNTO 0)]
      gt2_drpdi_o   => gt2_drpdi_o,     -- [OUT STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt2_drprdy_i  => gt2_drprdy_i,    -- [IN  STD_LOGIC]
      gt2_drpdo_i   => gt2_drpdo_i,     -- [IN  STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt3_drpen_o   => gt3_drpen_o,     -- [OUT STD_LOGIC]
      gt3_drpwe_o   => gt3_drpwe_o,     -- [OUT STD_LOGIC]
      gt3_drpaddr_o => gt3_drpaddr_o,   -- [OUT STD_LOGIC_VECTOR(9 DOWNTO 0)]
      gt3_drpdi_o   => gt3_drpdi_o,     -- [OUT STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt3_drprdy_i  => gt3_drprdy_i,    -- [IN  STD_LOGIC]
      gt3_drpdo_i   => gt3_drpdo_i,     -- [IN  STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt4_drpen_o   => gt4_drpen_o,     -- [OUT STD_LOGIC]
      gt4_drpwe_o   => gt4_drpwe_o,     -- [OUT STD_LOGIC]
      gt4_drpaddr_o => gt4_drpaddr_o,   -- [OUT STD_LOGIC_VECTOR(9 DOWNTO 0)]
      gt4_drpdi_o   => gt4_drpdi_o,     -- [OUT STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt4_drprdy_i  => gt4_drprdy_i,    -- [IN  STD_LOGIC]
      gt4_drpdo_i   => gt4_drpdo_i,     -- [IN  STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt5_drpen_o   => gt5_drpen_o,     -- [OUT STD_LOGIC]
      gt5_drpwe_o   => gt5_drpwe_o,     -- [OUT STD_LOGIC]
      gt5_drpaddr_o => gt5_drpaddr_o,   -- [OUT STD_LOGIC_VECTOR(9 DOWNTO 0)]
      gt5_drpdi_o   => gt5_drpdi_o,     -- [OUT STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt5_drprdy_i  => gt5_drprdy_i,    -- [IN  STD_LOGIC]
      gt5_drpdo_i   => gt5_drpdo_i,     -- [IN  STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt6_drpen_o   => gt6_drpen_o,     -- [OUT STD_LOGIC]
      gt6_drpwe_o   => gt6_drpwe_o,     -- [OUT STD_LOGIC]
      gt6_drpaddr_o => gt6_drpaddr_o,   -- [OUT STD_LOGIC_VECTOR(9 DOWNTO 0)]
      gt6_drpdi_o   => gt6_drpdi_o,     -- [OUT STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt6_drprdy_i  => gt6_drprdy_i,    -- [IN  STD_LOGIC]
      gt6_drpdo_i   => gt6_drpdo_i,     -- [IN  STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt7_drpen_o   => gt7_drpen_o,     -- [OUT STD_LOGIC]
      gt7_drpwe_o   => gt7_drpwe_o,     -- [OUT STD_LOGIC]
      gt7_drpaddr_o => gt7_drpaddr_o,   -- [OUT STD_LOGIC_VECTOR(9 DOWNTO 0)]
      gt7_drpdi_o   => gt7_drpdi_o,     -- [OUT STD_LOGIC_VECTOR(15 DOWNTO 0)]
      gt7_drprdy_i  => gt7_drprdy_i,    -- [IN  STD_LOGIC]
      gt7_drpdo_i   => gt7_drpdo_i,     -- [IN  STD_LOGIC_VECTOR(15 DOWNTO 0)]

      eyescanreset_o => eyescanreset_int,                     -- [OUT STD_LOGIC_VECTOR(7 DOWNTO 0)]
      rxrate_o       => rxrate_int,                           -- [OUT STD_LOGIC_VECTOR(23 DOWNTO 0)]
      txdiffctrl_o   => txdiffctrl_int,                       -- [OUT STD_LOGIC_VECTOR(39 DOWNTO 0)]
      txprecursor_o  => txprecursor_int,                      -- [OUT STD_LOGIC_VECTOR(39 DOWNTO 0)]
      txpostcursor_o => txpostcursor_int,                     -- [OUT STD_LOGIC_VECTOR(39 DOWNTO 0)]
      rxlpmen_o      => rxlpmen_int,                          -- [OUT STD_LOGIC_VECTOR(7 DOWNTO 0)]
      rxrate_i       => x"000000",                            -- [IN  STD_LOGIC_VECTOR(23 DOWNTO 0)]
      txdiffctrl_i   => x"8C6318C631",                        -- [IN  STD_LOGIC_VECTOR(39 DOWNTO 0)]
      txprecursor_i  => x"0000000000",                        -- [IN  STD_LOGIC_VECTOR(39 DOWNTO 0)]
      txpostcursor_i => x"0000000000",                        -- [IN  STD_LOGIC_VECTOR(39 DOWNTO 0)]
      rxlpmen_i      => x"FF",                                -- [IN  STD_LOGIC_VECTOR(7 DOWNTO 0)]
      drpclk_i       => drpclk_i,                             -- [IN  STD_LOGIC_VECTOR(7 DOWNTO 0)]
      rxoutclk_i     => rxoutclk_i,                           -- [IN  STD_LOGIC_VECTOR(7 DOWNTO 0)]
      clk            => hb_gtwiz_reset_clk_freerun_buf_int);  -- [IN STD_LOGIC]

  vio : DLx_phy_vio_0
    PORT MAP (
      clk                            => hb_gtwiz_reset_clk_freerun_buf_int,                     -- [IN  STD_LOGIC]
      probe_in0(0)                   => freerun_sync_RESETN,                                                 -- [IN  STD_LOGIC_VECTOR(0 DOWNTO 0)]
      probe_in1(0)                   => '0',                                                    -- [IN  STD_LOGIC_VECTOR(0 DOWNTO 0)]
      probe_in2(0)                   => init_done_int,                                          -- [IN  STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_in3                      => To_StdLogicVector(init_retry_ctr_int),                  -- [IN  STD_LOGIC_VECTOR(3 DOWNTO 0 ]
      probe_in4                      => x"00",                                                  -- [IN  STD_LOGIC_VECTOR(7 DOWNTO 0 ]
      probe_in5                      => x"00",                                                  -- [IN  STD_LOGIC_VECTOR(7 DOWNTO 0 ]
      probe_in6                      => x"00",                                                  -- [IN  STD_LOGIC_VECTOR(7 DOWNTO 0 ]
      probe_in7                      => To_StdLogicVector(gtwiz_reset_tx_done_vio_sync),        -- [IN  STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_in8                      => To_StdLogicVector(gtwiz_reset_rx_done_vio_sync),        -- [IN  STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_in9                      => To_StdLogicVector(gtwiz_buffbypass_tx_done_vio_sync),   -- [IN  STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_in10                     => To_StdLogicVector(gtwiz_buffbypass_rx_done_vio_sync),   -- [IN  STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_in11                     => To_StdLogicVector(gtwiz_buffbypass_tx_error_vio_sync),  -- [IN  STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_in12                     => To_StdLogicVector(gtwiz_buffbypass_rx_error_vio_sync),  -- [IN  STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_out0(0)                  => open,                                                   -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_out1(0)                  => ocde_vio,                                               -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_out2(0)                  => tsm_state4_to_5,
      probe_out3                     => hb0_gtwiz_reset_tx_datapath_int,                        -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_out4                     => hb_gtwiz_reset_rx_pll_and_datapath_vio_int,             -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_out5                     => hb_gtwiz_reset_rx_datapath_vio_int,                     -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
      probe_out6(0)                  => tsm_state2_to_3);                                       -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]

  vio_reset : vio_reset_n
    PORT MAP (
      clk           => clock_400mhz,     -- [IN  STD_LOGIC]
      probe_in0(0)  => dlx_tlx_link_up,  -- [IN  STD_LOGIC_VECTOR(0 DOWNTO 0)]
      probe_in1(0)  => tlxafu_ready,     -- [IN  STD_LOGIC_VECTOR(0 DOWNTO 0)]
      probe_out0(0) => vio_out_reset_n,  -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]
      probe_out1(0) => vio_trigger);     -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0)]

  pervasive : ENTITY work.ice_pervasive
    PORT MAP (
      ---------------------------------------------------------------------------
      -- I2C
      ---------------------------------------------------------------------------
      SCL_IO          => SCL_IO,  -- [inout std_logic]
      SDA_IO          => SDA_IO,
      trap0           => ice_perv_trap0,
      trap1           => ice_perv_trap1,
      trap2           => ice_perv_trap2,
      trap3           => ice_perv_trap3,
      trap4           => ice_perv_trap4,
      lem0            => ice_perv_lem0,
      ecid            => ice_perv_ecid,
      perv_mmio_pulse => perv_mmio_pulse,
      resetn          => freerun_sync_RESETN,
--      resetn          => resetn,
      freerun_clk     => hb_gtwiz_reset_clk_freerun_buf_int);            -- [inout std_logic]
--      freerun_clk => freerun_clk);            -- [inout std_logic]

--Freerun Reset sync
  reset_async : ENTITY work.ice_gmc_asynclat
      PORT MAP (
         i_clk          => hb_gtwiz_reset_clk_freerun_buf_int,
         i_data(0)      => RESETN,
         o_data(0)      => freerun_sync_RESETN);







END ice_top;
