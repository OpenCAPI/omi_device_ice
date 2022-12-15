`timescale 1ns / 1ps
// RAM (BRAM) with 1 read port one write port and one clock
//  Intended for synthesis to xilinx BRAM (especially if big)
// From: https://www.xilinx.com/support/documentation/sw_manuals/xilinx2014_2/ug901-vivado-synthesis.pdf
//       page 104 "Simple Dual-Port Block RAM with Single Clock Verilog Coding Example"

module iram_1r1w1ck_64x16
   (clk,ena,enb,wea,addra,addrb,dia,dob);
   input clk,ena,enb,wea;
   input [5:0] addra,addrb;
   input [15:0] dia;
   output [15:0] dob;
   reg[15:0] ram [63:0];
   reg[15:0] dob;

always @(posedge clk) begin
 if (ena) begin
    if (wea)
        ram[addra] <= dia;
 end
end

always @(posedge clk) begin
  if (enb)
    dob <= ram[addrb];
end

endmodule

