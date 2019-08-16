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
Use Ieee.Std_logic_1164.All;
Use Ieee.Numeric_std.All;
Use Ieee.Std_logic_arith.All;
Use Work.Ice_func.All;

entity ice_cfg_reg is
  generic
    (

      -------------------------------------------------------------------------
      addr_bit_index                 : natural := 0;    --address index of the register
      num_addr_bits                  : natural := 54;   --address width
      -------------------------------------------------------------------------
      -- Register Definition Setup
      -------------------------------------------------------------------------
      --Making config reg width configurable in case you don't want to use a
      --full 8 Bytes
      reg_width                      : natural := 64;    --Width of register in bits

      --The following is the reset value for the instantiated register and are
      --hard-coded to 64 bit vectors, which sets the max reg_width value at 64.
      --This is done to conincide with the default SCOM register width of 64 bits.
      --If the user implements reg_width < 64, the default reset value for the
      --register below will come from the range (0 to ((reg_width) - 1)) and the
      --lower order values will be ingnored.
      reg_reset_value                : std_ulogic_vector(0 to 63) := X"0000000000000000"

      );
  port
    (
      --CLOCKS
      clock_400mhz                           : in std_ulogic;
      reset_n                         : in STD_ULOGIC;  --connect the latch version of syncr


      sc_addr_v                      : in std_ulogic_vector(0 to (num_addr_bits - 1));
      --If the user implements reg_width < 64, the scom write data for the
      --register will come from the range (0 to ((reg_width) - 1)) and the
      --lower order values will be ingnored.
      sc_wdata                       : in std_ulogic_vector(0 to 63);  --  Write data delivered from SCOM satellite for a write request
      sc_wparity                     : in std_ulogic;                             --  Write data parity bit over sc_wdata
      sc_wr                          : in std_ulogic;       -- write pulse


      --REGISTER OUTPUTS
      cfg_reg                        : out std_ulogic_vector(0 to ((reg_width) - 1));  --configuration register output value
      cfg_reg_p                      : out std_ulogic;
      cfg_reg_perr                   : out std_ulogic;                                 --internal parity error reporting for this register instantiation
      sc_wr_pulse                    : out std_ulogic   -- single-cycle pulse indicating this reg is being written (address hit, etc.)
      );
  
end ice_cfg_reg;


architecture ice_cfg_reg of ice_cfg_reg is

signal cfg_reg_d   : std_ulogic_vector(0 to reg_width-1);  --configuration register output value
SIGNAL cfg_reg_p_d : std_ulogic;

signal cfg_reg_q   : std_ulogic_vector(0 to ((REG_WIDTH)-1)) := reg_reset_value(0 TO (reg_width-1));  --configuration register output value
SIGNAL cfg_reg_p_q : std_ulogic;
SIGNAL cfg_reg_perr_d : std_ulogic;
SIGNAL cfg_reg_perr_q : std_ulogic;
SIGNAL act_cfg : std_ulogic;
SIGNAL cfg_reg_wr : std_ulogic;
SIGNAL sc_wr_pulse_q : std_ulogic;
SIGNAL sc_wr_pulse_d : std_ulogic;
 
begin  


  act_cfg    <= cfg_reg_wr;
  cfg_reg_wr <= sc_wr AND sc_addr_v(addr_bit_index);

  genP64 : IF reg_width = 64 GENERATE
      cfg_reg_d  <= gate(sc_wdata, cfg_reg_wr) OR
                    gate(cfg_reg_q, NOT cfg_reg_wr);
      cfg_reg_p_d <= (sc_wparity  AND cfg_reg_wr) OR (cfg_reg_p_q and NOT cfg_reg_wr);

  END GENERATE genP64;
    
  genP_not64 : IF reg_width < 64 GENERATE
      cfg_reg_d  <= gate(sc_wdata(0 TO reg_width-1),      cfg_reg_wr) OR
                    gate(cfg_reg_q(0 TO reg_width-1), NOT cfg_reg_wr);
      cfg_reg_p_d <= ((sc_wparity XOR xor_reduce(sc_wdata(reg_width TO 63))) AND cfg_reg_wr) OR (cfg_reg_p_q and NOT cfg_reg_wr);
  END GENERATE genP_not64;

  cfg_reg_perr   <= cfg_reg_perr_q;
  cfg_reg_perr_d <= xor_reduce(cfg_reg_q) XOR cfg_reg_p_q;

  cfg_reg   <= cfg_reg_q;
  cfg_reg_p <= cfg_reg_p_q;

  
  sc_wr_pulse   <= sc_wr_pulse_q;
  sc_wr_pulse_d <= cfg_reg_wr;



  process (clock_400mhz)
    begin
      if clock_400mhz'EVENT and clock_400mhz = '1' then
        if reset_n='0' then
          cfg_reg_q <= REG_RESET_VALUE;
          cfg_reg_p_q <= xor_reduce(REG_RESET_VALUE);
          sc_wr_pulse_q <= '0';
        else
          if act_cfg = '1' then
            cfg_reg_q <= cfg_reg_d;
            cfg_reg_p_q <= cfg_reg_p_d;
          end if;
          sc_wr_pulse_q <= sc_wr_pulse_d;
        end if;
       cfg_reg_perr_q <= cfg_reg_perr_d;
      end if;
    end process;
            
end ice_cfg_reg;
