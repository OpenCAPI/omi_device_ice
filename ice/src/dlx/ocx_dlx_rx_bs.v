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


module ocx_dlx_rx_bs(
  reset                  // < input
  ,valid_in              // < input
  ,flit_in               // < input
  ,valid_out             // > output
  ,forced_valid_out      // > output
  ,flit_out              // > output
  ,sf_crc_error          // > output
  ,sf_ack_cnt            // > output
  ,sf_recal_status       // > output
  ,rx_clk_in             // < input
  
//-- ,gnd  // <> inout
//-- ,vdn  // <> inout
);	

input          reset;
input          valid_in;
input  [511:0] flit_in;
output         valid_out;
output         forced_valid_out;
output [511:0] flit_out;
output         sf_crc_error;
output [4:0]   sf_ack_cnt;
output [1:0]   sf_recal_status;
input          rx_clk_in;

//-- inout gnd;
//-- (* GROUND_PIN="1" *)
//-- wire gnd;

//-- inout vdn;
//-- (* POWER_PIN="1" *)
//-- wire vdn;

//----------------------------------- declarations -----------------------------
reg  [511:0]   flit_in_q;
wire [511:0]   flit_in_din;
reg  [511:0]   flit_out_q;
wire [511:0]   flit_out_din;
reg            valid_in_q;
wire           valid_in_din;
reg            valid_out_q;
wire           valid_out_din;
reg  [511:128] holding_q;
wire [511:128] holding_din;
reg  [3:0]     last_st_q;  
wire [3:0]     last_st_din;
wire [3:0]     new_run_length;
wire           ld_rl;
reg  [3:0]     run_length_q;
wire [3:0]     run_length_din;
reg  [3:0]     last_ds_st_q;
wire [3:0]     last_ds_st_din;
wire           last_ds_1_2;
wire           last_ds_3_4_5;
wire           last_ds_6_7_8_9;
wire [28:0]    fsm_inputs;
wire [3:0]     dsrl_l0, dsrl_l1, dsrl_l2, dsrl_l3, rl_l0, rl_l1, rl_l2, rl_l3,pcrl_l0,pcrl_l1,pcrl_l2,pcrl_l3;
wire [3:0]     cur_is_d_or_s;
// FSM outputs
wire [3:0]     cur_st;
wire [3:0]     dsrl2rl;
wire [3:0]     rl2rl;
wire           rl_is_1;
wire           val_out;
wire [3:0]     sf_crcchk;
wire [3:1]     sf_crcdly;
wire [3:0]     flit_out_mux_sel;
wire           dec_rl;
reg  [24:0]    o;
// Information about input flit data on previous cycle
reg  [3:0]     prev_ds_q;   // Data stalled
wire [3:0]     prev_ds_din;
reg  [3:0]     prev_is_idle_q; // Idle flit
wire [3:0]     prev_is_idle_din;
reg  [3:0]     prev_is_ctl_q; // Either run length = 0 (ctl flit) or A (replay). Different from cur_is_ctl and cur_is_replay
wire [3:0]     prev_is_ctl_din;
reg  [3:0]     prev_dsrl_zero_q; // Data Stalled replay length = 0
wire [3:0]     prev_dsrl_zero_din;
reg            prev_sfn_l3_q; // Short Flit Next
wire           prev_sfn_l3_din;
reg  [3:0]     prev_dsrl_l0_q;
wire [3:0]     prev_dsrl_l0_din;
reg  [3:0]     prev_dsrl_l1_q;
wire [3:0]     prev_dsrl_l1_din;
reg  [3:0]     prev_dsrl_l2_q;
wire [3:0]     prev_dsrl_l2_din;
reg  [3:0]     prev_dsrl_l3_q;
wire [3:0]     prev_dsrl_l3_din;
reg  [3:0]     prev_rl_l0_q;
wire [3:0]     prev_rl_l0_din;
reg  [3:0]     prev_rl_l1_q;
wire [3:0]     prev_rl_l1_din;
reg  [3:0]     prev_rl_l2_q;
wire [3:0]     prev_rl_l2_din;
reg  [3:0]     prev_rl_l3_q;
wire [3:0]     prev_rl_l3_din;
// Information about input flit data on current cycle
wire [3:0]     cur_ds;
wire [3:0]     cur_is_idle;
wire [3:0]     cur_is_ctl; // Either run length is 0 (ctl flit)
wire [3:0]     cur_is_rpl; 
wire [3:0]     cur_is_rpl_z; // Replay with PCRL=0
wire [3:0]     cur_dsrl_zero;
wire [3:0]     cur_sfn;
// CRC stuff
wire [3:0]     sf_crc_nonzero, sf_crc_nonzero_gated, sf_crc_lane_error,sf_crc_no_dly;
reg  [3:1]     sf_crc_dly_q;
wire [3:1]     sf_crc_dly_din;
reg            sf_crc_err_q;
wire           sf_crc_err_din;
reg            sf_crc_err_dlyd_q;
wire           sf_crc_err_dlyd_din;
// ACK count stuff
reg  [4:0]     sf_ack_cnt_q;
wire [4:0]     sf_ack_cnt_din;
reg  [4:0]     sf_ack_cnt_l0_q;
wire [4:0]     sf_ack_cnt_l0_din;
reg  [4:0]     sf_ack_cnt_l1_q;
wire [4:0]     sf_ack_cnt_l1_din;
reg  [4:0]     sf_ack_cnt_l2_q;
wire [4:0]     sf_ack_cnt_l2_din;
reg  [4:0]     sf_ack_cnt_l3_q;
wire [4:0]     sf_ack_cnt_l3_din;
wire [4:0]     sf_ack_cnt_total;
wire           force_val_out;
wire           forced_valid_din;
reg            forced_valid_q;
//Recal Status
(*mark_debug = "true" *)reg  [1:0]     sf_recal_status_q;
wire [1:0]     sf_recal_status_din;

// Force to turn off crc checking
wire crcchk_enb;
assign crcchk_enb = 1'b1;

//assign flit_in_din = flit_in;
assign valid_in_din = valid_in;
assign valid_out_din = val_out | force_val_out;
assign forced_valid_din = ~val_out & force_val_out;
//assign valid_out_din = valid_in_q;
// Latches
always @(posedge rx_clk_in) 
begin
 if(reset == 1'b1) begin
  flit_in_q[511:0]      <= 512'b0; 
  valid_in_q            <= 1'b0;
  flit_out_q[511:0]     <= 512'b0;
  valid_out_q           <= 1'b0;
  forced_valid_q        <= 1'b0;
  holding_q[511:128]    <= 384'b0;
  // Previous flit
  prev_ds_q[3:0]        <= 4'b0;
  prev_is_idle_q[3:0]   <= 4'b0;
  prev_is_ctl_q[3:0]    <= 4'h8;
  prev_dsrl_zero_q[3:0] <= 4'b0;
  prev_sfn_l3_q         <= 1'b0;
  // State latches
  last_st_q[3:0]        <= 4'b0;
  last_ds_st_q[3:0]     <= 4'b0;
  run_length_q[3:0]     <= 4'b0;
  // Run Lengths
  prev_dsrl_l0_q[3:0]   <= 4'b0;
  prev_dsrl_l1_q[3:0]   <= 4'b0;
  prev_dsrl_l2_q[3:0]   <= 4'b0;
  prev_dsrl_l3_q[3:0]   <= 4'b0;
  prev_rl_l0_q[3:0]     <= 4'b0;
  prev_rl_l1_q[3:0]     <= 4'b0;
  prev_rl_l2_q[3:0]     <= 4'b0;
  prev_rl_l3_q[3:0]     <= 4'b0;
  // CRC
  sf_crc_dly_q[3:1]     <= 3'b0;
  sf_crc_err_q          <= 1'b0;
  sf_crc_err_dlyd_q     <= 1'b0;
  // ACK count
  sf_ack_cnt_q[4:0]     <= 5'b0;
  sf_ack_cnt_l0_q[4:0]  <= 5'b0;
  sf_ack_cnt_l1_q[4:0]  <= 5'b0;
  sf_ack_cnt_l2_q[4:0]  <= 5'b0;
  sf_ack_cnt_l3_q[4:0]  <= 5'b0; 
  // Recal Status
  sf_recal_status_q[1:0]    <= 2'b00;
 end else begin
  flit_in_q[511:0]      <= flit_in_din[511:0];
  valid_in_q            <= valid_in_din;
  flit_out_q[511:0]     <= flit_out_din[511:0];
  valid_out_q           <= valid_out_din;
  forced_valid_q        <= forced_valid_din;
  holding_q[511:128]    <= holding_din[511:128];
  // Previous flit
  prev_ds_q[3:0]        <= prev_ds_din[3:0];
  prev_is_idle_q[3:0]   <= prev_is_idle_din[3:0];
  prev_is_ctl_q[3:0]    <= prev_is_ctl_din[3:0];
  prev_dsrl_zero_q[3:0] <= prev_dsrl_zero_din[3:0];
  prev_sfn_l3_q         <= prev_sfn_l3_din;
  // State latches
  last_st_q[3:0]        <= last_st_din[3:0];
  last_ds_st_q[3:0]     <= last_ds_st_din[3:0];
  run_length_q[3:0]     <= run_length_din[3:0];
  // Run Lengths
  prev_dsrl_l0_q[3:0]   <= prev_dsrl_l0_din[3:0];
  prev_dsrl_l1_q[3:0]   <= prev_dsrl_l1_din[3:0];
  prev_dsrl_l2_q[3:0]   <= prev_dsrl_l2_din[3:0];
  prev_dsrl_l3_q[3:0]   <= prev_dsrl_l3_din[3:0];
  prev_rl_l0_q[3:0]     <= prev_rl_l0_din[3:0];
  prev_rl_l1_q[3:0]     <= prev_rl_l1_din[3:0];
  prev_rl_l2_q[3:0]     <= prev_rl_l2_din[3:0];
  prev_rl_l3_q[3:0]     <= prev_rl_l3_din[3:0];
  // CRC
  sf_crc_dly_q[3:1]     <= sf_crc_dly_din[3:1];
  sf_crc_err_q          <= sf_crc_err_din;
  sf_crc_err_dlyd_q     <= sf_crc_err_q;
  // ACK count
  sf_ack_cnt_q[4:0]     <= sf_ack_cnt_din[4:0];
  sf_ack_cnt_l0_q[4:0]  <= sf_ack_cnt_l0_din[4:0];
  sf_ack_cnt_l1_q[4:0]  <= sf_ack_cnt_l1_din[4:0];
  sf_ack_cnt_l2_q[4:0]  <= sf_ack_cnt_l2_din[4:0];
  sf_ack_cnt_l3_q[4:0]  <= sf_ack_cnt_l3_din[4:0];
  //Recal STatus
  sf_recal_status_q[1:0] <= sf_recal_status_din[1:0];
 end
end

// Latch incoming flit
assign flit_in_din[511:0] = valid_in ? flit_in[511:0] : flit_in_q[511:0];

// Decode some DL content data from each lane
assign cur_is_d_or_s[0] = (cur_st[1] & cur_st[0]) | (~cur_st[2] & cur_st[1]) |
                          (~cur_st[3] & ~cur_st[2] & cur_st[0]) |
                          (~cur_st[3] & cur_st[2] & ~cur_st[1] & ~cur_st[0]);
assign cur_is_d_or_s[1] = (cur_st[1] & cur_st[0]) | (~cur_st[3] & cur_st[2]) |
                          (cur_st[3] & ~cur_st[2] & cur_st[1]) &
                          (cur_st[3] & ~cur_st[1] & ~cur_st[0]);
assign cur_is_d_or_s[2] = (cur_st[3] & ~cur_st[2]) | (cur_st[3] & ~cur_st[1]) |
                          (~cur_st[3] & cur_st[2] & cur_st[1]);
assign cur_is_d_or_s[3] = (cur_st[3] & ~cur_st[2] & cur_st[1]) |
                          (cur_st[3] & cur_st[2] & ~cur_st[1]) |
                          ~(|cur_st[3:0]);

// Lane is state D or S and Data stalled bit set
assign cur_ds[0] = cur_is_d_or_s[0] & flit_in_q[83]; 
assign cur_ds[1] = cur_is_d_or_s[1] & flit_in_q[211];
assign cur_ds[2] = cur_is_d_or_s[2] & flit_in_q[339];
assign cur_ds[3] = cur_is_d_or_s[3] & flit_in_q[467];
assign prev_ds_din[3:0] = cur_ds[3:0];

// Lane is state D or S and Run Length = xF
assign cur_is_idle[0] = &{cur_is_d_or_s[0],flit_in_q[67:64]};
assign cur_is_idle[1] = &{cur_is_d_or_s[1],flit_in_q[195:192]};
assign cur_is_idle[2] = &{cur_is_d_or_s[2],flit_in_q[323:320]};
assign cur_is_idle[3] = &{cur_is_d_or_s[3],flit_in_q[451:448]};
assign prev_is_idle_din[3:0] = cur_is_idle[3:0];

// Lane is state D or S and Run Length = x0
assign rl_l0[3:0] = flit_in_q[67:64];
assign rl_l1[3:0] = flit_in_q[195:192];
assign rl_l2[3:0] = flit_in_q[323:320];
assign rl_l3[3:0] = flit_in_q[451:448];
assign prev_rl_l0_din[3:0] = cur_is_rpl[0] ? pcrl_l0[3:0] : rl_l0[3:0];
assign prev_rl_l1_din[3:0] = cur_is_rpl[1] ? pcrl_l1[3:0] : rl_l1[3:0];
assign prev_rl_l2_din[3:0] = cur_is_rpl[2] ? pcrl_l2[3:0] : rl_l2[3:0];
assign prev_rl_l3_din[3:0] = cur_is_rpl[3] ? pcrl_l3[3:0] : rl_l3[3:0];
assign cur_is_ctl[0] = cur_is_d_or_s[0] & ~|(rl_l0[3:0]);
assign cur_is_ctl[1] = cur_is_d_or_s[1] & ~|(rl_l1[3:0]);
assign cur_is_ctl[2] = cur_is_d_or_s[2] & ~|(rl_l2[3:0]);
assign cur_is_ctl[3] = cur_is_d_or_s[3] & ~|(rl_l3[3:0]);
assign prev_is_ctl_din[3:0] = cur_is_ctl[3:0] | cur_is_rpl_z[3:0];
// Lane is state D or S and Run Length = xA
assign pcrl_l0[3:0] = flit_in_q[71:68];
assign pcrl_l1[3:0] = flit_in_q[199:196];
assign pcrl_l2[3:0] = flit_in_q[327:324];
assign pcrl_l3[3:0] = flit_in_q[455:452];
assign cur_is_rpl[0] = cur_is_d_or_s[0] & rl_l0[3] & ~rl_l0[2] & rl_l0[1] & ~rl_l0[0];
assign cur_is_rpl[1] = cur_is_d_or_s[1] & rl_l1[3] & ~rl_l1[2] & rl_l1[1] & ~rl_l1[0];
assign cur_is_rpl[2] = cur_is_d_or_s[2] & rl_l2[3] & ~rl_l2[2] & rl_l2[1] & ~rl_l2[0];
assign cur_is_rpl[3] = cur_is_d_or_s[3] & rl_l3[3] & ~rl_l3[2] & rl_l3[1] & ~rl_l3[0];
assign cur_is_rpl_z[0] = cur_is_rpl[0] & ~|pcrl_l0[3:0];
assign cur_is_rpl_z[1] = cur_is_rpl[1] & ~|pcrl_l1[3:0];
assign cur_is_rpl_z[2] = cur_is_rpl[2] & ~|pcrl_l2[3:0];
assign cur_is_rpl_z[3] = cur_is_rpl[3] & ~|pcrl_l3[3:0];

// Lane is state D or S, idle flit and Data Stalled Run Length = 0
assign dsrl_l0[3:0] = flit_in_q[71:68];
assign dsrl_l1[3:0] = flit_in_q[199:196];
assign dsrl_l2[3:0] = flit_in_q[327:324];
assign dsrl_l3[3:0] = flit_in_q[455:452];
assign prev_dsrl_l0_din[3:0] = dsrl_l0[3:0];
assign prev_dsrl_l1_din[3:0] = dsrl_l1[3:0];
assign prev_dsrl_l2_din[3:0] = dsrl_l2[3:0];
assign prev_dsrl_l3_din[3:0] = dsrl_l3[3:0];
assign cur_dsrl_zero[0] = cur_is_idle[0] & ~(|dsrl_l0[3:0]);
assign cur_dsrl_zero[1] = cur_is_idle[1] & ~(|dsrl_l1[3:0]);
assign cur_dsrl_zero[2] = cur_is_idle[2] & ~(|dsrl_l2[3:0]);
assign cur_dsrl_zero[3] = cur_is_idle[3] & ~(|dsrl_l3[3:0]);
assign prev_dsrl_zero_din[3:0] = cur_dsrl_zero[3:0];

// Lane is state D or S, short flit next bit set
assign cur_sfn[0] = flit_in_q[82];
assign cur_sfn[1] = flit_in_q[210];
assign cur_sfn[2] = flit_in_q[338];
assign cur_sfn[3] = flit_in_q[466];
assign prev_sfn_l3_din = cur_is_d_or_s[3] & cur_sfn[3];
                                 
assign fsm_inputs = {last_st_q[3:0],valid_in_q,prev_is_ctl_q[3:0],
                     prev_is_idle_q[3:0],prev_ds_q[3:0],prev_dsrl_zero_q[3:0],
                     prev_sfn_l3_q,rl_is_1,last_ds_1_2,last_ds_3_4_5,
                     last_ds_6_7_8_9,cur_sfn[2:0]};                                 
                                 
// Determine current states
always @(*)
begin
   (* full_case *) (* parallel_case *) 
   casez (fsm_inputs)
  	  //                                            flit_out_mux_sel
  	  //                      rl_is_1               |   crcchk
  	  //       PREVIOUS FLIT  |last_ds=1 or 2       |   :  crcdly   
  	  //     /---------------\|:last_ds=3,4 or 5    |   :  |valid_out
  	  //Valid              SFN|::last_ds=6,7,8 or 9 |   :  |:   dsrl2rl
  	  //    |CTL IDLE DS DSRL:|:: CUR FLIT SFN      |   :  |:   |rl2rl
      //    |32103210321032103|:::210            32103210321:32103210dec_rl
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = DCCC
    29'b00000????????????????????????: o=25'b0000000100000000000000000; //{D,C,C,C}; // No valid
    29'b00001????1???????0???0???????: o=25'b1110000100000001100000000; //{C,C,C,C}; // Prev=Long Idle, DSRL>0->Cur=Data 
    29'b00001????1???????1???0???????: o=25'b0000000100000001000000000; //{D,C,C,C}; // Prev=Long Idle, DSRL=0->Cur=Long Idle
    29'b000011???0???????????0???????: o=25'b0000000100000001000000000; //{D,C,C,C}; // Prev=Control (no data or Replay)->Cur=Control,Replay    
    29'b000010???0???0???????0???????: o=25'b1110000100000001000010000; //{C,C,C,C}; // Prev=Control w/ data->Cur=Data
    29'b000010???0???1???????0???????: o=25'b0000000100000001000000000; //{D,C,C,C}; // Prev=Control w/ data stall->Cur->Long Idle
    29'b00001????????????????1??????0: o=25'b0001000100010000000000000; //{C,C,C,S}; // Prev=Control w/ data->Cur=1 Short idle before data
    29'b00001????????????????1?????01: o=25'b0011000100110000000000000; //{C,C,S,S}; // Prev=Control w/ data->Cur=2 Short idles before data
    29'b00001????????????????1????011: o=25'b0110000101110000000000000; //{C,S,S,S}; // Prev=Control w/ data->Cur=3 Short idles before data
    29'b00001????????????????1????111: o=25'b1010000111110000000000000; //{S,S,S,S}; // Prev=Control w/ data->Cur=At least 4 short idles before data
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::| Prev State = CCCS
    29'b00010????????????????????????: o=25'b0001100000000000000000000; //{C,C,C,S}; // No valid
    29'b00011???????????????0????????: o=25'b1110100000000001000100000; //{C,C,C,C}; // Prev=Short idle, DSRL>0->Cur=Data
    29'b00011???????????????1???????0: o=25'b0010100000000001000000000; //{C,C,C,D}; // Prev=Short idle, DSRL=0->Cur=Long idle
    29'b00011???????????????1??????01: o=25'b0100100000100011000000000; //{C,C,S,D}; // Prev=Short idle, DSRL=0->Cur=Long idle followed by 1 short idle
    29'b00011???????????????1?????011: o=25'b0111100001100111000000000; //{C,S,S,D}; // Prev=Short idle, DSRL=0->Cur=Long idle followed by 2 short idles
    29'b00011???????????????1?????111: o=25'b1011100011101111000000000; //{S,S,S,D}; // Prev=Short idle, DSRL=0->Cur=Long Idle followed by (at least) 3 short idles
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::| Prev State = CCCD
    29'b00100????????????????????????: o=25'b0010100000000000000000000; //{C,C,C,D}; // No valid
    29'b00101???????1???????0????????: o=25'b1110100000000001000100000; //{C,C,C,C}; // Prev=Long Idle, DSRL>0->Cur=Data
    29'b00101???????1???????1???????0: o=25'b0010100000000001000000000; //{C,C,C,D}; // Prev=Long Idle, DSRL=0->Cur=Long idle
    29'b00101???????1???????1??????01: o=25'b0100100000100011000000000; //{C,C,S,D}; // Prev=Short idle, DSRL=0->Cur=Long idle followed by 1 short idle
    29'b00101???????1???????1?????011: o=25'b0111100001100111000000000; //{C,S,S,D}; // Prev=Short idle, DSRL=0->Cur=Long idle followed by 2 short idles
    29'b00101???????1???????1?????111: o=25'b1011100011101111000000000; //{S,S,S,D}; // Prev=Short idle, DSRL=0->Cur=Long Idle followed by (at least) 3 short idles
    29'b00101???1???0???????????????0: o=25'b0010100000000001000000000; //{C,C,C,D}; // Prev=Control (no data or Replay)->Cur=Control,Replay or Long Idle
    29'b00101???1???0??????????????01: o=25'b0100100000100011000000000; //{C,C,S,D}; // Prev=Control flit (no data or Replay)->Cur=Control,Replay or Long Idle followed by 1 short idle
    29'b00101???1???0?????????????011: o=25'b0111100001100111000000000; //{C,S,S,D}; // Prev=Control flit (no data or Replay)->Cur=Control,Replay or Long Idle followed by 2 short idles
    29'b00101???1???0?????????????111: o=25'b1011100011101111000000000; //{S,S,S,D}; // Prev=Control flit (no data or Replay)->Cur=Control,Replay or Long Idle followed by (at least) 3 short idles
    29'b00101???0???0???0????????????: o=25'b1110100000000001000000010; //{C,C,C,C}; // Prev=Control flit w/ data (no stall)->Cur=Data
    29'b00101???0???0???1???????????0: o=25'b0010100000000001000000000; //{C,C,C,D}; // Prev=Control flit w/ data stall->Cur=Long Idle
    29'b00101???0???0???1??????????01: o=25'b0100100000100011000000000; //{C,C,S,D}; // Prev=Control flit w/ data stall->Cur=Long Idle followed by 1 short idle
    29'b00101???0???0???1?????????011: o=25'b0111100001100111000000000; //{C,S,S,D}; // Prev=Control flit w/ data stall->Cur=Long Idle followed by 2 short idles
    29'b00101???0???0???1?????????111: o=25'b1011100011101111000000000; //{S,S,S,D}; // Prev=Control flit w/ data stall->Cur=Long Idle followed by (at least) 3 short idles    
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = CCSS
    29'b00110????????????????????????: o=25'b0011010000000000000000000; //{C,C,S,S}; // No valid  
    29'b00111??????????????0?????????: o=25'b1110010000000001001000000; //{C,C,C,C}; // Prev=Short idle,End of data stall->Cur=Data
    29'b00111??????????????1???????0?: o=25'b0101010000000001000000000; //{C,C,D,C}; // Prev=Short idle,DSRL=0->Cur=Long Idle
    29'b00111??????????????1??????01?: o=25'b1000010001000101000000000; //{C,S,D,C}; // Prev=Short idle,DSRL=0->Cur=Long Idle followed by 1 short idle
    29'b00111??????????????1??????11?: o=25'b1100010011001101000000000; //{S,S,D,C}; // Prev=Short idle,DSRL=0->Cur=Long Idle followed by (at least) 2 short idles
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = CCSD
    29'b01000????????????????????????: o=25'b0100010000000000000000000; //{D,C,C,C}; // No valid
    29'b01001??????????????0?????????: o=25'b1110010000000001001000000; //{C,C,C,C}; // Prev=Short idle,End of data stall->Cur=Data
    29'b01001??????????????1???????0?: o=25'b0101010000000001000000000; //{C,C,D,C}; // Prev=Short idle,DSRL=0->Cur=Long Idle
    29'b01001??????????????1??????01?: o=25'b1000010001000101000000000; //{C,S,D,C}; // Prev=Short idle,DSRL=0->Cur=Long Idle followed by 1 short idle
    29'b01001??????????????1??????11?: o=25'b1100010011001101000000000; //{S,S,D,C}; // Prev=Short idle,DSRL=0->Cur=Long Idle followed by (at least) 2 short idles
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = CCDC
    29'b01010????????????????????????: o=25'b0101010000000000000000000; //{C,C,D,C}; // No valid
    29'b01011??????1???????0?????????: o=25'b1110010000000001001000000; //{C,C,C,C}; // Prev=Long idle,DSRL>0->Cur=Data
    29'b01011??????1???????1???????0?: o=25'b0101010000000001000000000; //{C,C,D,C}; // Prev=Long idle,DSRL=0->Cur=Long Idle 
    29'b01011??????1???????1??????01?: o=25'b1000010001000101000000000; //{C,S,D,C}; // Prev=Long idle,DSRL=0->Cur=Long Idle followed by 1 short idle
    29'b01011??????1???????1??????11?: o=25'b1100010011001101000000000; //{S,S,D,C}; // Prev=Long idle,DSRL=0->Cur=Long Idle followed by (at least) 2 short idles
    29'b01011??1???0???????????????0?: o=25'b0101010000000001000000000; //{C,C,D,C}; // Prev=Control (no data or Replay)->Cur=Control,Replay or Long Idle
    29'b01011??1???0??????????????01?: o=25'b1000010001000101000000000; //{C,S,D,C}; // Prev=Control (no data or Replay)->Cur=Control,Replay or Long Idle followed by 1 short idle
    29'b01011??1???0??????????????11?: o=25'b1100010011001101000000000; //{S,S,D,C}; // Prev=Control (no data or Replay)->Cur=Control,Replay or Long Idle followed by (at least) 2 short idles
    29'b01011??0???0???0?????????????: o=25'b1110010000000001000000100; //{C,C,C,C}; // Prev=Control w/ data, no stall->Cur=Data
    29'b01011??0???0???1???????????0?: o=25'b0101010000000001000000000; //{C,C,D,C}; // Prev=Control w/ data stall->Cur=Long Idle 
    29'b01011??0???0???1??????????01?: o=25'b1000010001000101000000000; //{C,S,D,C}; // Prev=Control w/ data stall->Cur=Long Idle followed by 1 short idle
    29'b01011??0???0???1??????????11?: o=25'b1100010011001101000000000; //{S,S,D,C}; // Prev=Control w/ data stall->Cur=Long Idle followed by (at least) 2 short idles
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = CSSS
    29'b01100????????????????????????: o=25'b0110001000000000000000000; //{C,S,S,S}; // No valid
    29'b01101?????????????0??????????: o=25'b1110001000000001010000000; //{C,C,C,C}; // Prev=Short Idle,DSRL>0->Cur=Data
    29'b01101?????????????1???????0??: o=25'b1001001000000001000000000; //{C,D,C,C}; // Prev=Short Idle,DSRL=0->Cur=Long Idle
    29'b01101?????????????1???????1??: o=25'b1101001010001001000000000; //{S,D,C,C}; // Prev=Short Idle,DSRL=0->Cur=Long Idle followed by (at least) 1 short idle
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = CSSD
    29'b01110????????????????????????: o=25'b0110001000000000000000000; //{C,S,S,D}; // No valid
    29'b01111?????????????0??????????: o=25'b1110001000000001010000000; //{C,C,C,C}; // Prev=Short Idle,DSRL>0->Cur=Data
    29'b01111?????????????1???????0??: o=25'b1001001000000001000000000; //{C,D,C,C}; // Prev=Short Idle,DSRL=0->Cur=Long Idle
    29'b01111?????????????1???????1??: o=25'b1101001010001001000000000; //{S,D,C,C}; // Prev=Short Idle,DSRL=0->Cur=Long Idle followed by (at least) 1 short idle
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = CSDC
    29'b10000????????????????????????: o=25'b1000001000000000000000000; //{C,S,D,C}; // No valid
    29'b10001?????????????0??????????: o=25'b1110001000000001010000000; //{C,C,C,C}; // Prev=Short Idle,DSRL>0->Cur=Data
    29'b10001?????????????1???????0??: o=25'b1001001000000001000000000; //{C,D,C,C}; // Prev=Short Idle,DSRL=0->Cur=Long Idle
    29'b10001?????????????1???????1??: o=25'b1101001010001001000000000; //{S,D,C,C}; // Prev=Short Idle,DSRL=0->Cur=Long Idle followed by (at least) 1 short idle
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = CDCC
    29'b10010????????????????????????: o=25'b1001001000000000000000000; //{C,D,C,C}; // No valid
    29'b10011?????1???????0??????????: o=25'b1110001000000001010000000; //{C,C,C,C}; // Prev=Long Idle,DSRL>0->Cur=Data
    29'b10011?????1???????1???????0??: o=25'b1001001000000001000000000; //{C,D,C,C}; // Prev=Long Idle,DSRL=0->Cur=Long Idle
    29'b10011?????1???????1???????1??: o=25'b1101001010001001000000000; //{S,D,C,C}; // Prev=Long Idle,DSRL=0->Cur=Long Idle followed by (at least) 1 short idle
    29'b10011?1???0???????????????0??: o=25'b1001001000000001000000000; //{C,D,C,C}; // Prev=Control (no data or Replay)->Cur=Control,Replay or Long Idle
    29'b10011?1???0???????????????1??: o=25'b1101001010001001000000000; //{S,D,C,C}; // Prev=Control (no data or Replay)->Cur=Control,Replay or Long Idle followed by (at least) 1 short idle
    29'b10011?0???0???0??????????????: o=25'b1110001000000001000001000; //{C,C,C,C}; // Prev=Control w/data, no stall->Cur=Data
    29'b10011?0???0???1???????????0??: o=25'b1001001000000001000000000; //{C,D,C,C}; // Prev=Control w/data stall->Cur=Long Idle
    29'b10011?0???0???1???????????1??: o=25'b1101001010001001000000000; //{S,D,C,C}; // Prev=Control w/data stall->Cur=Long Idle followed by (at least) 1 short idle
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = SSSS
    29'b10100????????????????????????: o=25'b1010000100000000000000000; //{S,S,S,S}; // No valid
    29'b10101????????????1???0???????: o=25'b0000000100000001000000000; //{D,C,C,C}; // Prev=Short Idle,DSRL=0->Cur=Long Idle
    29'b10101????????????0???0???????: o=25'b1110000100000001100000000; //{C,C,C,C}; // Prev=Short Idle,DSRL>0->Cur=Data
    29'b10101????????????????1??????0: o=25'b0001000100010000000000000; //{C,C,C,S}; // Prev=Short Idle->Cur=Short Idle
    29'b10101????????????????1?????01: o=25'b0011000100110000000000000; //{C,C,S,S}; // Prev=Short Idle->Cur=2 Short Idles
    29'b10101????????????????1????011: o=25'b0110000101110000000000000; //{C,S,S,S}; // Prev=Short Idle->Cur=3 Short Idles
    29'b10101????????????????1????111: o=25'b1010000111110000000000000; //{S,S,S,S}; // Prev=Short Idle->Cur=(at least) 4 short idles
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = SSSD
    29'b10110????????????????????????: o=25'b1011000100000000000000000; //{S,S,S,D}; // No valid
    29'b10111????????????1???0???????: o=25'b0000000100000001000000000; //{D,C,C,C}; // Prev=Short Idle,DSRL=0->Cur=Long Idle
    29'b10111????????????0???0???????: o=25'b1110000100000001100000000; //{C,C,C,C}; // Prev=Short Idle,DSRL>0->Cur=Data
    29'b10111????????????????1??????0: o=25'b0001000100010000000000000; //{C,C,C,S}; // Prev=Short Idle->Cur=Short Idle
    29'b10111????????????????1?????01: o=25'b0011000100110000000000000; //{C,C,S,S}; // Prev=Short Idle->Cur=2 Short Idles
    29'b10111????????????????1????011: o=25'b0110000101110000000000000; //{C,S,S,S}; // Prev=Short Idle->Cur=3 Short Idles
    29'b10111????????????????1????111: o=25'b1010000111110000000000000; //{S,S,S,S}; // Prev=Short Idle->Cur=(at least) 4 short idles
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = SSDC
    29'b11000????????????????????????: o=25'b1100000100000000000000000; //{S,S,D,C}; // No valid
    29'b11001????????????1???0???????: o=25'b0000000100000001000000000; //{D,C,C,C}; // Prev=Short Idle,DSRL=0->Cur=Long Idle
    29'b11001????????????0???0???????: o=25'b1110000100000001100000000; //{C,C,C,C}; // Prev=Short Idle,DSRL>0->Cur=Data
    29'b11001????????????????1??????0: o=25'b0001000100010000000000000; //{C,C,C,S}; // Prev=Short Idle->Cur=Short Idle
    29'b11001????????????????1?????01: o=25'b0011000100110000000000000; //{C,C,S,S}; // Prev=Short Idle->Cur=2 Short Idles
    29'b11001????????????????1????011: o=25'b0110000101110000000000000; //{C,S,S,S}; // Prev=Short Idle->Cur=3 Short Idles
    29'b11001????????????????1????111: o=25'b1010000111110000000000000; //{S,S,S,S}; // Prev=Short Idle->Cur=(at least) 4 short idles
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = SDCC
    29'b11010????????????????????????: o=25'b1101000100000000000000000; //{S,S,S,D}; // No valid
    29'b11011????????????1???0???????: o=25'b0000000100000001000000000; //{D,C,C,C}; // Prev=Short Idle,DSRL=0->Cur=Long Idle
    29'b11011????????????0???0???????: o=25'b1110000100000001100000000; //{C,C,C,C}; // Prev=Short Idle,DSRL>0->Cur=Data
    29'b11011????????????????1??????0: o=25'b0001000100010000000000000; //{C,C,C,S}; // Prev=Short Idle->Cur=Short Idle
    29'b11011????????????????1?????01: o=25'b0011000100110000000000000; //{C,C,S,S}; // Prev=Short Idle->Cur=2 Short Idles
    29'b11011????????????????1????011: o=25'b0110000101110000000000000; //{C,S,S,S}; // Prev=Short Idle->Cur=3 Short Idles
    29'b11011????????????????1????111: o=25'b1010000111110000000000000; //{S,S,S,S}; // Prev=Short Idle->Cur=(at least) 4 short idles      
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Prev State = CCCC
    29'b11100????????????????????????: o=25'b1110000000000000000000000; //{C,C,C,C}; // No valid
    29'b11101?????????????????0000???: o=25'b1110000100000001000000001; //{C,C,C,C}; // Prev=Data->Cur=Data L3L2L1L0
    29'b11101?????????????????01?????: o=25'b1110100000000001000000001; //{C,C,C,C}; // Prev=Data->Cur=Data L0H3H2H1
    29'b11101?????????????????001????: o=25'b1110010000000001000000001; //{C,C,C,C}; // Prev=Data->Cur=Data L1L0H3H2
    29'b11101?????????????????0001???: o=25'b1110001000000001000000001; //{C,C,C,C}; // Prev=Data->Cur=Data L2L1L0H30
    29'b11101?????????????????1000???: o=25'b0000000100000001000000001; //{D,C,C,C}; // Prev=Last Data->Cur=Control,Replay or Long Idle L3L2L1L0
    29'b11101?????????????????11????0: o=25'b0010100000000001000000001; //{C,C,C,D}; // Prev=Last Data->Cur=Control,Replay or Long Idle L0H3H2H1
    29'b11101?????????????????11???01: o=25'b0100100000100011000000001; //{C,C,S,D}; // Prev=Last Data->Cur=Control,Replay or Long Idle followed by 1 short idle L0H3H2H1
    29'b11101?????????????????11??011: o=25'b0111100001100111000000001; //{C,S,S,D}; // Prev=Last Data->Cur=Control,Replay or Long Idle followed by 2 short idles L0H3H2H1
    29'b11101?????????????????11??111: o=25'b1011100011101111000000001; //{S,S,S,D}; // Prev=Last Data->Cur=Control,Replay or Long Idle followed by (at least) 3 short idles L0H3H2H1
    29'b11101?????????????????101??0?: o=25'b0101010000000001000000001; //{C,C,D,C}; // Prev=Last Data->Cur=Control,Replay or Long Idle L1L0H3H2
    29'b11101?????????????????101?01?: o=25'b1000010001000101000000001; //{C,S,D,C}; // Prev=Last Data->Cur=Control,Replay or Long Idle followed by 1 short idle L1L0H3H2
    29'b11101?????????????????101?11?: o=25'b1100010011001101000000001; //{S,S,D,C}; // Prev=Last Data->Cur=Control,Replay or Long Idle followed by (at least) 2 short idles L1L0H3H2
    29'b11101?????????????????10010??: o=25'b1001001000000001000000001; //{C,D,C,C}; // Prev=Last Data->Cur=Control,Replay or Long Idle L2L1L0H3
    29'b11101?????????????????10011??: o=25'b1101001010001001000000001; //{S,D,C,C}; // Prev=Last Data->Cur=Control,Replay or Long Idle followed by (at leasdt) 1 short idle L2L1L0H3
      //SSSS|::::||||::::||||:|:::|||        SSSS||||::::|||:||||::::|  Unused state
    29'b1111?????????????????????????: o=25'b1111000000000000000000000; 
  endcase	  
end

// FSM outputs
assign cur_st[3:0]           = o[24:21];
assign flit_out_mux_sel[3:0] = o[20:17];
assign sf_crcchk[3:0]        = o[16:13];
assign sf_crcdly[3:1]        = o[12:10];
assign val_out               = o[9];
assign dsrl2rl[3:0]          = o[8:5];
assign rl2rl[3:0]            = o[4:1];
assign dec_rl                = o[0];


// State registers
assign last_st_din[3:0] = cur_st; 	                          	                          

assign last_ds_st_din[3:0] = (last_st_q[3:0] != 4'b1110) ? last_st_q[3:0] :
	                         last_ds_st_q[3:0];

assign last_ds_1_2 = ~last_ds_st_q[3] & ~last_ds_st_q[2] & 
                    (last_ds_st_q[1] ^ last_ds_st_q[0]);
                    
assign last_ds_3_4_5 = (~last_ds_st_q[3] & ~last_ds_st_q[2] & (&last_ds_st_q[1:0])) |
                       (~last_ds_st_q[3] &  last_ds_st_q[2] & ~last_ds_st_q[1]);
                       
assign last_ds_6_7_8_9 = (~last_ds_st_q[3] & last_ds_st_q[2] & last_ds_st_q[1]) |
                         ( last_ds_st_q[3] & ~last_ds_st_q[2] & ~last_ds_st_q[1]);

// Track Run Length
assign run_length_din[3:0] = ld_rl ? new_run_length[3:0] :
	                         dec_rl ? run_length_q[3:0] - 4'b0001 :
	                         run_length_q;

assign new_run_length[3:0] = ({4{dsrl2rl[0]}} & prev_dsrl_l0_q[3:0]) |
                             ({4{dsrl2rl[1]}} & prev_dsrl_l1_q[3:0]) |
                             ({4{dsrl2rl[2]}} & prev_dsrl_l2_q[3:0]) |
                             ({4{dsrl2rl[3]}} & prev_dsrl_l3_q[3:0]) |
                             ({4{rl2rl[0]}} & prev_rl_l0_q[3:0]) |
                             ({4{rl2rl[1]}} & prev_rl_l1_q[3:0]) |
                             ({4{rl2rl[2]}} & prev_rl_l2_q[3:0]) |
                             ({4{rl2rl[3]}} & prev_rl_l3_q[3:0]);

assign ld_rl = |({dsrl2rl[3:0],rl2rl[3:0]});          

assign rl_is_1 = (run_length_q[3:0] == 4'b0001) ? 1 : 0;

// Holding registers
assign holding_din[511:128] = valid_in_q & ~(cur_st == 4'b1010) ? // Not all short idle flits
                              flit_in_q[511:128] : // Latch top 3 lanes of incoming Flit
                              holding_q[511:128];  // Nothing new to latch  

                              
                              
// Multiplex for output flit
assign flit_out_din[511:0] = ({512{flit_out_mux_sel[0]}} &  flit_in_q[511:0]) |
                             ({512{flit_out_mux_sel[1]}} & {flit_in_q[383:0],holding_q[511:384]}) |
                             ({512{flit_out_mux_sel[2]}} & {flit_in_q[255:0],holding_q[511:256]}) |
                             ({512{flit_out_mux_sel[3]}} & {flit_in_q[127:0],holding_q[511:128]}) |
                             ({512{~(|flit_out_mux_sel[3:0])}}&  flit_out_q[511:0]);

//assign flit_out_din[511:0] = flit_in_q[511:0];
assign flit_out = flit_out_q;
assign valid_out = valid_out_q;
assign forced_valid_out = forced_valid_q;

// CRC Checking
assign sf_crc_error = sf_crc_err_q & crcchk_enb;
assign sf_crc_err_din = |(sf_crc_lane_error[3:0]) |               // set
                         (sf_crc_err_q & ~(reset | valid_out_q)); // reset 
assign sf_crc_err_dlyd_din = sf_crc_err_q;
assign force_val_out = sf_crc_err_q & ~sf_crc_err_dlyd_q;
assign sf_crc_lane_error[0] = sf_crc_no_dly[0];
assign sf_crc_lane_error[3:1] = sf_crc_dly_q[3:1] | sf_crc_no_dly[3:1];
assign sf_crc_dly_din[3:1] = sf_crcdly[3:1] & sf_crc_nonzero_gated[3:1];
assign sf_crc_no_dly[0] = sf_crc_nonzero_gated[0];
assign sf_crc_no_dly[3:1] = sf_crc_nonzero_gated[3:1] & ~sf_crcdly[3:1];
assign sf_crc_nonzero_gated = sf_crcchk & sf_crc_nonzero;

ocx_dlx_crc16 crc_lane0
(
   .data (flit_in_q[127:0])
  ,.checkbits_out()
  ,.nonzero_check (sf_crc_nonzero[0])
);

ocx_dlx_crc16 crc_lane1
(
   .data (flit_in_q[255:128])
  ,.checkbits_out() 
  ,.nonzero_check (sf_crc_nonzero[1])
);

ocx_dlx_crc16 crc_lane2
(
   .data (flit_in_q[383:256])
  ,.checkbits_out()
  ,.nonzero_check (sf_crc_nonzero[2])
);

ocx_dlx_crc16 crc_lane3
(
   .data (flit_in_q[511:384])
  ,.checkbits_out()
  ,.nonzero_check (sf_crc_nonzero[3])
);

// ACK Counts
assign sf_ack_cnt_l0_din[4:0] = {5{(sf_crcchk[0] & ~sf_crc_nonzero[0])}} & 
                                flit_in_q[91:87];
assign sf_ack_cnt_l1_din[4:0] = {5{(sf_crcchk[1] & ~sf_crc_nonzero[1])}} &
                                flit_in_q[219:215];
assign sf_ack_cnt_l2_din[4:0] = {5{(sf_crcchk[2] & ~sf_crc_nonzero[2])}} &
                                flit_in_q[347:343];
assign sf_ack_cnt_l3_din[4:0] = {5{(sf_crcchk[3] & ~sf_crc_nonzero[3])}} &
                                flit_in_q[475:471];
assign sf_ack_cnt_total[4:0] = sf_ack_cnt_l0_q[4:0] + sf_ack_cnt_l1_q[4:0] +
                               sf_ack_cnt_l2_q[4:0] + sf_ack_cnt_l3_q[4:0];

assign sf_ack_cnt_din[4:0] = sf_ack_cnt_total[4:0];
assign sf_ack_cnt = sf_ack_cnt_q[4:0];

//Recal Status
assign sf_recal_status_din[1:0] = (sf_crcchk[3] & (sf_crc_nonzero[3:0] == 4'b0000)) ? flit_in_q[470:469] : 
                                  (sf_crcchk[2] & (sf_crc_nonzero[2:0] == 3'b000))  ? flit_in_q[342:341] :
                                  (sf_crcchk[1] & (sf_crc_nonzero[1:0] == 2'b00))   ? flit_in_q[214:213] :
                                  (sf_crcchk[0] & ~sf_crc_nonzero[0])               ? flit_in_q[86:85]   : 2'b00;

assign sf_recal_status[1:0] = sf_recal_status_q[1:0];

endmodule //-- ocx_dlx_rx_bs
