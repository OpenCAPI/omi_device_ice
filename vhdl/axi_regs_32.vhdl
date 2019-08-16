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
 
 
 

library ieee, ibm, work;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.axi_pkg.all;
  use work.ice_func.all;

entity axi_regs_32 is
  generic (
    -- Offset of register block
    offset : natural := 0;

    -- Scom Write Enable Masks
    REG_00_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_01_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_02_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_03_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_04_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_05_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_06_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_07_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_08_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_09_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0A_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0B_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0C_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0D_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0E_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0F_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";

    -- Hardware Write Enable Masks
    REG_00_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_01_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_02_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_03_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_04_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_05_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_06_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_07_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_08_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_09_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0A_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0B_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0C_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0D_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0E_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0F_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";

    -- Stick Bit Masks
    REG_00_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_01_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_02_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_03_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_04_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_05_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_06_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_07_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_08_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_09_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0A_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0B_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0C_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0D_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0E_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0F_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000"
    );

  port (
    -- AXI4-Lite
    s0_axi_aclk : in  std_ulogic;
    s0_axi_i    : in  t_AXI4_LITE_SLAVE_INPUT;
    s0_axi_o    : out t_AXI4_LITE_SLAVE_OUTPUT;

    -- Register Data
    reg_00_o : out std_ulogic_vector(31 downto 0);
    reg_01_o : out std_ulogic_vector(31 downto 0);
    reg_02_o : out std_ulogic_vector(31 downto 0);
    reg_03_o : out std_ulogic_vector(31 downto 0);
    reg_04_o : out std_ulogic_vector(31 downto 0);
    reg_05_o : out std_ulogic_vector(31 downto 0);
    reg_06_o : out std_ulogic_vector(31 downto 0);
    reg_07_o : out std_ulogic_vector(31 downto 0);
    reg_08_o : out std_ulogic_vector(31 downto 0);
    reg_09_o : out std_ulogic_vector(31 downto 0);
    reg_0A_o : out std_ulogic_vector(31 downto 0);
    reg_0B_o : out std_ulogic_vector(31 downto 0);
    reg_0C_o : out std_ulogic_vector(31 downto 0);
    reg_0D_o : out std_ulogic_vector(31 downto 0);
    reg_0E_o : out std_ulogic_vector(31 downto 0);
    reg_0F_o : out std_ulogic_vector(31 downto 0);

    -- Expandable Register Interface
    -- Read Data
    exp_rd_valid      : out std_ulogic;
    exp_rd_address    : out std_ulogic_vector(31 downto 0);
    exp_rd_data       : in  std_ulogic_vector(31 downto 0) := x"00000000";
    exp_rd_data_valid : in  std_ulogic := '0';
    -- Write Data
    exp_wr_valid      : out std_ulogic;
    exp_wr_address    : out std_ulogic_vector(31 downto 0);
    exp_wr_data       : out std_ulogic_vector(31 downto 0);

    -- Hardware Write Update Values and Enables
    reg_00_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_01_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_02_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_03_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_04_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_05_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_06_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_07_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_08_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_09_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0A_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0B_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0C_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0D_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0E_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0F_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_00_hwwe_i   : in std_ulogic := '0';
    reg_01_hwwe_i   : in std_ulogic := '0';
    reg_02_hwwe_i   : in std_ulogic := '0';
    reg_03_hwwe_i   : in std_ulogic := '0';
    reg_04_hwwe_i   : in std_ulogic := '0';
    reg_05_hwwe_i   : in std_ulogic := '0';
    reg_06_hwwe_i   : in std_ulogic := '0';
    reg_07_hwwe_i   : in std_ulogic := '0';
    reg_08_hwwe_i   : in std_ulogic := '0';
    reg_09_hwwe_i   : in std_ulogic := '0';
    reg_0A_hwwe_i   : in std_ulogic := '0';
    reg_0B_hwwe_i   : in std_ulogic := '0';
    reg_0C_hwwe_i   : in std_ulogic := '0';
    reg_0D_hwwe_i   : in std_ulogic := '0';
    reg_0E_hwwe_i   : in std_ulogic := '0';
    reg_0F_hwwe_i   : in std_ulogic := '0'
  );
end axi_regs_32;

architecture axi_regs_32 of axi_regs_32 is

  signal s0_axi_aresetn : std_ulogic;
  signal s0_axi_awvalid : std_ulogic;
  signal s0_axi_awready : std_ulogic;
  signal s0_axi_awaddr  : std_ulogic_vector(31 downto 0);
  signal s0_axi_awprot  : std_ulogic_vector(2 downto 0);
  signal s0_axi_wvalid  : std_ulogic;
  signal s0_axi_wready  : std_ulogic;
  signal s0_axi_wdata   : std_ulogic_vector(31 downto 0);
  signal s0_axi_wstrb   : std_ulogic_vector(3 downto 0);
  signal s0_axi_bvalid  : std_ulogic;
  signal s0_axi_bready  : std_ulogic;
  signal s0_axi_bresp   : std_ulogic_vector(1 downto 0);
  signal s0_axi_arvalid : std_ulogic;
  signal s0_axi_arready : std_ulogic;
  signal s0_axi_araddr  : std_ulogic_vector(31 downto 0);
  signal s0_axi_arprot  : std_ulogic_vector(2 downto 0);
  signal s0_axi_rvalid  : std_ulogic;
  signal s0_axi_rready  : std_ulogic;
  signal s0_axi_rdata   : std_ulogic_vector(31 downto 0);
  signal s0_axi_rresp   : std_ulogic_vector(1 downto 0);

  signal axi_rd_state_d     : std_ulogic_vector(3 downto 0);
  signal axi_rd_state_q     : std_ulogic_vector(3 downto 0);
  signal axi_rd_state_ns0_0 : std_ulogic;
  signal axi_rd_state_ns0_1 : std_ulogic;
  signal axi_rd_state_ns0_2 : std_ulogic;
  signal axi_rd_state_ns0_3 : std_ulogic;
  signal axi_rd_state_ns1_0 : std_ulogic;
  signal axi_rd_state_ns1_1 : std_ulogic;
  signal axi_rd_state_ns1_2 : std_ulogic;
  signal axi_rd_state_ns1_3 : std_ulogic;
  signal axi_rd_state_ns2_0 : std_ulogic;
  signal axi_rd_state_ns2_1 : std_ulogic;
  signal axi_rd_state_ns2_2 : std_ulogic;
  signal axi_rd_state_ns2_3 : std_ulogic;
  signal axi_rd_state_ns3_0 : std_ulogic;
  signal axi_rd_state_ns3_1 : std_ulogic;
  signal axi_rd_state_ns3_2 : std_ulogic;
  signal axi_rd_state_ns3_3 : std_ulogic;

  signal reg_rd_valid   : std_ulogic;
  signal reg_rd_valid_d : std_ulogic;
  signal reg_rd_valid_q : std_ulogic;
  signal reg_rd_addr_d  : std_ulogic_vector(31 downto 0);
  signal reg_rd_addr_q  : std_ulogic_vector(31 downto 0);

  signal axi_wr_state_d     : std_ulogic_vector(4 downto 0);
  signal axi_wr_state_q     : std_ulogic_vector(4 downto 0);
  signal axi_wr_state_ns0_0 : std_ulogic;
  signal axi_wr_state_ns0_1 : std_ulogic;
  signal axi_wr_state_ns0_2 : std_ulogic;
  signal axi_wr_state_ns0_3 : std_ulogic;
  signal axi_wr_state_ns0_4 : std_ulogic;
  signal axi_wr_state_ns1_0 : std_ulogic;
  signal axi_wr_state_ns1_1 : std_ulogic;
  signal axi_wr_state_ns1_2 : std_ulogic;
  signal axi_wr_state_ns1_3 : std_ulogic;
  signal axi_wr_state_ns1_4 : std_ulogic;
  signal axi_wr_state_ns2_0 : std_ulogic;
  signal axi_wr_state_ns2_1 : std_ulogic;
  signal axi_wr_state_ns2_2 : std_ulogic;
  signal axi_wr_state_ns2_3 : std_ulogic;
  signal axi_wr_state_ns2_4 : std_ulogic;
  signal axi_wr_state_ns3_0 : std_ulogic;
  signal axi_wr_state_ns3_1 : std_ulogic;
  signal axi_wr_state_ns3_2 : std_ulogic;
  signal axi_wr_state_ns3_3 : std_ulogic;
  signal axi_wr_state_ns3_4 : std_ulogic;
  signal axi_wr_state_ns4_0 : std_ulogic;
  signal axi_wr_state_ns4_1 : std_ulogic;
  signal axi_wr_state_ns4_2 : std_ulogic;
  signal axi_wr_state_ns4_3 : std_ulogic;
  signal axi_wr_state_ns4_4 : std_ulogic;

  signal reg_wr_valid   : std_ulogic;
  signal reg_wr_addr_d  : std_ulogic_vector(31 downto 0);
  signal reg_wr_addr_q  : std_ulogic_vector(31 downto 0);
  signal s0_axi_wdata_d : std_ulogic_vector(31 downto 0);
  signal s0_axi_wdata_q : std_ulogic_vector(31 downto 0);

  signal reg_00_d : std_ulogic_vector(31 downto 0);
  signal reg_01_d : std_ulogic_vector(31 downto 0);
  signal reg_02_d : std_ulogic_vector(31 downto 0);
  signal reg_03_d : std_ulogic_vector(31 downto 0);
  signal reg_04_d : std_ulogic_vector(31 downto 0);
  signal reg_05_d : std_ulogic_vector(31 downto 0);
  signal reg_06_d : std_ulogic_vector(31 downto 0);
  signal reg_07_d : std_ulogic_vector(31 downto 0);
  signal reg_08_d : std_ulogic_vector(31 downto 0);
  signal reg_09_d : std_ulogic_vector(31 downto 0);
  signal reg_0A_d : std_ulogic_vector(31 downto 0);
  signal reg_0B_d : std_ulogic_vector(31 downto 0);
  signal reg_0C_d : std_ulogic_vector(31 downto 0);
  signal reg_0D_d : std_ulogic_vector(31 downto 0);
  signal reg_0E_d : std_ulogic_vector(31 downto 0);
  signal reg_0F_d : std_ulogic_vector(31 downto 0);
  signal reg_00_q : std_ulogic_vector(31 downto 0);
  signal reg_01_q : std_ulogic_vector(31 downto 0);
  signal reg_02_q : std_ulogic_vector(31 downto 0);
  signal reg_03_q : std_ulogic_vector(31 downto 0);
  signal reg_04_q : std_ulogic_vector(31 downto 0);
  signal reg_05_q : std_ulogic_vector(31 downto 0);
  signal reg_06_q : std_ulogic_vector(31 downto 0);
  signal reg_07_q : std_ulogic_vector(31 downto 0);
  signal reg_08_q : std_ulogic_vector(31 downto 0);
  signal reg_09_q : std_ulogic_vector(31 downto 0);
  signal reg_0A_q : std_ulogic_vector(31 downto 0);
  signal reg_0B_q : std_ulogic_vector(31 downto 0);
  signal reg_0C_q : std_ulogic_vector(31 downto 0);
  signal reg_0D_q : std_ulogic_vector(31 downto 0);
  signal reg_0E_q : std_ulogic_vector(31 downto 0);
  signal reg_0F_q : std_ulogic_vector(31 downto 0);


begin

  -----------------------------------------------------------------------------
  -- AXI4-Lite Record
  -----------------------------------------------------------------------------
  -- Global
  s0_axi_aresetn <= s0_axi_i.s0_axi_aresetn;

  -- Write Address Channel
  s0_axi_awvalid             <= s0_axi_i.s0_axi_awvalid;
  s0_axi_o.s0_axi_awready    <= s0_axi_awready;
  s0_axi_awaddr(31 downto 0) <= s0_axi_i.s0_axi_awaddr(31 downto 0);
  s0_axi_awprot(2 downto 0)  <= s0_axi_i.s0_axi_awprot(2 downto 0);

  -- Write Data Channel
  s0_axi_wvalid             <= s0_axi_i.s0_axi_wvalid;
  s0_axi_o.s0_axi_wready    <= s0_axi_wready;
  s0_axi_wdata(31 downto 0) <= s0_axi_i.s0_axi_wdata(31 downto 0);
  s0_axi_wstrb(3 downto 0)  <= s0_axi_i.s0_axi_wstrb(3 downto 0);

  -- Write Response Channel
  s0_axi_o.s0_axi_bvalid            <= s0_axi_bvalid;
  s0_axi_bready                     <= s0_axi_i.s0_axi_bready;
  s0_axi_o.s0_axi_bresp(1 downto 0) <= s0_axi_bresp(1 downto 0);

  -- Read Address Channel
  s0_axi_arvalid             <= s0_axi_i.s0_axi_arvalid;
  s0_axi_o.s0_axi_arready    <= s0_axi_arready;
  s0_axi_araddr(31 downto 0) <= s0_axi_i.s0_axi_araddr(31 downto 0);
  s0_axi_arprot(2 downto 0)  <= s0_axi_i.s0_axi_arprot(2 downto 0);

  -- Read Data Channel
  s0_axi_o.s0_axi_rvalid             <= s0_axi_rvalid;
  s0_axi_rready                      <= s0_axi_i.s0_axi_rready;
  s0_axi_o.s0_axi_rdata(31 downto 0) <= s0_axi_rdata(31 downto 0);
  s0_axi_o.s0_axi_rresp(1 downto 0)  <= s0_axi_rresp(1 downto 0);

  -----------------------------------------------------------------------------
  -- Expandable Register Interface
  -----------------------------------------------------------------------------
  -- Read Data
  exp_rd_valid   <= reg_rd_valid;
  exp_rd_address <= reg_rd_addr_q;
  -- Write Data
  exp_wr_valid   <= reg_wr_valid;
  exp_wr_address <= reg_wr_addr_q;
  exp_wr_data    <= s0_axi_wdata_q;

  -----------------------------------------------------------------------------
  -- Read Transaction State Machine
  -----------------------------------------------------------------------------
  -- AXI Control Inputs:  s0_axi_arvalid, s0_axi_rready
  -- AXI Control Outputs: s0_axi_arready, s0_axi_rvalid, s0_axi_rresp

  -- State 0 - Idle - 0x1
  axi_rd_state_ns0_0 <= axi_rd_state_q(0) and not s0_axi_arvalid;
  axi_rd_state_ns0_1 <= axi_rd_state_q(0) and     s0_axi_arvalid;
  axi_rd_state_ns0_2 <= axi_rd_state_q(0) and '0';
  axi_rd_state_ns0_3 <= axi_rd_state_q(0) and '0';

  -- State 1 - Received ARValid - 0x2
  axi_rd_state_ns1_0 <= axi_rd_state_q(1) and '0';
  axi_rd_state_ns1_1 <= axi_rd_state_q(1) and '0';
  axi_rd_state_ns1_2 <= axi_rd_state_q(1) and '1';
  axi_rd_state_ns1_3 <= axi_rd_state_q(1) and '0';

  -- State 2 - Wait for Data - 0x4
  axi_rd_state_ns2_0 <= axi_rd_state_q(2) and '0';
  axi_rd_state_ns2_1 <= axi_rd_state_q(2) and '0';
  axi_rd_state_ns2_2 <= axi_rd_state_q(2) and '0';
  axi_rd_state_ns2_3 <= axi_rd_state_q(2) and '1';

  -- State 3 - Send Data - 0x8
  axi_rd_state_ns3_0 <= axi_rd_state_q(3) and     s0_axi_rready;
  axi_rd_state_ns3_1 <= axi_rd_state_q(3) and '0';
  axi_rd_state_ns3_2 <= axi_rd_state_q(3) and '0';
  axi_rd_state_ns3_3 <= axi_rd_state_q(3) and not s0_axi_rready;

  -- Control Outputs
  s0_axi_arready <= axi_rd_state_q(1);
  s0_axi_rvalid  <= axi_rd_state_q(3);
  s0_axi_rresp   <= "00";

  -- AXI Data Inputs:  s0_axi_araddr
  -- AXI Data Outputs: s0_axi_rdata
  -- Register Control: reg_rd_valid, reg_rd_addr
  reg_rd_valid   <= axi_rd_state_q(2);
  reg_rd_valid_d <= axi_rd_state_q(2);
  reg_rd_addr_d  <= gate(reg_rd_addr_q                , not axi_rd_state_q(0)) or
                    gate(s0_axi_araddr and x"FFFFFFFF",     axi_rd_state_q(0)); 

  -- Next State
  axi_rd_state_d(0) <= axi_rd_state_ns0_0 or axi_rd_state_ns1_0 or axi_rd_state_ns2_0 or axi_rd_state_ns3_0;
  axi_rd_state_d(1) <= axi_rd_state_ns0_1 or axi_rd_state_ns1_1 or axi_rd_state_ns2_1 or axi_rd_state_ns3_1;
  axi_rd_state_d(2) <= axi_rd_state_ns0_2 or axi_rd_state_ns1_2 or axi_rd_state_ns2_2 or axi_rd_state_ns3_2;
  axi_rd_state_d(3) <= axi_rd_state_ns0_3 or axi_rd_state_ns1_3 or axi_rd_state_ns2_3 or axi_rd_state_ns3_3;

  -----------------------------------------------------------------------------
  -- Write Transaction State Machine
  -----------------------------------------------------------------------------
  -- AXI Control Inputs:  s0_axi_awvalid, s0_axi_wvalid, s0_axi_bready
  -- AXI Control Outputs: s0_axi_awready, s0_axi_wready, s0_axi_bvalid, s0_axi_bresp

  -- State 0 - Idle - 0x01
  axi_wr_state_ns0_0 <= axi_wr_state_q(0) and not s0_axi_awvalid;
  axi_wr_state_ns0_1 <= axi_wr_state_q(0) and     s0_axi_awvalid;
  axi_wr_state_ns0_2 <= axi_wr_state_q(0) and '0';
  axi_wr_state_ns0_3 <= axi_wr_state_q(0) and '0';
  axi_wr_state_ns0_4 <= axi_wr_state_q(0) and '0';

  -- State 1 - Received AWValid - 0x02
  axi_wr_state_ns1_0 <= axi_wr_state_q(1) and '0';
  axi_wr_state_ns1_1 <= axi_wr_state_q(1) and '0';
  axi_wr_state_ns1_2 <= axi_wr_state_q(1) and '1';
  axi_wr_state_ns1_3 <= axi_wr_state_q(1) and '0';
  axi_wr_state_ns1_4 <= axi_wr_state_q(1) and '0';

  -- State 2 - Wait for WValid - 0x04
  axi_wr_state_ns2_0 <= axi_wr_state_q(2) and '0';
  axi_wr_state_ns2_1 <= axi_wr_state_q(2) and '0';
  axi_wr_state_ns2_2 <= axi_wr_state_q(2) and not s0_axi_wvalid;
  axi_wr_state_ns2_3 <= axi_wr_state_q(2) and     s0_axi_wvalid;
  axi_wr_state_ns2_4 <= axi_wr_state_q(2) and '0';

  -- State 3 - Send Data - 0x08
  axi_wr_state_ns3_0 <= axi_wr_state_q(3) and '0';
  axi_wr_state_ns3_1 <= axi_wr_state_q(3) and '0';
  axi_wr_state_ns3_2 <= axi_wr_state_q(3) and '0';
  axi_wr_state_ns3_3 <= axi_wr_state_q(3) and '0';
  axi_wr_state_ns3_4 <= axi_wr_state_q(3) and '1';

  -- State 4 - Wait for BReady - 0x10
  axi_wr_state_ns4_0 <= axi_wr_state_q(4) and     s0_axi_bready;
  axi_wr_state_ns4_1 <= axi_wr_state_q(4) and '0';
  axi_wr_state_ns4_2 <= axi_wr_state_q(4) and '0';
  axi_wr_state_ns4_3 <= axi_wr_state_q(4) and '0';
  axi_wr_state_ns4_4 <= axi_wr_state_q(4) and not s0_axi_bready;

  -- Control Outputs
  s0_axi_awready <= axi_wr_state_q(1);
  s0_axi_wready  <= axi_wr_state_q(3);
  s0_axi_bvalid  <= axi_wr_state_q(4);
  s0_axi_bresp   <= "00";

  -- AXI Data Inputs:  s0_axi_awaddr
  -- AXI Data Outputs: None
  -- Register Control: reg_wr_valid, reg_wr_addr
  reg_wr_valid   <= axi_wr_state_q(3);
  reg_wr_addr_d  <= gate(reg_wr_addr_q                , not axi_wr_state_q(0)) or
                    gate(s0_axi_awaddr and x"0003FFFF",     axi_wr_state_q(0)); 

  -- Need to delay the write data so it's valid same cycle as reg_wr_valid
  s0_axi_wdata_d <= s0_axi_wdata;

  -- Next State
  axi_wr_state_d(0) <= axi_wr_state_ns0_0 or axi_wr_state_ns1_0 or axi_wr_state_ns2_0 or axi_wr_state_ns3_0 or axi_wr_state_ns4_0;
  axi_wr_state_d(1) <= axi_wr_state_ns0_1 or axi_wr_state_ns1_1 or axi_wr_state_ns2_1 or axi_wr_state_ns3_1 or axi_wr_state_ns4_1;
  axi_wr_state_d(2) <= axi_wr_state_ns0_2 or axi_wr_state_ns1_2 or axi_wr_state_ns2_2 or axi_wr_state_ns3_2 or axi_wr_state_ns4_2;
  axi_wr_state_d(3) <= axi_wr_state_ns0_3 or axi_wr_state_ns1_3 or axi_wr_state_ns2_3 or axi_wr_state_ns3_3 or axi_wr_state_ns4_3;
  axi_wr_state_d(4) <= axi_wr_state_ns0_4 or axi_wr_state_ns1_4 or axi_wr_state_ns2_4 or axi_wr_state_ns3_4 or axi_wr_state_ns4_4;

  -----------------------------------------------------------------------------
  -- Config Registers
  -----------------------------------------------------------------------------
  s0_axi_rdata(31 downto 0) <= gate(exp_rd_data(31 downto 0),      exp_rd_data_valid                                                                                             ) or
                               gate(reg_00_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0000#, 32))) or
                               gate(reg_01_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0004#, 32))) or
                               gate(reg_02_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0070#, 32))) or
                               gate(reg_03_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0074#, 32))) or
                               gate(reg_04_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B0#, 32))) or
                               gate(reg_05_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B4#, 32))) or
                               gate(reg_06_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B8#, 32))) or
                               gate(reg_07_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00BC#, 32))) or
                               gate(reg_08_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C0#, 32))) or
                               gate(reg_09_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C4#, 32))) or
                               gate(reg_0A_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C8#, 32))) or
                               gate(reg_0B_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00CC#, 32))) or
                               gate(reg_0C_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D0#, 32))) or
                               gate(reg_0D_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D4#, 32))) or
                               gate(reg_0E_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D8#, 32))) or --unused, but better to keep some consistency
                               gate(reg_0F_q(31 downto 0),     not exp_rd_data_valid and reg_rd_valid_q and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00DC#, 32)));   --unused, but better to keep some consistency

  reg_00_d <= gate(reg_00_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0000#, 32))) and not reg_00_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_00_WE_MASK)   or (reg_00_q and not REG_00_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0000#, 32))) and not reg_00_hwwe_i) or
              gate((reg_00_update_i and REG_00_HWWE_MASK) or (reg_00_q and     (REG_00_STICKY_MASK or not REG_00_HWWE_MASK)),                                                                                                      reg_00_hwwe_i);
  reg_01_d <= gate(reg_01_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0004#, 32))) and not reg_01_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_01_WE_MASK)   or (reg_01_q and not REG_01_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0004#, 32))) and not reg_01_hwwe_i) or
              gate((reg_01_update_i and REG_01_HWWE_MASK) or (reg_01_q and     (REG_01_STICKY_MASK or not REG_01_HWWE_MASK)),                                                                                                      reg_01_hwwe_i);
  reg_02_d <= gate(reg_02_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0070#, 32))) and not reg_02_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_02_WE_MASK)   or (reg_02_q and not REG_02_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0070#, 32))) and not reg_02_hwwe_i) or
              gate((reg_02_update_i and REG_02_HWWE_MASK) or (reg_02_q and     (REG_02_STICKY_MASK or not REG_02_HWWE_MASK)),                                                                                                      reg_02_hwwe_i);
  reg_03_d <= gate(reg_03_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0074#, 32))) and not reg_03_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_03_WE_MASK)   or (reg_03_q and not REG_03_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0074#, 32))) and not reg_03_hwwe_i) or
              gate((reg_03_update_i and REG_03_HWWE_MASK) or (reg_03_q and     (REG_03_STICKY_MASK or not REG_03_HWWE_MASK)),                                                                                                      reg_03_hwwe_i);
  reg_04_d <= gate(reg_04_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B0#, 32))) and not reg_04_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_04_WE_MASK)   or (reg_04_q and not REG_04_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B0#, 32))) and not reg_04_hwwe_i) or
              gate((reg_04_update_i and REG_04_HWWE_MASK) or (reg_04_q and     (REG_04_STICKY_MASK or not REG_04_HWWE_MASK)),                                                                                                      reg_04_hwwe_i);
  reg_05_d <= gate(reg_05_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B4#, 32))) and not reg_05_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_05_WE_MASK)   or (reg_05_q and not REG_05_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B4#, 32))) and not reg_05_hwwe_i) or
              gate((reg_05_update_i and REG_05_HWWE_MASK) or (reg_05_q and     (REG_05_STICKY_MASK or not REG_05_HWWE_MASK)),                                                                                                      reg_05_hwwe_i);
  reg_06_d <= gate(reg_06_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B8#, 32))) and not reg_06_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_06_WE_MASK)   or (reg_06_q and not REG_06_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B8#, 32))) and not reg_06_hwwe_i) or
              gate((reg_06_update_i and REG_06_HWWE_MASK) or (reg_06_q and     (REG_06_STICKY_MASK or not REG_06_HWWE_MASK)),                                                                                                      reg_06_hwwe_i);
  reg_07_d <= gate(reg_07_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00BC#, 32))) and not reg_07_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_07_WE_MASK)   or (reg_07_q and not REG_07_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00BC#, 32))) and not reg_07_hwwe_i) or
              gate((reg_07_update_i and REG_07_HWWE_MASK) or (reg_07_q and     (REG_07_STICKY_MASK or not REG_07_HWWE_MASK)),                                                                                                      reg_07_hwwe_i);
  reg_08_d <= gate(reg_08_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C0#, 32))) and not reg_08_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_08_WE_MASK)   or (reg_08_q and not REG_08_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C0#, 32))) and not reg_08_hwwe_i) or
              gate((reg_08_update_i and REG_08_HWWE_MASK) or (reg_08_q and     (REG_08_STICKY_MASK or not REG_08_HWWE_MASK)),                                                                                                      reg_08_hwwe_i);
  reg_09_d <= gate(reg_09_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C4#, 32))) and not reg_09_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_09_WE_MASK)   or (reg_09_q and not REG_09_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C4#, 32))) and not reg_09_hwwe_i) or
              gate((reg_09_update_i and REG_09_HWWE_MASK) or (reg_09_q and     (REG_09_STICKY_MASK or not REG_09_HWWE_MASK)),                                                                                                      reg_09_hwwe_i);
  reg_0A_d <= gate(reg_0A_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C8#, 32))) and not reg_0A_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0A_WE_MASK)   or (reg_0A_q and not REG_0A_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C8#, 32))) and not reg_0A_hwwe_i) or
              gate((reg_0A_update_i and REG_0A_HWWE_MASK) or (reg_0A_q and     (REG_0A_STICKY_MASK or not REG_0A_HWWE_MASK)),                                                                                                      reg_0A_hwwe_i);
  reg_0B_d <= gate(reg_0B_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00CC#, 32))) and not reg_0B_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0B_WE_MASK)   or (reg_0B_q and not REG_0B_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00CC#, 32))) and not reg_0B_hwwe_i) or
              gate((reg_0B_update_i and REG_0B_HWWE_MASK) or (reg_0B_q and     (REG_0B_STICKY_MASK or not REG_0B_HWWE_MASK)),                                                                                                      reg_0B_hwwe_i);
  reg_0C_d <= gate(reg_0C_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D0#, 32))) and not reg_0C_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0C_WE_MASK)   or (reg_0C_q and not REG_0C_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D0#, 32))) and not reg_0C_hwwe_i) or
              gate((reg_0C_update_i and REG_0C_HWWE_MASK) or (reg_0C_q and     (REG_0C_STICKY_MASK or not REG_0C_HWWE_MASK)),                                                                                                      reg_0C_hwwe_i);
  reg_0D_d <= gate(reg_0D_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D4#, 32))) and not reg_0D_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0D_WE_MASK)   or (reg_0D_q and not REG_0D_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D4#, 32))) and not reg_0D_hwwe_i) or
              gate((reg_0D_update_i and REG_0D_HWWE_MASK) or (reg_0D_q and     (REG_0D_STICKY_MASK or not REG_0D_HWWE_MASK)),                                                                                                      reg_0D_hwwe_i);
  reg_0E_d <= gate(reg_0E_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D8#, 32))) and not reg_0E_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0E_WE_MASK)   or (reg_0E_q and not REG_0E_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D8#, 32))) and not reg_0E_hwwe_i) or
              gate((reg_0E_update_i and REG_0E_HWWE_MASK) or (reg_0E_q and     (REG_0E_STICKY_MASK or not REG_0E_HWWE_MASK)),                                                                                                      reg_0E_hwwe_i);
  reg_0F_d <= gate(reg_0F_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00DC#, 32))) and not reg_0F_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0F_WE_MASK)   or (reg_0F_q and not REG_0F_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00DC#, 32))) and not reg_0F_hwwe_i) or
              gate((reg_0F_update_i and REG_0F_HWWE_MASK) or (reg_0F_q and     (REG_0F_STICKY_MASK or not REG_0F_HWWE_MASK)),                                                                                                      reg_0F_hwwe_i);


-- Outputs
  reg_00_o <= reg_00_q;
  reg_01_o <= reg_01_q;
  reg_02_o <= reg_02_q;
  reg_03_o <= reg_03_q;
  reg_04_o <= reg_04_q;
  reg_05_o <= reg_05_q;
  reg_06_o <= reg_06_q;
  reg_07_o <= reg_07_q;
  reg_08_o <= reg_08_q;
  reg_09_o <= reg_09_q;
  reg_0A_o <= reg_0A_q;
  reg_0B_o <= reg_0B_q;
  reg_0C_o <= reg_0C_q;
  reg_0D_o <= reg_0D_q;
  reg_0E_o <= reg_0E_q;
  reg_0F_o <= reg_0F_q;

  -----------------------------------------------------------------------------
  -- Latches
  -----------------------------------------------------------------------------
  process (s0_axi_aclk) is
  begin
    if rising_edge(s0_axi_aclk) then
      if (s0_axi_aresetn = '0') then
        axi_rd_state_q <= "0001";
        reg_rd_addr_q  <= x"00000000";
        axi_wr_state_q <= "00001";
        reg_wr_addr_q  <= x"00000000";
        reg_00_q       <= x"00000000";
        reg_01_q       <= x"00000000";
        reg_02_q       <= x"00000000";
        reg_03_q       <= x"00000000";
        reg_04_q       <= x"00000000";
        reg_05_q       <= x"00000000";
        reg_06_q       <= x"00000000";
        reg_07_q       <= x"00000000";
        reg_08_q       <= x"00000000";
        reg_09_q       <= x"00000000";
        reg_0A_q       <= x"00000000";
        reg_0B_q       <= x"00000000";
        reg_0C_q       <= x"00000000";
        reg_0D_q       <= x"00000000";
        reg_0E_q       <= x"00000000";
        reg_0F_q       <= x"00000000";
        s0_axi_wdata_q <= x"00000000";
        reg_rd_valid_q <= '0';
      else
        axi_rd_state_q <= axi_rd_state_d;
        reg_rd_addr_q  <= reg_rd_addr_d;
        axi_wr_state_q <= axi_wr_state_d;
        reg_wr_addr_q  <= reg_wr_addr_d;
        reg_00_q       <= reg_00_d;
        reg_01_q       <= reg_01_d;
        reg_02_q       <= reg_02_d;
        reg_03_q       <= reg_03_d;
        reg_04_q       <= reg_04_d;
        reg_05_q       <= reg_05_d;
        reg_06_q       <= reg_06_d;
        reg_07_q       <= reg_07_d;
        reg_08_q       <= reg_08_d;
        reg_09_q       <= reg_09_d;
        reg_0A_q       <= reg_0A_d;
        reg_0B_q       <= reg_0B_d;
        reg_0C_q       <= reg_0C_d;
        reg_0D_q       <= reg_0D_d;
        reg_0E_q       <= reg_0E_d;
        reg_0F_q       <= reg_0F_d;
        s0_axi_wdata_q <= s0_axi_wdata_d;
        reg_rd_valid_q <= reg_rd_valid_d;
      end if;
    end if;
  end process;

end axi_regs_32;
