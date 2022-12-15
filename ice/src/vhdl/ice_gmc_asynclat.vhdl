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


entity ice_gmc_asynclat is
port(
  i_clk  : in  std_ulogic;
  i_data : in  std_ulogic_vector;
  o_data : out std_ulogic_vector
);
end ice_gmc_asynclat;

architecture ice_gmc_asynclat of ice_gmc_asynclat is
  attribute async_reg : string;
  signal meta_1q, meta_2q : std_ulogic_vector(i_data'range);
  attribute async_reg of meta_1q : signal is "TRUE";
  attribute async_reg of meta_2q : signal is "TRUE";
begin

pw:process
begin
  wait until rising_edge(i_clk);
  meta_1q <= i_data;
  meta_2q <= meta_1q;
end process;

o_data <= meta_2q;

end ice_gmc_asynclat;
