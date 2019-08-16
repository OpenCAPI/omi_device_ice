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
 
 
 

library ieee, Work;
Use Ieee.Std_logic_1164.All;
Use Ieee.Numeric_std.All;
Use Ieee.Std_logic_arith.All;
Use Work.Ice_func.All;
use  work.gemini_tlx_pkg.all;

--for all:<component_name> use entity <library>.<entity_name>[(<architecture_name>)]
entity iram_fifo_64x16 is
  port (
    clock                          : in std_ulogic;
    reset                          : in std_ulogic;        -- synchronous. clears control bits not the array (maybe xilinx does that anyway ? (don't care really))
    data_in                        : in std_ulogic_vector(15 downto 0);
    write                          : in std_ulogic;
    read                           : in std_ulogic;        -- reads next (output is valid in same cycle as read)
    data_out                       : out std_ulogic_vector(15 downto 0);
    empty                          : out std_ulogic;
    full                           : out std_ulogic;
    overflow                       : out std_ulogic;
    underflow                      : out std_ulogic
  );
end  iram_fifo_64x16 ;

architecture iram_fifo_64x16 of iram_fifo_64x16 is

 signal wptr_d,wptr_q,rptr_d,rptr_q     : std_ulogic_vector (6 downto 0);      -- one too many gives empty-full distinction
 signal bram_out                        : std_ulogic_vector (15 downto 0);
 signal bram_valid_d,bram_valid_q       : std_ulogic;
 signal inc_rptr,full_int,empty_int     : std_ulogic;
 signal write_fifo                      : std_ulogic;
 constant unity : std_ulogic_vector     := "0000001"; --  (log2(depth) downto 1 => '0') & '1';
begin

bulk_bram :  component iram_1r1w1ck_64x16
    port map (
      clk     => clock,
      ena     => '1',
      enb     => '1',
      wea     => write,
      dia     => data_in,
      addra   => wptr_q(5 downto 0),
      addrb   => rptr_q(5 downto 0),
      dob     => bram_out
    );

streaming_fifo: entity work.tlx_fifo
   generic map (
      width    => 16,
      depth    => 2
   )
   port map (
     clock       =>  clock,
     reset       =>  reset,
     data_in     =>  bram_out,
     write       =>  write_fifo,
     read        =>  read,
     data_out    =>  data_out,
     empty       =>  empty_int,
     full        =>  full_int,
     overflow    =>  open,
     underflow   =>  underflow
   );

   full <= full_int;
   empty <= empty_int;
   overflow <=  AND_REDUCE( (wptr_q(5 downto 0) xnor rptr_q(5 downto 0)) &  (wptr_q(6) xor rptr_q(6)) & write);

   inc_rptr <= '1' when (wptr_q /= rptr_q ) and ( read or empty_int or (not full_int and not write_fifo)) = '1' else '0';

   write_fifo <= bram_valid_q and not full_int;

   bram_valid_d <= '1' when (wptr_q /= rptr_q ) else '0';    -- bram_valid_q will say when bram output is valid

   wptr_d <= GATE(wptr_q + unity, not reset and write) or
             GATE(wptr_q        , not reset and not write);

   rptr_d <= GATE(rptr_q + unity , not reset and     inc_rptr) or
             GATE(rptr_q             , not reset and not inc_rptr);



latches : process(clock)
   begin
     if clock 'event and clock = '1' then
        bram_valid_q <= bram_valid_d and not reset;
        wptr_q <= wptr_d;
        rptr_q <= rptr_d;
     end if;
end process;

end architecture;


