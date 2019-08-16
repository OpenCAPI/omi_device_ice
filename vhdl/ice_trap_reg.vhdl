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

entity ice_trap_reg is
  generic
    (
      --Making config reg width configurable in case you don't want to use a
      --full 8 Bytes
     reg_width                      : natural := 64    --Width of register in bits
      );
  port
    (
      --CLOCKS
      clock_400mhz                          : in std_ulogic;
      reset_n                          : in STD_ULOGIC;  --connect the latch version of syncr


      --STATUS Inputs
      trap_input_bus                 : in std_ulogic_vector(0 to reg_width - 1);

      --This input will cause the trap register value to grab the value on
      --trap_input_bus when asserted.
      trap_update                    : in STD_ULOGIC := '1';
      --clear trap
      trap_clear                     : in std_ulogic := '0';

      --REGISTER OUTPUTS
      trap_reg                       : out std_ulogic_vector(0 to reg_width-1);  --trap register output value
      trap_reg_p                     : out std_ulogic;
      trap_reg_perr                  : out std_ulogic  --internal parity error reporting for this register instantiation
 
      );

end ice_trap_reg;


architecture ice_trap_reg of ice_trap_reg is
  SIGNAL act_trap : std_ulogic;
  SIGNAL trap_reg_p_d : std_ulogic;
  SIGNAL trap_reg_p_q : std_ulogic;
  SIGNAL trap_reg_perr_d : std_ulogic;
  SIGNAL trap_reg_perr_q : std_ulogic;
  SIGNAL trap_reg_d : std_ulogic_vector(0 to reg_width-1);
  SIGNAL trap_reg_q : std_ulogic_vector(0 to reg_width-1);

begin  

  act_trap        <= trap_update OR trap_clear;

  trap_reg_d          <= gate(trap_input_bus,    trap_update AND NOT trap_clear) OR
                         gate(trap_reg_q,    NOT trap_update AND NOT trap_clear);

  trap_reg_p_d        <= (xor_reduce(trap_input_bus) AND trap_update AND NOT trap_clear) OR
                         (trap_reg_p_q AND           NOT trap_update AND NOT trap_clear); 

  trap_reg_perr       <= trap_reg_perr_q;
  trap_reg_perr_d     <= xor_reduce(trap_reg_q) XOR trap_reg_p_q;
  trap_reg            <= trap_reg_q;
  trap_reg_p          <= trap_reg_p_q;



  process (clock_400mhz)
    begin
      if clock_400mhz'EVENT and clock_400mhz = '1' then
        if reset_n='0' then
          trap_reg_q <= (others => '0');
          trap_reg_p_q <= '0';
        else
          if act_trap = '1' then
            trap_reg_q <= trap_reg_d;
            trap_reg_p_q <= trap_reg_p_d;
          end if;
        end if;
       trap_reg_perr_q <= trap_reg_perr_d;
      end if;
    end process;

end ice_trap_reg;
