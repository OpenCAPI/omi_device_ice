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
use ieee.std_logic_arith.all;

package ice_gmc_func_pkg is

  -- logic.
  function Choice(innode,choice : std_ulogic)                           return std_ulogic_vector;
  function Mux2( s: std_ulogic; x,y : std_ulogic_vector)                return std_ulogic_vector;
  function b2g(a : std_ulogic_vector)                                   return std_ulogic_vector;
  function g2b(a : std_ulogic_vector)                                   return std_ulogic_vector;
  function RRarb( data_in, last_in : std_ulogic_vector)                 return std_ulogic_vector;
  function crAdj(i_crd, inc, dec : std_ulogic_vector)                   return std_ulogic_vector;

  -- reduction
  function gate_and(a: std_ulogic; b : std_ulogic_vector)               return std_ulogic_vector;
  function or_reduce(a_in: std_ulogic_vector)                           return std_ulogic;

  function "-"(l,r : std_ulogic_vector)                                 return std_ulogic_vector;
  function "-"(l : std_ulogic_vector; r : integer)                      return std_ulogic_vector;
  function "-"(l : std_ulogic_vector; r : std_ulogic)                   return std_ulogic_vector;
  function "+"(l,r : std_ulogic_vector)                                 return std_ulogic_vector;
  function "+"(l : std_ulogic_vector; r : integer)                      return std_ulogic_vector;
  function "+"(l : std_ulogic_vector; r : std_ulogic)                   return std_ulogic_vector;
  function "="(l,r : std_ulogic_vector)                                 return std_ulogic;
  function "="(l: std_ulogic_vector; r : integer)                       return boolean;
  function "="(l: std_ulogic_vector; r : integer)                       return std_ulogic;
  function "/="(l: std_ulogic_vector; r : integer)                      return std_ulogic;
  function "/="(l: std_ulogic_vector; r : integer)                      return boolean;

  function "srl"(l : std_ulogic_vector; r: integer)                     return std_ulogic_vector;
  function "rol"(l : std_ulogic_vector; r: integer)                     return std_ulogic_vector;
  function tconv(a : std_ulogic_vector)                                 return natural;
  function tconv(a_in,size : natural)                                   return std_ulogic_vector;
  function tconv(a_in : std_ulogic_vector; base : natural)              return string;
end package;

package body ice_gmc_func_pkg is

  function Log2(A : natural) return natural is
    variable val   : integer;
    variable width : natural;
  begin
    if    (A = 0) then return 0;
    elsif (A = 1) then return 1;
    else val := A-1;
    end if;
    width := 0;
    while val > 0  loop
      val   := val/2;
      width := width + 1;
    end loop;
    return width;
  end;

  function gate_and(a: std_ulogic; b : std_ulogic_vector) return std_ulogic_vector is
    variable z : std_ulogic_vector(b'range);
  begin
    if a='0' then z := (others => '0');
    else z := b;
    end if;
    return z;
  end function;

  function or_reduce(a_in: std_ulogic_vector) return std_ulogic is
  begin
    if unsigned(a_in)=0 then return '0'; else return '1'; end if;
  end function;


  function PadL (a: std_ulogic_vector; len : natural; pad : std_ulogic := '0') return std_ulogic_vector is
    -- pad on the left.  pad(5,"101") = "00101"
    variable z : std_ulogic_vector(len-1 downto 0);
  begin
    z := (others => pad) ;
    z(a'length-1 downto 0) := a;
    return z;
  end function;


  function suv2uns(a : std_ulogic_vector) return unsigned is
  -- don't overload this function.
    variable z : ieee.std_logic_arith.unsigned(a'range);
  begin
    z := ieee.std_logic_arith.unsigned(a);
    return(z);
  end function;

  function "-"(l,r : std_ulogic_vector) return std_ulogic_vector is
    variable z : unsigned(l'range);
  begin
    z := suv2uns(l) - suv2uns(r);
    return std_ulogic_vector(z);
  end;

  function "-"(l : std_ulogic_vector; r : integer) return std_ulogic_vector is
    variable z : unsigned(l'range);
  begin
    z := suv2uns(l) - r;
    return std_ulogic_vector(z);
  end;
  function "-"(l : std_ulogic_vector; r : std_ulogic) return std_ulogic_vector is
    variable z : unsigned(l'range);
  begin
    z := suv2uns(l) - suv2uns("0" & r);
    return std_ulogic_vector(z);
  end;

  function "+"(l,r : std_ulogic_vector) return std_ulogic_vector is
    variable z : unsigned(l'range);
  begin
    z := suv2uns(l) + suv2uns(r);
    return std_ulogic_vector(z);
  end;
  function "+"(l : std_ulogic_vector; r : integer) return std_ulogic_vector is
    variable z : unsigned(l'range);
  begin
    z := suv2uns(l) + r;
    return std_ulogic_vector(z);
  end;
  function "+"(l : std_ulogic_vector; r : std_ulogic) return std_ulogic_vector is
    variable z : unsigned(l'range);
  begin
    z := suv2uns(l) + suv2uns("0" & r);
    return std_ulogic_vector(z);
  end;

  function "="(l,r : std_ulogic_vector) return std_ulogic is
  begin
    if (unsigned(l)=unsigned(r)) then return '1'; else return '0'; end if;
  end;
  function "="(l: std_ulogic_vector; r : integer)  return boolean is
  begin
    return (unsigned(l)=r);
  end;

  function "srl"(l : std_ulogic_vector; r: integer) return std_ulogic_vector is
    variable z : std_ulogic_vector(0 to l'length-1);
  begin
    z := l;
    for i in 0 to r-1 loop
      z := '0' & z(0 to z'right-1);
    end loop;
    return z;
  end;

  function "rol"(l : std_ulogic_vector; r: integer) return std_ulogic_vector is
    variable z : std_ulogic_vector(0 to l'length -1);
  begin
    z := l;
    for i in 0 to r-1 loop
      z := z(1 to z'right) & z(0);
    end loop;
    return z;
  end;


  function "="(l: std_ulogic_vector; r : integer)  return std_ulogic is
  begin
    if (unsigned(l)=r) then return '1';  else return '0'; end if;
  end;

  function "/="(l: std_ulogic_vector; r : integer)  return std_ulogic is
  begin
    return not(l=r);
  end;
  function "/="(l: std_ulogic_vector; r : integer)  return boolean is
  begin
    return not(l=r);
  end;

  function Choice(innode,choice : std_ulogic) return std_ulogic_vector is
    variable z : std_ulogic_vector(0 to 1);
  begin
    z(0) := innode and choice;
    z(1) := innode and not(choice);
    return z;
  end function;

  function Mux2( s: std_ulogic; x,y : std_ulogic_vector) return std_ulogic_vector is
  -- like sel ? x : y
  begin
    if (s='1') then return x; else return y;
    end if;
  end function;


  function b2g(A: std_ulogic_vector) return std_ulogic_vector is
    constant len: positive := A'length;
    alias binval: std_ulogic_vector(0 to len -1) is A;
    variable grayval: std_ulogic_vector(0 to len - 1);
  begin
     grayval(0) := binval(0);
     for i in 1 to len-1 loop
        grayval(i) := binval(i-1) xor binval(i);
     end loop;
     return grayval;
  end function;

  function g2b(A: std_ulogic_vector) return std_ulogic_vector is
    constant len: positive := A'length;
    alias grayval: std_ulogic_vector(0 to len -1) is A;
    variable binval: std_ulogic_vector(0 to len - 1);
  begin
    binval(0) := grayval(0);
     for i in 1 to len-1 loop
        binval(i) := binval(i-1) xor grayval(i);
     end loop;
     return binval;
  end function;

  function RRarb( data_in, last_in : std_ulogic_vector) return std_ulogic_vector is
    variable d,l,z : std_ulogic_vector(0 to data_in'length -1);
    variable x,t   : std_ulogic;  -- minterms
    variable n     : natural;
  begin
    d := data_in;
    l := last_in;
    n := data_in'length;
    for i in 0 to n-1 loop
      x := l(i);                 -- or minterm
      for j in 1 to n-1 loop
        t := l( (n-j+i) mod n );  -- and minterm
        for k in 0 to j-1 loop
          t := t and not d( (n-j+i+k) mod n );
        end loop;
        x := x or t;
      end loop;
      z(i) := d(i) and x;
    end loop;
    return z;
  end function;

  function crAdj(i_crd, inc, dec : std_ulogic_vector) return std_ulogic_vector is
    variable z : std_ulogic_vector(i_crd'length downto 0);
  begin
    z := padL(i_crd,z'length) - padL(dec,z'length);
    z := z + padL(inc,z'length);
    return z(z'left-1 downto 0);
  end function;

  -- conversion functions.

  function tconv(a : std_ulogic_vector) return natural is
    variable z : natural;
  begin
    z := conv_integer(suv2uns(a));
    return z;
  end function;

  function tconv(a_in,size : natural) return std_ulogic_vector is
    variable z : std_ulogic_vector(size-1 downto 0);
    variable a : integer;
    variable undef : boolean;
  begin
    a := a_in;
    z := (others => '0');
    undef := false;
    for i in z'reverse_range loop
      if a mod 2 = 1 then z(i) :='1'; end if;
      a := a/2;
    end loop;
    if (a /= 0) then z := (others => 'X'); undef := true; end if;
    assert not(undef) report "size passed to tconv not big enough" severity error;

    return z;
  end function;


  function tconv(a_in : std_ulogic_vector; base : natural) return string is
  -- for assert report formatting.
    variable a : std_ulogic_vector(1 to a_in'length);
    variable z : string(1 to a_in'length);    -- string must start at 1.
  begin
    a := a_in;
    for i in z'range loop
      if    a(i)='1' then z(i):='1';
      elsif a(i)='0' then z(i):='0';
      elsif a(i)='U' then z(i):='U';
      else                z(i):='X';
      end if;
    end loop;
    return z;
  end function;

end;
