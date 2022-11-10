// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="ellipf,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=7.405000,HLS_SYN_LAT=2,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=33,HLS_SYN_LUT=261,HLS_VERSION=2020_1}" *)

module ellipf (
        ap_clk,
        ap_rst,
        in_ports_V,
        out_ports_V,
        out_ports_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 3'd1;
parameter    ap_ST_fsm_state2 = 3'd2;
parameter    ap_ST_fsm_state3 = 3'd4;

input   ap_clk;
input   ap_rst;
input  [31:0] in_ports_V;
output  [31:0] out_ports_V;
output   out_ports_V_ap_vld;

reg out_ports_V_ap_vld;

wire   [3:0] inp_V_fu_77_p1;
reg   [3:0] inp_V_reg_318;
(* fsm_encoding = "none" *) reg   [2:0] ap_CS_fsm;
wire    ap_CS_fsm_state2;
wire   [3:0] sv39_V_fu_121_p4;
reg   [3:0] sv39_V_reg_323;
wire   [3:0] n1_V_fu_131_p2;
reg   [3:0] n1_V_reg_329;
wire   [3:0] n2_V_fu_137_p2;
reg   [3:0] n2_V_reg_335;
wire   [3:0] n3_V_fu_143_p2;
reg   [3:0] n3_V_reg_341;
wire   [3:0] n5_V_fu_155_p2;
reg   [3:0] n5_V_reg_347;
reg   [2:0] tmp_reg_354;
reg   [2:0] tmp_1_reg_359;
wire    ap_CS_fsm_state3;
wire   [3:0] sv2_V_fu_81_p4;
wire   [3:0] sv33_V_fu_111_p4;
wire   [3:0] sv13_V_fu_91_p4;
wire   [3:0] sv26_V_fu_101_p4;
wire   [3:0] add_ln209_fu_149_p2;
wire   [3:0] n8_V_fu_181_p2;
wire   [3:0] add_ln209_4_fu_189_p2;
wire   [3:0] n9_V_fu_185_p2;
wire   [3:0] add_ln209_6_fu_199_p2;
wire   [3:0] n15_V_fu_194_p2;
wire   [3:0] n16_V_fu_204_p2;
wire   [3:0] factor_fu_225_p3;
wire   [3:0] add_ln209_11_fu_232_p2;
wire   [3:0] factor1_fu_244_p3;
wire   [3:0] n19_V_fu_214_p2;
wire   [3:0] n17_V_fu_209_p2;
wire   [3:0] add_ln209_14_fu_257_p2;
wire   [3:0] n28_V_fu_238_p2;
wire   [3:0] add_ln209_17_fu_274_p2;
wire   [3:0] n29_V_fu_251_p2;
wire   [3:0] n20_V_fu_220_p2;
wire   [3:0] sv39_o_V_fu_291_p2;
wire   [3:0] sv33_o_V_fu_285_p2;
wire   [3:0] sv26_o_V_fu_279_p2;
wire   [3:0] sv13_o_V_fu_268_p2;
wire   [3:0] sv2_o_V_fu_262_p2;
reg   [2:0] ap_NS_fsm;

// power-on initialization
initial begin
#0 ap_CS_fsm = 3'd1;
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        inp_V_reg_318 <= inp_V_fu_77_p1;
        n1_V_reg_329 <= n1_V_fu_131_p2;
        n2_V_reg_335 <= n2_V_fu_137_p2;
        n3_V_reg_341 <= n3_V_fu_143_p2;
        n5_V_reg_347 <= n5_V_fu_155_p2;
        sv39_V_reg_323 <= {{in_ports_V[31:28]}};
        tmp_1_reg_359 <= {{in_ports_V[26:24]}};
        tmp_reg_354 <= {{in_ports_V[14:12]}};
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        out_ports_V_ap_vld = 1'b1;
    end else begin
        out_ports_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        ap_ST_fsm_state2 : begin
            ap_NS_fsm = ap_ST_fsm_state3;
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_state1;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign add_ln209_11_fu_232_p2 = (n15_V_fu_194_p2 + factor_fu_225_p3);

assign add_ln209_14_fu_257_p2 = (n17_V_fu_209_p2 + inp_V_reg_318);

assign add_ln209_17_fu_274_p2 = (n9_V_fu_185_p2 + n5_V_reg_347);

assign add_ln209_4_fu_189_p2 = (n8_V_fu_181_p2 + n1_V_reg_329);

assign add_ln209_6_fu_199_p2 = (n9_V_fu_185_p2 + sv39_V_reg_323);

assign add_ln209_fu_149_p2 = (n3_V_fu_143_p2 + sv26_V_fu_101_p4);

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign factor1_fu_244_p3 = {{tmp_1_reg_359}, {1'd0}};

assign factor_fu_225_p3 = {{tmp_reg_354}, {1'd0}};

assign inp_V_fu_77_p1 = in_ports_V[3:0];

assign n15_V_fu_194_p2 = (n3_V_reg_341 + add_ln209_4_fu_189_p2);

assign n16_V_fu_204_p2 = (n2_V_reg_335 + add_ln209_6_fu_199_p2);

assign n17_V_fu_209_p2 = (n1_V_reg_329 + n15_V_fu_194_p2);

assign n19_V_fu_214_p2 = (n9_V_fu_185_p2 + n16_V_fu_204_p2);

assign n1_V_fu_131_p2 = (inp_V_fu_77_p1 + sv2_V_fu_81_p4);

assign n20_V_fu_220_p2 = (sv39_V_reg_323 + n16_V_fu_204_p2);

assign n28_V_fu_238_p2 = (n8_V_fu_181_p2 + add_ln209_11_fu_232_p2);

assign n29_V_fu_251_p2 = (factor1_fu_244_p3 + n19_V_fu_214_p2);

assign n2_V_fu_137_p2 = (sv33_V_fu_111_p4 + sv39_V_fu_121_p4);

assign n3_V_fu_143_p2 = (sv13_V_fu_91_p4 + n1_V_fu_131_p2);

assign n5_V_fu_155_p2 = (n2_V_fu_137_p2 + add_ln209_fu_149_p2);

assign n8_V_fu_181_p2 = (n3_V_reg_341 + n5_V_reg_347);

assign n9_V_fu_185_p2 = (n2_V_reg_335 + n5_V_reg_347);

assign out_ports_V = {{{{{{{{sv39_o_V_fu_291_p2}, {n29_V_fu_251_p2}}, {sv33_o_V_fu_285_p2}}, {sv26_o_V_fu_279_p2}}, {n28_V_fu_238_p2}}, {sv13_o_V_fu_268_p2}}, {sv2_o_V_fu_262_p2}}, {n20_V_fu_220_p2}};

assign sv13_V_fu_91_p4 = {{in_ports_V[11:8]}};

assign sv13_o_V_fu_268_p2 = (n17_V_fu_209_p2 + n28_V_fu_238_p2);

assign sv26_V_fu_101_p4 = {{in_ports_V[19:16]}};

assign sv26_o_V_fu_279_p2 = (n8_V_fu_181_p2 + add_ln209_17_fu_274_p2);

assign sv2_V_fu_81_p4 = {{in_ports_V[7:4]}};

assign sv2_o_V_fu_262_p2 = (n15_V_fu_194_p2 + add_ln209_14_fu_257_p2);

assign sv33_V_fu_111_p4 = {{in_ports_V[23:20]}};

assign sv33_o_V_fu_285_p2 = (n19_V_fu_214_p2 + n29_V_fu_251_p2);

assign sv39_V_fu_121_p4 = {{in_ports_V[31:28]}};

assign sv39_o_V_fu_291_p2 = (n16_V_fu_204_p2 + n20_V_fu_220_p2);

endmodule //ellipf
