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
LIBRARY work;
USE work.ice_func.ALL;

ENTITY ice_afu_cmd_fifo IS
  GENERIC (
    width : NATURAL := 64;
    depth : NATURAL := 16);
  PORT (
    clock                : IN  STD_ULOGIC;  --pulse
    reset_n              : IN  STD_ULOGIC;  --pulse
    cmd_fifo_wr          : IN  STD_ULOGIC;
    cmd_fifo_dat_in      : IN  STD_ULOGIC_VECTOR(0 TO width - 1);
    cmd_fifo_full        : out STD_ULOGIC;
    cmd_fifo_rd          : IN  STD_ULOGIC;  -- pulse; 
    cmd_fifo_dat_out     : OUT STD_ULOGIC_VECTOR(0 TO width - 1);
    cmd_fifo_dat_out_val : OUT STD_ULOGIC;
    cmd_fifo_err         : OUT STD_ULOGIC_VECTOR(0 TO 1)
    );
END ENTITY;

ARCHITECTURE ice_afu_cmd_fifo OF ice_afu_cmd_fifo IS

  TYPE mem IS ARRAY(NATURAL RANGE<>) OF STD_ULOGIC_VECTOR(0 TO width+2-1);

  SIGNAL wr               : STD_ULOGIC;
  SIGNAL rd               : STD_ULOGIC;
  SIGNAL din              : STD_ULOGIC_VECTOR(0 TO width - 1);
  SIGNAL dout             : STD_ULOGIC_VECTOR(0 TO width - 1);
  SIGNAL full             : STD_ULOGIC;
  SIGNAL empty            : STD_ULOGIC;
  SIGNAL valid_perr       : STD_ULOGIC;
  SIGNAL overflow_e       : STD_ULOGIC;
  SIGNAL underflow_e      : STD_ULOGIC;
  SIGNAL entry_valid      : STD_ULOGIC_VECTOR(0 TO depth - 1);
  SIGNAL next_entry       : STD_ULOGIC_VECTOR(0 TO depth - 1);
  SIGNAL next_entry_shift : STD_ULOGIC_VECTOR(0 TO depth - 1);
  SIGNAL wr_vec           : STD_ULOGIC_VECTOR(0 TO depth - 1);
  SIGNAL hold_vec         : STD_ULOGIC_VECTOR(0 TO depth - 1);
  SIGNAL shift_entry      : STD_ULOGIC_VECTOR(0 TO depth - 1);
  SIGNAL entry_shift      : mem(0 TO depth-1);
  SIGNAL entry_d          : mem(0 TO depth-1);
  SIGNAL entry_q          : mem(0 TO depth-1);
  signal cmd_fifo_err_d   : STD_ULOGIC_VECTOR(0 TO 1);
  signal cmd_fifo_err_q   : STD_ULOGIC_VECTOR(0 TO 1);
BEGIN

  
  wr <= cmd_fifo_wr;
  rd <= cmd_fifo_rd;

  din(0 TO width -1) <= cmd_fifo_dat_in(0 TO width - 1);


  cmd_fifo_dat_out_val             <= entry_q(0)(width) AND entry_q(0)(width+1);
  cmd_fifo_full                    <= full;
  cmd_fifo_dat_out(0 TO width - 1) <= dout(0 TO width - 1);  


  next_entry(0 TO depth - 1)       <= NOT entry_valid(0 TO depth - 1) AND ('1' & entry_valid(0 TO depth - 2));  
  next_entry_shift(0 TO depth - 1) <= next_entry(1 TO depth - 1) & '0';
  wr_vec(0 TO depth - 1)           <= gate(next_entry(0 TO depth - 1), wr AND NOT rd) OR
                                      gate(next_entry_shift(0 TO depth - 1), wr AND rd);
  shift_loop : FOR i IN 0 TO depth - 2 GENERATE
    entry_shift(i)(0 TO width + 2 - 1) <= entry_q(i+1)(0 TO width + 2 - 1);
  END GENERATE shift_loop;
  entry_shift(depth-1)(0 TO width + 2 - 1) <= (OTHERS => '0');

  main_loop : FOR i IN 0 TO depth - 1 GENERATE
    entry_valid(i)  <= entry_q(i)(width);
    entry_d(i)(0 TO width-1)               <= gate(entry_q(i)(0 TO width-1), hold_vec(i)) OR gate(din(0 TO width - 1), wr_vec(i)) OR gate(entry_shift(i)(0 TO width -1), shift_entry(i));
    --need to clear valid bits during reset
    entry_d(i)(width TO width+2 - 1)       <= gate(entry_q(i)(width TO width+2-1), hold_vec(i)) OR gate("11", wr_vec(i) AND reset_n) OR gate(entry_shift(i)(width TO width+2-1), shift_entry(i) AND reset_n);
  END GENERATE main_loop;

  shift_entry(0 TO depth - 1) <= gate(entry_valid(0 TO depth - 1), rd);

  hold_vec(0 TO depth - 1) <= NOT (wr_vec(0 TO depth - 1) OR shift_entry(0 TO depth -1)) AND (0 TO depth - 1 => reset_n);  --out of reset

  dout(0 TO width - 1) <= entry_q(0)(0 TO width - 1);
  empty                <= NOT entry_q(0)(width);
  full                 <= entry_q(depth-1)(width);
  valid_perr           <= entry_q(0)(width) XOR entry_q(0)(width+1);
  -- Bit 0: FIFO overflow
  -- Bit 1: FIFO underflow
  -- overload bit0 and bit 1 for valid parity error
  overflow_e           <= (wr AND full) OR valid_perr;
  underflow_e          <= (rd AND empty) OR valid_perr;

  cmd_fifo_err_d        <= overflow_e & underflow_e;
  cmd_fifo_err          <= cmd_fifo_err_q;

  latch : PROCESS
  BEGIN
    WAIT UNTIL clock'event AND clock = '1';
      entry_q <= entry_d;
      cmd_fifo_err_q <= cmd_fifo_err_d;
  END PROCESS;

END ARCHITECTURE;
