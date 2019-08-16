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

entity ice_gmc_top is
port(
  i_mclk                          : in  std_ulogic_vector(1 downto 0);
  i_mc_reset                      : in  std_ulogic_vector(1 downto 0);  -- mc domain reset
  i_hclk                          : in  std_ulogic;
  i_reset                         : in  std_ulogic;        -- host domain reset.
  o_idle                          : out std_ulogic_vector(1 downto 0);   --@hclk
  -- static configuration
  i_arbwt                         : in  std_ulogic_vector(7 downto 0) := (others => '0');  -- 3,2,1,0
  i_yield                         : in  std_ulogic_vector(1 downto 0);
  -- host interface.
  i_cmd_valid                     : in  std_ulogic;
  i_cmd_rw                        : in  std_ulogic;                      -- 1=write.
  i_cmd_addr                      : in  std_ulogic_vector(31 downto 3);
  i_cmd_tag                       : in  std_ulogic_vector(15 downto 0);
  i_cmd_size                      : in  std_ulogic;                      -- 0:64B, 1:128B
  i_wvalid                        : in  std_ulogic_vector(1 downto 0);   -- p1, p0.
  i_wdata                         : in  std_ulogic_vector(511 downto 0);
  i_wmeta                         : in  std_ulogic_vector(39 downto 0);
  -- response merge.
  o_cmd_fc                        : out std_ulogic_vector(3 downto 0);   -- r1, r0, w1, w0
  o_rsp_tag                       : out std_ulogic_vector(15 downto 0);
  o_rsp_offs                      : out std_ulogic;
  o_rsp_data                      : out std_ulogic_vector(511 downto 0);
  o_rsp_meta                      : out std_ulogic_vector(39 downto 0);
  o_rsp_size                      : out std_ulogic;
  o_rsp_perr                      : out std_ulogic_vector(23 downto 0);
  -- connect this part to the xilinx mc
  -- port 0
  i_ddr0_mc0_app_rdy              : in  std_ulogic;
  i_ddr0_mc0_app_wdf_rdy          : in  std_ulogic;
  i_ddr0_mc0_app_rd_data_end      : in  std_ulogic;
  i_ddr0_mc0_app_rd_data_valid    : in  std_ulogic;
  i_ddr0_mc0_app_rd_data          : in  std_ulogic_vector(575 downto 0);
  o_mc0_ddr0_addr                 : out std_ulogic_vector(30 downto 0);
  o_mc0_ddr0_cmd                  : out std_ulogic_vector(2 downto 0);
  o_mc0_ddr0_en                   : out std_ulogic;
  o_mc0_ddr0_wdf_end              : out std_ulogic;
  o_mc0_ddr0_wdf_wren             : out std_ulogic;
  o_mc0_ddr0_wdf_data             : out std_ulogic_vector(575 downto 0);
  o_mc0_fifo_err                  : out std_ulogic_vector(9 downto 0);     -- @hclk
  -- port 1
  i_ddr1_mc1_app_rdy              : in  std_ulogic;
  i_ddr1_mc1_app_wdf_rdy          : in  std_ulogic;
  i_ddr1_mc1_app_rd_data_end      : in  std_ulogic;
  i_ddr1_mc1_app_rd_data_valid    : in  std_ulogic;
  i_ddr1_mc1_app_rd_data          : in  std_ulogic_vector(575 downto 0);
  o_mc1_ddr1_addr                 : out std_ulogic_vector(30 downto 0);
  o_mc1_ddr1_cmd                  : out std_ulogic_vector(2 downto 0);
  o_mc1_ddr1_en                   : out std_ulogic;
  o_mc1_ddr1_wdf_end              : out std_ulogic;
  o_mc1_ddr1_wdf_wren             : out std_ulogic;
  o_mc1_ddr1_wdf_data             : out std_ulogic_vector(575 downto 0);
  o_mc1_fifo_err                  : out std_ulogic_vector(9 downto 0)      -- @hclk
);
end ice_gmc_top;

architecture ice_gmc_top of ice_gmc_top is
  type pcube_v is array(0 to 7, 0 to 7, 0 to 7) of std_ulogic;

  function parity3d (d_in : std_ulogic_vector) return std_ulogic_vector is
    variable a : pcube_v;
    variable d : std_ulogic_vector(0 to 511);
    variable z : std_ulogic_vector(23 downto 0);
    variable line_p, chip_p, pin_p : std_ulogic_vector(0 to 7);
  begin
    d := d_in;
    -- arrange 64B in a 8x8x8 cube.
    for L in 0 to 7 loop         --Line
      for C in 0 to 7 loop       --Chip
        for P in 0 to 7 loop     --Pin
          a(L,C,P) := d(64*L+8*C+P);
        end loop;
      end loop;
    end loop;
    -- take even parity of every plane.
    for x in 0 to 7 loop
      line_p(x) := '0';
      chip_p(x) := '0';
      pin_p(x)  := '0';
      for y in 0 to 7 loop
        for z in 0 to 7 loop
          line_p(x) := line_p(x) xor a(x,y,z);
          chip_p(x) := chip_p(x) xor a(y,x,z);
          pin_p(x)  := pin_p(x)  xor a(y,z,x);
        end loop;
      end loop;
    end loop;
    z := pin_p & chip_p & line_p;
    return z;
  end;

  signal cm_push                   : std_ulogic_vector(1 downto 0);
  signal cm_data                   : std_ulogic_vector(47 downto 0);
  signal arb_gnt_d, arb_gnt_q      : std_ulogic_vector(3 downto 0);
  signal rpull0_rd_pull            : std_ulogic;
  signal rpull0_rs_pull            : std_ulogic;
  signal wpull0_ws_pull            : std_ulogic;
  signal rpull1_rd_pull            : std_ulogic;
  signal rpull1_rs_pull            : std_ulogic;
  signal wpull1_ws_pull            : std_ulogic;
  signal mc0_rd_data               : std_ulogic_vector(575 downto 0);
  signal mc0_rd_rfc                : std_ulogic_vector(9 downto 0);
  signal mc0_rs_data               : std_ulogic_vector(17 downto 0);
  signal mc0_rs_rfc                : std_ulogic_vector(9 downto 0);
  signal mc0_ws_data               : std_ulogic_vector(17 downto 0);
  signal mc0_ws_rfc                : std_ulogic_vector(9 downto 0);
  signal mc0_wd_wfc                : std_ulogic_vector(9 downto 0);
  signal mc0_cm_wfc                : std_ulogic_vector(9 downto 0);
  signal mc1_rd_data               : std_ulogic_vector(575 downto 0);
  signal mc1_rd_rfc                : std_ulogic_vector(9 downto 0);
  signal mc1_rs_data               : std_ulogic_vector(17 downto 0);
  signal mc1_rs_rfc                : std_ulogic_vector(9 downto 0);
  signal mc1_ws_data               : std_ulogic_vector(17 downto 0);
  signal mc1_ws_rfc                : std_ulogic_vector(9 downto 0);
  signal mc1_wd_wfc                : std_ulogic_vector(9 downto 0);
  signal mc1_cm_wfc                : std_ulogic_vector(9 downto 0);
  --
  signal rpull0_req, wpull0_req    : std_ulogic;
  signal rpull1_req, wpull1_req    : std_ulogic;
  signal rpull0_rd_Data            : std_ulogic_vector(575 downto 0);
  signal rpull1_rd_Data            : std_ulogic_vector(575 downto 0);
  signal rpull0_rs_Data            : std_ulogic_vector(17 downto 0);
  signal wpull0_ws_Data            : std_ulogic_vector(17 downto 0);
  signal rpull1_rs_Data            : std_ulogic_vector(17 downto 0);
  signal wpull1_ws_Data            : std_ulogic_vector(17 downto 0);
  signal wdata                     : std_ulogic_vector(575 downto 0);
begin

cm_data(2 downto 0)   <= '0' & i_cmd_size & i_cmd_rw;
cm_data(30 downto 3)  <= i_cmd_addr(30 downto 3);
cm_data(31)           <= '0';               -- unused.
cm_data(47 downto 32) <= i_cmd_tag;

wdata(511 downto 0)   <= i_wdata;
wdata(535 downto 512) <= parity3d(i_wdata);
wdata(575 downto 536) <= i_wMeta;

cm_push(1) <= i_cmd_valid and i_cmd_addr(31);
cm_push(0) <= i_cmd_valid and not(i_cmd_addr(31));


bMerge : block
  signal rsp_data_q, rsp_data_d : std_ulogic_vector(17 downto 0);
  signal rd_data_q , rd_data_d  : std_ulogic_vector(575 downto 0);
  signal yield_d, yield_q  : std_ulogic_vector(i_yield'range);
  signal dpar_exp : std_ulogic_vector(23 downto 0);
begin

  ARB: entity work.ice_gmc_arb
  generic map(
    gN => 4
   ,gS => 2
  )
  port map(
    i_clk        => i_hclk
   ,i_reset      => i_reset
   ,i_yield(0)   => yield_q(1)
   ,i_yield(1)   => yield_q(1)
   ,i_yield(2)   => yield_q(0)
   ,i_yield(3)   => yield_q(0)
   ,i_req(0)     => wpull0_req
   ,i_req(1)     => wpull1_req
   ,i_req(2)     => rpull0_req
   ,i_req(3)     => rpull1_req
   ,i_wt(0 to 1) => i_arbwt(1 downto 0)
   ,i_wt(2 to 3) => i_arbwt(3 downto 2)
   ,i_wt(4 to 5) => i_arbwt(5 downto 4)
   ,i_wt(6 to 7) => i_arbwt(7 downto 6)
   ,o_win(0)     => arb_gnt_d(0)
   ,o_win(1)     => arb_gnt_d(1)
   ,o_win(2)     => arb_gnt_d(2)
   ,o_win(3)     => arb_gnt_d(3)
  );

  -- Use arbiter to merge the responses into 1 stream.
  rsp_data_d <= gate_and(arb_gnt_d(0), wpull0_ws_data)
             or gate_and(arb_gnt_d(1), wpull1_ws_data)
             or gate_and(arb_gnt_d(2), rpull0_rs_data)
             or gate_and(arb_gnt_d(3), rpull1_rs_data)
             ;

  rd_data_d  <= gate_and(arb_gnt_d(2), rpull0_rd_data)
             or gate_and(arb_gnt_d(3), rpull1_rd_data)
             ;

  o_cmd_fc    <= arb_gnt_q;
  -- which qualifies same cycle the following:

  o_rsp_tag  <= rsp_data_q(15 downto 0);
  o_rsp_size <= rsp_data_q(16);
  o_rsp_offs <= rsp_data_q(17);
  o_rsp_data <= rd_data_q(511 downto 0);
  o_rsp_meta <= rd_data_q(575 downto 536);
  dpar_exp   <= parity3d(rd_data_q(511 downto 0)); -- make appear in aet.
  o_rsp_perr <= dpar_exp xor rd_data_q(535 downto 512);
  yield_d    <= i_yield;

  pLatch : process
  begin
    wait until rising_edge(i_hclk);
    rsp_data_q <= rsp_data_d;
    rd_data_q  <= rd_data_d;
    arb_gnt_q  <= arb_gnt_d;
    yield_q    <= yield_d;
  end process;
end block;

-- Instantiate a Memory controller and 2 response pullers for each port.
MC0: entity work.ice_gmc_mc_eng
port map(
  i_mclk              => i_mclk(0)
 ,i_hclk              => i_hclk
 ,i_reset             => i_mc_reset(0)
 ,o_idle              => o_idle(0 downto 0)
 ,o_app_addr          => o_mc0_ddr0_addr
 ,o_app_cmd           => o_mc0_ddr0_cmd
 ,o_app_en            => o_mc0_ddr0_en
 ,i_app_rdy           => i_ddr0_mc0_app_rdy
 ,o_app_wdf_end       => o_mc0_ddr0_wdf_end
 ,o_app_wdf_wren      => o_mc0_ddr0_wdf_wren
 ,i_app_wdf_rdy       => i_ddr0_mc0_app_wdf_rdy
 ,o_app_wdf_data      => o_mc0_ddr0_wdf_data
 ,i_app_rd_data_end   => i_ddr0_mc0_app_rd_data_end
 ,i_app_rd_data_valid => i_ddr0_mc0_app_rd_data_valid
 ,i_app_rd_data       => i_ddr0_mc0_app_rd_data
 --
 ,i_wd_push           => i_wvalid(0)
 ,i_wd_data           => wdata
 ,o_wd_wfc            => mc0_wd_wfc  -- bypass mc go to puller.
 ,i_cm_push           => cm_push(0)
 ,i_cm_data           => cm_data
 ,o_cm_wfc            => mc0_cm_wfc
 ,i_rd_pull           => rpull0_rd_pull
 ,o_rd_data           => mc0_rd_data
 ,o_rd_rfc            => mc0_rd_rfc
 ,i_rs_pull           => rpull0_rs_pull
 ,o_rs_data           => mc0_rs_data
 ,o_rs_rfc            => mc0_rs_rfc
 ,i_ws_pull           => wpull0_ws_pull
 ,o_ws_data           => mc0_ws_data
 ,o_ws_rfc            => mc0_ws_rfc
 ,o_fifo_err          => o_mc0_fifo_err
);

RPULL0: entity work.ice_gmc_dpull
port map(
  i_clk     => i_hclk
 ,i_reset   => i_reset
 ,i_dp      => '1'
 ,i_sfc     => mc0_rs_rfc
 ,i_dfc     => mc0_rd_rfc
 ,i_sdat    => mc0_rs_data
 ,i_ddat    => mc0_rd_data
 ,o_spull   => rpull0_rs_pull
 ,o_dpull   => rpull0_rd_pull
 ,o_req     => rpull0_req
 ,i_gnt     => arb_gnt_d(2)
 ,o_rd_data => rpull0_rd_data
 ,o_rs_data => rpull0_rs_data
);

WPULL0: entity work.ice_gmc_dpull
port map(
  i_clk      => i_hclk
 ,i_reset    => i_reset
 ,i_dp       => '0'
 ,i_sfc      => mc0_ws_rfc
 ,i_sdat     => mc0_ws_data
 ,o_spull    => wpull0_ws_pull
 ,o_req      => wpull0_req
 ,o_rs_data  => wpull0_ws_data
 ,i_gnt      => arb_gnt_d(0)
 -- data part not used.
 ,i_dfc      => mc0_wd_wfc
 ,i_ddat     => (others => '0')
 ,o_dpull    => open
 ,o_rd_data  => open
);



---- Second Port.
MC1: entity work.ice_gmc_mc_eng
port map(
  i_mclk              => i_mclk(1)
 ,i_hclk              => i_hclk
 ,i_reset             => i_mc_reset(1)
 ,o_idle              => o_idle(1 downto 1)
 ,o_app_addr          => o_mc1_ddr1_addr
 ,o_app_cmd           => o_mc1_ddr1_cmd
 ,o_app_en            => o_mc1_ddr1_en
 ,i_app_rdy           => i_ddr1_mc1_app_rdy
 ,o_app_wdf_end       => o_mc1_ddr1_wdf_end
 ,o_app_wdf_wren      => o_mc1_ddr1_wdf_wren
 ,i_app_wdf_rdy       => i_ddr1_mc1_app_wdf_rdy
 ,o_app_wdf_data      => o_mc1_ddr1_wdf_data
 ,i_app_rd_data_end   => i_ddr1_mc1_app_rd_data_end
 ,i_app_rd_data_valid => i_ddr1_mc1_app_rd_data_valid
 ,i_app_rd_data       => i_ddr1_mc1_app_rd_data
 --
 ,i_wd_push           => i_wvalid(1)
 ,i_wd_data           => wdata
 ,o_wd_wfc            => mc1_wd_wfc
 ,i_cm_push           => cm_push(1)
 ,i_cm_data           => cm_data
 ,o_cm_wfc            => mc1_cm_wfc
 ,i_rd_pull           => rpull1_rd_pull
 ,o_rd_data           => mc1_rd_data
 ,o_rd_rfc            => mc1_rd_rfc
 ,i_rs_pull           => rpull1_rs_pull
 ,o_rs_data           => mc1_rs_data
 ,o_rs_rfc            => mc1_rs_rfc
 ,i_ws_pull           => wpull1_ws_pull
 ,o_ws_data           => mc1_ws_data
 ,o_ws_rfc            => mc1_ws_rfc
 ,o_fifo_err          => o_mc1_fifo_err
);

RPULL1: entity work.ice_gmc_dpull
port map(
  i_clk     => i_hclk
 ,i_reset   => i_reset
 ,i_dp      => '1'
 ,i_sfc     => mc1_rs_rfc
 ,i_dfc     => mc1_rd_rfc
 ,i_sdat    => mc1_rs_data
 ,i_ddat    => mc1_rd_data
 ,o_spull   => rpull1_rs_pull
 ,o_dpull   => rpull1_rd_pull
 ,o_req     => rpull1_req
 ,i_gnt     => arb_gnt_d(3)
 ,o_rd_data => rpull1_rd_data
 ,o_rs_data => rpull1_rs_data
);

WPULL1: entity work.ice_gmc_dpull
port map(
  i_clk      => i_hclk
 ,i_reset    => i_reset
 ,i_dp       => '0'
 ,i_sfc      => mc1_ws_rfc
 ,i_sdat     => mc1_ws_data    -- need the tag only
 ,o_spull    => wpull1_ws_pull
 ,o_req      => wpull1_req
 ,o_rs_data  => wpull1_ws_data
 ,i_gnt      => arb_gnt_d(1)
 -- data part not used.
 ,i_dfc      => mc1_wd_wfc
 ,i_ddat     => (others => '0')
 ,o_dpull    => open
 ,o_rd_data  => open
);

end ice_gmc_top;
