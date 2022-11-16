// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="diffeq_easy,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=7.525000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=29,HLS_SYN_LUT=161,HLS_VERSION=2020_1}" *)

module diffeq_easy (
        ap_clk,
        ap_rst,
        vars_V,
        Xoutport_V,
        Xoutport_V_ap_vld,
        Youtport_V,
        Youtport_V_ap_vld,
        Uoutport_V,
        Uoutport_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 5'd1;
parameter    ap_ST_fsm_state2 = 5'd2;
parameter    ap_ST_fsm_state3 = 5'd4;
parameter    ap_ST_fsm_state4 = 5'd8;
parameter    ap_ST_fsm_state5 = 5'd16;

input   ap_clk;
input   ap_rst;
input  [11:0] vars_V;
output  [3:0] Xoutport_V;
output   Xoutport_V_ap_vld;
output  [3:0] Youtport_V;
output   Youtport_V_ap_vld;
output  [3:0] Uoutport_V;
output   Uoutport_V_ap_vld;

reg Xoutport_V_ap_vld;
reg Youtport_V_ap_vld;
reg Uoutport_V_ap_vld;

wire   [3:0] x_var_V_fu_111_p1;
(* fsm_encoding = "none" *) reg   [4:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [3:0] u_var_V_2_fu_183_p2;
reg   [3:0] u_var_V_2_reg_219;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln887_fu_135_p2;
wire   [3:0] y_var_V_1_fu_189_p2;
reg   [3:0] y_var_V_1_reg_224;
wire   [3:0] add_ln214_fu_195_p2;
reg   [3:0] add_ln214_reg_229;
reg   [3:0] p_0426_0_reg_82;
wire    ap_CS_fsm_state5;
reg   [3:0] p_0423_0_reg_91;
reg  signed [3:0] t1_V_reg_101;
wire   [3:0] shl_ln214_fu_141_p2;
wire  signed [3:0] t2_V_fu_147_p2;
wire   [3:0] t4_V_fu_153_p2;
wire   [3:0] shl_ln214_1_fu_165_p2;
wire   [3:0] sub_ln214_3_fu_171_p2;
wire   [3:0] add_ln214_1_fu_177_p2;
wire   [3:0] t6_V_fu_159_p2;
reg   [4:0] ap_NS_fsm;

// power-on initialization
initial begin
#0 ap_CS_fsm = 5'd1;
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        p_0423_0_reg_91 <= y_var_V_1_reg_224;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_0423_0_reg_91 <= {{vars_V[7:4]}};
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        p_0426_0_reg_82 <= add_ln214_reg_229;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_0426_0_reg_82 <= x_var_V_fu_111_p1;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        t1_V_reg_101 <= u_var_V_2_reg_219;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        t1_V_reg_101 <= {{vars_V[11:8]}};
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_fu_135_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        add_ln214_reg_229 <= add_ln214_fu_195_p2;
        u_var_V_2_reg_219 <= u_var_V_2_fu_183_p2;
        y_var_V_1_reg_224 <= y_var_V_1_fu_189_p2;
    end
end

always @ (*) begin
    if (((icmp_ln887_fu_135_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        Uoutport_V_ap_vld = 1'b1;
    end else begin
        Uoutport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((icmp_ln887_fu_135_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        Xoutport_V_ap_vld = 1'b1;
    end else begin
        Xoutport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((icmp_ln887_fu_135_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        Youtport_V_ap_vld = 1'b1;
    end else begin
        Youtport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        ap_ST_fsm_state2 : begin
            if (((icmp_ln887_fu_135_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_state4;
        end
        ap_ST_fsm_state4 : begin
            ap_NS_fsm = ap_ST_fsm_state5;
        end
        ap_ST_fsm_state5 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign Uoutport_V = t1_V_reg_101;

assign Xoutport_V = 4'd15;

assign Youtport_V = p_0423_0_reg_91;

assign add_ln214_1_fu_177_p2 = (p_0423_0_reg_91 + sub_ln214_3_fu_171_p2);

assign add_ln214_fu_195_p2 = (p_0426_0_reg_82 + 4'd1);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

assign icmp_ln887_fu_135_p2 = ((p_0426_0_reg_82 == 4'd15) ? 1'b1 : 1'b0);

assign shl_ln214_1_fu_165_p2 = p_0423_0_reg_91 << 4'd2;

assign shl_ln214_fu_141_p2 = p_0426_0_reg_82 << 4'd2;

assign sub_ln214_3_fu_171_p2 = (4'd0 - shl_ln214_1_fu_165_p2);

assign t2_V_fu_147_p2 = (shl_ln214_fu_141_p2 - p_0426_0_reg_82);

assign t4_V_fu_153_p2 = ($signed(t1_V_reg_101) * $signed(t2_V_fu_147_p2));

assign t6_V_fu_159_p2 = ($signed(t1_V_reg_101) - $signed(t4_V_fu_153_p2));

assign u_var_V_2_fu_183_p2 = (add_ln214_1_fu_177_p2 + t6_V_fu_159_p2);

assign x_var_V_fu_111_p1 = vars_V[3:0];

assign y_var_V_1_fu_189_p2 = (p_0423_0_reg_91 + u_var_V_2_fu_183_p2);

endmodule //diffeq_easy