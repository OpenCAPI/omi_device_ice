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
Use Ieee.Std_logic_1164.All;
Use Ieee.Numeric_std.All;
Use Ieee.Std_logic_arith.All;
Use Work.Ice_func.All;

entity ice_errrpt_intrp is
  port
    (
      clock_400mhz                      : in    std_ulogic;
      reset_n                           : in    std_ulogic;
      
      mmio_errrpt_xstop_err                         : in    std_ulogic;
      mmio_errrpt_mchk_err                          : in    std_ulogic;
                                        
      mmio_errrpt_intrp_hdl_xstop       : in std_ulogic_vector(63 downto 0);
      mmio_errrpt_intrp_hdl_app         : in std_ulogic_vector(63 downto 0);
      mmio_errrpt_cmd_flag_xstop        : in std_ulogic_vector(3 downto 0);
      mmio_errrpt_cmd_flag_app          : in std_ulogic_vector(3 downto 0);
      
      cfg_tlx_function_actag_base       : in std_ulogic_vector(11 downto 0);
      cfg_tlx_function_actag_len_enab   : in std_ulogic_vector(11 downto 0);
      cfg_tlx_afu_actag_base            : in std_ulogic_vector(11 downto 0);
      cfg_tlx_afu_actag_len_enab        : in std_ulogic_vector(11 downto 0);
      cfg_tlx_pasid_length_enabled      : in std_ulogic_vector(4 downto 0);
      cfg_tlx_pasid_base                : in std_ulogic_vector(19 downto 0);
      
      afu_tlx_resp_initial_credit       : out std_ulogic_vector(6 downto 0);
      afu_tlx_resp_credit               : out std_ulogic;
      tlx_afu_resp_valid                : in std_ulogic;
      tlx_afu_resp_opcode               : in std_ulogic_vector(7 downto 0);
      tlx_afu_resp_afutag               : in std_ulogic_vector(15 downto 0);
                                        
      tlx_afu_cmd_initial_credit        : in std_ulogic_vector(3 downto 0);
      tlx_afu_cmd_credit                : in std_ulogic;
      afu_tlx_cmd_valid                 : out std_ulogic;
      afu_tlx_cmd_opcode                : out std_ulogic_vector(7 downto 0);
      afu_tlx_cmd_actag                 : out std_ulogic_vector(11 downto 0);
      afu_tlx_cmd_stream_id             : out std_ulogic_vector(3 downto 0);
      afu_tlx_cmd_ea_or_obj             : out std_ulogic_vector(63 downto 0);
      afu_tlx_cmd_afutag                : out std_ulogic_vector(15 downto 0);
      afu_tlx_cmd_flag                  : out std_ulogic_vector(3 downto 0);
      afu_tlx_cmd_bdf                   : out std_ulogic_vector(15 downto 0);
      afu_tlx_cmd_pasid                 : out std_ulogic_vector(19 downto 0);

      err_rpt_dbg                       : out std_ulogic_vector(3 downto 0)
    );

end ice_errrpt_intrp;

architecture ice_errrpt_intrp of ice_errrpt_intrp is

signal mmio_errrpt_intrp_hdl_xstop_d : std_ulogic_vector(63 downto 0);
signal mmio_errrpt_intrp_hdl_app_d   : std_ulogic_vector(63 downto 0);
signal mmio_errrpt_cmd_flag_xstop_d  : std_ulogic_vector(3 downto 0);
signal mmio_errrpt_cmd_flag_app_d    : std_ulogic_vector(3 downto 0);
signal afu_tlx_resp_initial_credit_d : std_ulogic_vector (6 downto 0);
signal afu_tlx_resp_credit_d         : std_ulogic;
signal afu_tlx_cmd_valid_d           : std_ulogic;
signal afu_tlx_cmd_opcode_d          : std_ulogic_vector(7 downto 0);
signal afu_tlx_cmd_actag_d           : std_ulogic_vector(11 downto 0);
signal afu_tlx_cmd_ea_or_obj_d       : std_ulogic_vector(63 downto 0);
signal afu_tlx_cmd_afutag_d          : std_ulogic_vector(15 downto 0);
signal afu_tlx_cmd_flag_d            : std_ulogic_vector(3 downto 0);
signal afu_tlx_cmd_bdf_d             : std_ulogic_vector(15 downto 0);
signal afu_tlx_cmd_pasid_d           : std_ulogic_vector(19 downto 0);
signal mmio_errrpt_intrp_hdl_xstop_q : std_ulogic_vector(63 downto 0);
signal mmio_errrpt_intrp_hdl_app_q   : std_ulogic_vector(63 downto 0);
signal mmio_errrpt_cmd_flag_xstop_q  : std_ulogic_vector(3 downto 0);
signal mmio_errrpt_cmd_flag_app_q    : std_ulogic_vector(3 downto 0);
signal afu_tlx_resp_initial_credit_q : std_ulogic_vector (6 downto 0);
signal afu_tlx_resp_credit_q         : std_ulogic;
signal afu_tlx_cmd_valid_q           : std_ulogic;
signal afu_tlx_cmd_opcode_q          : std_ulogic_vector(7 downto 0);
signal afu_tlx_cmd_actag_q           : std_ulogic_vector(11 downto 0);
signal afu_tlx_cmd_ea_or_obj_q       : std_ulogic_vector(63 downto 0);
signal afu_tlx_cmd_afutag_q          : std_ulogic_vector(15 downto 0);
signal afu_tlx_cmd_flag_q            : std_ulogic_vector(3 downto 0);
signal afu_tlx_cmd_bdf_q             : std_ulogic_vector(15 downto 0);
signal afu_tlx_cmd_pasid_q           : std_ulogic_vector(19 downto 0);
signal cfg_tlx_pasid_length_enabled_d  : std_ulogic_vector(4 downto 0);
signal cfg_tlx_pasid_base_d          : std_ulogic_vector(19 downto 0);
signal cfg_tlx_pasid_length_enabled_q : std_ulogic_vector(4 downto 0);
signal cfg_tlx_pasid_base_q          : std_ulogic_vector(19 downto 0);
signal cfg_tlx_afu_actag_len_enab_d  : std_ulogic_vector(11 downto 0);
signal cfg_tlx_afu_actag_base_d          : std_ulogic_vector(11 downto 0);
signal cfg_tlx_afu_actag_len_enab_q  : std_ulogic_vector(11 downto 0);
signal cfg_tlx_afu_actag_base_q          : std_ulogic_vector(11 downto 0);
signal cfg_tlx_function_actag_len_enab_q : std_ulogic_vector(11 downto 0);
signal cfg_tlx_function_actag_base_q          : std_ulogic_vector(11 downto 0);
signal cfg_tlx_function_actag_len_enab_d : std_ulogic_vector(11 downto 0);
signal cfg_tlx_function_actag_base_d          : std_ulogic_vector(11 downto 0);



----------------------------------------------------------------------------------------------------

signal intrp_req_chan_xstop_d : std_ulogic_vector(1 downto 0);
signal intrp_req_chan_xstop_q : std_ulogic_vector(1 downto 0);
signal intrp_req_app_intrp_d : std_ulogic_vector(1 downto 0);
signal intrp_req_app_intrp_q : std_ulogic_vector(1 downto 0);
signal assign_actag_sent_d : std_ulogic_vector(1 downto 0);
signal assign_actag_sent_q : std_ulogic_vector(1 downto 0);
signal assign_actag_enab : std_ulogic;
signal actag_len_enab_err : std_ulogic;
signal actag_base_err : std_ulogic;
signal cmd_credit_counter_d : std_ulogic_vector(3 downto 0);
signal cmd_credit_counter_q : std_ulogic_vector(3 downto 0);
signal send_intrp_req_chan_xstop : std_ulogic;
signal send_assign_actag : std_ulogic;
signal resp_credit_counter_d : std_ulogic_vector(6 downto 0);
signal resp_credit_counter_q : std_ulogic_vector(6 downto 0);
signal resp_credit_dec : std_ulogic;
signal pasid_enab : std_ulogic;
signal intrp_req_chan_xstop_idle : std_ulogic;
signal intrp_req_chan_xstop_pend : std_ulogic;
signal intrp_req_chan_xstop_send : std_ulogic;
signal xstop_intrp_pulse : std_ulogic;
signal intrp_req_app_intrp_idle : std_ulogic;
signal intrp_req_app_intrp_pend : std_ulogic;
signal intrp_req_app_intrp_send : std_ulogic;
signal app_intrp_pulse : std_ulogic;
signal send_intrp_req_app_intrp : std_ulogic;
signal cmd_credit_avail : std_ulogic;
signal intrp_resp_chan_xstop : std_ulogic;
signal intrp_resp_app_intrp : std_ulogic;
signal send_intrp_req : std_ulogic;
signal assign_actag_idle : std_ulogic;
signal assign_actag_pend : std_ulogic;
signal assign_actag_send : std_ulogic;
signal assign_actag_sent : std_ulogic;
signal intrp_resp_val   : std_ulogic;
signal mmio_errrpt_xstop_err_q : std_ulogic;
signal mmio_errrpt_xstop_err_d : std_ulogic;
signal mmio_errrpt_mchk_err_q : std_ulogic;
signal mmio_errrpt_mchk_err_d : std_ulogic;
signal unexpected_intrp_resp : std_ulogic;
signal intrp_resp_tag_err : std_ulogic;
signal unsupported_resp_opcode : std_ulogic;

constant assign_actag_opcode : std_ulogic_vector(7 downto 0):="01010000";
constant intrp_req_opcode : std_ulogic_vector(7 downto 0):="01011000";
constant intrp_resp_opcode : std_ulogic_vector(7 downto 0):="00001100";
constant device : std_ulogic_vector(4 downto 0):="00000";
constant func : std_ulogic_vector(2 downto 0):="001";
constant xstop_afutag : std_ulogic_vector(15 downto 0):=x"0001";
constant app_intrp_afutag : std_ulogic_vector(15 downto 0):=x"0004";
constant stream_id : std_ulogic_vector(3 downto 0):=x"0";
constant resp_init_cred : std_ulogic_vector(6 downto 0):="0000100";

attribute mark_debug : string;

attribute mark_debug of mmio_errrpt_xstop_err_q : signal is "true";
attribute mark_debug of intrp_req_chan_xstop_q : signal is "true";

    
begin   --ice_errrpt_intrp.vhdl

  mmio_errrpt_intrp_hdl_xstop_d <= mmio_errrpt_intrp_hdl_xstop;
  mmio_errrpt_intrp_hdl_app_d   <= mmio_errrpt_intrp_hdl_app;
  mmio_errrpt_cmd_flag_xstop_d  <= mmio_errrpt_cmd_flag_xstop;
  mmio_errrpt_cmd_flag_app_d    <= mmio_errrpt_cmd_flag_app;
  
  cfg_tlx_function_actag_base_d <= cfg_tlx_function_actag_base;
  cfg_tlx_function_actag_len_enab_d <= cfg_tlx_function_actag_len_enab;
  cfg_tlx_afu_actag_base_d <= cfg_tlx_afu_actag_base;
  cfg_tlx_afu_actag_len_enab_d <= cfg_tlx_afu_actag_len_enab;
  cfg_tlx_pasid_base_d <= cfg_tlx_pasid_base;
  cfg_tlx_pasid_length_enabled_d <= cfg_tlx_pasid_length_enabled;

  afu_tlx_resp_initial_credit <= afu_tlx_resp_initial_credit_q;
  afu_tlx_resp_credit         <= afu_tlx_resp_credit_q;

  mmio_errrpt_xstop_err_d <= mmio_errrpt_xstop_err;
  mmio_errrpt_mchk_err_d <= mmio_errrpt_mchk_err;

  --------------------------------------------------------------------------------------------------
  -- process inputs
  --------------------------------------------------------------------------------------------------
  intrp_resp_val <= tlx_afu_resp_valid and (tlx_afu_resp_opcode=intrp_resp_opcode);
  intrp_resp_app_intrp <=  intrp_resp_val and (tlx_afu_resp_afutag=app_intrp_afutag);
  intrp_resp_chan_xstop <= intrp_resp_val and (tlx_afu_resp_afutag=xstop_afutag);
  xstop_intrp_pulse <= mmio_errrpt_xstop_err_d and not mmio_errrpt_xstop_err_q;
  app_intrp_pulse <= mmio_errrpt_mchk_err_d and not mmio_errrpt_mchk_err_q;

  intrp_resp_tag_err <= intrp_resp_val and (tlx_afu_resp_afutag/=xstop_afutag) and (tlx_afu_resp_afutag/=app_intrp_afutag);
  unsupported_resp_opcode <= tlx_afu_resp_valid and (tlx_afu_resp_opcode/=intrp_resp_opcode);
  unexpected_intrp_resp <= intrp_resp_val and ( (intrp_req_chan_xstop_q/="11") or  (intrp_req_app_intrp_q/="11"));

  --------------------------------------------------------------------------------------------------
  -- TLX-AFU credit control
  --------------------------------------------------------------------------------------------------

  --Command Credit counter.
  --Needed to send Interrupts and Assign AcTag commands
  cmd_credit_counter_d <= gate(tlx_afu_cmd_initial_credit,          not reset_n) OR
                          gate(cmd_credit_counter_q-1,                  reset_n and      (send_intrp_req or send_assign_actag) and not tlx_afu_cmd_credit) OR
                          gate(cmd_credit_counter_q+1,                  reset_n and not  (send_intrp_req or send_assign_actag) and     tlx_afu_cmd_credit) OR
                          gate(cmd_credit_counter_q,                    reset_n and not ((send_intrp_req or send_assign_actag) xor     tlx_afu_cmd_credit));

  cmd_credit_avail <= or_reduce(cmd_credit_counter_q);
  send_intrp_req <= send_intrp_req_chan_xstop or send_intrp_req_app_intrp;

  --Response Credit Counter
  --Given to TLX to send responses to AFU.
  afu_tlx_resp_initial_credit_d <= resp_init_cred;
  resp_credit_dec <= or_reduce(resp_credit_counter_q);
  afu_tlx_resp_credit_d <= resp_credit_dec;
  
  resp_credit_counter_d <= gate("0000000",                       not reset_n) OR
                           gate(resp_credit_counter_q+1,            reset_n and     tlx_afu_resp_valid and not resp_credit_dec) OR
                           gate(resp_credit_counter_q-1,            reset_n and not tlx_afu_resp_valid and     resp_credit_dec) OR
                           gate(resp_credit_counter_q,              reset_n and not (tlx_afu_resp_valid xor    resp_credit_dec));
  
  --------------------------------------------------------------------------------------------------
  -- assign actag Logic
  --------------------------------------------------------------------------------------------------

  pasid_enab <= or_reduce(cfg_tlx_pasid_length_enabled);
  actag_base_err <= (cfg_tlx_afu_actag_base/=cfg_tlx_function_actag_base);
  actag_len_enab_err <= (cfg_tlx_function_actag_len_enab/=cfg_tlx_afu_actag_len_enab) or (cfg_tlx_afu_actag_len_enab>x"001") or (cfg_tlx_function_actag_len_enab>x"001");

  assign_actag_enab <= not actag_len_enab_err and not actag_base_err and (cfg_tlx_afu_actag_len_enab=1);

  assign_actag_idle <= reset_n and
                          (
                            (assign_actag_sent_q="00") OR
                            ((assign_actag_sent_q="01") and not assign_actag_enab)
                          );
  assign_actag_pend <= reset_n and
                       (
                         ((assign_actag_sent_q="01") and assign_actag_enab) OR
                         ((assign_actag_sent_q="10") and (not cmd_credit_avail or afu_tlx_cmd_valid_q))
                       );
  assign_actag_send <= reset_n and
                       (
                         ((assign_actag_sent_q="10") and cmd_credit_avail and not afu_tlx_cmd_valid_q) OR
                         (assign_actag_sent_q="11")
                       );

  assign_actag_sent_d <= gate("00",             not reset_n) OR
                         gate("01",             assign_actag_idle) OR
                         gate("10",             assign_actag_pend) OR
                         gate("11",             assign_actag_send);

  assign_actag_sent <= (assign_actag_sent_q="11");

  send_assign_actag <= (assign_actag_sent_q="10") and cmd_credit_avail and not afu_tlx_cmd_valid_q;
  
  --------------------------------------------------------------------------------------------------
  --Channell Chesktop Interrupt FSM
  --------------------------------------------------------------------------------------------------
  
  intrp_req_chan_xstop_idle <= reset_n and
                               (
                                 ((intrp_req_chan_xstop_q="00") ) OR
                                 ((intrp_req_chan_xstop_q="11") and intrp_resp_chan_xstop) OR
                                 ((intrp_req_chan_xstop_q="01") and not xstop_intrp_pulse)
                               );

  intrp_req_chan_xstop_pend <= reset_n and
                               (
                                 ((intrp_req_chan_xstop_q="01") and xstop_intrp_pulse) OR
                                 ((intrp_req_chan_xstop_q="10") and (not cmd_credit_avail or afu_tlx_cmd_valid_q))
                               );

  intrp_req_chan_xstop_send <= reset_n and
                               (
                                 ((intrp_req_chan_xstop_q="10") and cmd_credit_avail and not afu_tlx_cmd_valid_q) OR
                                 ((intrp_req_chan_xstop_q="11") and not intrp_resp_chan_xstop)
                               );

  send_intrp_req_chan_xstop <= (intrp_req_chan_xstop_q="10") and cmd_credit_avail and not afu_tlx_cmd_valid_q; 
                                  
  intrp_req_chan_xstop_d (1 downto 0) <= gate("00",               not reset_n) or
                                         gate("01",               intrp_req_chan_xstop_idle) OR
                                         gate("10",               intrp_req_chan_xstop_pend) OR
                                         gate("11",               intrp_req_chan_xstop_send);

  --------------------------------------------------------------------------------------------------
  -- Application Interrupt FSM
  --------------------------------------------------------------------------------------------------
  
  intrp_req_app_intrp_idle <= reset_n and
                               (
                                 ((intrp_req_app_intrp_q="00")) OR
                                 ((intrp_req_app_intrp_q="11") and intrp_resp_app_intrp) OR
                                 ((intrp_req_app_intrp_q="01") and not app_intrp_pulse)
                               );

  intrp_req_app_intrp_pend <= reset_n and
                               (
                                 ((intrp_req_app_intrp_q="01") and app_intrp_pulse) OR
                                 ((intrp_req_app_intrp_q="10") and (not cmd_credit_avail or afu_tlx_cmd_valid_q or (intrp_req_chan_xstop_q="10")))
                               );

  intrp_req_app_intrp_send <= reset_n and
                               (
                                 ((intrp_req_app_intrp_q="10") and cmd_credit_avail and not afu_tlx_cmd_valid_q and (intrp_req_chan_xstop_q/="10")) OR
                                 ((intrp_req_app_intrp_q="11") and not intrp_resp_app_intrp)
                               );

  send_intrp_req_app_intrp <= (intrp_req_app_intrp_q="10") and cmd_credit_avail and not afu_tlx_cmd_valid_q and (intrp_req_chan_xstop_q/="10"); 
                                  
  intrp_req_app_intrp_d (1 downto 0) <= gate("00",               not reset_n ) or
                                        gate("01",               intrp_req_app_intrp_idle) OR
                                        gate("10",               intrp_req_app_intrp_pend) OR
                                        gate("11",               intrp_req_app_intrp_send);

  --------------------------------------------------------------------------------------------------
  --Output Control
  --------------------------------------------------------------------------------------------------
  afu_tlx_cmd_valid_d <= (send_assign_actag or send_intrp_req_chan_xstop or send_intrp_req_app_intrp);
  
  
    afu_tlx_cmd_opcode_d    <= gate(assign_actag_opcode,                send_assign_actag)OR
                               gate(intrp_req_opcode,                   send_intrp_req_chan_xstop) OR
                               gate(intrp_req_opcode,                   send_intrp_req_app_intrp);
  
    afu_tlx_cmd_actag_d     <= gate(cfg_tlx_afu_actag_base_q,           send_assign_actag) OR
                               gate(cfg_tlx_afu_actag_base_q,           send_intrp_req_chan_xstop) OR
                               gate(cfg_tlx_afu_actag_base_q,           send_intrp_req_app_intrp);
                               
    afu_tlx_cmd_pasid_d     <= gate(cfg_tlx_pasid_base_q,               send_assign_actag);
                               
    afu_tlx_cmd_bdf_d       <= gate("00000000" & device & func,         send_assign_actag); 
                               
    afu_tlx_cmd_afutag_d    <= gate(xstop_afutag,                       send_intrp_req_chan_xstop) OR
                               gate(app_intrp_afutag,                   send_intrp_req_app_intrp);
                               
    afu_tlx_cmd_ea_or_obj_d <= gate(mmio_errrpt_intrp_hdl_xstop_q,      send_intrp_req_chan_xstop) OR
                               gate(mmio_errrpt_intrp_hdl_app_q,        send_intrp_req_app_intrp);
                               
    afu_tlx_cmd_flag_d      <= gate(mmio_errrpt_cmd_flag_xstop_q,       send_intrp_req_chan_xstop) OR
                               gate(mmio_errrpt_cmd_flag_app_q,         send_intrp_req_app_intrp);
                              

  afu_tlx_cmd_valid     <= afu_tlx_cmd_valid_q;
  afu_tlx_cmd_opcode    <= afu_tlx_cmd_opcode_q;
  afu_tlx_cmd_actag     <= afu_tlx_cmd_actag_q;
  afu_tlx_cmd_pasid     <= afu_tlx_cmd_pasid_q;
  afu_tlx_cmd_bdf       <= afu_tlx_cmd_bdf_q;
  afu_tlx_cmd_afutag    <= afu_tlx_cmd_afutag_q;
  afu_tlx_cmd_ea_or_obj <= afu_tlx_cmd_ea_or_obj_q;
  afu_tlx_cmd_stream_id <= stream_id;
  afu_tlx_cmd_flag      <= afu_tlx_cmd_flag_q;

  err_rpt_dbg <= intrp_req_chan_xstop_q & intrp_req_app_intrp_q;


  
latches : process(clock_400mhz)
  begin
    if clock_400mhz'EVENT and clock_400mhz = '1' then
      if reset_n = '0' then
        mmio_errrpt_intrp_hdl_xstop_q <= (others => '0');
        mmio_errrpt_intrp_hdl_app_q   <= (others => '0');
        mmio_errrpt_cmd_flag_xstop_q  <= (others => '0');
        mmio_errrpt_cmd_flag_app_q    <= (others => '0');
        afu_tlx_resp_initial_credit_q <= resp_init_cred;
        afu_tlx_resp_credit_q         <= '0';
        afu_tlx_cmd_valid_q           <= '0';
        afu_tlx_cmd_opcode_q          <= (others => '0');
        afu_tlx_cmd_actag_q           <= (others => '0');
        afu_tlx_cmd_ea_or_obj_q       <= (others => '0');
        afu_tlx_cmd_afutag_q          <= (others => '0');
        afu_tlx_cmd_flag_q            <= (others => '0');
        afu_tlx_cmd_bdf_q             <= (others => '0');
        afu_tlx_cmd_pasid_q           <= (others => '0');
        intrp_req_chan_xstop_q        <= (others => '0');
        intrp_req_app_intrp_q         <= (others => '0');
        assign_actag_sent_q           <= (others => '0');
        cmd_credit_counter_q          <= tlx_afu_cmd_initial_credit;
        resp_credit_counter_q         <= (others => '0');
      else
        mmio_errrpt_intrp_hdl_xstop_q     <= mmio_errrpt_intrp_hdl_xstop_d;
        mmio_errrpt_intrp_hdl_app_q       <= mmio_errrpt_intrp_hdl_app_d;
        mmio_errrpt_cmd_flag_xstop_q      <= mmio_errrpt_cmd_flag_xstop_d;
        mmio_errrpt_cmd_flag_app_q        <= mmio_errrpt_cmd_flag_app_d;
        afu_tlx_resp_initial_credit_q     <= afu_tlx_resp_initial_credit_d;
        afu_tlx_resp_credit_q             <= afu_tlx_resp_credit_d;
        afu_tlx_cmd_valid_q               <= afu_tlx_cmd_valid_d;
        afu_tlx_cmd_opcode_q              <= afu_tlx_cmd_opcode_d;
        afu_tlx_cmd_actag_q               <= afu_tlx_cmd_actag_d;
        afu_tlx_cmd_ea_or_obj_q           <= afu_tlx_cmd_ea_or_obj_d;
        afu_tlx_cmd_afutag_q              <= afu_tlx_cmd_afutag_d;
        afu_tlx_cmd_flag_q                <= afu_tlx_cmd_flag_d;
        afu_tlx_cmd_bdf_q                 <= afu_tlx_cmd_bdf_d;
        afu_tlx_cmd_pasid_q               <= afu_tlx_cmd_pasid_d;
        cfg_tlx_pasid_length_enabled_q    <= cfg_tlx_pasid_length_enabled_d;
        cfg_tlx_pasid_base_q              <= cfg_tlx_pasid_base_d;
        cfg_tlx_afu_actag_len_enab_q      <= cfg_tlx_afu_actag_len_enab_d;
        cfg_tlx_afu_actag_base_q          <= cfg_tlx_afu_actag_base_d;
        cfg_tlx_function_actag_len_enab_q <= cfg_tlx_function_actag_len_enab_d;
        cfg_tlx_function_actag_base_q     <= cfg_tlx_function_actag_base_d;
        intrp_req_chan_xstop_q            <= intrp_req_chan_xstop_d;
        intrp_req_app_intrp_q             <= intrp_req_app_intrp_d;
        assign_actag_sent_q               <= assign_actag_sent_d;
        cmd_credit_counter_q              <= cmd_credit_counter_d;
        resp_credit_counter_q             <= resp_credit_counter_d;
        mmio_errrpt_mchk_err_q            <= mmio_errrpt_mchk_err_d;
        mmio_errrpt_xstop_err_q           <= mmio_errrpt_xstop_err_d;
      end if;
    end if;
end process;        

    
end ice_errrpt_intrp;
