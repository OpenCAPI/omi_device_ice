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



module ocx_dlx_crc16 (  
   data                     // < input  [127:0]
  ,checkbits_out            // > output
  ,nonzero_check            // > output 
);

input   [127:0]    data;
output  [35:0]     checkbits_out;
output             nonzero_check;

wire   [35:0]   temp_checkbits;


assign temp_checkbits[0] = data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[11] ^ data[12] ^ data[14] ^ data[15] ^ data[21] ^ data[26] ^ data[27] ^ data[28] ^ data[30] ^ data[34] ^ data[36] ^ data[39] ^ data[40] ^ data[42] ^ data[49] ^ data[51] ^ data[52] ^ data[58] ^ data[60] ^ data[62] ^ data[63] ^ data[66] ^ data[68] ^ data[69] ^ data[70] ^ data[71] ^ data[76] ^ data[77] ^ data[78] ^ data[82] ^ data[84] ^ data[87] ^ data[88] ^ data[90] ^ data[92];

assign temp_checkbits[1] = data[0] ^ data[2] ^ data[3] ^ data[4] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[11] ^ data[12] ^ data[13] ^ data[15] ^ data[16] ^ data[22] ^ data[27] ^ data[28] ^ data[29] ^ data[31] ^ data[35] ^ data[37] ^ data[40] ^ data[41] ^ data[43] ^ data[50] ^ data[52] ^ data[53] ^ data[59] ^ data[61] ^ data[63] ^ data[64] ^ data[67] ^ data[69] ^ data[70] ^ data[71] ^ data[72] ^ data[77] ^ data[78] ^ data[79] ^ data[83] ^ data[85] ^ data[88] ^ data[89] ^ data[91] ^ data[93];

assign temp_checkbits[2] = data[0] ^ data[2] ^ data[4] ^ data[6] ^ data[13] ^ data[15] ^ data[16] ^ data[17] ^ data[21] ^ data[23] ^ data[26] ^ data[27] ^ data[29] ^ data[32] ^ data[34] ^ data[38] ^ data[39] ^ data[40] ^ data[41] ^ data[44] ^ data[49] ^ data[52] ^ data[53] ^ data[54] ^ data[58] ^ data[63] ^ data[64] ^ data[65] ^ data[66] ^ data[69] ^ data[72] ^ data[73] ^ data[76] ^ data[77] ^ data[79] ^ data[80] ^ data[82] ^ data[86] ^ data[87] ^ data[88] ^ data[89] ^ data[94];

assign temp_checkbits[3] = data[1] ^ data[3] ^ data[5] ^ data[7] ^ data[14] ^ data[16] ^ data[17] ^ data[18] ^ data[22] ^ data[24] ^ data[27] ^ data[28] ^ data[30] ^ data[33] ^ data[35] ^ data[39] ^ data[40] ^ data[41] ^ data[42] ^ data[45] ^ data[50] ^ data[53] ^ data[54] ^ data[55] ^ data[59] ^ data[64] ^ data[65] ^ data[66] ^ data[67] ^ data[70] ^ data[73] ^ data[74] ^ data[77] ^ data[78] ^ data[80] ^ data[81] ^ data[83] ^ data[87] ^ data[88] ^ data[89] ^ data[90] ^ data[95];

assign temp_checkbits[4] = data[2] ^ data[4] ^ data[6] ^ data[8] ^ data[15] ^ data[17] ^ data[18] ^ data[19] ^ data[23] ^ data[25] ^ data[28] ^ data[29] ^ data[31] ^ data[34] ^ data[36] ^ data[40] ^ data[41] ^ data[42] ^ data[43] ^ data[46] ^ data[51] ^ data[54] ^ data[55] ^ data[56] ^ data[60] ^ data[65] ^ data[66] ^ data[67] ^ data[68] ^ data[71] ^ data[74] ^ data[75] ^ data[78] ^ data[79] ^ data[81] ^ data[82] ^ data[84] ^ data[88] ^ data[89] ^ data[90] ^ data[91] ^ data[96];

assign temp_checkbits[5] = data[1] ^ data[2] ^ data[6] ^ data[8] ^ data[10] ^ data[11] ^ data[12] ^ data[14] ^ data[15] ^ data[16] ^ data[18] ^ data[19] ^ data[20] ^ data[21] ^ data[24] ^ data[27] ^ data[28] ^ data[29] ^ data[32] ^ data[34] ^ data[35] ^ data[36] ^ data[37] ^ data[39] ^ data[40] ^ data[41] ^ data[43] ^ data[44] ^ data[47] ^ data[49] ^ data[51] ^ data[55] ^ data[56] ^ data[57] ^ data[58] ^ data[60] ^ data[61] ^ data[62] ^ data[63] ^ data[67] ^ data[70] ^ data[71] ^ data[72] ^ data[75] ^ data[77] ^ data[78] ^ data[79] ^ data[80] ^ data[83] ^ data[84] ^ data[85] ^ data[87] ^ data[88] ^ data[89] ^ data[91] ^ data[97];

assign temp_checkbits[6] = data[0] ^ data[1] ^ data[5] ^ data[6] ^ data[8] ^ data[10] ^ data[13] ^ data[14] ^ data[16] ^ data[17] ^ data[19] ^ data[20] ^ data[22] ^ data[25] ^ data[26] ^ data[27] ^ data[29] ^ data[33] ^ data[34] ^ data[35] ^ data[37] ^ data[38] ^ data[39] ^ data[41] ^ data[44] ^ data[45] ^ data[48] ^ data[49] ^ data[50] ^ data[51] ^ data[56] ^ data[57] ^ data[59] ^ data[60] ^ data[61] ^ data[64] ^ data[66] ^ data[69] ^ data[70] ^ data[72] ^ data[73] ^ data[77] ^ data[79] ^ data[80] ^ data[81] ^ data[82] ^ data[85] ^ data[86] ^ data[87] ^ data[89] ^ data[98];

assign temp_checkbits[7] = data[0] ^ data[1] ^ data[2] ^ data[6] ^ data[7] ^ data[9] ^ data[11] ^ data[14] ^ data[15] ^ data[17] ^ data[18] ^ data[20] ^ data[21] ^ data[23] ^ data[26] ^ data[27] ^ data[28] ^ data[30] ^ data[34] ^ data[35] ^ data[36] ^ data[38] ^ data[39] ^ data[40] ^ data[42] ^ data[45] ^ data[46] ^ data[49] ^ data[50] ^ data[51] ^ data[52] ^ data[57] ^ data[58] ^ data[60] ^ data[61] ^ data[62] ^ data[65] ^ data[67] ^ data[70] ^ data[71] ^ data[73] ^ data[74] ^ data[78] ^ data[80] ^ data[81] ^ data[82] ^ data[83] ^ data[86] ^ data[87] ^ data[88] ^ data[90] ^ data[99];

assign temp_checkbits[8] = data[1] ^ data[2] ^ data[3] ^ data[7] ^ data[8] ^ data[10] ^ data[12] ^ data[15] ^ data[16] ^ data[18] ^ data[19] ^ data[21] ^ data[22] ^ data[24] ^ data[27] ^ data[28] ^ data[29] ^ data[31] ^ data[35] ^ data[36] ^ data[37] ^ data[39] ^ data[40] ^ data[41] ^ data[43] ^ data[46] ^ data[47] ^ data[50] ^ data[51] ^ data[52] ^ data[53] ^ data[58] ^ data[59] ^ data[61] ^ data[62] ^ data[63] ^ data[66] ^ data[68] ^ data[71] ^ data[72] ^ data[74] ^ data[75] ^ data[79] ^ data[81] ^ data[82] ^ data[83] ^ data[84] ^ data[87] ^ data[88] ^ data[89] ^ data[91] ^ data[100];

assign temp_checkbits[9] = data[1] ^ data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[10] ^ data[12] ^ data[13] ^ data[14] ^ data[15] ^ data[16] ^ data[17] ^ data[19] ^ data[20] ^ data[21] ^ data[22] ^ data[23] ^ data[25] ^ data[26] ^ data[27] ^ data[29] ^ data[32] ^ data[34] ^ data[37] ^ data[38] ^ data[39] ^ data[41] ^ data[44] ^ data[47] ^ data[48] ^ data[49] ^ data[53] ^ data[54] ^ data[58] ^ data[59] ^ data[64] ^ data[66] ^ data[67] ^ data[68] ^ data[70] ^ data[71] ^ data[72] ^ data[73] ^ data[75] ^ data[77] ^ data[78] ^ data[80] ^ data[83] ^ data[85] ^ data[87] ^ data[89] ^ data[101];

assign temp_checkbits[10] = data[0] ^ data[2] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[11] ^ data[13] ^ data[14] ^ data[15] ^ data[16] ^ data[17] ^ data[18] ^ data[20] ^ data[21] ^ data[22] ^ data[23] ^ data[24] ^ data[26] ^ data[27] ^ data[28] ^ data[30] ^ data[33] ^ data[35] ^ data[38] ^ data[39] ^ data[40] ^ data[42] ^ data[45] ^ data[48] ^ data[49] ^ data[50] ^ data[54] ^ data[55] ^ data[59] ^ data[60] ^ data[65] ^ data[67] ^ data[68] ^ data[69] ^ data[71] ^ data[72] ^ data[73] ^ data[74] ^ data[76] ^ data[78] ^ data[79] ^ data[81] ^ data[84] ^ data[86] ^ data[88] ^ data[90] ^ data[102];

assign temp_checkbits[11] = data[1] ^ data[3] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[12] ^ data[14] ^ data[15] ^ data[16] ^ data[17] ^ data[18] ^ data[19] ^ data[21] ^ data[22] ^ data[23] ^ data[24] ^ data[25] ^ data[27] ^ data[28] ^ data[29] ^ data[31] ^ data[34] ^ data[36] ^ data[39] ^ data[40] ^ data[41] ^ data[43] ^ data[46] ^ data[49] ^ data[50] ^ data[51] ^ data[55] ^ data[56] ^ data[60] ^ data[61] ^ data[66] ^ data[68] ^ data[69] ^ data[70] ^ data[72] ^ data[73] ^ data[74] ^ data[75] ^ data[77] ^ data[79] ^ data[80] ^ data[82] ^ data[85] ^ data[87] ^ data[89] ^ data[91] ^ data[103];

assign temp_checkbits[12] = data[1] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[11] ^ data[12] ^ data[13] ^ data[14] ^ data[16] ^ data[17] ^ data[18] ^ data[19] ^ data[20] ^ data[21] ^ data[22] ^ data[23] ^ data[24] ^ data[25] ^ data[27] ^ data[29] ^ data[32] ^ data[34] ^ data[35] ^ data[36] ^ data[37] ^ data[39] ^ data[41] ^ data[44] ^ data[47] ^ data[49] ^ data[50] ^ data[56] ^ data[57] ^ data[58] ^ data[60] ^ data[61] ^ data[63] ^ data[66] ^ data[67] ^ data[68] ^ data[73] ^ data[74] ^ data[75] ^ data[77] ^ data[80] ^ data[81] ^ data[82] ^ data[83] ^ data[84] ^ data[86] ^ data[87] ^ data[104];

assign temp_checkbits[13] = data[2] ^ data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[12] ^ data[13] ^ data[14] ^ data[15] ^ data[17] ^ data[18] ^ data[19] ^ data[20] ^ data[21] ^ data[22] ^ data[23] ^ data[24] ^ data[25] ^ data[26] ^ data[28] ^ data[30] ^ data[33] ^ data[35] ^ data[36] ^ data[37] ^ data[38] ^ data[40] ^ data[42] ^ data[45] ^ data[48] ^ data[50] ^ data[51] ^ data[57] ^ data[58] ^ data[59] ^ data[61] ^ data[62] ^ data[64] ^ data[67] ^ data[68] ^ data[69] ^ data[74] ^ data[75] ^ data[76] ^ data[78] ^ data[81] ^ data[82] ^ data[83] ^ data[84] ^ data[85] ^ data[87] ^ data[88] ^ data[105];

assign temp_checkbits[14] = data[3] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[13] ^ data[14] ^ data[15] ^ data[16] ^ data[18] ^ data[19] ^ data[20] ^ data[21] ^ data[22] ^ data[23] ^ data[24] ^ data[25] ^ data[26] ^ data[27] ^ data[29] ^ data[31] ^ data[34] ^ data[36] ^ data[37] ^ data[38] ^ data[39] ^ data[41] ^ data[43] ^ data[46] ^ data[49] ^ data[51] ^ data[52] ^ data[58] ^ data[59] ^ data[60] ^ data[62] ^ data[63] ^ data[65] ^ data[68] ^ data[69] ^ data[70] ^ data[75] ^ data[76] ^ data[77] ^ data[79] ^ data[82] ^ data[83] ^ data[84] ^ data[85] ^ data[86] ^ data[88] ^ data[89] ^ data[106];

assign temp_checkbits[15] = data[4] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[14] ^ data[15] ^ data[16] ^ data[17] ^ data[19] ^ data[20] ^ data[21] ^ data[22] ^ data[23] ^ data[24] ^ data[25] ^ data[26] ^ data[27] ^ data[28] ^ data[30] ^ data[32] ^ data[35] ^ data[37] ^ data[38] ^ data[39] ^ data[40] ^ data[42] ^ data[44] ^ data[47] ^ data[50] ^ data[52] ^ data[53] ^ data[59] ^ data[60] ^ data[61] ^ data[63] ^ data[64] ^ data[66] ^ data[69] ^ data[70] ^ data[71] ^ data[76] ^ data[77] ^ data[78] ^ data[80] ^ data[83] ^ data[84] ^ data[85] ^ data[86] ^ data[87] ^ data[89] ^ data[90] ^ data[107];

assign temp_checkbits[16] = data[0] ^ data[5] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[15] ^ data[16] ^ data[17] ^ data[18] ^ data[20] ^ data[21] ^ data[22] ^ data[23] ^ data[24] ^ data[25] ^ data[26] ^ data[27] ^ data[28] ^ data[29] ^ data[31] ^ data[33] ^ data[36] ^ data[38] ^ data[39] ^ data[40] ^ data[41] ^ data[43] ^ data[45] ^ data[48] ^ data[51] ^ data[53] ^ data[54] ^ data[60] ^ data[61] ^ data[62] ^ data[64] ^ data[65] ^ data[67] ^ data[70] ^ data[71] ^ data[72] ^ data[77] ^ data[78] ^ data[79] ^ data[81] ^ data[84] ^ data[85] ^ data[86] ^ data[87] ^ data[88] ^ data[90] ^ data[91] ^ data[108];

assign temp_checkbits[17] = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[7] ^ data[12] ^ data[14] ^ data[15] ^ data[16] ^ data[17] ^ data[18] ^ data[19] ^ data[22] ^ data[23] ^ data[24] ^ data[25] ^ data[29] ^ data[32] ^ data[36] ^ data[37] ^ data[41] ^ data[44] ^ data[46] ^ data[51] ^ data[54] ^ data[55] ^ data[58] ^ data[60] ^ data[61] ^ data[65] ^ data[69] ^ data[70] ^ data[72] ^ data[73] ^ data[76] ^ data[77] ^ data[79] ^ data[80] ^ data[84] ^ data[85] ^ data[86] ^ data[89] ^ data[90] ^ data[91] ^ data[109];

assign temp_checkbits[18] = data[0] ^ data[2] ^ data[4] ^ data[5] ^ data[7] ^ data[9] ^ data[10] ^ data[11] ^ data[12] ^ data[13] ^ data[14] ^ data[16] ^ data[17] ^ data[18] ^ data[19] ^ data[20] ^ data[21] ^ data[23] ^ data[24] ^ data[25] ^ data[27] ^ data[28] ^ data[33] ^ data[34] ^ data[36] ^ data[37] ^ data[38] ^ data[39] ^ data[40] ^ data[45] ^ data[47] ^ data[49] ^ data[51] ^ data[55] ^ data[56] ^ data[58] ^ data[59] ^ data[60] ^ data[61] ^ data[63] ^ data[68] ^ data[69] ^ data[73] ^ data[74] ^ data[76] ^ data[80] ^ data[81] ^ data[82] ^ data[84] ^ data[85] ^ data[86] ^ data[88] ^ data[91] ^ data[110];

assign temp_checkbits[19] = data[0] ^ data[2] ^ data[7] ^ data[9] ^ data[13] ^ data[17] ^ data[18] ^ data[19] ^ data[20] ^ data[22] ^ data[24] ^ data[25] ^ data[27] ^ data[29] ^ data[30] ^ data[35] ^ data[36] ^ data[37] ^ data[38] ^ data[41] ^ data[42] ^ data[46] ^ data[48] ^ data[49] ^ data[50] ^ data[51] ^ data[56] ^ data[57] ^ data[58] ^ data[59] ^ data[61] ^ data[63] ^ data[64] ^ data[66] ^ data[68] ^ data[71] ^ data[74] ^ data[75] ^ data[76] ^ data[78] ^ data[81] ^ data[83] ^ data[84] ^ data[85] ^ data[86] ^ data[88] ^ data[89] ^ data[90] ^ data[111];

assign temp_checkbits[20] = data[0] ^ data[1] ^ data[3] ^ data[8] ^ data[10] ^ data[14] ^ data[18] ^ data[19] ^ data[20] ^ data[21] ^ data[23] ^ data[25] ^ data[26] ^ data[28] ^ data[30] ^ data[31] ^ data[36] ^ data[37] ^ data[38] ^ data[39] ^ data[42] ^ data[43] ^ data[47] ^ data[49] ^ data[50] ^ data[51] ^ data[52] ^ data[57] ^ data[58] ^ data[59] ^ data[60] ^ data[62] ^ data[64] ^ data[65] ^ data[67] ^ data[69] ^ data[72] ^ data[75] ^ data[76] ^ data[77] ^ data[79] ^ data[82] ^ data[84] ^ data[85] ^ data[86] ^ data[87] ^ data[89] ^ data[90] ^ data[91] ^ data[112];

assign temp_checkbits[21] = data[0] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[10] ^ data[12] ^ data[14] ^ data[19] ^ data[20] ^ data[22] ^ data[24] ^ data[28] ^ data[29] ^ data[30] ^ data[31] ^ data[32] ^ data[34] ^ data[36] ^ data[37] ^ data[38] ^ data[42] ^ data[43] ^ data[44] ^ data[48] ^ data[49] ^ data[50] ^ data[53] ^ data[59] ^ data[61] ^ data[62] ^ data[65] ^ data[69] ^ data[71] ^ data[73] ^ data[80] ^ data[82] ^ data[83] ^ data[84] ^ data[85] ^ data[86] ^ data[91] ^ data[113];

assign temp_checkbits[22] = data[2] ^ data[3] ^ data[4] ^ data[10] ^ data[12] ^ data[13] ^ data[14] ^ data[20] ^ data[23] ^ data[25] ^ data[26] ^ data[27] ^ data[28] ^ data[29] ^ data[31] ^ data[32] ^ data[33] ^ data[34] ^ data[35] ^ data[36] ^ data[37] ^ data[38] ^ data[40] ^ data[42] ^ data[43] ^ data[44] ^ data[45] ^ data[50] ^ data[52] ^ data[54] ^ data[58] ^ data[68] ^ data[69] ^ data[71] ^ data[72] ^ data[74] ^ data[76] ^ data[77] ^ data[78] ^ data[81] ^ data[82] ^ data[83] ^ data[85] ^ data[86] ^ data[88] ^ data[90] ^ data[114];

assign temp_checkbits[23] = data[3] ^ data[4] ^ data[5] ^ data[11] ^ data[13] ^ data[14] ^ data[15] ^ data[21] ^ data[24] ^ data[26] ^ data[27] ^ data[28] ^ data[29] ^ data[30] ^ data[32] ^ data[33] ^ data[34] ^ data[35] ^ data[36] ^ data[37] ^ data[38] ^ data[39] ^ data[41] ^ data[43] ^ data[44] ^ data[45] ^ data[46] ^ data[51] ^ data[53] ^ data[55] ^ data[59] ^ data[69] ^ data[70] ^ data[72] ^ data[73] ^ data[75] ^ data[77] ^ data[78] ^ data[79] ^ data[82] ^ data[83] ^ data[84] ^ data[86] ^ data[87] ^ data[89] ^ data[91] ^ data[115];

assign temp_checkbits[24] = data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[11] ^ data[16] ^ data[21] ^ data[22] ^ data[25] ^ data[26] ^ data[29] ^ data[31] ^ data[33] ^ data[35] ^ data[37] ^ data[38] ^ data[44] ^ data[45] ^ data[46] ^ data[47] ^ data[49] ^ data[51] ^ data[54] ^ data[56] ^ data[58] ^ data[62] ^ data[63] ^ data[66] ^ data[68] ^ data[69] ^ data[73] ^ data[74] ^ data[77] ^ data[79] ^ data[80] ^ data[82] ^ data[83] ^ data[85] ^ data[116];

assign temp_checkbits[25] = data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[8] ^ data[9] ^ data[10] ^ data[11] ^ data[12] ^ data[17] ^ data[22] ^ data[23] ^ data[26] ^ data[27] ^ data[30] ^ data[32] ^ data[34] ^ data[36] ^ data[38] ^ data[39] ^ data[45] ^ data[46] ^ data[47] ^ data[48] ^ data[50] ^ data[52] ^ data[55] ^ data[57] ^ data[59] ^ data[63] ^ data[64] ^ data[67] ^ data[69] ^ data[70] ^ data[74] ^ data[75] ^ data[78] ^ data[80] ^ data[81] ^ data[83] ^ data[84] ^ data[86] ^ data[117];

assign temp_checkbits[26] = data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[9] ^ data[10] ^ data[11] ^ data[12] ^ data[13] ^ data[18] ^ data[23] ^ data[24] ^ data[27] ^ data[28] ^ data[31] ^ data[33] ^ data[35] ^ data[37] ^ data[39] ^ data[40] ^ data[46] ^ data[47] ^ data[48] ^ data[49] ^ data[51] ^ data[53] ^ data[56] ^ data[58] ^ data[60] ^ data[64] ^ data[65] ^ data[68] ^ data[70] ^ data[71] ^ data[75] ^ data[76] ^ data[79] ^ data[81] ^ data[82] ^ data[84] ^ data[85] ^ data[87] ^ data[118];

assign temp_checkbits[27] = data[0] ^ data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[10] ^ data[11] ^ data[12] ^ data[13] ^ data[14] ^ data[19] ^ data[24] ^ data[25] ^ data[28] ^ data[29] ^ data[32] ^ data[34] ^ data[36] ^ data[38] ^ data[40] ^ data[41] ^ data[47] ^ data[48] ^ data[49] ^ data[50] ^ data[52] ^ data[54] ^ data[57] ^ data[59] ^ data[61] ^ data[65] ^ data[66] ^ data[69] ^ data[71] ^ data[72] ^ data[76] ^ data[77] ^ data[80] ^ data[82] ^ data[83] ^ data[85] ^ data[86] ^ data[88] ^ data[119];

assign temp_checkbits[28] = data[1] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[11] ^ data[12] ^ data[13] ^ data[14] ^ data[15] ^ data[20] ^ data[25] ^ data[26] ^ data[29] ^ data[30] ^ data[33] ^ data[35] ^ data[37] ^ data[39] ^ data[41] ^ data[42] ^ data[48] ^ data[49] ^ data[50] ^ data[51] ^ data[53] ^ data[55] ^ data[58] ^ data[60] ^ data[62] ^ data[66] ^ data[67] ^ data[70] ^ data[72] ^ data[73] ^ data[77] ^ data[78] ^ data[81] ^ data[83] ^ data[84] ^ data[86] ^ data[87] ^ data[89] ^ data[120];

assign temp_checkbits[29] = data[2] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[12] ^ data[13] ^ data[14] ^ data[15] ^ data[16] ^ data[21] ^ data[26] ^ data[27] ^ data[30] ^ data[31] ^ data[34] ^ data[36] ^ data[38] ^ data[40] ^ data[42] ^ data[43] ^ data[49] ^ data[50] ^ data[51] ^ data[52] ^ data[54] ^ data[56] ^ data[59] ^ data[61] ^ data[63] ^ data[67] ^ data[68] ^ data[71] ^ data[73] ^ data[74] ^ data[78] ^ data[79] ^ data[82] ^ data[84] ^ data[85] ^ data[87] ^ data[88] ^ data[90] ^ data[121];

assign temp_checkbits[30] = data[0] ^ data[3] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[13] ^ data[14] ^ data[15] ^ data[16] ^ data[17] ^ data[22] ^ data[27] ^ data[28] ^ data[31] ^ data[32] ^ data[35] ^ data[37] ^ data[39] ^ data[41] ^ data[43] ^ data[44] ^ data[50] ^ data[51] ^ data[52] ^ data[53] ^ data[55] ^ data[57] ^ data[60] ^ data[62] ^ data[64] ^ data[68] ^ data[69] ^ data[72] ^ data[74] ^ data[75] ^ data[79] ^ data[80] ^ data[83] ^ data[85] ^ data[86] ^ data[88] ^ data[89] ^ data[91] ^ data[122];

assign temp_checkbits[31] = data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[12] ^ data[16] ^ data[17] ^ data[18] ^ data[21] ^ data[23] ^ data[26] ^ data[27] ^ data[29] ^ data[30] ^ data[32] ^ data[33] ^ data[34] ^ data[38] ^ data[39] ^ data[44] ^ data[45] ^ data[49] ^ data[53] ^ data[54] ^ data[56] ^ data[60] ^ data[61] ^ data[62] ^ data[65] ^ data[66] ^ data[68] ^ data[71] ^ data[73] ^ data[75] ^ data[77] ^ data[78] ^ data[80] ^ data[81] ^ data[82] ^ data[86] ^ data[88] ^ data[89] ^ data[123];

assign temp_checkbits[32] = data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[13] ^ data[17] ^ data[18] ^ data[19] ^ data[22] ^ data[24] ^ data[27] ^ data[28] ^ data[30] ^ data[31] ^ data[33] ^ data[34] ^ data[35] ^ data[39] ^ data[40] ^ data[45] ^ data[46] ^ data[50] ^ data[54] ^ data[55] ^ data[57] ^ data[61] ^ data[62] ^ data[63] ^ data[66] ^ data[67] ^ data[69] ^ data[72] ^ data[74] ^ data[76] ^ data[78] ^ data[79] ^ data[81] ^ data[82] ^ data[83] ^ data[87] ^ data[89] ^ data[90] ^ data[124];

assign temp_checkbits[33] = data[0] ^ data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[14] ^ data[18] ^ data[19] ^ data[20] ^ data[23] ^ data[25] ^ data[28] ^ data[29] ^ data[31] ^ data[32] ^ data[34] ^ data[35] ^ data[36] ^ data[40] ^ data[41] ^ data[46] ^ data[47] ^ data[51] ^ data[55] ^ data[56] ^ data[58] ^ data[62] ^ data[63] ^ data[64] ^ data[67] ^ data[68] ^ data[70] ^ data[73] ^ data[75] ^ data[77] ^ data[79] ^ data[80] ^ data[82] ^ data[83] ^ data[84] ^ data[88] ^ data[90] ^ data[91] ^ data[125];

assign temp_checkbits[34] = data[2] ^ data[3] ^ data[11] ^ data[12] ^ data[14] ^ data[19] ^ data[20] ^ data[24] ^ data[27] ^ data[28] ^ data[29] ^ data[32] ^ data[33] ^ data[34] ^ data[35] ^ data[37] ^ data[39] ^ data[40] ^ data[41] ^ data[47] ^ data[48] ^ data[49] ^ data[51] ^ data[56] ^ data[57] ^ data[58] ^ data[59] ^ data[60] ^ data[62] ^ data[64] ^ data[65] ^ data[66] ^ data[70] ^ data[74] ^ data[77] ^ data[80] ^ data[81] ^ data[82] ^ data[83] ^ data[85] ^ data[87] ^ data[88] ^ data[89] ^ data[90] ^ data[91] ^ data[126];

assign temp_checkbits[35] = data[0] ^ data[1] ^ data[2] ^ data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[11] ^ data[13] ^ data[14] ^ data[20] ^ data[25] ^ data[26] ^ data[27] ^ data[29] ^ data[33] ^ data[35] ^ data[38] ^ data[39] ^ data[41] ^ data[48] ^ data[50] ^ data[51] ^ data[57] ^ data[59] ^ data[61] ^ data[62] ^ data[65] ^ data[67] ^ data[68] ^ data[69] ^ data[70] ^ data[75] ^ data[76] ^ data[77] ^ data[81] ^ data[83] ^ data[86] ^ data[87] ^ data[89] ^ data[91] ^ data[127];


assign checkbits_out[35:0] = temp_checkbits[35:0];
assign nonzero_check       = |(temp_checkbits[35:0]);

endmodule
