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

ENTITY ice_mmio_mac IS
  
  PORT
    (
      clock_400mhz              : in    std_ulogic;
      reset_n                   : in    std_ulogic;
      ----------------------------------------------------------------------------------------------
      -- interface with cmd_dec / addr_xlate
      ----------------------------------------------------------------------------------------------
      xlate_mmio_cmd_val        : in    std_ulogic;
      mmio_xlate_fc             : out   std_ulogic;
      xlate_mmio_cmd_addr       : in    std_ulogic_vector(34 downto 0);
      xlate_mmio_cmd_rd         : in    std_ulogic;
      xlate_mmio_cmd_tag        : in    std_ulogic_vector(15 downto 0);
      xlate_mmio_data           : in    std_ulogic_vector(511 downto 0);
      xlate_mmio_data_val       : in    std_ulogic;

      ----------------------------------------------------------------------------------------------
      -- interface with interrupt handler
      ----------------------------------------------------------------------------------------------
      mmio_errrpt_intrp_hdl_xstop       : out std_ulogic_vector(63 downto 0);
      mmio_errrpt_intrp_hdl_app         : out std_ulogic_vector(63 downto 0);
      mmio_errrpt_cmd_flag_xstop        : out std_ulogic_vector(3 downto 0);
      mmio_errrpt_cmd_flag_app          : out std_ulogic_vector(3 downto 0);

      ----------------------------------------------------------------------------------------------
      -- interface with vc0 response mux
      ----------------------------------------------------------------------------------------------
      mmio_afu_resp_val         : out   std_ulogic;
      afu_mmio_resp_ack         : in   std_ulogic;
      mmio_afu_resp_opcode      : out   std_ulogic_vector(7 downto 0);
      mmio_afu_resp_tag         : out   std_ulogic_vector(15 downto 0);
      mmio_afu_resp_dl          : out   std_ulogic_vector(1 downto 0);
      mmio_afu_resp_dp          : out   std_ulogic_vector(1 downto 0);
      mmio_afu_resp_code        : out   std_ulogic_vector(3 downto 0);
      mmio_afu_rdata_bus        : out   std_ulogic_vector(511 downto 0);
      mmio_afu_rdata_val        : out   std_ulogic;

      ----------------------------------------------------------------------------------------------
      -- error input
      ----------------------------------------------------------------------------------------------
      tlx_mmio_err              : in std_ulogic_vector(31 downto 0):=x"00000000";
      afu_mmio_err              : in std_ulogic_vector(15 downto 0):=x"0000";
      tbd_mmio_err              : in std_ulogic_vector(13 downto 0):="00000000000000";  --left 2 errors for internal
                                                                      --error reporting.

      ----------------------------------------------------------------------------------------------
      -- Error output
      ----------------------------------------------------------------------------------------------
      mmio_errrpt_xstop_err     : out std_ulogic;
      mmio_errrpt_mchk_err      : out std_ulogic;
      
      ----------------------------------------------------------------------------------------------
      -- debug input
      ----------------------------------------------------------------------------------------------
      tlx_mmio_dbg            : in std_ulogic_vector(63 downto 0):=x"0000000000000000";
      afu_mmio_dbg            : in std_ulogic_vector(63 downto 0):=x"0000000000000000";
      tbd_mmio_dbg            : in std_ulogic_vector(63 downto 0):=x"0000000000000000";
      mc_mmio_dbg             : in std_ulogic_vector(63 downto 0);
      err_rpt_dbg             : in std_ulogic_vector(3 downto 0);
      tlx_mmio_xmt_dbg        : in std_ulogic_vector(63 downto 0);
      ui_mmio_err_dbg            : in std_ulogic_vector(63 downto 0):=x"0000000000000000";
      dbg_spare_in             : in std_ulogic_vector(63 downto 0):=x"0000000000000000";
      

      
      force_recal                 : OUT STD_ULOGIC;
      auto_recal_disable          : out  STD_ULOGIC;
      mem_init_start              : out STD_ULOGIC;
      mem_init_zero               : out STD_ULOGIC;
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
      ----------------------------------------------------------------------------------------------
      -- Rgister output to Pervasive (I2C) 
      ----------------------------------------------------------------------------------------------
      ice_perv_lem0             : out std_ulogic_vector(63 downto 0);
      ice_perv_trap0             : out std_ulogic_vector(63 downto 0);
      ice_perv_trap1             : out std_ulogic_vector(63 downto 0);
      ice_perv_trap2             : out std_ulogic_vector(63 downto 0);
      ice_perv_trap3             : out std_ulogic_vector(63 downto 0);
      ice_perv_trap4             : out std_ulogic_vector(63 downto 0);
      ice_perv_ecid              : out std_ulogic_vector(63 downto 0);
      perv_mmio_pulse           : in std_ulogic
      
      
      );
end ice_mmio_mac;

architecture ice_mmio_mac of ice_mmio_mac is

--------------------------------------------------------------------------------------------------
-- latches for all inputs and outputs

signal mmio_afu_resp_val_d : std_ulogic;
signal mmio_afu_resp_val_q : std_ulogic;
signal mmio_afu_resp_tag_d : std_ulogic_vector(15 downto 0);
signal mmio_afu_resp_tag_q : std_ulogic_vector(15 downto 0);
signal mmio_afu_resp_opcode_d : std_ulogic_vector(7 downto 0);
signal mmio_afu_resp_opcode_q : std_ulogic_vector(7 downto 0);
signal mmio_afu_resp_dl_d : std_ulogic_vector(1 downto 0);
signal mmio_afu_resp_dl_q : std_ulogic_vector(1 downto 0);
signal mmio_afu_resp_dp_q : std_ulogic_vector(1 downto 0);
signal mmio_afu_resp_dp_d : std_ulogic_vector(1 downto 0);
signal mmio_afu_resp_code_d : std_ulogic_vector(3 downto 0);
signal mmio_afu_resp_code_q : std_ulogic_vector(3 downto 0);
signal mmio_afu_rdata_val_d : std_ulogic;
signal mmio_afu_rdata_val_q : std_ulogic;
signal mmio_afu_rdata_d : std_ulogic_vector(511 downto 0);
signal mmio_afu_rdata_q : std_ulogic_vector(511 downto 0);
----------------------------------------------------------------------------------------------------

signal reset : std_ulogic;
signal cmd_data_in : std_ulogic_vector(51 downto 0);
signal cmd_push : std_ulogic;
signal cmd_pop : std_ulogic;
signal cmd_fifo_empty : std_ulogic;
signal cmd_overflow : std_ulogic;
signal cmd_underflow : std_ulogic;
signal cmd_data_out : std_ulogic_vector(51 downto 0);
signal cmd_fifo_full : std_ulogic;

signal cdata_in        : std_ulogic_vector(511 downto 0);
signal cdata_push      : std_ulogic;
signal cdata_pop       : std_ulogic;
signal cdata_out       : std_ulogic_vector(511 downto 0);
signal cdata_empty     : std_ulogic;
signal cdata_full      : std_ulogic;
signal cdata_overflow  : std_ulogic;
signal cdata_underflow : std_ulogic;
  
signal cmd_in_prog_d : std_ulogic;
signal cmd_in_prog_q : std_ulogic;
signal cmd_addr_offset_d : std_ulogic_vector(5 downto 0);  --offset in 64B data flit
signal cmd_addr_offset_q : std_ulogic_vector(5 downto 0);  -- offset in 64B data flit
signal offset : std_ulogic_vector(5 downto 0);
signal offset_0  : std_ulogic;
signal offset_8  : std_ulogic;
signal offset_16 : std_ulogic;
signal offset_24 : std_ulogic;
signal offset_32 : std_ulogic;
signal offset_40 : std_ulogic;
signal offset_48 : std_ulogic;
signal offset_56 : std_ulogic;
signal wr_pulse_d : std_ulogic;
signal wr_pulse_q : std_ulogic;
signal rd_pulse_d : std_ulogic;
signal rd_pulse_q : std_ulogic;
signal wr_pulse : std_ulogic;
signal rd_pulse : std_ulogic;
signal wr_data_d : std_ulogic_vector(63 downto 0);
signal wr_data_q : STD_ULOGIC_VECTOR(63 downto 0);
signal wr_data_p_d : std_ulogic;
signal wr_data_p_q : std_ulogic;
signal mmio_rdata_pend_q : std_ulogic;
signal mmio_rdata_pend_d : std_ulogic;
signal regs_rdata_val : std_ulogic;

signal tdn           : STD_ULOGIC_VECTOR(63 downto 0);
signal mmio_dbg_d     : STD_ULOGIC_VECTOR(63 downto 0);
signal mmio_dbg_q      : STD_ULOGIC_VECTOR(63 downto 0);
signal sc_addr_d       : STD_ULOGIC_VECTOR(31 downto 0);
signal sc_addr_q       : STD_ULOGIC_VECTOR(31 downto 0);
signal sc_addr_v     : STD_ULOGIC_VECTOR(0 to 31);
signal cfg0_hit      : std_ulogic;
signal cfg1_hit      : std_ulogic;
signal cfg2_hit      : std_ulogic;
signal inthld0_hit   : std_ulogic;
signal inthld1_hit   : std_ulogic;
signal inthld2_hit   : std_ulogic;
signal inthld3_hit   : std_ulogic;
signal lem0_mask_hit : std_ulogic;
signal lem1_mask_hit : std_ulogic;
signal lem2_mask_hit : std_ulogic;
signal lem0_hit      : std_ulogic;
signal lem1_hit      : std_ulogic;
signal lem2_hit      : std_ulogic;
signal trap0_hit     : std_ulogic;
signal trap1_hit     : std_ulogic;
signal trap2_hit     : std_ulogic;
signal trap3_hit     : std_ulogic;
signal trap4_hit     : std_ulogic;
signal trap5_hit     : std_ulogic;
signal trap6_hit     : std_ulogic;
signal trap7_hit     : std_ulogic;
signal trap8_hit     : std_ulogic;
signal no_addr_hit   : std_ulogic;

signal sc_rdata : STD_ULOGIC_VECTOR(0 to 63);
signal intrp_cmdflag_1 : std_ulogic_vector(3 downto 0);
signal intrp_cmdflag_2 : std_ulogic_vector(3 downto 0);
signal intrp_handle_1 : std_ulogic_vector(63 downto 0);
signal intrp_handle_2 : std_ulogic_vector(63 downto 0);

signal perv_mmio_pulse_l1_d : std_ulogic;
signal perv_mmio_pulse_l1_q : std_ulogic;
signal perv_mmio_pulse_l2_d : std_ulogic;
signal perv_mmio_pulse_l2_q : std_ulogic;

signal cdata_pop_d : std_ulogic;
signal cdata_pop_q : std_ulogic;
signal cmd_pop_d : std_ulogic;
signal cmd_pop_q : std_ulogic;
signal ice_errors_d : std_ulogic_vector(0 to 61);
signal ice_errors_q : std_ulogic_vector(0 to 61);

signal trap4_dbg_in : std_ulogic_vector(0 to 63);


----------------------------------------------------------------------------------------------------
-- register addresses
----------------------------------------------------------------------------------------------------
constant resp_dp           : std_ulogic_vector(1 downto 0) := "00";
constant resp_dl           : std_ulogic_vector(1 downto 0) := "01";
constant cfg0_sc_addr      : std_ulogic_vector(0 to 31)    := x"0801240c";
constant cfg1_sc_addr      : std_ulogic_vector(0 to 31)    := x"0801240d";
constant cfg2_sc_addr      : std_ulogic_vector(0 to 31)    := x"0801240e";
constant inthld0_sc_addr   : std_ulogic_vector(0 to 31)    := x"08012410";
constant inthld1_sc_addr   : std_ulogic_vector(0 to 31)    := x"08012411";
constant inthld2_sc_addr   : std_ulogic_vector(0 to 31)    := x"08012412";
constant inthld3_sc_addr   : std_ulogic_vector(0 to 31)    := x"08012413";
constant lem0_mask_sc_addr : std_ulogic_vector(0 to 31)    := x"08012414";
constant lem1_mask_sc_addr : std_ulogic_vector(0 to 31)    := x"08012415";
constant lem2_mask_sc_addr : std_ulogic_vector(0 to 31)    := x"08012416";
constant lem0_sc_addr      : std_ulogic_vector(0 to 31)    := x"0801241c";
constant lem1_sc_addr      : std_ulogic_vector(0 to 31)    := x"0801241d";
constant lem2_sc_addr      : std_ulogic_vector(0 to 31)    := x"0801241e";
constant trap0_sc_addr     : std_ulogic_vector(0 to 31)    := x"08012424";
constant trap1_sc_addr     : std_ulogic_vector(0 to 31)    := x"08012425";
constant trap2_sc_addr     : std_ulogic_vector(0 to 31)    := x"08012426";
constant trap3_sc_addr     : std_ulogic_vector(0 to 31)    := x"08012427";
constant trap4_sc_addr     : std_ulogic_vector(0 to 31)    := x"08012428";
constant trap5_sc_addr     : std_ulogic_vector(0 to 31)    := x"08012429";
constant trap6_sc_addr     : std_ulogic_vector(0 to 31)    := x"0801242a";
constant trap7_sc_addr     : std_ulogic_vector(0 to 31)    := x"0801242b";
constant trap8_sc_addr     : std_ulogic_vector(0 to 31)    := x"0801242c";



--opcodes
constant mem_rd_resp_opcode : std_ulogic_vector(7 downto 0):=x"01";
constant mem_wr_resp_opcode : std_ulogic_vector(7 downto 0):=x"04";
constant mem_wr_resp_fail_opcode : std_ulogic_vector(7 downto 0):=x"05";

attribute mark_debug : string;

attribute mark_debug of sc_addr_v : signal is "true";
attribute mark_debug of wr_pulse  : signal is "true";
attribute mark_debug of rd_pulse  : signal is "true";

begin  -- ice_mmio_mac

  tdn(63 DOWNTO 0 ) <= (OTHERS => '0');
 
  mmio_afu_resp_val           <= mmio_afu_resp_val_q and not mmio_rdata_pend_q;
  mmio_afu_resp_tag           <= mmio_afu_resp_tag_q;
  mmio_afu_resp_opcode        <= mmio_afu_resp_opcode_q;
  mmio_afu_resp_dl            <= mmio_afu_resp_dl_q;
  mmio_afu_resp_dp            <= mmio_afu_resp_dp_q;
  mmio_afu_resp_code          <= mmio_afu_resp_code_q;
  mmio_afu_rdata_val          <= mmio_afu_rdata_val_q;
  mmio_afu_rdata_bus          <= mmio_afu_rdata_q;

----------------------------------------------------------------------------------------------------
-- double latch pulse from pervasive
----------------------------------------------------------------------------------------------------
  perv_mmio_pulse_l1_d <= perv_mmio_pulse;
  perv_mmio_pulse_l2_d <= perv_mmio_pulse_l1_q;

  --------------------------------------------------------------------------------------------------
  -- Command/Data FIFOs
  --------------------------------------------------------------------------------------------------
  

  reset <= not reset_n;

  cmd_push <= xlate_mmio_cmd_val and not cmd_fifo_full;
  cdata_push <= xlate_mmio_data_val and not cdata_full;
  cdata_in <= xlate_mmio_data;
  mmio_xlate_fc <= cmd_pop_q;

  cmd_data_in <= xlate_mmio_cmd_tag & xlate_mmio_cmd_addr & xlate_mmio_cmd_rd;
  cmd_pop <= not cmd_fifo_empty and not cmd_in_prog_q and not (not cmd_data_out(0) and cdata_empty);
  cmd_pop_d <= cmd_pop;
  cdata_pop <= not cdata_empty and cmd_pop and not cmd_data_out(0);
  cdata_pop_d <= cdata_pop;
  mmio_rdata_pend_d <= (not mmio_rdata_pend_q and cdata_pop and cmd_data_out(0)) OR
                       (mmio_rdata_pend_q and not regs_rdata_val);

  cmd_in_prog_d <= (not cmd_in_prog_q and cmd_pop) OR
                   (    cmd_in_prog_q and not afu_mmio_resp_ack);

  --generate read/write pulse for registers
  rd_pulse_d <= cmd_pop and     cmd_data_out(0);
  rd_pulse <= rd_pulse_q;
  wr_pulse <= wr_pulse_q;
                      
  --generate sc_addr_v
  sc_addr_d <= cmd_data_out(35 downto 4);

  cfg0_hit      <= (sc_addr_q(31 downto 0) = cfg0_sc_addr);
  cfg1_hit      <= (sc_addr_q(31 downto 0) = cfg1_sc_addr);
  cfg2_hit      <= (sc_addr_q(31 downto 0) = cfg2_sc_addr);
  inthld0_hit   <= (sc_addr_q(31 downto 0) = inthld0_sc_addr);
  inthld1_hit   <= (sc_addr_q(31 downto 0) = inthld1_sc_addr);
  inthld2_hit   <= (sc_addr_q(31 downto 0) = inthld2_sc_addr);
  inthld3_hit   <= (sc_addr_q(31 downto 0) = inthld3_sc_addr);
  lem0_mask_hit <= (sc_addr_q(31 downto 0) = lem0_mask_sc_addr);
  lem1_mask_hit <= (sc_addr_q(31 downto 0) = lem1_mask_sc_addr);
  lem2_mask_hit <= (sc_addr_q(31 downto 0) = lem2_mask_sc_addr);
  lem0_hit      <= (sc_addr_q(31 downto 0) = lem0_sc_addr);
  lem1_hit      <= (sc_addr_q(31 downto 0) = lem1_sc_addr);
  lem2_hit      <= (sc_addr_q(31 downto 0) = lem2_sc_addr);
  trap0_hit     <= (sc_addr_q(31 downto 0) = trap0_sc_addr);
  trap1_hit     <= (sc_addr_q(31 downto 0) = trap1_sc_addr);
  trap2_hit     <= (sc_addr_q(31 downto 0) = trap2_sc_addr);
  trap3_hit     <= (sc_addr_q(31 downto 0) = trap3_sc_addr);
  trap4_hit     <= (sc_addr_q(31 downto 0) = trap4_sc_addr);
  trap5_hit     <= (sc_addr_q(31 downto 0) = trap5_sc_addr);
  trap6_hit     <= (sc_addr_q(31 downto 0) = trap6_sc_addr);
  trap7_hit     <= (sc_addr_q(31 downto 0) = trap7_sc_addr);
  trap8_hit     <= (sc_addr_q(31 downto 0) = trap8_sc_addr);
  

  no_addr_hit <= (sc_addr_q(31 downto 0) < cfg0_sc_addr) or
                 (sc_addr_q(31 downto 0) > trap8_sc_addr);
 

  sc_addr_v <= (cfg0_hit or no_addr_hit) &
               cfg1_hit &
               cfg2_hit &
               inthld0_hit &
               inthld1_hit &
               inthld2_hit &
               inthld3_hit &
               lem0_mask_hit &
               lem1_mask_hit &
               lem2_mask_hit &
               lem0_hit &
               lem1_hit &
               lem2_hit &
               trap0_hit &
               trap1_hit &
               trap2_hit &
               trap3_hit &
               trap4_hit &
               trap5_hit &
               trap6_hit &
               trap7_hit &
               trap8_hit &
               "0000000000";
                
  

  --Pipe relevant information into the output latches and hold for data/ack
  mmio_afu_resp_val_d    <= (not mmio_afu_resp_val_q and cmd_pop_q) or
                            (    mmio_afu_resp_val_q and not afu_mmio_resp_ack);
  mmio_afu_resp_code_d   <= gate("1110",                not mmio_afu_resp_val_q and not cmd_data_out(0) and     cfg2_hit) OR
                            gate(mmio_afu_resp_code_q,      mmio_afu_resp_val_q);
  
  mmio_afu_resp_opcode_d <= gate(mem_rd_resp_opcode,       not mmio_afu_resp_val_q and     cmd_data_out(0)) OR
                            gate(mem_wr_resp_opcode,       not mmio_afu_resp_val_q and not cmd_data_out(0) and not cfg2_hit) OR
                            gate(mem_wr_resp_fail_opcode,  not mmio_afu_resp_val_q and not cmd_data_out(0) and     cfg2_hit) OR
                            gate(mmio_afu_resp_opcode_q,       mmio_afu_resp_val_q);
  
  mmio_afu_resp_tag_d <= gate(cmd_data_out(51 downto 36),  not mmio_afu_resp_val_q) OR
                         gate(mmio_afu_resp_tag_q,             mmio_afu_resp_val_q);
  mmio_afu_resp_dl_d <= resp_dl;
  mmio_afu_resp_dp_d <= resp_dp;


  offset <= gate(cmd_data_out(6 downto 1), cmd_pop);
  cmd_addr_offset_d <= gate(offset(5 downto 0),         cmd_pop) OR
                       gate(cmd_addr_offset_q,      not cmd_pop);

  offset_0  <= (cmd_addr_offset_q = "000000");
  offset_8  <= (cmd_addr_offset_q = "001000");
  offset_16 <= (cmd_addr_offset_q = "010000");
  offset_24 <= (cmd_addr_offset_q = "011000");
  offset_32 <= (cmd_addr_offset_q = "100000");
  offset_40 <= (cmd_addr_offset_q = "101000");
  offset_48 <= (cmd_addr_offset_q = "110000");
  offset_56 <= (cmd_addr_offset_q = "111000");
  

  mmio_afu_rdata_d(511 downto 0) <= (gate(sc_rdata(0 to 63),   offset_56 and not mmio_afu_rdata_val_q and regs_rdata_val) &
                                     gate(sc_rdata(0 to 63),   offset_48 and not mmio_afu_rdata_val_q and regs_rdata_val) &
                                     gate(sc_rdata(0 to 63),   offset_40 and not mmio_afu_rdata_val_q and regs_rdata_val) &
                                     gate(sc_rdata(0 to 63),   offset_32 and not mmio_afu_rdata_val_q and regs_rdata_val) &
                                     gate(sc_rdata(0 to 63),   offset_24 and not mmio_afu_rdata_val_q and regs_rdata_val) &
                                     gate(sc_rdata(0 to 63),   offset_16 and not mmio_afu_rdata_val_q and regs_rdata_val) &
                                     gate(sc_rdata(0 to 63),   offset_8  and not mmio_afu_rdata_val_q and regs_rdata_val) &
                                     gate(sc_rdata(0 to 63),   offset_0  and not mmio_afu_rdata_val_q and regs_rdata_val)) OR
                                     gate(mmio_afu_rdata_q(511 downto 0),        mmio_afu_rdata_val_q and not afu_mmio_resp_ack);

  mmio_afu_rdata_val_d <= (not mmio_afu_rdata_val_q and regs_rdata_val) OR
                          (    mmio_afu_rdata_val_q and not afu_mmio_resp_ack);



  --pull out write data
  wr_pulse_d <= cmd_pop_q and not cmd_data_out(0) and not cfg2_hit;

  wr_data_d <= gate(cdata_out(511 downto 448), offset_56) OR
               gate(cdata_out(447 downto 384), offset_48) OR
               gate(cdata_out(383 downto 320), offset_40) OR
               gate(cdata_out(319 downto 256), offset_32) OR
               gate(cdata_out(255 downto 192), offset_24) OR
               gate(cdata_out(191 downto 128), offset_16) OR
               gate(cdata_out(127 downto 64), offset_8) OR
               gate(cdata_out(63 downto 0), offset_0);

  wr_data_p_d <= (xor_reduce(cdata_out(511 downto 448)) and offset_56) OR
                 (xor_reduce(cdata_out(447 downto 384)) and offset_48) OR
                 (xor_reduce(cdata_out(383 downto 320)) and offset_40) OR
                 (xor_reduce(cdata_out(319 downto 256)) and offset_32) OR
                 (xor_reduce(cdata_out(255 downto 192)) and offset_24) OR
                 (xor_reduce(cdata_out(191 downto 128)) and offset_16) OR
                 (xor_reduce(cdata_out(127 downto 64))  and offset_8) OR
                 (xor_reduce(cdata_out(63 downto 0))    and offset_0); 
  
  
  cmd_fifo: entity work.ice_mmio_fifo
    generic map (
      width => 52,
      depth => 4)
    port map (
      clock     => clock_400mhz,
      reset     => reset,
      data_in   => cmd_data_in,
      write     => cmd_push,
      read      => cmd_pop_q,
      data_out  => cmd_data_out,
      empty     => cmd_fifo_empty,
      full      => cmd_fifo_full, 
      overflow  => cmd_overflow,
      underflow => cmd_underflow);

  data_fifo: entity work.ice_mmio_fifo
    generic map (
      width => 512,
      depth => 4)
    port map (
      clock     => clock_400mhz,
      reset     => reset,
      data_in   => cdata_in,      
      write     => cdata_push,    
      read      => cdata_pop_q,     
      data_out  => cdata_out,     
      empty     => cdata_empty,   
      full      => cdata_full,     
      overflow  => cdata_overflow,
      underflow => cdata_underflow);


  --------------------------------------------------------------------------------------------------

  ice_errors_d(0 to 61) <= tlx_mmio_err(31 downto 0) &          --61:30
                           afu_mmio_err(15 downto 0) &          
                           tbd_mmio_dbg(13 downto 0);

  mmio_dbg_d <= xlate_mmio_cmd_val &
                xlate_mmio_cmd_rd &
                xlate_mmio_cmd_tag &
                cmd_pop_q &
                cmd_data_out(0) &
                cmd_data_out(51 downto 36) &
                sc_addr_v(0 to 17) &
                cmd_addr_offset_q(5 downto 3) &
                err_rpt_dbg &
                "000";

                

  trap4_dbg_in <= mc_mmio_dbg(63 DOWNTO 0);

  ice_regs: entity work.ice_regs
    port map (
      clock_400mhz    => clock_400mhz,
      force_recal     => force_recal, --            : OUT STD_ULOGIC;
      auto_recal_disable          => auto_recal_disable, --            : OUT STD_ULOGIC;
      mem_init_start              => mem_init_start,    -- [out  STD_ULOGIC]
      mem_init_zero               => mem_init_zero,    -- [out  STD_ULOGIC]
       --EDPL
      reg_04_val      => reg_04_val,  --    : out  STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_04_hwwe     => reg_04_hwwe,  --   : in STD_ULOGIC;
      reg_04_update   => reg_04_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_05_hwwe     => reg_05_hwwe,  --   : in STD_ULOGIC;
      reg_05_update   => reg_05_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_06_hwwe     => reg_06_hwwe,  --   : in STD_ULOGIC;
      reg_06_update   => reg_06_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_07_hwwe     => reg_07_hwwe,  --   : in STD_ULOGIC;
      reg_07_update   => reg_07_update,  -- : in STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reset_n         => reset_n,
      rd_pulse        => rd_pulse,
      wr_pulse        => wr_pulse,
      wr_data         => wr_data_q,
      wr_data_p       => wr_data_p_q,
      sc_addr_v       => sc_addr_v,
      sc_rdata        => sc_rdata,
      rdata_val       => regs_rdata_val,
      xstop_err       => mmio_errrpt_xstop_err,
      mchk_out        => mmio_errrpt_mchk_err,
      intrp_cmdflag_0 => mmio_errrpt_cmd_flag_xstop,
      intrp_cmdflag_1 => intrp_cmdflag_1,
      intrp_cmdflag_2 => intrp_cmdflag_2,
      intrp_cmdflag_3 => mmio_errrpt_cmd_flag_app,
      intrp_handle_0  => mmio_errrpt_intrp_hdl_xstop,
      intrp_handle_1  => intrp_handle_1,
      intrp_handle_2  => intrp_handle_2,
      intrp_handle_3  => mmio_errrpt_intrp_hdl_app,
      lem0_out        => ice_perv_lem0,
      trap0_out       => ice_perv_trap0,
      trap1_out       => ice_perv_trap1,
      trap2_out       => ice_perv_trap2,
      trap3_out       => ice_perv_trap3,
      trap4_out       => ice_perv_trap4,
      ecid_out        => ice_perv_ecid,
      perv_clear      => perv_mmio_pulse_l2_q,
      trap0_in        => tlx_mmio_dbg,
      trap1_in        => afu_mmio_dbg,
      trap2_in        => mmio_dbg_q,
      trap3_in        => tlx_mmio_xmt_dbg,
      trap4_in        => trap4_dbg_in,
      trap7_in        => ui_mmio_err_dbg,
      trap8_in        => dbg_spare_in,
      ice_errors      => ice_errors_q);
  
latch : process (clock_400mhz)
  begin
    if clock_400mhz'EVENT and clock_400mhz = '1' then
      if reset_n = '0' then
        mmio_afu_resp_val_q           <= '0';
        mmio_afu_resp_tag_q           <= (others => '0');
        mmio_afu_resp_opcode_q        <= (others => '0');
        mmio_afu_resp_dl_q            <= (others => '0');
        mmio_afu_resp_dp_q            <= (others => '0');
        mmio_afu_resp_code_q          <= (others => '0');
        mmio_afu_rdata_val_q          <= '0';
        wr_data_p_q                   <= '0';
        mmio_afu_rdata_q              <= (others => '0');
        sc_addr_q                     <= (others => '0');
        mmio_rdata_pend_q             <= '0';
        cmd_in_prog_q                 <= '0';
        rd_pulse_q                    <= '0';
        wr_pulse_q                    <= '0';
        cmd_addr_offset_q             <= (others => '0');
        wr_data_q                     <= (others => '0');
        perv_mmio_pulse_l1_q          <= '0';
        perv_mmio_pulse_l2_q          <= '0';
        cdata_pop_q                   <= '0';
        cmd_pop_q                     <= '0';
        mmio_dbg_q                    <= (others => '0');
        ice_errors_q                  <= (others => '0');
        
      else
        mmio_afu_resp_val_q           <= mmio_afu_resp_val_d;
        mmio_afu_resp_tag_q           <= mmio_afu_resp_tag_d;
        mmio_afu_resp_opcode_q        <= mmio_afu_resp_opcode_d;
        mmio_afu_resp_dl_q            <= mmio_afu_resp_dl_d;
        mmio_afu_resp_dp_q            <= mmio_afu_resp_dp_d;
        mmio_afu_resp_code_q          <= mmio_afu_resp_code_d;
        mmio_afu_rdata_val_q          <= mmio_afu_rdata_val_d;
        mmio_afu_rdata_q              <= mmio_afu_rdata_d;
        sc_addr_q                     <= sc_addr_d;
        wr_data_p_q                   <= wr_data_p_d;
        mmio_rdata_pend_q             <= mmio_rdata_pend_d;
        cmd_in_prog_q                 <= cmd_in_prog_d;
        rd_pulse_q                    <= rd_pulse_d;
        wr_pulse_q                    <= wr_pulse_d;
        cmd_addr_offset_q             <= cmd_addr_offset_d;
        wr_data_q                     <= wr_data_d;
        perv_mmio_pulse_l1_q          <= perv_mmio_pulse_l1_d;
        perv_mmio_pulse_l2_q          <= perv_mmio_pulse_l2_d;
        cdata_pop_q                   <= cdata_pop_d;
        cmd_pop_q                     <= cmd_pop_d;
        mmio_dbg_q                    <= mmio_dbg_d;
        ice_errors_q                  <= ice_errors_d;
      end if;
    end if;
  end process;
                                    
      
  

end ice_mmio_mac;
      

    
  
