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
 


library ieee;
use ieee.std_logic_1164.all;
use work.ice_gmc_func_pkg.all;

entity ice_gmc_dpull is
port(
  i_clk   : in  std_ulogic;
  i_reset : in  std_ulogic;
  i_dp    : in  std_ulogic;   -- dataphase ?
  -- fifo interfaces,  rsp/data
  i_sfc   : in  std_ulogic_vector(9 downto 0);
  i_dfc   : in  std_ulogic_vector(9 downto 0);
  i_sdat  : in  std_ulogic_vector(17 downto 0);
  i_ddat  : in  std_ulogic_vector(575 downto 0);
  o_spull : out std_ulogic;
  o_dpull : out std_ulogic;
  -- arb intf
  o_req   : out std_ulogic;
  i_gnt   : in  std_ulogic;
  --
  o_rd_data  : out std_ulogic_vector(575 downto 0);
  o_rs_data  : out std_ulogic_vector(17 downto 0)
);
end ice_gmc_dpull;

architecture ice_gmc_dpull of ice_gmc_dpull is
  signal s0                 : std_ulogic_vector(0 to 11);
  signal s1                 : std_ulogic_vector(0 to 4);
  signal s_q,  s_d          : std_ulogic_vector(0 to 0);
  signal size               : std_ulogic;
  signal spull, dpull       : std_ulogic;
  signal rsp_cr_q, rsp_cr_d : std_ulogic_vector(i_sfc'range);
  signal dat_cr_q, dat_cr_d : std_ulogic_vector(i_dfc'range);
begin

size      <= i_sdat(16);
o_rd_data <= i_ddat;

s0(0)        <= s_q=0;
s0(1 to 2)   <= choice(s0(0), rsp_cr_q /= 0);
s0(3 to 4)   <= choice(s0(1), dat_cr_q /= 0);
s0(5 to 6)   <= choice(s0(3), size and not(i_dp));
s0(7 to 8)   <= choice(s0(6), i_gnt);
s0(9)        <= s0(5) or s0(7);
s0(10 to 11) <= choice(s0(9), size);

s1(0)      <= s_q=1;
s1(1 to 2) <= choice(s1(0), dat_cr_q /= 0);
s1(3 to 4) <= choice(s1(1), i_gnt);

s_d(0) <= '0' when i_reset='1'
     else s0(10) or s1(2) or s1(4);

o_req <= s0(6) or s1(1);

spull <= s0(11) or s1(3);  -- defer pull to keep tag out on 2beat transfer.
dpull <= s0(9)  or s1(3);  -- pull each beat.

o_spull   <= spull;
o_dpull   <= dpull;

o_rs_data(15 downto 0) <= i_sdat(15 downto 0);
o_rs_data(16) <= size;
o_rs_data(17) <= s1(0);     -- offs.

rsp_cr_d <= (others => '0') when i_reset='1'
       else crAdj(rsp_cr_q, i_sfc, '0' & spull);

dat_cr_d <= (others => '0') when i_reset='1'
       else crAdj(dat_cr_q, i_dfc, '0' & dpull);


pLatch:process
begin
  wait until rising_edge(i_clk);
  rsp_cr_q <= rsp_cr_d;
  dat_cr_q <= dat_cr_d;
  s_q      <= s_d;
end process;


end ice_gmc_dpull;
