// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
// This module describes SIMD Inference 
// 4 adders packed into single DSP block
`timescale 100ps/100ps

(* use_dsp = "simd" *)
(* dont_touch = "1" *)  
module rtl_model (input            ap_clk, ap_rst, ap_ce, ap_start, ap_continue,
                  input [9:0]      a1, a2, a3, a4, b1, b2, b3, b4,
                  output           ap_idle, ap_done, ap_ready,
                  output           z1_ap_vld, z2_ap_vld, z3_ap_vld, z4_ap_vld,
                  output reg [9:0] z1, z2, z3, z4);

   wire ce = ap_ce;
   
   reg [9:0] areg1, areg2, areg3, areg4;
   reg [9:0] breg1, breg2, breg3, breg4;
   reg       dly1, dly2;
   
   always @ (posedge ap_clk)
     if (ap_rst)
       begin
          z1    <= 0;
          z2    <= 0;
          z3    <= 0;
          z4    <= 0;
          areg1 <= 0;
          areg2 <= 0;
          areg3 <= 0;
          areg4 <= 0;
          breg1 <= 0;
          breg2 <= 0;
          breg3 <= 0;
          breg4 <= 0;
          dly1  <= 0;
          dly2  <= 0;     
       end
     else if (ce)
       begin
          z1    <= areg1 + breg1;
          z2    <= areg2 + breg2;
          z3    <= areg3 + breg3;
          z4    <= areg4 + breg4;
          areg1 <= a1;
          areg2 <= a2;
          areg3 <= a3;
          areg4 <= a4;
          breg1 <= b1;
          breg2 <= b2;
          breg3 <= b3;
          breg4 <= b4;
          dly1  <= ap_start;
          dly2  <= dly1;          
       end

   assign z1_ap_vld = dly2;
   assign z2_ap_vld = dly2;
   assign z3_ap_vld = dly2;
   assign z4_ap_vld = dly2;
   assign ap_ready  = dly2;
   assign ap_done   = dly2;
   assign ap_idle   = ~ap_start;
      
endmodule // rtl_model
