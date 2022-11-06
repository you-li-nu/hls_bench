// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="diffeq,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=7.765000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=40,HLS_SYN_LUT=325,HLS_VERSION=2020_1}" *)

module diffeq (
        ap_clk,
        ap_rst,
        x_var_V,
        y_var_V,
        u_var_V,
        a_var_V,
        dx_var_V,
        Xoutport_V,
        Xoutport_V_ap_vld,
        Youtport_V,
        Youtport_V_ap_vld,
        Uoutport_V,
        Uoutport_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 3'd1;
parameter    ap_ST_fsm_state2 = 3'd2;
parameter    ap_ST_fsm_state3 = 3'd4;

input   ap_clk;
input   ap_rst;
input  [3:0] x_var_V;
input  [3:0] y_var_V;
input  [3:0] u_var_V;
input  [3:0] a_var_V;
input  [3:0] dx_var_V;
output  [3:0] Xoutport_V;
output   Xoutport_V_ap_vld;
output  [3:0] Youtport_V;
output   Youtport_V_ap_vld;
output  [3:0] Uoutport_V;
output   Uoutport_V_ap_vld;

reg Xoutport_V_ap_vld;
reg Youtport_V_ap_vld;
reg Uoutport_V_ap_vld;

wire   [3:0] grp_fu_159_p2;
reg   [3:0] mul_ln209_2_reg_221;
(* fsm_encoding = "none" *) reg   [2:0] ap_CS_fsm;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln887_fu_263_p2;
wire    ap_CS_fsm_state1;
wire  signed [3:0] sub_ln209_fu_257_p2;
reg  signed [3:0] sub_ln209_reg_352;
reg   [0:0] icmp_ln887_reg_358;
wire  signed [3:0] sub_ln214_1_fu_274_p2;
reg  signed [3:0] sub_ln214_1_reg_362;
wire  signed [3:0] sub_ln214_3_fu_306_p2;
wire    ap_CS_fsm_state3;
wire   [0:0] icmp_ln887_1_fu_296_p2;
wire   [3:0] add_ln209_2_fu_313_p2;
wire   [3:0] add_ln209_3_fu_319_p2;
reg  signed [3:0] x_var_V_buf_0_0_reg_93;
reg  signed [3:0] y_var_V_buf_0_0_reg_103;
reg  signed [3:0] u_var_V_buf_0_0_reg_113;
reg   [3:0] ap_phi_mux_u_var_V_buf_0_lcssa_phi_fu_126_p4;
reg   [3:0] u_var_V_buf_0_lcssa_reg_123;
reg   [3:0] ap_phi_mux_y_var_V_buf_0_lcssa_phi_fu_137_p4;
reg   [3:0] y_var_V_buf_0_lcssa_reg_134;
wire  signed [3:0] add_ln209_fu_281_p2;
reg   [3:0] ap_phi_mux_x_var_V_buf_0_lcssa_phi_fu_148_p4;
reg   [3:0] x_var_V_buf_0_lcssa_reg_145;
wire  signed [3:0] add_ln209_1_fu_289_p2;
reg  signed [3:0] grp_fu_156_p1;
wire  signed [3:0] grp_fu_156_p2;
reg  signed [3:0] grp_fu_157_p1;
reg  signed [3:0] grp_fu_158_p0;
reg  signed [3:0] grp_fu_159_p0;
wire  signed [3:0] grp_fu_159_p1;
wire  signed [3:0] shl_ln209_fu_251_p0;
wire   [3:0] shl_ln209_fu_251_p2;
wire  signed [3:0] sub_ln209_fu_257_p1;
wire   [3:0] grp_fu_157_p2;
wire   [3:0] sub_ln214_fu_268_p2;
wire   [3:0] grp_fu_158_p2;
wire  signed [3:0] add_ln209_1_fu_289_p1;
wire   [3:0] sub_ln214_2_fu_301_p2;
wire  signed [3:0] add_ln209_3_fu_319_p1;
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
    if (((icmp_ln887_1_fu_296_p2 == 1'd1) & (icmp_ln887_reg_358 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        u_var_V_buf_0_0_reg_113 <= sub_ln214_3_fu_306_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        u_var_V_buf_0_0_reg_113 <= u_var_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_fu_296_p2 == 1'd0) & (icmp_ln887_reg_358 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        u_var_V_buf_0_lcssa_reg_123 <= sub_ln214_1_reg_362;
    end else if (((icmp_ln887_fu_263_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        u_var_V_buf_0_lcssa_reg_123 <= u_var_V_buf_0_0_reg_113;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_fu_296_p2 == 1'd1) & (icmp_ln887_reg_358 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        x_var_V_buf_0_0_reg_93 <= add_ln209_3_fu_319_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        x_var_V_buf_0_0_reg_93 <= x_var_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_fu_296_p2 == 1'd0) & (icmp_ln887_reg_358 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        x_var_V_buf_0_lcssa_reg_145 <= add_ln209_1_fu_289_p2;
    end else if (((icmp_ln887_fu_263_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        x_var_V_buf_0_lcssa_reg_145 <= x_var_V_buf_0_0_reg_93;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_fu_296_p2 == 1'd1) & (icmp_ln887_reg_358 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        y_var_V_buf_0_0_reg_103 <= add_ln209_2_fu_313_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        y_var_V_buf_0_0_reg_103 <= y_var_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_fu_296_p2 == 1'd0) & (icmp_ln887_reg_358 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        y_var_V_buf_0_lcssa_reg_134 <= add_ln209_fu_281_p2;
    end else if (((icmp_ln887_fu_263_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        y_var_V_buf_0_lcssa_reg_134 <= y_var_V_buf_0_0_reg_103;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        icmp_ln887_reg_358 <= icmp_ln887_fu_263_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_fu_263_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        mul_ln209_2_reg_221 <= grp_fu_159_p2;
        sub_ln214_1_reg_362 <= sub_ln214_1_fu_274_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state1)) begin
        sub_ln209_reg_352 <= sub_ln209_fu_257_p2;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state3) & ((icmp_ln887_1_fu_296_p2 == 1'd0) | (icmp_ln887_reg_358 == 1'd0)))) begin
        Uoutport_V_ap_vld = 1'b1;
    end else begin
        Uoutport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state3) & ((icmp_ln887_1_fu_296_p2 == 1'd0) | (icmp_ln887_reg_358 == 1'd0)))) begin
        Xoutport_V_ap_vld = 1'b1;
    end else begin
        Xoutport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state3) & ((icmp_ln887_1_fu_296_p2 == 1'd0) | (icmp_ln887_reg_358 == 1'd0)))) begin
        Youtport_V_ap_vld = 1'b1;
    end else begin
        Youtport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((icmp_ln887_1_fu_296_p2 == 1'd0) & (icmp_ln887_reg_358 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        ap_phi_mux_u_var_V_buf_0_lcssa_phi_fu_126_p4 = sub_ln214_1_reg_362;
    end else begin
        ap_phi_mux_u_var_V_buf_0_lcssa_phi_fu_126_p4 = u_var_V_buf_0_lcssa_reg_123;
    end
end

always @ (*) begin
    if (((icmp_ln887_1_fu_296_p2 == 1'd0) & (icmp_ln887_reg_358 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        ap_phi_mux_x_var_V_buf_0_lcssa_phi_fu_148_p4 = add_ln209_1_fu_289_p2;
    end else begin
        ap_phi_mux_x_var_V_buf_0_lcssa_phi_fu_148_p4 = x_var_V_buf_0_lcssa_reg_145;
    end
end

always @ (*) begin
    if (((icmp_ln887_1_fu_296_p2 == 1'd0) & (icmp_ln887_reg_358 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        ap_phi_mux_y_var_V_buf_0_lcssa_phi_fu_137_p4 = add_ln209_fu_281_p2;
    end else begin
        ap_phi_mux_y_var_V_buf_0_lcssa_phi_fu_137_p4 = y_var_V_buf_0_lcssa_reg_134;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        grp_fu_156_p1 = sub_ln214_1_reg_362;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        grp_fu_156_p1 = u_var_V_buf_0_0_reg_113;
    end else begin
        grp_fu_156_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        grp_fu_157_p1 = add_ln209_1_fu_289_p2;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        grp_fu_157_p1 = x_var_V_buf_0_0_reg_93;
    end else begin
        grp_fu_157_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        grp_fu_158_p0 = add_ln209_fu_281_p2;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        grp_fu_158_p0 = y_var_V_buf_0_0_reg_103;
    end else begin
        grp_fu_158_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        grp_fu_159_p0 = sub_ln214_3_fu_306_p2;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        grp_fu_159_p0 = sub_ln214_1_fu_274_p2;
    end else begin
        grp_fu_159_p0 = 'bx;
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
            if (((1'b1 == ap_CS_fsm_state3) & ((icmp_ln887_1_fu_296_p2 == 1'd0) | (icmp_ln887_reg_358 == 1'd0)))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign Uoutport_V = ap_phi_mux_u_var_V_buf_0_lcssa_phi_fu_126_p4;

assign Xoutport_V = ap_phi_mux_x_var_V_buf_0_lcssa_phi_fu_148_p4;

assign Youtport_V = ap_phi_mux_y_var_V_buf_0_lcssa_phi_fu_137_p4;

assign add_ln209_1_fu_289_p1 = dx_var_V;

assign add_ln209_1_fu_289_p2 = ($signed(x_var_V_buf_0_0_reg_93) + $signed(add_ln209_1_fu_289_p1));

assign add_ln209_2_fu_313_p2 = ($signed(add_ln209_fu_281_p2) + $signed(grp_fu_159_p2));

assign add_ln209_3_fu_319_p1 = dx_var_V;

assign add_ln209_3_fu_319_p2 = ($signed(add_ln209_1_fu_289_p2) + $signed(add_ln209_3_fu_319_p1));

assign add_ln209_fu_281_p2 = ($signed(y_var_V_buf_0_0_reg_103) + $signed(mul_ln209_2_reg_221));

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign grp_fu_156_p2 = ($signed(sub_ln209_reg_352) * $signed(grp_fu_156_p1));

assign grp_fu_157_p2 = ($signed(grp_fu_156_p2) * $signed(grp_fu_157_p1));

assign grp_fu_158_p2 = ($signed(grp_fu_158_p0) * $signed(sub_ln209_reg_352));

assign grp_fu_159_p1 = dx_var_V;

assign grp_fu_159_p2 = ($signed(grp_fu_159_p0) * $signed(grp_fu_159_p1));

assign icmp_ln887_1_fu_296_p2 = ((add_ln209_1_fu_289_p2 < a_var_V) ? 1'b1 : 1'b0);

assign icmp_ln887_fu_263_p2 = ((x_var_V_buf_0_0_reg_93 < a_var_V) ? 1'b1 : 1'b0);

assign shl_ln209_fu_251_p0 = dx_var_V;

assign shl_ln209_fu_251_p2 = shl_ln209_fu_251_p0 << 4'd2;

assign sub_ln209_fu_257_p1 = dx_var_V;

assign sub_ln209_fu_257_p2 = ($signed(shl_ln209_fu_251_p2) - $signed(sub_ln209_fu_257_p1));

assign sub_ln214_1_fu_274_p2 = (sub_ln214_fu_268_p2 - grp_fu_158_p2);

assign sub_ln214_2_fu_301_p2 = ($signed(sub_ln214_1_reg_362) - $signed(grp_fu_157_p2));

assign sub_ln214_3_fu_306_p2 = (sub_ln214_2_fu_301_p2 - grp_fu_158_p2);

assign sub_ln214_fu_268_p2 = ($signed(u_var_V_buf_0_0_reg_113) - $signed(grp_fu_157_p2));

endmodule //diffeq
