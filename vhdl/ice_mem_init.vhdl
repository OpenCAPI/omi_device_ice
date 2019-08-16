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

ENTITY ice_mem_init IS
  PORT
    (

      -- cmd from afu main 
      i_afu_cmd_valid                     : in  std_ulogic;
      i_afu_cmd_rw                        : in  std_ulogic;                      -- 1=write.
      i_afu_cmd_addr                      : in  std_ulogic_vector(31 downto 3);
      i_afu_cmd_tag                       : in  std_ulogic_vector(15 downto 0);
      i_afu_cmd_size                      : in  std_ulogic;                      -- 0:64B, 1:128B

      i_afu_wvalid                        : in  std_ulogic_vector(1 downto 0);   -- p1, p0.
      i_afu_wdata                         : in  std_ulogic_vector(511 downto 0);
      i_afu_wmeta                         : in  std_ulogic_vector(39 downto 0);

      --Muxed out cmd to UI
      -----------------------------------
      -- --UI cmd queue interface 
      -- -----------------------------------
      o_ui_cmd_valid                      : OUT STD_ULOGIC;
      o_ui_cmd_rw                         : OUT STD_ULOGIC;                       --0:R  1:W
      o_ui_cmd_addr                       : OUT STD_ULOGIC_VECTOR(31 DOWNTO 3);
      o_ui_cmd_tag                        : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0);
      o_ui_cmd_size                       : OUT STD_ULOGIC;

      o_ui_wvalid                         : OUT STD_ULOGIC_VECTOR(1 DOWNTO 0);
      o_ui_wdata                          : OUT STD_ULOGIC_VECTOR(511 DOWNTO 0);
      o_ui_wmeta                          : OUT STD_ULOGIC_VECTOR(39 DOWNTO 0);

      
      --Response from UI
      i_ui_cmd_fc                         : IN  STD_ULOGIC_VECTOR(3 DOWNTO 0);
      i_ui_rsp_tag                        : IN  STD_ULOGIC_VECTOR(15 DOWNTO 0);
      i_ui_rsp_data                       : IN  STD_ULOGIC_VECTOR(511 DOWNTO 0);
      i_ui_rsp_meta                       : IN  STD_ULOGIC_VECTOR(39 DOWNTO 0);
      i_ui_rsp_perr                       : IN  STD_ULOGIC_VECTOR(23 DOWNTO 0);
      i_ui_rsp_offs                       : IN  STD_ULOGIC;
      i_ui_rsp_size                       : IN  STD_ULOGIC; --0: indicates request was for 64B  1: indicates request was for 128B. i_rsp_offs determine which half 
      o_ui_yield                          : OUT STD_ULOGIC_VECTOR(1 DOWNTO 0);
      o_ui_arbwt                          : OUT STD_ULOGIC_VECTOR(7 DOWNTO 0);
      
      -- response to afu main
      o_afu_cmd_fc                        : out std_ulogic_vector(3 downto 0);   -- r1, r0, w1, w0
      o_afu_rsp_tag                       : out std_ulogic_vector(15 downto 0);
      o_afu_rsp_offs                      : out std_ulogic;
      o_afu_rsp_data                      : out std_ulogic_vector(511 downto 0);
      o_afu_rsp_meta                      : out std_ulogic_vector(39 downto 0);
      o_afu_rsp_size                      : out std_ulogic;
      o_afu_rsp_perr                      : out std_ulogic_vector(23 downto 0);
      i_afu_yield                         : in STD_ULOGIC_VECTOR(1 DOWNTO 0);
      i_afu_arbwt                         : in STD_ULOGIC_VECTOR(7 DOWNTO 0);
     
      mem_init_start                   : IN  STD_ULOGIC;
      mem_init_zero                    : IN  STD_ULOGIC;
      mem_init_done                    : out  STD_ULOGIC;
      mem_init_ip                      : out  STD_ULOGIC;
      mem_init_wait                    : out  STD_ULOGIC;
      mem_init_addr                    : out  STD_ULOGIC_VECTOR(28 DOWNTO 0);

      clock_400mhz                     : IN  STD_ULOGIC;
      reset_n                          : IN  STD_ULOGIC

      );
END ice_mem_init;

ARCHITECTURE ice_mem_init OF ice_mem_init IS

  signal wr_cmd_crd_rdy       : std_ulogic;                     
  signal wr_cmd_crd_full      : std_ulogic;                     
  signal meminit_done         : std_ulogic;                    
  signal addr_done            : std_ulogic;                   

  signal meminit_cmd_valid           : std_ulogic;
  signal meminit_cmd_rw              : std_ulogic;                      -- 1=write.
  signal meminit_cmd_addr            : std_ulogic_vector(31 downto 3);
  signal meminit_cmd_tag             : std_ulogic_vector(15 downto 0);
  signal meminit_cmd_size            : std_ulogic;                      -- 0:64B, 1:128B

  signal meminit_wvalid              : std_ulogic_vector(1 downto 0);   -- p1, p0.
  signal meminit_wdata               : std_ulogic_vector(511 downto 0);
  signal meminit_wmeta               : std_ulogic_vector(39 downto 0);
  
  SIGNAL intlv0_wr_crd_d             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL intlv0_wr_crd_q             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL intlv1_wr_crd_d             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL intlv1_wr_crd_q             : STD_ULOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL pt                          : STD_ULOGIC;
  SIGNAL pt_out                      : STD_ULOGIC;
  SIGNAL use_wr0_fc                  : STD_ULOGIC;
  SIGNAL use_wr1_fc                  : STD_ULOGIC;
  SIGNAL return_wr0_fc               : STD_ULOGIC;
  SIGNAL return_wr1_fc               : STD_ULOGIC;
  SIGNAL phy_addr_d                  : STD_ULOGIC_VECTOR(34 DOWNTO 6);
  SIGNAL row_column_bank             : STD_ULOGIC_VECTOR(30 DOWNTO 0);
  SIGNAL phy_addr_q                  : STD_ULOGIC_VECTOR(34 DOWNTO 6);
  SIGNAL col                         : STD_ULOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL bg                          : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL bk                          : STD_ULOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL row                         : STD_ULOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL rank                        : STD_ULOGIC;

  SIGNAL done_d                        : STD_ULOGIC;
  SIGNAL wait_d                        : STD_ULOGIC;
  SIGNAL wcmd_d                        : STD_ULOGIC;

  SIGNAL done_q                        : STD_ULOGIC := '1';
  SIGNAL wait_q                        : STD_ULOGIC;
  SIGNAL wcmd_q                        : STD_ULOGIC;

  signal done_wait                     : STD_ULOGIC;
  signal done_wcmd                     : STD_ULOGIC;
  signal wcmd_wait                     : STD_ULOGIC;
  signal wait_wcmd                     : STD_ULOGIC;
  signal wait_done                     : STD_ULOGIC;

  signal mem_init_start_d              : STD_ULOGIC;
  signal mem_init_start_q              : STD_ULOGIC;
  signal mem_init_start_rpulse         : STD_ULOGIC;
  signal meminit_ran_d                 : STD_ULOGIC;
  signal meminit_ran_q                 : STD_ULOGIC;

  attribute mark_debug                : string;
  attribute mark_debug of  done_q              : signal is "true";
  attribute mark_debug of  wait_q              : signal is "true";
  attribute mark_debug of  wcmd_q              : signal is "true";
  attribute mark_debug of  phy_addr_q          : signal is "true";
  attribute mark_debug of  intlv0_wr_crd_q     : signal is "true";
  attribute mark_debug of  intlv1_wr_crd_q     : signal is "true";

BEGIN


      --Muxed out cmd to UI
      -----------------------------------
      -- --UI cmd queue interface 
      -- -----------------------------------
      o_ui_cmd_valid  <=      (i_afu_cmd_valid     AND meminit_done) or     (meminit_cmd_valid AND NOT meminit_done);
      o_ui_cmd_rw     <=      (i_afu_cmd_rw        AND meminit_done) or     (meminit_cmd_rw    AND NOT meminit_done);
      o_ui_cmd_addr   <=      gate(i_afu_cmd_addr  ,   meminit_done) or gate(meminit_cmd_addr  ,   NOT meminit_done);                          
      o_ui_cmd_tag    <=      gate(i_afu_cmd_tag   ,   meminit_done) or gate(meminit_cmd_tag   ,   NOT meminit_done);
      o_ui_cmd_size   <=      (i_afu_cmd_size      AND meminit_done) or     (meminit_cmd_size  and NOT meminit_done);
                                                                                             
      o_ui_wvalid     <=      gate(i_afu_wvalid    ,   meminit_done) OR gate(meminit_wvalid    ,   NOT meminit_done);                           
      o_ui_wdata      <=      gate(i_afu_wdata     ,   meminit_done) OR gate(meminit_wdata     ,   NOT meminit_done);
      o_ui_wmeta      <=      gate(i_afu_wmeta     ,   meminit_done) OR gate(meminit_wmeta     ,   NOT meminit_done);


      -- response to afu main
      o_afu_cmd_fc(3 DOWNTO 2)  <= i_ui_cmd_fc(3 DOWNTO 2);                      --: out std_ulogic_vector(3 downto 0);   -- r1, r0, w1, w0
      o_afu_cmd_fc(1 DOWNTO 0)  <= gate(i_ui_cmd_fc(1 DOWNTO 0), meminit_done);  --: out std_ulogic_vector(3 downto 0);   -- r1, r0, w1, w0
      o_afu_rsp_tag             <= i_ui_rsp_tag  ;                               --: out std_ulogic_vector(15 downto 0);
      o_afu_rsp_offs            <= i_ui_rsp_offs ;                               --: out std_ulogic;
      o_afu_rsp_data            <= i_ui_rsp_data ;                               --: out std_ulogic_vector(511 downto 0);
      o_afu_rsp_meta            <= i_ui_rsp_meta ;                               --: out std_ulogic_vector(39 downto 0);
      o_afu_rsp_size            <= i_ui_rsp_size ;                               --: out std_ulogic;
      o_afu_rsp_perr            <= i_ui_rsp_perr ;                               --: out std_ulogic_vector(23 downto 0);
      o_ui_yield                <= i_afu_yield   ;
      o_ui_arbwt                <= i_afu_arbwt   ;

      mem_init_start_rpulse     <= mem_init_start_d AND NOT mem_init_start_q;
      mem_init_start_d          <= mem_init_start;

      mem_init_done             <= done_q AND meminit_ran_q;
      mem_init_ip               <= wcmd_q;
      mem_init_wait             <= wait_q;
      mem_init_addr             <= phy_addr_q;
      meminit_cmd_valid         <= wcmd_q;
      meminit_cmd_rw            <= '1';
      meminit_cmd_addr          <= pt & row_column_bank(30 DOWNTO 3); 
      meminit_cmd_tag           <= (OTHERS => '0');
      meminit_cmd_size          <= '0';
                       
      meminit_wvalid            <= (wcmd_q AND pt) & (wcmd_q AND NOT pt);
      meminit_wdata             <= (511 downto 35 => '0') & gate(phy_addr_q(34 downto 6), NOT mem_init_zero) & (5 downto 0 => '0');
      meminit_wmeta             <= (OTHERS => '0');

      meminit_ran_d             <= (meminit_ran_q OR wait_done) AND reset_n;
      

  use_wr0_fc    <= ((done_q AND mem_init_start_rpulse) OR (wait_q AND NOT addr_done) OR (wcmd_q AND NOT addr_done)) AND NOT pt_out  AND wr_cmd_crd_rdy;
  use_wr1_fc    <= ((done_q AND mem_init_start_rpulse) OR (wait_q AND NOT addr_done) OR (wcmd_q AND NOT addr_done)) AND     pt_out  AND wr_cmd_crd_rdy;
  return_wr0_fc <= i_ui_cmd_fc(0) AND NOT meminit_done;
  return_wr1_fc <= i_ui_cmd_fc(1) AND NOT meminit_done;

  intlv0_wr_crd_d(8 DOWNTO 0) <= gate("100000000", NOT reset_n) OR
                                 gate(intlv0_wr_crd_q(8 DOWNTO 0) + 1, reset_n AND     return_wr0_fc AND NOT use_wr0_fc) OR
                                 gate(intlv0_wr_crd_q(8 DOWNTO 0) - 1, reset_n AND NOT return_wr0_fc AND     use_wr0_fc) OR
                                 gate(intlv0_wr_crd_q(8 DOWNTO 0),     reset_n AND    (return_wr0_fc XNOR    use_wr0_fc));
  intlv1_wr_crd_d(8 DOWNTO 0) <= gate("100000000", NOT reset_n) OR
                                 gate(intlv1_wr_crd_q(8 DOWNTO 0) + 1, reset_n AND     return_wr1_fc AND NOT use_wr1_fc) OR
                                 gate(intlv1_wr_crd_q(8 DOWNTO 0) - 1, reset_n AND NOT return_wr1_fc AND     use_wr1_fc) OR
                                 gate(intlv1_wr_crd_q(8 DOWNTO 0),     reset_n AND    (return_wr1_fc XNOR    use_wr1_fc));

  --always wait for both ports
  wr_cmd_crd_rdy   <= or_reduce(intlv0_wr_crd_q) AND or_reduce(intlv1_wr_crd_q);
  wr_cmd_crd_full  <= (intlv0_wr_crd_q = "100000000") AND (intlv1_wr_crd_q = "100000000");
  addr_done        <= and_reduce(phy_addr_q);
  meminit_done     <= done_q;

  done_wait    <= done_q AND mem_init_start_rpulse AND NOT wr_cmd_crd_rdy;
  done_wcmd    <= done_q AND mem_init_start_rpulse AND     wr_cmd_crd_rdy;
  wcmd_wait    <= wcmd_q AND (addr_done or  NOT     wr_cmd_crd_rdy);
  wait_wcmd    <= wait_q AND NOT addr_done  AND     wr_cmd_crd_rdy;
  wait_done    <= wait_q AND     addr_done  AND     wr_cmd_crd_full;
  done_d       <= (done_q AND NOT done_wait AND NOT done_wcmd) OR wait_done;
  wait_d       <= (wait_q AND NOT wait_done AND NOT wait_wcmd) OR wcmd_wait OR done_wait;
  wcmd_d       <= (wcmd_q AND NOT wcmd_wait) OR done_wcmd OR wait_wcmd;

  phy_addr_d(34 DOWNTO 6) <= (OTHERS => '0') WHEN  reset_n = '0' OR done_q = '1' OR mem_init_start_rpulse = '1' else
                             phy_addr_q + 1  when  wcmd_q = '1' AND addr_done = '0' else
                             phy_addr_q;
                             
      
  col(2 DOWNTO 0)  <= "000";            -- bit5 not being used since MC doesn't do BL8 reorder
  bg(0)            <= phy_addr_q(6);    --this is 64B bit
  pt               <= phy_addr_q(7);    --128B bit
  pt_out           <= phy_addr_d(7);    --128B bit,use this version to determine which credit to use
  bg(1)            <= phy_addr_q(8);
  bk(1 DOWNTO 0)   <= phy_addr_q(10 DOWNTO 9);
  col(3)           <= phy_addr_q(11); 
  col(7 DOWNTO 4)  <= phy_addr_q(15 DOWNTO 12);
  row(14 DOWNTO 0) <= phy_addr_q(30 DOWNTO 16);
  col(9 DOWNTO 8)  <= phy_addr_q(32 DOWNTO 31);
  row(15)          <= phy_addr_q(33);
  rank             <= phy_addr_q(34);   --bit35 and up not currently used in DRAM cmd

  --Row Column Bank MC memory address map
  row_column_bank(30)           <= rank;
  row_column_bank(29 DOWNTO 14) <= row(15 DOWNTO 0);
  row_column_bank(13 DOWNTO 7)  <= col(9 DOWNTO 3);
  row_column_bank(6 DOWNTO 5)   <= bk(1 DOWNTO 0);
  row_column_bank(4 DOWNTO 3)   <= bg(1 DOWNTO 0);
  row_column_bank(2 DOWNTO 0)   <= col(2 DOWNTO 0);
  
   ice_term(ROW_COLUMN_BANK(2 DOWNTO 0));

  latch : PROCESS
  BEGIN
    WAIT UNTIL clock_400mhz'event AND Clock_400mhz = '1';
    IF reset_n = '0' THEN
      done_q  <= '1';                               -- : STD_ULOGIC;
      wait_q  <= '0';                               -- : STD_ULOGIC;
      wcmd_q  <= '0';                               -- : STD_ULOGIC;
    ELSE
      done_q  <= done_d;                          -- : STD_ULOGIC;
      wait_q  <= wait_d;                          -- : STD_ULOGIC;
      wcmd_q  <= wcmd_d;                         -- : STD_ULOGIC;
    END IF;
    intlv0_wr_crd_q        <= intlv0_wr_crd_d;        -- : STD_ULOGIC_VECTOR(8 DOWNTO 0);
    intlv1_wr_crd_q        <= intlv1_wr_crd_d;        -- : STD_ULOGIC_VECTOR(8 DOWNTO 0);
    phy_addr_q             <= phy_addr_d;             -- : STD_ULOGIC_VECTOR;
    mem_init_start_q       <= mem_init_start_d;
    meminit_ran_q          <= meminit_ran_d;             
  END PROCESS;

END ice_mem_init;
