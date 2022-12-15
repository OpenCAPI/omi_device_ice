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

package SYNTHESIS_SUPPORT is

   type SYNTHESIS_VALUES is ('0',   -- logic 0
                             '1',   -- logic 1
                             '-',   -- logic disconnect, only allowed
                                    --   with "=" operator
                             'Z',   -- connect to tristate HIGH
                             'z',   --
                             'H',   -- connect to passive pullup
                             'h',   --
                             'L',   -- connect to passive pulldown
                             'l',   --
                             'W',   -- connect to weak non-driving OC/ECL net
                             'w',   --
                             'E',   -- connect to ERROR net
                             'e');  --

   type ENUMERATION_TRANSLATION is array
         (POSITIVE range<>, POSITIVE range <>) of SYNTHESIS_VALUES;

   type state_enumeration_values IS ('0',   -- logic 0
                                     '1',   -- logic 1
                                     '-');  -- logic dont care reserved for
                                            -- future use

   type state_enumeration_translation IS ARRAY
        (POSITIVE RANGE<>, POSITIVE RANGE <>) OF state_enumeration_values;

             -- defines an encoding for the enumerated type
             -- which defines the allowed values of signal or port
   attribute ENUMERATION_SYNTHESIS : ENUMERATION_TRANSLATION;
             -- defines an encoding for the enumerated type
             -- which defines the states of the state_register
             -- variable.
   attribute ENUM_ENCODING         : STATE_ENUMERATION_TRANSLATION;

   --
   -- Character array range constraints
   --
   subtype LIMIT7  is POSITIVE range 1 to 7;
   subtype LIMIT8  is POSITIVE range 1 to 8;
   subtype LIMIT10 is POSITIVE range 1 to 10;

   --
   -- Set of valid characters for synthesis attributes
   --
   type SYN_CHARACTER is
     ('a','b','c','d','e','f','g','h','i','j','k','l','m',
      'n','o','p','q','r','s','t','u','v','w','x','y','z',
      'A','B','C','D','E','F','G','H','I','J','K','L','M',
      'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
      '0','1','2','3','4','5','6','7','8','9',' ','_',
      '/','\','#','@','$','=','-','+','*','<','>');

   type SYN_CHARACTERS is array (POSITIVE range <>) of SYN_CHARACTER;

   --
   -- Set of numbers:
   --
   subtype SYN_NUMBER is SYN_CHARACTER range '0' to '9';
   type SYN_NUMBERS is array (POSITIVE range <>) of SYN_NUMBER;

   --
   -- Set of alphanumerics:
   --
   subtype SYN_ALPHANUMERIC is SYN_CHARACTER range 'a' to '9';
   type SYN_ALPHANUMERICS is array (POSITIVE range <>) of SYN_ALPHANUMERIC;

   --
   -- Set of alphanumerics with a space included:
   --
   subtype SYN_ALPHANUMERIC_W_SPACE is SYN_CHARACTER range 'a' to '_';
   type SYN_ALPHANUMERICS_W_SPACE is array (POSITIVE range <>) of
                                                 SYN_ALPHANUMERIC_W_SPACE;
   --
   -- Set of upper and lower case letters:
   --
   subtype SYN_LETTER is SYN_CHARACTER range 'a' to 'Z';
   type SYN_LETTERS is array (POSITIVE range <>) of SYN_LETTER;

   type PN_STRING  is array (LIMIT7  range <>) of CHARACTER;
   type CPN_STRING is array (LIMIT10 range <>) of CHARACTER;


   type MULTI_BLOCK_PIN_INFO is
     record
       BLOCK_PORTION : SYN_ALPHANUMERICS_W_SPACE(1 to 3);
       PIN_START     : STRING(1 to 8);
       PIN_START_MODE: STRING(1 to 4);
       PIN_BIT_MODE  : STRING(1 to 14);
     end record;

   type PIN_INTERFACE_LIST is array (POSITIVE range <>) of
                                              MULTI_BLOCK_PIN_INFO;
   type PINS_BIT_ARRAY is array (POSITIVE range <>, POSITIVE range <>) of
             STRING(1 to 8);

   type TYPE_CONV is (STRAIGHT_THRU, PAD_WITH_ZEROS, PAD_WITH_ONES);

   -- The part number keyword specifies the assigned IBM unit identification
   -- unit:
   -- Valid on ENTITY, FUNCTION, and COMPONENT INSTANTIATION(label)
   attribute PN: PN_STRING;

   -- The component part number keyword allows the naming of a BTR by part
   -- number:
   -- Valid on ENTITY, FUNCTION, and COMPONENT INSTANTIATION(label)
   attribute CPN: CPN_STRING;

   -- The block transformation rule name is associated with the BRULE keyword
   -- of the Automated Logic Diagram (ALD):
   -- Valid on ENTITY, FUNCTION, and COMPONENT INSTANTIATION(label)
   attribute BTR_NAME: STRING;

   -- Used to assign logical pin names.  This attribute is a special
   -- PIN_INFORMATION.  The first two fields are processed just like
   -- PIN_INFORMATIONs.  The third field specifies if the pin start is
   -- a seed name to be incremented "INCR", decremented "DECR", or used
   -- as the "SAME" name for all pins on that port.  The fourth field
   -- specifies how to treat each pin of a vectored port.  A vectored
   -- port could be treated as "PIN_BIT_SCALAR" or as "PIN_BIT_VECTOR".
   -- Valid on ENTITY and FUNCTION
   attribute PIN_BIT_INFORMATION: PIN_INTERFACE_LIST;

   -- Used when the default pin naming convention (increment by one)
   -- does not work.  Allows specification of exact pin names to be
   -- used for each array element.  Use the string "PINS" in the
   -- PIN_INFORMATION attribute to identify the ports where pins
   -- will be defined manually:
   -- Valid on ENTITY and FUNCTION
   attribute PINS_BIT_DETAIL: PINS_BIT_ARRAY;


   -- The Physical_Pins attribute is specifies if the port connections for an
   -- entity are physical or only logical pins. The default is FALSE (only
   -- logical pins):
   -- Valid on ENTITY
   attribute PHYSICAL_PINS: BOOLEAN;

   -- The Like_Builtin attribute specifies that a user defined function which
   -- overloads a builtin VHDL operator is equivalent to that builtin
   -- operator.  The default is FALSE:
   -- Valid on FUNCTION
   attribute LIKE_BUILTIN: BOOLEAN;

   -- This attributes specifies that the function that it is attached to is a
   -- type conversion with no synthesis logic.  The function must have only
   -- one input parameter.  When the number of input nets equals the number of
   -- output nets use STRAIGHT_THRU.  When the number of input nets is less
   -- then use either PAD_WITH_ZEROS or PAD_WITH_ONES.  It is invalid for the
   -- number of input nets to exceed the number of output nets.
   -- Valid on FUNCTION
   attribute TYPE_CONVERSION: TYPE_CONV;

   type LSSD_CLOCK_OR_SCAN is (A_CLK, B_CLK, C_CLK,
                               P_CLK, SCN_IN, SCN_OUT);

   type SYN_LATCH_CLOCK is (GATED_CLOCK, FREE_RUNNING_CLOCK, GATED_CLOCK_INTERNAL,GATED_CLOCK_AND,GATED_CLOCK_OR);

   -- This attribute indicates to vhdl synthesis where the LSSD nets are that
   -- will be used for LSSD clocks and scan datas:
   -- Valid on SIGNAL and PORT
   attribute LSSD_FLAG: LSSD_CLOCK_OR_SCAN;

   -- This attribute indicates to synthesis that a given guarded signal
   -- assignment is to have its latch implemented using gated clock logic or
   -- free running clock logic:
   -- Valid on SIGNAL or PORT
   attribute CLOCK_IMPLEMENTATION: SYN_LATCH_CLOCK;

   -- This attribute indicates to synthesis that a given guarded signal
   -- assignment is to be interpreted as a DC set or reset port:
   -- Valid on SIGNAL and PORT
   attribute DC_INITIALIZE: BOOLEAN;

   type PHYSICAL_DESCRIPTION_OF_IO is (MULTI_SOURCE_BUFFER, BI_DIRECTIONAL);

   -- Use this attribute to specify that this port, signal, or waveform is
   -- not to be optimized out by synthesis optimization transforms:
   -- Valid on SIGNAL
   attribute NO_MODIFICATION: STRING;

   -- This attribute allows the designer to specify what kind of pins
   -- should be built when using an INOUT port:
   -- Valid on PORT
   attribute IO_PHYSICAL_DESCRIPTION: PHYSICAL_DESCRIPTION_OF_IO;

   -- This attribute allows the designer to indicate that a concurrent
   -- signal assignment should be presented to synthesis as a boolean
   -- expression:
   -- Valid on CONCURRENT SIGNAL ASSIGMENT STM(label)
   attribute BOOLEAN_EXPRESSION: BOOLEAN;

   -- Generic attribute for putting user defined information on a VHDL
   -- block.
   -- Valid on ENTITY, FUNCTION, and COMPONENT INSTANTIATION(label)
   attribute BLOCK_DATA: STRING;

   -- Generic attribute for putting user defined information on a VHDL
   -- pin.
   -- Valid on PORT
   attribute PIN_DATA: STRING;

   -- Generic attribute for putting user defined information on a VHDL
   -- net.
   -- Valid on SIGNAL and PORT
   attribute NET_DATA: STRING;

   -- This attribute specifies that the pins of an IN port on an entity are
   -- "droppable" if that port is used as a FORMAL which is unconnected(OPEN).
   -- This attribute would not normally be used since the default expression
   -- on the IN port is usually desired.
   -- Valid on PORT
   attribute DROP_OPEN_PINS: BOOLEAN;

   -- This attribute directs the VHDL Synthesis Compiler to not process the
   -- entity/architecture pair which is bound by this component instance when
   -- in INCREMENTAL HIERARCHY or FLATTEN HIERARCHY modes.  Basically stops
   -- hierarchy walking.
   -- Valid on COMPONENT INSTANTIATION(label)
   attribute STOP_HIER_WALK: BOOLEAN;

   -- This attribute is used for dynamic block data in a function body.  A
   -- variable called BLOCK_DATA is searched for using this attribute to state
   -- how to build the block data on each function call.  The attrbute value
   -- has the same syntax as BLOCK_DATA.
   -- Valid on VARIABLE (in a function body)
   attribute DYNAMIC_BLOCK_DATA: STRING;

   --------------------------------------------------------------------
   --  Analysis and Checking Attributes                              --
   --------------------------------------------------------------------
   -- These attributes are used to control the generation of analysis
   -- and checking routine messages.  These attributes do not affect
   -- logic synthesis.
   -- Valid on PORT and SIGNAL.

    -- Set this to inhibit error messages on outputs that are
    -- not set within a model.
    -- Values are SUCCESS, INFORMATION, WARNING, ERROR, NONE
   attribute ANALYSIS_UNSET_OUT_PORT_SEVERITY : string;

    -- Used when a net should be assigned in the VHDL model,
    -- but not referenced.
   attribute ANALYSIS_NOT_REFERENCED : string;

    -- Used when a net should be referenced in a VHDL model,
    -- but not assigned.
   attribute ANALYSIS_NOT_ASSIGNED : string;

    -- Used when a net should be assigned in the VHDL model,
    -- but will be referenced via hierarchical reference assignments.
   attribute ANALYSIS_HIER_REFERENCED : string;

    -- Used when a net should be referenced in a VHDL model,
    -- but will be referenced via hierarchical reference assignments.
   attribute ANALYSIS_HIER_ASSIGNED : string;

    -- Used when a net is neither assigned or referenced in a VHDL model,
    -- but will be assigned and referenced via hierarchical reference assignments.
   attribute ANALYSIS_HIER_CHECKED : string;

    -- Used when you don't care about either the sets or refs
    -- done with a signal.  Both of these together is the same
    -- plain NOT_CHECKED alone.
   attribute ANALYSIS_SET_NOT_CHECKED : string;
   attribute ANALYSIS_REF_NOT_CHECKED : string;
    -- Do not check this net for assignments or references.
   attribute ANALYSIS_NOT_CHECKED : string;
    -- Not Used attribute.  You will get messages if it is used.
   attribute ANALYSIS_NOT_USED : string;
    --attached to the entity (value true), no lssd checking is done
   attribute ANALYSIS_NO_LSSD_CHECKS: boolean;
   --------------------------------------------------------------------
   --  Attributes worth reviewing in the future                      --
   --------------------------------------------------------------------

   type MULTI_BLOCK_PORT_INFO is
     record
       BLOCK_PORTION : SYN_ALPHANUMERICS_W_SPACE(1 to 3);
       PIN_START     : STRING(1 to 4);
     end record;
   type PORT_INTERFACE_LIST is array (POSITIVE range <>) of
                                              MULTI_BLOCK_PORT_INFO;

   -- Used to assign logical pin names.  The pin name is incremented
   -- to create additional pin names when the port contains multiple
   -- bits.  If incrementing the pin name is inappropriate, set the
   -- pin name field to "PINS" and use the PINS_DETAIL attribute:
   -- Valid on ENTITY and FUNCTION
   attribute PIN_INFORMATION: PORT_INTERFACE_LIST;

   type PINS_ARRAY is array (POSITIVE range <>, POSITIVE range <>) of
                                            STRING(1 to 4);

   -- Used when the default pin naming convention (increment by one)
   -- does not work.  Allows specification of exact pin names to be
   -- used for each array element.  Use the string "PINS" in the
   -- PIN_INFORMATION attribute to identify the ports where pins
   -- will be defined manually:
   -- Valid on ENTITY and FUNCTION
   attribute PINS_DETAIL: PINS_ARRAY;

   --------------------------------------------------------------------
   --  HIS predefined attributes for VHDL                            --
   --------------------------------------------------------------------

   attribute dc_allow : boolean;
   -- hiasynth will have a switch (dc_allow or ieee_dc) which will control
   -- the processing of '-' values in expressions to prevent simulation and
   -- synthesis mismatches due to the different interpretation of '-'.
   -- When the switch is set so that the processing is disabled, there
   -- are still some cases where '-' is appropriate.  In those cases, the
   -- dc_allow attribute may be attached to functions whose simulation behavior
   -- matches the synthesis interpretation.

   ATTRIBUTE hls_equiv_type : STRING;
               -- to overwrite a type/subtype (type overloading).

   ATTRIBUTE type_convert   : BOOLEAN;
               -- It tells synthesis that a certain function is purely
               -- for  "type conversion" purposes.

   ATTRIBUTE pseudo_fun     : BOOLEAN;
   ATTRIBUTE functionality  : STRING;
               -- These two attributes are used for redefining the
               -- functionality of any function/procedure.

   ATTRIBUTE no_synthesis   : BOOLEAN;
               -- It specifies that the Process or Block should not be
               -- synthesized.

   ATTRIBUTE recursive_synthesis : INTEGER;
               -- If set to 0, it will stop recursive synthesis processing
               -- If set to 1, and using the -rf switch on rclis, it will
               -- continue recursive processing even if entity has a
               -- BTR_NAME attribure.  Valid on entities and labels of
               -- component instances.

   ATTRIBUTE sgroup : integer ;
               -- VIM attribute used to determine whether an entity is sgroup

   ATTRIBUTE dont_initialize : boolean;
               -- HIS attribute to ensure that unused ports are not tied to 0

   attribute unbundled_def_pins : integer;
               -- If set to 1, it specifies that HIS should not create bundled
               -- dev pins when creating VIM.  Valic on entities and
               -- component declarations.

   -- attribute that controls the scan direction within a vectored register
   -- signal.  The type may also be used in a generic that controls the
   -- scan ring generation.
   type direction is ( right, left );
   attribute scan_direction : direction;

   --  HIS predefined attributes for VHDL                            --

   ATTRIBUTE port_mode      : STRING;
   ATTRIBUTE signal_mode    : STRING;
               -- used for fixing the type of buffers on signals/ports.

   ATTRIBUTE lssd_type      : STRING;
               -- It specifies the type of scan chain desired.

   ATTRIBUTE system_clocks  : STRING;
               -- It should be used in case of multiple clocks.

   -- HIS predefined attributes for Scheduling and Allocation          --

   ATTRIBUTE funits         : STRING;
               -- used to specify the type and number of functional units
               -- desired in the implementation.

   ATTRIBUTE fumerge        : STRING;
               -- used to specify the operations that should be considered
               -- during resource sharing.

   ATTRIBUTE min_saving     : INTEGER;
               -- sets the threshold area savings used during resource
               -- sharing.

   ATTRIBUTE seq_mod        : BOOLEAN;
               -- specifies that function/procedure is sequential or
               -- concurrent. Default: a function/procedure is sequential.

   ATTRIBUTE fsm_clock      : BOOLEAN;
               -- it should be attached to the clock port. It tells
               -- synthesis which port is the clock signal.


   -- HIS predefined attributes for Finite-State Machine synthesis     --

   ATTRIBUTE fsm_process         : BOOLEAN;
               -- It should be attached to the VHDL process modeling
               -- a FSM.

   ATTRIBUTE state_register      : BOOLEAN;
               -- specifies the variable that should become the state
               -- variable of the FSM.

   ATTRIBUTE state_register_name : STRING;
               -- defines a new name for the state variable.

   ATTRIBUTE insert_state_cut    : BOOLEAN;
               -- defines whether the FSM states should be kept or
               -- re-scheduled.

   ATTRIBUTE unroll_loop    : BOOLEAN;
               -- controls whether sequential loops should be unrolled or not.

end;
