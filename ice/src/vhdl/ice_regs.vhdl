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
 
 
 

library ieee, work;
Use Ieee.Std_logic_1164.All;
Use Ieee.Numeric_std.All;
Use Ieee.Std_logic_arith.All;
Use Work.Ice_func.All;
use Work.meta_pkg.all; --removed to complete compile


ENTITY ice_regs IS
  PORT (
    clock_400mhz                           : in STD_ULOGIC;
    reset_n                          : in STD_ULOGIC;

    rd_pulse                    : in STD_ULOGIC;
    wr_pulse                    : in STD_ULOGIC;
    wr_data                     : in std_ulogic_vector(0 to 63);
    wr_data_p                   : in STD_ULOGIC;
    sc_addr_v                   : in std_ulogic_vector(0 to 31);
    sc_rdata                    : out std_ulogic_vector(0 to 63);
    rdata_val                   : out STD_ULOGIC;
    force_recal                 : OUT STD_ULOGIC;
    auto_recal_disable          : OUT STD_ULOGIC;
    mem_init_start              : out STD_ULOGIC;
    mem_init_zero              : out STD_ULOGIC;
    xstop_err                  : out std_ulogic;                          -- checkstop   output to Global FIR
    mchk_out                   : out std_ulogic;                   
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

    intrp_cmdflag_0           : out STD_ULOGIC_VECTOR(0 to 3);
    intrp_cmdflag_1           : out STD_ULOGIC_VECTOR(0 to 3);
    intrp_cmdflag_2           : out STD_ULOGIC_VECTOR(0 to 3);
    intrp_cmdflag_3           : out STD_ULOGIC_VECTOR(0 to 3);
    intrp_handle_0            : out STD_ULOGIC_VECTOR(0 to 63);
    intrp_handle_1            : out STD_ULOGIC_VECTOR(0 to 63);
    intrp_handle_2            : out STD_ULOGIC_VECTOR(0 to 63);
    intrp_handle_3            : out STD_ULOGIC_VECTOR(0 to 63);

    ------------------------------------------------------------------------------------------------
    -- register outputs to pervasive
    ------------------------------------------------------------------------------------------------
    lem0_out                        : out STD_ULOGIC_VECTOR(0 to 63);
    trap0_out                       : out STD_ULOGIC_VECTOR(0 to 63);
    trap1_out                       : out STD_ULOGIC_VECTOR(0 to 63);
    trap2_out                       : out STD_ULOGIC_VECTOR(0 to 63);
    trap3_out                       : out STD_ULOGIC_VECTOR(0 to 63);
    trap4_out                       : out STD_ULOGIC_VECTOR(0 to 63);
    ecid_out                        : out STD_ULOGIC_VECTOR(0 to 63);
    

    ------------------------------------------------------------------------------------------------
    -- Hardware updated registers
    ------------------------------------------------------------------------------------------------
    trap0_in                       : in STD_ULOGIC_VECTOR(0 to 63);
    trap1_in                       : in STD_ULOGIC_VECTOR(0 to 63);
    trap2_in                       : in STD_ULOGIC_VECTOR(0 to 63);
    trap3_in                       : in STD_ULOGIC_VECTOR(0 to 63);
    trap4_in                       : in STD_ULOGIC_VECTOR(0 to 63);
    trap7_in                       : in STD_ULOGIC_VECTOR(0 to 63);
    trap8_in                       : in STD_ULOGIC_VECTOR(0 to 63);
    perv_clear                  : in std_ulogic;
    
    ice_errors                  : in std_ulogic_vector(0 to 61)
    );


END ice_regs;

ARCHITECTURE ice_regs OF ice_regs IS

  SIGNAL sc_rdata_d : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL sc_rdata_q : STD_ULOGIC_VECTOR(0 to 63);
  ----------------------------------------------------------------------------------------------------------------------------------------
  SIGNAL trap0_reg_perr : STD_ULOGIC;
  SIGNAL trap1_reg_perr : STD_ULOGIC;
  SIGNAL trap2_reg_perr : STD_ULOGIC;
  SIGNAL trap3_reg_perr : STD_ULOGIC;
  SIGNAL trap4_reg_perr : STD_ULOGIC;
  SIGNAL trap5_reg_perr : STD_ULOGIC;
  SIGNAL trap6_reg_perr : STD_ULOGIC;
  SIGNAL trap7_reg_perr : STD_ULOGIC;
  SIGNAL trap8_reg_perr : STD_ULOGIC;
  SIGNAL cfg_0_reg_perr : STD_ULOGIC;
  SIGNAL cfg_1_reg_perr : STD_ULOGIC;
  SIGNAL cfg_2_reg_perr : STD_ULOGIC;

  SIGNAL inthld_0_reg_perr : STD_ULOGIC;
  SIGNAL inthld_1_reg_perr : STD_ULOGIC;
  SIGNAL inthld_2_reg_perr : STD_ULOGIC;
  SIGNAL inthld_3_reg_perr : STD_ULOGIC;
  SIGNAL inthld_reg_perr   : STD_ULOGIC;

  SIGNAL trap0_input_bus : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap1_input_bus : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap2_input_bus : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap3_input_bus : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap4_input_bus : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap0_update : STD_ULOGIC;
  SIGNAL trap1_update : STD_ULOGIC;
  SIGNAL trap2_update : STD_ULOGIC;
  SIGNAL trap3_update : STD_ULOGIC;
  SIGNAL trap4_update : STD_ULOGIC;
  SIGNAL trap5_input_bus_d : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap6_input_bus_d : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap7_input_bus : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap8_input_bus : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap5_update_d : STD_ULOGIC;
  SIGNAL trap6_update_d : STD_ULOGIC;
  SIGNAL trap5_input_bus_q : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap6_input_bus_q : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap5_update_q : STD_ULOGIC;
  SIGNAL trap6_update_q : STD_ULOGIC;
  SIGNAL trap7_update : STD_ULOGIC;
  SIGNAL trap8_update : STD_ULOGIC;
  SIGNAL clear : STD_ULOGIC;
  SIGNAL trap_update : STD_ULOGIC;


  SIGNAL cfg_0_reg : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL cfg_1_reg : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL cfg_2_reg : STD_ULOGIC_VECTOR(0 to 63);

  SIGNAL inthld_0_reg: STD_ULOGIC_VECTOR(0 TO 63);
  SIGNAL inthld_1_reg: STD_ULOGIC_VECTOR(0 TO 63);
  SIGNAL inthld_2_reg: STD_ULOGIC_VECTOR(0 TO 63);
  SIGNAL inthld_3_reg: STD_ULOGIC_VECTOR(0 TO 63);

  SIGNAL err_stop : STD_ULOGIC;
  SIGNAL hold_acum : STD_ULOGIC;
  SIGNAL err0_mask_perr : STD_ULOGIC;
  SIGNAL err0_acum_perr : STD_ULOGIC;
  SIGNAL err1_mask_perr : STD_ULOGIC;
  SIGNAL err1_acum_perr : STD_ULOGIC;
  SIGNAL err2_mask_perr : STD_ULOGIC;
  SIGNAL err2_acum_perr : STD_ULOGIC;
  SIGNAL err0_mask  : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL err0_acum : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL err1_mask  : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL err1_acum : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL err2_mask  : STD_ULOGIC_VECTOR(0 to 31);
  SIGNAL err2_acum : STD_ULOGIC_VECTOR(0 to 31);
  SIGNAL errtrap0_input_bus : std_ulogic_vector(0 to 63);
  SIGNAL errtrap0_output_bus : std_ulogic_vector(0 to 63);
  SIGNAL errtrap1_input_bus : std_ulogic_vector(0 to 63);
  SIGNAL errtrap1_output_bus : std_ulogic_vector(0 to 63);
  SIGNAL errtrap2_input_bus : std_ulogic_vector(0 to 31);
  SIGNAL errtrap2_output_bus : std_ulogic_vector(0 to 31);

  SIGNAL trap_0_reg : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap_1_reg : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap_2_reg : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap_3_reg : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap_4_reg : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap_5_reg : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap_6_reg : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap_7_reg : STD_ULOGIC_VECTOR(0 to 63);
  SIGNAL trap_8_reg : STD_ULOGIC_VECTOR(0 to 63);

  SIGNAL ctrl_reg_perr : STD_ULOGIC;
  SIGNAL info_reg_perr : STD_ULOGIC;

  signal rd_pulse_d : STD_ULOGIC;
  signal rd_pulse_q : STD_ULOGIC;
  signal inject_xstop : STD_ULOGIC;
  signal inject_mchk : STD_ULOGIC;

  signal lem0_out_d : STD_ULOGIC_VECTOR(0 to 63);
  signal lem0_out_q : STD_ULOGIC_VECTOR(0 to 63);

  signal trap7_in_d : STD_ULOGIC_VECTOR(0 to 63);
  signal trap7_in_q : STD_ULOGIC_VECTOR(0 to 63);

  constant cfg2_reset : std_ulogic_vector(63 downto 0) := FIRE_ICE_META_VERSION&x"106000DC";

  --Add the debug busses to the ILA Trace
  attribute mark_debug : string;
  attribute keep       : string;
 
  attribute mark_debug of trap0_reg_perr : signal is "true";
  attribute mark_debug of trap1_reg_perr : signal is "true";
  attribute mark_debug of trap2_reg_perr : signal is "true";
  attribute mark_debug of trap3_reg_perr : signal is "true";
  attribute mark_debug of trap4_reg_perr : signal is "true";
  attribute mark_debug of err0_mask  :signal is "true";
  attribute mark_debug of lem0_out_q :signal is "true";
  attribute mark_debug of trap_0_reg :signal is "true";
  attribute mark_debug of trap_1_reg :signal is "true";
  attribute mark_debug of trap_2_reg :signal is "true";
  attribute mark_debug of trap_3_reg :signal is "true";
  attribute mark_debug of trap_4_reg :signal is "true";


Begin
  --## figtree_source ice_regs.fig
  --fixme
  -----------------------------------------------------------------------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------
  -- SCOM satellite
  -----------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --00<->03 RW CONFIG REGs
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  -- 00 TLXCFG0 RW  TLX Configuration Register 0
  -- 01 TLXCFG1 RW  TLX Configuration Register 1
  -- 02 TLXCFG2 RW  TLX Configuration Register 2

  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --04<->07 RW TLXT Interrupt Handle
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  -- 04 INTHDL0 RW  TLXT Interrupt Handle Register 0
  -- 05 INTHDL0 RW  TLXT Interrupt Handle Register 1
  -- 06 INTHDL0 RW  TLXT Interrupt Handle Register 2
  -- 07 INTHDL0 RW  TLXT Interrupt Handle Register 3

  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --08<->15 RW  Error  Mask Reg
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  -- 08 TLXERR  RW   TLX Error Mask Reg 0
  -- 09 TLXERR  RW   TLX Error Mask Reg 1
  -- 10 TLXERR  RW   TLX Error Mask Reg 2

  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --16<->23 RO  Error Report REGs
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  -- 16 TLXETR0 ROH TLX Error Report 0
  -- 17 TLXETR0 ROH TLX Error Report 1
  -- 18 TLXETR0 ROH TLX Error Report 1

  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --24<->53 RO  Status/Trap REGs
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  -- 24 TLXTR1  R   TLX Trap Register 0
  -- 25 TLXTR0  R   TLX Trap Register 1

  -- latch scom control/data signals
  --tcm_tlxt_scom_cch_d <= tcm_tlxt_scom_cch;
  --tcm_tlxt_scom_dch_d <= tcm_tlxt_scom_dch;
  --tlxt_tcm_scom_dch_d <= scom_dch_out;
  --tlxt_tcm_scom_cch_d <= scom_cch_out;
  --tlxt_tcm_scom_cch   <= tlxt_tcm_scom_cch_q;
  --tlxt_tcm_scom_dch   <= tlxt_tcm_scom_dch_q;

  --tlx_fir_out <= fir_out_int;



  --sat_id(0 TO 1) <= scom_tlx_sat_id;

  --sc_req_d <= sc_req;


  --rdy_ack <= rdy_q AND sc_req;
  --ack_rdy <= ack_q AND NOT sc_req;

  --rdy_d <= NOT vor(rdy_q & ack_q) OR (rdy_q AND NOT rdy_ack) OR ack_rdy;  --MR_ADD init => "1"

  --ack_d <= (ack_q AND NOT ack_rdy) OR rdy_ack;

  --sc_ack <= ack_q;

  --sc_wr_d <= sc_req AND NOT sc_req_q AND NOT sc_r_nw;
  --sc_wr   <= sc_wr_q;



  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --CFG1 REG
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  clear                   <= cfg_1_reg(0) or perv_clear;
  inject_xstop            <= cfg_1_reg(1);
  inject_mchk             <= cfg_1_reg(2);
  trap_update             <= cfg_1_reg(3);
  hold_acum               <= cfg_1_reg(4);
  force_recal             <= cfg_1_reg(5);
  auto_recal_disable      <= cfg_1_reg(6);
  mem_init_start          <= cfg_1_reg(7);
  mem_init_zero           <= cfg_1_reg(8);
  reg_04_val(31 DOWNTO 0) <= cfg_1_reg(16 TO 47);  -- x04000045
                                                   --31:27  reserved
                                                   --26     EDPL enable (enabled by default)
                                                   --25     EDPL Max Counter Reset 
                                                   --24:16  reserved
                                                   --15:8   EDPL Inject per lane
                                                   --7      reserved
                                                   --6:4    EDPL error threshold
                                                            --3'b000 -->  disabled
                                                            --3'b001 -->  2 errors
                                                            --3'b010 -->  4 errors
                                                            --3'b011 -->  8 errors
                                                            --3'b100 --> 16 errors (default)
                                                            --3'b101 --> 32 errors
                                                            --3'b110 --> 64 errors
                                                            --3'b111 -->128 errors   
                                                   --3:0    EDPL Time window      
                                                            --  4'b0000--> no time window 
                                                            --  4'b0001-->   4 us
                                                            --  4'b0010-->  32 us
                                                            --  4'b0011--> 256 us
                                                            --  4'b0100-->   2 ms
                                                            --  4'b0101-->  16 ms (default)
                                                            --  4'b0110--> 128 ms
                                                            --  4'b0111-->   1  s
                                                            --  4'b1000-->   8  s
                                                            --  4'b1001-->  64  s
                                                            --  4'b1010--> 512  s
                                                            --  4'b1011-->   4 ks
                                                            --  4'b1100-->  32 ks
                                                            --  4'b1101--> 256 ks
                                                            --  4'b1110-->   2 Ms
                                                            --  4'b1111-->  16 Ms

  --tlxc_crd_cfg_reg                     <= (0 TO 9 => '0') & cfg_0_reg(10 TO 63);

  ----------------------------------------------------------------------------------------------------------------------------------------------------------
  --tlxc config reg usage
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --  dcp1_credit_return_pause               <= tlxc_crd_cfg_reg(10);
  --  dcp1_credit_update_val                 <= tlxc_crd_cfg_reg(11);
  --  vc0_credit_return_pause                <= tlxc_crd_cfg_reg(12);
  --  vc0_credit_update_val                  <= tlxc_crd_cfg_reg(13);
  --  vc1_credit_return_pause                <= tlxc_crd_cfg_reg(14);
  --  vc1_credit_update_val                  <= tlxc_crd_cfg_reg(15);
  --  dcp1_credits_init(15 DOWNTO 0)         <= tlxc_crd_cfg_reg(16 TO 31);
  --  vc0_credits_init(15 DOWNTO 0)          <= tlxc_crd_cfg_reg(32 TO 47);
  --  vc1_credits_init(15 DOWNTO 0)          <= tlxc_crd_cfg_reg(48 TO 63);

  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --CFG1 REG
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --tlxt_tlxr_ctrl(0 TO 15) <= cfg_1_reg(0 TO 15);

  --tlxt_dbg_mode(0 TO 15)  <= cfg_1_reg(16 TO 31);

  --tlxc_tlxt_ctrl(0 TO 15) <= cfg_1_reg(32 TO 47);

  intrp_cmdflag_0    <= cfg_1_reg(48 TO 51);
  intrp_cmdflag_1    <= cfg_1_reg(52 TO 55);
  intrp_cmdflag_2    <= cfg_1_reg(56 TO 59);
  intrp_cmdflag_3    <= cfg_1_reg(60 TO 63);

  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --CFG2 REG
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --tlxc_wat_en_reg(0 TO 23) <= cfg_2_reg(0 TO 23);

  --xstop_rd_gate_dis <= cfg_2_reg(24);


  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --TLXT interrupt Handle REG
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  intrp_handle_0 <= inthld_0_reg;
  intrp_handle_1 <= inthld_1_reg;
  intrp_handle_2 <= inthld_2_reg;
  intrp_handle_3 <= inthld_3_reg;

  --------------------------------------------------------------------------------------------------
  -- TRap outputs
  --------------------------------------------------------------------------------------------------
  lem0_out <= lem0_out_q;
  lem0_out_d <= err0_acum;
  trap0_out <= trap_0_reg;
  trap1_out <= trap_1_reg;
  trap2_out <= trap_2_reg;
  trap3_out <= trap_3_reg;
  trap4_out <= trap_4_reg;
  ecid_out <= cfg_2_reg(0 to 63);
  
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --SCOM FIR
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --error_in(0)            <= info_reg_perr;
  --error_in(1)            <= ctrl_reg_perr;
  --error_in(2)            <= tlx_vc0_max_crd_error;
  --error_in(3)            <= tlx_vc1_max_crd_error;
  --error_in(4)            <= tlx_dcp0_max_crd_error;
  --error_in(5)            <= tlx_dcp3_max_crd_error;
  --error_in(6)            <= tlxc_err;
  --error_in(7)            <= tlxc_perr;
  --error_in(8)            <= tlxt_perr;
  --error_in(9)            <= tlxt_rec_err;
  --error_in(10)           <= tlxt_cfg_err;
  --error_in(11)           <= tlxt_unrec_err;
  --error_in(12)           <= tlxt_info_perr;
  --error_in(13  TO 15)    <= (OTHERS => '0');
  --error_in(16)           <= TLXR_Shutdown;
  --error_in(17)           <= TLXR_BAR0_or_MMIO_nf;
  --error_in(18)           <= TLXR_OC_Malformed;
  --error_in(19)           <= TLXR_OC_Protocol_Error;
  --error_in(20)           <= TLXR_Addr_Xlat;
  --error_in(21)           <= TLXR_Metadata_unc_dperr;
  --error_in(22)           <= TLXR_OC_Unsupported;
  --error_in(23)           <= TLXR_OC_Fatal;
  --error_in(24)           <= TLXR_Control_error;
  --error_in(25)           <= TLXR_Internal_Error;
  --error_in(26)           <= TLXR_Informational;
  --error_in(27)           <= TLXR_Trace_Stop;

  

  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --error trap  REG
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  errtrap0_input_bus(0 TO 63) <= ice_errors(0 TO 46)
                               & inject_xstop
                               & ice_errors(48 to 61)
                               & ctrl_reg_perr
                               & info_reg_perr;                          --bit00:43

  errtrap1_input_bus(0 TO 63) <= (others => '0');

  errtrap2_input_bus(0 TO 31) <= (others => '0');
                            --     tlxc_perrors(0 TO 7)                          --bit00:07
                            --   & tlxc_errors(4 TO 9)                           --bit08:13
                            --   & inthld_0_reg_perr                             --bit14:14
                            --   & inthld_1_reg_perr                             --bit15:15
                            --   & inthld_2_reg_perr                             --bit16:16
                            --   & inthld_3_reg_perr                             --bit17:17
                            --   & tlxt_errors(32)                               --bit18:18
                            --   & intrp_req_sm_perr(0 to 3)                        --bit19:22
                            --   & tlxt_perrors(32)                               --bit23:23
                            --   & (24 TO 31 => '0')
                            --;

--  cb_term(tlxc_errors(10 TO 15));       --bit 0 to 3 is tlx credit return overflow; routed to FIR directly


  ctrl_reg_perr   <=  or_reduce(
                              cfg_0_reg_perr
                            & cfg_1_reg_perr
                            & cfg_2_reg_perr
                            & inthld_reg_perr
                            & err0_mask_perr
                            & err1_mask_perr
                            & err2_mask_perr
                            & err0_acum_perr
                            & err1_acum_perr
                            & err2_acum_perr);
  info_reg_perr   <=  or_reduce(
                              trap0_reg_perr
                            & trap1_reg_perr
                            & trap2_reg_perr
                            & trap3_reg_perr
                            & trap4_reg_perr
                            & trap5_reg_perr
                            & trap6_reg_perr
                            & trap7_reg_perr
                            & trap8_reg_perr);


  --TLXR_Shutdown                    <= or_reduce(errtrap0_output_bus(5 to 6));           --   16  58:57
  --TLXR_BAR0_or_MMIO_nf             <= or_reduce(errtrap0_output_bus(7 to 8));           --   17  56:55
  --TLXR_OC_Malformed                <= or_reduce(errtrap0_output_bus(9 to 14));          --   18  54:49
  --TLXR_OC_Protocol_Error           <= or_reduce(errtrap0_output_bus(15 to 20));         --   19  48:43
  --TLXR_Addr_Xlat                   <= or_reduce(errtrap0_output_bus(21 to 25));         --   20  42:38
  --TLXR_Metadata_unc_dperr          <= or_reduce(errtrap0_output_bus(26 to 28));         --   21  37:35
  --TLXR_OC_Unsupported              <= or_reduce(errtrap0_output_bus(29 to 36));         --   22  34:27
  --TLXR_OC_Fatal                    <= or_reduce(errtrap0_output_bus(37 to 39));         --   23  26:24
  --TLXR_Control_error               <= or_reduce(errtrap0_output_bus(40 to 49));         --   24  23:14
  --TLXR_Internal_Error              <= or_reduce(errtrap0_output_bus(50 to 56));         --   25  13:7
  --TLXR_Informational               <= or_reduce(errtrap0_output_bus(57 to 62));         --   26   6:1
  --TLXR_Trace_Stop                  <= errtrap0_output_bus(63);                          --   27   0

  --tlxt_perr                        <=  or_reduce(errtrap1_output_bus(1 TO 21)) OR
  --                                     or_reduce(errtrap1_output_bus(23 to 24)) OR
  --                                     or_reduce(errtrap1_output_bus(26 to 36)) OR
  --                                     or_reduce(errtrap2_output_bus(19 to 22));
  --tlxt_rec_err                     <=  or_reduce(errtrap1_output_bus(37 TO 41));
  --tlxt_cfg_err                     <=  or_reduce(errtrap1_output_bus(42 TO 43)) or errtrap1_output_bus(63);
  --tlxt_unrec_err                   <=  or_reduce(errtrap1_output_bus(44 TO 62)) or errtrap2_output_bus(18);
  --tlxt_info_perr                   <=  errtrap1_output_bus(0) or
  --                                     errtrap1_output_bus(22) or
  --                                     errtrap1_output_bus(25);

  --tlxc_perr                        <=  or_reduce(errtrap2_output_bus(0 TO 7));

  --tlx_vc0_max_crd_error            <= tlxc_errors(0);
  --tlx_vc1_max_crd_error            <= tlxc_errors(1);
  --tlx_dcp0_max_crd_error           <= tlxc_errors(2);
  --tlx_dcp3_max_crd_error           <= tlxc_errors(3);

  --tlxc_err                         <=  or_reduce(errtrap2_output_bus(8 TO 13));
  inthld_reg_perr                  <=  inthld_0_reg_perr or
                                       inthld_1_reg_perr or
                                       inthld_2_reg_perr or
                                       inthld_3_reg_perr;

  err_stop <= or_reduce(err0_acum AND NOT err0_mask) AND NOT hold_acum;

  xstop_err <= or_reduce(errtrap0_output_bus AND NOT err0_mask);-- or inject_xstop;
  
  mchk_out <= inject_mchk;


  --------------------------------------------------------------------------------------------------
  -- EDPL Register Writing Logic
  --------------------------------------------------------------------------------------------------
  trap5_update_d <= reg_04_hwwe or reg_05_hwwe;
  trap5_input_bus_d <= gate(reg_04_update & trap_5_reg(32 to 63),           reg_04_hwwe and not reg_05_hwwe) OR
                       gate(trap_5_reg(0 to 31) & reg_05_update,        not reg_04_hwwe and     reg_05_hwwe) OR
                       gate(reg_04_update & reg_05_update,                  reg_04_hwwe and     reg_05_hwwe);

  trap6_update_d <= reg_06_hwwe or reg_07_hwwe;
  trap6_input_bus_d <= gate(reg_06_update & trap_6_reg(32 to 63),           reg_06_hwwe and not reg_07_hwwe) OR
                       gate(trap_6_reg(0 to 31) & reg_07_update,        not reg_06_hwwe and     reg_07_hwwe) OR
                       gate(reg_06_update & reg_07_update,                  reg_06_hwwe and     reg_07_hwwe);

  --------------------------------------------------------------------------------------------------
  -- latch trap7 (ui error debug) to align with the error pulse which stops the trap update
  --------------------------------------------------------------------------------------------------
  trap7_in_d <= trap7_in;
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  --trap  REG
  -----------------------------------------------------------------------------------------------------------------------------------------------------------
  trap0_input_bus <= trap0_in;
  trap1_input_bus <= trap1_in;
  trap2_input_bus <= trap2_in;
  trap3_input_bus <= trap3_in;
  trap4_input_bus <= trap4_in;
  trap7_input_bus <= trap7_in_q;
  trap8_input_bus <= trap8_in;

  trap0_update  <= NOT or_reduce(err0_acum AND NOT err0_mask) OR trap_update;  --stop on error
  trap1_update  <= NOT or_reduce(err0_acum AND NOT err0_mask) OR trap_update;  --stop on error
  trap2_update  <= NOT or_reduce(err0_acum AND NOT err0_mask) OR trap_update;  --stop on error
  trap3_update  <= NOT or_reduce(err0_acum AND NOT err0_mask) OR trap_update;  --stop on error
  trap4_update  <= '1';                 --MIG Status register
  trap7_update  <=  NOT or_reduce(err0_acum AND NOT err0_mask) OR trap_update; --stop on error
  trap8_update  <=  NOT or_reduce(err0_acum AND NOT err0_mask) OR trap_update; --stop on error
  

  -----------------------------------------------------------------------------------------------------------------------------------------------------------


  sc_rdata_d(0 TO 63) <= gate(cfg_0_reg(0 TO 63),                       (rd_pulse AND sc_addr_v(0))) OR
                         gate(cfg_1_reg(0 TO 63),                       (rd_pulse AND sc_addr_v(1))) OR
                         gate(cfg_2_reg(0 TO 63),                       (rd_pulse AND sc_addr_v(2))) OR
                         gate(inthld_0_reg(0 TO 63),                    (rd_pulse AND sc_addr_v(3))) OR
                         gate(inthld_1_reg(0 TO 63),                    (rd_pulse AND sc_addr_v(4))) OR
                         gate(inthld_2_reg(0 TO 63),                    (rd_pulse AND sc_addr_v(5))) OR
                         gate(inthld_3_reg(0 TO 63),                    (rd_pulse AND sc_addr_v(6))) OR
                         gate(err0_mask(0 TO 63),                       (rd_pulse AND sc_addr_v(7))) OR
                         gate(err1_mask(0 TO 63),                       (rd_pulse AND sc_addr_v(8))) OR
                         gate(err2_mask(0 TO 31) & x"00000000",         (rd_pulse AND sc_addr_v(9))) OR
                         gate(err0_acum(0 TO 63),                       (rd_pulse AND sc_addr_v(10))) OR
                         gate(err1_acum(0 TO 63),                       (rd_pulse AND sc_addr_v(11))) OR
                         gate(err2_acum(0 TO 31) & x"00000000",         (rd_pulse AND sc_addr_v(12))) OR
                         gate(trap_0_reg(0 TO 63),                      (rd_pulse AND sc_addr_v(13))) OR
                         gate(trap_1_reg(0 TO 63),                      (rd_pulse AND sc_addr_v(14))) OR
                         gate(trap_2_reg(0 TO 63),                      (rd_pulse AND sc_addr_v(15))) OR
                         gate(trap_3_reg(0 TO 63),                      (rd_pulse AND sc_addr_v(16))) OR
                         gate(trap_4_reg(0 TO 63),                      (rd_pulse AND sc_addr_v(17))) OR
                         gate(trap_5_reg(0 to 63),                      (rd_pulse and sc_addr_v(18))) OR
                         gate(trap_6_reg(0 TO 63),                      (rd_pulse AND sc_addr_v(19))) OR
                         gate(trap_7_reg(0 to 63),                      (rd_pulse and sc_addr_v(20))) OR
                         gate(trap_8_reg(0 to 63),                      (rd_pulse and sc_addr_v(21)));

  sc_rdata(0 TO 63) <= sc_rdata_q(0 TO 63);

  rd_pulse_d <= rd_pulse;
  rdata_val <= rd_pulse_q;
 

latches:process (clock_400mhz)
  begin
    if clock_400mhz'EVENT and clock_400mhz='1' then
      if reset_n='0' then
        rd_pulse_q <= '0';
        sc_rdata_q <= (others => '0');
        lem0_out_q <= (others => '0');

        trap5_input_bus_q <= (others => '0');
        trap6_input_bus_q <= (others => '0');
        trap5_update_q    <= '0';
        trap6_update_q    <= '0';

        trap7_in_q <= (others => '0');
                             
      else
        rd_pulse_q <= rd_pulse_d;
        sc_rdata_q <= sc_rdata_d;
        lem0_out_q <= lem0_out_d;

        trap5_input_bus_q <= trap5_input_bus_d;
        trap6_input_bus_q <= trap6_input_bus_d;
        trap5_update_q    <= trap5_update_d;
        trap6_update_q    <= trap6_update_d;

        trap7_in_q <= trap7_in_d;
          
      end if;
    end if;
  end process;




        
  --CFG REG
  --Default mmio register to read/write
  cfg0 : ENTITY work.ice_cfg_reg
    GENERIC MAP (
      addr_bit_index  => 0,                    -- [natural] address index of the register
      num_addr_bits => 32,
      reg_reset_value => x"0000000000000000")  -- [std_ulogic_vector(0 to 63)]
    PORT MAP (
      clock_400mhz => clock_400mhz,                            -- [in  std_ulogic]
      reset_n  => reset_n,           -- [in  STD_ULOGIC := '0']
      sc_addr_v  => sc_addr_v,          -- [in  std_ulogic_vector(0 to (num_addr_bits - 1))]
      sc_wdata   => wr_data,           -- [in  std_ulogic_vector(0 to ((reg_width * 8) - 1))] Write data delivered from SCOM satellite for a write request
      sc_wparity => wr_data_p,         -- [in  std_ulogic] Write data parity bit over wr_data
      sc_wr      => wr_pulse,              -- [in  std_ulogic] write pulse
      cfg_reg      => cfg_0_reg(0 TO 63),  -- [out std_ulogic_vector(0 to ((reg_width * 8) - 1))] configuration register output value
      cfg_reg_perr => cfg_0_reg_perr);       -- [out std_ulogic] internal parity error reporting for this register instantiation

  cfg1 : ENTITY work.ice_cfg_reg
    GENERIC MAP (
      addr_bit_index  => 1,                    -- [natural] address index of the register
      num_addr_bits => 32,
      reg_reset_value => x"0000040000450000")  -- [std_ulogic_vector(0 to 63)]
    PORT MAP (
      --CLOCKS
      clock_400mhz => clock_400mhz,                            -- [in  std_ulogic]
      reset_n  => reset_n,           -- [in  STD_ULOGIC := '0']
      sc_addr_v  => sc_addr_v,          -- [in  std_ulogic_vector(0 to (num_addr_bits - 1))]
      sc_wdata   => wr_data,           -- [in  std_ulogic_vector(0 to ((reg_width * 8) - 1))] Write data delivered from SCOM satellite for a write request
      sc_wparity => wr_data_p,         -- [in  std_ulogic] Write data parity bit over wr_data
      sc_wr      => wr_pulse,              -- [in  std_ulogic] write pulse
      cfg_reg      => cfg_1_reg(0 TO 63),  -- [out std_ulogic_vector(0 to ((reg_width * 8) - 1))] configuration register output value
      cfg_reg_perr => cfg_1_reg_perr);       -- [out std_ulogic] internal parity error reporting for this register instantiation

  cfg2 : ENTITY work.ice_cfg_reg
    GENERIC MAP (
      addr_bit_index  => 2,                    -- [natural] address index of the register
      num_addr_bits => 32,
      reg_reset_value => cfg2_reset)  -- [std_ulogic_vector(0 to 63)]
    PORT MAP (
      --CLOCKS
      clock_400mhz => clock_400mhz,                            -- [in  std_ulogic]
      reset_n  => reset_n,           -- [in  STD_ULOGIC := '0']
      sc_addr_v  => sc_addr_v,          -- [in  std_ulogic_vector(0 to (num_addr_bits - 1))]
      sc_wdata   => wr_data,           -- [in  std_ulogic_vector(0 to ((reg_width * 8) - 1))] Write data delivered from SCOM satellite for a write request
      sc_wparity => wr_data_p,         -- [in  std_ulogic] Write data parity bit over wr_data
      sc_wr      => wr_pulse,              -- [in  std_ulogic] write pulse
      cfg_reg      => cfg_2_reg(0 TO 63),  -- [out std_ulogic_vector(0 to ((reg_width * 8) - 1))] configuration register output value
      cfg_reg_perr => cfg_2_reg_perr);       -- [out std_ulogic] internal parity error report


  inthld0 : ENTITY work.ice_cfg_reg
    GENERIC MAP (
      addr_bit_index  => 3,                    -- [natural] address index of the register
      num_addr_bits => 32,
      reg_reset_value => x"0000000000000001")  -- [std_ulogic_vector(0 to 63)]
    PORT MAP (
      --CLOCKS
      clock_400mhz => clock_400mhz,                            -- [in  std_ulogic]
      reset_n  => reset_n,           -- [in  STD_ULOGIC := '0']
      sc_addr_v  => sc_addr_v,          -- [in  std_ulogic_vector(0 to (num_addr_bits - 1))]
      sc_wdata   => wr_data,           -- [in  std_ulogic_vector(0 to ((reg_width * 8) - 1))] Write data delivered from SCOM satellite for a write request
      sc_wparity => wr_data_p,         -- [in  std_ulogic] Write data parity bit over wr_data
      sc_wr      => wr_pulse,              -- [in  std_ulogic] write pulse
      cfg_reg      => inthld_0_reg(0 TO 63),  -- [out std_ulogic_vector(0 to ((reg_width * 8) - 1))] configuration register output value
      cfg_reg_perr => inthld_0_reg_perr);       -- [out std_ulogic] internal parity error report

  inthld1 : ENTITY work.ice_cfg_reg
    GENERIC MAP (
      addr_bit_index  => 4,                    -- [natural] address index of the register
      num_addr_bits => 32,
      reg_reset_value => x"0000000000000002")  -- [std_ulogic_vector(0 to 63)]
    PORT MAP (
      --CLOCKS
      clock_400mhz => clock_400mhz,                            -- [in  std_ulogic]
      reset_n  => reset_n,           -- [in  STD_ULOGIC := '0']
      sc_addr_v  => sc_addr_v,          -- [in  std_ulogic_vector(0 to (num_addr_bits - 1))]
      sc_wdata   => wr_data,           -- [in  std_ulogic_vector(0 to ((reg_width * 8) - 1))] Write data delivered from SCOM satellite for a write request
      sc_wparity => wr_data_p,         -- [in  std_ulogic] Write data parity bit over wr_data
      sc_wr      => wr_pulse,              -- [in  std_ulogic] write pulse
      cfg_reg      => inthld_1_reg(0 TO 63),  -- [out std_ulogic_vector(0 to ((reg_width * 8) - 1))] configuration register output value
      cfg_reg_perr => inthld_1_reg_perr);       -- [out std_ulogic] internal parity error report

   inthld2 : ENTITY work.ice_cfg_reg
    GENERIC MAP (
      addr_bit_index  => 5,                    -- [natural] address index of the register
      num_addr_bits => 32,
      reg_reset_value => x"0000000000000003")  -- [std_ulogic_vector(0 to 63)]
    PORT MAP (
      --CLOCKS
      clock_400mhz => clock_400mhz,                            -- [in  std_ulogic]
      reset_n  => reset_n,           -- [in  STD_ULOGIC := '0']
      sc_addr_v  => sc_addr_v,          -- [in  std_ulogic_vector(0 to (num_addr_bits - 1))]
      sc_wdata   => wr_data,           -- [in  std_ulogic_vector(0 to ((reg_width * 8) - 1))] Write data delivered from SCOM satellite for a write request
      sc_wparity => wr_data_p,         -- [in  std_ulogic] Write data parity bit over wr_data
      sc_wr      => wr_pulse,              -- [in  std_ulogic] write pulse
      cfg_reg      => inthld_2_reg(0 TO 63),  -- [out std_ulogic_vector(0 to ((reg_width * 8) - 1))] configuration register output value
      cfg_reg_perr => inthld_2_reg_perr);       -- [out std_ulogic] internal parity error report

  inthld3 : ENTITY work.ice_cfg_reg
    GENERIC MAP (
      addr_bit_index  => 6,                    -- [natural] address index of the register
      num_addr_bits => 32,
      reg_reset_value => x"0000000000000004")  -- [std_ulogic_vector(0 to 63)]
    PORT MAP (
      --CLOCKS
      clock_400mhz => clock_400mhz,                            -- [in  std_ulogic]
      reset_n  => reset_n,           -- [in  STD_ULOGIC := '0']
      sc_addr_v  => sc_addr_v,          -- [in  std_ulogic_vector(0 to (num_addr_bits - 1))]
      sc_wdata   => wr_data,           -- [in  std_ulogic_vector(0 to ((reg_width * 8) - 1))] Write data delivered from SCOM satellite for a write request
      sc_wparity => wr_data_p,         -- [in  std_ulogic] Write data parity bit over wr_data
      sc_wr      => wr_pulse,              -- [in  std_ulogic] write pulse
      cfg_reg      => inthld_3_reg(0 TO 63),  -- [out std_ulogic_vector(0 to ((reg_width * 8) - 1))] configuration register output value
      cfg_reg_perr => inthld_3_reg_perr);       -- [out std_ulogic] internal parity error report

  err0 : ENTITY work.ice_err_reg
    GENERIC MAP (
      error_out_latch => true,
      addr_bit_index => 7,              -- [natural] address index of the Mask register
      num_addr_bits => 32)
    PORT MAP (
      clock_400mhz          => clock_400mhz,            -- [in  std_ulogic]
      reset_n         => reset_n,           -- [in  STD_ULOGIC := '0']
      sc_addr_v     => sc_addr_v,       -- [in  std_ulogic_vector(0 to (num_addr_bits - 1))]
      sc_wdata      => wr_data,  -- [in  std_ulogic_vector(0 to ((err_mask_width * 8) - 1))] Write data delivered from SCOM satellite for a write request
      sc_wparity    => wr_data_p,      -- [in  std_ulogic] Write data parity bit over wr_data
      sc_wr         => wr_pulse,           -- [in  std_ulogic] write pulse

      err_mask      => err0_mask,         -- [out std_ulogic_vector(0 to (err_mask_width - 1))] error mask  register output value
      err_mask_perr => err0_mask_perr,    -- [out std_ulogic] internal parity error reporting for this register instantiation

      err_in        => errtrap0_input_bus,           -- [in  std_ulogic_vector(0 to ((err_mask_width) - 1))]
      err_out       => errtrap0_output_bus,          -- [out std_ulogic_vector(0 to ((err_mask_width) - 1))]
      err_acum      => err0_acum,         -- [out std_ulogic_vector(0 to ((err_mask_width) - 1))]
      err_acum_perr => err0_acum_perr,    -- [out std_ulogic] internal parity error reporting for this register instantiation
      stop          => err_stop,                     -- [in  STD_ULOGIC := '0']
      clear         => clear);                   -- [in std_ulogic := '0']

  err1 : ENTITY work.ice_err_reg
    GENERIC MAP (
      addr_bit_index => 8,              -- [natural] address index of the Mask register
      num_addr_bits => 32)
    PORT MAP (
      clock_400mhz          => clock_400mhz,            -- [in  std_ulogic]
      reset_n         => reset_n,           -- [in  STD_ULOGIC := '0']
      sc_addr_v     => sc_addr_v,       -- [in  std_ulogic_vector(0 to (num_addr_bits - 1))]
      sc_wdata      => wr_data,  -- [in  std_ulogic_vector(0 to ((err_mask_width * 8) - 1))] Write data delivered from SCOM satellite for a write request
      sc_wparity    => wr_data_p,      -- [in  std_ulogic] Write data parity bit over wr_data
      sc_wr         => wr_pulse,           -- [in  std_ulogic] write pulse

      err_mask      => err1_mask,         -- [out std_ulogic_vector(0 to (err_mask_width - 1))] error mask  register output value
      err_mask_perr => err1_mask_perr,    -- [out std_ulogic] internal parity error reporting for this register instantiation

      err_in        => errtrap1_input_bus,           -- [in  std_ulogic_vector(0 to ((err_mask_width) - 1))]
      err_out       => errtrap1_output_bus,          -- [out std_ulogic_vector(0 to ((err_mask_width) - 1))]
      err_acum      => err1_acum,         -- [out std_ulogic_vector(0 to ((err_mask_width) - 1))]
      err_acum_perr => err1_acum_perr,    -- [out std_ulogic] internal parity error reporting for this register instantiation
      stop          => err_stop,                     -- [in  STD_ULOGIC := '0']
      clear         => clear);                   -- [in std_ulogic := '0']

  err2 : ENTITY work.ice_err_reg
    GENERIC MAP (
      addr_bit_index => 9,              -- [natural] address index of the Mask register
      num_addr_bits => 32,
      err_mask_width => 32) --                     : natural := 64;    --Width of register in bits
    PORT MAP (
      clock_400mhz          => clock_400mhz,            -- [in  std_ulogic]
      reset_n         => reset_n,           -- [in  STD_ULOGIC := '0']
      sc_addr_v     => sc_addr_v,       -- [in  std_ulogic_vector(0 to (num_addr_bits - 1))]
      sc_wdata      => wr_data,  -- [in  std_ulogic_vector(0 to ((err_mask_width * 8) - 1))] Write data delivered from SCOM satellite for a write request
      sc_wparity    => wr_data_p,      -- [in  std_ulogic] Write data parity bit over wr_data
      sc_wr         => wr_pulse,           -- [in  std_ulogic] write pulse

      err_mask      => err2_mask,         -- [out std_ulogic_vector(0 to (err_mask_width - 1))] error mask  register output value
      err_mask_perr => err2_mask_perr,    -- [out std_ulogic] internal parity error reporting for this register instantiation

      err_in        => errtrap2_input_bus,           -- [in  std_ulogic_vector(0 to ((err_mask_width) - 1))]
      err_out       => errtrap2_output_bus,          -- [out std_ulogic_vector(0 to ((err_mask_width) - 1))]
      err_acum      => err2_acum,         -- [out std_ulogic_vector(0 to ((err_mask_width) - 1))]
      err_acum_perr => err2_acum_perr,    -- [out std_ulogic] internal parity error reporting for this register instantiation
      stop          => err_stop,                     -- [in  STD_ULOGIC := '0']
      clear         => clear);                   -- [in std_ulogic := '0']

  --TRAP REGs
  trap0 : ENTITY work.ice_trap_reg
    PORT MAP (
      clock_400mhz           => clock_400mhz,                     -- [in  std_ulogic]
      reset_n          => reset_n,           -- [in  STD_ULOGIC := '0']
      trap_input_bus => trap0_input_bus,  -- [in  std_ulogic_vector(0 to 63)]
      trap_update    => trap0_update,   -- [in  std_ulogic]
      trap_clear     => clear,          -- [in  std_ulogic]
      trap_reg       => trap_0_reg,      -- [out std_ulogic_vector(0 to 63)] trap register output value
      trap_reg_perr  => trap0_reg_perr);  -- [out std_ulogic] internal parity error reporting for this register instantiation

  trap1 : ENTITY work.ice_trap_reg
    PORT MAP (
      clock_400mhz           => clock_400mhz,                     -- [in  std_ulogic]
      reset_n          => reset_n,           -- [in  STD_ULOGIC := '0']
      trap_input_bus => trap1_input_bus,  -- [in  std_ulogic_vector(0 to 63)]
      trap_update    => trap1_update,   -- [in  std_ulogic]
      trap_clear     => clear,          -- [in  std_ulogic]
      trap_reg       => trap_1_reg,      -- [out std_ulogic_vector(0 to 63)] trap register output value
      trap_reg_perr  => trap1_reg_perr);  -- [out std_ulogic] internal parity error reporting for this register instantiation

  trap2 : ENTITY work.ice_trap_reg
    PORT MAP (
      clock_400mhz           => clock_400mhz,                     -- [in  std_ulogic]
      reset_n          => reset_n,           -- [in  STD_ULOGIC := '0']
      trap_input_bus => trap2_input_bus,  -- [in  std_ulogic_vector(0 to 63)]
      trap_update    => trap2_update,   -- [in  std_ulogic]
      trap_clear     => clear,          -- [in  std_ulogic]
      trap_reg       => trap_2_reg,      -- [out std_ulogic_vector(0 to 63)] trap register output value
      trap_reg_perr  => trap2_reg_perr);  -- [out std_ulogic] internal parity error reporting for this register instantiation

  trap3 : ENTITY work.ice_trap_reg
    PORT MAP (
      clock_400mhz           => clock_400mhz,                     -- [in  std_ulogic]
      reset_n          => reset_n,           -- [in  STD_ULOGIC := '0']
      trap_input_bus => trap3_input_bus,  -- [in  std_ulogic_vector(0 to 63)]
      trap_update    => trap3_update,   -- [in  std_ulogic]
      trap_clear     => clear,          -- [in  std_ulogic]
      trap_reg       => trap_3_reg,      -- [out std_ulogic_vector(0 to 63)] trap register output value
      trap_reg_perr  => trap3_reg_perr);  -- [out std_ulogic] internal parity error reporting for this register instantiation

  trap4 : ENTITY work.ice_trap_reg
    PORT MAP (
      clock_400mhz           => clock_400mhz,                     -- [in  std_ulogic]
      reset_n          => reset_n,           -- [in  STD_ULOGIC := '0']
      trap_input_bus => trap4_input_bus,  -- [in  std_ulogic_vector(0 to 63)]
      trap_update    => trap4_update,   -- [in  std_ulogic]
      trap_clear     => clear,          -- [in  std_ulogic]
      trap_reg       => trap_4_reg,      -- [out std_ulogic_vector(0 to 63)] trap register output value
      trap_reg_perr  => trap4_reg_perr);  -- [out std_ulogic] internal parity error reporting for this register instantiation

  trap5 : ENTITY work.ice_trap_reg
    PORT MAP (
      clock_400mhz           => clock_400mhz,                     -- [in  std_ulogic]
      reset_n          => reset_n,           -- [in  STD_ULOGIC := '0']
      trap_input_bus => trap5_input_bus_q,  -- [in  std_ulogic_vector(0 to 63)]
      trap_update    => trap5_update_q,   -- [in  std_ulogic]
      trap_clear     => clear,          -- [in  std_ulogic]
      trap_reg       => trap_5_reg,      -- [out std_ulogic_vector(0 to 63)] trap register output value
      trap_reg_perr  => trap5_reg_perr);  -- [out std_ulogic] internal parity error reporting for this register instantiation

  trap6 : ENTITY work.ice_trap_reg
    PORT MAP (
      clock_400mhz           => clock_400mhz,                     -- [in  std_ulogic]
      reset_n          => reset_n,           -- [in  STD_ULOGIC := '0']
      trap_input_bus => trap6_input_bus_q,  -- [in  std_ulogic_vector(0 to 63)]
      trap_update    => trap6_update_q,   -- [in  std_ulogic]
      trap_clear     => clear,          -- [in  std_ulogic]
      trap_reg       => trap_6_reg,      -- [out std_ulogic_vector(0 to 63)] trap register output value
      trap_reg_perr  => trap6_reg_perr);  -- [out std_ulogic] internal parity error reporting for this register instantiation

  trap7 : ENTITY work.ice_trap_reg
    PORT MAP (
      clock_400mhz           => clock_400mhz,                     -- [in  std_ulogic]
      reset_n          => reset_n,           -- [in  STD_ULOGIC := '0']
      trap_input_bus => trap7_input_bus,  -- [in  std_ulogic_vector(0 to 63)]
      trap_update    => trap7_update,   -- [in  std_ulogic]
      trap_clear     => clear,          -- [in  std_ulogic]
      trap_reg       => trap_7_reg,      -- [out std_ulogic_vector(0 to 63)] trap register output value
      trap_reg_perr  => trap7_reg_perr);  -- [out std_ulogic] internal parity error reporting for this register instantiation

  trap8 : ENTITY work.ice_trap_reg
    PORT MAP (
      clock_400mhz           => clock_400mhz,                     -- [in  std_ulogic]
      reset_n          => reset_n,           -- [in  STD_ULOGIC := '0']
      trap_input_bus => trap8_input_bus,  -- [in  std_ulogic_vector(0 to 63)]
      trap_update    => trap8_update,   -- [in  std_ulogic]
      trap_clear     => clear,          -- [in  std_ulogic]
      trap_reg       => trap_8_reg,      -- [out std_ulogic_vector(0 to 63)] trap register output value
      trap_reg_perr  => trap8_reg_perr);  -- [out std_ulogic] internal parity error reporting for this register instantiation

END ice_regs;
