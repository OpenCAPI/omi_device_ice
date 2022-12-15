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
 
 
 

library ieee, Work;
Use Ieee.Std_logic_1164.All;
Use Ieee.Numeric_std.All;
Use Ieee.Std_logic_arith.All;
Use Work.Ice_func.All;

entity ice_tlx_rcv is
  PORT (
      dlx_tlx_link_up                   : in std_ulogic;
      dlx_tlx_flit_valid                : in std_ulogic;
      dlx_tlx_flit_crc_err              : in std_ulogic;
      dlx_tlx_flit                      : in std_ulogic_vector(511 downto 0);

      -- -----------------------------------
      -- TLX Parser to AFU Receive Interface
      -- -----------------------------------
      tlx_afu_ready                     : out   std_ulogic;                       -- tied to link_up at the moment
      -- Command interface to AFU
      afu_tlx_cmd_initial_credit        : in    std_ulogic_vector(6 downto 0);
      afu_tlx_cmd_credit                : in    std_ulogic;
      tlx_afu_cmd_valid                 : out   std_ulogic;
      tlx_afu_cmd_opcode                : out   std_ulogic_vector(7 downto 0);
      tlx_afu_cmd_dl                    : out   std_ulogic_vector(1 downto 0);
      tlx_afu_cmd_pa                    : out   std_ulogic_vector(63 downto 0);
      tlx_afu_cmd_capptag               : out   std_ulogic_vector(15 downto 0);
      tlx_afu_cmd_pl                    : out   std_ulogic_vector(2 downto 0);
      tlx_afu_cmd_flag                  : out   std_ulogic_vector(3 downto 0);    -- needed for mem_cntl

      -- Config Command interface to AFU
      cfg_tlx_initial_credit            : in    std_ulogic_vector(3 downto 0);
      cfg_tlx_credit_return             : in    std_ulogic;
      tlx_cfg_valid                     : out   std_ulogic;
      tlx_cfg_opcode                    : out   std_ulogic_vector(7 downto 0);
      tlx_cfg_pa                        : out   std_ulogic_vector(63 downto 0);
      tlx_cfg_t                         : out   std_ulogic;
      tlx_cfg_pl                        : out   std_ulogic_vector(2 downto 0);
      tlx_cfg_capptag                   : out   std_ulogic_vector(15 downto 0);
      tlx_cfg_data_bus                  : out   std_ulogic_vector(31 downto 0);
      tlx_cfg_data_bdi                  : out   std_ulogic;                       -- tied '0'
      -- Response interface to AFU

      afu_tlx_resp_initial_credit       : in    std_ulogic_vector(6 downto 0);
      afu_tlx_resp_credit               : in    std_ulogic;
      tlx_afu_resp_valid                : out   std_ulogic;
      tlx_afu_resp_opcode               : out   std_ulogic_vector(7 downto 0);    -- tied "0C"
      tlx_afu_resp_afutag               : out   std_ulogic_vector(15 downto 0);

      -- Command data interface to AFU
      afu_tlx_cmd_rd_req                : in    std_ulogic;
      afu_tlx_cmd_rd_cnt                : in    std_ulogic_vector(2 downto 0);    -- will only ever be 001 or 010
      tlx_afu_cmd_data_valid            : out   std_ulogic;
      tlx_afu_cmd_data_bus              : out   std_ulogic_vector(517 downto 0);  -- meta is 517:512 data 511:0

      tlx_cfg_in_rcv_tmpl_capability_0  : out   std_ulogic;
      tlx_cfg_in_rcv_tmpl_capability_1  : out   std_ulogic;
      tlx_cfg_in_rcv_tmpl_capability_4  : out   std_ulogic;
      tlx_cfg_in_rcv_tmpl_capability_7  : out   std_ulogic;
      tlx_cfg_in_rcv_tmpl_capability_10 : out   std_ulogic;
      tlx_cfg_in_rcv_rate_capability_0  : out   std_ulogic_vector(3 downto 0);
      tlx_cfg_in_rcv_rate_capability_1  : out   std_ulogic_vector(3 downto 0);
      tlx_cfg_in_rcv_rate_capability_4  : out   std_ulogic_vector(3 downto 0);
      tlx_cfg_in_rcv_rate_capability_7  : out   std_ulogic_vector(3 downto 0);
      tlx_cfg_in_rcv_rate_capability_10 : out   std_ulogic_vector(3 downto 0);

      rcv_xmt_tlx_credit_vc0            : out std_ulogic_vector(3 downto 0);     -- from a return_tlx_credits - 01
      rcv_xmt_tlx_credit_vc3            : out std_ulogic_vector(3 downto 0);     -- (sent from upstream)
      rcv_xmt_tlx_credit_dcp0           : out std_ulogic_vector(5 downto 0);     --
      rcv_xmt_tlx_credit_dcp3           : out std_ulogic_vector(5 downto 0);     -- vc0 and dcp0 for responses and data
      rcv_xmt_tlx_credit_valid          : out std_ulogic;                        -- this need to be from a return_tl_credits   (this comes on when i get an 8)
                                                                                --
      rcv_xmt_tl_credit_vc0_valid       : out std_ulogic;                        -- rcv_xmt_credit_vc0_v in   ocx_tlx_rcv_mac T
      rcv_xmt_tl_credit_vc1_valid       : out std_ulogic;                        -- rcv_xmt_credit_v          ocx_tlx_resp_fifo_mac
      rcv_xmt_tl_credit_dcp0_valid      : out std_ulogic;                        --
      rcv_xmt_tl_credit_dcp1_valid      : out std_ulogic;                        -- presume these should be VC1 for commands and dcp1 for data, coming out of some counters which say how much
      rcv_xmt_tl_crd_cfg_dcp1_valid     : out std_ulogic;

      -- -----------------------------------            `
      -- Miscellaneous Ports
      metadata_enabled                  : in    std_ulogic;
      tlx_mmio_rcv_errors               : out std_ulogic_vector(31 downto 0);
      tlx_mmio_rcv_debug                : out std_ulogic_vector(63 downto 0);
      clock                             : in    std_ulogic;
      reset_n                           : in    std_ulogic
       );
end ice_tlx_rcv;

architecture ice_tlx_rcv of ice_tlx_rcv is
   signal cfg_credits_d,cfg_credits_q                   : std_ulogic_vector(3 downto 0);
   signal cfg_data_available                            : std_ulogic;
   signal cfg_data_empty,cfg_data_overflow              : std_ulogic;
   signal cfg_data_out                                  : std_ulogic_vector(31 downto 0);
   signal cfg_data_read,cfg_data_write                  : std_ulogic;
   signal cfg_data_underflow                            : std_ulogic;
   signal cfg_empty                                     : std_ulogic;
   signal cfg_out,cfg_packet                            : std_ulogic_vector(84 downto 0);
   signal cfg_overflow,cfg_underflow                    : std_ulogic;
   signal cfg_read,cfg_write,cfg_cred_ok                : std_ulogic;
   signal cfg_val_d,dec_cfg_cred                        : std_ulogic;
   signal cfgd_in_32,cfg_data_out_q                     : std_ulogic_vector(31 downto 0);
   signal cfg_data_not_needed                           : std_ulogic;
   signal cflit                                         : std_ulogic_vector(511 downto 0);
   signal cmd_credits_d,cmd_credits_q                   : std_ulogic_vector(6 downto 0);
   signal cmd_data_avail_1,cmd_data_avail_2             : std_ulogic;
   signal cmd_data_empty,cmd_data_full                  : std_ulogic;
   signal cmd_data_not_needed                           : std_ulogic;
   signal cmd_data_out                                  : std_ulogic_vector(517 downto 0);
   signal cmd_data_overflow,cmd_data_underflow          : std_ulogic;
   signal cmd_data_read,cmd_data_write                  : std_ulogic;
   signal cmd_one_data,cmd_two_data                     : std_ulogic;
   signal cmd_out                                       : std_ulogic_vector(111 downto 0);
   signal cmd_overflow,cmd_underflow                    : std_ulogic;
   signal cmd_read,cmd_empty                            : std_ulogic;
   signal cmd_val_d                                     : std_ulogic;
   signal cmd_write                                     : std_ulogic;
   signal cmdd_w_crc_d,cmdd_w_crc_q                     : std_ulogic_vector(5 downto 0);
   signal data_rx                                       : std_ulogic;
   signal dcp_we                                        : std_ulogic;
   signal dec_cmd_cred,cmd_cred_ok,dec_resp_cred        : std_ulogic;
   signal dflit_cnt_d,dflit_cnt_q                       : std_ulogic_vector(3 downto 0);
   signal dl_din                                        : std_ulogic_vector(518 downto 0);
   signal dl_dout                                       : std_ulogic_vector(518 downto 0);
   signal dl_overf,dl_full                              : std_ulogic;
   signal dl_read,dl_empty                              : std_ulogic;
   signal dl_underf                                     : std_ulogic;
   signal dl_valid,dl_write                             : std_ulogic;
   signal ds_din,ds_dout                                : std_ulogic_vector(7 downto 0);
   signal ds_done,ds_overf,ds_underf                    : std_ulogic;
   signal ds_write,ds_empty                             : std_ulogic;
   signal ee_0,ee_14                                    : std_ulogic;       -- early exit
   signal finished_ctl                                  : std_ulogic;
   signal i_count                                       : std_ulogic_vector(5 downto 0);
   signal input_overflow                                : std_ulogic;
   signal last_good_dflit_cnt_d,last_good_dflit_cnt_q   : std_ulogic_vector(3 downto 0);
   signal meta                                          : std_ulogic_vector(5 downto 0);
   signal meta_48_d,meta_48_q,T4_meta                   : std_ulogic_vector(47 downto 0);
   signal meta_mux_q,meta_mux_d                         : std_ulogic_vector(7 downto 0);
   signal onetwentyeightB_d,onetwentyeightB_q           : std_ulogic;
   signal packet_d,packet_q                             : std_ulogic_vector(111 downto 0);
   signal parse_st                                      : std_ulogic_vector(3 downto 0);
   signal parsing_ctl_d,parsing_ctl_q                   : std_ulogic;
   signal reads_requested_d,reads_requested_q           : std_ulogic_vector(5 downto 0);
   signal reset                                         : std_ulogic;
   signal resp_cred_ok,resp_empty,resp_read             : std_ulogic;
   signal resp_credits_d,resp_credits_q                 : std_ulogic_vector(6 downto 0);
   signal resp_underflow                                : std_ulogic;
   signal resp_write,resp_val_q,resp_val_d              : std_ulogic;
   signal ret_vc1,resp_overflow,ret_vc0                 : std_ulogic;
   signal rr_inputs                                     : std_ulogic_vector(2 downto 0);
   signal sd_0,sd_1,sd_4                                : std_ulogic_vector(111 downto 0);
   signal start_ctl                                     : std_ulogic;
   signal tlx_afu_cmd_capptag_d                         : std_ulogic_vector(15 downto 0);
   signal tlx_afu_cmd_dl_d                              : std_ulogic_vector(1 downto 0);
   signal tlx_afu_cmd_flag_d                            : std_ulogic_vector(3 downto 0);
   signal tlx_afu_cmd_opcode_d                          : std_ulogic_vector(7 downto 0);
   signal tlx_afu_cmd_pa_d                              : std_ulogic_vector(63 downto 0);
   signal tlx_afu_cmd_pl_d                              : std_ulogic_vector(2 downto 0);
   signal tlx_cfg_capptag_d                             : std_ulogic_vector(15 downto 0);
   signal tlx_cfg_opcode_d                              : std_ulogic;
   signal tlx_cfg_pa_d                                  : std_ulogic_vector(63 downto 0);
   signal tlx_cfg_pl_d                                  : std_ulogic_vector(2 downto 0);
   signal tlx_cfg_t_d                                   : std_ulogic;
   signal tlx_mmio_rcv_errors_d,tlx_mmio_rcv_errors_q   : std_ulogic_vector(31 downto 0);
   signal unknown_opcode                                : std_ulogic;
   signal vc0_count                                     : std_ulogic_vector(3 downto 0);
   signal vc1_count                                     : std_ulogic_vector(5 downto 0);
   signal vc1_sigs,vc0_sigs                             : std_ulogic_vector(2 downto 0);

--  do we need to include this in ice_tlx_top ?
--  attribute mark_debug : string;
--  attribute mark_debug of  tlx_mmio_rcv_debug : signal is "true"


   begin

      --synopsys translate_off
      assert not (clock'event and clock = '1' and dlx_tlx_flit_crc_err = '1' and dlx_tlx_flit_valid = '1')
           report "DLX supplying valid and error in the same cycle !)" severity error;
      assert not (clock'event and clock = '1' and dflit_cnt_q > "1000") report "dflit_cnt more than 8!" severity error;
      assert not (clock'event and clock = '1' and dl_overf = '1')   report "TL: input fifo overflowed" severity error;
      assert not (clock'event and clock = '1' and dl_underf = '1')  report "TL: input fifo underflowed" severity error;
      assert not (clock'event and clock = '1' and (start_ctl and dcp_we)='1') report "unexpected collision start_ctl and write data"  severity error;
      assert not (clock'event and clock = '1' and cmdd_w_crc_q = "000000" and  cmdd_w_crc_d = "111111") report "cmd crcd underflow"  severity error;
      assert not (clock'event and clock = '1' and ds_underf = '1') report "we have underflowed the data steering fifo" severity error;
      assert not (clock'event and clock = '1' and ds_overf = '1') report "we have overflowed the data steering fifo" severity error;
      assert not (clock'event and clock = '1' and resp_underflow = '1') report "we have undeflowed the response fifo" severity error;
      assert not (clock'event and clock = '1' and resp_overflow = '1') report "we have overflowed the response fifo" severity error;
      assert not (clock'event and clock = '1' and cmd_data_underflow = '1') report "we have underflowed the cmd data fifo" severity error;
      assert not (clock'event and clock = '1' and cmd_data_overflow = '1') report "we have overflowed the cmd data fifo" severity error;
      assert not (clock'event and clock = '1' and reset = '0' and afu_tlx_cmd_rd_cnt(2 downto 0) /= "001" and  afu_tlx_cmd_rd_req = '1' and
                                                                  afu_tlx_cmd_rd_cnt(2 downto 0) /= "010") report "invalid value on afu_tlx_cnt" severity error;
      assert not (clock'event and clock = '1' and reset = '0' and input_overflow = '1') report "input overflowed - probably issue 42 " severity error;

      assert not (clock'event and clock = '1' and reset = '0' and cmd_overflow = '1') report "cmd fifo overflowed " severity error;
      assert not (clock'event and clock = '1' and reset = '0' and cmd_underflow = '1') report "cmd fifo underflowed " severity error;
      assert not (clock'event and clock = '1' and reset = '0' and cfg_overflow = '1') report "cfg fifo overflowed " severity error;
      assert not (clock'event and clock = '1' and reset = '0' and cfg_underflow = '1') report "cfg fifo underflowed " severity error;
      assert not (clock'event and clock = '1' and reset = '0' and cfg_data_overflow = '1') report "cfg data fifo overflowed " severity error;
      assert not (clock'event and clock = '1' and reset = '0' and cfg_data_underflow = '1') report "cfg data fifo underflowed " severity error;
      --synopsys translate_on

      -- assuming xilinx latches all power up '0' !


     reset          <= not reset_n;

     tlx_mmio_rcv_errors_d(31)  <= dlx_tlx_flit_crc_err and dlx_tlx_flit_valid;                               -- DLX supplying valid and error in the same cycle !
     tlx_mmio_rcv_errors_d(30)  <= '1' when dflit_cnt_q > "1000" else '0';                                    -- dflit_cnt more than 8
     tlx_mmio_rcv_errors_d(29)  <= dl_overf;                                                                  -- input fifo overflowed
     tlx_mmio_rcv_errors_d(28)  <= dl_underf;                                                                 -- input fifo underflowed
     tlx_mmio_rcv_errors_d(27)  <= start_ctl and dcp_we;                                                      -- unexpected collision start_ctl and write data"  severity error;
     tlx_mmio_rcv_errors_d(26)  <= '1' when cmdd_w_crc_q = "000000" and  cmdd_w_crc_d = "111111" else '0';    -- cmd crcd underflow
     tlx_mmio_rcv_errors_d(25)  <= '1' when cmdd_w_crc_q = "111111" and  cmdd_w_crc_d = "000000" else '0';    -- cmd crcd overflow
     tlx_mmio_rcv_errors_d(24)  <= ds_underf;                                                                 -- we have undeflowed the data steering fifo
     tlx_mmio_rcv_errors_d(23)  <= ds_overf;                                                                  -- we have overflowed the data steering fifo
     tlx_mmio_rcv_errors_d(22)  <= resp_underflow;                                                            -- we have undeflowed the response fifo
     tlx_mmio_rcv_errors_d(21)  <= resp_overflow;                                                             -- we have overflowed the response fifo
     tlx_mmio_rcv_errors_d(20)  <= cmd_data_underflow;                                                        -- we have underflowed the config data fifo
     tlx_mmio_rcv_errors_d(19)  <= cmd_data_overflow;                                                         -- we have overflowed the config data fifo
     tlx_mmio_rcv_errors_d(18)  <= '1' when  reset = '0' and afu_tlx_cmd_rd_cnt(2 downto 0) /= "001" and  afu_tlx_cmd_rd_req = '1' and
                                                        afu_tlx_cmd_rd_cnt(2 downto 0) /= "010" else '0';   -- invalid value on afu_tlx_cnt
     tlx_mmio_rcv_errors_d(17)  <= input_overflow;                                                            -- input overflowed
     tlx_mmio_rcv_errors_d(16)  <= cmd_underflow;                                                             -- cmd fifo underflowed
     tlx_mmio_rcv_errors_d(15)  <= cmd_overflow;                                                              -- cmd fifo overflowed
     tlx_mmio_rcv_errors_d(14)  <= cfg_underflow;                                                             -- cfg fifo underflowed
     tlx_mmio_rcv_errors_d(13)  <= cfg_overflow;                                                              -- cfg fifo overflowed
     tlx_mmio_rcv_errors_d(12)  <= cfg_data_overflow;                                                         -- cfg data fifo overflowed
     tlx_mmio_rcv_errors_d(11)  <= cfg_data_underflow;                                                        -- cfg data fifo underflowed
     tlx_mmio_rcv_errors_d(10)  <= '1' when dlx_tlx_flit_valid = '1' and data_rx = '0' and dlx_tlx_flit(465 downto 461) /= "00000" and  dlx_tlx_flit(465 downto 460) /= "000100" else '0'; -- not template 0 1 or 4
     tlx_mmio_rcv_errors_d(9)   <= '1' when cmd_write = '1' and (packet_q(7 downto 0) = x"86" or packet_q(7 downto 0) = x"28") and packet_q(111 downto 109) /= "011" else '0'; -- not length of 8 for partial op
     tlx_mmio_rcv_errors_d(8)   <= unknown_opcode; -- either unknown or unsupported
     tlx_mmio_rcv_errors_d(7)   <= '1' when cmd_write = '1' and  (packet_q(7 downto 0) = x"81" or packet_q(7 downto 0) = x"20") and (packet_q(111 downto 110) = "11" or packet_q(111 downto 110) = "00") else '0';
     tlx_mmio_rcv_errors_d(6)   <= '1' when   cflit (119 downto 112) = "00000001" or
                                          ( cflit(465 downto 460) /= "000000" and ( cflit(231 downto 224)  = "00000001" or cflit(243 downto 336) = "00000001")) else '0';

     tlx_mmio_rcv_errors_d(5 downto 1) <= (others => '0');

     tlx_mmio_rcv_errors_d(0)   <= '1' when packet_q(11 downto 0) = x"1EF" and parsing_ctl_q = '1' else '0';

     ---
      unknown_opcode <= parsing_ctl_q when not (  ( packet_q(7 downto 4) = "0000" and ( packet_q(3 downto 1) = "000"  or packet_q(3 downto 0) = "1100")) or
                                                  ( packet_q(7 downto 4) = "0010" and ( packet_q(3 downto 0) = "1000" or packet_q(3 downto 0) = "0000")) or
                                                  ( packet_q(7 downto 4) = "1000" and ( packet_q(3 downto 0) = "0001" or packet_q(3 downto 0) = "0110")) or
                                                  ( packet_q(7 downto 4) = "1110" and  packet_q(3 downto 1) = "000" )
                                               )
                        else '0';

      ------------------------------------------------------------------------------------
      -- feed stuff from the dl into a fifo.  +data/control : metadata : flit(511 downto 0) --
      ------------------------------------------------------------------------------------
    last_good_dflit_cnt_d <= GATE(DLX_TLX_FLIT(451 downto 448), dlx_tlx_flit_valid and not data_rx) or
                             GATE(last_good_dflit_cnt_q, not dlx_tlx_flit_valid or data_rx);

    dflit_cnt_d         <=  last_good_dflit_cnt_q when dlx_tlx_flit_crc_err = '1' else
                            DLX_TLX_FLIT(451 downto 448) when (dlx_tlx_flit_valid and not data_rx) = '1' else
                            dflit_cnt_q - "0001"  when (dlx_tlx_flit_valid and data_rx) = '1' else
                            dflit_cnt_q;

    data_rx  <= OR_REDUCE(dflit_cnt_q);
    dl_din   <= data_rx & meta & dlx_tlx_flit; -- 518 is +data -control
    dl_write <= dlx_tlx_flit_valid;

dl_fifo: entity work.iram_input_fifo
  port map (
    clock           => clock,
    reset           => reset,
    remove_nulls    => '1',
    crc_error       => dlx_tlx_flit_crc_err,
    data_in         => dl_din,
    write           => dl_write,
    read            => dl_read,
    data_out        => dl_dout,
    empty           => dl_empty,
    full            => dl_full,
    overflow        => dl_overf,
    underflow       => dl_underf,
    array_overflow  => input_overflow
  );


    dl_valid   <= not dl_empty;


           ----------------------------------------------------------
           -- parse the output of the fifo if it is a control flit --
           ----------------------------------------------------------

infer: process(clock)
   begin
    if clock 'event and clock = '1' then
       if reset_n = '0' then
          parse_st <= (others=>'0');
          last_good_dflit_cnt_q  <= (others => '0');
          dflit_cnt_q            <= (others => '0');
          last_good_dflit_cnt_q  <= (others => '0');
          cflit                  <= (others => '0');
          cmdd_w_crc_q           <= (others => '0');
          reads_requested_q      <= (others => '0');
          onetwentyeightB_q      <= '0';
          meta_48_q              <= (others => '0');
          meta_mux_q             <= (others => '0');
       else
          parse_st(3 downto 0)   <=  GATE(parse_st(2 downto 0),not finished_ctl) & start_ctl;
          dflit_cnt_q            <=  dflit_cnt_d;
          last_good_dflit_cnt_q  <=  last_good_dflit_cnt_d;
          if start_ctl = '1' then
            cflit(511 downto 0)  <=  dl_dout(511 downto 0); -- the flit we are going to parse (this allows us to do data flits at the same time in some cases)
          end if;
          cmdd_w_crc_q           <=  cmdd_w_crc_d;
          reads_requested_q      <=  reads_requested_d;
          onetwentyeightB_q      <=  onetwentyeightB_d;
          meta_48_q              <=  meta_48_d;
          meta_mux_q             <= meta_mux_d;
       end if;

       tlx_mmio_rcv_errors_q     <=  tlx_mmio_rcv_errors_d;
       cmd_credits_q             <=  cmd_credits_d;
       cfg_credits_q             <=  cfg_credits_d;
       packet_q                  <=  packet_d;
       parsing_ctl_q             <=  parsing_ctl_d;

-- make the cmd_output
       tlx_afu_cmd_valid         <=  cmd_val_d;
       tlx_afu_cmd_opcode        <=  tlx_afu_cmd_opcode_d;
       tlx_afu_cmd_dl            <=  tlx_afu_cmd_dl_d;
       tlx_afu_cmd_pa            <=  tlx_afu_cmd_pa_d;
       tlx_afu_cmd_capptag       <=  tlx_afu_cmd_capptag_d;
       tlx_afu_cmd_pl            <=  tlx_afu_cmd_pl_d;
       tlx_afu_cmd_flag          <=  tlx_afu_cmd_flag_d;
-- make the config output
       tlx_cfg_valid             <=  cfg_val_d;
       tlx_cfg_opcode(0)         <=  tlx_cfg_opcode_d;
       tlx_cfg_pa                <=  tlx_cfg_pa_d;
       tlx_cfg_t                 <=  tlx_cfg_t_d;
       tlx_cfg_pl                <=  tlx_cfg_pl_d;
       tlx_cfg_capptag           <=  tlx_cfg_capptag_d;
       cfg_data_out_q            <=  cfg_data_out;
       resp_credits_q            <=  resp_credits_d;
       resp_val_q                <=  resp_val_d;
    end if;
end process infer;

    tlx_mmio_rcv_errors <= tlx_mmio_rcv_errors_q;

    tlx_cfg_opcode(7 downto 1) <= "1110000";

    parsing_ctl_d <=  OR_REDUCE(parse_st);

    start_ctl <= (not parsing_ctl_d or finished_ctl ) and dl_valid and not dl_dout(518);

-- throw out flits with empty slot zero before they go into the fifo. if the fifo is empty for a few clocks then I could put one in if it locks up at the end

    ee_0  <= (not OR_REDUCE(cflit(119 downto 112)) and  parse_st(0)) or
             parse_st(1);
    ee_14 <= (not OR_REDUCE(cflit(119 downto 112) & cflit(231 downto 224) & cflit(343 downto 336)) and parse_st(0)  ) or
             (                        not OR_REDUCE(cflit(231 downto 224) & cflit(343 downto 336)) and parse_st(1)  ) or
             (                                                not OR_REDUCE(cflit(343 downto 336)) and parse_st(2)  ) or
             parse_st(3);

    finished_ctl  <= (ee_0 and not cflit(465) and not cflit(464) and not cflit(463) and not cflit(462) and not cflit(461) and not cflit(460) ) or  -- t0
                     (ee_14 and not cflit(465) and not cflit(464) and not cflit(463) and not cflit(461) and (cflit(462) xor cflit(460)) );         -- t1 or t4

    dl_read <= not reset and dl_valid and (start_ctl or dcp_we) ;

    sd_0 <= x"00000000000000" & GATE(cflit(55 downto 0),parse_st(0)) or        --
                                GATE(cflit(223 downto 112),parse_st(1));
    sd_1 <= GATE(cflit(111 downto   0),parse_st(0)) or                         -- 4
            GATE(cflit(223 downto 112),parse_st(1)) or
            GATE(cflit(335 downto 224),parse_st(2)) or
            GATE(cflit(447 downto 336),parse_st(3));
    sd_4 <= x"00000000000000" & GATE(cflit(55 downto 0),parse_st(0)) or        -- 2
            GATE(cflit(223 downto 112),parse_st(1)) or
            GATE(cflit(335 downto 224),parse_st(2)) or
            GATE(cflit(447 downto 336),parse_st(3));


    packet_d(111  downto  0)  <= GATE(sd_0,cflit(465 downto 460) = "000000") or
                                   GATE(sd_1,cflit(465 downto 460) = "000001") or
                                   GATE(sd_4,cflit(465 downto 460) = "000100");

--                                 credit      slots   opcode    data required   fifo          comments
--             config read         tl.vc1         4      E0          0          config    E0                            1110
--             config write           vc1         4      E1          32         config    E1   replicate data
--             intrp_resp             vc0         2      0C          0          resp      0C
--             mem_cntl               vc0         2?     EF          0           cmd      EF
--             pr_rd_mem              vc1         4      28          0           cmd      28
--             pr_wr_mem           vc1/dcp1       4      86          32          cmd      86   replicate data
--             return_tlx_credits      -          1      01          0           -        01
--             rd_mem                 vc1         4      20          0           cmd      20   always reads 128
--             write_mem           vc1/dcp1       4      81       64 or 128      cmd      81   plus meta

                                                  -------------------
                                                  -- data steering --
                                                  -------------------
-- every time we put a command into cmd_fifo or cfg_fifo then if that command needs data too we also write a code onto the
-- steering_fifo. -1 = config, -0 = cmd, 1- = 128B, 0- = 64B
-- we read the fifo after as a data flit is written either to cmdd or cfgd
-- bits 8:2 are the byte offset for config accesses (dont-care for memory/mmio)

-- the write side must use unlatched signals to avoid underflowing the fifo when it's empty and we get a write folloved one flit followed
-- by data for that write in the next


    ds_din(1 downto 0) <=  GATE("01",packet_d(7 downto 0) = x"E1") or                  -- pr_wr_mem or wr_mem length 64 puts 00
                           GATE("10",packet_d(7 downto 0) = x"81" and packet_d(111 downto 110) = "10");

    ds_din(7 downto 2)   <= packet_d(33 downto 28);

    ds_write <= '1' when parsing_ctl_d = '1' and (packet_d(7 downto 0) = x"E1" or packet_d(7 downto 0) = x"86" or  packet_d(7 downto 0) = x"81") else '0';


    ds_done  <= dcp_we and ( not ds_dout(1) or onetwentyeightB_q);

    onetwentyeightB_d <= (dcp_we and ds_dout(1) and not onetwentyeightB_q) or    -- 19 Feb
                           (onetwentyeightB_q and not dcp_we);

STEERING_FIFO: entity work.tlx_fifo    -- ds _fifo
  generic map (
     width    => 8,
     depth    => 64
  )
  port map (
    clock       =>  clock,                                               -- in std_ulogic;
    reset       =>  reset,                                               -- in std_ulogic;        -- synchronous. clears control bits not the array (maybe xilinx does that anyway ? (don't care really))
    data_in     =>  ds_din,                                              -- in std_ulogic_vector(width-1 downto 0);
    write       =>  ds_write,                                            -- in std_ulogic;
    read        =>  ds_done,                                             -- in std_ulogic;        -- reads next (output is valid in same cycle as read)
    data_out    =>  ds_dout,                                             -- out std_ulogic_vector(width-1 downto 0);
    empty       =>  ds_empty,                                            -- out std_ulogic;
    overflow    =>  ds_overf,                                            -- out std_ulogic;
    underflow   =>  ds_underf                                            -- out std_ulogic
);
                                                  -------------------
                                                  -- cmd fifo --
                                                  -------------------
    cmd_write <= parsing_ctl_q and not ( (packet_q(7) and  packet_q(6) and not packet_q(4))        or     -- did I get this right ?
                                     (not packet_q(7) and not packet_q(6) and not packet_q(5))
                                   );

    cmd_val_d   <= not cmd_empty and cmd_cred_ok and (cmd_data_avail_1 or cmd_data_avail_2 or cmd_data_not_needed);
    cmd_read    <= cmd_val_d;
    tlx_afu_cmd_opcode_d    <= cmd_out(7 downto 0);
    tlx_afu_cmd_dl_d        <= cmd_out(111 downto 110);
    tlx_afu_cmd_pa_d        <= cmd_out(91 downto 28);
    tlx_afu_cmd_capptag_d   <= cmd_out(107 downto 92);
    tlx_afu_cmd_pl_d        <= cmd_out(111 downto 109);
    tlx_afu_cmd_flag_d      <= cmd_out(11 downto 8);                       -- valid for mem_cntl only


-- we need to count the crc data which has good crc
-- at start_ctl we clear a counter that is counting writes. we also add that counter value to a running total of data flits for commands

   cmdd_w_crc_d <=  GATE(cmdd_w_crc_q             , not cmd_data_write and not (not cmd_empty and cmd_cred_ok and (cmd_data_avail_1 or cmd_data_avail_2 ))) or        -- no write no read
                    GATE(cmdd_w_crc_q             ,     cmd_data_write and      not cmd_empty and cmd_cred_ok and cmd_data_avail_1 )                        or        -- write and read 1
                    GATE(cmdd_w_crc_q + "000001"  ,     cmd_data_write and not (not cmd_empty and cmd_cred_ok and (cmd_data_avail_1 or cmd_data_avail_2 ))) or        -- write and no read
                    GATE(cmdd_w_crc_q - "000001"  ,     cmd_data_write and      not cmd_empty and cmd_cred_ok and cmd_data_avail_2 )                        or        -- write and read 2
                    GATE(cmdd_w_crc_q - "000001"  , not cmd_data_write and      not cmd_empty and cmd_cred_ok and cmd_data_avail_1 )                        or        -- no write and read 1
                    GATE(cmdd_w_crc_q - "000010"  , not cmd_data_write and      not cmd_empty and cmd_cred_ok and cmd_data_avail_2 );                                 -- no write and read 2

    cmd_one_data <= '1' when  cmdd_w_crc_q /= "000000" and cmd_data_empty = '0' else '0';
    cmd_two_data <= '1' when  cmdd_w_crc_q >  "000001" and cmd_data_full  = '1' else '0';

    cmd_data_avail_1  <=  '1' when (cmd_out(7 downto 0) = x"86" and  cmd_one_data = '1') or
                                  (cmd_out(7 downto 0) = x"81" and cmd_out(111 downto 110) = "01" and  cmd_one_data='1')
                                else '0';

    cmd_data_avail_2  <= '1' when (cmd_out(7 downto 0) = x"81" and cmd_out(111 downto 110) = "10" and  cmd_two_data='1' )
                                else '0';

    cmd_data_not_needed <=  (cmd_out(7 downto 0) /= x"86" and cmd_out(7 downto 0) /= x"81");


cmd_fifo: entity work.iram_fifo_64x112
  port map (
    clock           => clock,
    reset           => reset,
    data_in         => packet_q,
    write           => cmd_write,
    read            => cmd_read,
    data_out        => cmd_out,
    empty           => cmd_empty,
    full            => open,
    overflow        => cmd_overflow,
    underflow       => cmd_underflow
  );
                                                  -------------------
                                                  -- cmd data fifo --
                                                  -------------------
                         -- 6 feb must not write data before commands have gone because cmd_writewon't then be valid. fixed again feb19 issue 29
    dcp_we <= (not parsing_ctl_d or not ds_empty) and dl_valid and dl_dout(518);

    cmd_data_write <= dcp_we and not ds_dout(0);
    -- issue 36 20 Feb. Need to count up the data requests and unstack as appropriate rather than attempting impossible for string of 128B requests

    rr_inputs <=  afu_tlx_cmd_rd_cnt(1) & afu_tlx_cmd_rd_req & cmd_data_read;

    reads_requested_d <=  GATE(reads_requested_q + "000001", rr_inputs = "111" or rr_inputs = "010") or
                          GATE(reads_requested_q - "000001", rr_inputs = "001" or rr_inputs = "101") or
                          GATE(reads_requested_q + "000010", rr_inputs = "110"                     ) or
                          GATE(reads_requested_q           , rr_inputs = "011" or rr_inputs(1 downto 0) = "00");  --- add reset in where we latch it

    cmd_data_read <= OR_REDUCE(reads_requested_q);

    tlx_afu_cmd_data_valid   <= cmd_data_read;

cmd_data_fifo: entity work.iram_fifo_64x518
  port map (
    clock           => clock,
    reset           => reset,
    data_in         => dl_dout(517 downto 0),
    write           => cmd_data_write,
    read            => cmd_data_read,
    data_out        => cmd_data_out,
    empty           => cmd_data_empty,
    full            => cmd_data_full,
    overflow        => cmd_data_overflow,
    underflow       => cmd_data_underflow
  );
      tlx_afu_cmd_data_bus   <= cmd_data_out;

                                                  --------------                                                                                --    config
                                                  -- cfg fifo --                                                                                --    config
                                                  --------------                                                                                --    config
    cfg_write <= parsing_ctl_q and packet_q(7) and  packet_q(6) and not packet_q(3);                                                            --    config
                                                                                                                                                --    config
    cfg_val_d   <= not cfg_empty and cfg_cred_ok and (cfg_data_available or cfg_data_not_needed);                                               --    config

    cfg_read    <= cfg_val_d;                                                                                                                   --    config

    cfg_data_read <= cfg_val_d and cfg_out(0); -- increment the data only for writes
                                                                                                                                                --    config
-- we need to count the crc data which has good crc                                                                                             --    config
-- at start_ctl we clear a counter that is counting writes. we also add that counter value to a running total of data flits for commands        --    config
                                                                                                                                                --    config
                                                                                                                                                --    config
    cfg_data_available <= not cfg_data_empty and not cfg_data_empty and cfg_out(0) ; --E1 only ever needs one data
                                                                                                                                                --    config
    cfg_data_not_needed <= not cfg_out(0);

    cfg_packet <= packet_q(107 downto 92) & packet_q(111 downto 109) & packet_q(108) &                                                          -- tag & pl &  t ....
                   packet_q(91 downto 28) & packet_q(0);

cfg_fifo: entity work.iram_fifo_64x85                                                                                                           --    config
  port map (                                                                                                                                    --    config
    clock           => clock,                                                                                                                   --    config
    reset           => reset,                                                                                                                   --    config
    data_in         => cfg_packet,                                                                                                              --    config
    write           => cfg_write,                                                                                                               --    config
    read            => cfg_read,                                                                                                                --    config
    data_out        => cfg_out,                                                                                                                 --    config
    empty           => cfg_empty,                                                                                                               --    config
    full            => open,                                                                                                                    --    config
    overflow        => cfg_overflow,                                                                                                            --    config
    underflow       => cfg_underflow                                                                                                            --    config
  );                                                                                                                                            --    config
                                                  -------------------                                                                           --    config
                                                  -- cfg data fifo --                                                                           --    config
                                                  -------------------                                                                           --    config
                         -- 6 feb must not write data before commands have gone because steering won't then be valid                            --    config
                                                                                                                                                --    config
    cfg_data_write <= dcp_we and ds_dout(0);                                                                                                    --    config
                                                                                                                                                --    config
                                                                                 -- we dig out 4 bytes from 64 - do we need to do more ?        --    config
    cfgd_in_32 <= GATE(dl_dout( 31 downto   0),ds_dout(7 downto 4) = "0000") or  -- gemini has no 32B data carriers                             --    config
                  GATE(dl_dout( 63 downto  32),ds_dout(7 downto 4) = "0001") or                                                                 --    config
                  GATE(dl_dout( 95 downto  64),ds_dout(7 downto 4) = "0010") or                                                                 --    config
                  GATE(dl_dout(127 downto  96),ds_dout(7 downto 4) = "0011") or                                                                 --    config
                  GATE(dl_dout(159 downto 128),ds_dout(7 downto 4) = "0100") or                                                                 --    config
                  GATE(dl_dout(191 downto 160),ds_dout(7 downto 4) = "0101") or                                                                 --    config
                  GATE(dl_dout(223 downto 192),ds_dout(7 downto 4) = "0110") or                                                                 --    config
                  GATE(dl_dout(255 downto 224),ds_dout(7 downto 4) = "0111") or                                                                 --    config
                  GATE(dl_dout(287 downto 256),ds_dout(7 downto 4) = "1000") or                                                                 --    config
                  GATE(dl_dout(319 downto 288),ds_dout(7 downto 4) = "1001") or                                                                 --    config
                  GATE(dl_dout(351 downto 320),ds_dout(7 downto 4) = "1010") or                                                                 --    config
                  GATE(dl_dout(383 downto 352),ds_dout(7 downto 4) = "1011") or                                                                 --    config
                  GATE(dl_dout(415 downto 384),ds_dout(7 downto 4) = "1100") or                                                                 --    config
                  GATE(dl_dout(447 downto 416),ds_dout(7 downto 4) = "1101") or                                                                 --    config
                  GATE(dl_dout(479 downto 448),ds_dout(7 downto 4) = "1110") or                                                                 --    config
                  GATE(dl_dout(511 downto 480),ds_dout(7 downto 4) = "1111");                                                                   --    config
                                                                                                                                                --    config
                                                                                                                                                --    config
                                                                                                                                                --    config
                                                                                                                                                --    config
cfg_data_fifo: entity work.iram_fifo_64x32                                                                                                      --    config
  port map (                                                                                                                                    --    config
    clock           => clock,                                                                                                                   --    config
    reset           => reset,                                                                                                                   --    config
    data_in         => cfgd_in_32,             -- timing problem ?                                                                              --    config
    write           => cfg_data_write,                                                                                                          --    config
    read            => cfg_data_read,                                                                                                           --    config
    data_out        => cfg_data_out,                                                                                                            --    config
    empty           => cfg_data_empty,                                                                                                          --    config
    full            => open,                                                                                                                    --    config
    overflow        => cfg_data_overflow,                                                                                                       --    config
    underflow       => cfg_data_underflow                                                                                                       --    config
  );                                                                                                                                            --    config

  tlx_cfg_opcode_d                    <=  cfg_out(0);                                                      --      : out   std_ulogic_vector(7 downto 0);
  tlx_cfg_pa_d                        <=  cfg_out(64 downto 1);                                            --      : out   std_ulogic_vector(63 downto 0);
  tlx_cfg_t_d                         <=  cfg_out(65);                                                     --      : out   std_ulogic;
  tlx_cfg_pl_d                        <=  cfg_out(68 downto 66);                                           --      : out   std_ulogic_vector(2 downto 0);
  tlx_cfg_capptag_d                   <=  cfg_out(84 downto 69);                                           --      : out   std_ulogic_vector(15 downto 0);
  tlx_cfg_data_bus                    <=  cfg_data_out_q;                                                  --      : out   std_ulogic_vector(31 downto 0);
  tlx_cfg_data_bdi                    <=  '0';                                                             --      : out   std_ulogic;                       -- tied '0'
  tlx_cfg_in_rcv_tmpl_capability_0    <=  '1';                                                             --      : out   std_ulogic;
  tlx_cfg_in_rcv_tmpl_capability_1    <=  '1';                                                             --      : out   std_ulogic;
  tlx_cfg_in_rcv_tmpl_capability_4    <=  '1';                                                             --      : out   std_ulogic;
  tlx_cfg_in_rcv_tmpl_capability_7    <=  '0';                                                             --      : out   std_ulogic;
  tlx_cfg_in_rcv_tmpl_capability_10   <=  '0';                                                             --      : out   std_ulogic;
  tlx_cfg_in_rcv_rate_capability_0    <=  "0100";                                                          --      : out   std_ulogic_vector(3 downto 0);
  tlx_cfg_in_rcv_rate_capability_1    <=  "0100";                                                          --      : out   std_ulogic_vector(3 downto 0);
  tlx_cfg_in_rcv_rate_capability_4    <=  "0100";                                                          --      : out   std_ulogic_vector(3 downto 0);
  tlx_cfg_in_rcv_rate_capability_7    <=  "1111";                                                          --      : out   std_ulogic_vector(3 downto 0);
  tlx_cfg_in_rcv_rate_capability_10   <=  "1111";                                                          --      : out   std_ulogic_vector(3 downto 0);

                                                  --------------------
                                                  -- credit counters --
                                                  --------------------

   dec_cmd_cred <= cmd_val_d and OR_REDUCE(cmd_credits_q & afu_tlx_cmd_credit);

   cmd_credits_d <= GATE(afu_tlx_cmd_initial_credit , reset) or
                    GATE(cmd_credits_q + "0000001", afu_tlx_cmd_credit and not dec_cmd_cred and not reset) or
                    GATE(cmd_credits_q - "0000001", not afu_tlx_cmd_credit and dec_cmd_cred and not reset) or
                    GATE(cmd_credits_q, not ((afu_tlx_cmd_credit xor dec_cmd_cred) or reset) );

   cmd_cred_ok <= OR_REDUCE(cmd_credits_q);

   dec_cfg_cred <= cfg_val_d and OR_REDUCE(cfg_credits_q & cfg_tlx_credit_return);

   cfg_credits_d <= GATE(cfg_tlx_initial_credit , reset) or
                    GATE(cfg_credits_q + "0001", cfg_tlx_credit_return and not dec_cfg_cred and not reset) or
                    GATE(cfg_credits_q - "0001", not cfg_tlx_credit_return and dec_cfg_cred and not reset) or
                    GATE(cfg_credits_q, not ((cfg_tlx_credit_return xor dec_cfg_cred) or reset) );

   cfg_cred_ok <= OR_REDUCE(cfg_credits_q);

   dec_resp_cred <= resp_val_d and OR_REDUCE(resp_credits_q & afu_tlx_resp_credit);

   resp_credits_d <= GATE(afu_tlx_resp_initial_credit , reset) or
                     GATE(resp_credits_q + "0000001", afu_tlx_resp_credit and not dec_resp_cred and not reset) or
                     GATE(resp_credits_q - "0000001", not afu_tlx_resp_credit and dec_resp_cred and not reset) or
                     GATE(resp_credits_q, not ((afu_tlx_resp_credit xor dec_resp_cred) or reset) );

   resp_cred_ok <= OR_REDUCE(resp_credits_q);

   vc1_sigs <=   (cmd_val_d and  not (cmd_out(3) and cmd_out(2))) &   -- anything except memcntl or intrp_resp
                 cfg_val_d                                        &   -- config
                 OR_REDUCE(vc1_count);                                -- saved credits

   vc0_sigs <=   (cmd_val_d and  cmd_out(3) and cmd_out(2))       &   -- memcntl
                 resp_val_d                                       &   -- intrp_resp
                 OR_REDUCE(vc0_count);

   rcv_xmt_tl_credit_dcp0_valid   <= '0';


-- with the null removing input fifo we should have in that fifo
-- 1 empty control flit + max of (vc1+vc0) c-flits + max of dcp1 d-flits
-- so vc1 + vc0 + dcp1 =< 63. (the individual fifos are never the limit, it's that input fifo that will always overflow first)

-- we have vc1 = 20 vc0 = 4 dcp1 = 20(16 + 4) at the moment
-- we could make issue 66 better with vc1 = 38 vc0 = 4 dcp1 = 20

crinit : process(clock)
   begin
    if clock 'event and clock = '1' then
       ret_vc1 <= '0';
       if reset_n = '0' then
           i_count <= "000000";
           vc1_count <= (others => '0');
           vc0_count <= (others => '0');
           rcv_xmt_tl_credit_vc1_valid     <= '0';
           rcv_xmt_tl_credit_vc0_valid     <= '0';
           rcv_xmt_tl_credit_dcp1_valid    <= '0';
           rcv_xmt_tl_crd_cfg_dcp1_valid   <= '0';
           rcv_xmt_tlx_credit_valid        <= '0';
       else
          if i_count /= "111111" then
             i_count <= i_count + "000001";
          end if;

-- we can send just one vc1 credit op per clock but we may accumulate two - so we save any extra and drain as we can


---        cmd cfg count           inc   dec  send
---
---        0    0   0               0     0    0
---        0    0   1               0     1    1
---        0    1   0               0     0    1
---        0    1   1               0     0    1
---        1    0   0               0     0    1
---        1    0   1               0     0    1
---        1    1   0               1     0    1
---        1    1   1               1     0    1

           ret_vc1 <= OR_REDUCE(vc1_sigs);
           if vc1_sigs = "001" then
              vc1_count <= vc1_count - "000001";
           elsif  vc1_sigs(2 downto 1) = "11" then
              vc1_count <= vc1_count + "000001";
           end if;

          if i_count < "100110"  then  -- give it 38 vc1
             rcv_xmt_tl_credit_vc1_valid     <= '1';
          else
             rcv_xmt_tl_credit_vc1_valid    <= ret_vc1;
          end if;


      -- we have the same problem with vc0 as with vc1. we can deliver memcntl and intrp_resp at the same time but can oly return one vc0
      -- credit per clock so we have to count up and drain when possible.

           ret_vc0 <= OR_REDUCE(vc0_sigs);
           if vc0_sigs = "001" then
              vc0_count <= vc0_count - "0001";
           elsif  vc0_sigs(2 downto 1) = "11" then
              vc0_count <= vc0_count + "0001";
           end if;

          if i_count < "000100" then  -- give it 4 vc0 and config data
             rcv_xmt_tl_credit_vc0_valid     <= '1';
             rcv_xmt_tl_crd_cfg_dcp1_valid  <= '1';
          else
             rcv_xmt_tl_credit_vc0_valid    <= ret_vc0 ;  -- memcntl and intr_resp
             rcv_xmt_tl_crd_cfg_dcp1_valid  <= cfg_data_read;
          end if;

          if i_count < "010000" then  -- give it 16 dcp1   HALF - to allow for nulls
             rcv_xmt_tl_credit_dcp1_valid     <= '1';
          else
             rcv_xmt_tl_credit_dcp1_valid    <= cmd_data_read;                  --- this appears just data for non-config
          end if;


          if (dlx_tlx_flit_valid  and not data_rx) = '1' and dlx_tlx_flit(7 downto 0) = x"01" then -- 4 mar  was packet_q and parsing_ctl_q because upstream
            rcv_xmt_tlx_credit_valid  <= '1';                                                      -- ie apollo is different
          else
             rcv_xmt_tlx_credit_valid  <= '0';
          end if;
          rcv_xmt_tlx_credit_vc0    <= dlx_tlx_flit(11 downto 8);
          rcv_xmt_tlx_credit_vc3    <= dlx_tlx_flit(23 downto 20);
          rcv_xmt_tlx_credit_dcp0   <= dlx_tlx_flit(37 downto 32);
          rcv_xmt_tlx_credit_dcp3   <= dlx_tlx_flit(55 downto 50);
       end if;
    end if;
end process crinit;
                                                  -----------------------------------
                                                  -- responses (always intrp_resp) --
                                                  -----------------------------------
    resp_write <= parsing_ctl_q and not packet_q(7) and  packet_q(3) and packet_q(2);

    resp_val_d   <= not resp_empty and resp_cred_ok;

    resp_read <= resp_val_d;

resp_fifo: entity work.iram_fifo_64x16
  port map (
    clock           => clock,
    reset           => reset,
    data_in         => packet_q(23 downto 8),
    write           => resp_write,
    read            => resp_read,
    data_out        => tlx_afu_resp_afutag,
    empty           => resp_empty,
    full            => open,
    overflow        => resp_overflow,
    underflow       => resp_underflow
  );

    tlx_afu_resp_valid     <= resp_val_q;
    tlx_afu_resp_opcode    <=  x"0C";
    tlx_afu_ready          <=  dlx_tlx_link_up;

                                               ----------------
                                               --  METADATA  --
                                               ----------------
-- New matadata scheme each good T4 control flit we latch 48 bits of metadata and then we mux some of it out each time a data flit is written. A non-t4
-- control flit loads zeros. six bits of metadata go intto the dl fifo alongside the data. crc error resets the mux pointer

   t4_meta  <= dlx_tlx_flit(110 downto 105) &  dlx_tlx_flit(103 downto 98) &  dlx_tlx_flit(96 downto 91) &  dlx_tlx_flit(89 downto 84) &
               dlx_tlx_flit(82  downto 77)  &  dlx_tlx_flit(75 downto 70) &  dlx_tlx_flit(68 downto 63) &  dlx_tlx_flit(61 downto 56);

   meta_48_d <= GATE(t4_meta       , (dlx_tlx_flit_valid & data_rx & dlx_tlx_flit(465 downto 460) & metadata_enabled) = "100001001") or -- latch when t4
                GATE(meta_48_q     ,  not (dlx_tlx_flit_valid and not data_rx)                                    );                    -- hold until good control

   meta(5 downto 0) <= GATE(meta_48_q( 5 downto  0),meta_mux_q(0)) or
                       GATE(meta_48_q(11 downto  6),meta_mux_q(1)) or
                       GATE(meta_48_q(17 downto 12),meta_mux_q(2)) or
                       GATE(meta_48_q(23 downto 18),meta_mux_q(3)) or
                       GATE(meta_48_q(29 downto 24),meta_mux_q(4)) or
                       GATE(meta_48_q(35 downto 30),meta_mux_q(5)) or
                       GATE(meta_48_q(41 downto 36),meta_mux_q(6)) or
                       GATE(meta_48_q(47 downto 42),meta_mux_q(7));

   meta_mux_d <=   GATE("00000001", (dlx_tlx_flit_valid & data_rx & dlx_tlx_flit(465 downto 460) & metadata_enabled) = "100001001") or -- latch when t4
                   GATE("00000001", dlx_tlx_flit_crc_err )                                                                          or
                   GATE(meta_mux_q(6 downto 0) & '0' , dlx_tlx_flit_valid and data_rx)                                              or
                   GATE(meta_mux_q                   , not dlx_tlx_flit_valid and not dlx_tlx_flit_crc_err);

                                               -------------
                                               --  DEBUG  --
                                               -------------


     tlx_mmio_rcv_debug(63)            <=  dlx_tlx_link_up;
     tlx_mmio_rcv_debug(62)            <=  dlx_tlx_flit_crc_err;
     tlx_mmio_rcv_debug(61)            <=  dlx_tlx_flit_valid;
     tlx_mmio_rcv_debug(60)            <=  data_rx;
     tlx_mmio_rcv_debug(59 downto 56)  <=  dlx_tlx_flit(451 downto 448);   -- runlength
     tlx_mmio_rcv_debug(55 downto 50)  <=  dlx_tlx_flit(465 downto 460);   -- template
     tlx_mmio_rcv_debug(49)            <=  input_overflow;
     tlx_mmio_rcv_debug(48 downto 47)  <=  "00";
     tlx_mmio_rcv_debug(46 downto 41)  <=  cflit(465 downto 460);
     tlx_mmio_rcv_debug(40)            <=  dl_full;
     tlx_mmio_rcv_debug(39)            <=  start_ctl;
     tlx_mmio_rcv_debug(38 downto 35)  <=  parse_st;
     tlx_mmio_rcv_debug(34 downto 27)  <=  packet_q(7 downto 0);
     tlx_mmio_rcv_debug(26 downto 24)  <=  packet_q(111 downto 109);
     tlx_mmio_rcv_debug(23)            <=  dcp_we;
     tlx_mmio_rcv_debug(22 downto 17)  <=  cmdd_w_crc_q(5 downto 0);
     tlx_mmio_rcv_debug(16)            <=  cfg_data_empty;
     tlx_mmio_rcv_debug(15)            <=  cmd_write;
     tlx_mmio_rcv_debug(14)            <=  cfg_write;
     tlx_mmio_rcv_debug(13)            <=  ds_write;
     tlx_mmio_rcv_debug(12 downto 5)   <=  ds_din;
     tlx_mmio_rcv_debug(4)             <=  resp_write;
     tlx_mmio_rcv_debug(3)             <=  resp_cred_ok;
     tlx_mmio_rcv_debug(2)             <=  cmd_cred_ok;
     tlx_mmio_rcv_debug(1)             <=  cfg_cred_ok;
     tlx_mmio_rcv_debug(0)             <=  tlx_mmio_rcv_errors_q(0);

end ice_tlx_rcv ;

