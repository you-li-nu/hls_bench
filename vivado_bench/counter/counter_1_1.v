// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="counter,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=3.300000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=17,HLS_SYN_LUT=155,HLS_VERSION=2020_1}" *)

module counter (
        ap_clk,
        ap_rst,
        seed_V,
        out_V,
        out_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 3'd1;
parameter    ap_ST_fsm_state2 = 3'd2;
parameter    ap_ST_fsm_state3 = 3'd4;

input   ap_clk;
input   ap_rst;
input  [5:0] seed_V;
output  [3:0] out_V;
output   out_V_ap_vld;

reg out_V_ap_vld;

(* fsm_encoding = "none" *) reg   [2:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [5:0] add_ln320_fu_120_p2;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln883_fu_114_p2;
wire   [3:0] limit_V_2_fu_176_p3;
wire   [3:0] select_ln879_1_fu_204_p3;
reg   [5:0] limit_V_in_reg_71;
reg   [3:0] limit_V_1_reg_80;
reg   [3:0] p_053_0_reg_91;
wire    ap_CS_fsm_state3;
wire   [1:0] ctrl_V_fu_104_p4;
wire   [0:0] icmp_ln883_1_fu_142_p2;
wire   [3:0] count_V_fu_148_p2;
wire   [3:0] count_V_1_fu_162_p2;
wire   [0:0] icmp_ln879_fu_130_p2;
wire   [3:0] data_V_fu_126_p1;
wire   [0:0] icmp_ln879_1_fu_136_p2;
wire   [0:0] xor_ln879_fu_184_p2;
wire   [0:0] and_ln879_fu_190_p2;
wire   [3:0] select_ln32_fu_154_p3;
wire   [3:0] select_ln36_fu_168_p3;
wire   [3:0] select_ln879_fu_196_p3;
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
    if (((icmp_ln883_fu_114_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        limit_V_1_reg_80 <= limit_V_2_fu_176_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        limit_V_1_reg_80 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_114_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        limit_V_in_reg_71 <= add_ln320_fu_120_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        limit_V_in_reg_71 <= seed_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_114_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        p_053_0_reg_91 <= select_ln879_1_fu_204_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_053_0_reg_91 <= 4'd0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        out_V_ap_vld = 1'b1;
    end else begin
        out_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        ap_ST_fsm_state2 : begin
            if (((icmp_ln883_fu_114_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_state1;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign add_ln320_fu_120_p2 = (6'd1 + limit_V_in_reg_71);

assign and_ln879_fu_190_p2 = (xor_ln879_fu_184_p2 & icmp_ln879_1_fu_136_p2);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign count_V_1_fu_162_p2 = ($signed(4'd15) + $signed(p_053_0_reg_91));

assign count_V_fu_148_p2 = (4'd1 + p_053_0_reg_91);

assign ctrl_V_fu_104_p4 = {{limit_V_in_reg_71[5:4]}};

assign data_V_fu_126_p1 = limit_V_in_reg_71[3:0];

assign icmp_ln879_1_fu_136_p2 = ((ctrl_V_fu_104_p4 == 2'd2) ? 1'b1 : 1'b0);

assign icmp_ln879_fu_130_p2 = ((ctrl_V_fu_104_p4 == 2'd1) ? 1'b1 : 1'b0);

assign icmp_ln883_1_fu_142_p2 = ((p_053_0_reg_91 == limit_V_1_reg_80) ? 1'b1 : 1'b0);

assign icmp_ln883_fu_114_p2 = ((ctrl_V_fu_104_p4 == 2'd0) ? 1'b1 : 1'b0);

assign limit_V_2_fu_176_p3 = ((icmp_ln879_fu_130_p2[0:0] === 1'b1) ? data_V_fu_126_p1 : limit_V_1_reg_80);

assign out_V = p_053_0_reg_91;

assign select_ln32_fu_154_p3 = ((icmp_ln883_1_fu_142_p2[0:0] === 1'b1) ? p_053_0_reg_91 : count_V_fu_148_p2);

assign select_ln36_fu_168_p3 = ((icmp_ln883_1_fu_142_p2[0:0] === 1'b1) ? p_053_0_reg_91 : count_V_1_fu_162_p2);

assign select_ln879_1_fu_204_p3 = ((icmp_ln879_fu_130_p2[0:0] === 1'b1) ? p_053_0_reg_91 : select_ln879_fu_196_p3);

assign select_ln879_fu_196_p3 = ((and_ln879_fu_190_p2[0:0] === 1'b1) ? select_ln32_fu_154_p3 : select_ln36_fu_168_p3);

assign xor_ln879_fu_184_p2 = (icmp_ln879_fu_130_p2 ^ 1'd1);

endmodule //counter
