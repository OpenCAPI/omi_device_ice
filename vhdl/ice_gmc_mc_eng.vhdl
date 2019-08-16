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

-- async fifo interface into Memory controller slice.

entity ice_gmc_mc_eng is
port(
  i_mclk              : in  std_ulogic;
  i_hclk              : in  std_ulogic;
  i_reset             : in  std_ulogic;
  o_idle              : out std_ulogic_vector(0 to 0);
  -- cfg
  i_addr_inc          : in  std_ulogic_vector(30 downto 3) := tconv(1,28);
  -- xmc application interface
  o_app_addr          : out std_ulogic_vector(30 downto 0);
  o_app_cmd           : out std_ulogic_vector(2 downto 0);
  o_app_en            : out std_ulogic;
  i_app_rdy           : in  std_ulogic;
  --
  o_app_wdf_end       : out std_ulogic;
  o_app_wdf_wren      : out std_ulogic;
  i_app_wdf_rdy       : in  std_ulogic;
  o_app_wdf_data      : out std_ulogic_vector(575 downto 0);
  --
  i_app_rd_data_end   : in  std_ulogic;
  i_app_rd_data_valid : in  std_ulogic;
  i_app_rd_data       : in  std_ulogic_vector(575 downto 0);
  -- Write Data  (from host)
  i_wd_push           : in  std_ulogic;
  i_wd_data           : in  std_ulogic_vector(575 downto 0);
  o_wd_wfc            : out std_ulogic_vector(9 downto 0);
  -- Command (from host)
  i_cm_push           : in  std_ulogic;
  i_cm_data           : in  std_ulogic_vector(47 downto 0);
  o_cm_wfc            : out std_ulogic_vector(9  downto 0);
  -- Read Data  ( to Host)
  i_rd_pull           : in  std_ulogic;
  o_rd_data           : out std_ulogic_vector(575 downto 0);
  o_rd_rfc            : out std_ulogic_vector(9 downto 0);
  -- Read  Rsp  ( to Host)
  i_rs_pull           : in  std_ulogic;
  o_rs_data           : out std_ulogic_vector(17 downto 0);
  o_rs_rfc            : out std_ulogic_vector(9 downto 0);
  -- Write Rsp  ( to Host)
  i_ws_pull           : in  std_ulogic;
  o_ws_data           : out std_ulogic_vector(17 downto 0);
  o_ws_rfc            : out std_ulogic_vector(9 downto 0);
  o_fifo_err          : out std_ulogic_vector(0 to 9)
);
end ice_gmc_mc_eng;

architecture ice_gmc_mc_eng of ice_gmc_mc_eng is
  function rSize(a: std_ulogic; en: std_ulogic :='1') return std_ulogic_vector is
    variable z : std_ulogic_vector(1 downto 0);
  begin
    if en='0'   then z:="00";
    elsif a='0' then z:="01";
    else             z:="10";
    end if;
    return z;
  end function;

  attribute mark_debug               : string;

  signal wd_pull  : std_ulogic;
  signal wd_data  : std_ulogic_vector(i_wd_data'range);
  signal wd_rfc   : std_ulogic_vector(o_wd_wfc'range);
  signal cm_pull  : std_ulogic;
  signal cm_data  : std_ulogic_vector(i_cm_data'range);
  signal cm_rfc   : std_ulogic_vector(o_cm_wfc'range);
  signal rd_push  : std_ulogic;
  signal rd_data  : std_ulogic_vector(o_rd_data'range);
  signal rd_wfc   : std_ulogic_vector(o_rd_rfc'range);
  signal rs_push  : std_ulogic;
  signal rs_data  : std_ulogic_vector(o_rs_data'range);
  signal rs_wfc   : std_ulogic_vector(o_rs_rfc'range);
  signal ws_push  : std_ulogic;
  signal ws_data  : std_ulogic_vector(o_ws_data'range);
  signal ws_wfc   : std_ulogic_vector(o_ws_rfc'range);
  --
  signal cm_rw   : std_ulogic;
  signal cm_size : std_ulogic;
  signal cm_addr : std_ulogic_vector(30 downto 3);
  signal cm_tag  : std_ulogic_vector(15 downto 0);
  signal rs_size  : std_ulogic;
  signal rs_tag   : std_ulogic_vector(15 downto 0);
  signal ws_size  : std_ulogic;
  signal ws_tag   : std_ulogic_vector(15 downto 0);
  --
  signal fifo_err_mclk : std_ulogic_vector(0 to 4);
  signal fifo_err_hclk : std_ulogic_vector(0 to 9);
  signal anyCmd, anyRoom : std_ulogic;
  signal wValid, rValid  : std_ulogic;
  signal size_d, size_q  : std_ulogic;
  signal offs_d, offs_q  : std_ulogic;

  signal s0       : std_ulogic_vector(0 to 5);
  signal s1       : std_ulogic_vector(0 to 4);
  signal s_d, s_q : std_ulogic_vector(0 to 0);
  -- credit
  signal rs_cr_d, rs_cr_q     : std_ulogic_vector(o_rs_rfc'range);
  signal ws_cr_d, ws_cr_q     : std_ulogic_vector(o_ws_rfc'range);
  signal rd_cr_d, rd_cr_q     : std_ulogic_vector(o_rd_rfc'range);
  signal wd_cr_d, wd_cr_q     : std_ulogic_vector(o_wd_wfc'range);
  signal cm_cr_d, cm_cr_q     : std_ulogic_vector(o_cm_wfc'range);
  signal wpnd_cr_d, wpnd_cr_q : std_ulogic_vector(o_wd_wfc'range);
  signal rpnd_cr_d, rpnd_cr_q : std_ulogic_vector(o_rd_rfc'range);
  -- app intf
  signal app_addr_d, app_addr_q   : std_ulogic_vector(30 downto 3);
  signal app_cmd_d, app_cmd_q     : std_ulogic_vector(o_app_cmd'range);
  signal app_en_d, app_en_q       : std_ulogic;
  signal app_data_wv, app_data_rv : std_ulogic;
  signal bogus                    : std_ulogic;
  signal idle_mclk_d, idle_mclk_q : std_ulogic_vector(0 to 0);

  attribute mark_debug of app_addr_q : signal is "true";
  attribute mark_debug of app_cmd_q  : signal is "true";
  attribute mark_debug of app_en_q   : signal is "true";
  attribute mark_debug of rs_cr_q    : signal is "true";
  attribute mark_debug of ws_cr_q    : signal is "true";
  attribute mark_debug of rd_cr_q    : signal is "true";
  attribute mark_debug of wd_cr_q    : signal is "true";
  attribute mark_debug of cm_cr_q    : signal is "true";
  attribute mark_debug of cm_data    : signal is "true"; -- this is a latch

  -- debug only.
  signal dbg_app_rdy_q            : std_ulogic;
  signal dbg_app_rd_data_valid_q  : std_ulogic;
  signal dbg_app_wdf_rdy_q        : std_ulogic;
  signal dbg_data_wv_q            : std_ulogic;
  signal dbg_data_rv_q            : std_ulogic;
  signal dbg_data_wdat_q          : std_ulogic_vector(7 downto 0);
  signal dbg_data_rdat_q          : std_ulogic_vector(7 downto 0);

  attribute mark_debug of dbg_app_rdy_q           : signal is "true";
  attribute mark_debug of dbg_app_rd_data_valid_q : signal is "true";
  attribute mark_debug of dbg_app_wdf_rdy_q       : signal is "true";
  attribute mark_debug of dbg_data_wv_q           : signal is "true";
  attribute mark_debug of dbg_data_rv_q           : signal is "true";
  attribute mark_debug of dbg_data_wdat_q         : signal is "true";
  attribute mark_debug of dbg_data_rdat_q         : signal is "true";

begin


anyCmd <= cm_cr_q /= 0;

bCheckRoom: block
  signal rsp       : std_ulogic_vector( ws_cr_q'range);
  signal dcr,pnd,z : std_ulogic_vector( wd_cr_q'range);
begin
  rsp <= Mux2(cm_rw, ws_cr_q, rs_cr_q);
  dcr <= Mux2(cm_rw, wd_cr_q, rd_cr_q);
  pnd <= Mux2(cm_rw, wpnd_cr_q, rpnd_cr_q);
  z   <= dcr - pnd;
  anyRoom <= '0' when rsp=0
        else '1' when cm_size='0' and z/=0
        else '1' when cm_size='1' and (z srl 1) /= 0
        else '0';
end block;


pDebugger : process
begin
  wait until rising_edge(i_mclk);
  dbg_app_rdy_q           <= i_app_rdy;
  dbg_app_rd_data_valid_q <= i_app_rd_data_valid;
  dbg_app_wdf_rdy_q       <= i_app_wdf_rdy;
  dbg_data_wv_q           <= app_data_wv;
  dbg_data_rv_q           <= app_data_rv;
  dbg_data_wdat_q         <= wd_data(7 downto 0);
  dbg_data_rdat_q         <= i_app_rd_data(7 downto 0);
end process;



-- command sm

s0(0)      <= s_q=0;
s0(1)      <= s0(0) or s1(4);
s0(2 to 3) <= choice(s0(1), anyCmd);
s0(4 to 5) <= choice(s0(2), anyRoom);

(wValid,rValid) <= choice(s0(4), cm_rw);

s1(0)      <= s_q=1;
s1(1 to 2) <= choice(s1(0), i_app_rdy);
s1(3 to 4) <= choice(s1(1), size_q);

s_d(0) <= '0' when i_reset='1'
     else s0(4) or s1(2) or s1(3);

app_en_d  <= s0(4) or s1(2) or s1(3);
app_cmd_d <= "00" & not(cm_rw) when s0(2)='1'
        else app_cmd_q;

app_addr_d <= cm_addr when s0(2)='1'
         else app_addr_q + i_addr_inc when s1(3)='1'
         else app_addr_q;

size_d <= cm_size when s0(2)='1'
     else '0'     when s1(1)='1'   -- -1 really...
     else size_q;

offs_d <= '0' when s0(2)='1'
     else '1' when s1(3)='1'
     else offs_q;


o_app_addr(30 downto 3) <= app_addr_q;
o_app_addr(2 downto 0)  <= "000";
o_app_en   <= app_en_q;
o_app_cmd  <= app_cmd_q;
cm_pull    <= s0(4);

rs_tag  <= cm_tag;
rs_size <= cm_size; -- need to know how much to pull later.
rs_push <= rValid;

ws_tag  <= cm_tag;
ws_size <= cm_size; -- need to know to defer credit to the last pull
ws_push <= wValid;


-- credit in flight between cmd and data phases.
wpnd_cr_d <= (others => '0') when i_reset='1'
  else crAdj(wpnd_cr_q, rSize(cm_size, wValid), '0' & wd_pull );

rpnd_cr_d <= (others => '0') when i_reset='1'
  else crAdj(rpnd_cr_q, rSize(cm_size, rValid), '0' & rd_push );

cm_cr_d <= (others => '0') when i_reset='1'
      else crAdj(cm_cr_q, cm_rfc, '0' & s0(4));

wd_cr_d <= (others => '0') when i_reset='1'
      else crAdj(wd_cr_q, wd_rfc,  '0' & wd_pull);

rs_cr_d <= tconv(2**rs_wfc'left,rs_wfc'length) when i_reset='1'
      else crAdj(rs_cr_q, rs_wfc,  '0' & rValid);

ws_cr_d <= tconv(2**ws_wfc'left,ws_wfc'length) when i_reset='1'
      else crAdj(ws_cr_q, ws_wfc,  '0' & wValid);

rd_cr_d <= tconv(2**rd_wfc'left,rd_wfc'length) when i_reset='1'
      else crAdj(rd_cr_q, rd_wfc,  '0' & rd_push);


idle_mclk_d(0) <= wpnd_cr_q=0 and rpnd_cr_q=0 and cm_cr_q=0;

-- data phases.
gDSM: for i in 0 to 1 generate  -- r, w
  signal s : std_ulogic_vector(0 to 1);
  signal anydata : std_ulogic_vector(wpnd_cr_q'range);
  signal valid   : std_ulogic;
begin

  anyData <= wpnd_cr_q     when i=1 else rpnd_cr_q;
  valid   <= i_app_wdf_rdy when i=1 else i_app_rd_data_valid;

  s(0) <= (anyData /= 0);
  s(1) <= s(0) and valid;
  g0:if i=0 generate
    app_data_rv <= s(0);
    rd_push <= s(1);
  end generate;
  g1:if i=1 generate
    app_data_wv  <= s(0);
    wd_pull  <= s(1);
  end generate;
end generate;

o_app_wdf_wren <= app_data_wv;
o_app_wdf_end  <= app_data_wv;
o_app_wdf_data <= wd_data;

rd_data <= i_app_rd_data;

bogus <= or_reduce( cm_data(31) & cm_data(2) & s0(3) & s0(5) & i_app_rd_data_end );

-- latches

pMCLK : process
begin
  wait until rising_edge(i_mclk);
  s_q         <= s_d ;
  ws_cr_q     <= ws_cr_d ;
  wd_cr_q     <= wd_cr_d ;
  rs_cr_q     <= rs_cr_d ;
  rd_cr_q     <= rd_cr_d ;
  cm_cr_q     <= cm_cr_d ;
  size_q      <= size_d ;
  offs_q      <= offs_d ;
  app_addr_q  <= app_addr_d ;
  wpnd_cr_q   <= wpnd_cr_d ;
  rpnd_cr_q   <= rpnd_cr_d ;
  app_en_q    <= app_en_d ;
  app_cmd_q   <= app_cmd_d ;
  idle_mclk_q <= idle_mclk_d;
end process;


FIFOERRXLAT: entity work.ice_gmc_asynclat
port map(
  i_clk  =>  i_hclk
 ,i_data =>  fifo_err_mclk
 ,o_data =>  fifo_err_hclk(5 to 9)
);

o_fifo_err <= fifo_err_hclk;

IDLEXLAT: entity work.ice_gmc_asynclat
port map(
  i_clk  =>  i_hclk
 ,i_data =>  idle_mclk_q(0 to 0)
 ,o_data =>  o_idle(0 to 0)
);

----------------------- Array Instantiations --------------------------

WD_XFIFO: entity work.ice_gmc_xfifo
generic map(
  gM => TRUE
 ,gS => 9
 ,gW => 576
 ,gA => "BLOCK"
)
port map(
  i_reset  => i_reset
 ,i_wclk   => i_hclk
 ,i_push   => i_wd_push
 ,i_data   => i_wd_data
 ,o_wfc    => o_wd_wfc
 ,o_werror => fifo_err_hclk(0 to 0)
 ,i_rclk   => i_mclk
 ,i_pull   => wd_pull
 ,o_data   => wd_data
 ,o_rfc    => wd_rfc
 ,o_rerror => fifo_err_mclk(0 to 0)
);

CM_XFIFO: entity work.ice_gmc_xfifo
generic map(
  gM => TRUE
 ,gS => 9
 ,gW => 48
 ,gA => "BLOCK"
)
port map(
  i_reset  => i_reset
 ,i_wclk   => i_hclk
 ,i_push   => i_cm_push
 ,i_data   => i_cm_data
 ,o_wfc    => o_cm_wfc
 ,o_werror => fifo_err_hclk(1 to 1)
 ,i_rclk   => i_mclk
 ,i_pull   => cm_pull
 ,o_data   => cm_data   -- expand below.
 ,o_rfc    => cm_rfc
 ,o_rerror => fifo_err_mclk(1 to 1)
);
cm_rw                <= cm_data(0);             -- 1 is write.
cm_size              <= cm_data(1);             -- 0 is 1 beat, 1 is two beats
cm_addr(30 downto 3) <= cm_data(30 downto 3);   -- 4:3 is bg, 6:5 is ba.  see spec for rest.
cm_tag               <= cm_data(47 downto 32);  -- there is no format to this.


RD_XFIFO: entity work.ice_gmc_xfifo
generic map(
  gM => TRUE
 ,gS => 9
 ,gW => 576
 ,gA => "BLOCK"
)
port map(
  i_reset  => i_reset
 ,i_wclk   => i_mclk
 ,i_push   => rd_push
 ,i_data   => rd_data
 ,o_wfc    => rd_wfc
 ,o_werror => fifo_err_mclk(2 to 2)
 ,i_rclk   => i_hclk
 ,i_pull   => i_rd_pull
 ,o_data   => o_rd_data
 ,o_rfc    => o_rd_rfc
 ,o_rerror => fifo_err_hclk(2 to 2)
);

RS_XFIFO: entity work.ice_gmc_xfifo
generic map(
  gM => TRUE
 ,gS => 9
 ,gW => 18
 ,gA => "BLOCK"
)
port map(
  i_reset  => i_reset
 ,i_wclk   => i_mclk
 ,i_push   => rs_push
 ,i_data   => rs_data    -- expand below.
 ,o_wfc    => rs_wfc
 ,o_werror => fifo_err_mclk(3 to 3)
 ,i_rclk   => i_hclk
 ,i_pull   => i_rs_pull
 ,o_data   => o_rs_data
 ,o_rfc    => o_rs_rfc
 ,o_rerror => fifo_err_hclk(3 to 3)
);
rs_data(17)          <= '0';
rs_data(16)          <= rs_size;
rs_data(15 downto 0) <= rs_tag;

WS_XFIFO: entity work.ice_gmc_xfifo
generic map(
  gM => TRUE
 ,gS => 9
 ,gW => 18
 ,gA => "BLOCK"
)
port map(
  i_reset  => i_reset
 ,i_wclk   => i_mclk
 ,i_push   => ws_push
 ,i_data   => ws_data  -- expand below.
 ,o_wfc    => ws_wfc
 ,o_werror => fifo_err_mclk(4 to 4)
 ,i_rclk   => i_hclk
 ,i_pull   => i_ws_pull
 ,o_data   => o_ws_data
 ,o_rfc    => o_ws_rfc
 ,o_rerror => fifo_err_hclk(4 to 4)
);
ws_data(17)          <= '0';
ws_data(16)          <= ws_size;
ws_data(15 downto 0) <= ws_tag;


end ice_gmc_mc_eng;
