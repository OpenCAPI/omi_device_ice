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
use work.gemini_tlx_pkg.all;

entity ice_tlx_top is            -- replaces ocx_tlx_top in ice_core
    PORT (
      -- -----------------------------------
      -- TLX Parser to AFU Receive Interface
      -- -----------------------------------
      tlx_afu_ready                     : OUT   STD_ULOGIC;
      -- Command interface to AFU
      afu_tlx_cmd_initial_credit        : IN    STD_ULOGIC_VECTOR(6 DOWNTO 0);
      afu_tlx_cmd_credit                : IN    STD_ULOGIC;
      tlx_afu_cmd_valid                 : OUT   STD_ULOGIC;
      tlx_afu_cmd_opcode                : OUT   STD_ULOGIC_VECTOR(7 DOWNTO 0);
      tlx_afu_cmd_dl                    : OUT   STD_ULOGIC_VECTOR(1 DOWNTO 0);
      tlx_afu_cmd_pa                    : OUT   STD_ULOGIC_VECTOR(63 DOWNTO 0);
      tlx_afu_cmd_capptag               : OUT   STD_ULOGIC_VECTOR(15 DOWNTO 0);
      tlx_afu_cmd_pl                    : OUT   STD_ULOGIC_VECTOR(2 DOWNTO 0);
      tlx_afu_cmd_flag                  : OUT   STD_ULOGIC_VECTOR(3 DOWNTO 0);
      -- Config Command interfave ce to AFU
      cfg_tlx_initial_credit            : IN    STD_ULOGIC_VECTOR(3 DOWNTO 0);
      cfg_tlx_credit_return             : IN    STD_ULOGIC;
      tlx_cfg_valid                     : OUT   STD_ULOGIC;
      tlx_cfg_opcode                    : OUT   STD_ULOGIC_VECTOR(7 DOWNTO 0);
      tlx_cfg_pa                        : OUT   STD_ULOGIC_VECTOR(63 DOWNTO 0);
      tlx_cfg_t                         : OUT   STD_ULOGIC;
      tlx_cfg_pl                        : OUT   STD_ULOGIC_VECTOR(2 DOWNTO 0);
      tlx_cfg_capptag                   : OUT   STD_ULOGIC_VECTOR(15 DOWNTO 0);
      tlx_cfg_data_bus                  : OUT   STD_ULOGIC_VECTOR(31 DOWNTO 0);
      tlx_cfg_data_bdi                  : OUT   STD_ULOGIC;
      -- Response interface to AFU
      afu_tlx_resp_initial_credit       : IN    STD_ULOGIC_VECTOR(6 DOWNTO 0);
      afu_tlx_resp_credit               : IN    STD_ULOGIC;
      tlx_afu_resp_valid                : OUT   STD_ULOGIC;
      tlx_afu_resp_opcode               : OUT   STD_ULOGIC_VECTOR(7 DOWNTO 0);
      tlx_afu_resp_afutag               : OUT   STD_ULOGIC_VECTOR(15 DOWNTO 0);
      -- Command data interface to AFU
      afu_tlx_cmd_rd_req                : IN    STD_ULOGIC;
      afu_tlx_cmd_rd_cnt                : IN    STD_ULOGIC_VECTOR(2 DOWNTO 0);
      tlx_afu_cmd_data_valid            : OUT   STD_ULOGIC;
      tlx_afu_cmd_data_bus              : OUT   STD_ULOGIC_VECTOR(517 DOWNTO 0);
      -- -----------------------------------
      -- AFU to TLX Framer Transmit Interface
      -- -----------------------------------
      -- --- Commands from AFU
      tlx_afu_cmd_initial_credit        : OUT   STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_afu_cmd_credit                : OUT   STD_ULOGIC;
      afu_tlx_cmd_valid                 : IN    STD_ULOGIC;
      afu_tlx_cmd_opcode                : IN    STD_ULOGIC_VECTOR(7 DOWNTO 0);
      afu_tlx_cmd_actag                 : IN    STD_ULOGIC_VECTOR(11 DOWNTO 0);
      afu_tlx_cmd_stream_id             : IN    STD_ULOGIC_VECTOR(3 DOWNTO 0);
      afu_tlx_cmd_ea_or_obj             : IN    STD_ULOGIC_VECTOR(63 DOWNTO 0);
      afu_tlx_cmd_afutag                : IN    STD_ULOGIC_VECTOR(15 DOWNTO 0);
      afu_tlx_cmd_flag                  : IN    STD_ULOGIC_VECTOR(3 DOWNTO 0);
      afu_tlx_cmd_bdf                   : IN    STD_ULOGIC_VECTOR(15 DOWNTO 0);
      afu_tlx_cmd_pasid                 : IN    STD_ULOGIC_VECTOR(19 DOWNTO 0);
      -- --- Command data from AFU
      tlx_afu_cmd_data_initial_credit   : OUT   STD_ULOGIC_VECTOR(5 DOWNTO 0);
      tlx_afu_cmd_data_credit           : OUT   STD_ULOGIC;
      -- --- Responses from AFU
      tlx_afu_resp_initial_credit       : OUT   STD_ULOGIC_VECTOR(5 DOWNTO 0);
      tlx_afu_resp_credit               : OUT   STD_ULOGIC;
      afu_tlx_resp_valid                : IN    STD_ULOGIC;
      afu_tlx_resp_opcode               : IN    STD_ULOGIC_VECTOR(7 DOWNTO 0);
      afu_tlx_resp_dl                   : IN    STD_ULOGIC_VECTOR(1 DOWNTO 0);
      afu_tlx_resp_capptag              : IN    STD_ULOGIC_VECTOR(15 DOWNTO 0);
      afu_tlx_resp_dp                   : IN    STD_ULOGIC_VECTOR(1 DOWNTO 0);
      afu_tlx_resp_code                 : IN    STD_ULOGIC_VECTOR(3 DOWNTO 0);
      -- --- Response data from AFU
      tlx_afu_resp_data_initial_credit  : OUT   STD_ULOGIC_VECTOR(5 DOWNTO 0);
      tlx_afu_resp_data_credit          : OUT   STD_ULOGIC;
      afu_tlx_rdata_valid               : IN    STD_ULOGIC;
      afu_tlx_rdata_bus                 : IN    STD_ULOGIC_VECTOR(511 DOWNTO 0);
      afu_tlx_rdata_bdi                 : IN    STD_ULOGIC;
      afu_tlx_rdata_meta                : in    STD_ULOGIC_VECTOR(5 downto 0);
      -- --- Config Responses from AFU
      cfg_tlx_resp_valid                : IN    STD_ULOGIC;
      cfg_tlx_resp_opcode               : IN    STD_ULOGIC_VECTOR(7 DOWNTO 0);
      cfg_tlx_resp_capptag              : IN    STD_ULOGIC_VECTOR(15 DOWNTO 0);
      cfg_tlx_resp_code                 : IN    STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_resp_ack                  : OUT   STD_ULOGIC;
      -- --- Config Response data from AFU
      cfg_tlx_rdata_offset              : IN    STD_ULOGIC_VECTOR(3 DOWNTO 0);
      cfg_tlx_rdata_bus                 : IN    STD_ULOGIC_VECTOR(31 DOWNTO 0);
      cfg_tlx_rdata_bdi                 : IN    STD_ULOGIC;
      -- -----------------------------------
      -- DLX to TLX Parser Interface
      -- -----------------------------------
      dlx_tlx_flit_valid                : IN    STD_ULOGIC;
      dlx_tlx_flit                      : IN    STD_ULOGIC_VECTOR(511 DOWNTO 0);
      dlx_tlx_flit_crc_err              : IN    STD_ULOGIC;
      dlx_tlx_link_up                   : IN    STD_ULOGIC;
      -- -----------------------------------
      -- TLX Framer to DLX Interface
      -- -----------------------------------
      dlx_tlx_init_flit_depth           : IN    STD_ULOGIC_VECTOR(2 DOWNTO 0);
      dlx_tlx_flit_credit               : IN    STD_ULOGIC;
      tlx_dlx_flit_valid                : OUT   STD_ULOGIC;
      tlx_dlx_flit                      : OUT   STD_ULOGIC_VECTOR(511 DOWNTO 0);
      tlx_dlx_debug_encode              : OUT   STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_dlx_debug_info                : OUT   STD_ULOGIC_VECTOR(31 DOWNTO 0);
      dlx_tlx_dlx_config_info           : IN    STD_ULOGIC_VECTOR(31 DOWNTO 0);
      -- -----------------------------------
      -- Configuration Ports
      -- -----------------------------------
      cfg_tlx_xmit_tmpl_config_0        : IN    STD_ULOGIC;
      cfg_tlx_xmit_tmpl_config_1        : IN    STD_ULOGIC;
      cfg_tlx_xmit_tmpl_config_5        : IN    STD_ULOGIC;
      cfg_tlx_xmit_rate_config_0        : IN    STD_ULOGIC_VECTOR(3 DOWNTO 0);
      cfg_tlx_xmit_rate_config_1        : IN    STD_ULOGIC_VECTOR(3 DOWNTO 0);
      cfg_tlx_xmit_rate_config_5        : IN    STD_ULOGIC_VECTOR(3 DOWNTO 0);
      cfg_tlx_metadata_enabled          : IN    STD_ULOGIC;
      tlx_cfg_in_rcv_tmpl_capability_0  : OUT   STD_ULOGIC;
      tlx_cfg_in_rcv_tmpl_capability_1  : OUT   STD_ULOGIC;
      tlx_cfg_in_rcv_tmpl_capability_4  : OUT   STD_ULOGIC;
      tlx_cfg_in_rcv_tmpl_capability_7  : OUT   STD_ULOGIC;
      tlx_cfg_in_rcv_tmpl_capability_10 : OUT   STD_ULOGIC;
      tlx_cfg_in_rcv_rate_capability_0  : OUT   STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_in_rcv_rate_capability_1  : OUT   STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_in_rcv_rate_capability_4  : OUT   STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_in_rcv_rate_capability_7  : OUT   STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_in_rcv_rate_capability_10 : OUT   STD_ULOGIC_VECTOR(3 DOWNTO 0);
      tlx_cfg_oc3_tlx_version           : OUT   STD_ULOGIC_VECTOR(31 DOWNTO 0);
      -- -----------------------------------
      -- Error and Debug to MMI0
      -- -----------------------------------
      tlx_mmio_rcv_errors               : OUT   STD_ULOGIC_VECTOR(31 DOWNTO 0);
      tlx_mmio_rcv_debug                : OUT   STD_ULOGIC_VECTOR(63 DOWNTO 0);
      tlx_mmio_xmt_err                  : out   STD_ULOGIC_VECTOR(15 downto 0);
      tlx_mmio_xmt_dbg                  : out STD_ULOGIC_VECTOR(63 downto 0);
      -- -----------------------------------
      -- Miscellaneous Ports
      -- -----------------------------------
      clock                            : IN    STD_ULOGIC;
      reset_n                          : IN    STD_ULOGIC);
  end ice_tlx_top;


 architecture ice_tlx_top of ice_tlx_top is
        -- -----------------------------------
        -- TLX Parser to TLX Framer Interface
        -- -----------------------------------
        signal    rcv_xmt_tl_credit_vc0_valid       :  std_ulogic;                         -- TL credit for VC0,  to send to TL
        signal    rcv_xmt_tl_credit_vc1_valid       :  std_ulogic;                         -- TL credit for VC1,  to send to TL
        signal    rcv_xmt_tl_credit_dcp0_valid      :  std_ulogic;                         -- TL credit for DCP0, to send to TL
        signal    rcv_xmt_tl_credit_dcp1_valid      :  std_ulogic;                         -- TL credit for DCP1, to send to TL
        signal    rcv_xmt_tl_crd_cfg_dcp1_valid     :  std_ulogic;                         -- TL credit for DCP1, to send to TL
                                                                                           --
        signal    rcv_xmt_tlx_credit_valid          :  std_ulogic;                         -- Indicates there are valid TLX credits to capture and use
        signal    rcv_xmt_tlx_credit_vc0            :  std_ulogic_vector(3 downto 0);     -- TLX credit for VC0,  to be used by TLX
        signal    rcv_xmt_tlx_credit_vc3            :  std_ulogic_vector(3 downto 0);     -- TLX credit for VC3,  to be used by TLX
        signal    rcv_xmt_tlx_credit_dcp0           :  std_ulogic_vector(5 downto 0);     -- TLX credit for DCP0, to be used by TLX
        signal    rcv_xmt_tlx_credit_dcp3           :  std_ulogic_vector(5 downto 0);     -- TLX credit for DCP3, to be used by TLX

        signal    rcv_xmt_debug_info                :  std_ulogic_vector(31 downto 0);
        signal    rcv_xmt_debug_fatal               :  std_ulogic;
        signal    rcv_xmt_debug_valid               :  std_ulogic;

        constant  OC3_TLX_VERSION                   : std_ulogic_vector(31 downto 0) := x"19012400";   -- Some clean up for tvc compile warnings.   No functional change.
        signal    afu_tlx_cmd_capptag               : std_ulogic_vector(15 downto 0);

  begin
       tlx_cfg_oc3_tlx_version  <=  OC3_TLX_VERSION ;

       afu_tlx_cmd_capptag      <= (others => '0');   
       rcv_xmt_debug_info       <= (others => '0');   
       rcv_xmt_debug_fatal      <= '0';              
       rcv_xmt_debug_valid      <= '0';             


icetlx_rcv: entity work.ice_tlx_rcv           -- tl_parser
  port map (
      dlx_tlx_link_up                   => dlx_tlx_link_up,
      dlx_tlx_flit_valid                => dlx_tlx_flit_valid,
      dlx_tlx_flit_crc_err              => dlx_tlx_flit_crc_err,
      dlx_tlx_flit                      => dlx_tlx_flit,

      -- -----------------------------------
      -- TLX Parser to AFU Receive Interface
      -- -----------------------------------
      tlx_afu_ready                     => tlx_afu_ready,                           -- tied to link_up at the moment
      -- Command interface to AFU
      afu_tlx_cmd_initial_credit        => afu_tlx_cmd_initial_credit,
      afu_tlx_cmd_credit                => afu_tlx_cmd_credit,
      tlx_afu_cmd_valid                 => tlx_afu_cmd_valid,
      tlx_afu_cmd_opcode                => tlx_afu_cmd_opcode,
      tlx_afu_cmd_dl                    => tlx_afu_cmd_dl,
      tlx_afu_cmd_pa                    => tlx_afu_cmd_pa,
      tlx_afu_cmd_capptag               => tlx_afu_cmd_capptag,
      tlx_afu_cmd_pl                    => tlx_afu_cmd_pl,
      tlx_afu_cmd_flag                  => tlx_afu_cmd_flag ,

      -- Config Command interface to AFU
      cfg_tlx_initial_credit            => cfg_tlx_initial_credit,
      cfg_tlx_credit_return             => cfg_tlx_credit_return,
      tlx_cfg_valid                     => tlx_cfg_valid,
      tlx_cfg_opcode                    => tlx_cfg_opcode,
      tlx_cfg_pa                        => tlx_cfg_pa,
      tlx_cfg_t                         => tlx_cfg_t,
      tlx_cfg_pl                        => tlx_cfg_pl,
      tlx_cfg_capptag                   => tlx_cfg_capptag,
      tlx_cfg_data_bus                  => tlx_cfg_data_bus,
      tlx_cfg_data_bdi                  => tlx_cfg_data_bdi,
      -- Response interface to AFU

      afu_tlx_resp_initial_credit       => afu_tlx_resp_initial_credit,
      afu_tlx_resp_credit               => afu_tlx_resp_credit,
      tlx_afu_resp_valid                => tlx_afu_resp_valid,
      tlx_afu_resp_opcode               => tlx_afu_resp_opcode,
      tlx_afu_resp_afutag               => tlx_afu_resp_afutag,

      -- Command data interface to AFU
      afu_tlx_cmd_rd_req                => afu_tlx_cmd_rd_req,
      afu_tlx_cmd_rd_cnt                => afu_tlx_cmd_rd_cnt,
      tlx_afu_cmd_data_valid            => tlx_afu_cmd_data_valid,
      tlx_afu_cmd_data_bus              => tlx_afu_cmd_data_bus,

      tlx_cfg_in_rcv_tmpl_capability_0  => tlx_cfg_in_rcv_tmpl_capability_0,
      tlx_cfg_in_rcv_tmpl_capability_1  => tlx_cfg_in_rcv_tmpl_capability_1,
      tlx_cfg_in_rcv_tmpl_capability_4  => tlx_cfg_in_rcv_tmpl_capability_4,
      tlx_cfg_in_rcv_tmpl_capability_7  => tlx_cfg_in_rcv_tmpl_capability_7,
      tlx_cfg_in_rcv_tmpl_capability_10 => tlx_cfg_in_rcv_tmpl_capability_10,
      tlx_cfg_in_rcv_rate_capability_0  => tlx_cfg_in_rcv_rate_capability_0,
      tlx_cfg_in_rcv_rate_capability_1  => tlx_cfg_in_rcv_rate_capability_1,
      tlx_cfg_in_rcv_rate_capability_4  => tlx_cfg_in_rcv_rate_capability_4,
      tlx_cfg_in_rcv_rate_capability_7  => tlx_cfg_in_rcv_rate_capability_7,
      tlx_cfg_in_rcv_rate_capability_10 => tlx_cfg_in_rcv_rate_capability_10,

      rcv_xmt_tlx_credit_vc0            => rcv_xmt_tlx_credit_vc0,                 -- from a return_tlx_credits - 01
      rcv_xmt_tlx_credit_vc3            => rcv_xmt_tlx_credit_vc3,                -- (sent from upstream)
      rcv_xmt_tlx_credit_dcp0           => rcv_xmt_tlx_credit_dcp0,               --
      rcv_xmt_tlx_credit_dcp3           => rcv_xmt_tlx_credit_dcp3,               -- vc0 and dcp0 for responses and data
      rcv_xmt_tlx_credit_valid          => rcv_xmt_tlx_credit_valid,              -- this need to be from a return_tl_credits   (this comes on when i get an 8)
                                                                                  --
      rcv_xmt_tl_credit_vc0_valid       => rcv_xmt_tl_credit_vc0_valid,           -- rcv_xmt_credit_vc0_v in   ocx_tlx_rcv_mac T
      rcv_xmt_tl_credit_vc1_valid       => rcv_xmt_tl_credit_vc1_valid,           -- rcv_xmt_credit_v          ocx_tlx_resp_fifo_mac
      rcv_xmt_tl_credit_dcp0_valid      => rcv_xmt_tl_credit_dcp0_valid,          --
      rcv_xmt_tl_credit_dcp1_valid      => rcv_xmt_tl_credit_dcp1_valid,          -- presume these should be VC1 for commands and dcp1 for data, coming out of some counters which say how much
      rcv_xmt_tl_crd_cfg_dcp1_valid     => rcv_xmt_tl_crd_cfg_dcp1_valid,

      -- -----------------------------------
      -- Miscellaneous Ports
      -- -----------------------------------
      metadata_enabled                  => cfg_tlx_metadata_enabled,
      tlx_mmio_rcv_errors               => tlx_mmio_rcv_errors,
      tlx_mmio_rcv_debug                => tlx_mmio_rcv_debug,
      clock                             => clock,
      reset_n                           => reset_n

      );


    -- ----------
    -- TLX Framer
    -- ----------
    icetlx_framer : component ice_tlx_framer
       port map (

        -- -----------------------------------
        -- AFU Command/Response/Data Interface
        -- -----------------------------------
        -- --- Initial credit allocation

        -- --- Commands from AFU
        tlx_afu_cmd_initial_credit        =>   tlx_afu_cmd_initial_credit ,
        tlx_afu_cmd_credit                =>   tlx_afu_cmd_credit,
        afu_tlx_cmd_valid                 =>   afu_tlx_cmd_valid,
        afu_tlx_cmd_opcode                =>   afu_tlx_cmd_opcode,
        afu_tlx_cmd_pa_or_obj             =>   afu_tlx_cmd_ea_or_obj,
        afu_tlx_cmd_actag                =>   afu_tlx_cmd_actag,

        afu_tlx_cmd_dl                    =>   "00",
        afu_tlx_cmd_pl                    =>   "000",
        afu_tlx_cmd_be                    =>   (others => '0'),
        afu_tlx_cmd_flag                  =>   afu_tlx_cmd_flag,
        afu_tlx_cmd_bdf                   =>   afu_tlx_cmd_bdf,
        afu_tlx_cmd_resp_code             =>   "0000",
        afu_tlx_cmd_afutag               =>   afu_tlx_cmd_afutag,

        -- --- Command data from AFU      =>
        tlx_afu_cmd_data_initial_credit   =>   tlx_afu_cmd_data_initial_credit,
        tlx_afu_cmd_data_credit           =>   tlx_afu_cmd_data_credit,
        afu_tlx_cdata_valid               =>   '0',
        afu_tlx_cdata_bus                 =>   (others => '0'),
        afu_tlx_cdata_bdi                 =>   '0',

        -- --- Responses from AFU         =>
        tlx_afu_resp_initial_credit       =>   tlx_afu_resp_initial_credit,
        tlx_afu_resp_credit               =>   tlx_afu_resp_credit,
        afu_tlx_resp_valid                =>   afu_tlx_resp_valid,
        afu_tlx_resp_opcode               =>   afu_tlx_resp_opcode,
        afu_tlx_resp_dl                   =>   afu_tlx_resp_dl,
        afu_tlx_resp_capptag              =>   afu_tlx_resp_capptag,
        afu_tlx_resp_dp                   =>   afu_tlx_resp_dp,
        afu_tlx_resp_code                 =>   afu_tlx_resp_code,

        -- --- Response data from AFU     =>
        tlx_afu_resp_data_initial_credit  =>   tlx_afu_resp_data_initial_credit,
        tlx_afu_resp_data_credit          =>   tlx_afu_resp_data_credit,
        afu_tlx_rdata_valid               =>   afu_tlx_rdata_valid,
        afu_tlx_rdata_bus                 =>   afu_tlx_rdata_bus,
        afu_tlx_rdata_bdi                 =>   afu_tlx_rdata_bdi,
        afu_tlx_rdata_meta                =>   afu_tlx_rdata_meta,

        -- --- Config Responses from AFU  =>
        cfg_tlx_resp_valid                =>   cfg_tlx_resp_valid,
        cfg_tlx_resp_opcode               =>   cfg_tlx_resp_opcode,
        cfg_tlx_resp_capptag              =>   cfg_tlx_resp_capptag,
        cfg_tlx_resp_code                 =>   cfg_tlx_resp_code,
        tlx_cfg_resp_ack                  =>   tlx_cfg_resp_ack,

        -- --- Config Response data from AFU
        cfg_tlx_rdata_offset              =>   cfg_tlx_rdata_offset,
        cfg_tlx_rdata_bus                 =>   cfg_tlx_rdata_bus,
        cfg_tlx_rdata_bdi                 =>   cfg_tlx_rdata_bdi,


        -- -----------------------------------
        -- TLX to DLX Interface
        -- -----------------------------------
        dlx_tlx_link_up                   =>   dlx_tlx_link_up,
        dlx_tlx_init_flit_depth           =>   dlx_tlx_init_flit_depth,
        dlx_tlx_flit_credit               =>   dlx_tlx_flit_credit,
        tlx_dlx_flit_valid                =>   tlx_dlx_flit_valid,
        tlx_dlx_flit                      =>   tlx_dlx_flit,

        -- -----------------------------------
        -- TLX Parser to TLX Framer Interface
        -- -----------------------------------
        rcv_xmt_tl_credit_vc0_valid       =>   rcv_xmt_tl_credit_vc0_valid,
        rcv_xmt_tl_credit_vc1_valid       =>   rcv_xmt_tl_credit_vc1_valid,
        rcv_xmt_tl_credit_dcp0_valid      =>   rcv_xmt_tl_credit_dcp0_valid ,
        rcv_xmt_tl_credit_dcp1_valid      =>   rcv_xmt_tl_credit_dcp1_valid ,
        rcv_xmt_tl_crd_cfg_dcp1_valid     =>   rcv_xmt_tl_crd_cfg_dcp1_valid,

        rcv_xmt_tlx_credit_valid          =>   rcv_xmt_tlx_credit_valid,
        rcv_xmt_tlx_credit_vc0            =>   rcv_xmt_tlx_credit_vc0 ,
        rcv_xmt_tlx_credit_vc3            =>   rcv_xmt_tlx_credit_vc3 ,
        rcv_xmt_tlx_credit_dcp0           =>   rcv_xmt_tlx_credit_dcp0 ,
        rcv_xmt_tlx_credit_dcp3           =>   rcv_xmt_tlx_credit_dcp3 ,

        -- -----------------------------------
        -- Configuration Ports
        -- -----------------------------------
        cfg_tlx_xmit_tmpl_config_0        =>   cfg_tlx_xmit_tmpl_config_0,
        cfg_tlx_xmit_tmpl_config_1        =>   cfg_tlx_xmit_tmpl_config_1,
        cfg_tlx_xmit_tmpl_config_5        =>   cfg_tlx_xmit_tmpl_config_5,
        cfg_tlx_xmit_rate_config_0        =>   cfg_tlx_xmit_rate_config_0,
        cfg_tlx_xmit_rate_config_1        =>   cfg_tlx_xmit_rate_config_1,
        cfg_tlx_xmit_rate_config_5        =>   cfg_tlx_xmit_rate_config_5,
        cfg_tlx_metadata_enabled          =>   cfg_tlx_metadata_enabled,

        -- -----------------------------------
        -- Debug Ports
        -- -----------------------------------
        rcv_xmt_debug_info                =>   rcv_xmt_debug_info,
        rcv_xmt_debug_fatal               =>   rcv_xmt_debug_fatal,
        rcv_xmt_debug_valid               =>   rcv_xmt_debug_valid,
        tlx_dlx_debug_encode              =>   tlx_dlx_debug_encode,
        tlx_dlx_debug_info                =>   tlx_dlx_debug_info,
        dlx_tlx_dlx_config_info           =>   dlx_tlx_dlx_config_info,
        tlx_mmio_xmt_err                  =>   tlx_mmio_xmt_err,
        tlx_mmio_xmt_dbg                  =>  tlx_mmio_xmt_dbg,

        -- -----------------------------------
        -- Misc. Interface
        -- -----------------------------------
        clock                             =>   clock,
        reset_n                           =>   reset_n
    ) ;

end architecture;
