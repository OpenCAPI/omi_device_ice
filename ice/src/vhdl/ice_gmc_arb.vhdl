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

-- N input round robin arbiter with weights.
-- if win with priority,  priority is held until weight expires.

entity ice_gmc_arb is
generic(
  gN : natural := 4;   -- number of requesters
  gS : natural := 2    -- size of weight (log2)
);
port(
  i_clk   : in  std_ulogic;
  i_reset : in  std_ulogic;
  i_yield : in  std_ulogic_vector(0 to gN-1) := (others => '0');
  i_req   : in  std_ulogic_vector(0 to gN-1);
  i_wt    : in  std_ulogic_vector(0 to gS*gN-1) := (others => '0');
  i_en    : in  std_ulogic := '1';
  o_win   : out std_ulogic_vector(0 to gN-1)
);
end ice_gmc_arb;

architecture ice_gmc_arb of ice_gmc_arb is
  type wt_v is array(natural range <>) of std_ulogic_vector(1 downto 0);
  signal wt_d, wt_q  : wt_v(0 to gN-1);
  signal win_d, win_q : std_ulogic_vector(0 to gN-1);
  signal pri_d, pri_q : std_ulogic_vector(0 to gN-1);
  signal req : std_ulogic_vector(0 to gN-1);
begin

req <= i_req and not(win_q) and not(i_yield);

o_win <= win_q;

pArb : process(all)
  variable np : std_ulogic;  -- next priority
begin

  wt_d  <= wt_q;
  win_d <= RRarb(req,pri_q);
  pri_d <= pri_q;
  np := '0';

  if i_reset='1' then
    pri_d <= (others => '0'); pri_d(0) <='1';
    win_d <= (others => '0');
    for i in 0 to gS-1 loop
      wt_d(i) <= i_wt(gS*i to gS*(i+1)-1);
    end loop;
  elsif req=0 then win_d <= (others => '0');
  else for i in 0 to gN-1 loop
    if win_d(i)='1' and pri_q(i)='1' then
       if wt_q(i)=0 then
         wt_d(i) <= i_wt(2*i to 2*i+1);
         np:='1';
       else
         wt_d(i) <= wt_q(i)-1;
       end if;
    else
      np:='1';
    end if;
  end loop;
  end if;
  if np='1' then pri_d <= pri_q rol 1; end if;
  -- note.. due to a severe timing restriction in the placement of the arrays
  -- there will be a gap between consequtive requests from the same source
  -- due to the latch delay of  win_q.
end process;

pLatch:process
begin
  wait until rising_edge(i_clk);
     win_q <= win_d;
     if i_en='1' or i_reset='1' then
       pri_q <= pri_d;
       wt_q  <= wt_d;
     end if;
end process;


end ice_gmc_arb;
