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
 
 
 


LIBRARY ieee, work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.axi_pkg.all;

ENTITY ice_pervasive IS
  PORT
    (
      freerun_clk                    : in  std_ulogic;
      resetn                         : in  std_ulogic;
      perv_mmio_pulse                : out std_ulogic;
      ---------------------------------------------------------------------------
      -- I2C
      ---------------------------------------------------------------------------
      SCL_IO                         : inout std_logic;
      SDA_IO                         : inout std_logic;
      ---------------------------------------------------------------------------
      -- Error Register inputs 
      ---------------------------------------------------------------------------
      trap0                          : in  std_ulogic_vector(63 downto 0);
      trap1                          : in  std_ulogic_vector(63 downto 0);
      trap2                          : in  std_ulogic_vector(63 downto 0);
      trap3                          : in  std_ulogic_vector(63 downto 0);
      trap4                          : in  std_ulogic_vector(63 downto 0);
      lem0                           : in  std_ulogic_vector(63 downto 0);
      ecid                           : in  std_ulogic_vector(63 downto 0)
      );

END ice_pervasive;

ARCHITECTURE ice_pervasive OF ice_pervasive IS

SIGNAL i2c_control_m0_axi_i   : t_AXI4_LITE_MASTER_INPUT;
SIGNAL i2c_control_m0_axi_o   : t_AXI4_LITE_MASTER_OUTPUT;
SIGNAL axi_iic_s0_axi_i       : t_AXI4_LITE_SLAVE_INPUT;
SIGNAL axi_iic_s0_axi_o       : t_AXI4_LITE_SLAVE_OUTPUT;
SIGNAL jtag_m0_axi_i          : t_AXI4_LITE_MASTER_INPUT;
SIGNAL jtag_m0_axi_o          : t_AXI4_LITE_MASTER_OUTPUT;
SIGNAL jtag_s0_axi_i          : t_AXI4_LITE_SLAVE_INPUT;  --To axi_regs
SIGNAL jtag_s0_axi_o          : t_AXI4_LITE_SLAVE_OUTPUT; --From Axi_regs
SIGNAL axi_iic_s0_axi_awaddr  : STD_LOGIC_VECTOR (63 downto 0);
SIGNAL axi_iic_s0_axi_awprot  : STD_LOGIC_VECTOR (2 downto 0);
SIGNAL axi_iic_s0_axi_awvalid : STD_LOGIC;
SIGNAL axi_iic_s0_axi_awready : STD_LOGIC;
SIGNAL axi_iic_s0_axi_wdata   : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL axi_iic_s0_axi_wstrb   : STD_LOGIC_VECTOR (3 downto 0);
SIGNAL axi_iic_s0_axi_wvalid  : STD_LOGIC;
SIGNAL axi_iic_s0_axi_wready  : STD_LOGIC;
SIGNAL axi_iic_s0_axi_bresp   : STD_LOGIC_VECTOR (1 downto 0);
SIGNAL axi_iic_s0_axi_bvalid  : STD_LOGIC;
SIGNAL axi_iic_s0_axi_bready  : STD_LOGIC;
SIGNAL axi_iic_s0_axi_araddr  : STD_LOGIC_VECTOR (63 downto 0);
SIGNAL axi_iic_s0_axi_arprot  : STD_LOGIC_VECTOR (2 downto 0);
SIGNAL axi_iic_s0_axi_arvalid : STD_LOGIC;
SIGNAL axi_iic_s0_axi_arready : STD_LOGIC;
SIGNAL axi_iic_s0_axi_rdata   : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL axi_iic_s0_axi_rresp   : STD_LOGIC_VECTOR (1 downto 0);
SIGNAL axi_iic_s0_axi_rvalid  : STD_LOGIC;
SIGNAL axi_iic_s0_axi_rready  : STD_LOGIC;
SIGNAL scl_o                  : STD_LOGIC;
SIGNAL scl_i                  : STD_LOGIC;
SIGNAL scl_t                  : STD_LOGIC;
SIGNAL sda_o                  : STD_LOGIC;
SIGNAL sda_i                  : STD_LOGIC;
SIGNAL sda_t                  : STD_LOGIC;
SIGNAL jtag_m0_axi_aresetn    : STD_LOGIC;
SIGNAL jtag_m0_axi_awvalid    : STD_LOGIC;
SIGNAL jtag_m0_axi_awaddr     : STD_LOGIC_VECTOR(63 downto 0);
SIGNAL jtag_m0_axi_awprot     : STD_LOGIC_VECTOR(2 downto 0); 
SIGNAL jtag_m0_axi_wvalid     : STD_LOGIC;
SIGNAL jtag_m0_axi_wdata      : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL jtag_m0_axi_wstrb      : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL jtag_m0_axi_bready     : STD_LOGIC;
SIGNAL jtag_m0_axi_arvalid    : STD_LOGIC;
SIGNAL jtag_m0_axi_araddr     : STD_LOGIC_VECTOR(63 downto 0);
SIGNAL jtag_m0_axi_arprot     : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL jtag_m0_axi_rready     : STD_LOGIC;
SIGNAL jtag_m0_axi_awready    : STD_LOGIC;
SIGNAL jtag_m0_axi_wready     : STD_LOGIC;
SIGNAL jtag_m0_axi_bvalid     : STD_LOGIC;
SIGNAL jtag_m0_axi_bresp      : STD_LOGIC_VECTOR(1 downto 0);
SIGNAL jtag_m0_axi_arready    : STD_LOGIC;
SIGNAL jtag_m0_axi_rvalid     : STD_LOGIC;
SIGNAL jtag_m0_axi_rdata      : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL jtag_m0_axi_rresp      : STD_LOGIC_VECTOR(1 downto 0);
SIGNAL trap0_i2c              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap1_i2c              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap2_i2c              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap3_i2c              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap4_i2c              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL lem0_i2c               : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL ecid_i2c               : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap0_l                : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL trap0_r                : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL trap1_l                : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL trap1_r                : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL trap2_l                : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL trap2_r                : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL trap3_l                : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL trap3_r                : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL trap4_l                : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL trap4_r                : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL lem0_l                 : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL lem0_r                 : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL ecid_l                 : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL ecid_r                 : STD_ULOGIC_VECTOR(31 downto 0);
SIGNAL trap0_d0_d             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap0_d0_q             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap1_d0_d             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap1_d0_q             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap2_d0_d             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap2_d0_q             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap3_d0_d             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap3_d0_q             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap4_d0_d             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap4_d0_q             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL lem0_d0_d              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL lem0_d0_q              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL ecid_d0_d              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL ecid_d0_q              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap0_d1_d             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap0_d1_q             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap1_d1_d             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap1_d1_q             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap2_d1_d             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap2_d1_q             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap3_d1_d             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap3_d1_q             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap4_d1_d             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL trap4_d1_q             : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL lem0_d1_d              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL lem0_d1_q              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL ecid_d1_d              : STD_ULOGIC_VECTOR(63 downto 0);
SIGNAL ecid_d1_q              : STD_ULOGIC_VECTOR(63 downto 0);

attribute ASYNC_REG  : string;


  --Async Reg attributes
attribute ASYNC_REG of  trap0_d0_q             : signal is "true";
attribute ASYNC_REG of  trap1_d0_q             : signal is "true";
attribute ASYNC_REG of  trap2_d0_q             : signal is "true";
attribute ASYNC_REG of  trap3_d0_q             : signal is "true";
attribute ASYNC_REG of  trap4_d0_q             : signal is "true";
attribute ASYNC_REG of  lem0_d0_q              : signal is "true";
attribute ASYNC_REG of  ecid_d0_q              : signal is "true";
attribute ASYNC_REG of  trap0_d1_q             : signal is "true";
attribute ASYNC_REG of  trap1_d1_q             : signal is "true";
attribute ASYNC_REG of  trap2_d1_q             : signal is "true";
attribute ASYNC_REG of  trap3_d1_q             : signal is "true";
attribute ASYNC_REG of  trap4_d1_q             : signal is "true";
attribute ASYNC_REG of  lem0_d1_q              : signal is "true";
attribute ASYNC_REG of  ecid_d1_q              : signal is "true";

  COMPONENT axi_iic_0
    PORT (
      s_axi_aclk : IN STD_LOGIC;
      s_axi_aresetn : IN STD_LOGIC;
      iic2intc_irpt : OUT STD_LOGIC;
      s_axi_awaddr : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC;
      s_axi_awready : OUT STD_LOGIC;
      s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_wvalid : IN STD_LOGIC;
      s_axi_wready : OUT STD_LOGIC;
      s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC;
      s_axi_bready : IN STD_LOGIC;
      s_axi_araddr : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC;
      s_axi_arready : OUT STD_LOGIC;
      s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_rvalid : OUT STD_LOGIC;
      s_axi_rready : IN STD_LOGIC;
      sda_i : IN STD_LOGIC;
      sda_o : OUT STD_LOGIC;
      sda_t : OUT STD_LOGIC;
      scl_i : IN STD_LOGIC;
      scl_o : OUT STD_LOGIC;
      scl_t : OUT STD_LOGIC;
      gpo : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT iobuf
    PORT (
      i : IN STD_LOGIC;
      o : OUT STD_LOGIC;
      t : IN STD_LOGIC;
      io : INOUT STD_LOGIC
      );
  END COMPONENT;
  
 COMPONENT jtag_axi_0
    PORT (
      aclk          : IN STD_LOGIC;          
      aresetn       : IN STD_LOGIC;
      m_axi_awaddr  : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axi_awprot  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awvalid : OUT STD_LOGIC;
      m_axi_awready : IN  STD_LOGIC;
      m_axi_wdata   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_wstrb   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_wvalid  : OUT STD_LOGIC;
      m_axi_wready  : IN  STD_LOGIC;
      m_axi_bresp   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_bvalid  : IN  STD_LOGIC;
      m_axi_bready  : OUT STD_LOGIC;
      m_axi_araddr  : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axi_arprot  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arvalid : OUT STD_LOGIC;
      m_axi_arready : IN  STD_LOGIC;
      m_axi_rdata   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_rresp   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_rvalid  : IN  STD_LOGIC;
      m_axi_rready  : OUT STD_LOGIC
      );
 END COMPONENT;
BEGIN


------------------------------------------------------------------------
--AXI/IIC
------------------------------------------------------------------------

  i2c_control : entity work.ice_i2c_control_mac
    GENERIC MAP (
--      axi_iic_offset => X"0103000000000000"
      axi_iic_offset => X"0000000000000000"
      )
    PORT MAP (
      clock           => freerun_clk,
    --  resetn          => resetn_d1_q,
      resetn          => resetn,
      m0_axi_i        => i2c_control_m0_axi_i,
      m0_axi_o        => i2c_control_m0_axi_o,
      perv_mmio_pulse => perv_mmio_pulse,
      trap0           => trap0_i2c,
      trap1           => trap1_i2c,
      trap2           => trap2_i2c,
      trap3           => trap3_i2c,
      trap4           => trap4_i2c,
      lem0            => lem0_i2c,
      ecid            => ecid_i2c
      );

--Convert Master to slave and vice versa for i/o for i2c_control/axi_iic interconnect
axi_iic_s0_axi_i     <= axi4_lite_master_slave_connect(i2c_control_m0_axi_o);
i2c_control_m0_axi_i <= axi4_lite_master_slave_connect(axi_iic_s0_axi_o);

--Build AXI4 Type Variables
axi_iic_s0_axi_awvalid          <= axi_iic_s0_axi_i.s0_axi_awvalid;
axi_iic_s0_axi_awaddr           <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_awaddr);
axi_iic_s0_axi_awprot           <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_awprot);
axi_iic_s0_axi_wvalid           <= axi_iic_s0_axi_i.s0_axi_wvalid;
axi_iic_s0_axi_wdata            <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_wdata);
axi_iic_s0_axi_wstrb            <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_wstrb);
axi_iic_s0_axi_bready           <= axi_iic_s0_axi_i.s0_axi_bready;
axi_iic_s0_axi_arvalid          <= axi_iic_s0_axi_i.s0_axi_arvalid;
axi_iic_s0_axi_araddr           <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_araddr);
axi_iic_s0_axi_arprot           <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_arprot);
axi_iic_s0_axi_rready           <= axi_iic_s0_axi_i.s0_axi_rready;
axi_iic_s0_axi_o.s0_axi_awready <= axi_iic_s0_axi_awready;
axi_iic_s0_axi_o.s0_axi_wready  <= axi_iic_s0_axi_wready;
axi_iic_s0_axi_o.s0_axi_bvalid  <= axi_iic_s0_axi_bvalid;
axi_iic_s0_axi_o.s0_axi_bresp   <= To_StdULogicVector(axi_iic_s0_axi_bresp);
axi_iic_s0_axi_o.s0_axi_arready <= axi_iic_s0_axi_arready;
axi_iic_s0_axi_o.s0_axi_rvalid  <= axi_iic_s0_axi_rvalid;
axi_iic_s0_axi_o.s0_axi_rdata   <= To_StdULogicVector(axi_iic_s0_axi_rdata);
axi_iic_s0_axi_o.s0_axi_rresp   <= To_StdULogicVector(axi_iic_s0_axi_rresp);

axi_iic : axi_iic_0
    PORT MAP (
      s_axi_aclk    => freerun_clk,
--      s_axi_aresetn => resetn_d1_q,
      s_axi_aresetn => resetn,
      iic2intc_irpt => open,
      s_axi_awaddr  => axi_iic_s0_axi_awaddr(8 downto 0),
      s_axi_awvalid => axi_iic_s0_axi_awvalid,
      s_axi_awready => axi_iic_s0_axi_awready,
      s_axi_wdata   => axi_iic_s0_axi_wdata,
      s_axi_wstrb   => axi_iic_s0_axi_wstrb,
      s_axi_wvalid  => axi_iic_s0_axi_wvalid,
      s_axi_wready  => axi_iic_s0_axi_wready,
      s_axi_bresp   => axi_iic_s0_axi_bresp,
      s_axi_bvalid  => axi_iic_s0_axi_bvalid,
      s_axi_bready  => axi_iic_s0_axi_bready,
      s_axi_araddr  => axi_iic_s0_axi_araddr(8 downto 0),
      s_axi_arvalid => axi_iic_s0_axi_arvalid,
      s_axi_arready => axi_iic_s0_axi_arready,
      s_axi_rdata   => axi_iic_s0_axi_rdata,
      s_axi_rresp   => axi_iic_s0_axi_rresp,
      s_axi_rvalid  => axi_iic_s0_axi_rvalid,
      s_axi_rready  => axi_iic_s0_axi_rready,
      sda_i         => sda_i,
      sda_o         => sda_o,
      sda_t         => sda_t,
      scl_i         => scl_i,
      scl_o         => scl_o,
      scl_t         => scl_t,
      gpo           => open
      );
  
  i2c_scl_iobuf : iobuf
    PORT MAP (
      I  => scl_o,
      IO => scl_io,
      O  => scl_i,
      T  => scl_t
      );

  i2c_sda_iobuf : iobuf
    PORT MAP (
      I  => sda_o,
      IO => sda_io,
      O  => sda_i,
      T  => sda_t
      );


------------------------------------------------------------------------
--JTAG/AXI Master 
------------------------------------------------------------------------

  jtag_axi : jtag_axi_0
    PORT MAP (
      aclk          => freerun_clk,
      aresetn       => resetn,
      m_axi_awaddr  => jtag_m0_axi_awaddr,
      m_axi_awprot  => jtag_m0_axi_awprot,
      m_axi_awvalid => jtag_m0_axi_awvalid,
      m_axi_awready => jtag_m0_axi_awready,
      m_axi_wdata   => jtag_m0_axi_wdata,
      m_axi_wstrb   => jtag_m0_axi_wstrb,
      m_axi_wvalid  => jtag_m0_axi_wvalid,
      m_axi_wready  => jtag_m0_axi_wready,
      m_axi_bresp   => jtag_m0_axi_bresp,
      m_axi_bvalid  => jtag_m0_axi_bvalid,
      m_axi_bready  => jtag_m0_axi_bready,
      m_axi_araddr  => jtag_m0_axi_araddr,
      m_axi_arprot  => jtag_m0_axi_arprot,
      m_axi_arvalid => jtag_m0_axi_arvalid,
      m_axi_arready => jtag_m0_axi_arready,
      m_axi_rdata   => jtag_m0_axi_rdata,
      m_axi_rresp   => jtag_m0_axi_rresp,
      m_axi_rvalid  => jtag_m0_axi_rvalid,
      m_axi_rready  => jtag_m0_axi_rready
      );
  
  jtag_m0_axi_o.m0_axi_aresetn <= resetn;
  jtag_m0_axi_o.m0_axi_awvalid <= jtag_m0_axi_awvalid;
  jtag_m0_axi_o.m0_axi_awaddr  <= To_StdULogicVector(jtag_m0_axi_awaddr);
  jtag_m0_axi_o.m0_axi_awprot  <= To_StdULogicVector(jtag_m0_axi_awprot);
  jtag_m0_axi_o.m0_axi_wvalid  <= jtag_m0_axi_wvalid;
  jtag_m0_axi_o.m0_axi_wdata   <= To_StdULogicVector(jtag_m0_axi_wdata);
  jtag_m0_axi_o.m0_axi_wstrb   <= To_StdULogicVector(jtag_m0_axi_wstrb);
  jtag_m0_axi_o.m0_axi_bready  <= jtag_m0_axi_bready;
  jtag_m0_axi_o.m0_axi_arvalid <= jtag_m0_axi_arvalid;
  jtag_m0_axi_o.m0_axi_araddr  <= To_StdULogicVector(jtag_m0_axi_araddr);
  jtag_m0_axi_o.m0_axi_arprot  <= To_StdULogicVector(jtag_m0_axi_arprot);
  jtag_m0_axi_o.m0_axi_rready  <= jtag_m0_axi_rready;
  jtag_m0_axi_awready          <= jtag_m0_axi_i.m0_axi_awready;
  jtag_m0_axi_wready           <= jtag_m0_axi_i.m0_axi_wready;
  jtag_m0_axi_bvalid           <= jtag_m0_axi_i.m0_axi_bvalid;
  jtag_m0_axi_bresp            <= To_StdLogicVector(jtag_m0_axi_i.m0_axi_bresp);
  jtag_m0_axi_arready          <= jtag_m0_axi_i.m0_axi_arready;
  jtag_m0_axi_rvalid           <= jtag_m0_axi_i.m0_axi_rvalid;
  jtag_m0_axi_rdata            <= To_StdLogicVector(jtag_m0_axi_i.m0_axi_rdata);
  jtag_m0_axi_rresp            <= To_StdLogicVector(jtag_m0_axi_i.m0_axi_rresp);

  --Convert Master to slave and vice versa for i/o for JTAG/AXI interconnect
  jtag_m0_axi_i       <= axi4_lite_master_slave_connect(jtag_s0_axi_o);  
  jtag_s0_axi_i       <= axi4_lite_master_slave_connect(jtag_m0_axi_o);  

----------------------------------------
--REGISTERS
----------------------------------------
--Build 64 bit regs for outputting to i2c_mac (AXI regs are only 32 bits, but MMIO sends 64 bits)
trap0_i2c <= trap0_l & trap0_r;
trap1_i2c <= trap1_l & trap1_r;
trap2_i2c <= trap2_l & trap2_r;
trap3_i2c <= trap3_l & trap3_r;
trap4_i2c <= trap4_l & trap4_r;
lem0_i2c  <= lem0_l  & lem0_r;
ecid_i2c  <= ecid_l  & ecid_r;


--Double latch error regs from MMIO block due to domain crossing
  trap0_d0_d(63 downto 0) <= trap0(63 downto 0);
  trap1_d0_d(63 downto 0) <= trap1(63 downto 0);
  trap2_d0_d(63 downto 0) <= trap2(63 downto 0);
  trap3_d0_d(63 downto 0) <= trap3(63 downto 0);
  trap4_d0_d(63 downto 0) <= trap4(63 downto 0);
  lem0_d0_d(63 downto 0)  <= lem0(63 downto 0);
  ecid_d0_d(63 downto 0)  <= ecid(63 downto 0);
 
  trap0_d1_d(63 downto 0) <= trap0_d0_q(63 downto 0);
  trap1_d1_d(63 downto 0) <= trap1_d0_q(63 downto 0);
  trap2_d1_d(63 downto 0) <= trap2_d0_q(63 downto 0);
  trap3_d1_d(63 downto 0) <= trap3_d0_q(63 downto 0);
  trap4_d1_d(63 downto 0) <= trap4_d0_q(63 downto 0);
  lem0_d1_d(63 downto 0)  <= lem0_d0_q(63 downto 0);
  ecid_d1_d(63 downto 0)  <= ecid_d0_q(63 downto 0);





  axi_regs : entity work.axi_regs_32
    GENERIC MAP (
        offset => 16#48092070#,  --first nibble=4 for JTAG
        REG_00_RESET       => x"00000000",
        REG_01_RESET       => x"00000000",
        REG_02_RESET       => x"00000000",
        REG_03_RESET       => x"00000000",
        REG_04_RESET       => x"00000000",
        REG_05_RESET       => x"00000000",
        REG_06_RESET       => x"00000000",
        REG_07_RESET       => x"00000000",
        REG_08_RESET       => x"00000000",
        REG_09_RESET       => x"00000000",
        REG_0A_RESET       => x"00000000",
        REG_00_HWWE_MASK => x"FFFFFFFF",
        REG_01_HWWE_MASK => x"FFFFFFFF",
        REG_02_HWWE_MASK => x"FFFFFFFF",
        REG_03_HWWE_MASK => x"FFFFFFFF",
        REG_04_HWWE_MASK => x"FFFFFFFF",
        REG_05_HWWE_MASK => x"FFFFFFFF",
        REG_06_HWWE_MASK => x"FFFFFFFF",
        REG_07_HWWE_MASK => x"FFFFFFFF",
        REG_08_HWWE_MASK => x"FFFFFFFF",
        REG_09_HWWE_MASK => x"FFFFFFFF",
        REG_0A_HWWE_MASK => x"FFFFFFFF",
        REG_0B_HWWE_MASK => x"FFFFFFFF",
        REG_0C_HWWE_MASK => x"FFFFFFFF",
        REG_0D_HWWE_MASK => x"FFFFFFFF"
      ) 
    PORT MAP (
       -- AXI4-Lite
       s0_axi_aclk   => freerun_clk, 
       s0_axi_i      => jtag_s0_axi_i,
       s0_axi_o      => jtag_s0_axi_o,
      
       -- Register Data
       reg_00_o          => ecid_l,
       reg_01_o          => ecid_r,
       reg_02_o          => lem0_l,
       reg_03_o          => lem0_r,
       reg_04_o          => trap0_l,
       reg_05_o          => trap0_r,
       reg_06_o          => trap1_l,
       reg_07_o          => trap1_r,
       reg_08_o          => trap2_l,
       reg_09_o          => trap2_r,
       reg_0A_o          => trap3_l,
       reg_0B_o          => trap3_r,
       reg_0C_o          => trap4_l,
       reg_0D_o          => trap4_r,
       reg_0E_o          => open,
       reg_0F_o          => open,
  
       -- Expandable Register Interface
       -- Read Data
       exp_rd_valid      => open,
       exp_rd_address    => open,
       exp_rd_data       => (others => '0'),
       exp_rd_data_valid => '0',
       -- Write Data
       exp_wr_valid      => open,
       exp_wr_address    => open,
       exp_wr_data       => open,
 
    -- Hardware Write Update Values and Enables
       reg_00_update_i   => ecid_d1_q(63 downto 32),
       reg_01_update_i   => ecid_d1_q(31 downto 0),
       reg_02_update_i   => lem0_d1_q(63 downto 32),
       reg_03_update_i   => lem0_d1_q(31 downto 0),
       reg_04_update_i   => trap0_d1_q(63 downto 32),
       reg_05_update_i   => trap0_d1_q(31 downto 0),
       reg_06_update_i   => trap1_d1_q(63 downto 32),
       reg_07_update_i   => trap1_d1_q(31 downto 0),
       reg_08_update_i   => trap2_d1_q(63 downto 32),
       reg_09_update_i   => trap2_d1_q(31 downto 0),
       reg_0A_update_i   => trap3_d1_q(63 downto 32),
       reg_0B_update_i   => trap3_d1_q(31 downto 0),
       reg_0C_update_i   => trap4_d1_q(63 downto 32),
       reg_0D_update_i   => trap4_d1_q(31 downto 0),
       reg_0E_update_i   => (others => '0'),
       reg_0F_update_i   => (others => '0'),
       reg_00_hwwe_i     => '1',
       reg_01_hwwe_i     => '1',
       reg_02_hwwe_i     => '1',
       reg_03_hwwe_i     => '1',
       reg_04_hwwe_i     => '1',
       reg_05_hwwe_i     => '1',
       reg_06_hwwe_i     => '1',
       reg_07_hwwe_i     => '1',
       reg_08_hwwe_i     => '1',
       reg_09_hwwe_i     => '1',
       reg_0A_hwwe_i     => '1',
       reg_0B_hwwe_i     => '1',
       reg_0C_hwwe_i     => '1',
       reg_0D_hwwe_i     => '1',
       reg_0E_hwwe_i     => '0',
       reg_0F_hwwe_i     => '0'
       );
  

--Process for metastability latches
   process(freerun_clk) is 
   begin
     if rising_edge(freerun_clk) then
        if(resetn = '0') then
           trap0_d0_q  <= (others => '0');  
           trap1_d0_q  <= (others => '0');  
           trap2_d0_q  <= (others => '0');  
           trap3_d0_q  <= (others => '0');  
           trap4_d0_q  <= (others => '0');  
           lem0_d0_q   <= (others => '0');  
           ecid_d0_q   <= (others => '0');  
           trap0_d1_q  <= (others => '0');  
           trap1_d1_q  <= (others => '0');  
           trap2_d1_q  <= (others => '0');  
           trap3_d1_q  <= (others => '0');  
           trap4_d1_q  <= (others => '0');  
           lem0_d1_q   <= (others => '0');  
           ecid_d1_q   <= (others => '0');  
        else           
           trap0_d0_q  <= trap0_d0_d;
           trap1_d0_q  <= trap1_d0_d;
           trap2_d0_q  <= trap2_d0_d;
           trap3_d0_q  <= trap3_d0_d;
           trap4_d0_q  <= trap4_d0_d;
           lem0_d0_q   <= lem0_d0_d;
           ecid_d0_q   <= ecid_d0_d;
           trap0_d1_q  <= trap0_d1_d;
           trap1_d1_q  <= trap1_d1_d;
           trap2_d1_q  <= trap2_d1_d;
           trap3_d1_q  <= trap3_d1_d;
           trap4_d1_q  <= trap4_d1_d;
           lem0_d1_q   <= lem0_d1_d;
           ecid_d1_q   <= ecid_d1_d;
       end if;
     end if;
   end process;







 
END ice_pervasive;
