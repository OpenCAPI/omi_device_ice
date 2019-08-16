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
use  work.gemini_tlx_pkg.all;

entity tlx_fifo is
  generic (
     width    : positive range 2 to 1024;
     depth    : positive range 2 to 512
  );
  port (
    clock                          : in std_ulogic;
    reset                          : in std_ulogic;        -- synchronous. clears control bits not the array (maybe xilinx does that anyway ? (don't care really))
    data_in                        : in std_ulogic_vector(width-1 downto 0);
    write                          : in std_ulogic;
    read                           : in std_ulogic;        -- reads next (output is valid in same cycle as read)
    data_out                       : out std_ulogic_vector(width-1 downto 0);
    empty                          : out std_ulogic;
    full                           : out std_ulogic;
    overflow                       : out std_ulogic;
    underflow                      : out std_ulogic
  );
end  tlx_fifo ;

architecture tlx_fifo of tlx_fifo is

    type fifo_type is array(depth downto 1) of std_ulogic_vector(width - 1 downto 0); -- stages numbered depth downto 1

    signal farray      :  fifo_type;                             -- the array
    signal fifo_state  :  std_ulogic_vector(depth downto 1);   -- one "valid" bit per stage, shifting right so stage 0 is the output;

begin

 func: process(clock) is
    begin
      if rising_edge(clock) then

f_gen:   for i in 1 to depth loop       --   for each stage gererate the full bits then do the dataflow/array contents. first and last stages have to be done separately
            if i = 1 then
               fifo_state(i) <=  (fifo_state(i) or (not fifo_state(i+1) and not fifo_state(i) and not read and write)) and
                                 (fifo_state(i+1) or not fifo_state(i) or not read or write)                           and
                                 (not reset);

               farray(i)     <= GATE(farray(i), fifo_state(i) and not read)                                     or
                                GATE(data_in, not fifo_state(i+1) and write and (not (read xor fifo_state(i)))) or
                                GATE(farray(i+1),fifo_state(i+1) and fifo_state(i) and read);

            elsif i = depth then
               fifo_state(i) <=  (fifo_state(i) or (not fifo_state(i) and fifo_state(i-1) and not read and write)) and   -- reset to all invalid - ie fifo is empty
                                 (not fifo_state(i) or not fifo_state(i-1) or not read or write)                   and
                                 (not reset);

               farray(i)     <= GATE(farray(i), fifo_state(i) and fifo_state(i-1) and not read)              or
                                GATE(data_in, fifo_state(i-1) and write and (not (read xor fifo_state(i))));

            else                    --- all the bits that are not first or last
               fifo_state(i) <=  (fifo_state(i) or (not fifo_state(i+1) and not fifo_state(i) and fifo_state(i-1) and not read and write))  and
                                 (fifo_state(i+1) or not fifo_state(i) or not fifo_state(i-1) or not read or write)                         and
                                 (not reset);

               farray(i)     <= GATE(farray(i), fifo_state(i) and fifo_state(i-1) and not read)                                     or
                                GATE(data_in, not fifo_state(i+1) and fifo_state(i-1) and write and (not (read xor fifo_state(i)))) or
                                GATE(farray(i+1),fifo_state(i+1) and fifo_state(i) and fifo_state(i-1) and read);
            end if;

end loop f_gen;
      end if;
 end process func;

              -- form the outputs
    data_out                       <= farray(1);
    empty                          <= not fifo_state(1);
    full                           <= AND_REDUCE(fifo_state);
    overflow                       <= write and not read and fifo_state(depth);
    underflow                      <= read and not fifo_state(1);

end  tlx_fifo;

