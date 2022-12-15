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
 
library ieee, work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.axi_pkg.all;
use work.ice_func.all;

entity ice_i2c_control_mac is
  generic (
    axi_iic_offset : std_ulogic_vector(63 downto 0) := (others => '0')
  );
  port (
    clock            : in  std_ulogic;
    resetn           : in  std_ulogic;
    trap0            : in  std_ulogic_vector(63 downto 0);
    trap1            : in  std_ulogic_vector(63 downto 0);
    trap2            : in  std_ulogic_vector(63 downto 0);
    trap3            : in  std_ulogic_vector(63 downto 0);
    trap4            : in  std_ulogic_vector(63 downto 0);
    lem0             : in  std_ulogic_vector(63 downto 0);
    ecid             : in  std_ulogic_vector(63 downto 0);
    perv_mmio_pulse  : out std_ulogic;
    m0_axi_i         : in  t_AXI4_LITE_MASTER_INPUT;
    m0_axi_o         : out t_AXI4_LITE_MASTER_OUTPUT
  );
end ice_i2c_control_mac;

architecture ice_i2c_control_mac of ice_i2c_control_mac is

--Prob Don't need these as latches anymore since we are using axi_reg_32 for jtag interface
--  signal trap0_d        : std_ulogic_vector(63 downto 0);
--  signal trap0_q        : std_ulogic_vector(63 downto 0);
--  signal trap1_d        : std_ulogic_vector(63 downto 0);
--  signal trap1_q        : std_ulogic_vector(63 downto 0);
--  signal trap2_d        : std_ulogic_vector(63 downto 0);
--  signal trap2_q        : std_ulogic_vector(63 downto 0);
--  signal trap3_d        : std_ulogic_vector(63 downto 0);
--  signal trap3_q        : std_ulogic_vector(63 downto 0);
--  signal trap4_d        : std_ulogic_vector(63 downto 0);
--  signal trap4_q        : std_ulogic_vector(63 downto 0);
--  signal lem0_d         : std_ulogic_vector(63 downto 0);
--  signal lem0_q         : std_ulogic_vector(63 downto 0);
--  signal ecid_d         : std_ulogic_vector(63 downto 0);
--  signal ecid_q         : std_ulogic_vector(63 downto 0);
  signal pulse_d        : std_ulogic;
  signal pulse_q        : std_ulogic;
  signal pulse_left     : std_ulogic;
--  signal pulse_right    : std_ulogic;
  signal trap0_left     : std_ulogic;
  signal trap0_right    : std_ulogic;
  signal trap1_left     : std_ulogic;
  signal trap1_right    : std_ulogic;
  signal trap2_left     : std_ulogic;
  signal trap2_right    : std_ulogic;
  signal trap3_left     : std_ulogic;
  signal trap3_right    : std_ulogic;
  signal trap4_left     : std_ulogic;
  signal trap4_right    : std_ulogic;
  signal lem0_left      : std_ulogic;
  signal lem0_right     : std_ulogic;
  signal ecid_left      : std_ulogic;
  signal ecid_right     : std_ulogic;
  signal m0_axi_aresetn : std_ulogic;
  signal m0_axi_awvalid : std_ulogic;
  signal m0_axi_awready : std_ulogic;
  signal m0_axi_awaddr  : std_ulogic_vector(63 downto 0);
  signal m0_axi_awprot  : std_ulogic_vector(2 downto 0);
  signal m0_axi_wvalid  : std_ulogic;
  signal m0_axi_wready  : std_ulogic;
  signal m0_axi_wdata   : std_ulogic_vector(31 downto 0);
  signal m0_axi_wstrb   : std_ulogic_vector(3 downto 0);
  signal m0_axi_bvalid  : std_ulogic;
  signal m0_axi_bready  : std_ulogic;
  signal m0_axi_bresp   : std_ulogic_vector(1 downto 0);
  signal m0_axi_arvalid : std_ulogic;
  signal m0_axi_arready : std_ulogic;
  signal m0_axi_araddr  : std_ulogic_vector(63 downto 0);
  signal m0_axi_arprot  : std_ulogic_vector(2 downto 0);
  signal m0_axi_rvalid  : std_ulogic;
  signal m0_axi_rready  : std_ulogic;
  signal m0_axi_rdata   : std_ulogic_vector(31 downto 0);
  signal m0_axi_rresp   : std_ulogic_vector(1 downto 0);
  signal address_from_i2c       : std_ulogic_vector(31 downto 0) := X"00000000";
  signal address_from_i2c_comp  : std_ulogic_vector(31 downto 0) := X"00000000";
  signal data_to_i2c            : std_ulogic_vector(31 downto 0) := X"dec0de00";
  signal data_from_i2c          : std_ulogic_vector(31 downto 0) := X"00000000";
  signal cmd                    : std_ulogic_vector(7 downto 0)  := "00000000";
  signal fw_status              : std_ulogic                     := '0';
  signal boot_config            : std_ulogic                     := '0';
  signal cmd_is_rd              : std_ulogic                     := '0';
  signal lt_rd_combo            : std_ulogic                     := '0';
  signal lt_rd_address_mismatch : std_ulogic                     := '0';
  signal cmd_is_rd_lt           : std_ulogic                     := '0';
  signal cmd_is_wr              : std_ulogic                     := '0';
  signal fake_reg               : std_ulogic_vector(31 downto 0) := X"dec0de0b";
  signal data_sel               : std_ulogic_vector(16 downto 0) := (others => '0');
  signal menterp_left           : std_ulogic;
  signal menterp_right          : std_ulogic;
  signal fw_status_data         : std_ulogic_vector(31 downto 0) := (others => '0');
  signal status                 : std_ulogic_vector(7 downto 0)  := (others => '0');
  signal boot_config_status     : std_ulogic_vector(7 downto 0)  := (others => '0');
  signal speed                  : std_ulogic_vector(3 downto 0)  := (others => '0');
  signal boot_config_data       : std_ulogic_vector(31 downto 0) := (others => '0');
  signal normal_mode_compare    : std_ulogic;
--  signal full_boot_compare      : std_ulogic;

  type ST_CONTROL is (
    ST_CONTROL_IDLE,                                                             -- 0
    ST_CONTROL_SET_SOFTR,                                                        -- 1
    ST_CONTROL_SET_CR_0,                                                         -- 2
    ST_CONTROL_SET_CR_1,                                                         -- 3
    ST_CONTROL_SET_ADR,                                                          -- 4
    ST_CONTROL_SET_RX_FIFO_PIRQ,                                                 -- 5
    ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR,  -- 6
    ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_CLEAR,                             -- 7
    ST_CONTROL_GET_CHECK_CMD,                                                    -- 8 READ Rx FIFO for cmd
    ST_CONTROL_GET_LENGTH,                                                       -- 9 Read Rx FIF0 for length
    ST_CONTROL_I2C_READ,                                                         -- 10 Go through I2c Rd state machine
    ST_CONTROL_I2C_WRITE,                                                        -- 11 Go through i2c wr state machine
    ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET,                              -- 12 Wait for everything to be transmitted
    ST_CONTROL_ERROR                                                             -- 13 Shouldn't ever go to this state
  );


  signal control_state : ST_CONTROL := ST_CONTROL_IDLE;

  type ST_AXI_READ is (
    ST_AXI_READ_IDLE,                   -- 0
    ST_AXI_READ_CMD,                    -- 1
    ST_AXI_READ_WAIT,                   -- 2
    ST_AXI_READ_DONE,                   -- 3
    ST_AXI_READ_ERROR                   -- 4
  );

  signal axi_read_state                    : ST_AXI_READ := ST_AXI_READ_IDLE;
  signal axi_read_valid                    : std_ulogic;
  signal axi_read_address                  : std_ulogic_vector(63 downto 0);
  signal axi_read_data                     : std_ulogic_vector(31 downto 0);
  signal axi_read_valid_during_i2c_read    : std_ulogic;
  signal axi_read_address_during_i2c_read  : std_ulogic_vector(63 downto 0);
  signal axi_read_valid_during_i2c_write   : std_ulogic;
  signal axi_read_address_during_i2c_write : std_ulogic_vector(63 downto 0);

  type ST_AXI_WRITE is (
    ST_AXI_WRITE_IDLE,                  -- 0
    ST_AXI_WRITE_CMD,                   -- 1
    ST_AXI_WRITE_WAIT,                  -- 2
    ST_AXI_WRITE_DONE,                  -- 3
    ST_AXI_WRITE_ERROR                  -- 4
  );

  type ST_I2C_READ is (
    ST_I2C_READ_IDLE,                   -- 0
    ST_I2C_READ_GET_ADDR0,              -- 1
    ST_I2C_READ_GET_ADDR1,              -- 2
    ST_I2C_READ_GET_ADDR2,              -- 3
    ST_I2C_READ_GET_ADDR3,              -- 4
    ST_I2C_READ_GET_AXI_REG,            -- 5
    ST_I2C_READ_SET_TX_FIFO0,           -- 6
    ST_I2C_READ_SET_TX_FIFO1,           -- 7
    ST_I2C_READ_SET_TX_FIFO2,           -- 8
    ST_I2C_READ_SET_TX_FIFO3,           -- 9
    ST_I2C_READ_SET_TX_FIFO4,           -- 10
    ST_I2C_READ_DONE,                   -- 11
    ST_I2C_READ_ERROR                   -- 12
  );

  signal i2c_read_state : ST_I2C_READ := ST_I2C_READ_IDLE;

  type ST_I2C_WRITE is (
    ST_I2C_WRITE_IDLE,               -- 0
    ST_I2C_WRITE_GET_ADDR0,          -- 1
    ST_I2C_WRITE_GET_ADDR1,          -- 2
    ST_I2C_WRITE_GET_ADDR2,          -- 3
    ST_I2C_WRITE_GET_ADDR3,          -- 4
    ST_I2C_WRITE_GET_DATA0,          -- 5
    ST_I2C_WRITE_GET_DATA1,          -- 6
    ST_I2C_WRITE_GET_DATA2,          -- 7
    ST_I2C_WRITE_GET_DATA3,          -- 8
    ST_I2C_WRITE_SET_AXI_REG,        -- 9
    ST_I2C_WRITE_DONE,               -- 10
    ST_I2C_WRITE_ERROR               -- 11
  );

  signal i2c_write_state : ST_I2C_WRITE := ST_I2C_WRITE_IDLE;

  signal axi_write_state                    : ST_AXI_WRITE := ST_AXI_WRITE_IDLE;
  signal axi_write_valid                    : std_ulogic;
  signal axi_write_address                  : std_ulogic_vector(63 downto 0);
  signal axi_write_data                     : std_ulogic_vector(31 downto 0);
  signal axi_write_valid_during_i2c_read    : std_ulogic;
  signal axi_write_address_during_i2c_read  : std_ulogic_vector(63 downto 0);
  signal axi_write_data_during_i2c_read     : std_ulogic_vector(31 downto 0);
  --signal axi_write_valid_during_i2c_write   : std_ulogic;
 -- signal axi_write_address_during_i2c_write : std_ulogic_vector(63 downto 0);

  signal axi_read_state_is_done  : std_ulogic;
  signal axi_write_state_is_done : std_ulogic;
  signal i2c_read_state_is_done  : std_ulogic;
  signal i2c_write_state_is_done : std_ulogic;


  attribute mark_debug : string;
  attribute keep       : string;

  --For ILA, commented some out for space
  attribute mark_debug of control_state            : signal is "true";
  attribute mark_debug of axi_read_state           : signal is "true";
  attribute mark_debug of i2c_read_state           : signal is "true";
  attribute mark_debug of axi_write_state          : signal is "true";
  attribute mark_debug of i2c_write_state          : signal is "true";
  attribute mark_debug of address_from_i2c         : signal is "true";
  attribute mark_debug of address_from_i2c_comp    : signal is "true";
  attribute mark_debug of data_to_i2c              : signal is "true";
  attribute mark_debug of data_from_i2c            : signal is "true";
  attribute mark_debug of axi_read_data            : signal is "true";
  
--  attribute mark_debug of resetn                   : signal is "true";
--  attribute mark_debug of m0_axi_aresetn           : signal is "true";
--  attribute mark_debug of m0_axi_awvalid           : signal is "true";
--  attribute mark_debug of m0_axi_awready           : signal is "true";
--  attribute mark_debug of m0_axi_awaddr            : signal is "true";
--  attribute mark_debug of m0_axi_awprot            : signal is "true";
--  attribute mark_debug of m0_axi_wvalid            : signal is "true";
--  attribute mark_debug of m0_axi_wready            : signal is "true";
--  attribute mark_debug of m0_axi_wdata             : signal is "true";
--  attribute mark_debug of m0_axi_arready           : signal is "true";
--  attribute mark_debug of m0_axi_araddr            : signal is "true";
--  attribute mark_debug of m0_axi_arvalid           : signal is "true";
--  attribute mark_debug of m0_axi_rvalid            : signal is "true";
--  attribute mark_debug of m0_axi_rdata             : signal is "true";
--  attribute mark_debug of data_sel                 : signal is "true";
--  attribute mark_debug of trap0                    : signal is "true";
--  attribute mark_debug of trap1                    : signal is "true";
--  attribute mark_debug of trap2                    : signal is "true";
--  attribute mark_debug of trap3                    : signal is "true";
--  attribute mark_debug of trap4                    : signal is "true";
--  attribute mark_debug of lem0                     : signal is "true";
--  attribute mark_debug of ecid                     : signal is "true";
--  attribute mark_debug of pulse_q                  : signal is "true";
--  attribute mark_debug of fw_status                : signal is "true";
  attribute mark_debug of boot_config              : signal is "true";
--  attribute mark_debug of cmd_is_rd                : signal is "true";
  attribute mark_debug of lt_rd_combo              : signal is "true";
--  attribute mark_debug of lt_rd_address_mismatch   : signal is "true";
--  attribute mark_debug of cmd_is_rd_lt             : signal is "true";
--  attribute mark_debug of cmd_is_wr                : signal is "true";
--  attribute mark_debug of fake_reg                 : signal is "true";
--  attribute mark_debug of fw_status_data           : signal is "true";
--  attribute mark_debug of boot_config_data         : signal is "true";
--  attribute mark_debug of boot_config_status       : signal is "true";
--  attribute mark_debug of normal_mode_compare      : signal is "true";
--  attribute mark_debug of full_boot_compare        : signal is "true";
 

begin
  
  --Speed, hardcoded value. Need to change vhdl if it changes on fpga
  --"0000" -- Undefined error 
  --"0001" -- 21.33 GBPS
  --"0010" -- 23.46 GBPS
  --"0011" -- 25.6  GBPS
  --"0100" -- Unsupported
  --"1111" -- Unsupported 
  speed <= "0001"; 
  
  --Assign AXI signals to outputs or intermediate signals
  m0_axi_aresetn          <= resetn;
  m0_axi_o.m0_axi_aresetn <= m0_axi_aresetn;
  m0_axi_o.m0_axi_awvalid <= m0_axi_awvalid;
  m0_axi_awready          <= m0_axi_i.m0_axi_awready;
  m0_axi_o.m0_axi_awaddr  <= m0_axi_awaddr;
  m0_axi_o.m0_axi_awprot  <= m0_axi_awprot;
  m0_axi_o.m0_axi_wvalid  <= m0_axi_wvalid;
  m0_axi_wready           <= m0_axi_i.m0_axi_wready;
  m0_axi_o.m0_axi_wdata   <= m0_axi_wdata;
  m0_axi_o.m0_axi_wstrb   <= m0_axi_wstrb;
  m0_axi_bvalid           <= m0_axi_i.m0_axi_bvalid;
  m0_axi_o.m0_axi_bready  <= m0_axi_bready;
  m0_axi_bresp            <= m0_axi_i.m0_axi_bresp;
  m0_axi_o.m0_axi_arvalid <= m0_axi_arvalid;
  m0_axi_arready          <= m0_axi_i.m0_axi_arready;
  m0_axi_o.m0_axi_araddr  <= m0_axi_araddr;
  m0_axi_o.m0_axi_arprot  <= m0_axi_arprot;
  m0_axi_rvalid           <= m0_axi_i.m0_axi_rvalid;
  m0_axi_o.m0_axi_rready  <= m0_axi_rready;
  m0_axi_rdata            <= m0_axi_i.m0_axi_rdata;
  m0_axi_rresp            <= m0_axi_i.m0_axi_rresp;
  m0_axi_awprot             <= (others => '0');
  m0_axi_arprot             <= (others => '0');

  axi_read_state_is_done  <= '1' when axi_read_state = ST_AXI_READ_DONE   else '0';
  axi_write_state_is_done <= '1' when axi_write_state = ST_AXI_WRITE_DONE else '0';
  i2c_read_state_is_done  <= '1' when i2c_read_state = ST_I2C_READ_DONE   else '0';
  i2c_write_state_is_done <= '1' when i2c_write_state = ST_I2C_WRITE_DONE else '0';
 
  --Set When to do an AXI Read  
  with control_state select axi_read_valid <=
    '1'                             when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR,
    '1'                             when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_CLEAR,
    '1'                             when ST_CONTROL_GET_CHECK_CMD,
    '1'                             when ST_CONTROL_GET_LENGTH,
    axi_read_valid_during_i2c_read  when ST_CONTROL_I2C_READ,
    axi_read_valid_during_i2c_write when ST_CONTROL_I2C_WRITE,
    '1'                             when ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET,
    '0'                             when others;

  --Select AXI Read Address
  --x104 is status reg
  --x10C is Rx Fifo
  with control_state select axi_read_address <=
    axi_iic_offset(63 downto 12) & x"104" when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR,
    axi_iic_offset(63 downto 12) & x"104" when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_CLEAR,
    axi_iic_offset(63 downto 12) & x"104" when ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET,
    axi_iic_offset(63 downto 12) & x"10C" when ST_CONTROL_GET_CHECK_CMD,
    axi_iic_offset(63 downto 12) & x"10C" when ST_CONTROL_GET_LENGTH,
    axi_read_address_during_i2c_write     when ST_CONTROL_I2C_WRITE,
    axi_read_address_during_i2c_read      when ST_CONTROL_I2C_READ,
    (others => '0')                       when others; 

  --AXI Read during I2C Read 
  with i2c_read_state select axi_read_valid_during_i2c_read <=
    '1' when ST_I2C_READ_GET_ADDR0,
    '1' when ST_I2C_READ_GET_ADDR1,
    '1' when ST_I2C_READ_GET_ADDR2,
    '1' when ST_I2C_READ_GET_ADDR3,
    '0' when others;

  --During I2C Read, read Rx FIFO
  with i2c_read_state select axi_read_address_during_i2c_read <=
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_READ_GET_ADDR0,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_READ_GET_ADDR1,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_READ_GET_ADDR2,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_READ_GET_ADDR3,
    (others => '0')  when others;

  --AXI Read During I2C Write
  with i2c_write_state select axi_read_valid_during_i2c_write <=
    '1' when ST_I2C_WRITE_GET_ADDR0,
    '1' when ST_I2C_WRITE_GET_ADDR1,
    '1' when ST_I2C_WRITE_GET_ADDR2,
    '1' when ST_I2C_WRITE_GET_ADDR3,
    '1' when ST_I2C_WRITE_GET_DATA0,
    '1' when ST_I2C_WRITE_GET_DATA1,
    '1' when ST_I2C_WRITE_GET_DATA2,
    '1' when ST_I2C_WRITE_GET_DATA3,
    '0' when others;

  --During I2C Write, get address and data from Rx Fifo
  with i2c_write_state select axi_read_address_during_i2c_write <=
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_ADDR0,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_ADDR1,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_ADDR2,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_ADDR3,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_DATA0,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_DATA1,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_DATA2,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_DATA3,
    (others => '0')                       when others;

  --Select when to do an AXI Write
  with control_state select axi_write_valid <=
    '1'                              when ST_CONTROL_SET_SOFTR,
    '1'                              when ST_CONTROL_SET_CR_0,
    '1'                              when ST_CONTROL_SET_CR_1,
    '1'                              when ST_CONTROL_SET_ADR,
    '1'                              when ST_CONTROL_SET_RX_FIFO_PIRQ,
    axi_write_valid_during_i2c_read  when ST_CONTROL_I2C_READ,
    '0'                              when others;

  --Select AXI Write Address
  --x040 SOFTR Register
  --x100 Control Register
  --x110 Slave Address Register
  --x120 Rx FIFO PIRQ (for interrupts)
  with control_state select axi_write_address <=
    axi_iic_offset(63 downto 12) & X"040" when ST_CONTROL_SET_SOFTR,
    axi_iic_offset(63 downto 12) & X"100" when ST_CONTROL_SET_CR_0,
    axi_iic_offset(63 downto 12) & X"100" when ST_CONTROL_SET_CR_1,
    axi_iic_offset(63 downto 12) & X"110" when ST_CONTROL_SET_ADR,
    axi_iic_offset(63 downto 12) & X"120" when ST_CONTROL_SET_RX_FIFO_PIRQ,
    axi_write_address_during_i2c_read     when ST_CONTROL_I2C_READ,
    (others => '0')                       when others;

  --Select Data to write 
  with control_state select axi_write_data <=
    X"0000000A"                     when ST_CONTROL_SET_SOFTR, --From spec, write A to have default values
    X"00000000"                     when ST_CONTROL_SET_CR_0,  --Write 0s to clear register
    X"00000001"                     when ST_CONTROL_SET_CR_1,  --Write 1 to enable axi_iic
    X"00000040"                     when ST_CONTROL_SET_ADR,   --x40 is slave address for OCMB (including bit 0 reserved)
    X"000000FF"                     when ST_CONTROL_SET_RX_FIFO_PIRQ, --Write to enable interrupt when all 16 spots are full
    axi_write_data_during_i2c_read  when ST_CONTROL_I2C_READ,  --Specific write data for fw_status read
    (others => '0')                 when others;

  --During I2C read, write to Tx fifo
  with i2c_read_state select axi_write_valid_during_i2c_read <=
    '1' when ST_I2C_READ_SET_TX_FIFO0,
    '1' when ST_I2C_READ_SET_TX_FIFO1,
    '1' when ST_I2C_READ_SET_TX_FIFO2,
    '1' when ST_I2C_READ_SET_TX_FIFO3,
    '1' when ST_I2C_READ_SET_TX_FIFO4,
    '0' when others;

  --Select AXI write address during i2c read, always Tx fifo
  with i2c_read_state select axi_write_address_during_i2c_read <=
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO0,
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO1,
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO2,
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO3,
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO4,
    (others => '0')                       when others;

  --Select Length, or data from select mux 
  with i2c_read_state select axi_write_data_during_i2c_read <=
    X"00000004"                           when ST_I2C_READ_SET_TX_FIFO0, --Length of 4 bytes
    X"000000" & data_to_i2c(31 downto 24) when ST_I2C_READ_SET_TX_FIFO1,
    X"000000" & data_to_i2c(23 downto 16) when ST_I2C_READ_SET_TX_FIFO2,
    X"000000" & data_to_i2c(15 downto 8)  when ST_I2C_READ_SET_TX_FIFO3,
    X"000000" & data_to_i2c(7 downto 0)   when ST_I2C_READ_SET_TX_FIFO4,
    (others => '0')                       when others;
    
    
    --Build FW Status Data
    fw_status_data(31 downto 0) <=  "00000000000000"     & --31:18 Reserved
                                    "11"                 & --17:16 Boot Stage ("11" for runtime fw)
                                    status(7 downto 0)   & --15:8  Status Code (Is x00 the correct value?)
                                    cmd(7 downto 0)      ; --7:0   Previous Cmd
    
    with cmd(7 downto 0) select status <= 
    boot_config_status         when X"01", --When previous cmd was a boot config, use the checking logic to know if config was okay
    (others => '0')            when others; --Everything else should be considered a success. Return x00 for that
    
    --Boot Config Checking (If they don't match the expected value then return an error)
    boot_config_status(1) <= boot_config_data(12)           xor  '0';   --Expected boot control bit is 0
    boot_config_status(2) <= boot_config_data(11 downto 10) /=  "00";   --Transport layer should be set to 00 for OpenCAPI
    boot_config_status(3) <= boot_config_data(9 downto 8)   /=  "00";   --DL Layer boot mode should be 00 for boot right after SerDes is configured
    boot_config_status(4) <= boot_config_data(3 downto 0)   /=  speed;  --Defaults to 25.6, but will change for faster or slower image
    boot_config_status(5) <= boot_config_data(6 downto 4)   /=  "001";  --Lane mode should be 001 for 8 lane   
    boot_config_status(6) <= '0';
    boot_config_status(7) <= '0';
    normal_mode_compare   <= boot_config_data(14 downto 13) /=  "00";   --Doesn't have its own specific error bit. Should be set to 00 for normal mode
  --LIF Took out (Don't trigger error on DFE)  full_boot_compare     <= boot_config_data(7)            xor  '0';   --Doesn't have its own specific error bit. Should be set to 0 for full boot 
 
    boot_config_status(0) <= or_reduce(boot_config_status(5 downto 1) & normal_mode_compare); --If any of the above bits are set, then invalid boot config cmd 
  
    --Special Reg Address Match
    --Need last NOT (fw_status or boot_config) since address doesn't get updated on these cmds
    menterp_left      <= (address_from_i2c(31 downto 0) = X"A8084720") and not (fw_status or boot_config);
    menterp_right     <= (address_from_i2c(31 downto 0) = X"A8084724") and not (fw_status or boot_config); --Need to return all 0s for this one
    trap0_left        <= (address_from_i2c(31 downto 0) = X"A8092120") and not (fw_status or boot_config);
    trap0_right       <= (address_from_i2c(31 downto 0) = X"A8092124") and not (fw_status or boot_config);
    trap1_left        <= (address_from_i2c(31 downto 0) = X"A8092128") and not (fw_status or boot_config);
    trap1_right       <= (address_from_i2c(31 downto 0) = X"A809212C") and not (fw_status or boot_config);
    trap2_left        <= (address_from_i2c(31 downto 0) = X"A8092130") and not (fw_status or boot_config);
    trap2_right       <= (address_from_i2c(31 downto 0) = X"A8092134") and not (fw_status or boot_config);
    trap3_left        <= (address_from_i2c(31 downto 0) = X"A8092138") and not (fw_status or boot_config);
    trap3_right       <= (address_from_i2c(31 downto 0) = X"A809213C") and not (fw_status or boot_config);
    trap4_left        <= (address_from_i2c(31 downto 0) = X"A8092140") and not (fw_status or boot_config);
    trap4_right       <= (address_from_i2c(31 downto 0) = X"A8092144") and not (fw_status or boot_config);
    lem0_left         <= (address_from_i2c(31 downto 0) = X"A80920E0") and not (fw_status or boot_config); 
    lem0_right        <= (address_from_i2c(31 downto 0) = X"A80920E4") and not (fw_status or boot_config); 
    ecid_left         <= (address_from_i2c(31 downto 0) = X"A8092070") and not (fw_status or boot_config); --Prob need to return all 0s for this one
    ecid_right        <= (address_from_i2c(31 downto 0) = X"A8092074") and not (fw_status or boot_config); 
    pulse_left        <= (address_from_i2c(31 downto 0) = X"A8092068") and not (fw_status or boot_config); 
--    pulse_right       <= (address_from_i2c(31 downto 0) = X"A809206C") and not (fw_status or boot_config); 
    --Select for special reg data
    data_sel(16 downto 0) <= fw_status        & 
                             menterp_left     &
                             menterp_right    &
                             trap0_left       &
                             trap0_right      &
                             trap1_left       &
                             trap1_right      &
                             trap2_left       &
                             trap2_right      &
                             trap3_left       &
                             trap3_right      &
                             trap4_left       &
                             trap4_right      &
                             lem0_left        &
                             lem0_right       &
                             ecid_left        &
                             ecid_right;
    

    --Special register data mux
    with data_sel(16 downto 0)  select data_to_i2c <= 
    fw_status_data(31 downto 0) when "10000000000000000", --FW_STATUS
    X"00000000"                 when "01000000000000000", --MENTERP REG Left
    X"00000000"                 when "00100000000000000", --MENTERP Reg Right
    trap0(63 downto 32)         when "00010000000000000", --Trap0_l
    trap0(31 downto 0)          when "00001000000000000", --Trap0_r
    trap1(63 downto 32)         when "00000100000000000", --Trap1_l
    trap1(31 downto 0)          when "00000010000000000", --Trap1_r
    trap2(63 downto 32)         when "00000001000000000", --Trap2_l
    trap2(31 downto 0)          when "00000000100000000", --Trap2_r
    trap3(63 downto 32)         when "00000000010000000", --Trap3_l
    trap3(31 downto 0)          when "00000000001000000", --Trap3_r
    trap4(63 downto 32)         when "00000000000100000", --Trap4_l
    trap4(31 downto 0)          when "00000000000010000", --Trap4_r
    lem0(63 downto 32)          when "00000000000001000", --lem0_l
    lem0(31 downto 0)           when "00000000000000100", --lem0_r
    ecid(63 downto 32)          when "00000000000000010", --ecid_l Should be all 0s
    ecid(31 downto 0)           when "00000000000000001", --ecid_r
    fake_reg(31 downto 0)       when others;

    --Pulse Signal mmio if error reg controls written
    pulse_d         <= pulse_left when i2c_write_state = ST_I2C_WRITE_SET_AXI_REG else '0';
    perv_mmio_pulse <= pulse_q;
  --Process block for all state machine and latching (not all latches have _d,_q names). If they are assigned in this block, then they are latches 
  process (clock) is
  begin
    if rising_edge(clock) then
      if (resetn = '0') then
        control_state             <= ST_CONTROL_IDLE;
        i2c_read_state            <= ST_I2C_READ_IDLE;
        i2c_write_state           <= ST_I2C_WRITE_IDLE;
        axi_read_state            <= ST_AXI_READ_IDLE;
        axi_write_state           <= ST_AXI_WRITE_IDLE;
        axi_read_data             <= (others => '0');
        m0_axi_araddr             <= (others => '0');
        m0_axi_awaddr             <= (others => '0');
        m0_axi_wdata              <= (others => '0');
        m0_axi_wstrb              <= (others => '0');
        m0_axi_arvalid            <= '0';
        m0_axi_awvalid            <= '0';
        m0_axi_wvalid             <= '0';
        m0_axi_rready             <= '0';
        m0_axi_bready             <= '0';
        address_from_i2c          <= (others => '0');
        address_from_i2c_comp     <= (others => '0');
        data_from_i2c             <= (others => '0');
        cmd(7 downto 0)           <= (others => '0');
        fw_status                 <= '0';
        boot_config               <= '0';
        cmd_is_rd                 <= '0';
        cmd_is_rd_lt              <= '0';
        cmd_is_wr                 <= '0';
        lt_rd_combo               <= '0';
        lt_rd_address_mismatch    <= '0';
        pulse_q                   <= '0';
        fake_reg                  <= X"dec0de0b"; ---(others => '0');
        boot_config_data          <= (others => '0');
--        trap0_q                   <= (others => '0');
--        trap1_q                   <= (others => '0');
--        trap2_q                   <= (others => '0');
--        trap3_q                   <= (others => '0');
--        trap4_q                   <= (others => '0');
--        lem0_q                    <= (others => '0');
--        ecid_q                    <= (others => '0');
      else
          pulse_q                    <= pulse_d;
          axi_read_data(31 downto 8) <= (others => '0');
        --error latches
--        trap0_q    <= trap0_d;
--        trap1_q    <= trap1_d;
--        trap2_q    <= trap2_d;
--        trap3_q    <= trap3_d;
--        trap4_q    <= trap4_d;
--        lem0_q     <= lem0_d;
--        ecid_q     <= ecid_d;
        -- CONTROL STATE MACHINE
        case control_state is
          when ST_CONTROL_IDLE =>
              control_state <= ST_CONTROL_SET_SOFTR;
          when ST_CONTROL_SET_SOFTR =>
            if (axi_write_state_is_done = '1') then
              control_state <= ST_CONTROL_SET_CR_0;
            end if;
          when ST_CONTROL_SET_CR_0 =>
            if (axi_write_state_is_done = '1') then
              control_state <= ST_CONTROL_SET_CR_1;
            end if;
          when ST_CONTROL_SET_CR_1 =>
            if (axi_write_state_is_done = '1') then
              control_state <= ST_CONTROL_SET_ADR;
            end if;
          when ST_CONTROL_SET_ADR =>
            if (axi_write_state_is_done = '1') then
              control_state <= ST_CONTROL_SET_RX_FIFO_PIRQ;
            end if;
          when ST_CONTROL_SET_RX_FIFO_PIRQ =>
            if (axi_write_state_is_done = '1') then
              control_state <= ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR;
            end if;
          when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR =>
            if (axi_read_state_is_done = '1' and axi_read_data(1) = '1' and axi_read_data(6) = '0') then
              control_state <= ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_CLEAR;
            end if;
          when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_CLEAR =>
            -- This used to only check bit 1, but because the RX_FIFO
            -- is 16 entries, it would fill up when using 8 byte
            -- addresses and 8 byte data. Because we send 16 bytes max
            -- total, add an additional check for the fifo being full,
            -- otherwise we'll get stuck here because the AXI IIC
            -- won't ACK the last byte and we know everything is
            -- here. If we ever send more than 16 bytes, we would need
            -- a check at some later point to wait for the next bytes
            -- to arrive.
            if (axi_read_state_is_done = '1' and (axi_read_data(1) = '0' or axi_read_data(5) = '1')) then
              control_state <= ST_CONTROL_GET_CHECK_CMD;
            end if;
          when ST_CONTROL_GET_CHECK_CMD => --Read FIFO0 to determine cmd type 
               --Everything but fw_status has a length that comes down
            if (axi_read_state_is_done = '1') then
               if(axi_read_data(7 downto 0) = x"01") then --Boot Config
                  boot_config   <= '1';
                  cmd(7 downto 0) <= axi_read_data(7 downto 0);
                  control_state <= ST_CONTROL_GET_LENGTH; 
               end if;
               if(axi_read_data(7 downto 0) = x"02") then --FW_STATUS
                  control_state <= ST_CONTROL_I2C_READ;
                  fw_status     <= '1';
               end if;
               if(axi_read_data(7 downto 0) = x"03") then --Read Latch
                  control_state <= ST_CONTROL_GET_LENGTH;
                  cmd(7 downto 0) <= axi_read_data(7 downto 0);
                  cmd_is_rd_lt  <= '1';
               end if;
               if(axi_read_data(7 downto 0) = x"04") then --READ
                  cmd_is_rd     <= '1';
                  cmd(7 downto 0) <= axi_read_data(7 downto 0);
                  control_state <= ST_CONTROL_GET_LENGTH;
               end if;
               if(axi_read_data(7 downto 0) = x"05") then --WRITE 
                  cmd_is_wr     <= '1';
                  cmd(7 downto 0) <= axi_read_data(7 downto 0);
                  control_state <= ST_CONTROL_GET_LENGTH;
               end if;
            end if;
          when ST_CONTROL_GET_LENGTH =>  --Rds/Wrs have a length associated with them, don't need to do anything with it as we only do 32b addr/data
            if(axi_read_state_is_done = '1') then
               if(cmd_is_rd = '1') then
                  control_state      <= ST_CONTROL_I2C_READ ;
               end if;
               if(cmd_is_wr = '1' or cmd_is_rd_lt = '1' or boot_config = '1') then
                  control_state      <= ST_CONTROL_I2C_WRITE;
               end if;
            end if;
          when ST_CONTROL_I2C_READ =>
            if(i2c_read_state_is_done = '1') then
               control_state <= ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET;
            end if;
          when ST_CONTROL_I2C_WRITE =>
            if(i2c_write_state_is_done = '1') then
               control_state <= ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET;
            end if;
          when ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET =>
            if (axi_read_state_is_done = '1' and axi_read_data(7) = '1') then
              control_state   <= ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR;
              lt_rd_combo     <= cmd_is_rd_lt and not (lt_rd_combo and cmd_is_rd);
              cmd_is_rd       <= '0';
              cmd_is_wr       <= '0';
              cmd_is_rd_lt    <= '0';
              boot_config     <= '0';
              fw_status       <= '0';
            end if;
          when others =>
            control_state <= ST_CONTROL_ERROR;
        end case;

        -- I2C READ STATE MACHINE
  
        --Address_from_i2c vs address_from_i2c_comp is for the read and rd latch command. I check to see if the two addresses match
        case i2c_read_state is
          when ST_I2C_READ_IDLE =>
            if (control_state = ST_CONTROL_I2C_READ and fw_status = '0') then
              i2c_read_state <= ST_I2C_READ_GET_ADDR0;
            end if;
            if (control_state = ST_CONTROL_I2C_READ and fw_status = '1') then --FW status is an i2c read, but we don't get an address so we can skip to the data return
              i2c_read_state <= ST_I2C_READ_GET_AXI_REG;
            end if; 
          when ST_I2C_READ_GET_ADDR0 =>
            if (axi_read_state_is_done = '1') then 
             if(lt_rd_combo = '0') then 
               address_from_i2c(31 downto 24) <= axi_read_data(7 downto 0);
             else 
               address_from_i2c_comp(31 downto 24) <= axi_read_data(7 downto 0);
             end if;
               i2c_read_state <= ST_I2C_READ_GET_ADDR1;
            end if;
          when ST_I2C_READ_GET_ADDR1 =>
            if (axi_read_state_is_done = '1') then 
             if(lt_rd_combo = '0') then 
               address_from_i2c(23 downto 16) <= axi_read_data(7 downto 0);
             else 
               address_from_i2c_comp(23 downto 16) <= axi_read_data(7 downto 0);
             end if;
               i2c_read_state <= ST_I2C_READ_GET_ADDR2;
            end if;
          when ST_I2C_READ_GET_ADDR2 =>
            if (axi_read_state_is_done = '1') then 
             if(lt_rd_combo = '0') then 
               address_from_i2c(15 downto 8) <= axi_read_data(7 downto 0);
             else 
               address_from_i2c_comp(15 downto 8) <= axi_read_data(7 downto 0);
             end if;
               i2c_read_state <= ST_I2C_READ_GET_ADDR3;
            end if;
          when ST_I2C_READ_GET_ADDR3 =>
            if (axi_read_state_is_done = '1') then 
             if(lt_rd_combo = '0') then 
               address_from_i2c(7 downto 0) <= axi_read_data(7 downto 0);
             else 
               address_from_i2c_comp(7 downto 0) <= axi_read_data(7 downto 0);
             end if;
               i2c_read_state <= ST_I2C_READ_GET_AXI_REG;
            end if;
          when ST_I2C_READ_GET_AXI_REG =>
             if(lt_rd_combo = '1' and (address_from_i2c /= address_from_i2c_comp)) then 
               lt_rd_address_mismatch <= '1';
             end if;
               i2c_read_state <= ST_I2C_READ_SET_TX_FIFO0;
                
          when ST_I2C_READ_SET_TX_FIFO0 =>      --Write Length here 
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO1;
            end if;
          when ST_I2C_READ_SET_TX_FIFO1 =>     --D0
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO2;
            end if;
          when ST_I2C_READ_SET_TX_FIFO2 =>     --D1
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO3;
            end if;
          when ST_I2C_READ_SET_TX_FIFO3 =>     --D2
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO4;
            end if;
          when ST_I2C_READ_SET_TX_FIFO4 =>     --D3
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_DONE;
            end if;
          when ST_I2C_READ_DONE =>
            i2c_read_state <= ST_I2C_READ_IDLE;
          when others =>
            i2c_read_state <= ST_I2C_READ_ERROR;
        end case;

        -- I2C WRITE STATE MACHINE
        case i2c_write_state is
          when ST_I2C_WRITE_IDLE =>
            if (control_state = ST_CONTROL_I2C_WRITE and boot_config = '0') then
              i2c_write_state <= ST_I2C_WRITE_GET_ADDR0;
            end if;
            if (control_state = ST_CONTROL_I2C_WRITE and boot_config = '1') then --Boot config is a write, but we don't get an address so we can skip to accepting data
              i2c_write_state <= ST_I2C_WRITE_GET_DATA0;
            end if;
          when ST_I2C_WRITE_GET_ADDR0 => --Addr0
            if (axi_read_state_is_done = '1') then
               address_from_i2c(31 downto 24) <= axi_read_data(7 downto 0);
               i2c_write_state <= ST_I2C_WRITE_GET_ADDR1;
            end if;
          when ST_I2C_WRITE_GET_ADDR1 => --Addr1
            if (axi_read_state_is_done = '1') then
               address_from_i2c(23 downto 16) <= axi_read_data(7 downto 0);
               i2c_write_state <= ST_I2C_WRITE_GET_ADDR2;
            end if;
          when ST_I2C_WRITE_GET_ADDR2 => --Addr2
            if (axi_read_state_is_done = '1') then
               address_from_i2c(15 downto 8) <= axi_read_data(7 downto 0);
               i2c_write_state <= ST_I2C_WRITE_GET_ADDR3;
            end if;
          when ST_I2C_WRITE_GET_ADDR3 => --Addr3
            if (axi_read_state_is_done = '1') then
                address_from_i2c(7 downto 0) <= axi_read_data(7 downto 0);
              if(cmd_is_rd_lt = '1') then 
               i2c_write_state <= ST_I2C_WRITE_DONE;
              else
               i2c_write_state <= ST_I2C_WRITE_GET_DATA0;
              end if;
            end if;
          when ST_I2C_WRITE_GET_DATA0 => --D0
            if (axi_read_state_is_done = '1') then
              data_from_i2c(31 downto 24) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_GET_DATA1;
            end if;
          when ST_I2C_WRITE_GET_DATA1 => --D1
            if (axi_read_state_is_done = '1') then
              data_from_i2c(23 downto 16) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_GET_DATA2;
            end if;
          when ST_I2C_WRITE_GET_DATA2 => --D2
            if (axi_read_state_is_done = '1') then
              data_from_i2c(15 downto 8) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_GET_DATA3;
            end if;
          when ST_I2C_WRITE_GET_DATA3 => --D3
            if (axi_read_state_is_done = '1') then
              data_from_i2c(7 downto 0) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_SET_AXI_REG;
            end if;
          when ST_I2C_WRITE_SET_AXI_REG =>
              if(boot_config = '1') then
                 boot_config_data     <= data_from_i2c;
              end if;
              fake_reg(31 downto 0) <= data_from_i2c; --Write a fake reg. If no address matches on read, I send this data back
              i2c_write_state       <= ST_I2C_WRITE_DONE;
          when ST_I2C_WRITE_DONE =>
            i2c_write_state <= ST_I2C_WRITE_IDLE;
          when others =>
            i2c_write_state <= ST_I2C_WRITE_ERROR;
        end case;

        -- AXI READ STATE MACHINE
        case axi_read_state is
          when ST_AXI_READ_IDLE =>
            m0_axi_arvalid <= '0';
            m0_axi_araddr <= (others => '0');
            m0_axi_rready <= '0';
            if (axi_read_valid = '1') then
              axi_read_state <= ST_AXI_READ_CMD;
            end if;
          when ST_AXI_READ_CMD =>
            m0_axi_arvalid <= '1';
            m0_axi_araddr <= axi_read_address;
            m0_axi_rready <= '0';
            if (m0_axi_arready = '1') then
              m0_axi_arvalid <= '0';
              m0_axi_araddr <= (others => '0');
              m0_axi_rready <= '1';
              axi_read_state <= ST_AXI_READ_WAIT;
            end if;
          when ST_AXI_READ_WAIT =>
            if (m0_axi_rvalid = '1') then
              axi_read_data <= m0_axi_rdata;
              m0_axi_rready <= '0';
              axi_read_state <= ST_AXI_READ_DONE;
            end if;
          when ST_AXI_READ_DONE =>
            m0_axi_arvalid <= '0';
            m0_axi_araddr <= (others => '0');
            axi_read_state <= ST_AXI_READ_IDLE;
          when others =>
            m0_axi_arvalid <= '0';
            m0_axi_araddr <= (others => '0');
            m0_axi_rready <= '0';
            axi_read_state <= ST_AXI_READ_ERROR;
        end case;

        -- AXI WRITE STATE MACHINE
        case axi_write_state is
          when ST_AXI_WRITE_IDLE =>
            m0_axi_awvalid <= '0';
            m0_axi_awaddr <= (others => '0');
            m0_axi_wvalid <= '0';
            m0_axi_wdata <= (others => '0');
            m0_axi_wstrb <= (others => '0');
            m0_axi_bready <= '0';
            if (axi_write_valid = '1') then
              axi_write_state <= ST_AXI_WRITE_CMD;
            end if;
          when ST_AXI_WRITE_CMD =>
            m0_axi_awvalid <= '1';
            m0_axi_awaddr <= axi_write_address;
            m0_axi_wvalid <= '1';
            m0_axi_wdata <= axi_write_data;
            m0_axi_wstrb <= (others => '1');
            m0_axi_bready <= '0';
            if (m0_axi_awready = '1' and m0_axi_wready = '1') then
              axi_write_state <= ST_AXI_WRITE_WAIT;
              m0_axi_awvalid <= '0';
              m0_axi_awaddr <= (others => '0');
              m0_axi_wvalid <= '0';
              m0_axi_wdata <= (others => '0');
              m0_axi_wstrb <= (others => '0');
              m0_axi_bready <= '0';
            end if;
          when ST_AXI_WRITE_WAIT =>
            if (m0_axi_bvalid = '1') then
              m0_axi_bready <= '1';
              axi_write_state <= ST_AXI_WRITE_DONE;
            end if;
          when ST_AXI_WRITE_DONE =>
            m0_axi_awvalid <= '0';
            m0_axi_awaddr <= (others => '0');
            m0_axi_wvalid <= '0';
            m0_axi_wdata <= (others => '0');
            m0_axi_wstrb <= (others => '0');
            m0_axi_bready <= '0';
            axi_write_state <= ST_AXI_WRITE_IDLE;
          when others =>
            m0_axi_awvalid <= '0';
            m0_axi_awaddr <= (others => '0');
            m0_axi_wvalid <= '0';
            m0_axi_wdata <= (others => '0');
            m0_axi_wstrb <= (others => '0');
            m0_axi_bready <= '0';
            axi_write_state <= ST_AXI_WRITE_ERROR;
        end case;
      end if;
    end if;
  end process;


end ice_i2c_control_mac;
















