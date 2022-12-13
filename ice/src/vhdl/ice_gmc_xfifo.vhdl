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

-- Async crossing Fifo

entity ice_gmc_xfifo is
generic(
  gM : boolean := TRUE; -- metastable pointer cross ?
  gS : natural := 9;
  gW : natural := 72;
  gA : string  := "BLOCK"  -- or Distributed.
);
port(
  i_reset  : in  std_ulogic;
  --
  i_wclk   : in  std_ulogic;
  i_push   : in  std_ulogic;
  i_data   : in  std_ulogic_vector(gW-1 downto 0);
  o_wfc    : out std_ulogic_vector(gS downto 0);
  o_wcap   : out std_ulogic_vector(gS downto 0);
  o_werror : out std_ulogic_vector(0 to 0);
  --
  i_rclk   : in  std_ulogic;
  i_pull   : in  std_ulogic;
  o_data   : out std_ulogic_vector(gW-1 downto 0);
  o_rfc    : out std_ulogic_vector(gS downto 0);
  o_rcap   : out std_ulogic_vector(gS downto 0);
  o_rerror : out std_ulogic_vector(0 to 0)
);
end ice_gmc_xfifo;

architecture ice_gmc_xfifo of ice_gmc_xfifo is
  signal rd_q, rd_d    : std_ulogic_vector(gW-1 downto 0);
  signal ra_q, ra_d    : std_ulogic_vector(gS downto 0);
  signal we_q, we_d    : std_ulogic;
  signal wd_q, wd_d    : std_ulogic_vector(gW-1 downto 0);
  signal wa_q, wa_d    : std_ulogic_vector(gS downto 0);
  signal xRa, xWa      : std_ulogic_vector(gS downto 0);
  signal ram_rdata     : std_ulogic_vector(gW-1 downto 0);
  signal rReset,wReset : std_ulogic;
  signal rcap, wcap    : std_ulogic_vector(gS downto 0);
begin


bWrite : block  ------------------------------------------
  signal xRa_q, xRa_d : std_ulogic_vector(gS downto 0);
  signal etrig : std_ulogic_vector(0 to 0);
begin
  wd_d <= i_data;
  we_d <= i_push;
  wa_d <= (others => '0') when wreset='1'
     else wa_q + we_q;

  xRa_d  <= xRa;
  o_wfc  <= xRa - xRa_q;
  wcap   <= wa_q - xRa_q;
  o_wcap <= wcap;

  etrig(0) <= wcap(gS) and or_reduce(wcap(gS-1 downto 0));

  ETRAP: entity work.ice_gmc_etrap
  port map(
    i_reset  => wreset
   ,i_clk    => i_wclk
   ,i_eTrig  => etrig
   ,o_error  => o_werror
  );



  pCLK : process
  begin
    wait until rising_edge(i_wclk);
    we_q  <= we_d;
    wd_q  <= wd_d;
    wa_q  <= wa_d;
    xRa_q <= xRa_d;
  end process;
end block;


gMtrue : if gM generate
------ BEGIN METASTABLE !!!!! -----------
 signal Meta_Ra_q, Meta_Ra_d : std_ulogic_vector(gS downto 0);
 signal Meta_Wa_q, Meta_Wa_d : std_ulogic_vector(gS downto 0);
 signal Meta_Ra, Meta_Wa     : std_ulogic_vector(gS downto 0);
begin
  -- metastabilize the resets.
  RMETAW : entity work.ice_gmc_asynclat
  port map(i_clk => i_wclk, i_data(0) => i_reset, o_data(0) => wreset);   -- @WCLK
  RMETAR: entity work.ice_gmc_asynclat
  port map(i_clk => i_rclk, i_data(0) => i_reset, o_data(0) => rreset);   -- @RCLK

  -- read address pointer to write side.
  Meta_Ra_d <= b2g(ra_q);   -- @RCLK
  pRCLK : process
  begin
     wait until rising_edge(i_rclk);
     Meta_Ra_q <= Meta_Ra_d;
  end process;
  RAMETA : entity work.ice_gmc_asynclat
  port map(i_clk => i_wclk, i_data => Meta_ra_q, o_data => Meta_Ra);
  xRa <= g2b(Meta_Ra);   -- @WCLK

  -- write address pointer to read side.
  Meta_Wa_d <= b2g(wa_q);   -- @WCLK
  pWCLK : process
  begin
     wait until rising_edge(i_wclk);
     Meta_Wa_q <= Meta_Wa_d;
  end process;
  WAMETA : entity work.ice_gmc_asynclat
  port map(i_clk => i_rclk, i_data => Meta_wa_q, o_data => Meta_Wa);
  xWa <= g2b(Meta_Wa);   -- @RCLK
end generate;
------ END METASTABLE -----------------

gMfalse : if not(gM) generate
  signal xWa_q : std_ulogic_vector(gS downto 0);
begin
  wreset <= i_reset;
  rreset <= i_reset;
  -- latch the cross pointers once to model the 1 cycle latency through the ram.
  pClk : process(all)
  begin
    if rising_edge(i_rclk) then xWa_q <= wa_q; end if; xWa <= xWa_q;
    -- using rclk to be consistant... in synchr mode, wclk=rclk
  end process;
  xRa <= ra_q; -- we used the ra_d on the ram, so relatching here is not needed.
  -- we use wa_q on the write side so the ram can be pushed far from the write side unit.
end generate;

----- Read --------------------------
bRead : block
  signal xWa_q, xWa_d       : std_ulogic_vector(gS downto 0);
  signal rAdv, rEmpty       : std_ulogic;
  signal pref_d, pref_q     : std_ulogic;  --- prefetch sm.
  signal etrig              : std_ulogic_vector(0 to 0);
begin

  rEmpty <= ra_q = xWa;
  rAdv   <= '0' when rEmpty='1'
       else '1' when i_pull='1'
       else not(pref_q);

  pref_d <= '0' when rreset='1'
       else '1' when rAdv='1'
       else '0' when i_pull='1'
       else pref_q;

  rd_d <= ram_rdata when rAdv='1' else rd_q;
  ra_d <= (others => '0') when rreset='1'
     else ra_q + rAdv;

  o_data <= rd_q;

  xWa_d  <= xWa;
  o_rfc  <= xWa - xWa_q;
  rcap   <= xWa_q - ra_q;
  o_rcap <= rcap;

  etrig(0) <= rcap(gS) and or_reduce(rcap(gS-1 downto 0));

  ETRAP: entity work.ice_gmc_etrap
  port map(
    i_reset  => rreset
   ,i_clk    => i_rclk
   ,i_eTrig  => etrig
   ,o_error  => o_rerror
  );

  pRCLK : process
  begin
    wait until rising_edge(i_rclk);
    pref_q   <= pref_d;
    xWa_q    <= xWa_d;
    rd_q     <= rd_d;
    ra_q     <= ra_d;
  end process;
end block;


RAM: entity work.ice_gmc_ram
generic map(
  gS => gS
 ,gW => gW
 ,gA => "BLOCK"
)
port map(
  i_wclk  => i_wclk
 ,i_waddr => wa_q(gS-1 downto 0)       -- all three relatched inside ram.
 ,i_we    => we_q
 ,i_wdata => wd_q
 ,i_rclk  => i_rclk
 ,i_raddr => ra_d(gS-1 downto 0)      -- latched inside ram.
 ,o_rdata => ram_rdata   -- in phase with ra_q.
);

end ice_gmc_xfifo;
