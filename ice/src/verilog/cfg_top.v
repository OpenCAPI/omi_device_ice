// *!***************************************************************************
// *! Copyright 2019 International Business Machines
// *!
// *! Licensed under the Apache License, Version 2.0 (the "License");
// *! you may not use this file except in compliance with the License.
// *! You may obtain a copy of the License at
// *! http://www.apache.org/licenses/LICENSE-2.0
// *!
// *! The patent license granted to you in Section 3 of the License, as applied
// *! to the "Work," hereby includes implementations of the Work in physical form.
// *!
// *! Unless required by applicable law or agreed to in writing, the reference design
// *! distributed under the License is distributed on an "AS IS" BASIS,
// *! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// *! See the License for the specific language governing permissions and
// *! limitations under the License.
// *!
// *! The background Specification upon which this is based is managed by and available from
// *! the OpenCAPI Consortium.  More information can be found at https://opencapi.org.
// *!***************************************************************************
 
 
 
`timescale 1ns / 1ps
   `define CFG_TOP_VERISION       19_Feb_2019   //  Latch read only receive capabilities so they can be referenced from figtree



module cfg_top (

    // -----------------------------------
    // Miscellaneous Ports
    // -----------------------------------
    input          clock                             
  , input          reset_n                            // (active low) Hardware reset
  , output   [7:0] cfg0_tlx_bus_num                   // To TLX for assign acTag cmd 

     // Hardcoded configuration inputs
  , input    [4:0] ro_device                          // Assigned to this Device instantiation at the next level
  , input   [31:0] ro_dlx0_version                    // Connect to DLX output at next level, or tie off to all 0s
  , input   [31:0] ro_tlx0_version                    // Connect to TLX output at next level, or tie off to all 0s

    // -----------------------------------
    // TLX0 Parser -> AFU Receive Interface
    // -----------------------------------

  , input          tlx_afu_ready                      // When 1, TLX is ready to receive both commands and responses from the AFU


    // Configuration Ports: Drive Configuration (determined by software)
  , output         cfg0_tlx_xmit_tmpl_config_0        // When 1, TLX should support transmitting template 0
  , output         cfg0_tlx_xmit_tmpl_config_1        // When 1, TLX should support transmitting template 1
  , output         cfg0_tlx_xmit_tmpl_config_5        // When 1, TLX should support transmitting template 5
  , output         cfg0_tlx_xmit_tmpl_config_9        // When 1, TLX should support transmitting template 9
  , output         cfg0_tlx_xmit_tmpl_config_11       // When 1, TLX should support tran
  , output [  3:0] cfg0_tlx_xmit_rate_config_0        // Value corresponds to the rate TLX can transmit template 0
  , output [  3:0] cfg0_tlx_xmit_rate_config_1        // Value corresponds to the rate TLX can transmit template 1
  , output [  3:0] cfg0_tlx_xmit_rate_config_5        // Value corresponds to the rate TLX can transmit template 5
  , output [  3:0] cfg0_tlx_xmit_rate_config_9        // Value corresponds to the rate TLX can transmit template 9
  , output [  3:0] cfg0_tlx_xmit_rate_config_11       // Value corresponds to the rate TLX can transmit template 11
  , output         cfg0_tlx_tl_minor_version          // When 1, indicates OpenCAPI v3.1 support, v3.0 otherwise
  , output         cfg0_tlx_enable_afu                // When 1, indicates AFU function is enabled
  , output         cfg0_tlx_metadata_enabled          // When 1, indicates metadata enabled
  , output [ 11:0] cfg0_tlx_function_actag_base       // actag base for function (Should be equal to cfg0_tlx_afu_actag_base)
  , output [ 11:0] cfg0_tlx_function_actag_len_enab   // actag length for function (Should be equal to cfg0_tlx_afu_actag_len_enab)
  , output [ 11:0] cfg0_tlx_afu_actag_base            // actag base for afu (Should be equal to cfg0_tlx_function_actag_base)
  , output [ 11:0] cfg0_tlx_afu_actag_len_enab        // actag length for afu (Should be equal to cfg0_tlx_function_actag_len_enab)
  , output [  4:0] cfg0_tlx_pasid_length_enabled      // 2 to the power of this number indicates number of PASIDs assigned to afu
  , output [ 19:0] cfg0_tlx_pasid_base                // Starting PASID assigned to this AFU
  , output [63:35] cfg0_tlx_mmio_bar0                 // Upper 29 bits of BAR0 Function 1
  , output         cfg0_tlx_memory_space              // When 1, MMIO space is activated
  , output [  3:0] cfg0_tlx_long_backoff_timer        // Long backoff timer for rtry
  
  // Configuration Ports: Receive Capabilities (determined by TLX design)
  , input          tlx_cfg0_in_rcv_tmpl_capability_0  // When 1, TLX supports receiving template 0
  , input          tlx_cfg0_in_rcv_tmpl_capability_1  // When 1, TLX supports receiving template 1
  , input          tlx_cfg0_in_rcv_tmpl_capability_4  // When 1, TLX supports receiving template 4
  , input          tlx_cfg0_in_rcv_tmpl_capability_7  // When 1, TLX supports receiving template 7
  , input          tlx_cfg0_in_rcv_tmpl_capability_10 // When 1, TLX supports receiving template 10
  , input  [  3:0] tlx_cfg0_in_rcv_rate_capability_0  // Value corresponds to the rate TLX can receive template 0
  , input  [  3:0] tlx_cfg0_in_rcv_rate_capability_1  // Value corresponds to the rate TLX can receive template 1
  , input  [  3:0] tlx_cfg0_in_rcv_rate_capability_4  // Value corresponds to the rate TLX can receive template 4
  , input  [  3:0] tlx_cfg0_in_rcv_rate_capability_7  // Value corresponds to the rate TLX can receive template 7
  , input  [  3:0] tlx_cfg0_in_rcv_rate_capability_10 // Value corresponds to the rate TLX can receive template 10
 
    // ---------------------------
    // Config_* command interfaces
    // ---------------------------

    // Port 0: config_write/read commands from host    
  , input          tlx_cfg0_valid
  , input    [7:0] tlx_cfg0_opcode
  , input   [63:0] tlx_cfg0_pa
  , input          tlx_cfg0_t
  , input    [2:0] tlx_cfg0_pl
  , input   [15:0] tlx_cfg0_capptag
  , input   [31:0] tlx_cfg0_data_bus
  , input          tlx_cfg0_data_bdi
  , output   [3:0] cfg0_tlx_initial_credit
  , output         cfg0_tlx_credit_return

    // Port 0: config_* responses back to host
  , output         cfg0_tlx_resp_valid
  , output   [7:0] cfg0_tlx_resp_opcode
//, output   [1:0] cfg0_tlx_resp_dl        The TLX will fill in dL=01 and dP=00 as only 1 FLIT is ever used. Comment vs. remove lines here in case another TLX operates differently.
  , output  [15:0] cfg0_tlx_resp_capptag
//, output   [1:0] cfg0_tlx_resp_dp        The TLX will fill in dL=01 and dP=00 as only 1 FLIT is ever used. Comment vs. remove lines here in case another TLX operates differently.
  , output   [3:0] cfg0_tlx_resp_code
  , output   [3:0] cfg0_tlx_rdata_offset
  , output  [31:0] cfg0_tlx_rdata_bus
  , output         cfg0_tlx_rdata_bdi
  , input          tlx_cfg0_resp_ack


) ;


// ==============================================================================================================================
// @@@  PARM: Parameters
// ==============================================================================================================================
// There are none on this design.


// ==============================================================================================================================
// @@@  SIG: Internal signals 
// ==============================================================================================================================
wire   reset;
assign reset = ~reset_n;  // Create positive active version of reset

// ****************************
// * LATCHES                  *
// ****************************

reg [31:0] tlx_cfg0_data_bus_q;
reg tlx_cfg0_data_bdi_q;

wire rcv_tmpl_cap_0_din;
reg  rcv_tmpl_cap_0_q;
wire rcv_tmpl_cap_1_din;
reg  rcv_tmpl_cap_1_q;
wire rcv_tmpl_cap_4_din;
reg  rcv_tmpl_cap_4_q;
wire rcv_tmpl_cap_7_din;
reg  rcv_tmpl_cap_7_q;
wire rcv_tmpl_cap_10_din;
reg  rcv_tmpl_cap_10_q;
wire [3:0] rcv_rate_cap_0_din;
reg  [3:0] rcv_rate_cap_0_q;
wire [3:0] rcv_rate_cap_1_din;
reg  [3:0] rcv_rate_cap_1_q;
wire [3:0] rcv_rate_cap_4_din;
reg  [3:0] rcv_rate_cap_4_q;
wire [3:0] rcv_rate_cap_7_din;
reg  [3:0] rcv_rate_cap_7_q;
wire [3:0] rcv_rate_cap_10_din;
reg  [3:0] rcv_rate_cap_10_q; 

assign rcv_tmpl_cap_0_din = tlx_cfg0_in_rcv_tmpl_capability_0;
assign rcv_tmpl_cap_1_din = tlx_cfg0_in_rcv_tmpl_capability_1;
assign rcv_tmpl_cap_4_din = tlx_cfg0_in_rcv_tmpl_capability_4;
assign rcv_tmpl_cap_7_din = tlx_cfg0_in_rcv_tmpl_capability_7;
assign rcv_tmpl_cap_10_din = tlx_cfg0_in_rcv_tmpl_capability_10;
assign rcv_rate_cap_0_din[3:0] = tlx_cfg0_in_rcv_rate_capability_0[3:0];
assign rcv_rate_cap_1_din[3:0] = tlx_cfg0_in_rcv_rate_capability_1[3:0];
assign rcv_rate_cap_4_din[3:0] = tlx_cfg0_in_rcv_rate_capability_4[3:0];
assign rcv_rate_cap_7_din[3:0] = tlx_cfg0_in_rcv_rate_capability_7[3:0];
assign rcv_rate_cap_10_din[3:0] = tlx_cfg0_in_rcv_rate_capability_10[3:0];

always @(posedge(clock))
begin
  tlx_cfg0_data_bus_q[31:0] <= tlx_cfg0_data_bus[31:0];
  tlx_cfg0_data_bdi_q <= tlx_cfg0_data_bdi;
  rcv_tmpl_cap_0_q <= rcv_tmpl_cap_0_din;
  rcv_tmpl_cap_1_q <= rcv_tmpl_cap_1_din;
  rcv_tmpl_cap_4_q <= rcv_tmpl_cap_4_din;
  rcv_tmpl_cap_7_q <= rcv_tmpl_cap_7_din;
  rcv_tmpl_cap_10_q <= rcv_tmpl_cap_10_din;
  rcv_rate_cap_0_q[3:0] <= rcv_rate_cap_0_din[3:0];
  rcv_rate_cap_1_q[3:0] <= rcv_rate_cap_1_din[3:0];
  rcv_rate_cap_4_q[3:0] <= rcv_rate_cap_4_din[3:0];
  rcv_rate_cap_7_q[3:0] <= rcv_rate_cap_7_din[3:0];
  rcv_rate_cap_10_q[3:0] <= rcv_rate_cap_10_din[3:0];
end



// ****************************
// * CONFIGURATION SUB-SYSTEM *
// ****************************

// ==============================================================================================================================
// @@@ CFG_CMDFIFO: Buffer a number of config_* commands to remove them from the head of the TLX command queue
// ==============================================================================================================================

// --- Port 0 ---

assign cfg0_tlx_initial_credit = 4'b0000;   // Command FIFO manages initial credits via pulsed credit return signal

// Signals to connect CMD FIFO to CMD SEQ
  wire  [7:0] cfg0_cff_cmd_opcode
; wire [31:0] cfg0_cff_cmd_pa               // Per OpenCAPI TL spec, pa[63:32] are 'reserved' so don't use them to conserve FPGA resources
; wire [15:0] cfg0_cff_cmd_capptag
; wire        cfg0_cff_cmd_t
; wire  [2:0] cfg0_cff_cmd_pl
; wire        cfg0_cff_data_bdi
; wire [31:0] cfg0_cff_data_bus
; wire        cfg0_cff_cmd_valid            // Internal version of tlx_afu_cmd_valid
; wire        cfg0_cff_fifo_overflow        // Added to internal error vector sent to MMIO logic 
; wire        cfg0_cmd_dispatched           // Pulsed to 1 when command is complete or sent into the pipeline
;

cfg_cmdfifo CFG0_CFF  (               
    .clock                ( clock                    )  // Clock - samples & launches data on rising edge
  , .reset                ( reset                    )  // Reset - when 1 set control logic to default state
  , .tlx_is_ready         ( tlx_afu_ready            )  // When 1, TLX is ready to exchange commands and responses 
     // Input into FIFO
  , .tlx_cfg_opcode       ( tlx_cfg0_opcode          )
  , .tlx_cfg_pa           ( tlx_cfg0_pa[31:0]        )  // Per OpenCAPI TL spec, pa[63:32] are 'reserved' so don't use them to conserve FPGA resources
  , .tlx_cfg_capptag      ( tlx_cfg0_capptag         )
  , .tlx_cfg_t            ( tlx_cfg0_t               )
  , .tlx_cfg_pl           ( tlx_cfg0_pl              )
  , .tlx_cfg_data_bdi     ( tlx_cfg0_data_bdi_q      )
  , .tlx_cfg_data_bus     ( tlx_cfg0_data_bus_q      )
  , .cmd_in_valid         ( tlx_cfg0_valid           )  // (in)  When 1, load 'cmd_in' into the FIFO
  , .cmd_credit_to_TLX    ( cfg0_tlx_credit_return   )  // (out) When 1, there is space in the FIFO for another command
     // Output from FIFO
  , .cmd_dispatched       ( cfg0_cmd_dispatched      )  // (in)  When 1, increment read FIFO pointer to present the next FIFO entry
  , .cfg_cff_cmd_opcode   ( cfg0_cff_cmd_opcode      )  // (out) Signals to CFG SEQ
  , .cfg_cff_cmd_pa       ( cfg0_cff_cmd_pa          )  // Per OpenCAPI TL spec, pa[63:32] are 'reserved' so don't use them to conserve FPGA resources
  , .cfg_cff_cmd_capptag  ( cfg0_cff_cmd_capptag     )
  , .cfg_cff_cmd_t        ( cfg0_cff_cmd_t           )
  , .cfg_cff_cmd_pl       ( cfg0_cff_cmd_pl          )
  , .cfg_cff_data_bdi     ( cfg0_cff_data_bdi        )
  , .cfg_cff_data_bus     ( cfg0_cff_data_bus        )
  , .cmd_out_valid        ( cfg0_cff_cmd_valid       )  // (out) When 1, 'cmd_out' contains valid information
     // Error
  , .fifo_overflow        ( cfg0_cff_fifo_overflow   )  // (out) When 1, FIFO was full when another 'cmd_valid' arrived
) ;


// ==============================================================================================================================
// @@@ CFG_SEQ: Choose a command and execute it
// ==============================================================================================================================

// Signals distributing Bus / Device numbers
  wire  [7:0] cfg0_bus_num                
; wire  [4:0] cfg0_device_num
;

assign cfg0_tlx_bus_num = cfg0_bus_num;

// Signals from CFG SEQ to RESP FIFO port 0
  wire        cfg0_rff_resp_valid         // Pulse to 1 when response and/or resp data is available for loading into response FIFO
; wire  [7:0] cfg0_rff_resp_opcode
; wire  [3:0] cfg0_rff_resp_code
//wire  [1:0] cfg0_rff_resp_dl
//wire  [1:0] cfg0_rff_resp_dp
; wire [15:0] cfg0_rff_resp_capptag
; wire  [3:0] cfg0_rff_rdata_offset
; wire        cfg0_rff_rdata_bdi
; wire [31:0] cfg0_rff_rdata_bus
; wire [3:0]  cfg0_rff_buffers_available  // For information only, rffcr_buffers_available is used to determine space available 

// CFG_SEQ -> CFG_F* Functional Interface
; wire   [2:0] cfg_function
; wire   [1:0] cfg_portnum                  
; wire  [11:0] cfg_addr                     
; wire  [31:0] cfg_wdata                    
; wire  [31:0] cfg_f0_rdata                 // CFG_F0 outputs                              
; wire         cfg_f0_rdata_vld             
; wire  [31:0] cfg_f1_rdata                 // CFG_F1 outputs                              
; wire         cfg_f1_rdata_vld             
; wire         cfg_wr_1B                    
; wire         cfg_wr_2B                    
; wire         cfg_wr_4B 
; wire         cfg_rd    
; wire         cfg_bad_rd
; wire         cfg_f0_bad_op_or_align       // CFG_F0 outputs 
; wire         cfg_f0_addr_not_implemented  
; wire         cfg_f1_bad_op_or_align       // CFG_F1 outputs 
; wire         cfg_f1_addr_not_implemented  
; wire [127:0] cfg_errvec
; wire         cfg_errvec_valid
;


// Combine sources from multiple Functions
  wire  [31:0] cfg_rdata
; wire         cfg_rdata_vld
; wire         cfg_bad_op_or_align
; wire         cfg_addr_not_implemented
;
assign cfg_rdata                = cfg_f0_rdata                | cfg_f1_rdata;                  // Functions not targeted return 0
assign cfg_rdata_vld            = cfg_f0_rdata_vld            | cfg_f1_rdata_vld;              // Functions not targeted return 0
assign cfg_bad_op_or_align      = cfg_f0_bad_op_or_align      | cfg_f1_bad_op_or_align;        // Functions not targeted return 0
assign cfg_addr_not_implemented = cfg_f0_addr_not_implemented & cfg_f1_addr_not_implemented;   // Not implemented if ALL functions say so

cfg_seq CFG_SEQ (
    .clock                      ( clock                      )   // Clock - samples & launches data on rising edge
  , .reset                      ( reset                      )   // Reset - when 1 set control logic to default state
  , .device_num                 ( ro_device                  )   // Propagate Device number into BDF registers
  , .functions_attached         ( 8'b0000_0011               )   // Set bit=1 for each Function attached, corresponding to its number (i.e. Func 0,1 = 8'h03)
    // Port 0: From CMD FIFO
  , .cfg0_portnum               ( 2'b00                      )   // (in)  Hardcoded port number associated with this TLX instance (use vector for future expansion)
  , .cfg0_cff_cmd_opcode        ( cfg0_cff_cmd_opcode        )   // (in)  Signals from CMD FIFO on this port
  , .cfg0_cff_cmd_pa            ( cfg0_cff_cmd_pa            )
  , .cfg0_cff_cmd_capptag       ( cfg0_cff_cmd_capptag       )
  , .cfg0_cff_cmd_t             ( cfg0_cff_cmd_t             )
  , .cfg0_cff_cmd_pl            ( cfg0_cff_cmd_pl            )
  , .cfg0_cff_data_bdi          ( cfg0_cff_data_bdi          )
  , .cfg0_cff_data_bus          ( cfg0_cff_data_bus          )
  , .cfg0_cff_cmd_valid         ( cfg0_cff_cmd_valid         )   // (in)  Set to 1 when a command is pending at the FIFO output
  , .cfg0_cmd_dispatched        ( cfg0_cmd_dispatched        )   // (out) Pulse to 1 to increment read FIFO pointer to present the next FIFO entry
  , .cfg0_bus_num               ( cfg0_bus_num               )   // (out) Propagate to anyone who may need to use it
  , .cfg0_device_num            ( cfg0_device_num            )   // (out) Propagate to anyone who may need to use it 
   // Port 1: Not implemented to conserve FPGA resources
   // Port 2: Not implemented to conserve FPGA resources
   // Port 3: Not implemented to conserve FPGA resources
   // Port 0: To RESP FIFO  
  , .cfg0_rff_resp_valid        ( cfg0_rff_resp_valid        ) // (out) Pulse to 1 when response and/or resp data is available for loading into response FIFO
  , .cfg0_rff_resp_opcode       ( cfg0_rff_resp_opcode       ) // (out) Info to load into response FIFO
  , .cfg0_rff_resp_code         ( cfg0_rff_resp_code         )
//, .cfg0_rff_resp_dl           ( cfg0_rff_resp_dl           )
//, .cfg0_rff_resp_dp           ( cfg0_rff_resp_dp           )
  , .cfg0_rff_resp_capptag      ( cfg0_rff_resp_capptag      )
  , .cfg0_rff_rdata_offset      ( cfg0_rff_rdata_offset      )
  , .cfg0_rff_rdata_bdi         ( cfg0_rff_rdata_bdi         )
  , .cfg0_rff_rdata_bus         ( cfg0_rff_rdata_bus         )
  , .cfg0_rff_buffers_available ( cfg0_rff_buffers_available ) // (in)  Used to determine when can send something to the response FIFO  
   // Port 1: Not implemented to conserve FPGA resources
   // Port 2: Not implemented to conserve FPGA resources
   // Port 3: Not implemented to conserve FPGA resources
   // Error conditions
   // CFG_SEQ -> CFG_F* Functional Interface
  , .cfg_function               ( cfg_function               )
  , .cfg_portnum                ( cfg_portnum                )
  , .cfg_addr                   ( cfg_addr                   )
  , .cfg_wdata                  ( cfg_wdata                  )
  , .cfg_rdata                  ( cfg_rdata                  )
  , .cfg_rdata_vld              ( cfg_rdata_vld              )
  , .cfg_wr_1B                  ( cfg_wr_1B                  )
  , .cfg_wr_2B                  ( cfg_wr_2B                  )
  , .cfg_wr_4B                  ( cfg_wr_4B                  )
  , .cfg_rd                     ( cfg_rd                     )
  , .cfg_bad_rd                 ( cfg_bad_rd                 )
  , .cfg_bad_op_or_align        ( cfg_bad_op_or_align        )
  , .cfg_addr_not_implemented   ( cfg_addr_not_implemented   )
    // Supplemental Error Information - The AFU may optionally provide a means for CFG errors & error information to be reported to the host
  , .cfg_errvec                 ( cfg_errvec                 )
  , .cfg_errvec_valid           ( cfg_errvec_valid           )

) ;


// ==============================================================================================================================
// @@@ CFG_RESPFIFO: Buffer a number of config_* responses allowing config_* ops to occur as fast as possible
// ==============================================================================================================================

// --- Port 0 ---

wire cfg0_rff_fifo_overflow;       // Added to internal error vector sent to MMIO logic 
cfg_respfifo CFG0_RFF  (                       
    .clock                  ( clock                      )   // Clock - samples & launches data on rising edge
  , .reset                  ( reset                      )   // Reset - when 1 set control logic to default state
     // Input into FIFO
  , .cfg_rff_resp_opcode    ( cfg0_rff_resp_opcode       )
  , .cfg_rff_resp_code      ( cfg0_rff_resp_code         )
//, .cfg_rff_resp_dl        ( cfg0_rff_resp_dl           )
//, .cfg_rff_resp_dp        ( cfg0_rff_resp_dp           )
  , .cfg_rff_resp_capptag   ( cfg0_rff_resp_capptag      )
  , .cfg_rff_rdata_offset   ( cfg0_rff_rdata_offset      )
  , .cfg_rff_rdata_bdi      ( cfg0_rff_rdata_bdi         )
  , .cfg_rff_rdata_bus      ( cfg0_rff_rdata_bus         )
  , .cfg_rff_resp_in_valid  ( cfg0_rff_resp_valid        )   // When 1, load 'resp_in' into the FIFO
  , .resp_buffers_available ( cfg0_rff_buffers_available )   // When >0, there is space in the FIFO for another command
     // Output from FIFO
  , .cfg_tlx_resp_opcode    ( cfg0_tlx_resp_opcode       )
//, .cfg_tlx_resp_dl        ( cfg0_tlx_resp_dl           )
  , .cfg_tlx_resp_capptag   ( cfg0_tlx_resp_capptag      )
//, .cfg_tlx_resp_dp        ( cfg0_tlx_resp_dp           )
  , .cfg_tlx_resp_code      ( cfg0_tlx_resp_code         )
  , .cfg_tlx_rdata_offset   ( cfg0_tlx_rdata_offset      )
  , .cfg_tlx_rdata_bus      ( cfg0_tlx_rdata_bus         )
  , .cfg_tlx_rdata_bdi      ( cfg0_tlx_rdata_bdi         )
     // Valid-Ack handshake with TLX 
  , .cfg_tlx_resp_valid     ( cfg0_tlx_resp_valid        )   // Tell TLX when a response is ready for it to send
  , .tlx_cfg_resp_ack       ( tlx_cfg0_resp_ack          )   // TLX indicates current valid response has been sent
     // Error
  , .fifo_overflow          ( cfg0_rff_fifo_overflow     )   // When 1, FIFO was full when another 'resp_valid' arrived
) ;


// ==============================================================================================================================
// @@@ CFG_0: Function 0 Capability Structures (contains no AFUs)
// ==============================================================================================================================

// Declare F0 outputs
wire  [63:0] cfg_f0_csh_mmio_bar0;
wire  [63:0] cfg_f0_csh_mmio_bar1;
wire  [63:0] cfg_f0_csh_mmio_bar2;
wire  [31:0] cfg_f0_csh_expansion_ROM_bar; 
wire         cfg_f0_csh_expansion_ROM_enable;
wire   [7:0] cfg_f0_otl0_tl_major_vers_config; 
wire   [7:0] cfg_f0_otl0_tl_minor_vers_config;
wire   [3:0] cfg_f0_otl0_long_backoff_timer;
wire   [3:0] cfg_f0_otl0_short_backoff_timer;
wire  [63:0] cfg_f0_otl0_xmt_tmpl_config;
wire [255:0] cfg_f0_otl0_xmt_rate_tmpl_config;  
wire         cfg_f0_ofunc_function_reset;      
wire  [11:0] cfg_f0_ofunc_func_actag_base;
wire  [11:0] cfg_f0_ofunc_func_actag_len_enab;
wire [ 63:0] cfg_f0_otl0_rcv_tmpl_capbl;  
wire [255:0] cfg_f0_otl0_rcv_rate_capbl;


assign cfg0_tlx_tl_minor_version = cfg_f0_otl0_tl_minor_vers_config[0];
assign cfg0_tlx_long_backoff_timer[3:0] = cfg_f0_otl0_long_backoff_timer[3:0];
assign cfg_f0_otl0_rcv_tmpl_capbl[63:0] = 
  { 53'b0, 
    rcv_tmpl_cap_10_q, 
    2'b0, 
    rcv_tmpl_cap_7_q,
    2'b0,
    rcv_tmpl_cap_4_q,
    2'b0,
    rcv_tmpl_cap_1_q,
    rcv_tmpl_cap_0_q };
assign cfg_f0_otl0_rcv_rate_capbl =
  { 212'b0,
    rcv_rate_cap_10_q[3:0],
    8'b0,
    rcv_rate_cap_7_q[3:0],
    8'b0,
    rcv_rate_cap_4_q[3:0],
    8'b0,
    rcv_rate_cap_1_q[3:0],
    rcv_rate_cap_0_q[3:0] };

wire   cfg_f0_reset;
assign cfg_f0_reset = reset | cfg_f0_ofunc_function_reset;   // Apply on hardware reset OR software cmd (Function Reset)

cfg_func0 CFG_F0  (               
    .clock                               ( clock                                )  
  , .reset                               ( cfg_f0_reset                         )  
  , .device_reset                        ( reset                                )  
    // READ ONLY field inputs 
    // Configuration Space Header
  , .cfg_ro_csh_device_id                ( 16'h0636                             )
  , .cfg_ro_csh_vendor_id                ( 16'h1014                             )
  , .cfg_ro_csh_class_code               ( 24'h050000                           ) // x05=Memory Controller x0000=RAM Controller
  , .cfg_ro_csh_revision_id              (  8'h01                               )
  , .cfg_ro_csh_multi_function           (  1'b1                                ) // Should be 1 if using IBM's CFG implementation
  , .cfg_ro_csh_mmio_bar0_size           ( 64'hFFFF_FFFF_FFFF_FFFF              ) // [63:n+1]=1, [n:0]=0 to indicate MMIO region size (default 0 MB)
  , .cfg_ro_csh_mmio_bar1_size           ( 64'hFFFF_FFFF_FFFF_FFFF              ) // [63:n+1]=1, [n:0]=0 to indicate MMIO region size (default 0 MB)
  , .cfg_ro_csh_mmio_bar2_size           ( 64'hFFFF_FFFF_FFFF_FFFF              ) // [63:n+1]=1, [n:0]=0 to indicate MMIO region size (default 0 MB)
  , .cfg_ro_csh_mmio_bar0_prefetchable   (  1'b0                                ) 
  , .cfg_ro_csh_mmio_bar1_prefetchable   (  1'b0                                )
  , .cfg_ro_csh_mmio_bar2_prefetchable   (  1'b0                                )
  , .cfg_ro_csh_subsystem_id             ( 16'h0636                             )
  , .cfg_ro_csh_subsystem_vendor_id      ( 16'h1014                             )
  , .cfg_ro_csh_expansion_rom_bar        ( 32'hFFFF_F800                        ) // Only [31:11] are used
    // Device Serial Number
  , .cfg_ro_dsn_serial_number            ( 64'hDEAD_BEEF_DEAD_BEEF              ) //
    // OpenCAPI TL - port 0
  , .cfg_ro_otl0_tl_major_vers_capbl     (  8'h03                               )
  , .cfg_ro_otl0_tl_minor_vers_capbl     (  8'h01                               )
  , .cfg_ro_otl0_rcv_tmpl_capbl          (  cfg_f0_otl0_rcv_tmpl_capbl          ) // Gemini supports receive tmpls 0,1,4,7,A
  , .cfg_ro_otl0_rcv_rate_tmpl_capbl     (  cfg_f0_otl0_rcv_rate_capbl          ) // Get capabilities from TLX itself
    // Function
  , .cfg_ro_ofunc_reset_duration         (  8'h02                               ) // Number of cycles Function reset is active (00=255 cycles)
  , .cfg_ro_ofunc_afu_present            (  1'b0                                ) // Function 0 has no AFUs
  , .cfg_ro_ofunc_max_afu_index          (  6'b00_0000                          ) // Default is AFU number 0
    // Vendor DVSEC
  , .cfg_ro_ovsec_tlx0_version           ( ro_tlx0_version                      ) 
  , .cfg_ro_ovsec_tlx1_version           ( 32'h00000000                         ) // TLX port is not used
  , .cfg_ro_ovsec_tlx2_version           ( 32'h00000000                         ) // TLX port is not used   
  , .cfg_ro_ovsec_tlx3_version           ( 32'h00000000                         ) // TLX port is not used
  , .cfg_ro_ovsec_dlx0_version           ( ro_dlx0_version                      )
  , .cfg_ro_ovsec_dlx1_version           ( 32'h00000000                         ) // DLX port is not used
  , .cfg_ro_ovsec_dlx2_version           ( 32'h00000000                         ) // DLX port is not used
  , .cfg_ro_ovsec_dlx3_version           ( 32'h00000000                         ) // DLX port is not used
    // Assigned configuration values 
  , .cfg_ro_function                     ( 3'b000                               ) // This is Function 0
    // Functional interface
  , .cfg_function                        ( cfg_function                         )                       
  , .cfg_portnum                         ( cfg_portnum                          ) 
  , .cfg_addr                            ( cfg_addr                             ) 
  , .cfg_wdata                           ( cfg_wdata                            ) 
  , .cfg_rdata                           ( cfg_f0_rdata                         ) 
  , .cfg_rdata_vld                       ( cfg_f0_rdata_vld                     ) 
  , .cfg_wr_1B                           ( cfg_wr_1B                            ) 
  , .cfg_wr_2B                           ( cfg_wr_2B                            ) 
  , .cfg_wr_4B                           ( cfg_wr_4B                            ) 
  , .cfg_rd                              ( cfg_rd                               )
  , .cfg_bad_rd                          ( cfg_bad_rd                           )
  , .cfg_bad_op_or_align                 ( cfg_f0_bad_op_or_align               )
  , .cfg_addr_not_implemented            ( cfg_f0_addr_not_implemented          )
    // Individual fields from configuration registers
    // CSH
  , .cfg_csh_memory_space                ( cfg_f0_csh_memory_space              )
  , .cfg_csh_mmio_bar0                   ( cfg_f0_csh_mmio_bar0                 )
  , .cfg_csh_mmio_bar1                   ( cfg_f0_csh_mmio_bar1                 )
  , .cfg_csh_mmio_bar2                   ( cfg_f0_csh_mmio_bar2                 )
  , .cfg_csh_expansion_ROM_bar           ( cfg_f0_csh_expansion_ROM_bar         )
  , .cfg_csh_expansion_ROM_enable        ( cfg_f0_csh_expansion_ROM_enable      )
    // OTL Port 0
  , .cfg_otl0_tl_major_vers_config       ( cfg_f0_otl0_tl_major_vers_config     )
  , .cfg_otl0_tl_minor_vers_config       ( cfg_f0_otl0_tl_minor_vers_config     )
  , .cfg_otl0_long_backoff_timer         ( cfg_f0_otl0_long_backoff_timer       )
  , .cfg_otl0_short_backoff_timer        ( cfg_f0_otl0_short_backoff_timer      )
  , .cfg_otl0_xmt_tmpl_config            ( cfg_f0_otl0_xmt_tmpl_config          )
  , .cfg_otl0_xmt_rate_tmpl_config       ( cfg_f0_otl0_xmt_rate_tmpl_config     )
    // OFUNC
  , .cfg_ofunc_function_reset            ( cfg_f0_ofunc_function_reset          )
  , .cfg_ofunc_func_actag_base           ( cfg_f0_ofunc_func_actag_base         )
  , .cfg_ofunc_func_actag_len_enab       ( cfg_f0_ofunc_func_actag_len_enab     )
   // Interface to VPD 
  , .cfg_vpd_addr                        (                                      )
  , .cfg_vpd_wren                        (                                      )
  , .cfg_vpd_wdata                       (                                      )
  , .cfg_vpd_rden                        (                                      )
  , .vpd_cfg_rdata                       ( 32'b0                                )
  , .vpd_cfg_done                        ( 1'b0                                 )
   // Interface to FLASH control logic
  , .cfg_flsh_devsel                     (                                      )
  , .cfg_flsh_addr                       (                                      )
  , .cfg_flsh_wren                       (                                      )
  , .cfg_flsh_wdata                      (                                      )
  , .cfg_flsh_rden                       (                                      )
  , .flsh_cfg_rdata                      ( 32'b0                                )
  , .flsh_cfg_done                       ( 1'b0                                 )
  , .flsh_cfg_status                     ( 8'b0                                 )
  , .flsh_cfg_bresp                      ( 2'b0                                 )
  , .flsh_cfg_rresp                      ( 2'b0                                 )
  , .cfg_flsh_expand_enable              (                                      )
  , .cfg_flsh_expand_dir                 (                                      )

);

wire         cfg_f1_csh_memory_space;
wire [63:0] cfg_f1_csh_mmio_bar0;
wire [63:0] cfg_f1_csh_mmio_bar1;
wire [63:0] cfg_f1_csh_mmio_bar2;
wire [31:0] cfg_f1_csh_expansion_ROM_bar;
wire [11:0] cfg_f1_ofunc_func_actag_base;
wire [11:0] cfg_f1_ofunc_func_actag_len_enab;
wire [5:0]  cfg_f1_octrl00_afu_control_index;
wire [19:0] cfg_f1_octrl00_terminate_pasid;
wire [4:0]  cfg_f1_octrl00_pasid_length_enabled;
wire [2:0]  cfg_f1_octrl00_host_tag_run_length;
wire [19:0] cfg_f1_octrl00_pasid_base;
wire [11:0] cfg_f1_octrl00_afu_actag_base;
wire [11:0] cfg_f1_octrl00_afu_actag_len_enab;
wire        cfg_f1_reset;
wire        cfg_f1_ofunc_function_reset;
wire [5:0]  cfg_desc_afu_index;
wire [30:0] cfg_desc_offset;
wire        cfg_desc_cmd_valid;
wire        desc_cfg_echo_cmd_valid;
wire        desc_cfg_data_valid;
wire [31:0] desc_cfg_data;
wire [3:0]  cfg_f1_octrl00_afu_unique;
wire        cfg_f1_octrl00_enable_afu;
wire        cfg_f1_octrl00_metadata_enabled;


assign cfg0_tlx_memory_space = cfg_f1_csh_memory_space;
// Drive template and rate configuration information back into TLX
assign cfg0_tlx_xmit_tmpl_config_11 = cfg_f0_otl0_xmt_tmpl_config[11];
assign cfg0_tlx_xmit_tmpl_config_9  = cfg_f0_otl0_xmt_tmpl_config[9];
assign cfg0_tlx_xmit_tmpl_config_5  = cfg_f0_otl0_xmt_tmpl_config[5];
assign cfg0_tlx_xmit_tmpl_config_1  = cfg_f0_otl0_xmt_tmpl_config[1];
assign cfg0_tlx_xmit_tmpl_config_0  = cfg_f0_otl0_xmt_tmpl_config[0];

assign cfg0_tlx_xmit_rate_config_11[3:0] = cfg_f0_otl0_xmt_rate_tmpl_config[47:44];
assign cfg0_tlx_xmit_rate_config_9[3:0]  = cfg_f0_otl0_xmt_rate_tmpl_config[39:36];
assign cfg0_tlx_xmit_rate_config_5[3:0]  = cfg_f0_otl0_xmt_rate_tmpl_config[23:20];
assign cfg0_tlx_xmit_rate_config_1[3:0]  = cfg_f0_otl0_xmt_rate_tmpl_config[7:4];
assign cfg0_tlx_xmit_rate_config_0[3:0]  = cfg_f0_otl0_xmt_rate_tmpl_config[3:0];

assign cfg0_tlx_mmio_bar0[63:35] = cfg_f1_csh_mmio_bar0[63:35];
assign cfg0_tlx_function_actag_base[11:0] = cfg_f1_ofunc_func_actag_base[11:0];
assign cfg0_tlx_function_actag_len_enab[11:0] = cfg_f1_ofunc_func_actag_len_enab[11:0];
assign cfg0_tlx_pasid_base[19:0] = cfg_f1_octrl00_pasid_base[19:0];
assign cfg0_tlx_pasid_length_enabled[4:0] = cfg_f1_octrl00_pasid_length_enabled[4:0];
assign cfg0_tlx_afu_actag_base[11:0] = cfg_f1_octrl00_afu_actag_base[11:0];
assign cfg0_tlx_afu_actag_len_enab[11:0] = cfg_f1_octrl00_afu_actag_len_enab[11:0];
assign cfg0_tlx_enable_afu = cfg_f1_octrl00_enable_afu;
assign cfg0_tlx_metadata_enabled = cfg_f1_octrl00_metadata_enabled;


assign cfg_f1_reset = (reset == 1'b1 || cfg_f1_ofunc_function_reset == 1'b1) ? 1'b1 : 1'b0;   // Apply on hardware reset OR software cmd (Function Reset)

cfg_func CFG_F1  (               
    .clock                               ( clock                                )  
  , .reset                               ( cfg_f1_reset                         )  
  , .device_reset                        ( reset                                )  
    // READ ONLY field inputs 
    // Configuration Space Header
  , .cfg_ro_csh_device_id                ( 16'h0636                             )
  , .cfg_ro_csh_vendor_id                ( 16'h1014                             )
  , .cfg_ro_csh_class_code               ( 24'h050000                           ) // x05=Memory Controller x0000=RAM Controller
  , .cfg_ro_csh_revision_id              (  8'h01                               )
  , .cfg_ro_csh_multi_function           (  1'b1                                ) // Should be 1 if using IBM's CFG implementation
  , .cfg_ro_csh_mmio_bar0_size           ( 64'hFFFF_FFF8_0000_0000              ) // [63:n+1]=1, [n:0]=0 to indicate MMIO region size (default 32GB)
  , .cfg_ro_csh_mmio_bar1_size           ( 64'hFFFF_FFFF_FFFF_FFFF              ) // [63:n+1]=1, [n:0]=0 to indicate MMIO region size (default 0 MB)
  , .cfg_ro_csh_mmio_bar2_size           ( 64'hFFFF_FFFF_FFFF_FFFF              ) // [63:n+1]=1, [n:0]=0 to indicate MMIO region size (default 0 MB)
  , .cfg_ro_csh_mmio_bar0_prefetchable   (  1'b0                                ) 
  , .cfg_ro_csh_mmio_bar1_prefetchable   (  1'b0                                )
  , .cfg_ro_csh_mmio_bar2_prefetchable   (  1'b0                                )
  , .cfg_ro_csh_subsystem_id             ( 16'h0636                            )
  , .cfg_ro_csh_subsystem_vendor_id      ( 16'h1014                             )
  , .cfg_ro_csh_expansion_rom_bar        ( 32'hFFFF_F800                        ) // Only [31:11] are used
    // PASID
  , .cfg_ro_pasid_max_pasid_width        (  5'b00000                            ) // 1 PASID in Gemini/OCMB
    // Function
  , .cfg_ro_ofunc_reset_duration         (  8'h02                               ) // Number of cycles Function reset is active (00=255 cycles)
  , .cfg_ro_ofunc_afu_present            (  1'b1                                ) // Func0=0, FuncN=1 (likely)
  , .cfg_ro_ofunc_max_afu_index          (  6'b00_0000                          ) // Default is AFU number 0
    // AFU 0 Control
  , .cfg_ro_octrl00_reset_duration       (  8'h02                               ) // Number of cycles AFU reset is active (00=255 cycles)
  , .cfg_ro_octrl00_afu_control_index    (  6'b000000                           ) // Control structure for AFU Index 0
  , .cfg_ro_octrl00_pasid_len_supported  (  5'b00000                            ) // Default is 1 PASID
  , .cfg_ro_octrl00_metadata_supported   (  1'b1                                ) // MetaData is supported
  , .cfg_ro_octrl00_actag_len_supported  ( 12'h001                              ) // Default is 1 acTag
    // Assigned configuration values 
  , .cfg_ro_function                     (  3'b001                              ) 
    // Functional interface
  , .cfg_function                        ( cfg_function                         )                       
  , .cfg_portnum                         ( cfg_portnum                          ) 
  , .cfg_addr                            ( cfg_addr                             ) 
  , .cfg_wdata                           ( cfg_wdata                            ) 
  , .cfg_rdata                           ( cfg_f1_rdata                         ) 
  , .cfg_rdata_vld                       ( cfg_f1_rdata_vld                     ) 
  , .cfg_wr_1B                           ( cfg_wr_1B                            ) 
  , .cfg_wr_2B                           ( cfg_wr_2B                            ) 
  , .cfg_wr_4B                           ( cfg_wr_4B                            ) 
  , .cfg_rd                              ( cfg_rd                               )
  , .cfg_bad_rd                          ( cfg_bad_rd                           )
  , .cfg_bad_op_or_align                 ( cfg_f1_bad_op_or_align               )
  , .cfg_addr_not_implemented            ( cfg_f1_addr_not_implemented          )
    // Inputs defined by active AFU logic
  , .cfg_octrl00_terminate_in_progress   ( 1'b0     ) // Function 1 contains one AFU
    // Individual fields from configuration registers
    // CSH
  , .cfg_csh_memory_space                ( cfg_f1_csh_memory_space              )
  , .cfg_csh_mmio_bar0                   ( cfg_f1_csh_mmio_bar0                 )
  , .cfg_csh_mmio_bar1                   ( cfg_f1_csh_mmio_bar1                 )
  , .cfg_csh_mmio_bar2                   ( cfg_f1_csh_mmio_bar2                 )
  , .cfg_csh_expansion_ROM_bar           ( cfg_f1_csh_expansion_ROM_bar         )
  , .cfg_csh_expansion_ROM_enable        ( cfg_f1_csh_expansion_ROM_enable      )
    // OFUNC
  , .cfg_ofunc_function_reset            ( cfg_f1_ofunc_function_reset          )
  , .cfg_ofunc_func_actag_base           ( cfg_f1_ofunc_func_actag_base         ) // These aren't needed in a single AFU device
  , .cfg_ofunc_func_actag_len_enab       ( cfg_f1_ofunc_func_actag_len_enab     ) // These aren't needed in a single AFU device
    // OCTRL
  , .cfg_octrl00_afu_control_index       ( cfg_f1_octrl00_afu_control_index     )
  , .cfg_octrl00_afu_unique              ( cfg_f1_octrl00_afu_unique            )
  , .cfg_octrl00_fence_afu               ( cfg_f1_octrl00_fence_afu             )  
  , .cfg_octrl00_enable_afu              ( cfg_f1_octrl00_enable_afu            )  
  , .cfg_octrl00_reset_afu               ( cfg_f1_octrl00_reset_afu             )
  , .cfg_octrl00_terminate_valid         ( cfg_f1_octrl00_terminate_valid       )
  , .cfg_octrl00_terminate_pasid         ( cfg_f1_octrl00_terminate_pasid       )
  , .cfg_octrl00_pasid_length_enabled    ( cfg_f1_octrl00_pasid_length_enabled  )
  , .cfg_octrl00_metadata_enabled        ( cfg_f1_octrl00_metadata_enabled      )
  , .cfg_octrl00_host_tag_run_length     ( cfg_f1_octrl00_host_tag_run_length   )
  , .cfg_octrl00_pasid_base              ( cfg_f1_octrl00_pasid_base            )
  , .cfg_octrl00_afu_actag_base          ( cfg_f1_octrl00_afu_actag_base        )
  , .cfg_octrl00_afu_actag_len_enab      ( cfg_f1_octrl00_afu_actag_len_enab    )
    // Interface to AFU Descriptor table (interface is Read Only)
  , .cfg_desc_afu_index                  ( cfg_desc_afu_index                   )
  , .cfg_desc_offset                     ( cfg_desc_offset                      )
  , .cfg_desc_cmd_valid                  ( cfg_desc_cmd_valid                   )
  , .desc_cfg_data                       ( desc_cfg_data                        )
  , .desc_cfg_data_valid                 ( desc_cfg_data_valid                  )
  , .desc_cfg_echo_cmd_valid             ( desc_cfg_echo_cmd_valid              )
);

// Resync credits control
assign cfg_f1_octrl00_resync_credits = cfg_f1_octrl00_afu_unique[0];   // Assign AFU Unique[0] as resync_credits signal 
assign resync_credits_afu00          = cfg_f1_octrl00_afu_unique[0];   // Make a copy for internal use, as get Warning when an output as an input



// ==============================================================================================================================
// @@@ LPC: LPC top level
// ==============================================================================================================================

// Set AFU reset on either: card reset OR function reset OR software reset to AFU 0
assign reset_afu00 = ( reset == 1'b1        || 
                       cfg_f1_reset == 1'b1 ||
                      (cfg_f1_octrl00_reset_afu == 1'b1 && cfg_f1_octrl00_afu_control_index == 6'b000000) ) ? 1'b1 : 1'b0; 

cfg_descriptor DESC (
    .clock                                  ( clock                             )
  , .reset                                  ( reset_afu00                       )  // (positive active)
    // READ ONLY field inputs 
                                              // 222221111111111000000000
                                              // 432109876543210987654321   Keep string exactly 24 characters long
//, .ro_name_space                          (   "IBM,LPC00000000000000000"        ) // '.' is an illegal character in the name
  , .ro_name_space                          (  {"IBM_OPENCAPI_DDR4_BUFFER"}     ) // String must contain EXACTLY 24 characters, so pad accordingly with NULLs
  , .ro_afu_version_major                   (  8'h01               ) 
  , .ro_afu_version_minor                   (  8'h00               ) 
  , .ro_afuc_type                           (   3'b000                          ) // Type C0 contains no visible-to-the-host processing element
  , .ro_afum_type                           (   3'b001                          ) // Type M1 contains host mapped addresses (i.e. MMIO or memory)
  , .ro_profile                             (   8'h02                           ) // OpenCAPI 3.1 Memory Interface Class
  , .ro_global_mmio_offset                  (  48'h0000_0000_0000               ) // MMIO space start offset from BAR 0 addr ([15:0] assumed to be h0000)
  , .ro_global_mmio_bar                     (   3'b000                          ) // MMIO space is contained in BAR0
  , .ro_global_mmio_size                    (  32'h8000_0000                    ) // Global MMIO space
  , .ro_cmd_flag_x1_supported               (   1'b0                            ) // cmd_flag x1 is not supported
  , .ro_cmd_flag_x3_supported               (   1'b0                            ) // cmd_flag x3 is not supported
  , .ro_atc_2M_page_supported               (   1'b0                            ) // Address Translation Cache page size of 2MB is not supported
  , .ro_atc_64K_page_supported              (   1'b0                            ) // Address Translation Cache page size of 64KB is not supported
  , .ro_max_host_tag_size                   (   5'b00000                        ) // Caching is not supported
  , .ro_per_pasid_mmio_offset               (  48'h0000_0000_0000               ) // PASID space start at BAR 0+512KB address ([15:0] assumed to be h0000)
  , .ro_per_pasid_mmio_bar                  (   3'b000                          ) // PASID space is contained in BAR0
  , .ro_per_pasid_mmio_stride               (  16'h0001                         ) // Stride is 64KB per PASID entry ([15:0] assumed to be h0000)
  , .ro_mem_size                            (   8'h14                           ) // Default is 1 MB (2^20, x14 = 20 decimal) - SAM disabled
//, .ro_mem_size                            (   8'h2A                           ) // Default is 4 TB (2^42, x2A = 42 decimal) - SAM enabled
  , .ro_mem_start_addr                      (  64'h0000_0000_0000_0000          ) // LPC has only one Memory Space, starting at addr 0
  , .ro_naa_wwid                            ( 128'h0000_0000_0000_0000_0000_0000_0000_0000 ) // LPC has no WWID
  , .ro_system_memory_length                (  64'h0000_0000_0000_0000          ) // General Purpose System Memory Size, [15:0] forced to h0000 to align with 64 KB boundary
    // Hardcoded 'AFU Index' number of this instance of descriptor table
  , .ro_afu_index                           ( 6'b0                              ) // Each AFU instance under a common Function needs a unique index number
    // Functional interface
  , .cfg_desc_afu_index                     ( cfg_desc_afu_index                )
  , .cfg_desc_offset                        ( cfg_desc_offset                   )
  , .cfg_desc_cmd_valid                     ( cfg_desc_cmd_valid                )
  , .desc_cfg_data                          ( desc_cfg_data                     )
  , .desc_cfg_data_valid                    ( desc_cfg_data_valid               )
  , .desc_cfg_echo_cmd_valid                ( desc_cfg_echo_cmd_valid           )
    // Error indicator
  , .err_unimplemented_addr                 ( desc_err_unimplemented_addr       )
);


 

endmodule 
