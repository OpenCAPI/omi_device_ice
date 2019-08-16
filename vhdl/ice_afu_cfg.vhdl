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
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ice_afu_cfg IS
  PORT
    (
   
      -- -----------------------------------
      -- TLX Parser to AFU Receive Interface
      -- -----------------------------------
      tlx_afu_ready                    : IN    STD_ULOGIC;
     
      cfg_tlx_initial_credit           : OUT   STD_ULOGIC_VECTOR(3 DOWNTO 0);
      cfg_tlx_credit_return            : OUT   STD_ULOGIC;
      tlx_cfg_valid                    : IN    STD_ULOGIC;
      tlx_cfg_opcode                   : IN    STD_ULOGIC_VECTOR(7 DOWNTO 0);
      tlx_cfg_pa                       : IN    STD_ULOGIC_VECTOR(63 DOWNTO 0);
      tlx_cfg_t                        : IN    STD_ULOGIC;
      tlx_cfg_pl                       : IN    STD_ULOGIC_VECTOR(2 DOWNTO 0);
      tlx_cfg_capptag                  : IN    STD_ULOGIC_VECTOR(15 DOWNTO 0);
      tlx_cfg_data_bus                 : IN    STD_ULOGIC_VECTOR(31 DOWNTO 0);
      tlx_cfg_data_bdi                 : IN    STD_ULOGIC;      
      -- --- Config Responses from AFU
      cfg_tlx_resp_valid               : OUT   STD_ULOGIC;
      cfg_tlx_resp_opcode              : OUT   STD_ULOGIC_VECTOR(7 DOWNTO 0);
      cfg_tlx_resp_capptag             : OUT   STD_ULOGIC_VECTOR(15 DOWNTO 0);
      cfg_tlx_resp_code                : OUT   STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_resp_ack                 : IN    STD_ULOGIC;
      -- --- Config Response data from AFU
      cfg_tlx_rdata_offset             : OUT   STD_ULOGIC_VECTOR(3 DOWNTO 0);
      cfg_tlx_rdata_bus                : OUT   STD_ULOGIC_VECTOR(31 DOWNTO 0);
      cfg_tlx_rdata_bdi                : OUT   STD_ULOGIC;

      -- -----------------------------------
      -- Configuration Ports
      -- -----------------------------------
      cfg_tlx_bus_num                  : OUT STD_ULOGIC_VECTOR(7 downto 0);
      cfg_tlx_xmit_tmpl_config_0       : OUT STD_ULOGIC;
      cfg_tlx_xmit_tmpl_config_1       : OUT STD_ULOGIC;
      cfg_tlx_xmit_tmpl_config_5       : OUT STD_ULOGIC;
      cfg_tlx_xmit_tmpl_config_9       : OUT STD_ULOGIC;
      cfg_tlx_xmit_tmpl_config_11      : OUT STD_ULOGIC;
      cfg_tlx_xmit_rate_config_0       : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0);
      cfg_tlx_xmit_rate_config_1       : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0);
      cfg_tlx_xmit_rate_config_5       : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0);
      cfg_tlx_xmit_rate_config_9       : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0);
      cfg_tlx_xmit_rate_config_11      : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0); 
      cfg_tlx_tl_minor_version         : OUT STD_ULOGIC;                      
      cfg_tlx_enable_afu               : OUT STD_ULOGIC;                      
      cfg_tlx_metadata_enabled         : OUT STD_ULOGIC;                      
      cfg_tlx_function_actag_base      : OUT STD_ULOGIC_VECTOR(11 downto 0);
      cfg_tlx_function_actag_len_enab  : OUT STD_ULOGIC_VECTOR(11 downto 0);
      cfg_tlx_afu_actag_base           : OUT STD_ULOGIC_VECTOR(11 downto 0);
      cfg_tlx_afu_actag_len_enab       : OUT STD_ULOGIC_VECTOR(11 downto 0);
      cfg_tlx_pasid_length_enabled     : OUT STD_ULOGIC_VECTOR(4 downto 0);   
      cfg_tlx_pasid_base               : OUT STD_ULOGIC_VECTOR(19 downto 0);  
      cfg_tlx_mmio_bar0                : OUT STD_ULOGIC_VECTOR(63 downto 35); 
      cfg_tlx_memory_space             : OUT STD_ULOGIC;                      
      cfg_tlx_long_backoff_timer       : OUT STD_ULOGIC_VECTOR(3 downto 0);   
      tlx_cfg_in_rcv_tmpl_capability_0 : IN  STD_ULOGIC;
      tlx_cfg_in_rcv_tmpl_capability_1 : IN  STD_ULOGIC;
      tlx_cfg_in_rcv_tmpl_capability_4 : IN  STD_ULOGIC;
      tlx_cfg_in_rcv_tmpl_capability_7 : IN  STD_ULOGIC;
      tlx_cfg_in_rcv_tmpl_capability_10: IN  STD_ULOGIC;
      tlx_cfg_in_rcv_rate_capability_0 : IN  STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_in_rcv_rate_capability_1 : IN  STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_in_rcv_rate_capability_4 : IN  STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_in_rcv_rate_capability_7 : IN  STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_in_rcv_rate_capability_10: IN  STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_oc3_tlx_version          : IN  STD_ULOGIC_VECTOR(31 DOWNTO 0);
      tlx_cfg_oc3_dlx_version          : IN  STD_ULOGIC_VECTOR(31 DOWNTO 0);
      -- -----------------------------------
      -- Miscellaneous Ports
      -- -----------------------------------
      clock_400mhz                     : IN  STD_ULOGIC;
      reset_n                          : IN  STD_ULOGIC

      );

END ice_afu_cfg;

ARCHITECTURE ice_afu_cfg OF ice_afu_cfg IS


  component cfg_top 
  port (

    -- -----------------------------------
    -- Miscellaneous Ports
    -- -----------------------------------
    clock                             : in  std_ulogic;                             
    reset_n                           : in  std_ulogic;                      -- (active low) Hardware reset
    cfg0_tlx_bus_num                  : out std_ulogic_vector(7 downto 0);

    -- Hardcoded configuration inputs
    ro_device                         : in  std_ulogic_vector(4 downto 0);   -- Assigned to this Device instantiation at the next level
    ro_dlx0_version                   : in  std_ulogic_vector(31 downto 0);  -- Connect to DLX output at next level, or tie off to all 0s
    ro_tlx0_version                   : in  std_ulogic_vector(31 downto 0);  -- Connect to TLX output at next level, or tie off to all 0s

    -- -----------------------------------
    -- TLX0 Parser -> AFU Receive Interface
    -- -----------------------------------

    tlx_afu_ready                     : in  std_ulogic;                      -- When 1, TLX is ready to receive both commands and responses from the AFU


    -- Configuration Ports: Drive Configuration (determined by software)
    cfg0_tlx_xmit_tmpl_config_0       : out std_ulogic;                      -- When 1, TLX should support transmitting template 0
    cfg0_tlx_xmit_tmpl_config_1       : out std_ulogic;                      -- When 1, TLX should support transmitting template 1
    cfg0_tlx_xmit_tmpl_config_5       : out std_ulogic;                      -- When 1, TLX should support transmitting template 5
    cfg0_tlx_xmit_tmpl_config_9       : out std_ulogic;                      -- When 1, TLX should support transmitting template 9
    cfg0_tlx_xmit_tmpl_config_11      : out std_ulogic;                      -- When 1, TLX should support tran
    cfg0_tlx_xmit_rate_config_0       : out std_ulogic_vector(3 downto 0);   -- Value corresponds to the rate TLX can transmit template 0
    cfg0_tlx_xmit_rate_config_1       : out std_ulogic_vector(3 downto 0);   -- Value corresponds to the rate TLX can transmit template 1
    cfg0_tlx_xmit_rate_config_5       : out std_ulogic_vector(3 downto 0);   -- Value corresponds to the rate TLX can transmit template 5
    cfg0_tlx_xmit_rate_config_9       : out std_ulogic_vector(3 downto 0);   -- Value corresponds to the rate TLX can transmit template 9
    cfg0_tlx_xmit_rate_config_11      : out std_ulogic_vector(3 downto 0);   -- Value corresponds to the rate TLX can transmit template 11
    cfg0_tlx_tl_minor_version         : out std_ulogic;                      -- When 1, indicates OpenCAPI v3.1 support, v3.0 otherwise
    cfg0_tlx_enable_afu               : out std_ulogic;                      -- When 1, indicates AFU function is enabled
    cfg0_tlx_metadata_enabled         : out std_ulogic;                      -- When 1, indicates metadata enabled
    cfg0_tlx_function_actag_base      : out std_ulogic_vector(11 downto 0);  -- actag base for function (Should be equal  to cfg0_tlx_afu_actag_base)
    cfg0_tlx_function_actag_len_enab  : out std_ulogic_vector(11 downto 0);  -- actag length for function (Should be equal to cfg0_tlx_afu_actag_len_enab)
    cfg0_tlx_afu_actag_base           : out std_ulogic_vector(11 downto 0);  -- actag base for afu (Should be equal  to cfg0_tlx_function_actag_base)
    cfg0_tlx_afu_actag_len_enab       : out std_ulogic_vector(11 downto 0);  -- actag length for afu (Should be equal to cfg0_tlx_function_actag_len_enab)
    cfg0_tlx_pasid_length_enabled     : out std_ulogic_vector(4 downto 0);   -- 2 to the power of this number indicates number of PASIDs assigned to afu
    cfg0_tlx_pasid_base               : out std_ulogic_vector(19 downto 0);  -- Starting PASID assigned to this AFU
    cfg0_tlx_mmio_bar0                : out std_ulogic_vector(63 downto 35); -- Upper 29 bits of BAR0 Function 1
    cfg0_tlx_memory_space             : out std_ulogic;                      -- When 1, MMIO space is activated
    cfg0_tlx_long_backoff_timer       : out std_ulogic_vector(3 downto 0);   -- Long backoff timer for rtry
    
    -- Configuration Ports: Receive Capabilities (determined by TLX design)
    tlx_cfg0_in_rcv_tmpl_capability_0 : in  std_ulogic;                      -- When 1, TLX should support receiving template 0
    tlx_cfg0_in_rcv_tmpl_capability_1 : in  std_ulogic;                      -- When 1, TLX should support receiving template 1
    tlx_cfg0_in_rcv_tmpl_capability_4 : in  std_ulogic;                      -- When 1, TLX should support receiving template 4
    tlx_cfg0_in_rcv_tmpl_capability_7 : in  std_ulogic;                      -- When 1, TLX should support receiving template 7
    tlx_cfg0_in_rcv_tmpl_capability_10: in  std_ulogic;                      -- When 1, TLX should support receiving template 10
    tlx_cfg0_in_rcv_rate_capability_0 : in  std_ulogic_vector(3 DOWNTO 0);   -- Value corresponds to the rate TLX can receive template 0
    tlx_cfg0_in_rcv_rate_capability_1 : in  std_ulogic_vector(3 DOWNTO 0);   -- Value corresponds to the rate TLX can receive template 1
    tlx_cfg0_in_rcv_rate_capability_4 : in  std_ulogic_vector(3 DOWNTO 0);   -- Value corresponds to the rate TLX can receive template 4
    tlx_cfg0_in_rcv_rate_capability_7 : in  std_ulogic_vector(3 DOWNTO 0);   -- Value corresponds to the rate TLX can receive template 7
    tlx_cfg0_in_rcv_rate_capability_10: in  std_ulogic_vector(3 DOWNTO 0);   -- Value corresponds to the rate TLX can receive template 10
 
    -- ---------------------------
    -- Config_* command interfaces
    -- ---------------------------

    -- Port 0: config_write/read commands from host    
    tlx_cfg0_valid                    : in  std_ulogic;
    tlx_cfg0_opcode                   : in  std_ulogic_vector(7 downto 0);
    tlx_cfg0_pa                       : in  std_ulogic_vector(63 downto 0);
    tlx_cfg0_t                        : in  std_ulogic;
    tlx_cfg0_pl                       : in  std_ulogic_vector(2 downto 0);
    tlx_cfg0_capptag                  : in  std_ulogic_vector(15 downto 0);
    tlx_cfg0_data_bus                 : in  std_ulogic_vector(31 downto 0);
    tlx_cfg0_data_bdi                 : in  std_ulogic;
    cfg0_tlx_initial_credit           : out std_ulogic_vector(3 downto 0);
    cfg0_tlx_credit_return            : out std_ulogic;

    -- Port 0: config_* responses back to host
    cfg0_tlx_resp_valid               : out std_ulogic;
    cfg0_tlx_resp_opcode              : out std_ulogic_vector(7 downto 0);
    cfg0_tlx_resp_capptag             : out std_ulogic_vector(15 downto 0);
    cfg0_tlx_resp_code                : out std_ulogic_vector(3 downto 0);
    cfg0_tlx_rdata_offset             : out std_ulogic_vector(3 downto 0);
    cfg0_tlx_rdata_bus                : out std_ulogic_vector(31 downto 0);
    cfg0_tlx_rdata_bdi                : out std_ulogic;
    tlx_cfg0_resp_ack                 : in  std_ulogic


  ) ;
  end component cfg_top;

 
BEGIN

  --## figtree_source ice_afu_cfg.fig

  CFG : cfg_top
  port map(
    -- -----------------------------------
    -- Miscellaneous Ports
    -- -----------------------------------
    clock                              => CLOCK_400MHZ,                             
    reset_n                            => RESET_N,
    cfg0_tlx_bus_num                   => CFG_TLX_BUS_NUM,
    ro_device                          => "00000", -- Only one device
    ro_dlx0_version                    => TLX_CFG_OC3_DLX_VERSION,
    ro_tlx0_version                    => TLX_CFG_OC3_TLX_VERSION,

    -- -----------------------------------
    -- TLX0 Parser -> AFU Receive Interface
    -- -----------------------------------

    tlx_afu_ready                      => TLX_AFU_READY,


    -- Configuration Ports: Drive Configuration (determined by software)
    cfg0_tlx_xmit_tmpl_config_0        => CFG_TLX_XMIT_TMPL_CONFIG_0,  
    cfg0_tlx_xmit_tmpl_config_1        => CFG_TLX_XMIT_TMPL_CONFIG_1,
    cfg0_tlx_xmit_tmpl_config_5        => CFG_TLX_XMIT_TMPL_CONFIG_5, 
    cfg0_tlx_xmit_tmpl_config_9        => CFG_TLX_XMIT_TMPL_CONFIG_9,
    cfg0_tlx_xmit_tmpl_config_11       => CFG_TLX_XMIT_TMPL_CONFIG_11,
    cfg0_tlx_xmit_rate_config_0        => CFG_TLX_XMIT_RATE_CONFIG_0,
    cfg0_tlx_xmit_rate_config_1        => CFG_TLX_XMIT_RATE_CONFIG_1,
    cfg0_tlx_xmit_rate_config_5        => CFG_TLX_XMIT_RATE_CONFIG_5,
    cfg0_tlx_xmit_rate_config_9        => CFG_TLX_XMIT_RATE_CONFIG_9, 
    cfg0_tlx_xmit_rate_config_11       => CFG_TLX_XMIT_RATE_CONFIG_11,
    cfg0_tlx_tl_minor_version          => CFG_TLX_TL_MINOR_VERSION,
    cfg0_tlx_enable_afu                => CFG_TLX_ENABLE_AFU,
    cfg0_tlx_metadata_enabled          => CFG_TLX_METADATA_ENABLED,
    cfg0_tlx_function_actag_base       => CFG_TLX_FUNCTION_ACTAG_BASE,
    cfg0_tlx_function_actag_len_enab   => CFG_TLX_FUNCTION_ACTAG_LEN_ENAB,
    cfg0_tlx_afu_actag_base            => CFG_TLX_AFU_ACTAG_BASE,   
    cfg0_tlx_afu_actag_len_enab        => CFG_TLX_AFU_ACTAG_LEN_ENAB,
    cfg0_tlx_pasid_length_enabled      => CFG_TLX_PASID_LENGTH_ENABLED,   
    cfg0_tlx_pasid_base                => CFG_TLX_PASID_BASE,
    cfg0_tlx_mmio_bar0                 => CFG_TLX_MMIO_BAR0,
    cfg0_tlx_memory_space              => CFG_TLX_MEMORY_SPACE, 
    cfg0_tlx_long_backoff_timer        => CFG_TLX_LONG_BACKOFF_TIMER,    
 
    -- Configuration Ports: Receive Capabilities (determined by TLX design)
    tlx_cfg0_in_rcv_tmpl_capability_0  => TLX_CFG_IN_RCV_TMPL_CAPABILITY_0,
    tlx_cfg0_in_rcv_tmpl_capability_1  => TLX_CFG_IN_RCV_TMPL_CAPABILITY_1,
    tlx_cfg0_in_rcv_tmpl_capability_4  => TLX_CFG_IN_RCV_TMPL_CAPABILITY_4,
    tlx_cfg0_in_rcv_tmpl_capability_7  => TLX_CFG_IN_RCV_TMPL_CAPABILITY_7,
    tlx_cfg0_in_rcv_tmpl_capability_10 => TLX_CFG_IN_RCV_TMPL_CAPABILITY_10,
    tlx_cfg0_in_rcv_rate_capability_0  => TLX_CFG_IN_RCV_RATE_CAPABILITY_0,
    tlx_cfg0_in_rcv_rate_capability_1  => TLX_CFG_IN_RCV_RATE_CAPABILITY_1,
    tlx_cfg0_in_rcv_rate_capability_4  => TLX_CFG_IN_RCV_RATE_CAPABILITY_4,
    tlx_cfg0_in_rcv_rate_capability_7  => TLX_CFG_IN_RCV_RATE_CAPABILITY_7,
    tlx_cfg0_in_rcv_rate_capability_10 => TLX_CFG_IN_RCV_RATE_CAPABILITY_10,
    
    -- ---------------------------
    -- Config_* command interfaces
    -- ---------------------------

    -- Port 0: config_write/read commands from host    
    tlx_cfg0_valid                     => TLX_CFG_VALID,
    tlx_cfg0_opcode                    => TLX_CFG_OPCODE,
    tlx_cfg0_pa                        => TLX_CFG_PA,
    tlx_cfg0_t                         => TLX_CFG_T,
    tlx_cfg0_pl                        => TLX_CFG_PL,
    tlx_cfg0_capptag                   => TLX_CFG_CAPPTAG,
    tlx_cfg0_data_bus                  => TLX_CFG_DATA_BUS,
    tlx_cfg0_data_bdi                  => TLX_CFG_DATA_BDI,
    cfg0_tlx_initial_credit            => CFG_TLX_INITIAL_CREDIT,
    cfg0_tlx_credit_return             => CFG_TLX_CREDIT_RETURN,

    -- Port 0: config_* responses back to host
    cfg0_tlx_resp_valid                => CFG_TLX_RESP_VALID,
    cfg0_tlx_resp_opcode               => CFG_TLX_RESP_OPCODE,
    cfg0_tlx_resp_capptag              => CFG_TLX_RESP_CAPPTAG,
    cfg0_tlx_resp_code                 => CFG_TLX_RESP_CODE,
    cfg0_tlx_rdata_offset              => CFG_TLX_RDATA_OFFSET,
    cfg0_tlx_rdata_bus                 => CFG_TLX_RDATA_BUS,
    cfg0_tlx_rdata_bdi                 => CFG_TLX_RDATA_BDI,
    tlx_cfg0_resp_ack                  => TLX_CFG_RESP_ACK

  );

END ice_afu_cfg;
