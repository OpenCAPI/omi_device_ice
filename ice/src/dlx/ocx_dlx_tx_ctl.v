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

  `define DLX_VERSION_NUMBER      32'h18102500 //-- Added reset conditions to latches to fix pointer errors
module ocx_dlx_tx_ctl #(
parameter GEMINI_NOT_APOLLO = 0
) (

     rx_tx_tx_lane_swap                   // --  < input
    ,rx_tx_crc_error                      // --  < input
    ,rx_tx_retrain                        // --  < input
    ,user_retrain                         // --  < input
    ,rx_tx_nack                           // --  < input
    ,rx_tx_pattern_a                      // --  < input  [7:0]
    ,rx_tx_pattern_b                      // --  < input  [7:0]
    ,rx_tx_sync                           // --  < input  [7:0]
    ,rx_tx_TS1                            // --  < input  [7:0]
    ,rx_tx_TS2                            // --  < input  [7:0]
    ,rx_tx_TS3                            // --  < input  [7:0]
    ,rx_tx_block_lock                     // --  < input  [7:0]
    ,ln0_rx_tx_last_byte_ts3              // --  < input  [7:0]
    ,ln1_rx_tx_last_byte_ts3              // --  < input  [7:0]
    ,ln2_rx_tx_last_byte_ts3              // --  < input  [7:0]
    ,ln3_rx_tx_last_byte_ts3              // --  < input  [7:0]
    ,io_pb_o0_rx_init_done                // --  < input  [7:0]
    ,rx_tx_deskew_done                    // --  < input
    ,rx_tx_linkup                         // --  < input
    ,dlx_reset                            // --  < input
    ,error_no_fwd_progress                // --  < input
    ,pulse_1us                            // -- >  output
    ,train_ts2                            // -- >  output
    ,train_ts67                           // -- >  output
    ,tx_rx_phy_training                   // -- >  output
    ,tx_rx_training                       // -- >  output
    ,tx_rx_disabled_rx_lanes                 // --  > output [7:0]
    ,ctl_que_reset                        // -- >  output
    ,ctl_que_stall                        // -- >  output
    ,ctl_que_use_nghbr_outside               // -- >  output[3:1]
    ,ctl_que_use_nghbr_inside                // -- >  output[3:1]
    ,ctl_gb_tx_a_pattern                  // -- >  output
    ,ctl_gb_tx_b_pattern                  // -- >  output
    ,ctl_gb_tx_sync_pattern               // -- >  output
    ,ctl_gb_tx_zeros                      // -- >  output  [7:0]
    ,ctl_que_tx_ts0                       // -- >  output
    ,ctl_que_tx_ts1                       // -- >  output
    ,ctl_que_tx_ts2                       // -- >  output
    ,ctl_que_tx_ts3                       // -- >  output
    ,ctl_que_good_lanes                   // -- >  output [15:0]
    ,ctl_que_deskew                       // -- >  output [23:0]
    ,ctl_gb_train                         // -- >  output
    ,ctl_gb_reset                         // -- >  output
    ,ctl_gb_seq                           // -- >  output [6:0]
    ,ctl_flt_train_done                   // -- >  output
    ,ctl_flt_stall                        // -- >  output
    ,ctl_q0_lane_scrambler                // -- >  output [63:0]
    ,ctl_q1_lane_scrambler                // -- >  output [63:0]
    ,ctl_q2_lane_scrambler                // -- >  output [63:0]
    ,ctl_q3_lane_scrambler                // -- >  output [63:0]
    ,ctl_q4_lane_scrambler                // -- >  output [63:0]
    ,ctl_q5_lane_scrambler                // -- >  output [63:0]
    ,ctl_q6_lane_scrambler                // -- >  output [63:0]
    ,ctl_q7_lane_scrambler                // -- >  output [63:0]
    ,pb_io_o0_rx_run_lane                 // -- >  output [7:0]
    ,ro_dlx_version                       // -- >  output [31:0]
    ,ctl_x4_not_x8_tx_mode                // -- >  output
    ,ctl_x2_tx_mode                       // -- >  output
    ,tsm_state2_to_3                      // -- <  input
    ,tsm_state4_to_5                      // -- <  input
    ,tsm_state6_to_1                      // -- <  input
    ,EDPL_ena                             // -- <  input
    ,EDPL_time_window_enc                 // -- <  input [3:0]
    ,EDPL_max_cnt_reset                   // -- <  input
    ,rx_tx_EDPL_thres_reached             // -- <  input [7:0]
    ,tx_rx_EDPL_cntr_reset                // -- >  output
    ,ctl_reg_hwwe                         // -- >  output
    ,x8_mode                              // -- < input
    ,x4OL_mode                            // -- <  input
    ,x8_degrade_to_outside                // -- < input
    ,x8_degrade_to_inside                 // -- < input
    ,x4_degrade_to_outside                // -- < input
    ,x4_degrade_to_inside                 // -- < input
    ,ltch_lane_cfg                        // -- > output

//--     ,gnd                                  // -- <> inout
//--     ,vdn                                  // -- <> inout
    ,dlx_clk                              // -- <  input  
    );

    input         rx_tx_tx_lane_swap;
    input         rx_tx_crc_error;
    input         rx_tx_retrain;
    input         user_retrain;
    input         rx_tx_nack;
    input  [7:0]  rx_tx_pattern_a;
    input  [7:0]  rx_tx_pattern_b;
    input  [7:0]  rx_tx_sync;
    input  [7:0]  rx_tx_TS1;
    input  [7:0]  rx_tx_TS2;
    input  [7:0]  rx_tx_TS3;
    input  [7:0]  rx_tx_block_lock;
    input         rx_tx_deskew_done;
    input         rx_tx_linkup;
    input  [7:0]  ln0_rx_tx_last_byte_ts3;
    input  [7:0]  ln1_rx_tx_last_byte_ts3;
    input  [7:0]  ln2_rx_tx_last_byte_ts3;
    input  [7:0]  ln3_rx_tx_last_byte_ts3;
    input         dlx_reset;
    input         error_no_fwd_progress;
    input  [7:0]  io_pb_o0_rx_init_done;
    output        pulse_1us;
    output        train_ts2;
    output        train_ts67;
    output        tx_rx_phy_training;
    output        tx_rx_training;
    output [7:0]  tx_rx_disabled_rx_lanes;
    output        ctl_que_reset;
    output        ctl_que_stall;
    output [3:1]  ctl_que_use_nghbr_outside;
    output [3:1]  ctl_que_use_nghbr_inside;
    output        ctl_gb_tx_a_pattern;
    output        ctl_gb_tx_b_pattern;
    output        ctl_gb_tx_sync_pattern;
    output [7:0]  ctl_gb_tx_zeros;
    output        ctl_que_tx_ts0;
    output        ctl_que_tx_ts1;
    output        ctl_que_tx_ts2;
    output        ctl_que_tx_ts3;
    output [15:0] ctl_que_good_lanes;
    output [23:0] ctl_que_deskew;
    output        ctl_gb_train;
    output        ctl_gb_reset;
    output [6:0]  ctl_gb_seq;
    output        ctl_flt_train_done;
    output        ctl_flt_stall;
    output        ctl_x4_not_x8_tx_mode;
    output        ctl_x2_tx_mode;
  
    output [63:0] ctl_q0_lane_scrambler;
    output [63:0] ctl_q1_lane_scrambler;
    output [63:0] ctl_q2_lane_scrambler;
    output [63:0] ctl_q3_lane_scrambler;
    output [63:0] ctl_q4_lane_scrambler;
    output [63:0] ctl_q5_lane_scrambler;
    output [63:0] ctl_q6_lane_scrambler;
    output [63:0] ctl_q7_lane_scrambler;
    output [7:0]  pb_io_o0_rx_run_lane;
    output [31:0] ro_dlx_version;
    output        ltch_lane_cfg;

    input dlx_clk;
    input tsm_state2_to_3;
    input tsm_state4_to_5;
    input tsm_state6_to_1;
    
    input EDPL_ena;
    input [3:0] EDPL_time_window_enc;
    input EDPL_max_cnt_reset;
    input [7:0] rx_tx_EDPL_thres_reached;
    output tx_rx_EDPL_cntr_reset;
    output ctl_reg_hwwe;
    input  x8_mode;
    input  x4OL_mode;
    input  x8_degrade_to_outside;
    input  x8_degrade_to_inside;
    input  x4_degrade_to_outside;
    input  x4_degrade_to_inside;
   
//--     inout gnd;

//--     (* GROUND_PIN="1" *)
//--     wire gnd;

//--     inout vdn;
//--     (* POWER_PIN="1" *)
//--     wire vdn;

// -- begin logic here
//-- lfsr functions
function [63:0] reverse64 (input [63:0] forward);
  integer i;
  for (i=0; i<=63; i=i+1)
    reverse64[63-i] = forward[i];
endfunction
function [22:0] reverse23 (input [22:0] forward);
  integer i;
  for (i=0; i<=22; i=i+1)
    reverse23[22-i] = forward[i];
endfunction
function [15:0] reverse16 (input [15:0] forward);
  integer i;
  for (i=0; i<=15; i=i+1)
    reverse16[15-i] = forward[i];
endfunction
function [7:0] reverse8 (input [7:0] forward);
  integer i;
  for (i=0; i<=7; i=i+1)
    reverse8[7-i] = forward[i];
endfunction

function [0:22] advance64;      //-- advance the 23 bit lfsr by 64 bits
input [0:22] lfsr;
begin 

advance64[22] =    lfsr[2]  ^ lfsr[4]  ^ lfsr[6]  ^ lfsr[13] ^ lfsr[15] ^ lfsr[18] ^
                   lfsr[19] ^ lfsr[20] ^ lfsr[22];
advance64[21] =    lfsr[1]  ^ lfsr[3]  ^ lfsr[5]  ^ lfsr[12] ^ lfsr[14] ^ lfsr[17] ^
                   lfsr[18] ^ lfsr[19] ^ lfsr[21];
advance64[20] =    lfsr[0]  ^ lfsr[2]  ^ lfsr[4]  ^ lfsr[11] ^ lfsr[13] ^ lfsr[16] ^
                   lfsr[17] ^ lfsr[18] ^ lfsr[20];
advance64[19] =    lfsr[3]  ^ lfsr[6]  ^ lfsr[10] ^ lfsr[12] ^ lfsr[14] ^ lfsr[15] ^
                   lfsr[16] ^ lfsr[19] ^ lfsr[20] ^ lfsr[22];
advance64[18] =    lfsr[2]  ^ lfsr[5]  ^ lfsr[9]  ^ lfsr[11] ^ lfsr[13] ^ lfsr[14] ^
                   lfsr[15] ^ lfsr[18] ^ lfsr[19] ^ lfsr[21];
advance64[17] =    lfsr[1]  ^ lfsr[4]  ^ lfsr[8]  ^ lfsr[10] ^ lfsr[12] ^ lfsr[13] ^
                   lfsr[14] ^ lfsr[17] ^ lfsr[18] ^ lfsr[20];
advance64[16] =    lfsr[0]  ^ lfsr[3]  ^ lfsr[7]  ^ lfsr[9]  ^ lfsr[11] ^ lfsr[12] ^
                   lfsr[13] ^ lfsr[16] ^ lfsr[17] ^ lfsr[19];
advance64[15] =    lfsr[1]  ^ lfsr[2]  ^ lfsr[8]  ^ lfsr[10] ^ lfsr[11] ^ lfsr[12] ^
                   lfsr[14] ^ lfsr[15] ^ lfsr[16] ^ lfsr[17] ^ lfsr[18] ^ lfsr[20] ^ lfsr[22];
advance64[14] =    lfsr[0]  ^ lfsr[1]  ^ lfsr[7]  ^ lfsr[9]  ^ lfsr[10] ^ lfsr[11] ^
                   lfsr[13] ^ lfsr[14] ^ lfsr[15] ^ lfsr[16] ^ lfsr[17] ^ lfsr[19] ^ lfsr[21];
advance64[13] =    lfsr[0]  ^ lfsr[1]  ^ lfsr[8]  ^ lfsr[9]  ^ lfsr[10] ^ lfsr[12] ^
                   lfsr[13] ^ lfsr[15] ^ lfsr[16] ^ lfsr[17] ^ lfsr[18] ^ lfsr[22];
advance64[12] =    lfsr[0]  ^ lfsr[1]  ^ lfsr[6]  ^ lfsr[7]  ^ lfsr[8]  ^ lfsr[9]  ^
                   lfsr[11] ^ lfsr[12] ^ lfsr[15] ^ lfsr[16] ^ lfsr[20] ^ lfsr[21] ^ lfsr[22];
advance64[11] =    lfsr[0]  ^ lfsr[1]  ^ lfsr[5]  ^ lfsr[7]  ^ lfsr[8]  ^ lfsr[10] ^
                   lfsr[11] ^ lfsr[15] ^ lfsr[17] ^ lfsr[19] ^ lfsr[21] ^ lfsr[22];
advance64[10] =    lfsr[0]  ^ lfsr[1]  ^ lfsr[4]  ^ lfsr[7]  ^ lfsr[9]  ^ lfsr[10] ^
                   lfsr[16] ^ lfsr[17] ^ lfsr[18] ^ lfsr[21] ^ lfsr[22];
advance64[9]  =    lfsr[0]  ^ lfsr[1]  ^ lfsr[3]  ^ lfsr[8]  ^ lfsr[9]  ^ lfsr[14] ^
                   lfsr[15] ^ lfsr[16] ^ lfsr[21] ^ lfsr[22];
advance64[8]  =    lfsr[0]  ^ lfsr[1]  ^ lfsr[2]  ^ lfsr[6]  ^ lfsr[7]  ^ lfsr[8]  ^
                   lfsr[13] ^ lfsr[15] ^ lfsr[17] ^ lfsr[21] ^ lfsr[22];
advance64[7]  =    lfsr[0]  ^ lfsr[5]  ^ lfsr[7]  ^ lfsr[12] ^ lfsr[16] ^ lfsr[17] ^
                   lfsr[21] ^ lfsr[22];
advance64[6]  =    lfsr[1]  ^ lfsr[4]  ^ lfsr[11] ^ lfsr[14] ^ lfsr[15] ^ lfsr[16] ^
                   lfsr[17] ^ lfsr[21] ^ lfsr[22];
advance64[5]  =    lfsr[0]  ^ lfsr[3]  ^ lfsr[10] ^ lfsr[13] ^ lfsr[14] ^ lfsr[15] ^
                   lfsr[16] ^ lfsr[20] ^ lfsr[21];
advance64[4]  =    lfsr[1]  ^ lfsr[2]  ^ lfsr[6]  ^ lfsr[9]  ^ lfsr[12] ^ lfsr[13] ^
                   lfsr[15] ^ lfsr[17] ^ lfsr[19] ^ lfsr[22];
advance64[3]  =    lfsr[0]  ^ lfsr[1]  ^ lfsr[5]  ^ lfsr[8]  ^ lfsr[11] ^ lfsr[12] ^
                   lfsr[14] ^ lfsr[16] ^ lfsr[18] ^ lfsr[21];
advance64[2]  =    lfsr[0]  ^ lfsr[1]  ^ lfsr[4]  ^ lfsr[6]  ^ lfsr[7]  ^ lfsr[10] ^
                   lfsr[11] ^ lfsr[13] ^ lfsr[14] ^ lfsr[15] ^ lfsr[22];
advance64[1]  =    lfsr[0]  ^ lfsr[1]  ^ lfsr[3]  ^ lfsr[5]  ^ lfsr[9]  ^ lfsr[10] ^
                   lfsr[12] ^ lfsr[13] ^ lfsr[17] ^ lfsr[20] ^ lfsr[21] ^ lfsr[22];
advance64[0]  =    lfsr[0]  ^ lfsr[1]  ^ lfsr[2]  ^ lfsr[4]  ^ lfsr[6]  ^ lfsr[8]  ^
                   lfsr[9]  ^ lfsr[11] ^ lfsr[12] ^ lfsr[14] ^ lfsr[16] ^ lfsr[17] ^
                   lfsr[19] ^ lfsr[21] ^ lfsr[22];

end 
endfunction


function [0:63] lane0;         //-- get the next 64 bits from the 23 bit lfsr (doesn't advance the lfsr)
input [0:22] lfsr_q;
begin
  lane0[0]    = lfsr_q[22];
  lane0[1]    = lfsr_q[21];
  lane0[2]    = lfsr_q[20];
  lane0[3]    = lfsr_q[19];
  lane0[4]    = lfsr_q[18];
  lane0[5]    = lfsr_q[17];
  lane0[6]    = lfsr_q[16];
  lane0[7]    = lfsr_q[15];
  lane0[8]    = lfsr_q[14];
  lane0[9]    = lfsr_q[13];
  lane0[10]   = lfsr_q[12];
  lane0[11]   = lfsr_q[11];
  lane0[12]   = lfsr_q[10];
  lane0[13]   = lfsr_q[9];
  lane0[14]   = lfsr_q[8];
  lane0[15]   = lfsr_q[7];
  lane0[16]   = lfsr_q[6];
  lane0[17]   = lfsr_q[5];
  lane0[18]   = lfsr_q[4];
  lane0[19]   = lfsr_q[3];
  lane0[20]   = lfsr_q[2];
  lane0[21]   = lfsr_q[1];
  lane0[22]   = lfsr_q[0];
  lane0[23]   = lfsr_q[1]  ^ lfsr_q[6]  ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane0[24]   = lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21];
  lane0[25]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane0[26]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21];
  lane0[27]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[22];
  lane0[28]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[21];
  lane0[29]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[22];
  lane0[30]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[31]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[32]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane0[33]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[22];
  lane0[34]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[35]   = lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[36]   = lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane0[37]   = lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20];
  lane0[38]   = lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19];
  lane0[39]   = lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18];
  lane0[40]   = lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17];
  lane0[41]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16];
  lane0[42]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15];
  lane0[43]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane0[44]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21];
  lane0[45]   = lfsr_q[0]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane0[46]   = lfsr_q[1]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[47]   = lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane0[48]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane0[49]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[21];
  lane0[50]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[9]  ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[22];
  lane0[51]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[8]  ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[21];
  lane0[52]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[22];
  lane0[53]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[54]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[55]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[56]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[57]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[58]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[59]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[21];
  lane0[60]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[22];
  lane0[61]   = lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane0[62]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane0[63]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
end
endfunction

function [0:63] lane1;         //-- get the next 64 bits from the 23 bit lfsr (doesn't advance the lfsr)
input [0:22] lfsr_q;
begin
  lane1[0]    = lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane1[1]    = lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21];
  lane1[2]    = lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[20];
  lane1[3]    = lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[19];
  lane1[4]    = lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[18];
  lane1[5]    = lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[17];
  lane1[6]    = lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[16];
  lane1[7]    = lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[15];
  lane1[8]    = lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14];
  lane1[9]    = lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13];
  lane1[10]   = lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12];
  lane1[11]   = lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11];
  lane1[12]   = lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[10];
  lane1[13]   = lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[9];
  lane1[14]   = lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[8];
  lane1[15]   = lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[7];
  lane1[16]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[6];
  lane1[17]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[5];
  lane1[18]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane1[19]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21];
  lane1[20]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane1[21]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[22]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[23]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane1[24]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[22];
  lane1[25]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[26]   = lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[27]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane1[28]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20];
  lane1[29]   = lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane1[30]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane1[31]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20];
  lane1[32]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane1[33]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane1[34]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[18] ^ lfsr_q[22];
  lane1[35]   = lfsr_q[2]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[36]   = lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane1[37]   = lfsr_q[0]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane1[38]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane1[39]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane1[40]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[22];
  lane1[41]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[21];
  lane1[42]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[20];
  lane1[43]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane1[44]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[45]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane1[46]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane1[47]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane1[48]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[49]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[50]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[51]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21];
  lane1[52]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[22];
  lane1[53]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[54]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane1[55]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane1[56]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[57]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[58]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane1[59]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20];
  lane1[60]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane1[61]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane1[62]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane1[63]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
end
endfunction

function [0:63] lane2;         //-- get the next 64 bits from the 23 bit lfsr (doesn't advance the lfsr)
input [0:22] lfsr_q;
begin
  lane2[0]    = lfsr_q[16] ^ lfsr_q[21] ^ lfsr_q[22];
  lane2[1]    = lfsr_q[15] ^ lfsr_q[20] ^ lfsr_q[21];
  lane2[2]    = lfsr_q[14] ^ lfsr_q[19] ^ lfsr_q[20];
  lane2[3]    = lfsr_q[13] ^ lfsr_q[18] ^ lfsr_q[19];
  lane2[4]    = lfsr_q[12] ^ lfsr_q[17] ^ lfsr_q[18];
  lane2[5]    = lfsr_q[11] ^ lfsr_q[16] ^ lfsr_q[17];
  lane2[6]    = lfsr_q[10] ^ lfsr_q[15] ^ lfsr_q[16];
  lane2[7]    = lfsr_q[9]  ^ lfsr_q[14] ^ lfsr_q[15];
  lane2[8]    = lfsr_q[8]  ^ lfsr_q[13] ^ lfsr_q[14];
  lane2[9]    = lfsr_q[7]  ^ lfsr_q[12] ^ lfsr_q[13];
  lane2[10]   = lfsr_q[6]  ^ lfsr_q[11] ^ lfsr_q[12];
  lane2[11]   = lfsr_q[5]  ^ lfsr_q[10] ^ lfsr_q[11];
  lane2[12]   = lfsr_q[4]  ^ lfsr_q[9]  ^ lfsr_q[10];
  lane2[13]   = lfsr_q[3]  ^ lfsr_q[8]  ^ lfsr_q[9];
  lane2[14]   = lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[8];
  lane2[15]   = lfsr_q[1]  ^ lfsr_q[6]  ^ lfsr_q[7];
  lane2[16]   = lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[6];
  lane2[17]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane2[18]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21];
  lane2[19]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane2[20]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21];
  lane2[21]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[22];
  lane2[22]   = lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane2[23]   = lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane2[24]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane2[25]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19];
  lane2[26]   = lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
  lane2[27]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21];
  lane2[28]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20];
  lane2[29]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane2[30]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane2[31]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[22];
  lane2[32]   = lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane2[33]   = lfsr_q[1]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane2[34]   = lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane2[35]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane2[36]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane2[37]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[22];
  lane2[38]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[21];
  lane2[39]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[22];
  lane2[40]   = lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane2[41]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane2[42]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane2[43]   = lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane2[44]   = lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane2[45]   = lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20];
  lane2[46]   = lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19];
  lane2[47]   = lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18];
  lane2[48]   = lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17];
  lane2[49]   = lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16];
  lane2[50]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15];
  lane2[51]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14];
  lane2[52]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane2[53]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21];
  lane2[54]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane2[55]   = lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane2[56]   = lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane2[57]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane2[58]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19];
  lane2[59]   = lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
  lane2[60]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21];
  lane2[61]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20];
  lane2[62]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19];
  lane2[63]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
end
endfunction

function [0:63] lane3;         //-- get the next 64 bits from the 23 bit lfsr (doesn't advance the lfsr)
input [0:22] lfsr_q;
begin
  lane3[0]    = lfsr_q[15] ^ lfsr_q[20] ^ lfsr_q[22];
  lane3[1]    = lfsr_q[14] ^ lfsr_q[19] ^ lfsr_q[21];
  lane3[2]    = lfsr_q[13] ^ lfsr_q[18] ^ lfsr_q[20];
  lane3[3]    = lfsr_q[12] ^ lfsr_q[17] ^ lfsr_q[19];
  lane3[4]    = lfsr_q[11] ^ lfsr_q[16] ^ lfsr_q[18];
  lane3[5]    = lfsr_q[10] ^ lfsr_q[15] ^ lfsr_q[17];
  lane3[6]    = lfsr_q[9]  ^ lfsr_q[14] ^ lfsr_q[16];
  lane3[7]    = lfsr_q[8]  ^ lfsr_q[13] ^ lfsr_q[15];
  lane3[8]    = lfsr_q[7]  ^ lfsr_q[12] ^ lfsr_q[14];
  lane3[9]    = lfsr_q[6]  ^ lfsr_q[11] ^ lfsr_q[13];
  lane3[10]   = lfsr_q[5]  ^ lfsr_q[10] ^ lfsr_q[12];
  lane3[11]   = lfsr_q[4]  ^ lfsr_q[9]  ^ lfsr_q[11];
  lane3[12]   = lfsr_q[3]  ^ lfsr_q[8]  ^ lfsr_q[10];
  lane3[13]   = lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[9];
  lane3[14]   = lfsr_q[1]  ^ lfsr_q[6]  ^ lfsr_q[8];
  lane3[15]   = lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[7];
  lane3[16]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane3[17]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21];
  lane3[18]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[6]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane3[19]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21];
  lane3[20]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[22];
  lane3[21]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[22]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[23]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[24]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[25]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[20] ^ lfsr_q[21];
  lane3[26]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[22];
  lane3[27]   = lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[28]   = lfsr_q[1]  ^ lfsr_q[6]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane3[29]   = lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane3[30]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane3[31]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane3[32]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[22];
  lane3[33]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[21];
  lane3[34]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[22];
  lane3[35]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[36]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[37]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane3[38]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[22];
  lane3[39]   = lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[40]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane3[41]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane3[42]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19];
  lane3[43]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[8]  ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
  lane3[44]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[45]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane3[46]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane3[47]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[48]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[49]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[50]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[51]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[20] ^ lfsr_q[21];
  lane3[52]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[19] ^ lfsr_q[20];
  lane3[53]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane3[54]   = lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[55]   = lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane3[56]   = lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane3[57]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19];
  lane3[58]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18];
  lane3[59]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[22];
  lane3[60]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[21];
  lane3[61]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane3[62]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane3[63]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
end
endfunction

function [0:63] lane4;         //-- get the next 64 bits from the 23 bit lfsr (doesn't advance the lfsr)
input [0:22] lfsr_q;
begin
  lane4[0]    = lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane4[1]    = lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21];
  lane4[2]    = lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[20];
  lane4[3]    = lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19];
  lane4[4]    = lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18];
  lane4[5]    = lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[17];
  lane4[6]    = lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[16];
  lane4[7]    = lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[15];
  lane4[8]    = lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[14];
  lane4[9]    = lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[13];
  lane4[10]   = lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[12];
  lane4[11]   = lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[11];
  lane4[12]   = lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[10];
  lane4[13]   = lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[9];
  lane4[14]   = lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[8];
  lane4[15]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7];
  lane4[16]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[6];
  lane4[17]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[5];
  lane4[18]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane4[19]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[20]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[21]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[22]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[23]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[20] ^ lfsr_q[21];
  lane4[24]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[22];
  lane4[25]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[26]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane4[27]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane4[28]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane4[29]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[30]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[31]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane4[32]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20];
  lane4[33]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane4[34]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[35]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[36]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane4[37]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20];
  lane4[38]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane4[39]   = lfsr_q[0]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[40]   = lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[41]   = lfsr_q[0]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane4[42]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[22];
  lane4[43]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[21];
  lane4[44]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[22];
  lane4[45]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[21];
  lane4[46]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[20];
  lane4[47]   = lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane4[48]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[49]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane4[50]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane4[51]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[21];
  lane4[52]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[22];
  lane4[53]   = lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[54]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane4[55]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane4[56]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane4[57]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane4[58]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[22];
  lane4[59]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[60]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane4[61]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane4[62]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane4[63]   = lfsr_q[0]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
end
endfunction

function [0:63] lane5;         //-- get the next 64 bits from the 23 bit lfsr (doesn't advance the lfsr)
input [0:22] lfsr_q;
begin
  lane5[0]    = lfsr_q[16] ^ lfsr_q[22];
  lane5[1]    = lfsr_q[15] ^ lfsr_q[21];
  lane5[2]    = lfsr_q[14] ^ lfsr_q[20];
  lane5[3]    = lfsr_q[13] ^ lfsr_q[19];
  lane5[4]    = lfsr_q[12] ^ lfsr_q[18];
  lane5[5]    = lfsr_q[11] ^ lfsr_q[17];
  lane5[6]    = lfsr_q[10] ^ lfsr_q[16];
  lane5[7]    = lfsr_q[9]  ^ lfsr_q[15];
  lane5[8]    = lfsr_q[8]  ^ lfsr_q[14];
  lane5[9]    = lfsr_q[7]  ^ lfsr_q[13];
  lane5[10]   = lfsr_q[6]  ^ lfsr_q[12];
  lane5[11]   = lfsr_q[5]  ^ lfsr_q[11];
  lane5[12]   = lfsr_q[4]  ^ lfsr_q[10];
  lane5[13]   = lfsr_q[3]  ^ lfsr_q[9];
  lane5[14]   = lfsr_q[2]  ^ lfsr_q[8];
  lane5[15]   = lfsr_q[1]  ^ lfsr_q[7];
  lane5[16]   = lfsr_q[0]  ^ lfsr_q[6];
  lane5[17]   = lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane5[18]   = lfsr_q[0]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21];
  lane5[19]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane5[20]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21];
  lane5[21]   = lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[22];
  lane5[22]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[21];
  lane5[23]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[20];
  lane5[24]   = lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane5[25]   = lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane5[26]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20];
  lane5[27]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19];
  lane5[28]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
  lane5[29]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21];
  lane5[30]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane5[31]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane5[32]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane5[33]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane5[34]   = lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane5[35]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane5[36]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane5[37]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[19] ^ lfsr_q[22];
  lane5[38]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[18] ^ lfsr_q[21];
  lane5[39]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[22];
  lane5[40]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane5[41]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane5[42]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane5[43]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane5[44]   = lfsr_q[0]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane5[45]   = lfsr_q[1]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[21] ^ lfsr_q[22];
  lane5[46]   = lfsr_q[0]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21];
  lane5[47]   = lfsr_q[1]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[22];
  lane5[48]   = lfsr_q[0]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[21];
  lane5[49]   = lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[22];
  lane5[50]   = lfsr_q[0]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[21];
  lane5[51]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[22];
  lane5[52]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[21];
  lane5[53]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[22];
  lane5[54]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[21];
  lane5[55]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[20];
  lane5[56]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane5[57]   = lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane5[58]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane5[59]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane5[60]   = lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane5[61]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane5[62]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20];
  lane5[63]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19];
end
endfunction

function [0:63] lane6;         //-- get the next 64 bits from the 23 bit lfsr (doesn't advance the lfsr)
input [0:22] lfsr_q;
begin
  lane6[0]    = lfsr_q[15] ^ lfsr_q[21] ^ lfsr_q[22];
  lane6[1]    = lfsr_q[14] ^ lfsr_q[20] ^ lfsr_q[21];
  lane6[2]    = lfsr_q[13] ^ lfsr_q[19] ^ lfsr_q[20];
  lane6[3]    = lfsr_q[12] ^ lfsr_q[18] ^ lfsr_q[19];
  lane6[4]    = lfsr_q[11] ^ lfsr_q[17] ^ lfsr_q[18];
  lane6[5]    = lfsr_q[10] ^ lfsr_q[16] ^ lfsr_q[17];
  lane6[6]    = lfsr_q[9]  ^ lfsr_q[15] ^ lfsr_q[16];
  lane6[7]    = lfsr_q[8]  ^ lfsr_q[14] ^ lfsr_q[15];
  lane6[8]    = lfsr_q[7]  ^ lfsr_q[13] ^ lfsr_q[14];
  lane6[9]    = lfsr_q[6]  ^ lfsr_q[12] ^ lfsr_q[13];
  lane6[10]   = lfsr_q[5]  ^ lfsr_q[11] ^ lfsr_q[12];
  lane6[11]   = lfsr_q[4]  ^ lfsr_q[10] ^ lfsr_q[11];
  lane6[12]   = lfsr_q[3]  ^ lfsr_q[9]  ^ lfsr_q[10];
  lane6[13]   = lfsr_q[2]  ^ lfsr_q[8]  ^ lfsr_q[9];
  lane6[14]   = lfsr_q[1]  ^ lfsr_q[7]  ^ lfsr_q[8];
  lane6[15]   = lfsr_q[0]  ^ lfsr_q[6]  ^ lfsr_q[7];
  lane6[16]   = lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane6[17]   = lfsr_q[0]  ^ lfsr_q[4]  ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21];
  lane6[18]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane6[19]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21];
  lane6[20]   = lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[22];
  lane6[21]   = lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[21];
  lane6[22]   = lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[20];
  lane6[23]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[19];
  lane6[24]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[18];
  lane6[25]   = lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[20] ^ lfsr_q[22];
  lane6[26]   = lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[19] ^ lfsr_q[21];
  lane6[27]   = lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[18] ^ lfsr_q[20];
  lane6[28]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[17] ^ lfsr_q[19];
  lane6[29]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[16] ^ lfsr_q[18];
  lane6[30]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[15] ^ lfsr_q[17];
  lane6[31]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane6[32]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane6[33]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane6[34]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane6[35]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane6[36]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane6[37]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane6[38]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane6[39]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane6[40]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane6[41]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane6[42]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane6[43]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane6[44]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane6[45]   = lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane6[46]   = lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane6[47]   = lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane6[48]   = lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19];
  lane6[49]   = lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18];
  lane6[50]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17];
  lane6[51]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16];
  lane6[52]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15];
  lane6[53]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane6[54]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane6[55]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane6[56]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane6[57]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane6[58]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane6[59]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane6[60]   = lfsr_q[0]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[21] ^ lfsr_q[22];
  lane6[61]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[21] ^ lfsr_q[22];
  lane6[62]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[20] ^ lfsr_q[21];
  lane6[63]   = lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[22];
end
endfunction

function [0:63] lane7;         //-- get the next 64 bits from the 23 bit lfsr (doesn't advance the lfsr)
input [0:22] lfsr_q;
begin
  lane7[0]    = lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[22];
  lane7[1]    = lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[21];
  lane7[2]    = lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[20];
  lane7[3]    = lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[19];
  lane7[4]    = lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[18];
  lane7[5]    = lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[17];
  lane7[6]    = lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[16];
  lane7[7]    = lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[15];
  lane7[8]    = lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[14];
  lane7[9]    = lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[13];
  lane7[10]   = lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[12];
  lane7[11]   = lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[11];
  lane7[12]   = lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[10];
  lane7[13]   = lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[9];
  lane7[14]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[8];
  lane7[15]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[7];
  lane7[16]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[6];
  lane7[17]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[22];
  lane7[18]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[19]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[20]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[21]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[22]   = lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[17] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[23]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[21];
  lane7[24]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[20];
  lane7[25]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane7[26]   = lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[27]   = lfsr_q[1]  ^ lfsr_q[6]  ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane7[28]   = lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
  lane7[29]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane7[30]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane7[31]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[22];
  lane7[32]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[21];
  lane7[33]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[22];
  lane7[34]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[35]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[36]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane7[37]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[22];
  lane7[38]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[39]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[40]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
  lane7[41]   = lfsr_q[0]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[19] ^ lfsr_q[22];
  lane7[42]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[43]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane7[44]   = lfsr_q[3]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane7[45]   = lfsr_q[2]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[21];
  lane7[46]   = lfsr_q[1]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20];
  lane7[47]   = lfsr_q[0]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[19];
  lane7[48]   = lfsr_q[1]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
  lane7[49]   = lfsr_q[0]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21];
  lane7[50]   = lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
  lane7[51]   = lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21];
  lane7[52]   = lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[22];
  lane7[53]   = lfsr_q[1]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[21];
  lane7[54]   = lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[20];
  lane7[55]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
  lane7[56]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
  lane7[57]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[22];
  lane7[58]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[21];
  lane7[59]   = lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[22];
  lane7[60]   = lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
  lane7[61]   = lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
  lane7[62]   = lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
  lane7[63]   = lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[21];
end
endfunction

    wire [2:0]   tsm_din;
    (*mark_debug = "true"*) (*keep = "true"*)reg  [2:0]   tsm_q = 3'b110;
    wire [7:0]   good_tx_lanes_din;
    reg [2:0]   tsm_int;
    reg  [7:0]   good_tx_lanes_q;
    wire [8:0]   seq_cnt_din;
    reg  [8:0]   seq_cnt_q; 
    wire [3:0]   a_cnt_din;
 (*mark_debug = "true"*)   reg  [3:0]   a_cnt_q;
    wire [3:0]   b_cnt_din;
  (*mark_debug = "true"*)  reg  [3:0]   b_cnt_q;
    wire [9:0]   timer_din;
    reg  [9:0]   timer_q;
    wire [0:22]  lfsr_din;
    reg  [0:22]  lfsr_q ;
    wire         dl_reset_din;
    reg          dl_reset_q;
    wire         dl_reset_d1_din;
    reg          dl_reset_d1_q;
    wire         det_sync_din;
    reg          det_sync_q;
    wire         flt_ready_din;
 (*mark_debug = "true"*)   reg          flt_ready_q;
    wire         good_tx_outsides_din;
    reg          good_tx_outsides_q;
    wire         good_tx_insides_din;
    reg          good_tx_insides_q;
    wire         good_rx_outsides_din;
    reg          good_rx_outsides_q;
    wire         good_rx_insides_din;
    reg          good_rx_insides_q;
    wire         x4_not_x8_tx_mode_din;
    reg          x4_not_x8_tx_mode_q;    
    wire         x2_tx_mode_din;
    reg          x2_tx_mode_q;    
    wire [7:0]   disabled_tx_lanes_din;
    reg  [7:0]   disabled_tx_lanes_q;
    wire [7:0]   enabled_rx_lanes_din;
    reg  [7:0]   enabled_rx_lanes_q;
    wire [7:0]   disabled_rx_lanes_din;
    reg  [7:0]   disabled_rx_lanes_q;
    wire [3:0]   dis_lane_cnt_din;
    reg  [3:0]   dis_lane_cnt_q;
    wire         sync_pattern_din;
    reg          sync_pattern_q;
    reg          reset_q; 
    wire         reset_din;
    reg          reset_d1_q; 
    wire         reset_d1_din;
    wire         start_train;
 (*mark_debug = "true"*)   reg          start_retrain_q; 
    wire         start_retrain_din;
    reg [2:0]    start_retrain_dly_q;
    wire [2:0]   start_retrain_dly_din;
    

    wire         pat_a_done;
    wire         pat_b_done;
    wire         sync_done;
    wire         ts1_done;
    wire         ts2_done;
    wire         ts3_done;
    wire         ts4_done;
    wire         block_locked;

 (*mark_debug = "true"*)   reg         ts1_done_q;
  (*mark_debug = "true"*)  reg         ts2_done_q;
   (*mark_debug = "true"*) reg         ts3_done_q;
    (*mark_debug = "true"*)reg         ts4_done_q;
    (*mark_debug = "true"*) reg        block_locked_q;

    wire         tsm_advance;
    wire         tpulse;
    wire         det_a;
    wire         det_b;
    wire         quick_sim;
    wire         lfsr_advance;
    wire         good_tx_insides;
    wire         good_tx_outsides;
    wire         good_rx_insides;
    wire         good_rx_outsides;
    wire         sync_pattern;
    wire         ctl_gb_train_int;
    wire  [6:0]  ctl_gb_seq_int;
    wire  [7:0]  rx_lane_mask;
    wire         outside_rx_outside_tx_trained;
    wire         outside_rx_inside_tx_trained;
    wire         inside_rx_outside_tx_trained;
    wire         inside_rx_inside_tx_trained;
    wire  [31:0] dlx_version_din;
    wire         tsm_state2_to_3_din;
    wire         tsm_state2_to_3_d1_din;
    wire         tsm_state4_to_5_din;
    wire         tsm_state4_to_5_d1_din;
    wire         tsm_state6_to_1_din;
    wire         tsm_state6_to_1_d1_din;
    reg          tsm_state2_to_3_q;
    reg          tsm_state2_to_3_d1_q;
    reg          tsm_state4_to_5_q;
    reg          tsm_state4_to_5_d1_q;
    reg          tsm_state6_to_1_q;
    reg          tsm_state6_to_1_d1_q;
    wire [7:0]   EDPL_bad_lane_din;
    reg  [7:0]   EDPL_bad_lane_q;
    wire [7:0]   EDPL_kill_lane_pend_din;
    reg  [7:0]   EDPL_kill_lane_pend_q;
    wire         EDPL_reset_cnts_din;
    reg          EDPL_reset_cnts_q ;
    wire         EDPL_thres_reached_din;
    reg          EDPL_thres_reached_q;
    wire [44:0]  EDPL_time_window;
    wire [43:0]  EDPL_timer_din;
    wire         EDPL_timer_inc;
    reg  [43:0]  EDPL_timer_q;
    wire         EDPL_timer_reset;
    wire [5:0]   EDPL_compare_din;
    reg  [5:0]   EDPL_compare_q;
    wire         EDPL_time_window_disable;
    wire         EDPL_window_hit;
    reg [2:0]    retrain_pending_q;
    wire [2:0]   retrain_pending_din;
    // Preserve this register so we can use it to inject randomn timing constraints into Vivado runs. 
   (* dont_touch = "yes" *)
    reg   [31:0] dlx_version_q;
    wire [5:0]   dl_deskew_version;
    reg          tick_1us_q;
    wire         tick_1us_din;
    reg [8:0]    tick_1us_cntr_q;
    wire [8:0]   tick_1us_cntr_din;
    wire [7:0]   mask_pattern_a, mask_pattern_b;

    //-- read only variable via config memory: DVSEC
    assign dlx_version_din[31:0] = `DLX_VERSION_NUMBER;
    assign ro_dlx_version[31:0]  = dlx_version_q[31:0];
    assign quick_sim = 1'b0;

    assign lfsr_din[0:22]              = reset_q      ? 23'b01111000101110110010010:
                                         lfsr_advance ? advance64(lfsr_q[0:22]) :
                                                        lfsr_q[0:22];         //-- advance LFSR 64 bits

    assign ctl_q0_lane_scrambler[63:0] = lane0(lfsr_q[0:22]);                         //-- get the PseudoRandom Bit Sequence for this block
    assign ctl_q1_lane_scrambler[63:0] = lane1(lfsr_q[0:22]);                         //-- get the PseudoRandom Bit Sequence for this block
    assign ctl_q2_lane_scrambler[63:0] = lane2(lfsr_q[0:22]);                         //-- get the PseudoRandom Bit Sequence for this block
    assign ctl_q3_lane_scrambler[63:0] = lane3(lfsr_q[0:22]);                         //-- get the PseudoRandom Bit Sequence for this block
    assign ctl_q4_lane_scrambler[63:0] = lane4(lfsr_q[0:22]);                         //-- get the PseudoRandom Bit Sequence for this block
    assign ctl_q5_lane_scrambler[63:0] = lane5(lfsr_q[0:22]);                         //-- get the PseudoRandom Bit Sequence for this block
    assign ctl_q6_lane_scrambler[63:0] = lane6(lfsr_q[0:22]);                         //-- get the PseudoRandom Bit Sequence for this block
    assign ctl_q7_lane_scrambler[63:0] = lane7(lfsr_q[0:22]);                         //-- get the PseudoRandom Bit Sequence for this block
    assign lfsr_advance                = ((tsm_q[2:0] == 3'b111) & x2_tx_mode_q)        ? ~seq_cnt_q[6] :
                                         ((tsm_q[2:0] == 3'b111) & x4_not_x8_tx_mode_q) ? ~seq_cnt_q[7] :
                                                                                          ~seq_cnt_q[8];

    assign reset_din = dlx_reset;
    assign reset_d1_din = reset_q;
    assign start_train = reset_d1_q & ~reset_q;
    assign start_retrain_din = rx_tx_retrain | error_no_fwd_progress | user_retrain
                               | (retrain_pending_q[2] & ~start_retrain_q);
    assign start_retrain_dly_din[2:0] = {start_retrain_dly_q[1:0],start_retrain_q};

    assign tsm_state2_to_3_din      = tsm_state2_to_3;
    assign tsm_state2_to_3_d1_din   = tsm_state2_to_3_q;
    assign tsm_state6_to_1_din      = tsm_state6_to_1;
    assign tsm_state6_to_1_d1_din   = tsm_state6_to_1_q;
    assign tsm_state4_to_5_din      = tsm_state4_to_5;
    assign tsm_state4_to_5_d1_din   = tsm_state4_to_5_q;
 always @(*)
begin
   case (tsm_q[2:0])
        3'b000 : tsm_int[2:0] =
                                start_train     ? 3'b001:     //-- dl in reset
                                                  3'b000;

        3'b001 : tsm_int[2:0] =
                                dlx_reset       ? 3'b110:     // -- dl going into reset
                                pat_a_done      ? 3'b010:     // -- pattern a detected for appropriate time
                                                  3'b001;  

        3'b010 : tsm_int[2:0] =
                                dlx_reset       ? 3'b110:     // -- dl going into reset
                     ~tsm_state2_to_3_d1_q      ? 3'b010:
                                pat_b_done      ? 3'b011:     // -- pattern b detected for appropriate time
                                                  3'b010;  

        3'b011 : tsm_int[2:0]  =
                                 dlx_reset       ? 3'b110:     // -- dl going into reset
                                 sync_done       ? 3'b100:     // -- sync done
                                                   3'b011;  

        3'b100 : tsm_int[2:0]  =
                                 dlx_reset       ? 3'b110:     // -- dl going into reset
                    ~tsm_state4_to_5_d1_q        ? 3'b100 :    //--for stepping through training
                    rx_tx_deskew_done & block_locked &           // -- block lock and deskew done, and 
                    (ts1_done | ts2_done)        ? 3'b101:     // -- receiving TS1's or TS2's (other side may block lock and send TS2's before we block lock)
                                                   3'b100;  

        3'b101 : tsm_int[2:0]  =
                                 dlx_reset       ? 3'b110:     // -- dl going into reset
                                 start_retrain_q ? 3'b100:     // -- start retraining 
                                 ts2_done        ? 3'b110:     // -- ts2 done
                                                   3'b101;  
  
        3'b110 : tsm_int[2:0]  =
                                 dlx_reset       ? 3'b110:     // -- dl going into reset
                                 start_retrain_q ? 3'b100:     // -- start retraining 
                     tsm_state6_to_1_d1_q        ? 3'b001 :    //-- for stepping through training
                 (tsm_advance & ts3_done & flt_ready_q)
                                                 ? 3'b111:     // -- ts3 done
                                                   3'b110;  

        3'b111 : tsm_int[2:0]  =
                                 dlx_reset       ? 3'b110:     // -- dl going into reset
                                 start_retrain_q ? 3'b100:     // -- start retraining 
                                                   3'b111;  
      endcase
end

    assign tsm_din[2:0] = reset_q ? 3'b110 : tsm_int[2:0];
    assign ltch_lane_cfg = (tsm_q[2:0] != 3'b100) && (tsm_int[2:0] == 3'b100);
//-- wait for a lot of pattern a's, this is so the transeiver has a chance to lock on all lanes
    assign pat_a_done              = tsm_advance & |(a_cnt_q[3:0]);
    assign pat_b_done              = tsm_advance & (det_sync_q | (b_cnt_q[3] & b_cnt_q[2]));        //-- only need 16, but there are alignment cases, so send ~20
//--    assign sync_done               = (tsm_advance &  det_sync_q);
    assign sync_done               = (tsm_advance &  (tsm_q[2:0] == 3'b011));  //-- ljl 10/18/2017.
    assign ts1_done                = ((rx_tx_TS1[7:0]        | disabled_rx_lanes_q[7:0]) == 8'b11111111) | ((rx_tx_TS2[7:0]  | disabled_rx_lanes_q[7:0]) == 8'b11111111);
    assign ts2_done                = ((rx_tx_TS2[7:0]        | disabled_rx_lanes_q[7:0]) == 8'b11111111) | ((rx_tx_TS3[7:0]  | disabled_rx_lanes_q[7:0]) == 8'b11111111);
    assign ts3_done                = (((rx_tx_TS3[7:0]       | disabled_rx_lanes_q[7:0]) == 8'b11111111) );
    assign ts4_done                = (((rx_tx_TS3[7:0]       | disabled_rx_lanes_q[7:0]) == 8'b11111111) | rx_tx_linkup);
    assign block_locked            = ((rx_tx_block_lock[7:0] | disabled_rx_lanes_q[7:0]) == 8'b11111111);

    assign timer_din[9:0]          = tpulse ? 10'b0 : timer_q[9:0] + 10'b0000000001;
    assign pulse_1us               = (timer_q[9:0] == 10'd402);
    assign tpulse                  = (timer_q[9:0] == 10'd402) | (quick_sim & (timer_q[9:0] == 10'd20)) ;


    assign mask_pattern_a = {~(x8_degrade_to_inside | x4_degrade_to_inside) & rx_tx_pattern_a[7],
                             (x8_mode | x8_degrade_to_inside) & rx_tx_pattern_a[6],
                             ~(x8_degrade_to_inside |  x4_degrade_to_outside) & rx_tx_pattern_a[5],
                             (x8_mode | x8_degrade_to_inside) & rx_tx_pattern_a[4],
                             (x8_mode | x8_degrade_to_inside) & rx_tx_pattern_a[3],
                             ~(x8_degrade_to_inside | x4_degrade_to_outside) & rx_tx_pattern_a[2],
                             (x8_mode | x8_degrade_to_inside) & rx_tx_pattern_a[1],
                             ~(x8_degrade_to_inside | x4_degrade_to_inside) & rx_tx_pattern_a[0]};
    assign mask_pattern_b = {~(x8_degrade_to_inside | x4_degrade_to_inside) & rx_tx_pattern_b[7],
                             (x8_mode | x8_degrade_to_inside) & ~x4OL_mode & rx_tx_pattern_b[6],
                             ~(x8_degrade_to_inside |  x4_degrade_to_outside) & rx_tx_pattern_b[5],
                             ~(x8_degrade_to_inside |  x4_degrade_to_outside) & rx_tx_pattern_b[4],
                             (x8_mode | x8_degrade_to_inside) & rx_tx_pattern_b[3],
                             ~(x8_degrade_to_inside | x4_degrade_to_outside) & rx_tx_pattern_b[2],
                             (x8_mode | x8_degrade_to_inside) & rx_tx_pattern_b[1],
                             ~(x8_degrade_to_inside | x4_degrade_to_inside) & rx_tx_pattern_b[0]};                             
    assign det_a                   = |(mask_pattern_a[7:0]);
    assign det_b                   = |(mask_pattern_b[7:0]);
    assign det_sync_din            =  dlx_reset  ? 1'b0  :
                                                   ((tsm_q[2:1] == 2'b01) | (tsm_q[2] == 1'b1)) & (det_sync_q | (|(rx_tx_sync[7:0])));

    assign a_cnt_din[3:0]          =   dlx_reset       ? 4'b0             :
                                     (~det_a & ~det_b) ? 4'b0             :
                                       tpulse          ? a_cnt_q[3:0] + 4'b0001 :
                                                         a_cnt_q[3:0]     ;
                                                         
    assign b_cnt_din[3:0]          =   dlx_reset       ? 4'b0             :
                                      ~det_b           ? 4'b0             :
                                       tpulse          ? b_cnt_q[3:0] + 4'b0001 :
                                                         b_cnt_q[3:0]     ;
                                                         

    assign ctl_que_reset               = (dlx_reset | dl_reset_q);                             
    assign ctl_gb_tx_a_pattern         = (tsm_q[2:0] == 3'b001) | (tsm_q[2:0] == 3'b010) | (tsm_q[2:0] == 3'b011);               
    assign ctl_gb_tx_b_pattern         = (tsm_q[2:1] == 2'b01 ) & (seq_cnt_q[4:2] == 3'b111);               
    assign sync_pattern                = (tsm_q[2:0] == 3'b011) & (seq_cnt_q[7:2] == 6'b111111) & ~sync_pattern_q;
    assign ctl_gb_tx_sync_pattern      = sync_pattern;
    assign sync_pattern_din            = sync_pattern;

    assign ctl_que_tx_ts1              = (tsm_q[2:0] == 3'b100);                    
    assign ctl_que_tx_ts2              = (tsm_q[2:0] == 3'b101);                    
    assign ctl_que_tx_ts3              = (tsm_q[2:0] == 3'b110);                    
    assign ctl_gb_train_int            = ~(tsm_q[2:0] == 3'b111);
    assign ctl_gb_train                = ctl_gb_train_int;


    assign flt_ready_din               = ((ts3_done & (seq_cnt_q[7:2] == 6'b111111)) | flt_ready_q) & ~dl_reset_q & ~start_retrain_q & (tsm_q[2:1] == 2'b11);

    assign ctl_flt_train_done          = flt_ready_q;                      

    assign ctl_gb_reset                = (dlx_reset | dl_reset_q);           


    assign tx_rx_training              = ((tsm_q[2] & ~(tsm_q[2:0] == 3'b111) & det_sync_q) | ((tsm_q[2:0] == 3'b111) & ~rx_tx_linkup)) & ~dlx_reset & ~(~start_retrain_q & rx_tx_retrain);       //-- pulse off for retraining
      

    assign train_ts2                   = (tsm_q[2:0] == 3'b101);
    assign train_ts67                  = (tsm_q[2:1] == 2'b11);
    assign tx_rx_phy_training          = (~(tsm_q[2] & (&(io_pb_o0_rx_init_done[7:0])) & det_sync_q));
    assign pb_io_o0_rx_run_lane[7:0]   = {8{(tsm_q[2] & det_sync_q)}};

    assign ctl_que_use_nghbr_outside[3]  = good_tx_outsides_q & x2_tx_mode_q & seq_cnt_q[1] &  seq_cnt_q[0];
    assign ctl_que_use_nghbr_outside[2]  = good_tx_outsides_q & x2_tx_mode_q & seq_cnt_q[1] & ~seq_cnt_q[0];
    assign ctl_que_use_nghbr_outside[1]  = good_tx_outsides_q & x4_not_x8_tx_mode_q ? seq_cnt_q[1]:
    	                                   good_tx_outsides_q & x2_tx_mode_q ? ~seq_cnt_q[1] & seq_cnt_q[0] :
                                                                                 1'b0         ;

    assign ctl_que_use_nghbr_inside[3]   = good_tx_insides_q  & x2_tx_mode_q & seq_cnt_q[1] &  seq_cnt_q[0];                                                                                 
    assign ctl_que_use_nghbr_inside[2]   = good_tx_insides_q  & x2_tx_mode_q & seq_cnt_q[1] & ~seq_cnt_q[0];                                                                                 
    assign ctl_que_use_nghbr_inside[1]   = good_tx_insides_q  & x4_not_x8_tx_mode_q ? seq_cnt_q[1]:
    	                                   good_tx_insides_q  & x2_tx_mode_q ? ~seq_cnt_q[1] & seq_cnt_q[0] :
                                                                                 1'b0         ;

    assign ctl_gb_tx_zeros[7:0]        = disabled_tx_lanes_q[7:0];        
    assign ctl_que_tx_ts0              = 1'b0;          
    assign ctl_que_good_lanes[15:0]    = x4OL_mode | x4_degrade_to_inside | x4_degrade_to_outside ?
                                       {8'b0,4'b0001, good_rx_insides_q, good_rx_outsides_q,2'b00} : 
                                       {8'b0,4'b0010, good_rx_insides_q, good_rx_outsides_q,2'b00};         // DL3.1 format          


   generate
      if (GEMINI_NOT_APOLLO == 1) begin
        assign dl_deskew_version = 6'b001000;
      end
      else begin
        assign dl_deskew_version = 6'b001001;
      end
   endgenerate

   assign ctl_que_deskew[23:0]        = {4'b0000,            //--23:20
                                         2'b00  ,            //--19:18 
                                         (x8_mode | x8_degrade_to_outside | x8_degrade_to_inside),         // x8 supported
                                         (x4OL_mode | x4_degrade_to_outside | x4_degrade_to_inside),          // x4OL supported
                                         ~(x8_mode | x4OL_mode), // 15 degrade supported
                                         1'b0,              //--14
                                         dl_deskew_version,  //--13:8  (version number, Gemini Sends x8)
                                         1'b0,               //--7
                                         rx_tx_tx_lane_swap, //--6
                                         6'b000000};         //--5:0

    assign good_tx_lanes_din[7:0]      = rx_tx_TS1[7:0] | good_tx_lanes_q[7:0];

    assign good_tx_insides                = (~(disabled_tx_lanes_q[6] | disabled_tx_lanes_q[4] | disabled_tx_lanes_q[3] | disabled_tx_lanes_q[1]) & (x8_mode | x8_degrade_to_inside)) |
                                            (~(disabled_tx_lanes_q[5] | disabled_tx_lanes_q[2]) & (x4OL_mode | x4_degrade_to_inside));
    assign good_tx_outsides               = (~(disabled_tx_lanes_q[7] | disabled_tx_lanes_q[5] | disabled_tx_lanes_q[2] | disabled_tx_lanes_q[0]) & (x8_mode | x8_degrade_to_outside)) |
                                            (~(disabled_tx_lanes_q[7] | disabled_tx_lanes_q[0]) & (x4OL_mode | x4_degrade_to_outside));

    assign good_rx_insides                = (enabled_rx_lanes_q[6] & enabled_rx_lanes_q[4] & enabled_rx_lanes_q[3] & enabled_rx_lanes_q[1] & (x8_mode | x8_degrade_to_inside)) |
                                            (enabled_rx_lanes_q[5] & enabled_rx_lanes_q[2] & (x4OL_mode | x4_degrade_to_inside));
    assign good_rx_outsides               = (enabled_rx_lanes_q[7] & enabled_rx_lanes_q[5] & enabled_rx_lanes_q[2] & enabled_rx_lanes_q[0] & (x8_mode | x8_degrade_to_outside)) |
                                            (enabled_rx_lanes_q[7] & enabled_rx_lanes_q[0] & (x4OL_mode | x4_degrade_to_outside));

    assign good_tx_insides_din            = (dlx_reset | dl_reset_q) ? 1'b0                   :
                                                                    good_tx_insides;

    assign good_tx_outsides_din           = (dlx_reset | dl_reset_q) ? 1'b0                   :
                                                                    good_tx_outsides;

    assign good_rx_insides_din            = (dlx_reset | dl_reset_q) ? 1'b0                   :
                                                                    good_rx_insides;

    assign good_rx_outsides_din           = (dlx_reset | dl_reset_q) ? 1'b0                   :
                                                                    good_rx_outsides;

    assign x4_not_x8_tx_mode_din       = (((good_tx_insides_q & ~good_tx_outsides_q) | (~good_tx_insides_q & good_tx_outsides_q)) & (x8_mode | x8_degrade_to_inside | x8_degrade_to_outside)) |
                                         (good_tx_insides_q & good_tx_outsides_q & x4OL_mode);
    
    assign x2_tx_mode_din = ((good_tx_insides_q & ~good_tx_outsides_q) | (~good_tx_insides_q & good_tx_outsides_q)) & (x4_degrade_to_inside | x4_degrade_to_outside);                                         
                                         
//--  this needs to run at full speed for either mode
    assign ctl_gb_seq_int[6:0] = x2_tx_mode_q & ~ctl_gb_train_int        ? seq_cnt_q[6:0]:
                                 x4_not_x8_tx_mode_q & ~ctl_gb_train_int ? seq_cnt_q[7:1]:
                                                                           seq_cnt_q[8:2];

//-- 8/8 during retrain, ctl_gb_train_int can cause ctl_gb_seq_int to glitch.  we don't go back to x8 on retrain, so keep mux locked up.
//--    assign x4_not_x8_tx_mux_lock_din = ((x4_not_x8_tx_mode_q & ~ctl_gb_train_int) | x4_not_x8_tx_mux_lock_q) & ~(dlx_reset | dl_reset_q);

    assign ctl_gb_seq  = ctl_gb_seq_int;

    assign ctl_que_stall               = ctl_gb_seq_int[6];                     
//--    assign tsm_advance                 = (seq_cnt_q[7:1] == 7'b1000001);                     
    assign tsm_advance                 = tsm_q[2] ? (seq_cnt_q[8:2] == 7'b1000001) :
                                                    (seq_cnt_q[8:2] == 7'b0111111) ;                    

//-- in x8 mode need to stall 2 cycles after 64,  in x4 mode do the same except stall every other cycle in addition
//-- in x2 mode need to stall 3 out of every 4 cycles
    assign ctl_flt_stall               = x2_tx_mode_q && (seq_cnt_q[6:0] == 7'b1000001) ? 1'b0 :
                                         x2_tx_mode_q && (seq_cnt_q[6:0] != 7'b1000001) ? (seq_cnt_q[6:0] == 7'b0111111) || (seq_cnt_q[6:0] == 7'b1000000) || ~(seq_cnt_q[1] & seq_cnt_q[0]):
                                         x4_not_x8_tx_mode_q  ? (seq_cnt_q[7:1] == 7'b0111100) || (seq_cnt_q[7:1] == 7'b0111101) || ~seq_cnt_q[1]:  // -- two cycles early to keep things pipelined
                                                                (seq_cnt_q[8:2] == 7'b0111100) || (seq_cnt_q[8:2] == 7'b0111101)                ;  // -- two cycles early to keep things pipelined

    assign ctl_x4_not_x8_tx_mode = x4_not_x8_tx_mode_q;
    assign ctl_x2_tx_mode = x2_tx_mode_q;

//-- go to 8 bits to support x4 mode.  need to stall every other cycle in this mode, so needed the low order bit.
//-- 26/07/19 go to 9 bits to support x2 mode. need to stall 3 cycles in 4 in this mode
    assign seq_cnt_din[8:0]            =  dlx_reset | dl_reset_q                                                                     ?  9'b100000000         :
                                         ~x4_not_x8_tx_mode_q & ~x2_tx_mode_q & (seq_cnt_q[8:2] == 7'b1000001)                       ?  9'b000000000         :
                                          (x4_not_x8_tx_mode_q | x2_tx_mode_q) &  ctl_gb_train_int & (seq_cnt_q[8:2] == 7'b1000001)  ?  9'b000000000         :
                                          x4_not_x8_tx_mode_q & ~ctl_gb_train_int & (seq_cnt_q[7:1] == 7'b1000001)                   ?  9'b000000000         :
                                          x4_not_x8_tx_mode_q & ~ctl_gb_train_int                                                    ?  (seq_cnt_q[8:0] + 9'b000000010):
                                          x2_tx_mode_q & ~ctl_gb_train_int & (seq_cnt_q[6:0] == 7'b1000001)                          ?  9'b000000000         :
                                          x2_tx_mode_q & ~ctl_gb_train_int                                                           ?  (seq_cnt_q[8:0] + 9'b000000001):
                                                                                                                                        (seq_cnt_q[8:0] + 9'b000000100);            //-- x8 mode
    assign dl_reset_din                = dlx_reset;
    assign dl_reset_d1_din             = dl_reset_q;

//-- ************** To prevent a single bit error on the TS3 packet from disabling lanes make sure two lanes say the xmit lanes are bad
//-- this is set outside if the x8 is downgraded to a x4 (it was suppose to train at a x8)



assign outside_rx_outside_tx_trained = ln0_rx_tx_last_byte_ts3[2] | ln2_rx_tx_last_byte_ts3[2];
assign outside_rx_inside_tx_trained  = ln0_rx_tx_last_byte_ts3[3] | ln2_rx_tx_last_byte_ts3[3];
assign inside_rx_outside_tx_trained  = ln1_rx_tx_last_byte_ts3[2] | ln3_rx_tx_last_byte_ts3[2];
assign inside_rx_inside_tx_trained   = ln1_rx_tx_last_byte_ts3[3] | ln3_rx_tx_last_byte_ts3[3];

assign disabled_tx_lanes_din[7:0] = dl_reset_q                                                                                                                         ? 8'b00000000 :
                                    x8_mode & good_rx_outsides_q & (rx_tx_TS2[0] | rx_tx_TS3[0]) & ln0_rx_tx_last_byte_ts3[5]  &  outside_rx_outside_tx_trained & ~outside_rx_inside_tx_trained ? 8'b01011010:  //-- inside from other end didn't train, set them
                                    x8_mode & good_rx_insides_q  & (rx_tx_TS2[1] | rx_tx_TS3[1]) & ln1_rx_tx_last_byte_ts3[5]  &   inside_rx_outside_tx_trained &  ~inside_rx_inside_tx_trained ? 8'b01011010:  //-- inside from other end didn't train, set them
                                    x8_mode & good_rx_outsides_q & (rx_tx_TS2[0] | rx_tx_TS3[0]) & ln0_rx_tx_last_byte_ts3[5]  & ~outside_rx_outside_tx_trained &  outside_rx_inside_tx_trained ? 8'b10100101:  //-- outside from other end didn't train, set them
                                    x8_mode & good_rx_insides_q  & (rx_tx_TS2[1] | rx_tx_TS3[1]) & ln1_rx_tx_last_byte_ts3[5]  &  ~inside_rx_outside_tx_trained &   inside_rx_inside_tx_trained ? 8'b10100101:  //-- outside from other end didn't train, set them
                                    x8_mode & good_rx_outsides_q & (| rx_tx_TS3[7:0])            & ln0_rx_tx_last_byte_ts3[5]  & ~outside_rx_outside_tx_trained & ~outside_rx_inside_tx_trained ? 8'b11111111:  //-- neither trained, set them all
                                    x8_mode & good_rx_insides_q  & (| rx_tx_TS3[7:0])            & ln1_rx_tx_last_byte_ts3[5]  &  ~inside_rx_outside_tx_trained &  ~inside_rx_inside_tx_trained ? 8'b11111111:  //-- neither trained, set them all
                                    x8_mode & good_rx_outsides_q & (rx_tx_TS2[0] | rx_tx_TS3[0]) & ln0_rx_tx_last_byte_ts3[5]  &  outside_rx_outside_tx_trained & ~outside_rx_inside_tx_trained ? 8'b01111110:  //-- inside from other end didn't train, set them
                                     x4OL_mode & good_rx_insides_q  & (rx_tx_TS2[1] | rx_tx_TS3[1]) & ln1_rx_tx_last_byte_ts3[5]  &   inside_rx_outside_tx_trained &  ~inside_rx_inside_tx_trained ? 8'b01111110:  //-- inside from other end didn't train, set them
                                     x4OL_mode & good_rx_outsides_q & (rx_tx_TS2[0] | rx_tx_TS3[0]) & ln0_rx_tx_last_byte_ts3[5]  & ~outside_rx_outside_tx_trained &  outside_rx_inside_tx_trained ? 8'b11011011:  //-- outside from other end didn't train, set them
                                     x4OL_mode & good_rx_insides_q  & (rx_tx_TS2[1] | rx_tx_TS3[1]) & ln1_rx_tx_last_byte_ts3[5]  &  ~inside_rx_outside_tx_trained &   inside_rx_inside_tx_trained ? 8'b11011011:  //-- outside from other end didn't train, set them
                                     x4OL_mode & good_rx_outsides_q & (| rx_tx_TS3[7:0])            & ln0_rx_tx_last_byte_ts3[5]  & ~outside_rx_outside_tx_trained & ~outside_rx_inside_tx_trained ? 8'b11111111:  //-- neither trained, set them all
                                     x4OL_mode & good_rx_insides_q  & (| rx_tx_TS3[7:0])            & ln1_rx_tx_last_byte_ts3[5]  &  ~inside_rx_outside_tx_trained &  ~inside_rx_inside_tx_trained ? 8'b11111111:  //-- neither trained, set them all                
                                     x4OL_mode ? 8'b01011010 :    
                                     x8_degrade_to_outside ? 8'b01011010 :
                                     x8_degrade_to_inside ? 8'b10100101 :
                                     x4_degrade_to_outside ? 8'b01111110 :
                                     x4_degrade_to_inside ? 8'b11011011 :
                                                                                                                                                                         disabled_tx_lanes_q[7:0]; 


assign rx_lane_mask[7:0] = ({good_rx_outsides_q, good_rx_insides_q, good_rx_outsides_q,good_rx_insides_q, good_rx_insides_q,good_rx_outsides_q,good_rx_insides_q, good_rx_outsides_q} & 
                            {8{x8_mode}}) |
                           ({good_rx_outsides_q, 1'b0, good_rx_outsides_q, 2'b00, good_rx_outsides_q, 1'b0, good_rx_outsides_q} & {8{x8_degrade_to_outside}}) |
                           ({1'b0, good_rx_insides_q, 1'b0,good_rx_insides_q, good_rx_insides_q, 1'b0,good_rx_insides_q, 1'b0} & {8{x8_degrade_to_inside}}) |
                           ({good_rx_outsides_q, 1'b0, good_rx_insides_q, 2'b00, good_rx_insides_q, 1'b0, good_rx_outsides_q} & {8{x4OL_mode}}) |
                           ({good_rx_outsides_q, 6'b000000, good_rx_outsides_q} & {8{x4_degrade_to_outside}}) |
                           ({2'b00, good_rx_insides_q, 2'b00, good_rx_insides_q, 2'b00} & {8{x4_degrade_to_inside}});

assign disabled_rx_lanes_din[7:0]  = dl_reset_q        ? 8'b00000000              :
                                     dis_lane_cnt_q[3] ? ~(enabled_rx_lanes_q[7:0] & rx_lane_mask[7:0]) :
                                                         disabled_rx_lanes_q[7:0] ;

assign dis_lane_cnt_din[3:0]       = dl_reset_q                                                              ?  4'b0000                       :
                                     tsm_advance & (|({rx_tx_TS1[7:0],rx_tx_TS2[7:0]})) & ~dis_lane_cnt_q[3] ?  dis_lane_cnt_q[3:0] + 4'b0001 :
                                                                                                                dis_lane_cnt_q[3:0];

assign enabled_rx_lanes_din[7:0]  = dl_reset_q ? 8'b00000000 :
                                                 (rx_tx_TS1[7:0] | rx_tx_TS2[7:0] | enabled_rx_lanes_q[7:0]);

assign tx_rx_disabled_rx_lanes[7:0] = disabled_rx_lanes_q[7:0] | EDPL_bad_lane_q[7:0];

// ----------------------- EDPL logic ---------------------------------------

// Counter for 1 us ticks
assign tick_1us_cntr_din[8:0] = (dlx_reset | tick_1us_q) ? 9'b0 : tick_1us_cntr_q[8:0] + 9'b1;

assign tick_1us_din = (tick_1us_cntr_q == 9'h190) ? 1'b1 : 1'b0;

//-- Upper bit is a disable bit to stop the EDPL timer from incrementing
assign EDPL_time_window_disable = EDPL_time_window[44];
assign EDPL_time_window[44:0] = ({1'b1, 44'hFFF_FFFF_FFFF} & {45{(EDPL_time_window_enc[3:0] == 4'b0000)}}) |  //-- no time window 
                                ({1'b0, 44'h000_0000_0004} & {45{(EDPL_time_window_enc[3:0] == 4'b0001)}}) |  //--   4 us
                                ({1'b0, 44'h000_0000_0020} & {45{(EDPL_time_window_enc[3:0] == 4'b0010)}}) |  //--  32 us
                                ({1'b0, 44'h000_0000_0100} & {45{(EDPL_time_window_enc[3:0] == 4'b0011)}}) |  //-- 256 us
                                ({1'b0, 44'h000_0000_07D0} & {45{(EDPL_time_window_enc[3:0] == 4'b0100)}}) |  //--   2 ms
                                ({1'b0, 44'h000_0000_3E80} & {45{(EDPL_time_window_enc[3:0] == 4'b0101)}}) |  //--  16 ms
                                ({1'b0, 44'h000_0001_F400} & {45{(EDPL_time_window_enc[3:0] == 4'b0110)}}) |  //-- 128 ms
                                ({1'b0, 44'h000_000F_4240} & {45{(EDPL_time_window_enc[3:0] == 4'b0111)}}) |  //--   1  s
                                ({1'b0, 44'h000_007A_1200} & {45{(EDPL_time_window_enc[3:0] == 4'b1000)}}) |  //--   8  s
                                ({1'b0, 44'h000_03D0_9000} & {45{(EDPL_time_window_enc[3:0] == 4'b1001)}}) |  //--  64  s
                                ({1'b0, 44'h000_1E84_8000} & {45{(EDPL_time_window_enc[3:0] == 4'b1010)}}) |  //-- 512  s
                                ({1'b0, 44'h000_EE6B_2800} & {45{(EDPL_time_window_enc[3:0] == 4'b1011)}}) |  //--   4 ks
                                ({1'b0, 44'h007_7359_4000} & {45{(EDPL_time_window_enc[3:0] == 4'b1100)}}) |  //--  32 ks
                                ({1'b0, 44'h03B_9ACA_0000} & {45{(EDPL_time_window_enc[3:0] == 4'b1101)}}) |  //-- 256 ks
                                ({1'b0, 44'h1D1_A94A_2000} & {45{(EDPL_time_window_enc[3:0] == 4'b1110)}}) |  //--   2 Ms
                                ({1'b0, 44'hE8D_4A51_0000} & {45{(EDPL_time_window_enc[3:0] == 4'b1111)}});   //--  16 Ms

//-- Inserted for testability and should also improve timing
assign EDPL_compare_din[5]    = (EDPL_timer_q[43:40] == EDPL_time_window[43:40]) & ~EDPL_reset_cnts_q & ~reset_q;
assign EDPL_compare_din[4]    = (EDPL_timer_q[39:32] == EDPL_time_window[39:32]) & ~EDPL_reset_cnts_q & ~reset_q;
assign EDPL_compare_din[3]    = (EDPL_timer_q[31:24] == EDPL_time_window[31:24]) & ~EDPL_reset_cnts_q & ~reset_q;
assign EDPL_compare_din[2]    = (EDPL_timer_q[23:16] == EDPL_time_window[23:16]) & ~EDPL_reset_cnts_q & ~reset_q;
assign EDPL_compare_din[1]    = (EDPL_timer_q[15: 8] == EDPL_time_window[15: 8]) & ~EDPL_reset_cnts_q & ~reset_q;
assign EDPL_compare_din[0]    = (EDPL_timer_q[ 7: 0] == EDPL_time_window[ 7: 0]) & ~EDPL_reset_cnts_q & ~reset_q;
assign EDPL_window_hit        = (&EDPL_compare_q[5:0]);

assign EDPL_reset_cnts_din    = (EDPL_window_hit) & ~EDPL_reset_cnts_q & ~reset_q;

assign EDPL_timer_reset       =  EDPL_time_window_disable | EDPL_reset_cnts_q | EDPL_max_cnt_reset;
assign EDPL_timer_inc         = ~EDPL_time_window_disable & tick_1us_q;
assign EDPL_timer_din[43:0]   =  EDPL_timer_reset  ? 44'b0 :
                                 EDPL_timer_inc    ? EDPL_timer_q[43:0] + 44'b1 :
                                                     EDPL_timer_q[43:0];

//-- error signal
assign EDPL_thres_reached_din       = (|rx_tx_EDPL_thres_reached[7:0]);
//-- wait until retrain launches to kill the correct lane
assign EDPL_kill_lane_pend_din[7:0] = (EDPL_kill_lane_pend_q[7:0] | rx_tx_EDPL_thres_reached[7:0]) & {8{~reset_q}};
assign EDPL_bad_lane_din[7:0]       = (({8{start_retrain_q | start_retrain_dly_q[2]}} & EDPL_kill_lane_pend_q[7:0]) | EDPL_bad_lane_q[7:0]) &
                                      {8{~reset_q}};

assign tx_rx_EDPL_cntr_reset = EDPL_reset_cnts_q;

assign ctl_reg_hwwe = EDPL_max_cnt_reset;

assign retrain_pending_din[2:1] = retrain_pending_q[1:0];
assign retrain_pending_din[0] = &{tsm_q[2:0],EDPL_thres_reached_q};
                        

// ----------------------- end of EDPL logic --------------------------------

always @(posedge (dlx_clk)) begin
   tsm_state2_to_3_q             <= tsm_state2_to_3_din;
   tsm_state2_to_3_d1_q          <= tsm_state2_to_3_d1_din;
   tsm_state6_to_1_q             <= tsm_state6_to_1_din;
   tsm_state6_to_1_d1_q          <= tsm_state6_to_1_d1_din;
   tsm_state4_to_5_q             <= tsm_state4_to_5_din;
   tsm_state4_to_5_d1_q          <= tsm_state4_to_5_d1_din;
   flt_ready_q                   <= flt_ready_din;
   det_sync_q                    <= det_sync_din;
   dl_reset_q                    <= dl_reset_din;
   dl_reset_d1_q                 <= dl_reset_d1_din;
   tsm_q[2:0]                    <= tsm_din[2:0];
   a_cnt_q[3:0]                  <= a_cnt_din[3:0];
   b_cnt_q[3:0]                  <= b_cnt_din[3:0];
   seq_cnt_q[8:0]                <= seq_cnt_din[8:0];
   timer_q[9:0]                  <= timer_din[9:0];
   lfsr_q[0:22]                  <= lfsr_din[0:22];
   good_tx_lanes_q[7:0]          <= good_tx_lanes_din[7:0];
   good_tx_outsides_q            <= good_tx_outsides_din;
   good_tx_insides_q             <= good_tx_insides_din;
   good_rx_outsides_q            <= good_rx_outsides_din;
   good_rx_insides_q             <= good_rx_insides_din;
   x4_not_x8_tx_mode_q           <= x4_not_x8_tx_mode_din;   
   x2_tx_mode_q                  <= x2_tx_mode_din;   
   disabled_tx_lanes_q[7:0]      <= disabled_tx_lanes_din[7:0];
   disabled_rx_lanes_q[7:0]      <= disabled_rx_lanes_din[7:0];
   dis_lane_cnt_q[3:0]           <= dis_lane_cnt_din[3:0];
   enabled_rx_lanes_q[7:0]       <= enabled_rx_lanes_din[7:0];
   start_retrain_q               <= start_retrain_din;
   start_retrain_dly_q[2:0]      <= start_retrain_dly_din[2:0];
   reset_q                       <= reset_din;
   reset_d1_q                    <= reset_d1_din;
   sync_pattern_q                <= sync_pattern_din;
   dlx_version_q[31:0]           <= dlx_version_din[31:0];
   EDPL_bad_lane_q[7:0]          <= EDPL_bad_lane_din[7:0];
   EDPL_kill_lane_pend_q         <= EDPL_kill_lane_pend_din;
   EDPL_reset_cnts_q             <= EDPL_reset_cnts_din;
   EDPL_thres_reached_q          <= EDPL_thres_reached_din;
   EDPL_timer_q[43:0]            <= EDPL_timer_din[43:0];
   EDPL_compare_q[5:0]           <= EDPL_compare_din[5:0];
   tick_1us_cntr_q[8:0]          <= tick_1us_cntr_din[8:0];
   tick_1us_q                    <= tick_1us_din;
   retrain_pending_q[2:0]        <= retrain_pending_din[2:0];
   ts1_done_q                    <= ts1_done;
   ts2_done_q			 <= ts2_done;
   ts3_done_q			 <= ts3_done;
   ts4_done_q			 <= ts4_done;
   block_locked_q                <= block_locked;

end

endmodule // -- ocx_dlx_tx_ctl
