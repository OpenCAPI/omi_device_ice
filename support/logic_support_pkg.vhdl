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

library ibm,ieee ;
use ibm.synthesis_support.all ;
use ibm.std_ulogic_support.all ;
use ieee.std_logic_1164.all ;

package logic_support_pkg is


  -------------------------------------------------------------------
  ---         Virtual timing process support functions            ---
  -------------------------------------------------------------------

  function vtiming( s:std_ulogic ) return std_ulogic;
  function vtiming( s:std_ulogic_vector ) return std_ulogic;
  function vtiming( s:std_ulogic; n: natural ) return std_ulogic;
  function vtiming( s:std_ulogic_vector; n: natural ) return std_ulogic;
  function vtiming( n: natural ) return std_ulogic;

  -------------------------------------------------------------------
  ---         Delay_function for timing process                   ---
  -------------------------------------------------------------------

  function delay_element( s:std_ulogic; n:natural ) return std_ulogic;
  function delay_element( s:std_ulogic_vector; n:natural ) return std_ulogic_vector;
  constant delay_element_max: natural := 50;
  constant delay_element_step: natural := 5;

  -------------------------------------------------------------------
  ---         Orthogonality functions for assert statements       ---
  -------------------------------------------------------------------

  function orthogonal( s:std_ulogic_vector ) return boolean;
  function orthogonal_extended( s:std_ulogic_vector ) return boolean;


  ------------------------------------------------------------------------
  --- Additional attributes for eCLipz tools                            --
  ------------------------------------------------------------------------

  ATTRIBUTE generic_port_list: STRING;
                -- Attribute for specifying a list of generics to be
                -- passed as a VIM attribute

  ATTRIBUTE buffer_type: STRING;
                -- Attribute for specifying if repowering is allowed

  -------------------------------------------------------------------
  ---         Type declarations for latch packages                ---
  -------------------------------------------------------------------
  TYPE latch_version is (dynamic, static);
  TYPE scan_type is (normal, interleaved, reversed, reverse_interleaved);

  TYPE block_type_type is (
    -- top types
    chip,
    core,
    unit,
    chiplet,
    mixed,
    -- above the macro misc types
    soft,
    -- macro types
    superrlm,
    analog,
    ary_t,
    custom,
    io,
    regfile,
    rlm,
    custom_10t,
    clock_10t,
    -- below the macro types
    book,
    leaf,
    lcb,
    latch,
    mem_t,
    simonly,
    testonly,
    -- Power Gating below the macro type
    fence_t
    -- to be removed
--    behavior,
--    customrlm,
--    hilevel,
--    latch,
--    lcb,
--    ots,
--    pla,
--    rlmleaf,
--    rom,
--    super
    );
  ATTRIBUTE block_type : block_type_type;
  ATTRIBUTE IS_INSTANTIATED : boolean;
  ATTRIBUTE CLK_ENABLE : string;
  ATTRIBUTE EQUIV_PINCLASS : string;

-- Intended to represent a unit delay for event simulators (NCSIM)
--  CONSTANT GATE_DELAY:TIME := 10 ps;

  -------------------------------------------------------------------
  ---         tconv that allow no conversion                      ---
  -------------------------------------------------------------------

  function tconv( s : std_ulogic       ) return  std_ulogic;
  function tconv( s : std_ulogic_vector) return  std_ulogic_vector;

  attribute type_convert: boolean;
  attribute type_convert of tconv: function is TRUE;

  -------------------------------------------------------------------
  ---         VDD level functions                                 ---
  -------------------------------------------------------------------

  attribute cannotevaluate : boolean;
  attribute functionality  : string;

  function vdd_array return std_ulogic;
  attribute cannotevaluate of vdd_array: function is true;
  attribute functionality  of vdd_array: function is "ARRAY_POWER_SUPPLY";

  function vdd_ios return std_ulogic;
  attribute cannotevaluate of vdd_ios: function is true;
  attribute functionality  of vdd_ios: function is "IO_POWER_SUPPLY";

  function vdd_sb return std_ulogic;
  attribute cannotevaluate of vdd_sb: function is true;
  attribute functionality  of vdd_sb: function is "SB_POWER_SUPPLY";

  type power_supply_level_type is  ('1',
                                    vdd_array_enum,
                                    vdd_ios_enum,
                                    vdd_sb_enum);
  attribute power_supply_level: power_supply_level_type;

  -------------------------------------------------------------------
  ---         Attributes for power                                ---
  -------------------------------------------------------------------

  attribute actual_power_domain       : string;   -- used on instance label
  attribute power_domain              : string;   -- used on entity
  type pin_domain_crossing_type is (vdd2vdx, vdx2vdd, cross_all);
  attribute pin_domain_crossing       : pin_domain_crossing_type; -- used on signal

  attribute pin_default_power_domain  : string;
  attribute pin_default_ground_domain : string;
  attribute pin_power_domain          : string;
  attribute pin_ground_domain         : string;
  attribute power_pin                 : integer;
  attribute ground_pin                : integer;
  attribute virtual_power_pin         : integer;
  attribute virtual_ground_pin        : integer;

  attribute pg_domain                 : string;   -- used on entity
  attribute pg_default_domain         : string;   -- used on entity
  attribute pg_fence_domain           : string;   -- used on entity
  attribute pg_fence_active           : string;   -- used on entity

  -------------------------------------------------------------------
  ---         Attributes for cloned latches                       ---
  ---  Used on entity where cloned latches are used (value "t")   ---
  ---  and on instance label of each latch (string as required)   ---
  -------------------------------------------------------------------

  attribute SynthClonedLatch    : string;

  -------------------------------------------------------------------
  ---         Attributes for Figtree                             ---
  -------------------------------------------------------------------

  attribute figtree_traceback   : string;

  -------------------------------------------------------------------
  ---         Attributes for Lockstep                             ---
  -------------------------------------------------------------------

  attribute clkgatedomain      : string;
  attribute refreshportdomain  : string;
  attribute pwrgatedomain      : string;
  attribute rdportdomain       : string;
  attribute rdlateportdomain   : string;
  attribute wrportdomain       : string;
  attribute wrlateportdomain   : string;
  attribute camportdomain      : string;
  attribute clrportdomain      : string;
  attribute camlateportdomain  : string;
  attribute rdhalfportdomain   : string;
  attribute rdtargethalfportdomain : string;
  attribute wrhalfportdomain   : string;
  attribute rdtargetportdomain   : string;
  attribute datagatedomain   : string;

  -------------------------------------------------------------------
  ---         Attributes for Timing/Async Verification            ---
  -------------------------------------------------------------------
  -- Please coordinate with the Geyzer support team before modifying this type!
  TYPE timing_type_type is (
    normal              , -- normal timed synchronous signal; default case
                          --  (attribute not required)
    async_point2point   , -- asynchronous point-to-point control signal from one latch
                          --  in one clock domain to two metastability-hardened sink
                          --  latches in series in a different clock domain
                          --  (signal may feed back into sending domain)
    async_glitchless    , -- asynchronous control signal which is output from glitch-free
                          --  combinational logic to a single sink latch
    async_gated         , -- asynchronous data signal which is gated when transitioning,
                          --  so that no asynchronous transition reaches receive domain
    async_qualified     , -- asynchronous data signal whose sampling by receive domain
                          --  is qualified by a separate control signal
    async_array         , -- signal from read port of array written by one clock
                          --  domain, to latch clocked by a different clock domain
    async_reset         , -- asynchronous signal that can enable or disable a latch
                          --  (e.g., controls a clock, reset or flush input)
    async_other         , -- signal is asynchronous but does not fall into the
                          --  above categories; this is a "temporary" classification
                          --  until a more appropriate category can be defined.
    untimed             , -- net propagation delay will not be checked (DC net);
                          --  net will be given special phase tag DCDC by Einstimer
    test_only           , -- for nets used only during test, so timed at slower speed, apply GSD phase on this net/pin
    multicycle_x           , -- for nets which do not need to make timing in one cycle, net/pin is handled as multicycle path with cycle target not specified in VHDL
    multicycle_2           , -- for nets which do not need to make timing in one cycle, net/pin is handled as multicycle path with 2 cycle target
    multicycle_4           , -- for nets which do not need to make timing in one cycle, net/pin is handled as multicycle path with 4 cycle target
    multicycle_8           , -- for nets which do not need to make timing in one cycle, net/pin is handled as multicycle path with 8 cycle target
    multicycle_16           , -- for nets which do not need to make timing in one cycle, net/pin is handled as multicycle path with 16 cycle target
    multicycle_2r          , -- for nets which do not need to make timing in one cycle, net/pin is handled as multicycle path with 2 cycle target
    multicycle_4r          , -- for nets which do not need to make timing in one cycle, net/pin is handled as multicycle path with 4 cycle target
    multicycle_8r          , -- for nets which do not need to make timing in one cycle, net/pin is handled as multicycle path with 8 cycle target
    multicycle_16r          , -- for nets which do not need to make timing in one cycle, net/pin is handled as multicycle path with 16 cycle target
    p1to1hold           , -- xto1 thold signal; see design guide chapter 7 for usage requirements
    p2to1hold           ,
    p3to1hold           ,
    p4to1hold           ,
    p5to1hold           ,
    p6to1hold           ,
    p8to1hold           ,
    p2to1ihold          ,
    p4to1ihold
  );

  ATTRIBUTE timing_type : timing_type_type;
	-- Purpose of this attribute is to flag signals which are not normal timed
	-- synchronous signals, so that verification can model the effects these signals
	-- can have on the functional (cycle-by-cycle) operation of the design.

  ATTRIBUTE arctic_phase : string;
	-- Identifies clock phase of a signal; used for async verification and clock
	-- analysis.

  ATTRIBUTE arctic_mode  : string;
	-- Identifies signal which affects propagation of clock phases; used for
	-- async verification and clock analysis.

  ATTRIBUTE async_group  : string;
        -- Assigns a group name to a signal in an asynchronous interface. Intended to group
        -- functionally-related asynchronous signals. All signals in the group will be timed
        -- similarly according to the async_group_defs attribute.
        -- The value of this attribute must be the name of a group defined by the async_group_defs
        -- attribute for an enclosing VHDL entity (at same level or above).

  ATTRIBUTE async_group_defs : string;
        -- Must be assigned to an entity; defines the groups which may appear on async_group
        -- attributes attached to signals within the given entity or below.
        -- Syntax is or will be defined here:
        -- $CTEPATH/tools/simarama/doc/geyzer/index.html -> User Guide -> Attributes

  -------------------------------------------------------------------
  ---         Attributes for geyzer                               ---
  -------------------------------------------------------------------
  -- The following attributes are required by the Geyzer tool, used for async interface
  -- verification. They are documented at:
  -- $CTEPATH/tools/simarama/doc/geyzer/index.html -> User Guide -> Attributes
  --
  ATTRIBUTE geyzer_clock       : string;
  ATTRIBUTE geyzer_clock_defs  : string;
  ATTRIBUTE geyzer_clocks      : string; -- deprecated as of Geyzer 1.12, use geyzer_clock_defs
  ATTRIBUTE geyzer_mode        : string;
  ATTRIBUTE geyzer_mode_assert : string;
  ATTRIBUTE geyzer_mode_defs   : string;
  ATTRIBUTE geyzer_parms       : string;
  ATTRIBUTE geyzer_phase       : string;
  ATTRIBUTE geyzer_phase_default_for_bidis   : string;
  ATTRIBUTE geyzer_phase_default_for_inputs  : string;
  ATTRIBUTE geyzer_phase_default_for_outputs : string;
  ATTRIBUTE geyzer_waive       : string;

  -------------------------------------------------------------------
  ---         Attributes for nse                          ---
  -------------------------------------------------------------------
  ATTRIBUTE NOBUFFER        : string; -- YES: pins that cannot have buffers
        -- on their nets. Must tag both source and sink pins.
  ATTRIBUTE INV_ONLY        : string; -- YES: pins that may only have single
        -- inverters on their nets. Must tag both source and sink pins.
  ATTRIBUTE TRIPLE_INV_ONLY : string; -- YES: pins that may only have triple
        -- inverters on their nets. Must tag both source and sink pins.
  ATTRIBUTE DIFFERENTIAL    : string; -- Complementary pin name: pin is part of
        -- differential pair and must be routed as such.
  ATTRIBUTE CML             : string; -- YES: pin is part of current mode logic
        -- path and should be treated as such.
  ATTRIBUTE LENGTH_MATCH    : string; -- pin name to match length: the net
        -- connected to this pin must have a length that matches the net length
        -- of the indicated pin
  ATTRIBUTE POINT_TO_POINT  : string; -- YES: source pin may only be connected
       --  to a single sink pin (ie. no multidrop)
  ATTRIBUTE SHIELDED        : string; -- SHIELD1, SHELD2: net connected to this
       -- pin must have one or two sides shielded with a shape on the same
       -- layer, space <= 2*minDRC and connected to supply rail.
  ATTRIBUTE ESD_PROTECT     : string; -- YES: net conneted to this pin must be
       -- connected to an EDS diode.
  ATTRIBUTE SCAN_AT_SPEED_LOGIC  : string; -- YES: pin is allowed to be placed
       -- on a scan path to avoid the need for GEchk waivers
  ATTRIBUTE RESISTANCE      : string; -- Resistance (Ohms): maximum resistance
       --  allowed for given net
  ATTRIBUTE SLEW_LIMIT      : string; -- Slew (ps): maximum slew limit allowed
       -- on pin
  ATTRIBUTE INTERNAL_PULLUP_1P5K : string; -- YES: pin is connected to a tristate
       -- with an internal pullup resistor or it is a tristate pin that contains
       -- an internal pullup resistor.

-- Added 7/30/2015 per HW327400
  ATTRIBUTE PIA : string; -- YES, NO, MULTI  phase-independent abstract
       -- identification for macros with more than one clock pin
  ATTRIBUTE THOLD_PNTO1_RATIOS : string; -- string has of {x@y <ratio>} Identifies
       -- minimum thold gear ratio per clock domain - will be identified by spider crawl
       -- or designer
  ATTRIBUTE DO_NOT_ROUTE : string; -- YES indicates that this pin must be igored by
       -- the router
  ATTRIBUTE NOLATCH : string; -- YES indentifies a pin that may not be connected to a latch
  ATTRIBUTE MAX_RESISTANCE      : string; -- Resistance (Ohms): maximum resistance
       --  allowed for given net
  ATTRIBUTE TARGET_RESISTANCE   : string; -- has of {Resistance(ohms), Tolerance(%)}
       --  identifies target resistance of a net within a required tolerance
  attribute ep_block_type : block_type_type;


  -------------------------------------------------------------------
  ---         Attributes for Verity                               ---
  -------------------------------------------------------------------
  ATTRIBUTE OUTPUT_POWER_PIN  : integer;

  -------------------------------------------------------------------
  ---         Attributes for morph                                ---
  -------------------------------------------------------------------
  attribute morph_blackbox : boolean;

end logic_support_pkg ;

library ibm,ieee ;
use ibm.std_ulogic_unsigned.all ;
use ieee.std_logic_1164.all ;

package body logic_support_pkg is

   -- conversion from 2B to Binary

   FUNCTION TB2Bin( Input : std_ulogic_vector ) RETURN std_ulogic_vector IS
      ALIAS    in_val  : std_ulogic_vector(0 TO Input'length-1) IS Input;
      VARIABLE ret_val : std_ulogic_vector(0 TO Input'length/2-1);
   BEGIN
      FOR i IN 0 TO Input'length/4-1 LOOP
         IF in_val(i*4 TO i*4+4-1) = "0001" THEN
            ret_val(i*2 TO i*2+2-1) := "00";
         ELSIF in_val(i*4 TO i*4+4-1) = "0010" THEN
            ret_val(i*2 TO i*2+2-1) := "01";
         ELSIF in_val(i*4 TO i*4+4-1) = "0100" THEN
            ret_val(i*2 TO i*2+2-1) := "10";
         ELSIF in_val(i*4 TO i*4+4-1) = "1000" THEN
            ret_val(i*2 TO i*2+2-1) := "11";
         ELSE
            ret_val(i*2 TO i*2+2-1) := "00";
         END IF;
      END LOOP;
      RETURN ret_val;
   END TB2Bin;


   -- conversion from Binary to 2B
   FUNCTION Bin2TB( Input : std_ulogic_vector ) RETURN std_ulogic_vector IS
      ALIAS    in_val  : std_ulogic_vector(0 TO Input'length-1) IS Input;
      VARIABLE ret_val : std_ulogic_vector(0 TO Input'length*2-1);
   BEGIN
      FOR i IN 0 TO Input'length/2-1 LOOP
         IF in_val(i*2 TO i*2+2-1) = "00" THEN
            ret_val(i*4 TO i*4+4-1) := "0001";
         ELSIF in_val(i*2 TO i*2+2-1) = "01" THEN
            ret_val(i*4 TO i*4+4-1) := "0010";
         ELSIF in_val(i*2 TO i*2+2-1) = "10" THEN
            ret_val(i*4 TO i*4+4-1) := "0100";
         ELSIF in_val(i*2 TO i*2+2-1) = "11" THEN
            ret_val(i*4 TO i*4+4-1) := "1000";
         ELSE
            ret_val(i*4 TO i*4+4-1) := "0000";
         END IF;
      END LOOP;
      RETURN ret_val;
   END Bin2TB;



  -------------------------------------------------------------------
  ---         Virtual timing process support functions            ---
  -------------------------------------------------------------------

  function vtiming( s:std_ulogic ) return std_ulogic is
  begin
    return '0';
  end vtiming;

  function vtiming( s:std_ulogic_vector ) return std_ulogic is
  begin
    return '0';
  end vtiming;

  function vtiming( s:std_ulogic; n: natural ) return std_ulogic is
  begin
    return '0';
  end vtiming;

  function vtiming( s:std_ulogic_vector; n: natural ) return std_ulogic is
  begin
    return '0';
  end vtiming;

  function vtiming( n:natural ) return std_ulogic is
  begin
    return '0';
  end vtiming;

  -------------------------------------------------------------------
  ---         Delay function for timing process                   ---
  -------------------------------------------------------------------

  function delay_element( s:std_ulogic; n:natural ) return std_ulogic is
  begin
    return tconv(delay_element((0 to 0 => s), n));
  end delay_element;

  function delay_element( s:std_ulogic_vector; n:natural ) return std_ulogic_vector is
    function delay_element( s:std_ulogic_vector; n:string ) return std_ulogic_vector;
    function delay_element( s:std_ulogic_vector; n:string ) return std_ulogic_vector is
      function delay_element( s:std_ulogic_vector ) return std_ulogic_vector;
      attribute btr_name of delay_element : function is "cs_delay_element"&n;
      attribute recursive_synthesis of delay_element : function is 0;
      attribute pin_bit_information of delay_element : function is
         (1 => ("   ","a       ","SAME","PIN_BIT_VECTOR"),
          2 => ("   ","y       ","SAME","PIN_BIT_VECTOR"));
      function delay_element( s:std_ulogic_vector) return std_ulogic_vector is
      begin
        return (s);
      end delay_element;
    begin
      return delay_element(s);
    end delay_element;
    variable result : std_ulogic_vector(s'low to s'high);
  begin
    result := s;
    if (n >= delay_element_max) then
      for i in 1 to (n/delay_element_max) loop
        result := delay_element(result, tconv(delay_element_max));
      end loop;
    end if;
    if ((n mod delay_element_max) > 0) then
      result := delay_element(result, tconv(((n mod delay_element_max)/delay_element_step)*delay_element_step));
    end if;
    return result;
  end delay_element;

  ------------------------------------------------------------------------------
  ---    Orthogonality functions to be used in assert statements
  ------------------------------------------------------------------------------

  function orthogonal (s: std_ulogic_vector) RETURN boolean is
  variable result: boolean;
  variable z: std_ulogic_vector(1 to s'length);
  begin
     z := (others => '0');
     result := ((s and (s - "1")) = z)
               and (s /= z);
     return result;
  end orthogonal;

  function orthogonal_extended (s: std_ulogic_vector) RETURN boolean is
  variable result: boolean;
  variable z: std_ulogic_vector(1 to s'length);
  begin
     z := (others => '0');
     result := ((s and (s - "1")) = z);
     return result;
  end orthogonal_extended;


  -------------------------------------------------------------------
  ---         tconv that allow no conversion                      ---
  -------------------------------------------------------------------

  function tconv( s : std_ulogic) return  std_ulogic is
     begin
        return s;
     end tconv;
  function tconv( s : std_ulogic_vector) return  std_ulogic_vector is
     begin
        return s;
     end tconv;


  -------------------------------------------------------------------
  ---         VDD level functions                                 ---
  -------------------------------------------------------------------

  function vdd_array return std_ulogic is
     begin
        return '1';
     end vdd_array;

  function vdd_ios return std_ulogic is
     begin
        return '1';
     end vdd_ios;

  function vdd_sb return std_ulogic is
     begin
        return '1';
     end vdd_sb;

end logic_support_pkg ;
