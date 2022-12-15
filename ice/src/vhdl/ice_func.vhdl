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

package ice_func is
  type shortint is range -2**16+1 to 2**16-1;
  type byte_v is array(natural range <>) of std_ulogic_vector(7 downto 0);
  type res_v is array(natural range <>) of std_ulogic_vector(2 downto 0); --for M7 functions

  procedure ice_term (in0 : in std_ulogic);
  procedure ice_term (in0 : in std_ulogic_vector);
  -- logic.
  function Mux2( s: std_ulogic; x,y : std_ulogic_vector)                return std_ulogic_vector;
  function Mux2( s: std_ulogic; x,y : std_ulogic)                       return std_ulogic;

  -- reduction
  function gate_and(a: std_ulogic; b : std_ulogic_vector)               return std_ulogic_vector;
  function gate(a: std_ulogic_vector; b : std_ulogic)               return std_ulogic_vector;
  function gate_or(a: std_ulogic; b : std_ulogic_vector)                return std_ulogic_vector;
  function and_reduce(a_in: std_ulogic_vector)                          return std_ulogic;
  function or_reduce(a_in: std_ulogic_vector)                           return std_ulogic;
  function xor_reduce(a_in: std_ulogic_vector)                          return std_ulogic;
  function xnor_reduce(a_in: std_ulogic_vector)                         return std_ulogic;

  -- parity
  function EvenParity( data_in :std_ulogic_vector; w: natural :=8)      return std_ulogic_vector;
  function OddParity(  data_in :std_ulogic_vector; w: natural :=8)      return std_ulogic_vector;


  function "*"(l,r : std_ulogic_vector)                                 return std_ulogic_vector;
  function "-"(l,r : std_ulogic_vector)                                 return std_ulogic_vector;
  function "-"(l : std_ulogic_vector; r : integer)                      return std_ulogic_vector;
  function "-"(l : std_ulogic_vector; r : std_ulogic)                   return std_ulogic_vector;
  function "+"(l,r : std_ulogic_vector)                                 return std_ulogic_vector;
  function "+"(l : std_ulogic_vector; r : integer)                      return std_ulogic_vector;
  function "+"(l : std_ulogic_vector; r : std_ulogic)                   return std_ulogic_vector;
--  function "="(l,r : std_ulogic_vector)                                 return boolean;
  function "="(l,r : std_ulogic_vector)                                 return std_ulogic;
  function "/="(l,r : std_ulogic_vector)                                return std_ulogic;
  function "="(l: std_ulogic_vector; r : integer)                       return boolean;
  function "="(l: std_ulogic_vector; r : integer)                       return std_ulogic;
  function "/="(l: std_ulogic_vector; r : integer)                      return std_ulogic;
  function "/="(l: std_ulogic_vector; r : integer)                      return boolean;
  function ">"(l: integer; r : std_ulogic_vector)                       return boolean;
  function ">"(l: std_ulogic_vector; r : integer)                       return boolean;
  function ">"(l,r : std_ulogic_vector)                                 return std_ulogic;
  function ">="(l,r : std_ulogic_vector)                                return std_ulogic;
  function ">="(l: std_ulogic_vector; r : integer)                      return boolean;
  function "<="(l,r : std_ulogic_vector)                                return boolean;
  function "<="(l: std_ulogic_vector; r : integer)                      return boolean;
  function "<="(l: std_ulogic_vector; r : integer)                      return std_ulogic;
  function "<="(l,r : std_ulogic_vector)                                return std_ulogic;
  function "<"(l: std_ulogic_vector; r : integer)                       return std_ulogic;
  function "<"(l,r : std_ulogic_vector)                                 return std_ulogic;
  function "sll"(l : std_ulogic_vector; r: integer)                     return std_ulogic_vector;
  function tconv(a_in : std_ulogic_vector)                              return byte_v;
  function tconv(a : std_ulogic)                                        return natural;
  function tconv(a_in : byte_v)                                         return std_ulogic_vector;
  function tconv(a : std_ulogic_vector)                                 return natural;
  function tconv(a_in,size : natural)                                   return std_ulogic_vector;
  function tconv(a_in : std_ulogic_vector; base : natural)              return string;
  function ONLYONE(d: in std_ulogic_vector) return boolean;
  function ONLYONE(d: in std_ulogic_vector) return std_ulogic;
end package;

package body ice_func is
 -- ************************************************************************
  --  Generic Terminator
  -- ************************************************************************
  procedure ice_term
    (in0 : in std_ulogic)
  is
    variable result : std_ulogic;
    attribute ANALYSIS_NOT_REFERENCED : string;
    attribute ANALYSIS_NOT_REFERENCED of result : variable is "TRUE";
  begin
    result := in0;
  end ice_term;

  procedure ice_term
    (in0 : in std_ulogic_vector)
  is
    variable result : std_ulogic_vector(0 to in0'length-1);
    attribute ANALYSIS_NOT_REFERENCED : string;
    attribute ANALYSIS_NOT_REFERENCED of result : variable is "TRUE";
  begin
    result := in0;
  end ice_term;

 
  function gate_and(a: std_ulogic; b : std_ulogic_vector) return std_ulogic_vector is
    variable z : std_ulogic_vector(b'range);
  begin
    if a='0' then z := (others => '0');
    else z := b;
    end if;
    return z;
  end function;


  function gate(a: std_ulogic_vector; b : std_ulogic) return std_ulogic_vector is
    variable z : std_ulogic_vector(a'range);
  begin
    if b='0' then z := (others => '0');
    else z := a;
    end if;
    return z;
  end function;

  function gate_or(a: std_ulogic; b : std_ulogic_vector) return std_ulogic_vector is
    variable z : std_ulogic_vector(b'range);
  begin
    if a='1' then z := (others => '1');
    else z := b;
    end if;
    return z;
  end function;

  function or_reduce(a_in: std_ulogic_vector) return std_ulogic is
  begin
    if unsigned(a_in)=0 then return '0'; else return '1'; end if;
  end function;

  function and_reduce(a_in: std_ulogic_vector) return std_ulogic is
  begin
    if unsigned(not(a_in))=0 then return '1'; else return '0';  end if;
  end function;

  function xor_reduce(a_in: std_ulogic_vector) return std_ulogic is
    constant alen : natural := a_in'length;
    variable a : std_ulogic_vector(0 to a_in'length-1);
    variable z : std_ulogic;
  begin
    a := a_in;
    if    alen=0 then z := '0';
    elsif alen=1 then z := a(0);
    elsif alen=2 then z := a(0) xor a(1);
    else z := xor_reduce(a(0 to alen/2-1)) xor xor_reduce(a(alen/2 to alen-1));
    end if;
    return z;
  end function;
  function xnor_reduce(a_in: std_ulogic_vector) return std_ulogic is
  begin
    return not(xor_reduce(a_in));
  end function;

  function suv2uns(a : std_ulogic_vector) return unsigned is
  -- don't overload this function.
    variable z : ieee.std_logic_arith.unsigned(a'range);
  begin
    z := ieee.std_logic_arith.unsigned(a);
    return(z);
  end function;


  function "*"(l,r : std_ulogic_vector) return std_ulogic_vector is
    variable z : unsigned(l'length+r'length-1 downto 0);
  begin
    z := suv2uns(l) * suv2uns(r);
    return std_ulogic_vector(z);
  end;

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


 -- function "="(l,r : std_ulogic_vector) return boolean is
--  begin
--    return (unsigned(l)=unsigned(r));
--  end;
  function "="(l,r : std_ulogic_vector) return std_ulogic is
  begin
    if (unsigned(l)=unsigned(r)) then return '1'; else return '0'; end if;
  end;
  function "/="(l,r : std_ulogic_vector) return std_ulogic is
  begin
    return not(l=r);
  end;
  function "="(l: std_ulogic_vector; r : integer)  return boolean is
  begin
    return (unsigned(l)=r);
  end;
  function ">"(l: integer; r : std_ulogic_vector)  return boolean is
  begin
    return (l>unsigned(r));
  end;
  function ">"(l: std_ulogic_vector; r : integer)  return boolean is
  begin
    return (unsigned(l)>r);
  end;
  function ">="(l: std_ulogic_vector; r : integer)  return boolean is
  begin
    return (unsigned(l)>=r);
  end;
  function "<="(l: std_ulogic_vector; r : integer)  return boolean is
  begin
    return (unsigned(l)<=r);
  end;
  function "<="(l: std_ulogic_vector; r : integer)  return std_ulogic is
  begin
    if (unsigned(l)<=r) then return '1'; else return '0'; end if;
  end;
  function "<="(l,r : std_ulogic_vector)  return boolean is
  begin
    return (unsigned(l)<=unsigned(r));
  end;
  function "<="(l,r : std_ulogic_vector)  return std_ulogic is
  begin
    if (unsigned(l)<=unsigned(r)) then return '1'; else return '0'; end if;
  end;
  function "<"(l,r : std_ulogic_vector)  return std_ulogic is
  begin
    if (unsigned(l)<unsigned(r)) then return '1'; else return '0'; end if;
  end;
  function "<"(l: std_ulogic_vector; r : integer)  return std_ulogic is
  begin
    if (unsigned(l)<r) then return '1'; else return '0'; end if;
  end;
  function ">"(l,r : std_ulogic_vector) return std_ulogic is
  begin
    if (unsigned(l)>unsigned(r)) then return '1'; else return '0'; end if;
  end;
  function ">="(l,r : std_ulogic_vector) return std_ulogic is
  begin
    if (unsigned(l)>=unsigned(r)) then return '1'; else return '0'; end if;
  end;

  function "sll"(l : std_ulogic_vector; r: integer) return std_ulogic_vector is
    variable z : unsigned(l'range);
  begin
    z := shl(suv2uns(l),conv_unsigned(r,256));
    return std_ulogic_vector(z);
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



  function Mux2( s: std_ulogic; x,y : std_ulogic_vector) return std_ulogic_vector is
  -- like sel ? x : y
  begin
    if (s='1') then return x; else return y;
    end if;
  end function;
  function Mux2( s: std_ulogic; x,y : std_ulogic) return std_ulogic is
  -- like sel ? x : y
  begin
    if (s='1') then return x; else return y;
    end if;
  end function;

  --- Byte Parity ---
  function EvenParity( data_in :std_ulogic_vector; w: natural:=8) return std_ulogic_vector is
    variable data : std_ulogic_vector(((data_in'length-1)/w+1)*w -1 downto 0);
    variable z    : std_ulogic_vector(( data_in'length-1)/w  downto 0      );
  begin
    data := (others => '0');
    data(data_in'length-1 downto 0)  := data_in;  -- normalize to right'=0, and even multiple of w.
    for i in 0 to data'length/w -1 loop
      z(i) := xor_reduce(data(w*(i+1)-1 downto w*i));
    end loop;
    return z;
  end function;

  function OddParity( data_in :std_ulogic_vector; w: natural:=8) return std_ulogic_vector is
    variable z : std_ulogic_vector(( data_in'length-1)/w  downto 0      );
  begin
    z := not EvenParity(data_in, w);
    return z;
  end function;



  -- conversion functions.

  function tconv(a : std_ulogic_vector) return natural is
    variable z : natural;
  begin
    z := conv_integer(suv2uns(a));
    return z;
  end function;
  function tconv(a : std_ulogic) return natural is
    variable z : natural;
  begin
    z := conv_integer(suv2uns('0' & a));
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

  function tconv(a_in : byte_v) return std_ulogic_vector is
    variable a : byte_v(0 to a_in'length-1);
    variable z : std_ulogic_vector(0 to 8*a_in'length -1);
  begin
    a := a_in;
    for i in a'range loop
      z(8*i to 8*i+7) := a(i);
    end loop;
    return z;
  end function;

  function tconv(a_in : std_ulogic_vector) return byte_v is
    variable a : std_ulogic_vector(0 to a_in'length -1);
    variable z : byte_v(0 to a_in'length/8-1);
  begin
    assert 8*z'length = a_in'length report "tconv requires 8n bits " severity error;
    a := a_in;
    for i in z'range loop
      z(i) := a(8*i to 8*i+7);
    end loop;
    return z;
  end function;


  function tconv(a_in : std_ulogic_vector; base : natural) return string is
  -- for assert report formatting.
    variable a : std_ulogic_vector(1 to a_in'length);
    variable z : string(1 to a_in'length);    -- string must start at 1.
  begin
    a := a_in;
   -- assert false report "in function" severity error;
    for i in z'range loop
      if    a(i)='1' then z(i):='1';
      elsif a(i)='0' then z(i):='0';
      elsif a(i)='U' then z(i):='U';
      else                z(i):='X';
      end if;
    end loop;
    return z;
  end function;

  function ONLYONE(d: in std_ulogic_vector) return boolean is
    variable result : boolean;
    variable result_vec: std_ulogic_vector(0 to d'length-1);
    variable data: std_ulogic_vector(0 to d'length-1);
    variable data_vec: std_ulogic_vector(0 to (d'length * d'length)-1);
  begin
    -- normalize data vector to index start on 0
    data := d;
    result:=false;

    -- create the vector of data pattern with one bit inverted per iteration
    for i in 0 to d'length-1 loop
      for j in 0 to d'length-1 loop
        if i=j
          then
            data_vec((i*d'length)+j) := not(data(j));
          else
            data_vec((i*d'length)+j) := data(j);
        end if;
      end loop;
    end loop;

    -- see if any data pattern is all zero
    for k in 0 to d'length-1 loop
      result_vec(k) := not(or_reduce(data_vec((k*d'length) to ((k*d'length)+d'length-1))));
    end loop;

    if (or_reduce(result_vec(0 to d'length-1)) = '1')
      then
        result := true;
    end if;

    return result;
  end ONLYONE;

  function ONLYONE(d: in std_ulogic_vector) return std_ulogic is
    variable result : std_ulogic;
    variable result_vec: std_ulogic_vector(0 to d'length-1);
    variable data: std_ulogic_vector(0 to d'length-1);
    variable data_vec: std_ulogic_vector(0 to (d'length * d'length)-1);
  begin
    -- normalize data vector to index start on 0
    data := d;

    -- create the vector of data pattern with one bit inverted per iteration
    for i in 0 to d'length-1 loop
      for j in 0 to d'length-1 loop
        if i=j
          then
            data_vec((i*d'length)+j) := not(data(j));
          else
            data_vec((i*d'length)+j) := data(j);
        end if;
      end loop;
    end loop;

    -- see if any data pattern is all zero
    for k in 0 to d'length-1 loop
      result_vec(k) := not(or_reduce(data_vec((k*d'length) to ((k*d'length)+d'length-1))));
    end loop;

    result := or_reduce(result_vec(0 to d'length-1));

    return result;
  end ONLYONE;

end;


