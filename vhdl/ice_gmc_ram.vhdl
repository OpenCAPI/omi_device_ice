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

entity ice_gmc_ram is
generic(
  gS : natural := 5;
  gW : natural := 64;
  gA : string  := "BLOCK"  -- or Distributed.
);
port(
  i_wclk  : in  std_ulogic;
  i_waddr : in  std_ulogic_vector(gS-1 downto 0);
  i_we    : in  std_ulogic;
  i_wdata : in  std_ulogic_vector(gW-1 downto 0);
  i_rclk  : in  std_ulogic;
  i_raddr : in  std_ulogic_vector(gS-1 downto 0);
  i_rden  : in  std_ulogic := '1';
  i_rdmsk : in  std_ulogic := '0';
  o_rdata : out std_ulogic_vector(gW-1 downto 0)
);
end ice_gmc_ram;

architecture ice_gmc_ram of ice_gmc_ram is
  type texsim_array_update_policy is (RW, WR);
  attribute array_update       : texsim_array_update_policy;
  attribute ram_style  : string;

  type mem_t is array(0 to 2**gS-1) of std_ulogic_vector(gW-1 downto 0);
  signal MEM_q : mem_t;
  signal rdata_q : std_ulogic_vector(o_rdata'range);
  attribute array_update of MEM_Q : signal is RW; -- never WR when a signal
  attribute ram_style of mem_q : signal is gA;
begin

pw:process
begin
  wait until rising_edge(i_wclk);
  if i_we='1'   then MEM_q(tconv(i_waddr)) <= i_wdata; end if;
end process;

pr:process
begin
  wait until rising_edge(i_rclk);
  if i_rden='1' then rdata_q <= MEM_q(tconv(i_raddr)); end if;
end process;

o_rdata <= rdata_q when i_rdmsk='0' else (others => '0');


end ice_gmc_ram;
