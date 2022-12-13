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
 
 
 


Library Ieee, Work;
Use Ieee.Std_logic_1164.All;
Use Ieee.Numeric_std.All;
Use Ieee.Std_logic_arith.All;
Use Work.Ice_func.All;

ENTITY ice_afu_main IS
  PORT
    (
      -- -----------------------------------
      -- TLX Parser to AFU Receive Interface
      -- -----------------------------------
      tlx_afu_ready                    : IN  STD_ULOGIC;
      -- Command interface to AFU
      afu_tlx_cmd_initial_credit       : OUT STD_ULOGIC_VECTOR(6 DOWNTO 0);
      afu_tlx_cmd_credit               : OUT STD_ULOGIC;
      tlx_afu_cmd_valid                : IN  STD_ULOGIC;
      tlx_afu_cmd_opcode               : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      tlx_afu_cmd_dl                   : IN  STD_ULOGIC_VECTOR(1 DOWNTO 0);
--      tlx_afu_cmd_end                  : IN  STD_ULOGIC;
      tlx_afu_cmd_pa                   : IN  STD_ULOGIC_VECTOR(63 DOWNTO 0);
      tlx_afu_cmd_capptag              : in  STD_ULOGIC_VECTOR(15 DOWNTO 0);
      -- Command data interface to AFU
      afu_tlx_cmd_rd_req               : OUT STD_ULOGIC;
      afu_tlx_cmd_rd_cnt               : OUT STD_ULOGIC_VECTOR(2 DOWNTO 0);
      tlx_afu_cmd_data_valid           : IN  STD_ULOGIC;
--      tlx_afu_cmd_data_bdi             : IN  STD_ULOGIC;
      tlx_afu_cmd_data_bus             : IN  STD_ULOGIC_VECTOR(517 DOWNTO 0);
      -- -----------------------------------
      -- AFU to TLX Framer Transmit Interface
      -- -----------------------------------
      -- --- Responses from AFU
      tlx_afu_resp_initial_credit      : IN  STD_ULOGIC_VECTOR(5 DOWNTO 0);
      tlx_afu_resp_credit              : IN  STD_ULOGIC;
      afu_tlx_resp_valid               : OUT STD_ULOGIC;
      afu_tlx_resp_opcode              : OUT STD_ULOGIC_VECTOR(7 DOWNTO 0);
      afu_tlx_resp_dl                  : OUT STD_ULOGIC_VECTOR(1 DOWNTO 0);
      afu_tlx_resp_capptag             : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0);
      afu_tlx_resp_dp                  : OUT STD_ULOGIC_VECTOR(1 DOWNTO 0);
      afu_tlx_resp_code                : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0);
      -- --- Response data from AFU
      tlx_afu_resp_data_initial_credit : IN  STD_ULOGIC_VECTOR(5 DOWNTO 0);
      tlx_afu_resp_data_credit         : IN  STD_ULOGIC;
      afu_tlx_rdata_valid              : OUT STD_ULOGIC;
      afu_tlx_rdata_bus                : OUT STD_ULOGIC_VECTOR(517 DOWNTO 0);
      afu_tlx_rdata_bdi                : OUT STD_ULOGIC;
      -- -----------------------------------
      -- --UI cmd queue interface 
      -- -----------------------------------
      o_cmd_valid                      : OUT STD_ULOGIC;
      o_cmd_rw                         : OUT STD_ULOGIC;                       --0:R  1:W
      o_cmd_addr                       : OUT STD_ULOGIC_VECTOR(31 DOWNTO 3);
      o_cmd_tag                        : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0);
      o_cmd_size                       : OUT STD_ULOGIC;
      i_cmd_fc                         : IN  STD_ULOGIC_VECTOR(3 DOWNTO 0);
      -- -----------------------------------
      -- --UI Data queue interface 
      -- -----------------------------------
      o_wvalid                         : OUT STD_ULOGIC_VECTOR(1 DOWNTO 0);
      o_wdata                          : OUT STD_ULOGIC_VECTOR(511 DOWNTO 0);
      o_wmeta                          : OUT STD_ULOGIC_VECTOR(39 DOWNTO 0);
      -- -----------------------------------
      -- --UI response interface 
      -- -----------------------------------
      i_rsp_tag                        : IN  STD_ULOGIC_VECTOR(15 DOWNTO 0);
      i_rsp_data                       : IN  STD_ULOGIC_VECTOR(511 DOWNTO 0);
      i_rsp_meta                       : IN  STD_ULOGIC_VECTOR(39 DOWNTO 0);
      i_rsp_perr                       : IN  STD_ULOGIC_VECTOR(23 DOWNTO 0);
      i_rsp_offs                       : IN  STD_ULOGIC;
      i_rsp_size                       : IN  STD_ULOGIC; --0: indicates request was for 64B  1: indicates request was for 128B. i_rsp_offs determine which half 
      o_yield                          : OUT STD_ULOGIC_VECTOR(1 DOWNTO 0);
      o_arbwt                          : OUT STD_ULOGIC_VECTOR(7 DOWNTO 0);
      -- -----------------------------------
      -- --MMIO cmd queue interface 
      -- -----------------------------------
      xlate_mmio_cmd_val               : OUT STD_ULOGIC;
      mmio_xlate_fc                    : IN  STD_ULOGIC;
      xlate_mmio_cmd_addr              : OUT STD_ULOGIC_VECTOR(34 DOWNTO 0);
      xlate_mmio_cmd_rd                : OUT STD_ULOGIC;
      xlate_mmio_cmd_tag               : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0);
      -- -----------------------------------
      -- --MMIO data queue interface 
      -- -----------------------------------
      xlate_mmio_data                  : OUT STD_ULOGIC_VECTOR(511 DOWNTO 0);
      xlate_mmio_data_val              : OUT STD_ULOGIC;
      ----------------------------------------------------------------------------------------------
      -- interface with vc0 response mux
      ----------------------------------------------------------------------------------------------
      mmio_afu_resp_val                : IN  STD_ULOGIC;
      afu_mmio_resp_ack                : OUT STD_ULOGIC;
      mmio_afu_resp_opcode             : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      mmio_afu_resp_tag                : IN  STD_ULOGIC_VECTOR(15 DOWNTO 0);
      mmio_afu_resp_dl                 : IN  STD_ULOGIC_VECTOR(1 DOWNTO 0);
      mmio_afu_resp_dp                 : IN  STD_ULOGIC_VECTOR(1 DOWNTO 0);
      mmio_afu_resp_code               : IN  STD_ULOGIC_VECTOR(3 DOWNTO 0);
      mmio_afu_rdata_bus               : IN  STD_ULOGIC_VECTOR(511 DOWNTO 0);
      mmio_afu_rdata_val               : IN  STD_ULOGIC;
      -- -----------------------------------
      -- Miscellaneous Ports
      -- -----------------------------------
      afu_mmio_err                     : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0);
      afu_mmio_dbg                     : OUT STD_ULOGIC_VECTOR(63 DOWNTO 0);
      cfg_tlx_mmio_bar0                : IN  STD_ULOGIC_VECTOR(63 DOWNTO 35);  -- Upper 29 bits of BAR0 Function 1
      cfg_tlx_memory_space             : IN  STD_ULOGIC;                       -- When 1, MMIO space is activated
      clock_400mhz                     : IN  STD_ULOGIC;
      reset_n                          : IN  STD_ULOGIC

      );
END ice_afu_main;

ARCHITECTURE ice_afu_main OF ice_afu_main IS
  
  SIGNAL readcmd_in                  : STD_ULOGIC;
  SIGNAL writecmd_in                 : STD_ULOGIC;
  SIGNAL partial_op                  : STD_ULOGIC;
  SIGNAL mmiocmd_in                  : STD_ULOGIC;
  SIGNAL cmd_fifo_dat_out            : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL fifo_rd_q                   : STD_ULOGIC;
  SIGNAL reset_n_d                   : STD_ULOGIC;
  SIGNAL reset_n_q                   : STD_ULOGIC;
  SIGNAL cmd_fifo_dat_in             : STD_ULOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL cmd_fifo_write              : STD_ULOGIC;
  SIGNAL intlv0_wr_crd_d             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL intlv0_wr_crd_q             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL intlv0_wr                   : STD_ULOGIC;
  SIGNAL fifo_rd                     : STD_ULOGIC;
  SIGNAL cmd_fifo_rd                 : STD_ULOGIC;
  SIGNAL Cmd_fifo_err                : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL data_ctrl_fifo_err          : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL intlv1_wr_crd_d             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL intlv1_wr_crd_q             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL intlv1_wr                   : STD_ULOGIC;
  SIGNAL intlv0_rd_crd_d             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL intlv0_rd_crd_q             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL intlv0_rd                   : STD_ULOGIC;
  SIGNAL intlv1_rd_crd_d             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL intlv1_rd_crd_q             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL mmio_crd_d                  : STD_ULOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL mmio_crd_q                  : STD_ULOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL mmiocmd_out                 : STD_ULOGIC;
  SIGNAL writecmd_out                : STD_ULOGIC;
  SIGNAL readcmd_out                 : STD_ULOGIC;
  SIGNAL pt                          : STD_ULOGIC;
  SIGNAL pt_out                      : STD_ULOGIC;
  SIGNAL intlv1_rd                   : STD_ULOGIC;
  SIGNAL use_wr0_fc                  : STD_ULOGIC;
  SIGNAL use_wr1_fc                  : STD_ULOGIC;
  SIGNAL use_rd0_fc                  : STD_ULOGIC;
  SIGNAL use_rd1_fc                  : STD_ULOGIC;
  SIGNAL use_mmio_fc                  : STD_ULOGIC;
  SIGNAL return_wr0_fc               : STD_ULOGIC;
  SIGNAL return_wr1_fc               : STD_ULOGIC;
  SIGNAL return_rd0_fc               : STD_ULOGIC;
  SIGNAL return_rd1_fc               : STD_ULOGIC;
--  SIGNAL intlv0_wr_d                 : STD_ULOGIC;
--  SIGNAL intlv1_wr_d                 : STD_ULOGIC;
--  SIGNAL intlv0_rd_d                 : STD_ULOGIC;
--  SIGNAL intlv1_rd_d                 : STD_ULOGIC;
  SIGNAL cmd_rw_d                    : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL cmd_tag_d                   : STD_ULOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL phy_addr_d                  : STD_ULOGIC_VECTOR(39 DOWNTO 5);
  SIGNAL cmd_size_d                  : STD_ULOGIC;
--  SIGNAL cmd_mmio_d                  : STD_ULOGIC;
  SIGNAL cmdrdy_cmdval               : STD_ULOGIC;
  SIGNAL cmdrdy_q                    : STD_ULOGIC;
  SIGNAL cmd_fifo_dat_out_val        : STD_ULOGIC;
  SIGNAL cmd_crd_rdy                 : STD_ULOGIC;
  SIGNAL cmdrdy_cmdmmio              : STD_ULOGIC;
  SIGNAL mmio_crd_rdy                : STD_ULOGIC;
  SIGNAL cmdval_cmdrdy               : STD_ULOGIC;
  SIGNAL cmdval_q                    : STD_ULOGIC;
  SIGNAL mmio_crd_nrdy               : STD_ULOGIC;
  SIGNAL cmd_crd_nrdy                : STD_ULOGIC;
  SIGNAL cmdval_cmdmmio              : STD_ULOGIC;
  SIGNAL cmdmmio_cmdval              : STD_ULOGIC;
  SIGNAL cmdmmio_q                   : STD_ULOGIC;
  SIGNAL cmdmmio_d                   : STD_ULOGIC;
  SIGNAL cmdmmio_cmdrdy              : STD_ULOGIC;
  SIGNAL cmdrdy_d                    : STD_ULOGIC;
  SIGNAL cmdval_d                    : STD_ULOGIC;
  SIGNAL crd_rdy                     : STD_ULOGIC;
  SIGNAL fifo_rd_d                   : STD_ULOGIC;
  SIGNAL cmd_rw_q                    : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL row_column_bank             : STD_ULOGIC_VECTOR(30 DOWNTO 0);
  SIGNAL cmd_tag_q                   : STD_ULOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL cmd_size_q                  : STD_ULOGIC;
  SIGNAL phy_addr_q                  : STD_ULOGIC_VECTOR(39 DOWNTO 5);
  SIGNAL col                         : STD_ULOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL bg                          : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL bk                          : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL row                         : STD_ULOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL rank                        : STD_ULOGIC;
  SIGNAL data_ctrl_fifo_wr           : STD_ULOGIC;
  SIGNAL data_ctrl_fifo_dat_in       : STD_ULOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL wvalid_q                    : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL wdata_q                     : STD_ULOGIC_VECTOR(511 DOWNTO 0);
  SIGNAL wdata_m_q                   : STD_ULOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL xlate_mmio_data_val_q       : STD_ULOGIC;
  SIGNAL wvalid_d                    : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL data4p1                     : STD_ULOGIC;
  SIGNAL data4p0                     : STD_ULOGIC;
  SIGNAL data_ctrl_fifo_dat_out_val  : STD_ULOGIC;
  SIGNAL data4dram                   : STD_ULOGIC;
  SIGNAL wdata_d                     : STD_ULOGIC_VECTOR(511 DOWNTO 0);
  SIGNAL wdata_m_d                   : STD_ULOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL xlate_mmio_data_val_d       : STD_ULOGIC;
  SIGNAL data4mmio                   : STD_ULOGIC;
  SIGNAL data_ctrl_fifo_dat_out      : STD_ULOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data2beats                  : STD_ULOGIC;
  SIGNAL pause_rd_d                  : STD_ULOGIC;
  SIGNAL pause_rd_q                  : STD_ULOGIC;
  SIGNAL data_ctrl_fifo_rd           : STD_ULOGIC;
--  SIGNAL cmd_mmio_q                  : STD_ULOGIC;
--  SIGNAL intlv0_rd_q                 : STD_ULOGIC;
--  SIGNAL intlv0_wr_q                 : STD_ULOGIC;
--  SIGNAL intlv1_rd_q                 : STD_ULOGIC;
--  SIGNAL intlv1_wr_q                 : STD_ULOGIC;
  SIGNAL reset_drop_d                : STD_ULOGIC;
  SIGNAL rspcmd_valid                : STD_ULOGIC;
  SIGNAL afu_mmio_resp_ack_q         : STD_ULOGIC;
  SIGNAL rspdata_valid               : STD_ULOGIC;
  SIGNAL tlx_resp_credit_d           : STD_ULOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL reset_drop_q                : STD_ULOGIC;
  SIGNAL tlx_resp_credit_q           : STD_ULOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL tlx_data_credit_d           : STD_ULOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL tlx_data_credit_q           : STD_ULOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL yield_mmio_d                : STD_ULOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL yield_mmio_q                : STD_ULOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL yield_d                     : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL yield_q                     : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL afu_mmio_resp_ack_d         : STD_ULOGIC;
  SIGNAL rspwr_valid                 : STD_ULOGIC;
  SIGNAL rsprd_valid                 : STD_ULOGIC;
  SIGNAL rsprdwr_valid               : STD_ULOGIC;
  SIGNAL afu_tlx_resp_valid_q        : STD_ULOGIC;
  SIGNAL afu_tlx_resp_opcode_q       : STD_ULOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL afu_tlx_resp_dl_q           : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL afu_tlx_resp_capptag_q      : STD_ULOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL afu_tlx_resp_dp_q           : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL afu_tlx_resp_code_q         : STD_ULOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL afu_tlx_rdata_valid_q       : STD_ULOGIC;
  SIGNAL afu_tlx_rdata_bus_q         : STD_ULOGIC_VECTOR(517 DOWNTO 0);
  SIGNAL afu_tlx_rdata_bdi_q         : STD_ULOGIC;
  SIGNAL afu_tlx_resp_valid_d        : STD_ULOGIC;
  SIGNAL afu_tlx_resp_opcode_d       : STD_ULOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL afu_tlx_resp_dl_d           : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL afu_tlx_resp_capptag_d      : STD_ULOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL afu_tlx_resp_dp_d           : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL afu_tlx_resp_code_d         : STD_ULOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL afu_tlx_rdata_valid_d       : STD_ULOGIC;
  SIGNAL afu_tlx_rdata_bus_d         : STD_ULOGIC_VECTOR(517 DOWNTO 0);
  SIGNAL afu_tlx_rdata_bdi_d         : STD_ULOGIC;
  signal rsp_conflict_err_d          : STD_ULOGIC;
  signal rsp_crd_err_d               : STD_ULOGIC;
  signal rsp_crd_underflow_d         : STD_ULOGIC;
  signal unexpected_data_err_d       : STD_ULOGIC;
  signal ctrl_err_d                  : STD_ULOGIC;
  signal cmd_crd_err_d               : STD_ULOGIC;
  signal unsupported_cmd_err_d       : STD_ULOGIC;
  signal unsupported_cmd_size_d       : STD_ULOGIC;
  signal rsp_conflict_err_q          : STD_ULOGIC;
  signal rsp_crd_err_q               : STD_ULOGIC;
  signal rsp_crd_underflow_q         : STD_ULOGIC;
  signal unexpected_data_err_q       : STD_ULOGIC;
  signal ctrl_err_q                  : STD_ULOGIC;
  signal cmd_crd_err_q               : STD_ULOGIC;
  signal unsupported_cmd_err_q       : STD_ULOGIC;
  signal unsupported_cmd_size_q       : STD_ULOGIC;

  attribute mark_debug                : string;
  attribute mark_debug of  fifo_rd_q              : signal is "true";
  attribute mark_debug of  intlv0_wr_crd_q        : signal is "true";
  attribute mark_debug of  intlv1_wr_crd_q        : signal is "true";
  attribute mark_debug of  intlv0_rd_crd_q        : signal is "true";
  attribute mark_debug of  intlv1_rd_crd_q        : signal is "true";
  attribute mark_debug of  mmio_crd_q             : signal is "true";
  attribute mark_debug of  cmd_rw_q               : signal is "true";
  attribute mark_debug of  cmd_tag_q              : signal is "true";
  attribute mark_debug of  cmd_size_q             : signal is "true";
  attribute mark_debug of  wvalid_q               : signal is "true";
  attribute mark_debug of  xlate_mmio_data_val_q  : signal is "true";
  attribute mark_debug of  pause_rd_q             : signal is "true";
  attribute mark_debug of  tlx_resp_credit_q      : signal is "true";
  attribute mark_debug of  tlx_data_credit_q      : signal is "true";
  attribute mark_debug of  yield_q                : signal is "true";
  attribute mark_debug of  yield_mmio_q           : signal is "true";
  attribute mark_debug of  afu_mmio_resp_ack_q    : signal is "true";
  attribute mark_debug of  afu_tlx_resp_valid_q   : signal is "true";
  attribute mark_debug of  afu_tlx_resp_opcode_q  : signal is "true";
  attribute mark_debug of  afu_tlx_resp_dl_q      : signal is "true";
  attribute mark_debug of  afu_tlx_resp_capptag_q : signal is "true";
  attribute mark_debug of  afu_tlx_resp_dp_q      : signal is "true";
  attribute mark_debug of  afu_tlx_resp_code_q    : signal is "true";
  attribute mark_debug of  afu_tlx_rdata_valid_q  : signal is "true";
  attribute mark_debug of  afu_tlx_rdata_bus_q  : signal is "true";
  attribute mark_debug of  afu_tlx_rdata_bdi_q  : signal is "true";
  attribute mark_debug of  cmdrdy_q               : signal is "true";
  attribute mark_debug of  cmdval_q               : signal is "true";
  attribute mark_debug of  cmdmmio_q              : signal is "true";
  attribute mark_debug OF  cmd_fifo_dat_out_val   : signal is "true";
  attribute mark_debug OF  data_ctrl_fifo_dat_out_val : signal is "true";
  attribute mark_debug OF  pt                         : signal is "true";
  attribute mark_debug OF  data4dram                  : signal is "true";
  attribute mark_debug OF  data4mmio                  : signal is "true";
  attribute mark_debug OF  data2beats                 : signal is "true";
  attribute mark_debug OF  data4p1                    : signal is "true";
  attribute mark_debug OF  phy_addr_q                 : signal is "true";
  attribute mark_debug OF  wdata_q                    : signal is "true";
  attribute mark_debug OF  wdata_m_q                  : signal is "true";

BEGIN
ice_term(CMD_FIFO_DAT_OUT(63 DOWNTO 55));
ice_term(ROW_COLUMN_BANK(2 DOWNTO 0));
ice_term(I_RSP_META(39 DOWNTO 6));
ice_term(TLX_AFU_READY);
--ice_term(TLX_AFU_CMD_END);
--ice_term(TLX_AFU_CMD_DATA_BDI);
ice_term(MMIO_AFU_RESP_DL);

  afu_mmio_dbg(0)             <= cmdrdy_q;
  afu_mmio_dbg(1)             <= cmdval_q;
  afu_mmio_dbg(2)             <= cmdmmio_q;
  afu_mmio_dbg(3)             <= cmd_fifo_dat_out_val;
  afu_mmio_dbg(4)             <= data_ctrl_fifo_dat_out_val;
  afu_mmio_dbg(6 DOWNTO 5)    <= yield_q(1 DOWNTO 0);
  afu_mmio_dbg(7)             <= or_reduce(intlv0_wr_crd_q(8 DOWNTO 0));
  afu_mmio_dbg(8)             <= or_reduce(intlv1_wr_crd_q(8 DOWNTO 0));
  afu_mmio_dbg(9)             <= or_reduce(intlv0_rd_crd_q(8 DOWNTO 0));
  afu_mmio_dbg(10)            <= or_reduce(intlv1_rd_crd_q(8 DOWNTO 0));
  afu_mmio_dbg(11)            <= or_reduce(mmio_crd_q(2 DOWNTO 0));
  afu_mmio_dbg(12)            <= pt;
  afu_mmio_dbg(13)            <= cmd_size_q;
  afu_mmio_dbg(15 DOWNTO 14)  <= wvalid_q(1 DOWNTO 0);
  afu_mmio_dbg(16)            <= xlate_mmio_data_val_q;
  afu_mmio_dbg(20 DOWNTO 17)  <= data_ctrl_fifo_dat_out(3 DOWNTO 0);
  afu_mmio_dbg(21)            <= or_reduce(tlx_resp_credit_q(5 DOWNTO 0));
  afu_mmio_dbg(22)            <= or_reduce(tlx_data_credit_q(5 DOWNTO 0));
  afu_mmio_dbg(63 DOWNTO 23)  <= (OTHERS => '0');                     

  reset_n_d <= reset_n;
  --TLX to AFU CAPP Command Interface (VC1)

  afu_tlx_cmd_initial_credit(6 DOWNTO 0) <= "0001000";  --8 cmd entries
  afu_tlx_cmd_credit                     <= fifo_rd_q;  --command credit RETURN

  --////////////////////////////////////////////////////////////////////////////////////////
  --=========================================================================================
  --cmd into FIFO
  readcmd_in <= (tlx_afu_cmd_opcode(7 DOWNTO 0) = x"20") OR   -- mem rd
                (tlx_afu_cmd_opcode(7 DOWNTO 0) = x"28");     -- partial memory rd
  writecmd_in <= (tlx_afu_cmd_opcode(7 DOWNTO 0) = x"81") OR  -- mem write
                 (tlx_afu_cmd_opcode(7 DOWNTO 0) = x"86");    -- partial memory write

  partial_op  <= (tlx_afu_cmd_opcode(7 DOWNTO 0) = x"86") or    -- partial memory write
                (tlx_afu_cmd_opcode(7 DOWNTO 0) = x"28");     -- partial memory rd
  mmiocmd_in <= (tlx_afu_cmd_pa(63 DOWNTO 35) = cfg_tlx_mmio_bar0(63 DOWNTO 35)) AND cfg_tlx_memory_space AND partial_op;

  cmd_fifo_dat_in(15 DOWNTO 0)  <= tlx_afu_cmd_capptag(15 DOWNTO 0);               --capi tag
  cmd_fifo_dat_in(50 DOWNTO 16) <= gate(tlx_afu_cmd_pa(39 DOWNTO 5), NOT mmiocmd_in) OR
                                   gate(tlx_afu_cmd_pa(34 DOWNTO 0),     mmiocmd_in);  -- phsyical addr -> Memory (39:5)  MMIO (34:0)
  cmd_fifo_dat_in(51)           <= (tlx_afu_cmd_dl(1 DOWNTO 0) = "10") AND NOT partial_op;            -- 0: 64B or less;  1: 128B
  cmd_fifo_dat_in(53 DOWNTO 52) <= readcmd_in & writecmd_in;
  cmd_fifo_dat_in(54)           <= mmiocmd_in;
  cmd_fifo_dat_in(63 DOWNTO 55) <= (OTHERS => '0');
  cmd_fifo_write                <= tlx_afu_cmd_valid;

  unsupported_cmd_err_d         <= tlx_afu_cmd_valid AND NOT readcmd_in AND NOT writecmd_in;
  unsupported_cmd_size_d        <= tlx_afu_cmd_valid AND NOT mmiocmd_in AND (writecmd_in OR readcmd_in) AND (tlx_afu_cmd_dl(1) XNOR tlx_afu_cmd_dl(0));
  --=========================================================================================


  --////////////////////////////////////////////////////////////////////////////////////////
  --=========================================================================================
  --MC/MMIO interface command flow control

  return_wr0_fc <= i_cmd_fc(0);
  return_wr1_fc <= i_cmd_fc(1);
  --since a cmd credit represents max of 128B, and when a 128B request with two responses, we only want to conside one credit return for two responses 
  return_rd0_fc <= (i_cmd_fc(2) AND NOT i_rsp_size) OR (i_cmd_fc(2) AND i_rsp_size AND i_rsp_offs);
  return_rd1_fc <= (i_cmd_fc(3) AND NOT i_rsp_size) OR (i_cmd_fc(3) AND i_rsp_size AND i_rsp_offs);

  intlv0_wr_crd_d(8 DOWNTO 0) <= gate("100000000", NOT reset_n) OR
                                 gate(intlv0_wr_crd_q(8 DOWNTO 0) + 1, reset_n AND     return_wr0_fc AND NOT use_wr0_fc) OR
                                 gate(intlv0_wr_crd_q(8 DOWNTO 0) - 1, reset_n AND NOT return_wr0_fc AND     use_wr0_fc) OR
                                 gate(intlv0_wr_crd_q(8 DOWNTO 0),     reset_n AND    (return_wr0_fc XNOR    use_wr0_fc));
  intlv1_wr_crd_d(8 DOWNTO 0) <= gate("100000000", NOT reset_n_q) OR
                                 gate(intlv1_wr_crd_q(8 DOWNTO 0) + 1, reset_n AND     return_wr1_fc AND NOT use_wr1_fc) OR
                                 gate(intlv1_wr_crd_q(8 DOWNTO 0) - 1, reset_n AND NOT return_wr1_fc AND     use_wr1_fc) OR
                                 gate(intlv1_wr_crd_q(8 DOWNTO 0),     reset_n AND    (return_wr1_fc XNOR    use_wr1_fc));
  intlv0_rd_crd_d(8 DOWNTO 0) <= gate("100000000", NOT reset_n_q) OR
                                 gate(intlv0_rd_crd_q(8 DOWNTO 0) + 1, reset_n AND     return_rd0_fc AND NOT use_rd0_fc) OR
                                 gate(intlv0_rd_crd_q(8 DOWNTO 0) - 1, reset_n AND NOT return_rd0_fc AND     use_rd0_fc) OR
                                 gate(intlv0_rd_crd_q(8 DOWNTO 0),     reset_n AND    (return_rd0_fc XNOR    use_rd0_fc));
  intlv1_rd_crd_d(8 DOWNTO 0) <= gate("100000000", NOT reset_n_q) OR
                                 gate(intlv1_rd_crd_q(8 DOWNTO 0) + 1, reset_n AND     return_rd1_fc AND NOT use_rd1_fc) OR
                                 gate(intlv1_rd_crd_q(8 DOWNTO 0) - 1, reset_n AND NOT return_rd1_fc AND     use_rd1_fc) OR
                                 gate(intlv1_rd_crd_q(8 DOWNTO 0),     reset_n AND    (return_rd1_fc XNOR    use_rd1_fc));

  mmio_crd_d(2 DOWNTO 0) <= gate("100", NOT reset_n) OR
                            gate(mmio_crd_q(2 DOWNTO 0) + 1, reset_n AND     mmio_xlate_fc AND NOT use_mmio_fc) OR
                            gate(mmio_crd_q(2 DOWNTO 0) - 1, reset_n AND NOT mmio_xlate_fc AND     use_mmio_fc) OR
                            gate(mmio_crd_q(2 DOWNTO 0),     reset_n AND    (mmio_xlate_fc XNOR    use_mmio_fc));

  cmd_crd_err_d <= (intlv0_wr_crd_q(8) AND intlv0_wr_crd_q(0)) OR 
                   (intlv1_wr_crd_q(8) AND intlv1_wr_crd_q(0)) OR 
                   (intlv0_rd_crd_q(8) AND intlv0_rd_crd_q(0)) OR 
                   (intlv1_rd_crd_q(8) AND intlv1_rd_crd_q(0)) OR 
                   (mmio_crd_q(2) AND mmio_crd_q(0));

  --=========================================================================================


  --////////////////////////////////////////////////////////////////////////////////////////
  --=========================================================================================
  --cmd interface
  mmiocmd_out  <= cmd_fifo_dat_out(54);
  writecmd_out <= (cmd_fifo_dat_out(53 DOWNTO 52) = "01");  --53:R  52:W
  readcmd_out  <= (cmd_fifo_dat_out(53 DOWNTO 52) = "10");
  intlv0_wr    <= NOT mmiocmd_out AND NOT pt_out AND writecmd_out;
  intlv1_wr    <= NOT mmiocmd_out AND     pt_out AND writecmd_out;
  intlv0_rd    <= NOT mmiocmd_out AND NOT pt_out AND readcmd_out;
  intlv1_rd    <= NOT mmiocmd_out AND     pt_out AND readcmd_out;

  --indicates which credit we are going to use
  use_wr0_fc   <= cmd_fifo_dat_out_val AND (intlv0_wr   AND or_reduce(intlv0_wr_crd_q(8 DOWNTO 0)));       -- port0 write and credit
  use_wr1_fc   <= cmd_fifo_dat_out_val AND (intlv1_wr   AND or_reduce(intlv1_wr_crd_q(8 DOWNTO 0)));       -- port1 write and credit
  use_rd0_fc   <= cmd_fifo_dat_out_val AND (intlv0_rd   AND or_reduce(intlv0_rd_crd_q(8 DOWNTO 0)));       -- port0 read  and credit
  use_rd1_fc   <= cmd_fifo_dat_out_val AND (intlv1_rd   AND or_reduce(intlv1_rd_crd_q(8 DOWNTO 0)));        -- port1 read  and credit
  use_mmio_fc  <= cmd_fifo_dat_out_val AND (mmiocmd_out AND or_reduce(mmio_crd_q(2 DOWNTO 0)));           -- MMIO credit

--  intlv0_wr_d <= intlv0_wr;
--  intlv1_wr_d <= intlv1_wr;
--  intlv0_rd_d <= intlv0_rd;
--  intlv1_rd_d <= intlv1_rd;

  cmd_rw_d(1 DOWNTO 0)    <= cmd_fifo_dat_out(53 DOWNTO 52);
  cmd_tag_d(15 DOWNTO 0)  <= cmd_fifo_dat_out(15 DOWNTO 0);
  phy_addr_d(39 DOWNTO 5) <= cmd_fifo_dat_out(50 DOWNTO 16);
  cmd_size_d              <= cmd_fifo_dat_out(51);
  --cmd_mmio_d              <= cmd_fifo_dat_out(54);



  cmdrdy_cmdval <= cmdrdy_q AND cmd_fifo_dat_out_val AND cmd_crd_rdy;

  cmdrdy_cmdmmio <= cmdrdy_q AND cmd_fifo_dat_out_val AND mmio_crd_rdy;

  cmdval_cmdrdy <= cmdval_q AND (NOT cmd_fifo_dat_out_val OR mmio_crd_nrdy or cmd_crd_nrdy);

  cmdval_cmdmmio <= cmdval_q AND cmd_fifo_dat_out_val AND mmio_crd_rdy;

  cmdmmio_cmdval <= cmdmmio_q AND cmd_fifo_dat_out_val AND cmd_crd_rdy;

  cmdmmio_cmdrdy <= cmdmmio_q AND (NOT cmd_fifo_dat_out_val OR mmio_crd_nrdy or cmd_crd_nrdy);

  cmdrdy_d  <= (cmdrdy_q AND NOT cmdrdy_cmdval AND NOT cmdrdy_cmdmmio) OR cmdval_cmdrdy OR cmdmmio_cmdrdy;
  cmdval_d  <= (cmdval_q AND NOT cmdval_cmdrdy AND NOT cmdval_cmdmmio) OR cmdrdy_cmdval OR cmdmmio_cmdval;
  cmdmmio_d <= (cmdmmio_q AND NOT cmdmmio_cmdrdy AND NOT cmdmmio_cmdval) OR cmdrdy_cmdmmio OR cmdval_cmdmmio;

  --mmio and cmd is mutually exclusive
  mmio_crd_rdy  <= (mmiocmd_out AND or_reduce(mmio_crd_q(2 DOWNTO 0)));           -- MMIO credit
  mmio_crd_nrdy <= (mmiocmd_out AND NOT or_reduce(mmio_crd_q(2 DOWNTO 0)));       -- No MMIO credit
  cmd_crd_rdy <= ((intlv0_wr AND or_reduce(intlv0_wr_crd_q(8 DOWNTO 0))) OR       -- port0 write and credit
                  (intlv1_wr AND or_reduce(intlv1_wr_crd_q(8 DOWNTO 0))) OR       -- port1 write and credit
                  (intlv0_rd AND or_reduce(intlv0_rd_crd_q(8 DOWNTO 0))) OR       -- port0 read  and credit
                  (intlv1_rd AND or_reduce(intlv1_rd_crd_q(8 DOWNTO 0))));        -- port1 read  and credit
  cmd_crd_nrdy <= ((intlv0_wr AND NOT or_reduce(intlv0_wr_crd_q(8 DOWNTO 0))) OR  -- port0 write and no credit
                   (intlv1_wr AND NOT or_reduce(intlv1_wr_crd_q(8 DOWNTO 0))) OR  -- port1 write and no credit
                   (intlv0_rd AND NOT or_reduce(intlv0_rd_crd_q(8 DOWNTO 0))) OR  -- port0 read  and no credit
                   (intlv1_rd AND NOT or_reduce(intlv1_rd_crd_q(8 DOWNTO 0))));   -- port1 read  and no credit
  crd_rdy <= mmio_crd_rdy OR cmd_crd_rdy;

  fifo_rd     <= cmd_fifo_dat_out_val AND crd_rdy;
  fifo_rd_d   <= fifo_rd;
  cmd_fifo_rd <= fifo_rd;

  o_cmd_valid <= cmdval_q;
  o_cmd_rw    <= cmd_rw_q(0);  --: OUT std_ulogic;  --0:R  1:W
  o_cmd_addr  <= pt & row_column_bank(30 DOWNTO 3);  -- STD_ULOGIC_VECTOR(31 DOWNTO 3);  
  o_cmd_tag   <= cmd_tag_q(15 DOWNTO 0);             --: OUT STD_ULOGIC_VECTOR(15 DOWNTO 0);
  o_cmd_size  <= cmd_size_q;                         --: OUT STD_ULOGIC;

  xlate_mmio_cmd_val  <= cmdmmio_q;
  xlate_mmio_cmd_addr <= phy_addr_q(39 DOWNTO 5);  -- out    std_ulogic_vector(34 downto 0);
  xlate_mmio_cmd_rd   <= cmd_rw_q(1);              --: out    std_ulogic;
  xlate_mmio_cmd_tag  <= cmd_tag_q(15 DOWNTO 0);   --: out    std_ulogic_vector(15 downto 0);
  -- -----------------------------------

  ctrl_err_d <= NOT onlyone(cmdrdy_q & cmdval_q & cmdmmio_q);
  --=========================================================================================




  --////////////////////////////////////////////////////////////////////////////////////////
  --=========================================================================================
  --Addr xlate
-- switch BG each 64B
  col(2 DOWNTO 0)  <= "000";            -- bit5 not being used since MC doesn't do BL8 reorder
  bg(0)            <= phy_addr_q(6);    --this is 64B bit
  pt               <= phy_addr_q(7);    --128B bit
  pt_out           <= phy_addr_d(7);    --128B bit,use this version to determine which credit to use
  bg(1)            <= phy_addr_q(8);
  bk(1 DOWNTO 0)   <= phy_addr_q(10 DOWNTO 9);
  col(3)           <= phy_addr_q(11); 
  col(7 DOWNTO 4)  <= phy_addr_q(15 DOWNTO 12);
  row(14 DOWNTO 0) <= phy_addr_q(30 DOWNTO 16);
  col(9 DOWNTO 8)  <= phy_addr_q(32 DOWNTO 31);
  row(15)          <= phy_addr_q(33);
  rank             <= phy_addr_q(34);   --bit35 and up not currently used in DRAM cmd

  --Row Column Bank MC memory address map
  row_column_bank(30)           <= rank;
  row_column_bank(29 DOWNTO 14) <= row(15 DOWNTO 0);
  row_column_bank(13 DOWNTO 7)  <= col(9 DOWNTO 3);
  row_column_bank(6 DOWNTO 5)   <= bk(1 DOWNTO 0);
  row_column_bank(4 DOWNTO 3)   <= bg(1 DOWNTO 0);
  row_column_bank(2 DOWNTO 0)   <= col(2 DOWNTO 0);
  --=========================================================================================

  --////////////////////////////////////////////////////////////////////////////////////////
  --=========================================================================================
  --Data interface
  --issue data request same cycle as sending cmd to UI interface
  afu_tlx_cmd_rd_req             <= (cmdval_q OR cmdmmio_q) AND cmd_rw_q(0);  --: OUT   STD_ULOGIC;
  afu_tlx_cmd_rd_cnt(2 DOWNTO 0) <= '0'& cmd_size_q & (NOT cmd_size_q);       --    : OUT   STD_ULOGIC_VECTOR(2 DOWNTO 0); "001"->64B; "010"->128B

  --store the write parm into write control buffer
  data_ctrl_fifo_wr                 <= (cmdval_q OR cmdmmio_q) AND cmd_rw_q(0);  --only write cmd
  data_ctrl_fifo_dat_in(3 DOWNTO 0) <= cmdval_q & cmdmmio_q & cmd_size_q & pt;

  o_wvalid  <= wvalid_q(1 DOWNTO 0);                          --                       : OUT STD_ULOGIC_VECTOR(1 DOWNTO 0);
  o_wdata   <= wdata_q(511 DOWNTO 0);                         --                          : OUT STD_ULOGIC_VECTOR(511 DOWNTO 0);
  o_wmeta   <= (39 DOWNTO 6 => '0') & wdata_m_q(5 DOWNTO 0);  --                       : OUT STD_ULOGIC_VECTOR(31 DOWNTO 0);

  xlate_mmio_data     <= wdata_q(511 DOWNTO 0);  --   : out    std_ulogic_vector(511 downto 0);
  xlate_mmio_data_val <= xlate_mmio_data_val_q;  --   : out    std_ulogic;

  --using parm from data contorl buffer to steer data to UI interface
  wvalid_d(1 DOWNTO 0)  <= gate(data4p1 & data4p0, data_ctrl_fifo_dat_out_val AND tlx_afu_cmd_data_valid AND data4dram);
  wdata_d(511 DOWNTO 0) <= tlx_afu_cmd_data_bus(511 DOWNTO 0);
  wdata_m_d(5 DOWNTO 0) <= tlx_afu_cmd_data_bus(517 DOWNTO 512);

  --using parm from data contorl buffer to steer data to  MMIO interface
  xlate_mmio_data_val_d <= data_ctrl_fifo_dat_out_val AND tlx_afu_cmd_data_valid AND data4mmio;

  data4dram  <= data_ctrl_fifo_dat_out(3);
  data4mmio  <= data_ctrl_fifo_dat_out(2);
  data2beats <= data_ctrl_fifo_dat_out(1);
  data4p0    <= NOT data_ctrl_fifo_dat_out(0);
  data4p1    <= data_ctrl_fifo_dat_out(0);

  --keep write data parm in ctrl buffer for additional cycle for 128B requests
  --only remove after the second beat of data
  pause_rd_d <= data_ctrl_fifo_dat_out_val AND tlx_afu_cmd_data_valid AND data2beats AND NOT pause_rd_q;

  data_ctrl_fifo_rd <= (tlx_afu_cmd_data_valid AND data_ctrl_fifo_dat_out_val AND NOT data2beats) OR  --64B
                       pause_rd_q;                                                                    --128B


  unexpected_data_err_d <= NOT data_ctrl_fifo_dat_out_val AND tlx_afu_cmd_data_valid; 
  --////////////////////////////////////////////////////////////////////////////////////////
  --=========================================================================================
  --resp interface

  --tl credit 
  reset_drop_d <= reset_n_d AND NOT reset_n_q;

  rspcmd_valid                  <= or_reduce(i_cmd_fc(3 DOWNTO 0)) OR afu_mmio_resp_ack_q;
  rspdata_valid                 <= or_reduce(i_cmd_fc(3 DOWNTO 2)) OR (afu_mmio_resp_ack_q AND mmio_afu_rdata_val);

  tlx_resp_credit_d(5 DOWNTO 0) <= gate(tlx_afu_resp_initial_credit(5 DOWNTO 0), reset_drop_q) OR
                                   gate(tlx_resp_credit_q(5 DOWNTO 0) - 1,   NOT reset_drop_q AND     rspcmd_valid AND NOT tlx_afu_resp_credit) OR
                                   gate(tlx_resp_credit_q(5 DOWNTO 0) + 1,   NOT reset_drop_q AND NOT rspcmd_valid AND     tlx_afu_resp_credit) OR
                                   gate(tlx_resp_credit_q(5 DOWNTO 0),       NOT reset_drop_q AND    (rspcmd_valid XNOR    tlx_afu_resp_credit));

  tlx_data_credit_d(5 DOWNTO 0) <= gate(tlx_afu_resp_data_initial_credit(5 DOWNTO 0), reset_drop_q) OR
                                   gate(tlx_data_credit_q(5 DOWNTO 0) - 1,        NOT reset_drop_q AND      rspdata_valid AND NOT tlx_afu_resp_data_credit) OR
                                   gate(tlx_data_credit_q(5 DOWNTO 0) + 1,        NOT reset_drop_q AND NOT  rspdata_valid AND     tlx_afu_resp_data_credit) OR
                                   gate(tlx_data_credit_q(5 DOWNTO 0),            NOT reset_drop_q AND     (rspdata_valid XNOR    tlx_afu_resp_data_credit));

 rsp_crd_err_d <= (tlx_resp_credit_q > tlx_afu_resp_initial_credit) OR (tlx_data_credit_q > tlx_afu_resp_data_initial_credit);
 rsp_crd_underflow_d <= (NOT or_reduce(tlx_resp_credit_q(5 DOWNTO 0)) AND and_reduce(tlx_resp_credit_d(5 DOWNTO 0))) OR 
                        (NOT or_reduce(tlx_data_credit_q(5 DOWNTO 0)) AND and_reduce(tlx_data_credit_d(5 DOWNTO 0)));
  ---------------------------------------------------------------------------------------------------------------------------------------------------------
  --rsp flow control
  ---------------------------------------------------------------------------------------------------------------------------------------------------------
  afu_mmio_resp_ack <= afu_mmio_resp_ack_q;
  --always let mmio rsp go first
  --raise rd yield once see mmio request or no cmd or datacredit
  yield_d(0)               <=    -- at least 3 crds. 1 cyc yield delay + 2
                                ((tlx_resp_credit_q(5 DOWNTO 0) < "000101") AND     rspcmd_valid) OR  -- raise yield if current cycle is using credit and only 4
                                                                                                    -- creddit left
                                ((tlx_resp_credit_q(5 DOWNTO 0) < "000100") AND NOT rspcmd_valid) OR  -- raise yield if current cycle is not using credit and only 3

                                ((tlx_data_credit_q(5 DOWNTO 0) < "000101") AND     rspdata_valid) OR  -- raise yield if current cycle is using data credit and only 4
                                                                                                     -- creddit left
                                ((tlx_data_credit_q(5 DOWNTO 0) < "000100") AND not rspdata_valid) OR  -- raise yield if current cycle is not using data credit and only 3

                                mmio_afu_resp_val; 

  --raise wr yield once see mmio request or no cmd credit
  yield_d(1)               <= 
                                ((tlx_resp_credit_q(5 DOWNTO 0) < "000101") AND     rspcmd_valid) OR  -- raise yield if current cycle is using credit and only 4
                                                                                                    -- creddit left
                                ((tlx_resp_credit_q(5 DOWNTO 0) < "000100") AND NOT rspcmd_valid) OR  -- raise yield if current cycle is not using credit and only 3

                                 mmio_afu_resp_val;  -- at least 3 crds. 1 cyc yield delay + 2
   -- 0,        1,      2,      3,    4
   -- yield_d, yield_q,delay, delay, ready                                                                                                             -- cycles arb delay
  --ack mmio the 3rd cycle after raising yield. this is where no dram response will be returned
  yield_mmio_d(4 DOWNTO 0) <= gate(yield_mmio_q(3 DOWNTO 0) & mmio_afu_resp_val, NOT afu_mmio_resp_ack_q);  --issue MMIO after 3rd cyc to ensure dram resp cmd pipe is clean
  afu_mmio_resp_ack_d <= yield_mmio_d(4) AND mmio_afu_resp_val AND or_reduce(tlx_resp_credit_q(5 DOWNTO 0)) AND (NOT mmio_afu_rdata_val OR or_reduce(tlx_data_credit_q(5 DOWNTO 0)));

  rspwr_valid                         <= or_reduce(i_cmd_fc(1 DOWNTO 0));
  rsprd_valid                         <= or_reduce(i_cmd_fc(3 DOWNTO 2));
  rsprdwr_valid                       <= or_reduce(i_cmd_fc(3 DOWNTO 0));

  o_yield                             <= yield_q;                           --      : out STD_ULOGIC;
  o_arbwt                             <= x"F0";                                --     : out STD_ULOGIC_VECTOR(7 DOWNTO 0);
  afu_tlx_resp_valid                  <= afu_tlx_resp_valid_q;                 --            : OUT STD_ULOGIC;
  afu_tlx_resp_opcode                 <= afu_tlx_resp_opcode_q(7 DOWNTO 0);    --              : OUT STD_ULOGIC_VECTOR(7 DOWNTO 0);
  afu_tlx_resp_dl                     <= afu_tlx_resp_dl_q(1 DOWNTO 0);                                 --                 : OUT STD_ULOGIC_VECTOR(1 DOWNTO 0);
  afu_tlx_resp_capptag                <= afu_tlx_resp_capptag_q(15 DOWNTO 0);  --             : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0);
  afu_tlx_resp_dp                     <= afu_tlx_resp_dp_q(1 DOWNTO 0);        --                  : OUT STD_ULOGIC_VECTOR(1 DOWNTO 0);
  afu_tlx_resp_code                   <= afu_tlx_resp_code_q(3 DOWNTO 0);      --                : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0);

  afu_tlx_rdata_valid                 <= afu_tlx_rdata_valid_q;  --              : OUT STD_ULOGIC;
  afu_tlx_rdata_bus(517 DOWNTO 0)     <= afu_tlx_rdata_bus_q(517 DOWNTO 0);
  afu_tlx_rdata_bdi                   <= afu_tlx_rdata_bdi_q;

  afu_tlx_resp_valid_d                <= rspcmd_valid;
  afu_tlx_resp_dl_d(1 DOWNTO 0)       <= gate("10", rspwr_valid AND i_rsp_size) OR gate("01", NOT rspwr_valid OR NOT i_rsp_size);                                 --                 : OUT STD_ULOGIC_VECTOR(1 DOWNTO 0);
  afu_tlx_resp_opcode_d(7 DOWNTO 0)   <= gate(x"04", rspwr_valid) OR gate(x"01", rsprd_valid) OR gate(mmio_afu_resp_opcode(7 DOWNTO 0), afu_mmio_resp_ack_q);
  afu_tlx_resp_capptag_d(15 DOWNTO 0) <= gate(i_rsp_tag(15 DOWNTO 0), rsprdwr_valid) OR gate(mmio_afu_resp_tag(15 DOWNTO 0), afu_mmio_resp_ack_q);
  afu_tlx_resp_dp_d(1 DOWNTO 0)       <= ('0' & (i_rsp_offs AND rsprd_valid)) OR gate(mmio_afu_resp_dp(1 DOWNTO 0), afu_mmio_resp_ack_q);  --64B
  afu_tlx_resp_code_d(3 DOWNTO 0)     <= gate(mmio_afu_resp_code, afu_mmio_resp_ack_q);


  afu_tlx_rdata_valid_d               <= rsprd_valid OR (afu_mmio_resp_ack_q AND mmio_afu_rdata_val);  --      : OUT STD_ULOGIC;
  afu_tlx_rdata_bus_d(517 DOWNTO 512) <= gate(i_rsp_meta(5 DOWNTO 0),rsprd_valid);                                       --    : OUT STD_ULOGIC_VECTOR(511 DOWNTO 0);
  afu_tlx_rdata_bus_d(511 DOWNTO 0)   <= gate(i_rsp_data(511 DOWNTO 0), rsprd_valid) OR
                                         gate(mmio_afu_rdata_bus(511 DOWNTO 0), afu_mmio_resp_ack_q);
  afu_tlx_rdata_bdi_d                 <= rsprd_valid AND or_reduce(i_rsp_perr(23 DOWNTO 0));

  rsp_conflict_err_d   <= or_reduce(i_cmd_fc(3 DOWNTO 0)) AND afu_mmio_resp_ack_q;
  ---------------------------------------------------------------------------------------------------------------------------------------------------------

  ---------------------------------------------------------------------------------------------------------------------------------------------------------
  --error and debug info
  ---------------------------------------------------------------------------------------------------------------------------------------------------------
  afu_mmio_err(15 DOWNTO 0) <= 
                               Cmd_fifo_err(1 DOWNTO 0) 
                             & data_ctrl_fifo_err(1 DOWNTO 0)
                             & rsp_conflict_err_q
                             & rsp_crd_err_q
                             & unexpected_data_err_q 
                             & ctrl_err_q 
                             & cmd_crd_err_q 
                             & unsupported_cmd_err_q         
                             & rsp_crd_underflow_q         
                             & unsupported_cmd_size_q         
                             & (3 DOWNTO 0 => '0');         

  Cmd_fifo : ENTITY Work.ice_afu_cmd_fifo
    GENERIC MAP (
      Width => 64,                                   -- [Natural]
      Depth => 8)                                   -- [Natural]
    PORT MAP (
      clock                => clock_400mhz,          -- [In  Std_ulogic] Pulse
      reset_n              => reset_n,             -- [In  Std_ulogic] Pulse
      Cmd_fifo_wr          => cmd_fifo_write,        -- [In  Std_ulogic]
      Cmd_fifo_dat_in      => Cmd_fifo_dat_in,       -- [In  Std_ulogic_vector(0 To Width - 1)]
      Cmd_fifo_rd          => Cmd_fifo_rd,           -- [In  Std_ulogic] Pulse;
      Cmd_fifo_dat_out     => Cmd_fifo_dat_out,      -- [Out Std_ulogic_vector(0 To Width - 1)]
      Cmd_fifo_dat_out_val => Cmd_fifo_dat_out_val,  -- [Out Std_ulogic]
      Cmd_fifo_err         => Cmd_fifo_err);         -- [Out Std_ulogic_vector(0 To 1)]

  data_ctrl_fifo : ENTITY Work.ice_afu_cmd_fifo
    GENERIC MAP (
      Width => 4,                                          -- [Natural]
      Depth => 8)                                          -- [Natural]
    PORT MAP (
      clock                => clock_400mhz,                -- [In  Std_ulogic] Pulse
      reset_n              => reset_n,                   -- [In  Std_ulogic] Pulse
      Cmd_fifo_wr          => data_ctrl_fifo_wr,           -- [In  Std_ulogic]
      Cmd_fifo_dat_in      => data_ctrl_fifo_dat_in,       -- [In  Std_ulogic_vector(0 To Width - 1)]
      Cmd_fifo_rd          => data_ctrl_fifo_rd,           -- [In  Std_ulogic] Pulse;
      Cmd_fifo_dat_out     => data_ctrl_fifo_dat_out,      -- [Out Std_ulogic_vector(0 To Width - 1)]
      Cmd_fifo_dat_out_val => data_ctrl_fifo_dat_out_val,  -- [Out Std_ulogic]
      Cmd_fifo_err         => data_ctrl_fifo_err);         -- [Out Std_ulogic_vector(0 To 1)]

  latch : PROCESS
  BEGIN
    WAIT UNTIL clock_400mhz'event AND Clock_400mhz = '1';
    IF reset_n = '0' THEN
      cmdrdy_q  <= '1';                               -- : STD_ULOGIC;
      cmdval_q  <= '0';                               -- : STD_ULOGIC;
      cmdmmio_q <= '0';                               -- : STD_ULOGIC;
    ELSE
      cmdrdy_q  <= cmdrdy_d;                          -- : STD_ULOGIC;
      cmdval_q  <= cmdval_d;                          -- : STD_ULOGIC;
      cmdmmio_q <= cmdmmio_d;                         -- : STD_ULOGIC;
    END IF;
    reset_n_q              <= reset_n_d;
    fifo_rd_q              <= fifo_rd_d;              -- : STD_ULOGIC;
    intlv0_wr_crd_q        <= intlv0_wr_crd_d;        -- : STD_ULOGIC_VECTOR(8 DOWNTO 0);
    intlv1_wr_crd_q        <= intlv1_wr_crd_d;        -- : STD_ULOGIC_VECTOR(8 DOWNTO 0);
    intlv0_rd_crd_q        <= intlv0_rd_crd_d;        -- : STD_ULOGIC_VECTOR(8 DOWNTO 0);
    intlv1_rd_crd_q        <= intlv1_rd_crd_d;        -- : STD_ULOGIC_VECTOR(8 DOWNTO 0);
    mmio_crd_q             <= mmio_crd_d;             -- : STD_ULOGIC_VECTOR(2 DOWNTO 0);
    cmd_rw_q               <= cmd_rw_d;               -- : STD_ULOGIC_VECTOR;
    cmd_tag_q              <= cmd_tag_d;              -- : STD_ULOGIC_VECTOR(15 DOWNTO 0);
    cmd_size_q             <= cmd_size_d;             -- : STD_ULOGIC;
    phy_addr_q             <= phy_addr_d;             -- : STD_ULOGIC_VECTOR;
    wvalid_q               <= wvalid_d;               -- : STD_ULOGIC_VECTOR(1 DOWNTO 0);
    wdata_q                <= wdata_d;                -- : STD_ULOGIC_VECTOR(511 DOWNTO 0);
    wdata_m_q              <= wdata_m_d;              -- : STD_ULOGIC_VECTOR(5 DOWNTO 0);
    xlate_mmio_data_val_q  <= xlate_mmio_data_val_d;  -- : STD_ULOGIC;
    pause_rd_q             <= pause_rd_d;             -- : STD_ULOGIC;
--    cmd_mmio_q             <= cmd_mmio_d;             -- : STD_ULOGIC;
--    intlv0_rd_q            <= intlv0_rd_d;            -- : STD_ULOGIC;
--    intlv0_wr_q            <= intlv0_wr_d;            -- : STD_ULOGIC;
--    intlv1_rd_q            <= intlv1_rd_d;            -- : STD_ULOGIC;
--    intlv1_wr_q            <= intlv1_wr_d;            -- : STD_ULOGIC;
    reset_drop_q           <= reset_drop_d;
    tlx_resp_credit_q      <= tlx_resp_credit_d;
    tlx_data_credit_q      <= tlx_data_credit_d;
    yield_q                <= yield_d;
    yield_mmio_q           <= yield_mmio_d;
    afu_mmio_resp_ack_q    <= afu_mmio_resp_ack_d;
    afu_tlx_resp_valid_q   <= afu_tlx_resp_valid_d;
    afu_tlx_resp_opcode_q  <= afu_tlx_resp_opcode_d;
    afu_tlx_resp_dl_q      <= afu_tlx_resp_dl_d;
    afu_tlx_resp_capptag_q <= afu_tlx_resp_capptag_d;
    afu_tlx_resp_dp_q      <= afu_tlx_resp_dp_d;
    afu_tlx_resp_code_q    <= afu_tlx_resp_code_d;
    afu_tlx_rdata_valid_q  <= afu_tlx_rdata_valid_d;
    afu_tlx_rdata_bus_q    <= afu_tlx_rdata_bus_d;
    afu_tlx_rdata_bdi_q    <= afu_tlx_rdata_bdi_d;
    rsp_conflict_err_q     <= rsp_conflict_err_d;
    rsp_crd_err_q          <= rsp_crd_err_d;
    rsp_crd_underflow_q    <= rsp_crd_underflow_d;
    unexpected_data_err_q  <= unexpected_data_err_d; 
    ctrl_err_q             <= ctrl_err_d; 
    cmd_crd_err_q          <= cmd_crd_err_d; 
    unsupported_cmd_err_q  <= unsupported_cmd_err_d;         
    unsupported_cmd_size_q  <= unsupported_cmd_size_d;         

  END PROCESS;

END ice_afu_main;
