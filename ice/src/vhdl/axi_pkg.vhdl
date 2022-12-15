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

package axi_pkg is

  ---------------------------------------------------------------------------
  -- Type Aliases for AXI4-Lite Interface
  ---------------------------------------------------------------------------
  type t_AXI4_LITE_SLAVE_INPUT is record
    -- Global
    s0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    s0_axi_awvalid : std_ulogic;
    s0_axi_awaddr  : std_ulogic_vector(63 downto 0);
    s0_axi_awprot  : std_ulogic_vector(2 downto 0);

    -- Write Data Channel
    s0_axi_wvalid : std_ulogic;
    s0_axi_wdata  : std_ulogic_vector(31 downto 0);
    s0_axi_wstrb  : std_ulogic_vector(3 downto 0);

    -- Write Response Channel
    s0_axi_bready : std_ulogic;

    -- Read Address Channel
    s0_axi_arvalid : std_ulogic;
    s0_axi_araddr  : std_ulogic_vector(63 downto 0);
    s0_axi_arprot  : std_ulogic_vector(2 downto 0);

    -- Read Data Channel
    s0_axi_rready : std_ulogic;
  end record t_AXI4_LITE_SLAVE_INPUT;

  type t_AXI4_LITE_SLAVE_OUTPUT is record
    -- Global

    -- Write Address Channel
    s0_axi_awready : std_ulogic;

    -- Write Data Channel
    s0_axi_wready : std_ulogic;

    -- Write Response Channel
    s0_axi_bvalid : std_ulogic;
    s0_axi_bresp  : std_ulogic_vector(1 downto 0);

    -- Read Address Channel
    s0_axi_arready : std_ulogic;

    -- Read Data Channel
    s0_axi_rvalid : std_ulogic;
    s0_axi_rdata  : std_ulogic_vector(31 downto 0);
    s0_axi_rresp  : std_ulogic_vector(1 downto 0);
  end record t_AXI4_LITE_SLAVE_OUTPUT;

  type t_AXI4_LITE_MASTER_OUTPUT is record
    -- Global
    m0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    m0_axi_awvalid : std_ulogic;
    m0_axi_awaddr  : std_ulogic_vector(63 downto 0);
    m0_axi_awprot  : std_ulogic_vector(2 downto 0);

    -- Write Data Channel
    m0_axi_wvalid : std_ulogic;
    m0_axi_wdata  : std_ulogic_vector(31 downto 0);
    m0_axi_wstrb  : std_ulogic_vector(3 downto 0);

    -- Write Response Channel
    m0_axi_bready : std_ulogic;

    -- Read Address Channel
    m0_axi_arvalid : std_ulogic;
    m0_axi_araddr  : std_ulogic_vector(63 downto 0);
    m0_axi_arprot  : std_ulogic_vector(2 downto 0);

    -- Read Data Channel
    m0_axi_rready : std_ulogic;
  end record t_AXI4_LITE_MASTER_OUTPUT;

  type t_AXI4_LITE_MASTER_INPUT is record
    -- Global

    -- Write Address Channel
    m0_axi_awready : std_ulogic;

    -- Write Data Channel
    m0_axi_wready : std_ulogic;

    -- Write Response Channel
    m0_axi_bvalid : std_ulogic;
    m0_axi_bresp  : std_ulogic_vector(1 downto 0);

    -- Read Address Channel
    m0_axi_arready : std_ulogic;

    -- Read Data Channel
    m0_axi_rvalid : std_ulogic;
    m0_axi_rdata  : std_ulogic_vector(31 downto 0);
    m0_axi_rresp  : std_ulogic_vector(1 downto 0);
  end record t_AXI4_LITE_MASTER_INPUT;

  ---------------------------------------------------------------------------
  -- Functions to Connect Master and Slaves
  ---------------------------------------------------------------------------
  function axi4_lite_master_slave_connect (
    i : in t_AXI4_LITE_SLAVE_OUTPUT
    ) return t_AXI4_LITE_MASTER_INPUT;

  function axi4_lite_master_slave_connect (
    i : in t_AXI4_LITE_MASTER_OUTPUT
    ) return t_AXI4_LITE_SLAVE_INPUT;

end package axi_pkg;

package body axi_pkg is

  function axi4_lite_master_slave_connect (
    i : in t_AXI4_LITE_SLAVE_OUTPUT
    ) return t_AXI4_LITE_MASTER_INPUT is
    variable o : t_AXI4_LITE_MASTER_INPUT;
  begin
    o.m0_axi_awready := i.s0_axi_awready;
    o.m0_axi_wready  := i.s0_axi_wready;
    o.m0_axi_bvalid  := i.s0_axi_bvalid;
    o.m0_axi_bresp   := i.s0_axi_bresp;
    o.m0_axi_arready := i.s0_axi_arready;
    o.m0_axi_rvalid  := i.s0_axi_rvalid;
    o.m0_axi_rdata   := i.s0_axi_rdata;
    o.m0_axi_rresp   := i.s0_axi_rresp;
    return o;
  end;

  function axi4_lite_master_slave_connect (
    i : in t_AXI4_LITE_MASTER_OUTPUT
    ) return t_AXI4_LITE_SLAVE_INPUT is
    variable o : t_AXI4_LITE_SLAVE_INPUT;

  begin
    o.s0_axi_aresetn := i.m0_axi_aresetn;
    o.s0_axi_awvalid := i.m0_axi_awvalid;
    o.s0_axi_awaddr  := i.m0_axi_awaddr;
    o.s0_axi_awprot  := i.m0_axi_awprot;
    o.s0_axi_wvalid  := i.m0_axi_wvalid;
    o.s0_axi_wdata   := i.m0_axi_wdata;
    o.s0_axi_wstrb   := i.m0_axi_wstrb;
    o.s0_axi_bready  := i.m0_axi_bready;
    o.s0_axi_arvalid := i.m0_axi_arvalid;
    o.s0_axi_araddr  := i.m0_axi_araddr;
    o.s0_axi_arprot  := i.m0_axi_arprot;
    o.s0_axi_rready  := i.m0_axi_rready;
    return o;
  end;

end package body axi_pkg;
