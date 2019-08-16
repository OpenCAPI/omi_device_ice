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

ENTITY ice_cal_retry IS
  PORT
    (
      clock                         : IN  STD_ULOGIC;
      force_recal                   : IN  STD_ULOGIC;
      auto_recal_disable            : IN  STD_ULOGIC;
      mig_reset_n                   : IN  STD_ULOGIC;
      c0_init_calib_complete        : IN  STD_ULOGIC;
      c1_init_calib_complete        : IN  STD_ULOGIC;
      o_init_calib_complete         : OUT STD_ULOGIC_VECTOR(1 DOWNTO 0);
      cal_retry_cnt                 : out STD_ULOGIC_VECTOR(7 DOWNTO 0);
      cal_reset_n                   : out STD_ULOGIC

      );
END ice_cal_retry;

ARCHITECTURE ice_cal_retry OF ice_cal_retry IS
  signal cal_good_d : STD_ULOGIC;
  signal cal_good_q : STD_ULOGIC;
  signal cal_good_dly_d : STD_ULOGIC_VECTOR(3 DOWNTO 0);
  signal cal_good_dly_q : STD_ULOGIC_VECTOR(3 DOWNTO 0);
  signal init_calib_complete : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  signal cal_resetn_d : STD_ULOGIC;
  signal cal_resetn_q : STD_ULOGIC := '1';
  signal resetn_sync_400mhz : STD_ULOGIC;
  signal count_q : STD_ULOGIC_VECTOR(29 DOWNTO 0);
  signal retry_cnt_q : STD_ULOGIC_VECTOR(7 DOWNTO 0);
  signal i_init_calib_complete         : STD_ULOGIC_VECTOR(1 DOWNTO 0);

  attribute mark_debug                : string;
  attribute mark_debug of  cal_resetn_q              : signal is "true";
  attribute mark_debug of  init_calib_complete       : signal is "true";
  attribute mark_debug of  resetn_sync_400mhz        : signal is "true";
  attribute mark_debug of  retry_cnt_q               : signal is "true";
  attribute mark_debug of  count_q                   : signal is "true";

BEGIN

  cal_reset_n               <= cal_resetn_q;
  cal_retry_cnt             <= retry_cnt_q;
  i_init_calib_complete     <= c0_init_calib_complete & c1_init_calib_complete;
  o_init_calib_complete     <= init_calib_complete;

  cal_sync : ENTITY work.ice_gmc_asynclat
      PORT MAP (
         i_clk       => clock,
         i_data      => i_init_calib_complete(1 DOWNTO 0),
         o_data      => init_calib_complete(1 DOWNTO 0));

  reset_sync : ENTITY work.ice_gmc_asynclat
      PORT MAP (
         i_clk          => clock,
         i_data(0)      => mig_reset_n,
         o_data(0)      => resetn_sync_400mhz);

   cal_good_d <= init_calib_complete(1) AND init_calib_complete(0);

   cal_resetn_d <= (count_q(29 DOWNTO 6) /= x"FFFFFF") AND NOT force_recal;

  process (clock)
  begin
    if clock'event and clock = '1' then

      if resetn_sync_400mhz = '0' OR cal_good_q = '1' OR force_recal = '1' OR auto_recal_disable = '1' then
        count_q <= (OTHERS => '0');
      elsif cal_good_q = '0' then
         count_q <= count_q + 1;
      end if;

      if resetn_sync_400mhz = '0' then
         retry_cnt_q <= x"00";
      elsif cal_resetn_d = '1' AND cal_resetn_q = '0' AND retry_cnt_q /= x"FF" then
         retry_cnt_q <= retry_cnt_q + 1;
      END if;

      cal_good_q       <= cal_good_d;
      cal_resetn_q     <= cal_resetn_d;
     end if;
  end process;

END ice_cal_retry;
