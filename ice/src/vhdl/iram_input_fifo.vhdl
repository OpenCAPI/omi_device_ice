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

entity iram_input_fifo is
  port (
    clock                          : in std_ulogic;
    reset                          : in std_ulogic;        -- synchronous. clears control bits not the array (maybe xilinx does that anyway ? (don't care really))
    remove_nulls                   : in std_ulogic;
    crc_error                      : in std_ulogic;
    data_in                        : in std_ulogic_vector(518 downto 0);       -- 518 = +data 517:512 metadata 511 downto 0 data/control flit
    write                          : in std_ulogic;
    read                           : in std_ulogic;        -- reads next (output is valid in same cycle as read)
    data_out                       : out std_ulogic_vector(518 downto 0);
    empty                          : out std_ulogic;
    full                           : out std_ulogic;
    overflow                       : out std_ulogic;
    underflow                      : out std_ulogic;
    array_overflow                 : out std_ulogic
  );
end  iram_input_fifo ;

architecture iram_input_fifo of iram_input_fifo is

 signal wptr_d,wptr_q,rptr_d,rptr_q         : std_ulogic_vector (6 downto 0);      -- one too many gives empty-full distinction
 signal bram_out,data_out_int               : std_ulogic_vector (518 downto 0);
 signal bram_valid_d,bram_valid_q           : std_ulogic;
 signal inc_rptr,full_int,empty_int         : std_ulogic;
 signal write_fifo                          : std_ulogic;
 signal overwritable_d,overwritable_q       : std_ulogic;
 signal last_good_wptr_d,last_good_wptr_q   : std_ulogic_vector (6 downto 0);
 signal wptr_plus_one                       : std_ulogic_vector (6 downto 0);
 signal tail_null,empty_c_flit              : std_ulogic;

 signal e_count                             : integer;
 signal d_count                             : integer;
 signal c_count,t_count                     : integer;

 constant unity : std_ulogic_vector     := "0000001"; --  (log2(depth) downto 1 => '0') & '1';
begin

bulk_bram :  component iram_1r1w1ck_64x519
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
      width    => 519,
      depth    => 2
   )
   port map (
     clock       =>  clock,
     reset       =>  reset,
     data_in     =>  bram_out,
     write       =>  write_fifo,
     read        =>  read,
     data_out    =>  data_out_int,
     empty       =>  empty_int,
     full        =>  full_int,
     overflow    =>  overflow,
     underflow   =>  underflow
   );
   data_out <= data_out_int;
                                             -- fifo signals

   write_fifo <= bram_valid_q and not full_int;
   full <= full_int;
   empty <= empty_int;

                                             -- bulk ram signals

   inc_rptr <= '1' when (last_good_wptr_q /= rptr_q ) and ( read or empty_int or (not full_int and not write_fifo)) = '1' else '0';

   rptr_d <= GATE(rptr_q + unity , not reset and     inc_rptr) or
             GATE(rptr_q             , not reset and not inc_rptr);

   bram_valid_d <= '1' when (last_good_wptr_q /= rptr_q ) else '0';    -- bram_valid_q will say when bram output is valid

   wptr_plus_one <= wptr_q + unity;

   last_good_wptr_d <= GATE( wptr_plus_one    , write and not data_in(518) and not empty_c_flit) or
                       GATE( wptr_q           , write and not data_in(518) and     empty_c_flit) or
                       GATE( last_good_wptr_q , not (write and not data_in(518)));

        -- treat control templates with nothing useful in them as empty_flits
   empty_c_flit <= remove_nulls when data_in(7 downto 1) = "0000000" and data_in(119 downto 112) = x"00" and data_in(518) = '0'  and -- no command credit in slot 0 or 4 of control flit
                                  (
                                     (data_in(465 downto 460) = "000000")                                   or   -- template 0
                                     (data_in(231 downto 224) = x"00" and data_in(343 downto 336) = x"00")       -- templates 1 and 4
                                  ) else '0';

   overwritable_d     <=     (write and empty_c_flit ) or                                  -- this means that we did not increment the write pointer after writing a null flit
                             (overwritable_q and not (write or crc_error or tail_null));

   tail_null <=  not write and overwritable_q and empty_int; -- the fifo is empty and the last thing we did was write a null but not advance the pointer

   wptr_d <= GATE(wptr_plus_one, write and (data_in(518) or not empty_c_flit)) or  -- normal case writing data or non-null control
             GATE(wptr_plus_one, tail_null and not crc_error                 ) or
             GATE(last_good_wptr_q, crc_error                                ) or  -- remember we assert we can't have crc error and write in the same cycle
             GATE(wptr_q, not crc_error and not tail_null and not (write and (data_in(518) or not empty_c_flit)));

   array_overflow <= AND_REDUCE( (wptr_q(5 downto 0) xnor rptr_q(5 downto 0)) &  (wptr_q(6) xor rptr_q(6)) & write);
                      -- get into discussion about how the xilinx ip works but -- this is the safest

latches : process(clock)
   begin
     if clock 'event and clock = '1' then
        if reset = '1' then
           last_good_wptr_q <= (others => '0');
           overwritable_q  <= '0';
           wptr_q <= (others => '0');
        else
           last_good_wptr_q <= last_good_wptr_d;
           overwritable_q  <= overwritable_d;

--synopsys translate_off
           assert  (last_good_wptr_q(5 downto 0) <=  wptr_q(5 downto 0)  and last_good_wptr_q(6) = wptr_q(6)) or
                   (last_good_wptr_q(5 downto 0) >=  wptr_q(5 downto 0)  and last_good_wptr_q(6) /= wptr_q(6))
            report "issue 43 - incrementing last_good wptr when null flit written" severity error;
--synopsys translate_on

           wptr_q <= wptr_d;
        end if;
        bram_valid_q <= bram_valid_d and not reset;
        rptr_q <= rptr_d;
     end if;
end process;

-- synopsys translate_off
dbg_counters : process(clock)
  variable tail_count : integer;
  variable control_count : integer;
  variable data_count : integer;
  variable empty_count : integer;
  variable writing_empty,reading_empty : boolean;

   begin
     if clock 'event and clock = '1' then
        if reset = '1' then
           control_count := 0;
           data_count := 0;
           empty_count := 0;
           tail_count := 0;
           e_count  <= 0;
           d_count  <= 0;
           c_count  <= 0;
           t_count  <= 0;
        else
           assert  (last_good_wptr_q(5 downto 0) <=  wptr_q(5 downto 0)  and last_good_wptr_q(6) = wptr_q(6)) or
                   (last_good_wptr_q(5 downto 0) >=  wptr_q(5 downto 0)  and last_good_wptr_q(6) /= wptr_q(6))
            report "issue 43 - incrementing last_good wptr when null flit written" severity error;

            writing_empty :=  data_in(7 downto 1) = "0000000" and data_in(119 downto 112) = x"00" and data_in(518) = '0'  and write = '1' and
                                      (
                                         (data_in(465 downto 460) = "000000")                                   or   -- template 0
                                         (data_in(231 downto 224) = x"00" and data_in(343 downto 336) = x"00")       -- templates 1 and 4
                                      );
            reading_empty :=  data_out_int(7 downto 1) = "0000000" and data_out_int(119 downto 112) = x"00" and data_out_int(518) = '0' and read = '1' and
                                      (
                                         (data_out_int(465 downto 460) = "000000")                              or   -- template 0
                                         (data_out_int(231 downto 224) = x"00" and data_out_int(343 downto 336) = x"00")       -- templates 1 and 4
                                      );

            if tail_null = '1' and not reading_empty then
               tail_count := tail_count + 1;
            elsif tail_null = '0' and reading_empty then
               tail_count := tail_count - 1;
            end if;

            if writing_empty and not reading_empty then
               empty_count := empty_count + 1;
            elsif write = '1' and not writing_empty and overwritable_q = '1' then
               empty_count :=  empty_count - 1;
            end if;

            if (write and data_in(518) and not (read and data_out_int(518))) = '1' then
               data_count := data_count + 1;
            elsif (data_out_int(518) and read and not (write and data_in(518))) = '1' then
               data_count := data_count - 1;
            end if;

            if (write and not data_in(518) and not empty_c_flit) = '1' and ( read = '0' or reading_empty or data_out_int(518) = '1') then
               control_count := control_count + 1;
            elsif read = '1' and not reading_empty and data_out_int(518) = '0' and not (write and not data_in(518) and not empty_c_flit )  = '1' then
               control_count := control_count - 1;
            end if;
        end if;

        e_count <= empty_count;
        d_count <= data_count;
        c_count <= control_count;
        t_count <= tail_count;
     end if;
end process;
-- synopsys translate_on
end architecture;


