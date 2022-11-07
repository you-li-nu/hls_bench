// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="diffeq,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=7.765000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=19,HLS_SYN_LUT=162,HLS_VERSION=2020_1}" *)

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

(* fsm_encoding = "none" *) reg   [2:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire  signed [3:0] t1_V_fu_136_p2;
reg  signed [3:0] t1_V_reg_217;
wire  signed [3:0] sub_ln214_fu_169_p2;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln887_fu_142_p2;
wire   [3:0] add_ln209_fu_180_p2;
wire   [3:0] add_ln209_1_fu_186_p2;
reg  signed [3:0] x_var_V_buf_0_reg_97;
reg  signed [3:0] y_var_V_buf_0_reg_108;
reg  signed [3:0] u_var_V_buf_0_reg_119;
wire    ap_CS_fsm_state3;
wire  signed [3:0] shl_ln209_fu_130_p0;
wire   [3:0] shl_ln209_fu_130_p2;
wire  signed [3:0] t1_V_fu_136_p1;
wire  signed [3:0] mul_ln209_fu_147_p2;
wire   [3:0] t4_V_fu_152_p2;
wire   [3:0] t6_V_fu_163_p2;
wire   [3:0] t5_V_fu_158_p2;
wire  signed [3:0] y1_V_fu_175_p1;
wire   [3:0] y1_V_fu_175_p2;
wire  signed [3:0] add_ln209_1_fu_186_p1;
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
    if (((icmp_ln887_fu_142_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        u_var_V_buf_0_reg_119 <= sub_ln214_fu_169_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        u_var_V_buf_0_reg_119 <= u_var_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_fu_142_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        x_var_V_buf_0_reg_97 <= add_ln209_1_fu_186_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        x_var_V_buf_0_reg_97 <= x_var_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_fu_142_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        y_var_V_buf_0_reg_108 <= add_ln209_fu_180_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        y_var_V_buf_0_reg_108 <= y_var_V;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state1)) begin
        t1_V_reg_217 <= t1_V_fu_136_p2;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        Uoutport_V_ap_vld = 1'b1;
    end else begin
        Uoutport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        Xoutport_V_ap_vld = 1'b1;
    end else begin
        Xoutport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
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
            if (((icmp_ln887_fu_142_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
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

assign Uoutport_V = u_var_V_buf_0_reg_119;

assign Xoutport_V = x_var_V_buf_0_reg_97;

assign Youtport_V = y_var_V_buf_0_reg_108;

assign add_ln209_1_fu_186_p1 = dx_var_V;

assign add_ln209_1_fu_186_p2 = ($signed(x_var_V_buf_0_reg_97) + $signed(add_ln209_1_fu_186_p1));

assign add_ln209_fu_180_p2 = ($signed(y1_V_fu_175_p2) + $signed(y_var_V_buf_0_reg_108));

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign icmp_ln887_fu_142_p2 = ((x_var_V_buf_0_reg_97 < a_var_V) ? 1'b1 : 1'b0);

assign mul_ln209_fu_147_p2 = ($signed(t1_V_reg_217) * $signed(u_var_V_buf_0_reg_119));

assign shl_ln209_fu_130_p0 = dx_var_V;

assign shl_ln209_fu_130_p2 = shl_ln209_fu_130_p0 << 4'd2;

assign sub_ln214_fu_169_p2 = (t6_V_fu_163_p2 - t5_V_fu_158_p2);

assign t1_V_fu_136_p1 = dx_var_V;

assign t1_V_fu_136_p2 = ($signed(shl_ln209_fu_130_p2) - $signed(t1_V_fu_136_p1));

assign t4_V_fu_152_p2 = ($signed(mul_ln209_fu_147_p2) * $signed(x_var_V_buf_0_reg_97));

assign t5_V_fu_158_p2 = ($signed(y_var_V_buf_0_reg_108) * $signed(t1_V_reg_217));

assign t6_V_fu_163_p2 = ($signed(u_var_V_buf_0_reg_119) - $signed(t4_V_fu_152_p2));

assign y1_V_fu_175_p1 = dx_var_V;

assign y1_V_fu_175_p2 = ($signed(sub_ln214_fu_169_p2) * $signed(y1_V_fu_175_p1));

endmodule //diffeq