--
-- Copyright 2019 International Business Machines
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- The patent license granted to you in Section 3 of the License, as applied
-- to the "Work," hereby includes implementations of the Work in physical form.
--
-- Unless required by applicable law or agreed to in writing, the reference design
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- The background Specification upon which this is based is managed by and available from
-- the OpenCAPI Consortium.  More information can be found at https://opencapi.org.
--

library ieee, ibm;
use ieee.std_logic_1164.all;
use ibm.synthesis_support.all;

package std_ulogic_unsigned is

  function "+" (l : std_ulogic_vector; r: std_ulogic_vector) return std_ulogic_vector;
  function "+" (l : std_ulogic_vector; r: integer)          return std_ulogic_vector;
  function "+" (l : integer;          r: std_ulogic_vector) return std_ulogic_vector;
  function "+" (l : std_ulogic_vector; r: std_ulogic)        return std_ulogic_vector;
  function "+" (l : std_ulogic;        r: std_ulogic_vector) return std_ulogic_vector;

  function "-" (l : std_ulogic_vector; r: std_ulogic_vector) return std_ulogic_vector;
  function "-" (l : std_ulogic_vector; r: integer)          return std_ulogic_vector;
  function "-" (l : integer;          r: std_ulogic_vector) return std_ulogic_vector;
  function "-" (l : std_ulogic_vector; r: std_ulogic)        return std_ulogic_vector;
  function "-" (l : std_ulogic;        r: std_ulogic_vector) return std_ulogic_vector;

  function "+" (l : std_ulogic_vector)                      return std_ulogic_vector;
  function "*" (l : std_ulogic_vector; r: std_ulogic_vector) return std_ulogic_vector;

  function "=" ( l : natural;          r : std_ulogic_vector) return boolean;
  function "/="( l : natural;          r : std_ulogic_vector) return boolean;
  function "<" ( l : natural;          r : std_ulogic_vector) return boolean;
  function "<="( l : natural;          r : std_ulogic_vector) return boolean;
  function ">" ( l : natural;          r : std_ulogic_vector) return boolean;
  function ">="( l : natural;          r : std_ulogic_vector) return boolean;

  function "=" ( l : std_ulogic_vector; r : natural)          return boolean;
  function "/="( l : std_ulogic_vector; r : natural)          return boolean;
  function "<" ( l : std_ulogic_vector; r : natural)          return boolean;
  function "<="( l : std_ulogic_vector; r : natural)          return boolean;
  function ">" ( l : std_ulogic_vector; r : natural)          return boolean;
  function ">="( l : std_ulogic_vector; r : natural)          return boolean;
  
  function "=" ( l : natural;          r : std_ulogic_vector) return std_ulogic;
  function "/="( l : natural;          r : std_ulogic_vector) return std_ulogic;
  function "<" ( l : natural;          r : std_ulogic_vector) return std_ulogic;
  function "<="( l : natural;          r : std_ulogic_vector) return std_ulogic;
  function ">" ( l : natural;          r : std_ulogic_vector) return std_ulogic;
  function ">="( l : natural;          r : std_ulogic_vector) return std_ulogic;

  function "=" ( l : std_ulogic_vector; r : natural)          return std_ulogic;
  function "/="( l : std_ulogic_vector; r : natural)          return std_ulogic;
  function "<" ( l : std_ulogic_vector; r : natural)          return std_ulogic;
  function "<="( l : std_ulogic_vector; r : natural)          return std_ulogic;
  function ">" ( l : std_ulogic_vector; r : natural)          return std_ulogic;
  function ">="( l : std_ulogic_vector; r : natural)          return std_ulogic;

  function to_integer( d : std_ulogic_vector ) return natural;
  attribute type_convert        of to_integer : function is true;
  attribute btr_name            of to_integer : function is "PASS";
  attribute pin_bit_information of to_integer : function is
           (1 => ("   ","A0      ","INCR","PIN_BIT_SCALAR"),
            2 => ("   ","10      ","INCR","PIN_BIT_SCALAR"));
  
  function to_std_ulogic_vector( d : natural; w : positive ) return std_ulogic_vector;
  attribute type_convert        of to_std_ulogic_vector : function is true;
  attribute btr_name            of to_std_ulogic_vector : function is "PASS";
  attribute pin_bit_information of to_std_ulogic_vector : function is
           (1 => ("   ","A0      ","INCR","PIN_BIT_SCALAR"),
            2 => ("   ","10      ","INCR","PIN_BIT_SCALAR"));
  
end std_ulogic_unsigned;

library ieee, ibm;
use ieee.numeric_std.all;
use ibm.std_ulogic_support.all;

package body std_ulogic_unsigned is

  function maximum(l, r: integer) return integer is
  begin
    if l > r then
      return l;
    else
      return r;
    end if;
  end;

  function "+"(l: std_ulogic_vector; r: std_ulogic_vector) return std_ulogic_vector is
    constant length : integer := maximum(l'length, r'length);
    variable result : unsigned(length-1 downto 0);
  begin
    result  := unsigned(l) + unsigned(r);
    return   std_ulogic_vector(result);
  end;

  function "+"(l: std_ulogic_vector; r: integer) return std_ulogic_vector is
    variable result  : std_ulogic_vector (l'range);
  begin
    result := std_ulogic_vector( unsigned(l) + r );
    return  result ;
  end;

  function "+"(l: integer; r: std_ulogic_vector) return std_ulogic_vector is
    variable result  : std_ulogic_vector (r'range);
  begin
    result := std_ulogic_vector( l + unsigned(r) );
    return  result;
  end;

  function "+"(l: std_ulogic_vector; r: std_ulogic) return std_ulogic_vector is
    variable result  : std_ulogic_vector (l'range);
  begin
    if r = '1' then
      result := std_ulogic_vector( unsigned(l) + 1 );
    else
      result := l;
    end if; 
    return result ;
  end;

  function "+"(l: std_ulogic; r: std_ulogic_vector) return std_ulogic_vector is
    variable result  : std_ulogic_vector (r'range);
  begin
    if l = '1' then
      result := std_ulogic_vector( unsigned(r) + 1 );
    else
      result := r;
    end if; 
    return result ;
  end;

  function "-"(l: std_ulogic_vector; r: std_ulogic_vector) return std_ulogic_vector is
    constant length: integer := maximum(l'length, r'length);
    variable result  : std_ulogic_vector (length-1 downto 0);
  begin
    result := std_ulogic_vector( unsigned(l) - unsigned(r) );
    return  result ;
  end;

  function "-"(l: std_ulogic_vector; r: integer) return std_ulogic_vector is
    variable result  : std_ulogic_vector (l'range);
  begin
    result  := std_ulogic_vector( unsigned(l) - r );
    return  result ;
  end;

  function "-"(l: integer; r: std_ulogic_vector) return std_ulogic_vector is
    variable result  : std_ulogic_vector (r'range);
  begin
    result  := std_ulogic_vector( l - unsigned(r) );
    return   result ;
  end;

  function "-"(l: std_ulogic_vector; r: std_ulogic) return std_ulogic_vector is
    variable result  : std_ulogic_vector (l'range);
  begin
    if r = '1' then
      result  := std_ulogic_vector( unsigned(l) - 1 );
    else
      result  := l;
    end if;
    return  result ;
  end;

  function "-"(l: std_ulogic; r: std_ulogic_vector) return std_ulogic_vector is
    variable result  : std_ulogic_vector (r'range);
  begin
    if l = '1' then
      result  := std_ulogic_vector( 1 - unsigned(r) );
    else
      result  := std_ulogic_vector( 0 - unsigned(r) );
    end if;
    return  result ;
  end;

  function "+"(l: std_ulogic_vector) return std_ulogic_vector is
    variable result  : std_ulogic_vector (l'range);
  begin
    result := l;
    return result ;
  end;

  function "*"(l: std_ulogic_vector; r: std_ulogic_vector) return std_ulogic_vector is
    constant length: integer := maximum(l'length, r'length);
    variable result  : std_ulogic_vector ((l'length+r'length-1) downto 0);
  begin
    result := std_ulogic_vector( unsigned(l) * unsigned(r) );
    return result ;
  end;

  function "=" ( l : natural;          r : std_ulogic_vector) return boolean is
  begin
    return l = unsigned(r);
  end "=";
  
  function "/="( l : natural;          r : std_ulogic_vector) return boolean is
  begin
    return l /= unsigned(r);
  end "/=";
  
  function "<" ( l : natural;          r : std_ulogic_vector) return boolean is
  begin
    return l < unsigned(r);
  end "<";
  
  function "<="( l : natural;          r : std_ulogic_vector) return boolean is
  begin
    return l <= unsigned(r);
  end "<=";
  
  function ">" ( l : natural;          r : std_ulogic_vector) return boolean is
  begin
    return l > unsigned(r);
  end ">";
  
  function ">="( l : natural;          r : std_ulogic_vector) return boolean is
  begin
    return l >= unsigned(r);
  end ">=";
  
  function "=" ( l : std_ulogic_vector; r : natural)          return boolean is
  begin
    return unsigned(l) = r;
  end "=";
  
  function "/="( l : std_ulogic_vector; r : natural)          return boolean is
  begin
    return unsigned(l) /= r;
  end "/=";
  
  function "<" ( l : std_ulogic_vector; r : natural)          return boolean is
  begin
    return unsigned(l) < r;
  end "<";
  
  function "<="( l : std_ulogic_vector; r : natural)          return boolean is
  begin
    return unsigned(l) <= r;
  end "<=";
  
  function ">" ( l : std_ulogic_vector; r : natural)          return boolean is
  begin
    return unsigned(l) > r;
  end ">";
  
  function ">="( l : std_ulogic_vector; r : natural)          return boolean is
  begin
    return unsigned(l) >= r;
  end ">=";
  
  function "=" ( l : natural;          r : std_ulogic_vector) return std_ulogic is
  begin
    return tconv( l = unsigned(r) );
  end "=";
  
  function "/="( l : natural;          r : std_ulogic_vector) return std_ulogic is
  begin
    return tconv( l /= unsigned(r) );
  end "/=";
  
  function "<" ( l : natural;          r : std_ulogic_vector) return std_ulogic is
  begin
    return tconv( l < unsigned(r) );
  end "<";
  
  function "<="( l : natural;          r : std_ulogic_vector) return std_ulogic is
  begin
    return tconv( l <= unsigned(r) );
  end "<=";
  
  function ">" ( l : natural;          r : std_ulogic_vector) return std_ulogic is
  begin
    return tconv( l > unsigned(r) );
  end ">";
  
  function ">="( l : natural;          r : std_ulogic_vector) return std_ulogic is
  begin
    return tconv( l >= unsigned(r) );
  end ">=";
  
  function "=" ( l : std_ulogic_vector; r : natural)          return std_ulogic is
  begin
    return tconv( unsigned(l) = r );
  end "=";
  
  function "/="( l : std_ulogic_vector; r : natural)          return std_ulogic is
  begin
    return tconv( unsigned(l) /= r );
  end "/=";
  
  function "<" ( l : std_ulogic_vector; r : natural)          return std_ulogic is
  begin
    return tconv( unsigned(l) < r );
  end "<";
  
  function "<="( l : std_ulogic_vector; r : natural)          return std_ulogic is
  begin
    return tconv( unsigned(l) <= r );
  end "<=";
  
  function ">" ( l : std_ulogic_vector; r : natural)          return std_ulogic is
  begin
    return tconv( unsigned(l) > r );
  end ">";
  
  function ">="( l : std_ulogic_vector; r : natural)          return std_ulogic is
  begin
    return tconv( unsigned(l) >= r );
  end ">=";
  
  function to_integer( d : std_ulogic_vector ) return natural is
  begin
    return tconv( d );
  end to_integer;
  
  function to_std_ulogic_vector( d : natural; w : positive ) return std_ulogic_vector is
  begin
    return tconv( d, w );
  end to_std_ulogic_vector;
  
end std_ulogic_unsigned;
