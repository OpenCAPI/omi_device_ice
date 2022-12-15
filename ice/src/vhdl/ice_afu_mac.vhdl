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
Use Work.ice_func.All;

ENTITY ice_afu_mac IS
  PORT
    (
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
      -- -----------------------------------
      -- MC User Interface
      -- -----------------------------------
      --PORT0 user interface
      c0_ddr4_ui_clk            : IN  STD_LOGIC;
      c0_ddr4_ui_clk_sync_rst   : IN  STD_LOGIC;
      c0_ddr4_app_en            : OUT    STD_LOGIC;
      c0_ddr4_app_hi_pri        : OUT    STD_LOGIC;
      c0_ddr4_app_wdf_end       : OUT    STD_LOGIC;
      c0_ddr4_app_wdf_wren      : OUT    STD_LOGIC;
      c0_ddr4_app_rd_data_end   : IN  STD_LOGIC;
      c0_ddr4_app_rd_data_valid : IN  STD_LOGIC;
      c0_ddr4_app_rdy           : IN  STD_LOGIC;
      c0_ddr4_app_wdf_rdy       : IN  STD_LOGIC;
      c0_ddr4_app_addr          : OUT    STD_LOGIC_VECTOR(30 DOWNTO 0);
      c0_ddr4_app_cmd           : OUT    STD_LOGIC_VECTOR(2 DOWNTO 0);
      c0_ddr4_app_wdf_data      : OUT    STD_LOGIC_VECTOR(575 DOWNTO 0);
      c0_ddr4_app_rd_data       : IN  STD_LOGIC_VECTOR(575 DOWNTO 0);
      c0_init_calib_complete    : IN  STD_LOGIC;
--      c0_dbg_clk                : IN  STD_LOGIC;
--      c0_dbg_bus                : IN  STD_LOGIC_VECTOR(511 DOWNTO 0);
      --PORT1 user interface
      c1_ddr4_ui_clk            : IN  STD_LOGIC;
      c1_ddr4_ui_clk_sync_rst   : IN  STD_LOGIC;
      c1_ddr4_app_en            : OUT    STD_LOGIC;
      c1_ddr4_app_hi_pri        : OUT    STD_LOGIC;
      c1_ddr4_app_wdf_end       : OUT    STD_LOGIC;
      c1_ddr4_app_wdf_wren      : OUT    STD_LOGIC;
      c1_ddr4_app_rd_data_end   : IN  STD_LOGIC;
      c1_ddr4_app_rd_data_valid : IN  STD_LOGIC;
      c1_ddr4_app_rdy           : IN  STD_LOGIC;
      c1_ddr4_app_wdf_rdy       : IN  STD_LOGIC;
      c1_ddr4_app_addr          : OUT    STD_LOGIC_VECTOR(30 DOWNTO 0);
      c1_ddr4_app_cmd           : OUT    STD_LOGIC_VECTOR(2 DOWNTO 0);
      c1_ddr4_app_wdf_data      : OUT    STD_LOGIC_VECTOR(575 DOWNTO 0);
      c1_ddr4_app_rd_data       : IN  STD_LOGIC_VECTOR(575 DOWNTO 0);
      c1_init_calib_complete    : IN  STD_LOGIC;
--      c1_dbg_clk                : IN  STD_LOGIC;
--      c1_dbg_bus                : IN  STD_LOGIC_VECTOR(511 DOWNTO 0);
      --------------------------------------
      -- trap reg output to i2c
      --------------------------------------
      ice_perv_lem0             : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_trap0            : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_trap1            : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_trap2            : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_trap3            : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_trap4            : OUT STD_ULOGIC_VECTOR(63 downto 0);
      ice_perv_ecid             : out STD_ULOGIC_VECTOR(63 downto 0);
      perv_mmio_pulse           : in STD_LOGIC;
      force_recal               : OUT STD_ULOGIC;
      auto_recal_disable        : out  STD_ULOGIC;
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
      init_calib_complete       : in STD_ULOGIC_VECTOR(1 DOWNTO 0);
      cal_retry_cnt             : in  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      tlxafu_ready              : OUT STD_ULOGIC;
      clock_400mhz              : IN  STD_ULOGIC;
      reset_n                   : IN  STD_ULOGIC

      );

END ice_afu_mac;

ARCHITECTURE ice_afu_mac OF ice_afu_mac IS
 --not being used

  signal  tlx_afu_cmd_pl   : STD_ULOGIC_VECTOR(2 DOWNTO 0);

  -- -----------------------------------
  -- TLX Parser to AFU Receive Interface
  -- -----------------------------------
  SIGNAL tlx_afu_ready                    : STD_ULOGIC;  -- [IN]
  -- Command interface to AFU
  SIGNAL afu_tlx_cmd_initial_credit       : STD_ULOGIC_VECTOR(6 DOWNTO 0);    -- [OUT]
  SIGNAL afu_tlx_cmd_credit               : STD_ULOGIC;  -- [OUT]
  SIGNAL tlx_afu_cmd_valid                : STD_ULOGIC;  -- [IN]
  SIGNAL tlx_afu_cmd_opcode               : STD_ULOGIC_VECTOR(7 DOWNTO 0);    -- [IN]
  SIGNAL tlx_afu_cmd_dl                   : STD_ULOGIC_VECTOR(1 DOWNTO 0);    -- [IN]
  --SIGNAL tlx_afu_cmd_end                  : STD_ULOGIC;  -- [IN]
  SIGNAL tlx_afu_cmd_pa                   : STD_ULOGIC_VECTOR(63 DOWNTO 0);   -- [IN]
  SIGNAL tlx_afu_cmd_capptag              : STD_ULOGIC_VECTOR(15 DOWNTO 0);   -- [in]
  -- Command data interface to AFU
  SIGNAL afu_tlx_cmd_rd_req               : STD_ULOGIC;  -- [OUT]
  SIGNAL afu_tlx_cmd_rd_cnt               : STD_ULOGIC_VECTOR(2 DOWNTO 0);    -- [OUT]
  SIGNAL tlx_afu_cmd_data_valid           : STD_ULOGIC;  -- [IN]
  --SIGNAL tlx_afu_cmd_data_bdi             : STD_ULOGIC;  -- [IN]
  SIGNAL tlx_afu_cmd_data_bus             : STD_ULOGIC_VECTOR(517 DOWNTO 0):=(others => '0');  -- [IN]
  -- -----------------------------------
  -- AFU to TLX Framer Transmit Interface
  -- -----------------------------------
  -- --- Responses from AFU
  SIGNAL tlx_afu_resp_initial_credit      : STD_ULOGIC_VECTOR(5 DOWNTO 0);    -- [IN]
  SIGNAL tlx_afu_resp_credit              : STD_ULOGIC;  -- [IN]
  SIGNAL afu_tlx_resp_valid               : STD_ULOGIC;  -- [OUT]
  SIGNAL afu_tlx_resp_opcode              : STD_ULOGIC_VECTOR(7 DOWNTO 0);    -- [OUT]
  SIGNAL afu_tlx_resp_dl                  : STD_ULOGIC_VECTOR(1 DOWNTO 0);    -- [OUT]
  SIGNAL afu_tlx_resp_capptag             : STD_ULOGIC_VECTOR(15 DOWNTO 0);   -- [OUT]
  SIGNAL afu_tlx_resp_dp                  : STD_ULOGIC_VECTOR(1 DOWNTO 0);    -- [OUT]
  SIGNAL afu_tlx_resp_code                : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [OUT]
  -- --- Response data from AFU
  SIGNAL tlx_afu_resp_data_initial_credit : STD_ULOGIC_VECTOR(5 DOWNTO 0);    -- [IN]
  SIGNAL tlx_afu_resp_data_credit         : STD_ULOGIC;  -- [IN]
  SIGNAL afu_tlx_rdata_valid              : STD_ULOGIC;  -- [OUT]
  SIGNAL afu_tlx_rdata_bus                : STD_ULOGIC_VECTOR(517 DOWNTO 0);  -- [OUT]
  SIGNAL afu_tlx_rdata_bdi                : STD_ULOGIC;  -- [OUT]
  -- -----------------------------------
  -- --UI cmd queue interface
  -- -----------------------------------
  SIGNAL cmd_valid                      : STD_ULOGIC;  -- [OUT]
  SIGNAL cmd_rw                         : STD_ULOGIC;  -- [OUT] 0:R  1:W
  SIGNAL cmd_addr                       : STD_ULOGIC_VECTOR(31 DOWNTO 3);   -- [OUT]
  SIGNAL cmd_tag                        : STD_ULOGIC_VECTOR(15 DOWNTO 0);   -- [OUT]
  SIGNAL cmd_size                       : STD_ULOGIC;  -- [OUT]
  SIGNAL cmd_fc                         : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [IN]
  -- -----------------------------------
  -- --UI Data queue interface
  -- -----------------------------------
  SIGNAL wvalid                         : STD_ULOGIC_VECTOR(1 DOWNTO 0);    -- [OUT]
  SIGNAL wdata                          : STD_ULOGIC_VECTOR(511 DOWNTO 0);  -- [OUT]
  SIGNAL wmeta                          : STD_ULOGIC_VECTOR(39 DOWNTO 0);   -- [OUT]
  -- -----------------------------------
  -- --UI response interface
  -- -----------------------------------
  SIGNAL rsp_tag                        : STD_ULOGIC_VECTOR(15 DOWNTO 0);   -- [IN]
  SIGNAL rsp_data                       : STD_ULOGIC_VECTOR(511 DOWNTO 0);  -- [IN]
  SIGNAL rsp_meta                       : STD_ULOGIC_VECTOR(39 DOWNTO 0);   -- [IN]
  SIGNAL rsp_perr                       : STD_ULOGIC_VECTOR(23 DOWNTO 0);  -- [IN]
  SIGNAL rsp_offs                       : STD_ULOGIC;  -- [IN]
  SIGNAL rsp_size                       : STD_ULOGIC;  -- [IN]  0: indicates request was for 64B  1: indicates request was for 128B. i_rsp_offs determine which half
  SIGNAL yield                          : STD_ULOGIC_VECTOR(1 DOWNTO 0);  -- [OUT]
  SIGNAL arbwt                          : STD_ULOGIC_VECTOR(7 DOWNTO 0);    -- [OUT]
  -- -----------------------------------
  -- --MMIO cmd queue interface
  -- -----------------------------------
  SIGNAL xlate_mmio_cmd_val               : STD_ULOGIC;  -- [OUT]
  SIGNAL mmio_xlate_fc                    : STD_ULOGIC;  -- [IN]
  SIGNAL xlate_mmio_cmd_addr              : STD_ULOGIC_VECTOR(34 DOWNTO 0);   -- [OUT]
  SIGNAL xlate_mmio_cmd_rd                : STD_ULOGIC;  -- [OUT]
  SIGNAL xlate_mmio_cmd_tag               : STD_ULOGIC_VECTOR(15 DOWNTO 0);   -- [OUT]
  -- -----------------------------------
  -- --MMIO data queue interface
  -- -----------------------------------
  SIGNAL xlate_mmio_data                  : STD_ULOGIC_VECTOR(511 DOWNTO 0);  -- [OUT]
  SIGNAL xlate_mmio_data_val              : STD_ULOGIC;  -- [OUT]
  ----------------------------------------------------------------------------------------------
  -- interface with vc0 response mux
  ----------------------------------------------------------------------------------------------
  SIGNAL mmio_afu_resp_val                : STD_ULOGIC;  -- [IN]
  SIGNAL afu_mmio_resp_ack                : STD_ULOGIC;  -- [OUT]
  SIGNAL mmio_afu_resp_opcode             : STD_ULOGIC_VECTOR(7 DOWNTO 0);    -- [IN]
  SIGNAL mmio_afu_resp_tag                : STD_ULOGIC_VECTOR(15 DOWNTO 0);   -- [IN]
  SIGNAL mmio_afu_resp_dl                 : STD_ULOGIC_VECTOR(1 DOWNTO 0);    -- [IN]
  SIGNAL mmio_afu_resp_dp                 : STD_ULOGIC_VECTOR(1 DOWNTO 0);    -- [IN]
  SIGNAL mmio_afu_resp_code               : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [IN]
  SIGNAL mmio_afu_rdata_bus               : STD_ULOGIC_VECTOR(511 DOWNTO 0);  -- [IN]
  SIGNAL mmio_afu_rdata_val               : STD_ULOGIC;  -- [IN]


  -- -----------------------------------
  -- TLX Parser to AFU Receive Interface
  -- -----------------------------------

  SIGNAL cfg_tlx_initial_credit : STD_ULOGIC_VECTOR(3 DOWNTO 0);   -- [OUT]
  SIGNAL cfg_tlx_credit_return  : STD_ULOGIC;                      -- [OUT]
  SIGNAL tlx_cfg_valid          : STD_ULOGIC;                      -- [IN]
  SIGNAL tlx_cfg_opcode         : STD_ULOGIC_VECTOR(7 DOWNTO 0);   -- [IN]
  SIGNAL tlx_cfg_pa             : STD_ULOGIC_VECTOR(63 DOWNTO 0);  -- [IN]
  SIGNAL tlx_cfg_t              : STD_ULOGIC;                      -- [IN]
  SIGNAL tlx_cfg_pl             : STD_ULOGIC_VECTOR(2 DOWNTO 0);   -- [IN]
  SIGNAL tlx_cfg_capptag        : STD_ULOGIC_VECTOR(15 DOWNTO 0);  -- [IN]
  SIGNAL tlx_cfg_data_bus       : STD_ULOGIC_VECTOR(31 DOWNTO 0);  -- [IN]
  SIGNAL tlx_cfg_data_bdi       : STD_ULOGIC;                      -- [IN]
  -- --- Config Responses from AFU
  SIGNAL cfg_tlx_resp_valid     : STD_ULOGIC;                      -- [OUT]
  SIGNAL cfg_tlx_resp_opcode    : STD_ULOGIC_VECTOR(7 DOWNTO 0);   -- [OUT]
  SIGNAL cfg_tlx_resp_capptag   : STD_ULOGIC_VECTOR(15 DOWNTO 0);  -- [OUT]
  SIGNAL cfg_tlx_resp_code      : STD_ULOGIC_VECTOR(3 DOWNTO 0);   -- [OUT]
  SIGNAL tlx_cfg_resp_ack       : STD_ULOGIC;                      -- [IN]
  -- --- Config Response data from AFU
  SIGNAL cfg_tlx_rdata_offset   : STD_ULOGIC_VECTOR(3 DOWNTO 0);   -- [OUT]
  SIGNAL cfg_tlx_rdata_bus      : STD_ULOGIC_VECTOR(31 DOWNTO 0);  -- [OUT]
  SIGNAL cfg_tlx_rdata_bdi      : STD_ULOGIC;                      -- [OUT]

  -- -----------------------------------
  -- Configuration Ports
  -- -----------------------------------
  SIGNAL cfg_tlx_xmit_tmpl_config_0        : STD_ULOGIC;                       -- [OUT]
  SIGNAL cfg_tlx_xmit_tmpl_config_1        : STD_ULOGIC;                       -- [OUT]
  SIGNAL cfg_tlx_xmit_tmpl_config_5        : STD_ULOGIC;                       -- [OUT]
  SIGNAL cfg_tlx_xmit_tmpl_config_9        : STD_ULOGIC;                       -- [OUT]
  SIGNAL cfg_tlx_xmit_tmpl_config_11       : STD_ULOGIC;                       -- [OUT]
  SIGNAL cfg_tlx_xmit_rate_config_0        : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [OUT]
  SIGNAL cfg_tlx_xmit_rate_config_1        : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [OUT]
  SIGNAL cfg_tlx_xmit_rate_config_5        : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [OUT]
  SIGNAL cfg_tlx_xmit_rate_config_9        : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [OUT]
  SIGNAL cfg_tlx_xmit_rate_config_11       : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [OUT]
  SIGNAL cfg_tlx_tl_minor_version          : STD_ULOGIC;                       -- [OUT]
  SIGNAL cfg_tlx_enable_afu                : STD_ULOGIC;                       -- [OUT]
  SIGNAL cfg_tlx_metadata_enabled          : STD_ULOGIC;                       -- [OUT]
  SIGNAL cfg_tlx_function_actag_base       : STD_ULOGIC_VECTOR(11 downto 0);   -- [OUT]
  SIGNAL cfg_tlx_function_actag_len_enab   : STD_ULOGIC_VECTOR(11 downto 0);   -- [OUT]
  SIGNAL cfg_tlx_afu_actag_base            : STD_ULOGIC_VECTOR(11 downto 0);   -- [OUT]
  SIGNAL cfg_tlx_afu_actag_len_enab        : STD_ULOGIC_VECTOR(11 downto 0);   -- [OUT]
  SIGNAL cfg_tlx_pasid_length_enabled      : STD_ULOGIC_VECTOR(4 downto 0);    -- [OUT]
  SIGNAL cfg_tlx_pasid_base                : STD_ULOGIC_VECTOR(19 downto 0);   -- [OUT]
  SIGNAL cfg_tlx_mmio_bar0                 : STD_ULOGIC_VECTOR(63 downto 35);  -- [OUT]
  SIGNAL cfg_tlx_memory_space              : STD_ULOGIC;                       -- [OUT]
  SIGNAL cfg_tlx_long_backoff_timer        : STD_ULOGIC_VECTOR(3 downto 0);    -- [OUT]
  SIGNAL tlx_cfg_in_rcv_tmpl_capability_0  : STD_ULOGIC;                       -- [IN]
  SIGNAL tlx_cfg_in_rcv_tmpl_capability_1  : STD_ULOGIC;                       -- [IN]
  SIGNAL tlx_cfg_in_rcv_tmpl_capability_4  : STD_ULOGIC:='0';                       -- [IN]
  SIGNAL tlx_cfg_in_rcv_tmpl_capability_7  : STD_ULOGIC:='0';                       -- [IN]
  SIGNAL tlx_cfg_in_rcv_tmpl_capability_10 : STD_ULOGIC:='0';                       -- [IN]
  SIGNAL tlx_cfg_in_rcv_rate_capability_0  : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [IN]
  SIGNAL tlx_cfg_in_rcv_rate_capability_1  : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [IN]
  SIGNAL tlx_cfg_in_rcv_rate_capability_4  : STD_ULOGIC_VECTOR(3 DOWNTO 0):="0000";    -- [IN]
  SIGNAL tlx_cfg_in_rcv_rate_capability_7  : STD_ULOGIC_VECTOR(3 DOWNTO 0):="0000";    -- [IN]
  SIGNAL tlx_cfg_in_rcv_rate_capability_10 : STD_ULOGIC_VECTOR(3 DOWNTO 0):="0000";    -- [IN]
  SIGNAL tlx_cfg_oc3_tlx_version           : STD_ULOGIC_VECTOR(31 DOWNTO 0);   -- [IN]
  SIGNAL tlx_cfg_oc3_dlx_version           : STD_ULOGIC_VECTOR(31 DOWNTO 0):=(others => '0');   -- [IN]


  SIGNAL mmio_errrpt_intrp_hdl_xstop : std_ulogic_vector(63 downto 0);  -- [in]
  SIGNAL mmio_errrpt_intrp_hdl_app   : std_ulogic_vector(63 downto 0);  -- [in]
  SIGNAL mmio_errrpt_cmd_flag_xstop  : std_ulogic_vector(3 downto 0);   -- [in]
  SIGNAL mmio_errrpt_cmd_flag_app    : std_ulogic_vector(3 downto 0);   -- [in]

  SIGNAL afu_tlx_resp_initial_credit : std_ulogic_vector(6 downto 0);   -- [out]
  SIGNAL afu_tlx_resp_credit         : std_ulogic;                      -- [out]
  SIGNAL tlx_afu_resp_valid          : std_ulogic;                      -- [in]
  SIGNAL tlx_afu_resp_opcode         : std_ulogic_vector(7 downto 0);   -- [in]
  SIGNAL tlx_afu_resp_afutag         : std_ulogic_vector(15 downto 0);  -- [in]

  SIGNAL tlx_afu_cmd_initial_credit : std_ulogic_vector(3 downto 0);   -- [in]
  SIGNAL tlx_afu_cmd_credit         : std_ulogic;                      -- [in]
  SIGNAL afu_tlx_cmd_valid          : std_ulogic;                      -- [out]
  SIGNAL afu_tlx_cmd_opcode         : std_ulogic_vector(7 downto 0);   -- [out]
  SIGNAL afu_tlx_cmd_actag          : std_ulogic_vector(11 downto 0);  -- [out]
  SIGNAL afu_tlx_cmd_stream_id      : std_ulogic_vector(3 downto 0);   -- [out]
  SIGNAL afu_tlx_cmd_ea_or_obj      : std_ulogic_vector(63 downto 0);  -- [out]
  SIGNAL afu_tlx_cmd_afutag         : std_ulogic_vector(15 downto 0);  -- [out]
  SIGNAL afu_tlx_cmd_flag           : std_ulogic_vector(3 downto 0);   -- [out]
  SIGNAL afu_tlx_cmd_bdf            : std_ulogic_vector(15 downto 0);  -- [out]
  SIGNAL afu_tlx_cmd_pasid          : std_ulogic_vector(19 downto 0);  -- [out]




 
  -- --- Command data from AFU
  SIGNAL tlx_afu_cmd_data_initial_credit   : STD_ULOGIC_VECTOR(5 DOWNTO 0);    -- [OUT]
  SIGNAL tlx_afu_cmd_data_credit           : STD_ULOGIC;                       -- [OUT]
  -- -----------------------------------
  -- err & debug bus
  -- -----------------------------------
  SIGNAL afu_mmio_err          : STD_ULOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL afu_mmio_dbg          : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL ui_mmio_err           : STD_ULOGIC_VECTOR(49 DOWNTO 0);
  SIGNAL ui_mmio_dbg           : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL mc_mmio_dbg           : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL mmio_errrpt_xstop_err : STD_ULOGIC;
  SIGNAL mmio_errrpt_mchk_err  : STD_ULOGIC;
  SIGNAL tlx_mmio_rcv_errors   : STD_ULOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL tlx_mmio_rcv_debug    : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL tlx_mmio_xmt_err      : STD_ULOGIC_VECTOR(15 downto 0);
  signal tlx_mmio_xmt_dbg : std_ulogic_vector(63 downto 0);
  SIGNAL err_rpt_dbg          : STD_ULOGIC_VECTOR(3 DOWNTO 0):=(others => '0');
  signal afu_mmio_err_int       : STD_ULOGIC_VECTOR(15 downto 0);
  signal ui_mmio_err_dbg        : STD_ULOGIC_VECTOR(63 downto 0);
  signal dbg_spare_in           : STD_ULOGIC_VECTOR(63 downto 0):=x"0000000000000000";

  signal    afu_tlx_rdata_meta : STD_ULOGIC_VECTOR(5 downto 0):="000000";

  -- cmd from afu main 
  SIGNAL afu_cmd_valid : std_ulogic;                      -- [in]
  SIGNAL afu_cmd_rw    : std_ulogic;                      -- [in]  1=write.
  SIGNAL afu_cmd_addr  : std_ulogic_vector(31 downto 3);  -- [in]
  SIGNAL afu_cmd_tag   : std_ulogic_vector(15 downto 0);  -- [in]
  SIGNAL afu_cmd_size  : std_ulogic;                      -- [in]  0:64B, 1:128B

  SIGNAL afu_wvalid : std_ulogic_vector(1 downto 0);    -- [in]  p1, p0.
  SIGNAL afu_wdata  : std_ulogic_vector(511 downto 0);  -- [in]
  SIGNAL afu_wmeta  : std_ulogic_vector(39 downto 0);   -- [in]


  --Response from UI
  SIGNAL ui_cmd_fc   : STD_ULOGIC_VECTOR(3 DOWNTO 0);    -- [IN]
  SIGNAL ui_rsp_tag  : STD_ULOGIC_VECTOR(15 DOWNTO 0);   -- [IN]
  SIGNAL ui_rsp_data : STD_ULOGIC_VECTOR(511 DOWNTO 0);  -- [IN]
  SIGNAL ui_rsp_meta : STD_ULOGIC_VECTOR(39 DOWNTO 0);   -- [IN]
  SIGNAL ui_rsp_perr : STD_ULOGIC_VECTOR(23 DOWNTO 0);   -- [IN]
  SIGNAL ui_rsp_offs : STD_ULOGIC;    -- [IN]
  SIGNAL ui_rsp_size : STD_ULOGIC;    -- [IN]  0: indicates request was for 64B  1: indicates request was for 128B. i_rsp_offs determine which half

  -- response to afu main
  SIGNAL afu_yield    : STD_ULOGIC_VECTOR(1 DOWNTO 0);    -- [in]
  SIGNAL afu_arbwt    : STD_ULOGIC_VECTOR(7 DOWNTO 0);    -- [in]

  SIGNAL mem_init_done    : STD_ULOGIC;  -- [out]
  signal mem_init_ip      : STD_ULOGIC;
  signal mem_init_wait    : STD_ULOGIC;
  signal mem_init_addr    : STD_ULOGIC_VECTOR(28 DOWNTO 0);
  SIGNAL mem_init_start   : STD_ULOGIC;  -- [out]
  SIGNAL mem_init_zero   : STD_ULOGIC;  -- [out]

   --Add the debug busses to the ILA Trace
  attribute mark_debug : string;
  attribute keep       : string;

  attribute mark_debug of ui_mmio_err           : signal is "true";
  attribute mark_debug of xlate_mmio_cmd_val    : signal is "true";
  attribute mark_debug of xlate_mmio_cmd_tag    : signal is "true";
  attribute mark_debug of mmio_errrpt_xstop_err : signal is "true";

BEGIN

  tlxafu_ready             <= tlx_afu_ready;
  mc_mmio_dbg(63 DOWNTO 0)  <= init_calib_complete(1 DOWNTO 0) & (61 DOWNTO 40 => '0') & cal_retry_cnt(7 DOWNTO 0) &
                               mem_init_done & mem_init_ip & mem_init_wait & mem_init_addr(28 DOWNTO 0);



  tlx : ENTITY work.ice_tlx_top
    PORT MAP (
      -- -----------------------------------
      -- TLX Parser to AFU Receive Interface
      -- -----------------------------------
      tlx_afu_ready                     => tlx_afu_ready,                      -- [OUT STD_ULOGIC]
      -- Command interface to AFU
      afu_tlx_cmd_initial_credit        => afu_tlx_cmd_initial_credit,         -- [IN  STD_ULOGIC_VECTOR(6 DOWNTO 0)]
      afu_tlx_cmd_credit                => afu_tlx_cmd_credit,                 -- [IN  STD_ULOGIC]
      tlx_afu_cmd_valid                 => tlx_afu_cmd_valid,                  -- [OUT STD_ULOGIC]
      tlx_afu_cmd_opcode                => tlx_afu_cmd_opcode,                 -- [OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      tlx_afu_cmd_dl                    => tlx_afu_cmd_dl,                     -- [OUT STD_ULOGIC_VECTOR(1 DOWNTO 0)]
      tlx_afu_cmd_pa                    => tlx_afu_cmd_pa,                     -- [OUT STD_ULOGIC_VECTOR(63 DOWNTO 0)]
      tlx_afu_cmd_capptag               => tlx_afu_cmd_capptag,                -- [OUT STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      tlx_afu_cmd_pl                    => tlx_afu_cmd_pl,                     -- [OUT STD_ULOGIC_VECTOR(2 DOWNTO 0)]
      -- Config Command interface to AFU
      cfg_tlx_initial_credit            => cfg_tlx_initial_credit,             -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_credit_return             => cfg_tlx_credit_return,              -- [IN  STD_ULOGIC]
      tlx_cfg_valid                     => tlx_cfg_valid,                      -- [OUT STD_ULOGIC]
      tlx_cfg_opcode                    => tlx_cfg_opcode,                     -- [OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      tlx_cfg_pa                        => tlx_cfg_pa,                         -- [OUT STD_ULOGIC_VECTOR(63 DOWNTO 0)]
      tlx_cfg_t                         => tlx_cfg_t,                          -- [OUT STD_ULOGIC]
      tlx_cfg_pl                        => tlx_cfg_pl,                         -- [OUT STD_ULOGIC_VECTOR(2 DOWNTO 0)]
      tlx_cfg_capptag                   => tlx_cfg_capptag,                    -- [OUT STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      tlx_cfg_data_bus                  => tlx_cfg_data_bus,                   -- [OUT STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      tlx_cfg_data_bdi                  => tlx_cfg_data_bdi,                   -- [OUT STD_ULOGIC]
      -- Response interface to AFU
      afu_tlx_resp_initial_credit       => afu_tlx_resp_initial_credit,        -- [IN  STD_ULOGIC_VECTOR(6 DOWNTO 0)]
      afu_tlx_resp_credit               => afu_tlx_resp_credit,                -- [IN  STD_ULOGIC]
      tlx_afu_resp_valid                => tlx_afu_resp_valid,                 -- [OUT STD_ULOGIC]
      tlx_afu_resp_opcode               => tlx_afu_resp_opcode,                -- [OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      tlx_afu_resp_afutag               => tlx_afu_resp_afutag,                -- [OUT STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      -- Command data interface to AFU
      afu_tlx_cmd_rd_req                => afu_tlx_cmd_rd_req,                 -- [IN  STD_ULOGIC]
      afu_tlx_cmd_rd_cnt                => afu_tlx_cmd_rd_cnt,                 -- [IN  STD_ULOGIC_VECTOR(2 DOWNTO 0)]
      tlx_afu_cmd_data_valid            => tlx_afu_cmd_data_valid,             -- [OUT STD_ULOGIC]
      tlx_afu_cmd_data_bus              => tlx_afu_cmd_data_bus,               -- [OUT STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      -- -----------------------------------
      -- AFU to TLX Framer Transmit Interface
      -- -----------------------------------
      -- --- Commands from AFU
      tlx_afu_cmd_initial_credit        => tlx_afu_cmd_initial_credit,         -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_afu_cmd_credit                => tlx_afu_cmd_credit,                 -- [OUT STD_ULOGIC]
      afu_tlx_cmd_valid                 => afu_tlx_cmd_valid,                  -- [IN  STD_ULOGIC]
      afu_tlx_cmd_opcode                => afu_tlx_cmd_opcode,                 -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      afu_tlx_cmd_actag                 => afu_tlx_cmd_actag,                  -- [IN  STD_ULOGIC_VECTOR(11 DOWNTO 0)]
      afu_tlx_cmd_stream_id             => afu_tlx_cmd_stream_id,              -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      afu_tlx_cmd_ea_or_obj             => afu_tlx_cmd_ea_or_obj,              -- [IN  STD_ULOGIC_VECTOR(67 DOWNTO 0)]
      afu_tlx_cmd_afutag                => afu_tlx_cmd_afutag,                 -- [IN  STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      --afu_tlx_cmd_dl                    => afu_tlx_cmd_dl,                     -- [IN  STD_ULOGIC_VECTOR(1 DOWNTO 0)]
      --afu_tlx_cmd_pl                    => afu_tlx_cmd_pl,                     -- [IN  STD_ULOGIC_VECTOR(2 DOWNTO 0)]
      --afu_tlx_cmd_os                    => afu_tlx_cmd_os,                     -- [IN  STD_ULOGIC]
      --afu_tlx_cmd_be                    => afu_tlx_cmd_be,                     -- [IN  STD_ULOGIC_VECTOR(63 DOWNTO 0)]
      afu_tlx_cmd_flag                  => afu_tlx_cmd_flag,                   -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      --afu_tlx_cmd_endian                => afu_tlx_cmd_endian,                 -- [IN  STD_ULOGIC]
      afu_tlx_cmd_bdf                   => afu_tlx_cmd_bdf,                    -- [IN  STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      afu_tlx_cmd_pasid                 => afu_tlx_cmd_pasid,                  -- [IN  STD_ULOGIC_VECTOR(19 DOWNTO 0)]
      --afu_tlx_cmd_pg_size               => afu_tlx_cmd_pg_size,                -- [IN  STD_ULOGIC_VECTOR(5 DOWNTO 0)]
      -- --- Command data from AFU
      tlx_afu_cmd_data_initial_credit   => tlx_afu_cmd_data_initial_credit,    -- [OUT STD_ULOGIC_VECTOR(5 DOWNTO 0)]
      tlx_afu_cmd_data_credit           => tlx_afu_cmd_data_credit,            -- [OUT STD_ULOGIC]
      --afu_tlx_cdata_valid               => afu_tlx_cdata_valid,                -- [IN  STD_ULOGIC]
      --afu_tlx_cdata_bus                 => afu_tlx_cdata_bus,                  -- [IN  STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      --afu_tlx_cdata_bdi                 => afu_tlx_cdata_bdi,                  -- [IN  STD_ULOGIC]
      -- --- Responses from AFU
      tlx_afu_resp_initial_credit       => tlx_afu_resp_initial_credit,        -- [OUT STD_ULOGIC_VECTOR(5 DOWNTO 0)]
      tlx_afu_resp_credit               => tlx_afu_resp_credit,                -- [OUT STD_ULOGIC]
      afu_tlx_resp_valid                => afu_tlx_resp_valid,                 -- [IN  STD_ULOGIC]
      afu_tlx_resp_opcode               => afu_tlx_resp_opcode,                -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      afu_tlx_resp_dl                   => afu_tlx_resp_dl,                    -- [IN  STD_ULOGIC_VECTOR(1 DOWNTO 0)]
      afu_tlx_resp_capptag              => afu_tlx_resp_capptag,               -- [IN  STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      afu_tlx_resp_dp                   => afu_tlx_resp_dp,                    -- [IN  STD_ULOGIC_VECTOR(1 DOWNTO 0)]
      afu_tlx_resp_code                 => afu_tlx_resp_code,                  -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      -- --- Response data from AFU
      tlx_afu_resp_data_initial_credit  => tlx_afu_resp_data_initial_credit,   -- [OUT STD_ULOGIC_VECTOR(5 DOWNTO 0)]
      tlx_afu_resp_data_credit          => tlx_afu_resp_data_credit,           -- [OUT STD_ULOGIC]
      afu_tlx_rdata_valid               => afu_tlx_rdata_valid,                -- [IN  STD_ULOGIC]
      afu_tlx_rdata_bus                 => afu_tlx_rdata_bus(511 downto 0),                  -- [IN  STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      afu_tlx_rdata_bdi                 => afu_tlx_rdata_bdi,                  -- [IN  STD_ULOGIC]
      afu_tlx_rdata_meta                => afu_tlx_rdata_bus(517 downto 512),                 -- [IN  STD_ULOGIC_VECTOR(5 DOWNTO 0)]
      -- --- Config Responses from AFU
      cfg_tlx_resp_valid                => cfg_tlx_resp_valid,                 -- [IN  STD_ULOGIC]
      cfg_tlx_resp_opcode               => cfg_tlx_resp_opcode,                -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      cfg_tlx_resp_capptag              => cfg_tlx_resp_capptag,               -- [IN  STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      cfg_tlx_resp_code                 => cfg_tlx_resp_code,                  -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_cfg_resp_ack                  => tlx_cfg_resp_ack,                   -- [OUT STD_ULOGIC]
      -- --- Config Response data from AFU
      cfg_tlx_rdata_offset              => cfg_tlx_rdata_offset,               -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_rdata_bus                 => cfg_tlx_rdata_bus,                  -- [IN  STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      cfg_tlx_rdata_bdi                 => cfg_tlx_rdata_bdi,                  -- [IN  STD_ULOGIC]
      -- -----------------------------------
      -- DLX to TLX Parser Interface
      -- -----------------------------------
      dlx_tlx_flit_valid                => dlx_tlx_flit_valid,                 -- [IN  STD_ULOGIC]
      dlx_tlx_flit                      => dlx_tlx_flit,                       -- [IN  STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      dlx_tlx_flit_crc_err              => dlx_tlx_flit_crc_err,               -- [IN  STD_ULOGIC]
      dlx_tlx_link_up                   => dlx_tlx_link_up,                    -- [IN  STD_ULOGIC]
      -- -----------------------------------
      -- TLX Framer to DLX Interface
      -- -----------------------------------
      dlx_tlx_init_flit_depth           => dlx_tlx_init_flit_depth,            -- [IN  STD_ULOGIC_VECTOR(2 DOWNTO 0)]
      dlx_tlx_flit_credit               => dlx_tlx_flit_credit,                -- [IN  STD_ULOGIC]
      tlx_dlx_flit_valid                => tlx_dlx_flit_valid,                 -- [OUT STD_ULOGIC]
      tlx_dlx_flit                      => tlx_dlx_flit,                       -- [OUT STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      tlx_dlx_debug_encode              => tlx_dlx_debug_encode,               -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_dlx_debug_info                => tlx_dlx_debug_info,                 -- [OUT STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      dlx_tlx_dlx_config_info           => dlx_tlx_dlx_config_info,            -- [IN  STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      -- -----------------------------------
      -- Configuration Ports
      -- -----------------------------------
      cfg_tlx_xmit_tmpl_config_0        => cfg_tlx_xmit_tmpl_config_0,         -- [IN  STD_ULOGIC]
      cfg_tlx_xmit_tmpl_config_1        => cfg_tlx_xmit_tmpl_config_1,         -- [IN  STD_ULOGIC]
      cfg_tlx_xmit_tmpl_config_5        => cfg_tlx_xmit_tmpl_config_5,         -- [IN  STD_ULOGIC]
      cfg_tlx_xmit_rate_config_0        => cfg_tlx_xmit_rate_config_0,         -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_xmit_rate_config_1        => cfg_tlx_xmit_rate_config_1,         -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_xmit_rate_config_5        => cfg_tlx_xmit_rate_config_5,         -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_metadata_enabled          => cfg_tlx_metadata_enabled,           -- [IN  STD_ULOGIC]
      tlx_cfg_in_rcv_tmpl_capability_0  => tlx_cfg_in_rcv_tmpl_capability_0,   -- [OUT STD_ULOGIC]
      tlx_cfg_in_rcv_tmpl_capability_1  => tlx_cfg_in_rcv_tmpl_capability_1,   -- [OUT STD_ULOGIC]
      tlx_cfg_in_rcv_tmpl_capability_4  => tlx_cfg_in_rcv_tmpl_capability_4,   -- [OUT STD_ULOGIC]
      tlx_cfg_in_rcv_tmpl_capability_7  => tlx_cfg_in_rcv_tmpl_capability_7,   -- [OUT STD_ULOGIC]
      tlx_cfg_in_rcv_tmpl_capability_10 => tlx_cfg_in_rcv_tmpl_capability_10,  -- [OUT STD_ULOGIC]
      tlx_cfg_in_rcv_rate_capability_0  => tlx_cfg_in_rcv_rate_capability_0,   -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_cfg_in_rcv_rate_capability_1  => tlx_cfg_in_rcv_rate_capability_1,   -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_cfg_in_rcv_rate_capability_4  => tlx_cfg_in_rcv_rate_capability_4,   -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_cfg_in_rcv_rate_capability_7  => tlx_cfg_in_rcv_rate_capability_7,   -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_cfg_in_rcv_rate_capability_10 => tlx_cfg_in_rcv_rate_capability_10,  -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      -- -----------------------------------
      -- Miscellaneous Ports
      -- -----------------------------------
      tlx_mmio_rcv_errors               => tlx_mmio_rcv_errors,
      tlx_mmio_rcv_debug                => tlx_mmio_rcv_debug,
      tlx_mmio_xmt_err                  => tlx_mmio_xmt_err,
      tlx_mmio_xmt_dbg                  => tlx_mmio_xmt_dbg,
      tlx_cfg_oc3_tlx_version           => tlx_cfg_oc3_tlx_version,            --OUT   STD_ULOGIC_VECTOR(31 DOWNTO 0);
      clock                             => clock_400mhz,                       -- [IN  STD_ULOGIC]
      reset_n                           => reset_n);                           -- [IN STD_ULOGIC]


  cfg: entity work.ice_afu_cfg
    PORT MAP (

      -- -----------------------------------
      -- TLX Parser to AFU Receive Interface
      -- -----------------------------------
      tlx_afu_ready => tlx_afu_ready,   -- [IN  STD_ULOGIC]

      cfg_tlx_initial_credit => cfg_tlx_initial_credit,  -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_credit_return  => cfg_tlx_credit_return,   -- [OUT STD_ULOGIC]
      tlx_cfg_valid          => tlx_cfg_valid,           -- [IN  STD_ULOGIC]
      tlx_cfg_opcode         => tlx_cfg_opcode,          -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      tlx_cfg_pa             => tlx_cfg_pa,              -- [IN  STD_ULOGIC_VECTOR(63 DOWNTO 0)]
      tlx_cfg_t              => tlx_cfg_t,               -- [IN  STD_ULOGIC]
      tlx_cfg_pl             => tlx_cfg_pl,              -- [IN  STD_ULOGIC_VECTOR(2 DOWNTO 0)]
      tlx_cfg_capptag        => tlx_cfg_capptag,         -- [IN  STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      tlx_cfg_data_bus       => tlx_cfg_data_bus,        -- [IN  STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      tlx_cfg_data_bdi       => tlx_cfg_data_bdi,        -- [IN  STD_ULOGIC]
      -- --- Config Responses from AFU
      cfg_tlx_resp_valid     => cfg_tlx_resp_valid,      -- [OUT STD_ULOGIC]
      cfg_tlx_resp_opcode    => cfg_tlx_resp_opcode,     -- [OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      cfg_tlx_resp_capptag   => cfg_tlx_resp_capptag,    -- [OUT STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      cfg_tlx_resp_code      => cfg_tlx_resp_code,       -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_cfg_resp_ack       => tlx_cfg_resp_ack,        -- [IN  STD_ULOGIC]
      -- --- Config Response data from AFU
      cfg_tlx_rdata_offset   => cfg_tlx_rdata_offset,    -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_rdata_bus      => cfg_tlx_rdata_bus,       -- [OUT STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      cfg_tlx_rdata_bdi      => cfg_tlx_rdata_bdi,       -- [OUT STD_ULOGIC]

      -- -----------------------------------
      -- Configuration Ports
      -- -----------------------------------
      cfg_tlx_xmit_tmpl_config_0        => cfg_tlx_xmit_tmpl_config_0,         -- [OUT STD_ULOGIC]
      cfg_tlx_xmit_tmpl_config_1        => cfg_tlx_xmit_tmpl_config_1,         -- [OUT STD_ULOGIC]
      cfg_tlx_xmit_tmpl_config_5        => cfg_tlx_xmit_tmpl_config_5,         -- [OUT STD_ULOGIC]
      cfg_tlx_xmit_tmpl_config_9        => cfg_tlx_xmit_tmpl_config_9,         -- [OUT STD_ULOGIC]
      cfg_tlx_xmit_tmpl_config_11       => cfg_tlx_xmit_tmpl_config_11,        -- [OUT STD_ULOGIC]
      cfg_tlx_xmit_rate_config_0        => cfg_tlx_xmit_rate_config_0,         -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_xmit_rate_config_1        => cfg_tlx_xmit_rate_config_1,         -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_xmit_rate_config_5        => cfg_tlx_xmit_rate_config_5,         -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_xmit_rate_config_9        => cfg_tlx_xmit_rate_config_9,         -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_xmit_rate_config_11       => cfg_tlx_xmit_rate_config_11,        -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      cfg_tlx_tl_minor_version          => cfg_tlx_tl_minor_version,           -- [OUT STD_ULOGIC]
      cfg_tlx_enable_afu                => cfg_tlx_enable_afu,                 -- [OUT STD_ULOGIC]
      cfg_tlx_metadata_enabled          => cfg_tlx_metadata_enabled,           -- [OUT STD_ULOGIC]
      cfg_tlx_function_actag_base       => cfg_tlx_function_actag_base,        -- [OUT STD_ULOGIC_VECTOR(11 downto 0)]
      cfg_tlx_function_actag_len_enab   => cfg_tlx_function_actag_len_enab,    -- [OUT STD_ULOGIC_VECTOR(11 downto 0)]
      cfg_tlx_afu_actag_base            => cfg_tlx_afu_actag_base,             -- [OUT STD_ULOGIC_VECTOR(11 downto 0)]
      cfg_tlx_afu_actag_len_enab        => cfg_tlx_afu_actag_len_enab,         -- [OUT STD_ULOGIC_VECTOR(11 downto 0)]
      cfg_tlx_pasid_length_enabled      => cfg_tlx_pasid_length_enabled,       -- [OUT STD_ULOGIC_VECTOR(4 downto 0)]
      cfg_tlx_pasid_base                => cfg_tlx_pasid_base,                 -- [OUT STD_ULOGIC_VECTOR(19 downto 0)]
      cfg_tlx_mmio_bar0                 => cfg_tlx_mmio_bar0,                  -- [OUT STD_ULOGIC_VECTOR(63 downto 35)]
      cfg_tlx_memory_space              => cfg_tlx_memory_space,               -- [OUT STD_ULOGIC]
      cfg_tlx_long_backoff_timer        => cfg_tlx_long_backoff_timer,         -- [OUT STD_ULOGIC_VECTOR(3 downto 0)]
      tlx_cfg_in_rcv_tmpl_capability_0  => tlx_cfg_in_rcv_tmpl_capability_0,   -- [IN  STD_ULOGIC]
      tlx_cfg_in_rcv_tmpl_capability_1  => tlx_cfg_in_rcv_tmpl_capability_1,   -- [IN  STD_ULOGIC]
      tlx_cfg_in_rcv_tmpl_capability_4  => tlx_cfg_in_rcv_tmpl_capability_4,   -- [IN  STD_ULOGIC]
      tlx_cfg_in_rcv_tmpl_capability_7  => tlx_cfg_in_rcv_tmpl_capability_7,   -- [IN  STD_ULOGIC]
      tlx_cfg_in_rcv_tmpl_capability_10 => tlx_cfg_in_rcv_tmpl_capability_10,  -- [IN  STD_ULOGIC]
      tlx_cfg_in_rcv_rate_capability_0  => tlx_cfg_in_rcv_rate_capability_0,   -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_cfg_in_rcv_rate_capability_1  => tlx_cfg_in_rcv_rate_capability_1,   -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_cfg_in_rcv_rate_capability_4  => tlx_cfg_in_rcv_rate_capability_4,   -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_cfg_in_rcv_rate_capability_7  => tlx_cfg_in_rcv_rate_capability_7,   -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_cfg_in_rcv_rate_capability_10 => tlx_cfg_in_rcv_rate_capability_10,  -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      tlx_cfg_oc3_tlx_version           => tlx_cfg_oc3_tlx_version,            -- [IN  STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      tlx_cfg_oc3_dlx_version           => tlx_cfg_oc3_dlx_version,            -- [IN  STD_ULOGIC_VECTOR(31 DOWNTO 0)]
      -- -----------------------------------
      -- Miscellaneous Ports
      -- -----------------------------------
      clock_400mhz                      => clock_400mhz,                       -- [IN  STD_ULOGIC]
      reset_n                           => reset_n);                           -- [IN STD_ULOGIC]

  errrpt_intrp : ENTITY work.ice_errrpt_intrp
      PORT MAP (
        clock_400mhz => clock_400mhz,   -- [in  std_ulogic]
        reset_n      => reset_n,        -- [in  std_ulogic]

        mmio_errrpt_xstop_err => mmio_errrpt_xstop_err,
        mmio_errrpt_mchk_err => mmio_errrpt_mchk_err,

        mmio_errrpt_intrp_hdl_xstop => mmio_errrpt_intrp_hdl_xstop,  -- [in  std_ulogic_vector(63 downto 0)]
        mmio_errrpt_intrp_hdl_app   => mmio_errrpt_intrp_hdl_app,    -- [in  std_ulogic_vector(63 downto 0)]
        mmio_errrpt_cmd_flag_xstop  => mmio_errrpt_cmd_flag_xstop,   -- [in  std_ulogic_vector(3 downto 0)]
        mmio_errrpt_cmd_flag_app    => mmio_errrpt_cmd_flag_app,     -- [in  std_ulogic_vector(3 downto 0)]

        cfg_tlx_function_actag_base     => cfg_tlx_function_actag_base,      -- [in  std_ulogic_vector(11 downto 0)]
        cfg_tlx_function_actag_len_enab => cfg_tlx_function_actag_len_enab,  -- [in  std_ulogic_vector(11 downto 0)]
        cfg_tlx_afu_actag_base          => cfg_tlx_afu_actag_base,           -- [in  std_ulogic_vector(11 downto 0)]
        cfg_tlx_afu_actag_len_enab      => cfg_tlx_afu_actag_len_enab,       -- [in  std_ulogic_vector(11 downto 0)]
        cfg_tlx_pasid_length_enabled    => cfg_tlx_pasid_length_enabled,     -- [in  std_ulogic_vector(4 downto 0)]
        cfg_tlx_pasid_base              => cfg_tlx_pasid_base,               -- [in  std_ulogic_vector(19 downto 0)]

        afu_tlx_resp_initial_credit => afu_tlx_resp_initial_credit,  -- [out std_ulogic_vector(6 downto 0)]
        afu_tlx_resp_credit         => afu_tlx_resp_credit,          -- [out std_ulogic]
        tlx_afu_resp_valid          => tlx_afu_resp_valid,           -- [in  std_ulogic]
        tlx_afu_resp_opcode         => tlx_afu_resp_opcode,          -- [in  std_ulogic_vector(7 downto 0)]
        tlx_afu_resp_afutag         => tlx_afu_resp_afutag,          -- [in  std_ulogic_vector(15 downto 0)]

        tlx_afu_cmd_initial_credit => tlx_afu_cmd_initial_credit,  -- [in  std_ulogic_vector(3 downto 0)]
        tlx_afu_cmd_credit         => tlx_afu_cmd_credit,          -- [in  std_ulogic]
        afu_tlx_cmd_valid          => afu_tlx_cmd_valid,           -- [out std_ulogic]
        afu_tlx_cmd_opcode         => afu_tlx_cmd_opcode,          -- [out std_ulogic_vector(7 downto 0)]
        afu_tlx_cmd_actag          => afu_tlx_cmd_actag,           -- [out std_ulogic_vector(11 downto 0)]
        afu_tlx_cmd_stream_id      => afu_tlx_cmd_stream_id,       -- [out std_ulogic_vector(3 downto 0)]
        afu_tlx_cmd_ea_or_obj      => afu_tlx_cmd_ea_or_obj,       -- [out std_ulogic_vector(63 downto 0)]
        afu_tlx_cmd_afutag         => afu_tlx_cmd_afutag,          -- [out std_ulogic_vector(15 downto 0)]
        afu_tlx_cmd_flag           => afu_tlx_cmd_flag,            -- [out std_ulogic_vector(3 downto 0)]
        afu_tlx_cmd_bdf            => afu_tlx_cmd_bdf,             -- [out std_ulogic_vector(15 downto 0)]
        afu_tlx_cmd_pasid          => afu_tlx_cmd_pasid,          -- [out std_ulogic_vector(19 downto 0)]
        err_rpt_dbg                => err_rpt_dbg);

  mmio: entity work.ice_mmio_mac
    port map (
      clock_400mhz                => clock_400mhz,                      -- [IN  STD_ULOGIC]
      reset_n                     => reset_n,                           -- [IN  STD_ULOGIC]
      xlate_mmio_cmd_val          => xlate_mmio_cmd_val,                -- [IN  STD_ULOGIC]
      mmio_xlate_fc               => mmio_xlate_fc,                     -- [OUT  STD_ULOGIC]
      xlate_mmio_cmd_addr         => xlate_mmio_cmd_addr,               -- [IN STD_ULOGIC_VECTOR(34 downto 0)]
      xlate_mmio_cmd_rd           => xlate_mmio_cmd_rd,                 -- [IN STD_ULOGIC]
      xlate_mmio_cmd_tag          => xlate_mmio_cmd_tag,                -- [IN STD_ULOGIC_VECTOR(15 downto 0)]
      xlate_mmio_data             => xlate_mmio_data,                   -- [IN STD_ULOGIC_VECTOR(511 downto 0)]
      xlate_mmio_data_val         => xlate_mmio_data_val,               -- [IN STD_ULOGIC]
      mmio_errrpt_intrp_hdl_xstop => mmio_errrpt_intrp_hdl_xstop,       -- [OUT STD_ULOGIC_VECTOR(63 downto 0)]
      mmio_errrpt_intrp_hdl_app   => mmio_errrpt_intrp_hdl_app,         -- [OUT STD_ULOGIC_VECTOR(63 downto 0)]
      mmio_errrpt_cmd_flag_xstop  => mmio_errrpt_cmd_flag_xstop,        -- [OUT STD_ULOGIC_VECTOR(3 downto 0)]
      mmio_errrpt_cmd_flag_app    => mmio_errrpt_cmd_flag_app,          -- [OUT STD_ULOGIC_VECTOR(3 downto 0)]
      mmio_afu_resp_val           => mmio_afu_resp_val,                 -- [OUT STD_ULOGIC]
      afu_mmio_resp_ack           => afu_mmio_resp_ack,                 -- [IN STD_ULOGIC]
      mmio_afu_resp_opcode        => mmio_afu_resp_opcode,              -- [OUT STD_ULOGIC_VECTOR(7 downto 0)]
      mmio_afu_resp_tag           => mmio_afu_resp_tag,                 -- [OUT STD_ULOGIC_VECTOR(15 downto 0)]
      mmio_afu_resp_dl            => mmio_afu_resp_dl,                  -- [OUT STD_ULOGIC_VECTOR(1 downto 0)]
      mmio_afu_resp_dp            => mmio_afu_resp_dp,                  -- [OUT STD_ULOGIC_VECTOR(1 downto 0)]
      mmio_afu_resp_code          => mmio_afu_resp_code,                -- [OUT STD_ULOGIC_VECTOR(3 downto 0)]
      mmio_afu_rdata_bus          => mmio_afu_rdata_bus,                -- [OUT STD_ULOGIC_VECTOR(511 downto 0)]
      mmio_afu_rdata_val          => mmio_afu_rdata_val,               -- [OUT STD_ULOGIC]
      mmio_errrpt_mchk_err        => mmio_errrpt_mchk_err,
      mmio_errrpt_xstop_err       => mmio_errrpt_xstop_err,
      tlx_mmio_err                => tlx_mmio_rcv_errors,
      tlx_mmio_dbg                => tlx_mmio_rcv_debug,
      afu_mmio_err                => afu_mmio_err_int          ,
      tbd_mmio_err                => tlx_mmio_xmt_err(13 downto 0)          ,
      tlx_mmio_xmt_dbg            => tlx_mmio_xmt_dbg,
      ice_perv_lem0               => ice_perv_lem0         ,
      ice_perv_trap0              => ice_perv_trap0        ,
      ice_perv_trap1              => ice_perv_trap1        ,
      ice_perv_trap2              => ice_perv_trap2        ,
      ice_perv_trap3              => ice_perv_trap3        ,
      ice_perv_trap4              => ice_perv_trap4        ,
      ice_perv_ecid               => ice_perv_ecid,
      perv_mmio_pulse             => perv_mmio_pulse,
      mc_mmio_dbg                 => mc_mmio_dbg,
      force_recal                 => force_recal, --            : OUT STD_ULOGIC;
      mem_init_start              => mem_init_start,    -- [out  STD_ULOGIC]
      mem_init_zero               => mem_init_zero,    -- [out  STD_ULOGIC]
      auto_recal_disable          => auto_recal_disable, --            : OUT STD_ULOGIC;
      --EDPL
      reg_04_val                  => reg_04_val,  --    : out  STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_04_hwwe                 => reg_04_hwwe,  --   : in STD_ULOGIC;
      reg_04_update               => reg_04_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_05_hwwe                 => reg_05_hwwe,  --   : in STD_ULOGIC;
      reg_05_update               => reg_05_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_06_hwwe                 => reg_06_hwwe,  --   : in STD_ULOGIC;
      reg_06_update               => reg_06_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_07_hwwe                 => reg_07_hwwe,  --   : in STD_ULOGIC;
      reg_07_update               => reg_07_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      err_rpt_dbg                 => err_rpt_dbg,
      ui_mmio_err_dbg             => ui_mmio_err_dbg,
      dbg_spare_in                => dbg_spare_in);

  mem_init: entity work.ice_mem_init
    PORT MAP (

      -- cmd from afu main 
      i_afu_cmd_valid => afu_cmd_valid,  -- [in  std_ulogic]
      i_afu_cmd_rw    => afu_cmd_rw,     -- [in  std_ulogic] 1=write.
      i_afu_cmd_addr  => afu_cmd_addr,   -- [in  std_ulogic_vector(31 downto 3)]
      i_afu_cmd_tag   => afu_cmd_tag,    -- [in  std_ulogic_vector(15 downto 0)]
      i_afu_cmd_size  => afu_cmd_size,   -- [in  std_ulogic] 0:64B, 1:128B

      i_afu_wvalid => afu_wvalid,     -- [in  std_ulogic_vector(1 downto 0)] p1, p0.
      i_afu_wdata  => afu_wdata,      -- [in  std_ulogic_vector(511 downto 0)]
      i_afu_wmeta  => afu_wmeta,      -- [in  std_ulogic_vector(39 downto 0)]

      --Muxed out cmd to UI
      -----------------------------------
      -- --UI cmd queue interface 
      -- -----------------------------------
      o_ui_cmd_valid => cmd_valid,  -- [OUT STD_ULOGIC]
      o_ui_cmd_rw    => cmd_rw,     -- [OUT STD_ULOGIC] 0:R  1:W
      o_ui_cmd_addr  => cmd_addr,   -- [OUT STD_ULOGIC_VECTOR(31 DOWNTO 3)]
      o_ui_cmd_tag   => cmd_tag,    -- [OUT STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      o_ui_cmd_size  => cmd_size,   -- [OUT STD_ULOGIC]

      o_ui_wvalid => wvalid,       -- [OUT STD_ULOGIC_VECTOR(1 DOWNTO 0)]
      o_ui_wdata  => wdata,        -- [OUT STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      o_ui_wmeta  => wmeta,        -- [OUT STD_ULOGIC_VECTOR(39 DOWNTO 0)]


      --Response from UI
      i_ui_cmd_fc   => ui_cmd_fc,     -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      i_ui_rsp_tag  => ui_rsp_tag,    -- [IN  STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      i_ui_rsp_data => ui_rsp_data,   -- [IN  STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      i_ui_rsp_meta => ui_rsp_meta,   -- [IN  STD_ULOGIC_VECTOR(39 DOWNTO 0)]
      i_ui_rsp_perr => ui_rsp_perr,   -- [IN  STD_ULOGIC_VECTOR(23 DOWNTO 0)]
      i_ui_rsp_offs => ui_rsp_offs,   -- [IN  STD_ULOGIC]
      i_ui_rsp_size => ui_rsp_size,  -- [IN  STD_ULOGIC] 0: indicates request was for 64B  1: indicates request was for 128B. i_rsp_offs determine which half
      o_ui_yield    => yield,      -- [OUT STD_ULOGIC_VECTOR(1 DOWNTO 0)]
      o_ui_arbwt    => arbwt,      -- [OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)]

      -- response to afu main
      o_afu_cmd_fc   => cmd_fc,    -- [out std_ulogic_vector(3 downto 0)] r1, r0, w1, w0
      o_afu_rsp_tag  => rsp_tag,   -- [out std_ulogic_vector(15 downto 0)]
      o_afu_rsp_offs => rsp_offs,  -- [out std_ulogic]
      o_afu_rsp_data => rsp_data,  -- [out std_ulogic_vector(511 downto 0)]
      o_afu_rsp_meta => rsp_meta,  -- [out std_ulogic_vector(39 downto 0)]
      o_afu_rsp_size => rsp_size,  -- [out std_ulogic]
      o_afu_rsp_perr => rsp_perr,  -- [out std_ulogic_vector(23 downto 0)]
      i_afu_yield    => afu_yield,     -- [in  STD_ULOGIC_VECTOR(1 DOWNTO 0)]
      i_afu_arbwt    => afu_arbwt,     -- [in  STD_ULOGIC_VECTOR(7 DOWNTO 0)]

      mem_init_start   => mem_init_start,    -- [IN  STD_ULOGIC]
      mem_init_zero    => mem_init_zero,    -- [IN  STD_ULOGIC]
      mem_init_done    => mem_init_done,     -- [out STD_ULOGIC]
      mem_init_ip      => mem_init_ip,     -- [out STD_ULOGIC]
      mem_init_wait    => mem_init_wait,     -- [out STD_ULOGIC]
      mem_init_addr    => mem_init_addr,     -- [out STD_ULOGIC_VECTOR(28 downto 0)]

      clock_400mhz => clock_400mhz,     -- [IN  STD_ULOGIC]
      reset_n      => reset_n);         -- [IN STD_ULOGIC]

  main: entity work.ice_afu_main
      PORT MAP (
        -- -----------------------------------
        -- TLX Parser to AFU Receive Interface
        -- -----------------------------------
        tlx_afu_ready                    => tlx_afu_ready,                     -- [IN  STD_ULOGIC]
        -- Command interface to AFU
        afu_tlx_cmd_initial_credit       => afu_tlx_cmd_initial_credit,        -- [OUT STD_ULOGIC_VECTOR(6 DOWNTO 0)]
        afu_tlx_cmd_credit               => afu_tlx_cmd_credit,                -- [OUT STD_ULOGIC]
        tlx_afu_cmd_valid                => tlx_afu_cmd_valid,                 -- [IN  STD_ULOGIC]
        tlx_afu_cmd_opcode               => tlx_afu_cmd_opcode,                -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
        tlx_afu_cmd_dl                   => tlx_afu_cmd_dl,                    -- [IN  STD_ULOGIC_VECTOR(1 DOWNTO 0)]
--        tlx_afu_cmd_end                  => tlx_afu_cmd_end,                   -- [IN  STD_ULOGIC]
        tlx_afu_cmd_pa                   => tlx_afu_cmd_pa,                    -- [IN  STD_ULOGIC_VECTOR(63 DOWNTO 0)]
        tlx_afu_cmd_capptag              => tlx_afu_cmd_capptag,               -- [in  STD_ULOGIC_VECTOR(15 DOWNTO 0)]
        -- Command data interface to AFU
        afu_tlx_cmd_rd_req               => afu_tlx_cmd_rd_req,                -- [OUT STD_ULOGIC]
        afu_tlx_cmd_rd_cnt               => afu_tlx_cmd_rd_cnt,                -- [OUT STD_ULOGIC_VECTOR(2 DOWNTO 0)]
        tlx_afu_cmd_data_valid           => tlx_afu_cmd_data_valid,            -- [IN  STD_ULOGIC]
--        tlx_afu_cmd_data_bdi             => tlx_afu_cmd_data_bdi,              -- [IN  STD_ULOGIC]
        tlx_afu_cmd_data_bus             => tlx_afu_cmd_data_bus,              -- [IN  STD_ULOGIC_VECTOR(517 DOWNTO 0)]
        -- -----------------------------------
        -- AFU to TLX Framer Transmit Interface
        -- -----------------------------------
        -- --- Responses from AFU
        tlx_afu_resp_initial_credit      => tlx_afu_resp_initial_credit,       -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
        tlx_afu_resp_credit              => tlx_afu_resp_credit,               -- [IN  STD_ULOGIC]
        afu_tlx_resp_valid               => afu_tlx_resp_valid,                -- [OUT STD_ULOGIC]
        afu_tlx_resp_opcode              => afu_tlx_resp_opcode,               -- [OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)]
        afu_tlx_resp_dl                  => afu_tlx_resp_dl,                   -- [OUT STD_ULOGIC_VECTOR(1 DOWNTO 0)]
        afu_tlx_resp_capptag             => afu_tlx_resp_capptag,              -- [OUT STD_ULOGIC_VECTOR(15 DOWNTO 0)]
        afu_tlx_resp_dp                  => afu_tlx_resp_dp,                   -- [OUT STD_ULOGIC_VECTOR(1 DOWNTO 0)]
        afu_tlx_resp_code                => afu_tlx_resp_code,                 -- [OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)]
        -- --- Response data from AFU
        tlx_afu_resp_data_initial_credit => tlx_afu_resp_data_initial_credit,  -- [IN  STD_ULOGIC_VECTOR(5 DOWNTO 0)]
        tlx_afu_resp_data_credit         => tlx_afu_resp_data_credit,          -- [IN  STD_ULOGIC]
        afu_tlx_rdata_valid              => afu_tlx_rdata_valid,               -- [OUT STD_ULOGIC]
        afu_tlx_rdata_bus                => afu_tlx_rdata_bus,                 -- [OUT STD_ULOGIC_VECTOR(511 DOWNTO 0)]
        afu_tlx_rdata_bdi                => afu_tlx_rdata_bdi,                 -- [OUT STD_ULOGIC]
        -- -----------------------------------
        -- --UI cmd queue interface
        -- -----------------------------------
        o_cmd_valid                      => afu_cmd_valid,                       -- [OUT STD_ULOGIC]
        o_cmd_rw                         => afu_cmd_rw,    -- [OUT STD_ULOGIC] 0:R  1:W
        o_cmd_addr                       => afu_cmd_addr,  -- [OUT STD_ULOGIC_VECTOR(31 DOWNTO 3)]
        o_cmd_tag                        => afu_cmd_tag,   -- [OUT STD_ULOGIC_VECTOR(15 DOWNTO 0)]
        o_cmd_size                       => afu_cmd_size,  -- [OUT STD_ULOGIC]
        i_cmd_fc                         => cmd_fc,    -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
        -- -----------------------------------
        -- --UI Data queue interface
        -- -----------------------------------
        o_wvalid                         => afu_wvalid,    -- [OUT STD_ULOGIC_VECTOR(1 DOWNTO 0)]
        o_wdata                          => afu_wdata,     -- [OUT STD_ULOGIC_VECTOR(511 DOWNTO 0)]
        o_wmeta                          => afu_wmeta,     -- [OUT STD_ULOGIC_VECTOR(39 DOWNTO 0)]
        -- -----------------------------------
        -- --UI response interface
        -- -----------------------------------
        i_rsp_tag                        => rsp_tag,   -- [IN  STD_ULOGIC_VECTOR(15 DOWNTO 0)]
        i_rsp_data                       => rsp_data,  -- [IN  STD_ULOGIC_VECTOR(511 DOWNTO 0)]
        i_rsp_meta                       => rsp_meta,  -- [IN  STD_ULOGIC_VECTOR(39 DOWNTO 0)]
        i_rsp_perr                       => rsp_perr,  -- [IN  STD_ULOGIC_VECTOR(23 DOWNTO 0)]
        i_rsp_offs                       => rsp_offs,  -- [IN  STD_ULOGIC]
        i_rsp_size                       => rsp_size,  -- [IN  STD_ULOGIC] 0: indicates request was for 64B  1: indicates request was for 128B. i_rsp_offs determine which half
        o_yield                          => afu_yield,     -- [OUT STD_ULOGIC_VECTOR(1 downto 0)]
        o_arbwt                          => afu_arbwt,     -- [OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)]
        -- -----------------------------------
        -- --MMIO cmd queue interface
        -- -----------------------------------
        xlate_mmio_cmd_val               => xlate_mmio_cmd_val,                -- [OUT STD_ULOGIC]
        mmio_xlate_fc                    => mmio_xlate_fc,                     -- [IN  STD_ULOGIC]
        xlate_mmio_cmd_addr              => xlate_mmio_cmd_addr,               -- [OUT STD_ULOGIC_VECTOR(34 DOWNTO 0)]
        xlate_mmio_cmd_rd                => xlate_mmio_cmd_rd,                 -- [OUT STD_ULOGIC]
        xlate_mmio_cmd_tag               => xlate_mmio_cmd_tag,                -- [OUT STD_ULOGIC_VECTOR(15 DOWNTO 0)]
        -- -----------------------------------
        -- --MMIO data queue interface
        -- -----------------------------------
        xlate_mmio_data                  => xlate_mmio_data,                   -- [OUT STD_ULOGIC_VECTOR(511 DOWNTO 0)]
        xlate_mmio_data_val              => xlate_mmio_data_val,               -- [OUT STD_ULOGIC]
        ----------------------------------------------------------------------------------------------
        -- interface with vc0 response mux
        ----------------------------------------------------------------------------------------------
        mmio_afu_resp_val                => mmio_afu_resp_val,                 -- [IN  STD_ULOGIC]
        afu_mmio_resp_ack                => afu_mmio_resp_ack,                 -- [OUT STD_ULOGIC]
        mmio_afu_resp_opcode             => mmio_afu_resp_opcode,              -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
        mmio_afu_resp_tag                => mmio_afu_resp_tag,                 -- [IN  STD_ULOGIC_VECTOR(15 DOWNTO 0)]
        mmio_afu_resp_dl                 => mmio_afu_resp_dl,                  -- [IN  STD_ULOGIC_VECTOR(1 DOWNTO 0)]
        mmio_afu_resp_dp                 => mmio_afu_resp_dp,                  -- [IN  STD_ULOGIC_VECTOR(1 DOWNTO 0)]
        mmio_afu_resp_code               => mmio_afu_resp_code,                -- [IN  STD_ULOGIC_VECTOR(3 DOWNTO 0)]
        mmio_afu_rdata_bus               => mmio_afu_rdata_bus,                -- [IN  STD_ULOGIC_VECTOR(511 DOWNTO 0)]
        mmio_afu_rdata_val               => mmio_afu_rdata_val,                -- [IN  STD_ULOGIC]
        -- -----------------------------------
        -- Miscellaneous Ports
        -- -----------------------------------
        afu_mmio_err                     => afu_mmio_err,                      -- [OUT STD_ULOGIC_VECTOR(15 DOWNTO 0)]
        afu_mmio_dbg                     => afu_mmio_dbg,                      -- [OUT STD_ULOGIC_VECTOR(63 DOWNTO 0)]
        cfg_tlx_mmio_bar0                => cfg_tlx_mmio_bar0,                 -- [IN  STD_ULOGIC_VECTOR(63 DOWNTO 35)] Upper 29 bits of BAR0 Function 1
        cfg_tlx_memory_space             => cfg_tlx_memory_space,              -- [IN  STD_ULOGIC] When 1, MMIO space is activated
        clock_400mhz                     => clock_400mhz,                      -- [IN  STD_ULOGIC]
        reset_n                          => reset_n);    -- [IN STD_ULOGIC]

  ui: entity work.ice_afu_ui
    PORT MAP (
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
      -- -----------------------------------
      -- --UI cmd queue interface
      -- -----------------------------------
      i_cmd_valid               => cmd_valid,                -- [in  STD_ULOGIC]
      i_cmd_rw                  => cmd_rw,    -- [in  STD_ULOGIC] 0:R  1:W
      i_cmd_addr                => cmd_addr,  -- [in  STD_ULOGIC_VECTOR(31 DOWNTO 3)]
      i_cmd_tag                 => cmd_tag,   -- [in  STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      i_cmd_size                => cmd_size,  -- [in  STD_ULOGIC]
      o_cmd_fc                  => ui_cmd_fc,    -- [out STD_ULOGIC_VECTOR(3 DOWNTO 0)]
      -- -----------------------------------
      -- --UI Data queue interface
      -- -----------------------------------
      i_wvalid                  => wvalid,    -- [in  STD_ULOGIC_VECTOR(1 DOWNTO 0)]
      i_wdata                   => wdata,     -- [in  STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      i_wmeta                   => wmeta,   -- [in  STD_ULOGIC_VECTOR(39 DOWNTO 0)]
      -- -----------------------------------
      -- --UI response interface
      -- -----------------------------------
      o_rsp_tag                 => ui_rsp_tag,   -- [out STD_ULOGIC_VECTOR(15 DOWNTO 0)]
      o_rsp_data                => ui_rsp_data,  -- [out STD_ULOGIC_VECTOR(511 DOWNTO 0)]
      o_rsp_meta                => ui_rsp_meta,  -- [out STD_ULOGIC_VECTOR(39 DOWNTO 0)]
      o_rsp_perr                => ui_rsp_perr,            -- [out STD_ULOGIC_VECTOR(23 downto 0)]
      o_rsp_offs                => ui_rsp_offs,  -- [out STD_ULOGIC]
      o_rsp_size                => ui_rsp_size,  -- [out STD_ULOGIC] 0: indicates request was for 64B  1: indicates request was for 128B. i_rsp_offs determine which half
      i_yield                   => yield,     -- [in  STD_ULOGIC_VECTOR(1 downto 0)]
      i_arbwt                   => arbwt,     -- [in  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      -- -----------------------------------
      -- dbg & err
      -- -----------------------------------
      o_idle                    => ui_mmio_dbg(1 DOWNTO 0),                   -- [out  std_ulogic_vector(1 downto 0)]
      o_mc0_fifo_err            => ui_mmio_err(34 DOWNTO 25),                 --   : out std_ulogic_vector(9 downto 0)      -- @hclk
      o_mc1_fifo_err            => ui_mmio_err(44 DOWNTO 35),                 --   : out std_ulogic_vector(9 downto 0)      -- @hclk
      -- -----------------------------------
      -- Miscellaneous Ports
      -- -----------------------------------
      clock_400mhz              => clock_400mhz,               -- [IN  STD_ULOGIC]
      reset_n                   => reset_n);    -- [IN STD_ULOGIC]

      ui_mmio_err(24)          <= cmd_fc(3) AND or_reduce(rsp_perr(23 DOWNTO 0));
      ui_mmio_err(23 DOWNTO 0) <= gate(rsp_perr(23 DOWNTO 0), (cmd_fc(3) OR cmd_fc(2)));
      ui_mmio_err(49 DOWNTO 45) <= (OTHERS => '0');
      afu_mmio_err_int <= afu_mmio_err(15 downto 4) & or_reduce(ui_mmio_err) & "000";
      ui_mmio_err_dbg <= ui_mmio_err(49 downto 0) & "00000000000000";

END ice_afu_mac;
