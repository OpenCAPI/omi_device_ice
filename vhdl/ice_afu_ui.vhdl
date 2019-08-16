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
 
 
 


Library Ieee;
Use Ieee.Std_logic_1164.All;
Use Ieee.Numeric_std.All;
Use Ieee.Std_logic_arith.All;
Use Work.Ice_func.All;

ENTITY ice_afu_ui IS
  PORT
    (
      -- -----------------------------------
      -- MC User Interface
      -- -----------------------------------
      --PORT0 user interface
      c0_ddr4_ui_clk            : IN  STD_LOGIC;
      c0_ddr4_ui_clk_sync_rst   : IN  STD_LOGIC;
      c0_ddr4_app_en            : OUT STD_LOGIC;
      c0_ddr4_app_hi_pri        : OUT STD_LOGIC;
      c0_ddr4_app_wdf_end       : OUT STD_LOGIC;
      c0_ddr4_app_wdf_wren      : OUT STD_LOGIC;
      c0_ddr4_app_rd_data_end   : IN  STD_LOGIC;
      c0_ddr4_app_rd_data_valid : IN  STD_LOGIC;
      c0_ddr4_app_rdy           : IN  STD_LOGIC;
      c0_ddr4_app_wdf_rdy       : IN  STD_LOGIC;
      c0_ddr4_app_addr          : OUT STD_LOGIC_VECTOR(30 DOWNTO 0);
      c0_ddr4_app_cmd           : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      c0_ddr4_app_wdf_data      : OUT STD_LOGIC_VECTOR(575 DOWNTO 0);
      c0_ddr4_app_rd_data       : IN  STD_LOGIC_VECTOR(575 DOWNTO 0);
      c0_init_calib_complete    : IN  STD_LOGIC;
--      c0_dbg_clk                : IN  STD_LOGIC;
--      c0_dbg_bus                : IN  STD_LOGIC_VECTOR(511 DOWNTO 0);
      --PORT1 user interface
      c1_ddr4_ui_clk            : IN  STD_LOGIC;
      c1_ddr4_ui_clk_sync_rst   : IN  STD_LOGIC;
      c1_ddr4_app_en            : OUT STD_LOGIC;
      c1_ddr4_app_hi_pri        : OUT STD_LOGIC;
      c1_ddr4_app_wdf_end       : OUT STD_LOGIC;
      c1_ddr4_app_wdf_wren      : OUT STD_LOGIC;
      c1_ddr4_app_rd_data_end   : IN  STD_LOGIC;
      c1_ddr4_app_rd_data_valid : IN  STD_LOGIC;
      c1_ddr4_app_rdy           : IN  STD_LOGIC;
      c1_ddr4_app_wdf_rdy       : IN  STD_LOGIC;
      c1_ddr4_app_addr          : OUT STD_LOGIC_VECTOR(30 DOWNTO 0);
      c1_ddr4_app_cmd           : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      c1_ddr4_app_wdf_data      : OUT STD_LOGIC_VECTOR(575 DOWNTO 0);
      c1_ddr4_app_rd_data       : IN  STD_LOGIC_VECTOR(575 DOWNTO 0);
      c1_init_calib_complete    : IN  STD_LOGIC;
--      c1_dbg_clk                : IN  STD_LOGIC;
--      c1_dbg_bus                : IN  STD_LOGIC_VECTOR(511 DOWNTO 0);
      -- -----------------------------------
      -- --UI cmd queue interface 
      -- -----------------------------------
      i_cmd_valid               : IN  STD_ULOGIC;
      i_cmd_rw                  : IN  STD_ULOGIC;  --0:R  1:W
      i_cmd_addr                : IN  STD_ULOGIC_VECTOR(31 DOWNTO 3);
      i_cmd_tag                 : IN  STD_ULOGIC_VECTOR(15 DOWNTO 0);
      i_cmd_size                : IN  STD_ULOGIC;
      o_cmd_fc                  : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0);
      -- -----------------------------------
      -- --UI Data queue interface 
      -- -----------------------------------
      i_wvalid                  : IN  STD_ULOGIC_VECTOR(1 DOWNTO 0);
      i_wdata                   : IN  STD_ULOGIC_VECTOR(511 DOWNTO 0);
      i_wmeta                   : IN  STD_ULOGIC_VECTOR(39 DOWNTO 0);
      -- -----------------------------------
      -- --UI response interface 
      -- -----------------------------------
      o_rsp_tag                 : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0);
      o_rsp_data                : OUT STD_ULOGIC_VECTOR(511 DOWNTO 0);
      o_rsp_meta                : OUT STD_ULOGIC_VECTOR(39 DOWNTO 0);
      o_rsp_perr                : OUT STD_ULOGIC_VECTOR(23 DOWNTO 0);
      o_rsp_offs                : OUT STD_ULOGIC;
      o_rsp_size                : OUT STD_ULOGIC;  --0: indicates request was for 64B  1: indicates request was for 128B. i_rsp_offs determine which half 
      i_yield                   : IN  STD_ULOGIC_VECTOR(1 DOWNTO 0);
      i_arbwt                   : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      -- -----------------------------------
      -- dbg & err
      -- -----------------------------------
      o_idle                          : out std_ulogic_vector(1 downto 0);   --@hclk
      o_mc0_fifo_err                  : out std_ulogic_vector(9 downto 0);     -- @hclk
      o_mc1_fifo_err                  : out std_ulogic_vector(9 downto 0);      -- @hclk
      -- -----------------------------------
      -- Miscellaneous Ports
      -- -----------------------------------
      clock_400mhz              : IN  STD_ULOGIC;
      reset_n                   : IN  STD_ULOGIC

      );

END ice_afu_ui;

ARCHITECTURE ice_afu_ui OF ice_afu_ui IS


  SIGNAL i_mclk                       : STD_ULOGIC_VECTOR(1 DOWNTO 0);                       -- [in]
  SIGNAL i_mc_reset                   : STD_ULOGIC_VECTOR(1 DOWNTO 0);                       -- [in]
  SIGNAL i_hclk                       : STD_ULOGIC;                       -- [in]
  SIGNAL i_reset                      : STD_ULOGIC;                       -- [in]
  -- connect this part to the xilinx mc
  -- port 0
  SIGNAL i_ddr0_mc0_app_rdy           : STD_ULOGIC;                       -- [in]
  SIGNAL i_ddr0_mc0_app_wdf_rdy       : STD_ULOGIC;                       -- [in]
  SIGNAL i_ddr0_mc0_app_rd_data_end   : STD_ULOGIC;                       -- [in]
  SIGNAL i_ddr0_mc0_app_rd_data_valid : STD_ULOGIC;                       -- [in]
  SIGNAL i_ddr0_mc0_app_rd_data       : STD_ULOGIC_VECTOR(575 DOWNTO 0);  -- [in]
  SIGNAL o_mc0_ddr0_addr              : STD_ULOGIC_VECTOR(30 DOWNTO 0);   -- [out]
  SIGNAL o_mc0_ddr0_cmd               : STD_ULOGIC_VECTOR(2 DOWNTO 0);    -- [out]
  SIGNAL o_mc0_ddr0_en                : STD_ULOGIC;                       -- [out]
  SIGNAL o_mc0_ddr0_wdf_end           : STD_ULOGIC;                       -- [out]
  SIGNAL o_mc0_ddr0_wdf_wren          : STD_ULOGIC;                       -- [out]
  SIGNAL o_mc0_ddr0_wdf_data          : STD_ULOGIC_VECTOR(575 DOWNTO 0);  -- [out]
  -- port 1
  SIGNAL i_ddr1_mc1_app_rdy           : STD_ULOGIC;                       -- [in]
  SIGNAL i_ddr1_mc1_app_wdf_rdy       : STD_ULOGIC;                       -- [in]
  SIGNAL i_ddr1_mc1_app_rd_data_end   : STD_ULOGIC;                       -- [in]
  SIGNAL i_ddr1_mc1_app_rd_data_valid : STD_ULOGIC;                       -- [in]
  SIGNAL i_ddr1_mc1_app_rd_data       : STD_ULOGIC_VECTOR(575 DOWNTO 0);  -- [in]
  SIGNAL o_mc1_ddr1_addr              : STD_ULOGIC_VECTOR(30 DOWNTO 0);   -- [out]
  SIGNAL o_mc1_ddr1_cmd               : STD_ULOGIC_VECTOR(2 DOWNTO 0);    -- [out]
  SIGNAL o_mc1_ddr1_en                : STD_ULOGIC;                       -- [out]
  SIGNAL o_mc1_ddr1_wdf_end           : STD_ULOGIC;                       -- [out]
  SIGNAL o_mc1_ddr1_wdf_wren          : STD_ULOGIC;                       -- [out]
  SIGNAL o_mc1_ddr1_wdf_data          : STD_ULOGIC_VECTOR(575 DOWNTO 0);  -- [out]

BEGIN

  i_mclk(0)                    <= c0_ddr4_ui_clk;  --                 : std_ulogic;                      
  i_mclk(1)                    <= c1_ddr4_ui_clk;  --                 : std_ulogic;                      
  i_mc_reset(0)                <= c0_ddr4_ui_clk_sync_rst;  --                   : std_ulogic;                       
  i_mc_reset(1)                <= c1_ddr4_ui_clk_sync_rst;  --                   : std_ulogic;                       
  i_hclk                       <= clock_400mhz;  --                     : std_ulogic;                    
  i_reset                      <= NOT reset_n;  --                   : std_ulogic;                       
  i_ddr0_mc0_app_rdy           <= c0_ddr4_app_rdy;  --: std_ulogic;                                     
  i_ddr0_mc0_app_wdf_rdy       <= c0_ddr4_app_wdf_rdy;  --: std_ulogic;                                  
  i_ddr0_mc0_app_rd_data_end   <= c0_ddr4_app_rd_data_end;  --: std_ulogic;                              
  i_ddr0_mc0_app_rd_data_valid <= c0_ddr4_app_rd_data_valid;  --: std_ulogic;                            
  i_ddr0_mc0_app_rd_data       <= To_StdULogicVector(c0_ddr4_app_rd_data);  --: std_ulogic_vector(575 downto 0);             
  c0_ddr4_app_addr             <= To_StdLogicVector(o_mc0_ddr0_addr);  --   : std_ulogic_vector(30 downto 0);               
  c0_ddr4_app_cmd              <= To_StdLogicVector(o_mc0_ddr0_cmd);  --   : std_ulogic_vector(2 downto 0);                 
  c0_ddr4_app_en               <= o_mc0_ddr0_en;  --   : std_ulogic;                                     
  c0_ddr4_app_wdf_end          <= o_mc0_ddr0_wdf_end;  --   : std_ulogic;                                
  c0_ddr4_app_wdf_wren         <= o_mc0_ddr0_wdf_wren;  --   : std_ulogic;                               
  c0_ddr4_app_wdf_data         <= To_StdLogicVector(o_mc0_ddr0_wdf_data);  --   : std_ulogic_vector(575 downto 0);          
  c0_ddr4_app_hi_pri           <= '0';
  i_ddr1_mc1_app_rdy           <= c1_ddr4_app_rdy;  --: std_ulogic;                                     
  i_ddr1_mc1_app_wdf_rdy       <= c1_ddr4_app_wdf_rdy;  --: std_ulogic;                                  
  i_ddr1_mc1_app_rd_data_end   <= c1_ddr4_app_rd_data_end;  --: std_ulogic;                              
  i_ddr1_mc1_app_rd_data_valid <= c1_ddr4_app_rd_data_valid;  --: std_ulogic;                            
  i_ddr1_mc1_app_rd_data       <= To_StdULogicVector(c1_ddr4_app_rd_data);  --: std_ulogic_vector(575 downto 0);             
  c1_ddr4_app_addr             <= To_StdLogicVector(o_mc1_ddr1_addr);  --   : std_ulogic_vector(30 downto 0);               
  c1_ddr4_app_cmd              <= To_StdLogicVector(o_mc1_ddr1_cmd);  --   : std_ulogic_vector(2 downto 0);                 
  c1_ddr4_app_en               <= o_mc1_ddr1_en;  --   : std_ulogic;                                     
  c1_ddr4_app_wdf_end          <= o_mc1_ddr1_wdf_end;  --   : std_ulogic;                                
  c1_ddr4_app_wdf_wren         <= o_mc1_ddr1_wdf_wren;  --   : std_ulogic;                               
  c1_ddr4_app_wdf_data         <= To_StdLogicVector(o_mc1_ddr1_wdf_data);  --   : std_ulogic_vector(575 downto 0);          
  c1_ddr4_app_hi_pri           <= '0';
  gmc : ENTITY work.ice_gmc_top
    PORT MAP (
      i_mclk                       => i_mclk,                        -- [in  std_ulogic_vector(1 downto 0)]
      i_hclk                       => i_hclk,                        -- [in  std_ulogic]
      i_reset                      => i_reset,                       -- [in  std_ulogic_vector(1 downto 0)]
      i_mc_reset                   => i_mc_reset,                       -- [in  std_ulogic]
      o_idle                       => o_idle,                        -- [out  std_ulogic_vector(1 downto 0)]
      -- static configuration
      i_arbwt                      => i_arbwt,                       -- [in  std_ulogic_vector(7 downto 0) := (others => '0')] 0,1,2,3
      i_yield                      => i_yield,                       -- [in  std_ulogic_vector(1 downto 0)]
      -- host interface.
      i_cmd_valid                  => i_cmd_valid,                   -- [in  std_ulogic]
      i_cmd_rw                     => i_cmd_rw,                      -- [in  std_ulogic] 1=write.
      i_cmd_addr                   => i_cmd_addr,                    -- [in  std_ulogic_vector(31 downto 3)]
      i_cmd_tag                    => i_cmd_tag,                     -- [in  std_ulogic_vector(15 downto 0)]
      i_cmd_size                   => i_cmd_size,                    -- [in  std_ulogic] 0:64B, 1:128B
      i_wvalid                     => i_wvalid,                      -- [in  std_ulogic_vector(1 downto 0)] p1, p0.
      i_wdata                      => i_wdata,                       -- [in  std_ulogic_vector(511 downto 0)]
      i_wmeta                      => i_wmeta,                       -- [in  std_ulogic_vector(39 downto 0)]
      -- response merge.
      o_cmd_fc                     => o_cmd_fc,                      -- [out std_ulogic_vector(3 downto 0)] r1, r0, w1, w0
      o_rsp_tag                    => o_rsp_tag,                     -- [out std_ulogic_vector(15 downto 0)]
      o_rsp_offs                   => o_rsp_offs,                    -- [out std_ulogic]
      o_rsp_data                   => o_rsp_data,                    -- [out std_ulogic_vector(511 downto 0)]
      o_rsp_meta                   => o_rsp_meta,                    -- [out std_ulogic_vector(39 downto 0)]
      o_rsp_size                   => o_rsp_size,                    -- [out std_ulogic]
      o_rsp_perr                   => o_rsp_perr,                    -- [out std_ulogic_vector(23 downto 0)]
      -- connect this part to the xilinx mc
      -- port 0
      i_ddr0_mc0_app_rdy           => i_ddr0_mc0_app_rdy,            -- [in  std_ulogic]
      i_ddr0_mc0_app_wdf_rdy       => i_ddr0_mc0_app_wdf_rdy,        -- [in  std_ulogic]
      i_ddr0_mc0_app_rd_data_end   => i_ddr0_mc0_app_rd_data_end,    -- [in  std_ulogic]
      i_ddr0_mc0_app_rd_data_valid => i_ddr0_mc0_app_rd_data_valid,  -- [in  std_ulogic]
      i_ddr0_mc0_app_rd_data       => i_ddr0_mc0_app_rd_data,        -- [in  std_ulogic_vector(575 downto 0)]
      o_mc0_ddr0_addr              => o_mc0_ddr0_addr,               -- [out std_ulogic_vector(30 downto 0)]
      o_mc0_ddr0_cmd               => o_mc0_ddr0_cmd,                -- [out std_ulogic_vector(2 downto 0)]
      o_mc0_ddr0_en                => o_mc0_ddr0_en,                 -- [out std_ulogic]
      o_mc0_ddr0_wdf_end           => o_mc0_ddr0_wdf_end,            -- [out std_ulogic]
      o_mc0_ddr0_wdf_wren          => o_mc0_ddr0_wdf_wren,           -- [out std_ulogic]
      o_mc0_ddr0_wdf_data          => o_mc0_ddr0_wdf_data,           -- [out std_ulogic_vector(575 downto 0)]
      o_mc0_fifo_err               => o_mc0_fifo_err,                 --   : out std_ulogic_vector(9 downto 0)      -- @hclk
      -- port 1
      i_ddr1_mc1_app_rdy           => i_ddr1_mc1_app_rdy,            -- [in  std_ulogic]
      i_ddr1_mc1_app_wdf_rdy       => i_ddr1_mc1_app_wdf_rdy,        -- [in  std_ulogic]
      i_ddr1_mc1_app_rd_data_end   => i_ddr1_mc1_app_rd_data_end,    -- [in  std_ulogic]
      i_ddr1_mc1_app_rd_data_valid => i_ddr1_mc1_app_rd_data_valid,  -- [in  std_ulogic]
      i_ddr1_mc1_app_rd_data       => i_ddr1_mc1_app_rd_data,        -- [in  std_ulogic_vector(575 downto 0)]
      o_mc1_fifo_err               => o_mc1_fifo_err,                 --   : out std_ulogic_vector(9 downto 0)      -- @hclk
      o_mc1_ddr1_addr              => o_mc1_ddr1_addr,               -- [out std_ulogic_vector(30 downto 0)]
      o_mc1_ddr1_cmd               => o_mc1_ddr1_cmd,                -- [out std_ulogic_vector(2 downto 0)]
      o_mc1_ddr1_en                => o_mc1_ddr1_en,                 -- [out std_ulogic]
      o_mc1_ddr1_wdf_end           => o_mc1_ddr1_wdf_end,            -- [out std_ulogic]
      o_mc1_ddr1_wdf_wren          => o_mc1_ddr1_wdf_wren,           -- [out std_ulogic]
      o_mc1_ddr1_wdf_data          => o_mc1_ddr1_wdf_data);          -- [out std_ulogic_vector(575 downto 0)]
END ice_afu_ui;
