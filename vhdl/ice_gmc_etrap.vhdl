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

entity ice_gmc_etrap is
port(
  i_reset  : in  std_ulogic;
  i_clk    : in  std_ulogic;
  i_eTrig  : in  std_ulogic_vector;
  o_error  : out std_ulogic_vector
);
end ice_gmc_etrap;

architecture ice_gmc_etrap of ice_gmc_etrap is
  signal err_q : std_ulogic_vector(i_eTrig'range);
begin

pError: process
begin
  wait until rising_edge(i_clk);
  if i_reset='1' then err_q <= (others => '0');
  else err_q <= i_eTrig;
  end if;
end process;
o_error <= err_q;

assert err_q=0 or i_reset='1'
report "error assert " & tconv(err_q,0)  severity error;

end ice_gmc_etrap;
