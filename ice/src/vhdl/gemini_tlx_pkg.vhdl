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
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use work.ice_func.all;

package gemini_tlx_pkg is
-- get the number of address bits needed for fifos etc if you know the depth
   function log2 (x : positive) return natural;
   function one_less (b : std_ulogic_vector) return std_ulogic_vector;

   component iram_1r1w1ck_64x519
      port (
         clk       : in  std_ulogic;
         ena       : in  std_ulogic;
         enb       : in  std_ulogic;
         wea       : in  std_ulogic;
         dia       : in  std_ulogic_vector(518 downto 0);
         addra     : in  std_ulogic_vector(5 downto 0);
         addrb     : in  std_ulogic_vector(5 downto 0);
         dob       : out std_ulogic_vector(518 downto 0)
      );
   end component;

   component iram_1r1w1ck_64x518
      port (
         clk       : in  std_ulogic;
         ena       : in  std_ulogic;
         enb       : in  std_ulogic;
         wea       : in  std_ulogic;
         dia       : in  std_ulogic_vector(517 downto 0);
         addra     : in  std_ulogic_vector(5 downto 0);
         addrb     : in  std_ulogic_vector(5 downto 0);
         dob       : out std_ulogic_vector(517 downto 0)
      );
   end component;

   component iram_1r1w1ck_64x112
      port (
         clk       : in  std_ulogic;
         ena       : in  std_ulogic;
         enb       : in  std_ulogic;
         wea       : in  std_ulogic;
         dia       : in  std_ulogic_vector(111 downto 0);
         addra     : in  std_ulogic_vector(5 downto 0);
         addrb     : in  std_ulogic_vector(5 downto 0);
         dob       : out std_ulogic_vector(111 downto 0)
      );
   end component;

   component iram_1r1w1ck_64x85
      port (
         clk       : in  std_ulogic;
         ena       : in  std_ulogic;
         enb       : in  std_ulogic;
         wea       : in  std_ulogic;
         dia       : in  std_ulogic_vector(84 downto 0);
         addra     : in  std_ulogic_vector(5 downto 0);
         addrb     : in  std_ulogic_vector(5 downto 0);
         dob       : out std_ulogic_vector(84 downto 0)
      );
   end component;

   component iram_1r1w1ck_64x32
      port (
         clk       : in  std_ulogic;
         ena       : in  std_ulogic;
         enb       : in  std_ulogic;
         wea       : in  std_ulogic;
         dia       : in  std_ulogic_vector(31 downto 0);
         addra     : in  std_ulogic_vector(5 downto 0);
         addrb     : in  std_ulogic_vector(5 downto 0);
         dob       : out std_ulogic_vector(31 downto 0)
      );
   end component;

   component iram_1r1w1ck_64x16
      port (
         clk       : in  std_ulogic;
         ena       : in  std_ulogic;
         enb       : in  std_ulogic;
         wea       : in  std_ulogic;
         dia       : in  std_ulogic_vector(15 downto 0);
         addra     : in  std_ulogic_vector(5 downto 0);
         addrb     : in  std_ulogic_vector(5 downto 0);
         dob       : out std_ulogic_vector(15 downto 0)
      );
   end component;

   component  ice_tlx_framer
      port (
        -- AFU Command/Response/Data Interface
        -- -----------------------------------
        -- --- Initial credit allocation

        -- --- Commands from AFU
        tlx_afu_cmd_initial_credit        : out std_ulogic_vector(3 downto 0);
        tlx_afu_cmd_credit                : out std_ulogic;
        afu_tlx_cmd_valid                 : in  std_ulogic;
        afu_tlx_cmd_opcode                : in  std_ulogic_vector(7 downto 0);
        afu_tlx_cmd_pa_or_obj             : in  std_ulogic_vector(63 downto 0); 
        afu_tlx_cmd_afutag                : in  std_ulogic_vector(15 downto 0);
        afu_tlx_cmd_dl                    : in  std_ulogic_vector(1 downto 0);
        afu_tlx_cmd_pl                    : in  std_ulogic_vector(2 downto 0);
        afu_tlx_cmd_be                    : in  std_ulogic_vector(63 downto 0);
        afu_tlx_cmd_flag                  : in  std_ulogic_vector(3 downto 0);
        afu_tlx_cmd_bdf                   : in  std_ulogic_vector(15 downto 0);
        afu_tlx_cmd_resp_code             : in  std_ulogic_vector(3 downto 0);
        afu_tlx_cmd_actag                 : in  std_ulogic_vector(11 downto 0);

        -- --- Command data from AFU
        tlx_afu_cmd_data_initial_credit   : out std_ulogic_vector(5 downto 0);
        tlx_afu_cmd_data_credit           : out std_ulogic;
        afu_tlx_cdata_valid               : in  std_ulogic;
        afu_tlx_cdata_bus                 : in  std_ulogic_vector(511 downto 0);
        afu_tlx_cdata_bdi                 : in  std_ulogic;

        -- --- Responses from AFU
        tlx_afu_resp_initial_credit       : out std_ulogic_vector(5 downto 0);
        tlx_afu_resp_credit               : out std_ulogic;
        afu_tlx_resp_valid                : in  std_ulogic;
        afu_tlx_resp_opcode               : in  std_ulogic_vector(7 downto 0);
        afu_tlx_resp_dl                   : in  std_ulogic_vector(1 downto 0);
        afu_tlx_resp_capptag              : in  std_ulogic_vector(15 downto 0);
        afu_tlx_resp_dp                   : in  std_ulogic_vector(1 downto 0);
        afu_tlx_resp_code                 : in  std_ulogic_vector(3 downto 0);

        -- --- Response data from AFU
        tlx_afu_resp_data_initial_credit  : out std_ulogic_vector(5 downto 0);
        tlx_afu_resp_data_credit          : out std_ulogic;
        afu_tlx_rdata_valid               : in  std_ulogic;
        afu_tlx_rdata_bus                 : in  std_ulogic_vector(511 downto 0);
        afu_tlx_rdata_bdi                 : in  std_ulogic;
        afu_tlx_rdata_meta                : in  std_ulogic_vector(5 downto 0);

        -- --- Config Responses from AFU
        cfg_tlx_resp_valid                : in  std_ulogic;
        cfg_tlx_resp_opcode               : in  std_ulogic_vector(7 downto 0);
        cfg_tlx_resp_capptag              : in  std_ulogic_vector(15 downto 0);
        cfg_tlx_resp_code                 : in  std_ulogic_vector(3 downto 0);
        tlx_cfg_resp_ack                  : out std_ulogic;

        -- --- Config Response data from AFU
        cfg_tlx_rdata_offset              : in  std_ulogic_vector(3 downto 0);
        cfg_tlx_rdata_bus                 : in  std_ulogic_vector(31 downto 0);
        cfg_tlx_rdata_bdi                 : in  std_ulogic;


        -- -----------------------------------
        -- TLX to DLX Interface
        -- -----------------------------------
        dlx_tlx_link_up                   : in  std_ulogic;
        dlx_tlx_init_flit_depth           : in  std_ulogic_vector(2 downto 0);
        dlx_tlx_flit_credit               : in  std_ulogic;
        tlx_dlx_flit_valid                : out std_ulogic;
        tlx_dlx_flit                      : out std_ulogic_vector(511 downto 0);
        dlx_tlx_dlx_config_info           : in  std_ulogic_vector(31 downto 0);

        -- -----------------------------------
        -- TLX Parser to TLX Framer Interface
        -- -----------------------------------
        rcv_xmt_tl_credit_vc0_valid       : in  std_ulogic;
        rcv_xmt_tl_credit_vc1_valid       : in  std_ulogic;
        rcv_xmt_tl_credit_dcp0_valid      : in  std_ulogic;
        rcv_xmt_tl_credit_dcp1_valid      : in  std_ulogic;
        rcv_xmt_tl_crd_cfg_dcp1_valid     : in  std_ulogic;

        rcv_xmt_tlx_credit_valid          : in  std_ulogic;
        rcv_xmt_tlx_credit_vc0            : in  std_ulogic_vector(3 downto 0);
        rcv_xmt_tlx_credit_vc3            : in  std_ulogic_vector(3 downto 0);
        rcv_xmt_tlx_credit_dcp0           : in  std_ulogic_vector(5 downto 0);
        rcv_xmt_tlx_credit_dcp3           : in  std_ulogic_vector(5 downto 0);


        -- -----------------------------------
        -- Configuration Ports
        -- -----------------------------------
        cfg_tlx_xmit_tmpl_config_0        : in  std_ulogic;
        cfg_tlx_xmit_tmpl_config_1        : in  std_ulogic;
        cfg_tlx_xmit_tmpl_config_5        : in  std_ulogic;
        cfg_tlx_xmit_rate_config_0        : in  std_ulogic_vector(3 downto 0);
        cfg_tlx_xmit_rate_config_1        : in  std_ulogic_vector(3 downto 0);
        cfg_tlx_xmit_rate_config_5        : in  std_ulogic_vector(3 downto 0);
        cfg_tlx_metadata_enabled          : in  std_ulogic;


        -- -----------------------------------
        -- Debug Ports
        -- -----------------------------------
        rcv_xmt_debug_info                : in  std_ulogic_vector(31 downto 0);
        rcv_xmt_debug_fatal               : in  std_ulogic;
        rcv_xmt_debug_valid               : in  std_ulogic;
        tlx_dlx_debug_encode              : out std_ulogic_vector(3 downto 0);
        tlx_dlx_debug_info                : out std_ulogic_vector(31 downto 0);
        tlx_mmio_xmt_err                  : out std_ulogic_vector(15 downto 0);
        tlx_mmio_xmt_dbg                  : out std_ulogic_vector(63 downto 0);


        -- -----------------------------------
        -- Misc. Interface
        -- -----------------------------------
        clock                             : in  std_ulogic;
        reset_n                           : in  std_ulogic
    ) ;
   end component;

  end gemini_tlx_pkg;

-----------------------------------------------------------------------------------------------------

package body gemini_tlx_pkg is

   function log2 (x : positive) return natural is
      variable i : natural;
   begin
      assert x < 2049 report "log2: input bigger than 2048 " severity error;
      i := 0;
      while (2**i < x) and i < 2049 loop
         i := i + 1;
      end loop;
      return i;
   end function;

   function one_less (b : std_ulogic_vector) return std_ulogic_vector is
      variable m1  : std_ulogic_vector(b'range);
      variable ret : std_ulogic_vector(b'range);
   begin
      assert b'left > b'right report "minus_one function wants little endian" severity error;
      assert b(b'left) /= '1' or b(b'left-1 downto b'right) = (b'left-1 downto b'right => '0') report "minus_one function invalid input" severity error;
      -- input must be such that subtracting 1 makes a shorter vector without losing information
      m1 := (others => '0');
      m1(b'right) := '1';
      ret := b-m1;
      return ret(b'left - 1 downto b'right);
   end function;

end package body gemini_tlx_pkg;
