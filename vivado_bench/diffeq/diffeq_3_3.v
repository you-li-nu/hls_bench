// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="diffeq,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=6.325000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=51,HLS_SYN_LUT=302,HLS_VERSION=2020_1}" *)

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

parameter    ap_ST_fsm_state1 = 5'd1;
parameter    ap_ST_fsm_state2 = 5'd2;
parameter    ap_ST_fsm_state3 = 5'd4;
parameter    ap_ST_fsm_state4 = 5'd8;
parameter    ap_ST_fsm_state5 = 5'd16;

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

(* fsm_encoding = "none" *) reg   [4:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire  signed [3:0] sub_ln209_fu_168_p2;
reg  signed [3:0] sub_ln209_reg_293;
wire   [0:0] icmp_ln887_fu_174_p2;
reg   [0:0] icmp_ln887_reg_301;
wire    ap_CS_fsm_state2;
wire  signed [3:0] sub_ln214_1_fu_201_p2;
reg  signed [3:0] sub_ln214_1_reg_305;
wire  signed [3:0] add_ln209_1_fu_207_p2;
reg  signed [3:0] add_ln209_1_reg_313;
wire   [0:0] icmp_ln887_1_fu_212_p2;
reg   [0:0] icmp_ln887_1_reg_320;
wire  signed [3:0] add_ln209_fu_221_p2;
reg  signed [3:0] add_ln209_reg_324;
wire    ap_CS_fsm_state3;
wire   [3:0] mul_ln209_3_fu_231_p2;
reg   [3:0] mul_ln209_3_reg_331;
wire  signed [3:0] sub_ln214_3_fu_244_p2;
wire    ap_CS_fsm_state4;
wire   [3:0] add_ln209_2_fu_255_p2;
wire   [3:0] add_ln209_3_fu_260_p2;
reg  signed [3:0] x_var_V_buf_0_0_reg_99;
reg  signed [3:0] y_var_V_buf_0_0_reg_109;
reg  signed [3:0] u_var_V_buf_0_0_reg_119;
reg   [3:0] u_var_V_buf_0_lcssa_reg_129;
reg   [3:0] y_var_V_buf_0_lcssa_reg_140;
reg   [3:0] x_var_V_buf_0_lcssa_reg_151;
wire    ap_CS_fsm_state5;
wire  signed [3:0] shl_ln209_fu_162_p0;
wire   [3:0] shl_ln209_fu_162_p2;
wire  signed [3:0] sub_ln209_fu_168_p1;
wire  signed [3:0] mul_ln209_6_fu_179_p2;
wire   [3:0] mul_ln209_fu_184_p2;
wire   [3:0] sub_ln214_fu_195_p2;
wire   [3:0] mul_ln209_1_fu_190_p2;
wire  signed [3:0] add_ln209_1_fu_207_p1;
wire  signed [3:0] mul_ln209_2_fu_217_p1;
wire   [3:0] mul_ln209_2_fu_217_p2;
wire  signed [3:0] mul_ln209_7_fu_227_p2;
wire   [3:0] sub_ln214_2_fu_240_p2;
wire   [3:0] mul_ln209_4_fu_236_p2;
wire  signed [3:0] mul_ln209_5_fu_250_p1;
wire   [3:0] mul_ln209_5_fu_250_p2;
wire  signed [3:0] add_ln209_3_fu_260_p1;
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
    if (((icmp_ln887_1_reg_320 == 1'd1) & (icmp_ln887_reg_301 == 1'd1) & (1'b1 == ap_CS_fsm_state4))) begin
        u_var_V_buf_0_0_reg_119 <= sub_ln214_3_fu_244_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        u_var_V_buf_0_0_reg_119 <= u_var_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_reg_320 == 1'd0) & (icmp_ln887_reg_301 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        u_var_V_buf_0_lcssa_reg_129 <= sub_ln214_1_reg_305;
    end else if (((icmp_ln887_fu_174_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        u_var_V_buf_0_lcssa_reg_129 <= u_var_V_buf_0_0_reg_119;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_reg_320 == 1'd1) & (icmp_ln887_reg_301 == 1'd1) & (1'b1 == ap_CS_fsm_state4))) begin
        x_var_V_buf_0_0_reg_99 <= add_ln209_3_fu_260_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        x_var_V_buf_0_0_reg_99 <= x_var_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_reg_320 == 1'd0) & (icmp_ln887_reg_301 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        x_var_V_buf_0_lcssa_reg_151 <= add_ln209_1_reg_313;
    end else if (((icmp_ln887_fu_174_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        x_var_V_buf_0_lcssa_reg_151 <= x_var_V_buf_0_0_reg_99;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_reg_320 == 1'd1) & (icmp_ln887_reg_301 == 1'd1) & (1'b1 == ap_CS_fsm_state4))) begin
        y_var_V_buf_0_0_reg_109 <= add_ln209_2_fu_255_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        y_var_V_buf_0_0_reg_109 <= y_var_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_reg_320 == 1'd0) & (icmp_ln887_reg_301 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        y_var_V_buf_0_lcssa_reg_140 <= add_ln209_fu_221_p2;
    end else if (((icmp_ln887_fu_174_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        y_var_V_buf_0_lcssa_reg_140 <= y_var_V_buf_0_0_reg_109;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_fu_174_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        add_ln209_1_reg_313 <= add_ln209_1_fu_207_p2;
        icmp_ln887_1_reg_320 <= icmp_ln887_1_fu_212_p2;
        sub_ln214_1_reg_305 <= sub_ln214_1_fu_201_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_reg_301 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        add_ln209_reg_324 <= add_ln209_fu_221_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        icmp_ln887_reg_301 <= icmp_ln887_fu_174_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_reg_320 == 1'd1) & (icmp_ln887_reg_301 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        mul_ln209_3_reg_331 <= mul_ln209_3_fu_231_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state1)) begin
        sub_ln209_reg_293 <= sub_ln209_fu_168_p2;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        Uoutport_V_ap_vld = 1'b1;
    end else begin
        Uoutport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        Xoutport_V_ap_vld = 1'b1;
    end else begin
        Xoutport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
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
            ap_NS_fsm = ap_ST_fsm_state3;
        end
        ap_ST_fsm_state3 : begin
            if (((icmp_ln887_1_reg_320 == 1'd1) & (icmp_ln887_reg_301 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end
        end
        ap_ST_fsm_state4 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        ap_ST_fsm_state5 : begin
            ap_NS_fsm = ap_ST_fsm_state1;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign Uoutport_V = u_var_V_buf_0_lcssa_reg_129;

assign Xoutport_V = x_var_V_buf_0_lcssa_reg_151;

assign Youtport_V = y_var_V_buf_0_lcssa_reg_140;

assign add_ln209_1_fu_207_p1 = dx_var_V;

assign add_ln209_1_fu_207_p2 = ($signed(x_var_V_buf_0_0_reg_99) + $signed(add_ln209_1_fu_207_p1));

assign add_ln209_2_fu_255_p2 = ($signed(add_ln209_reg_324) + $signed(mul_ln209_5_fu_250_p2));

assign add_ln209_3_fu_260_p1 = dx_var_V;

assign add_ln209_3_fu_260_p2 = ($signed(add_ln209_1_reg_313) + $signed(add_ln209_3_fu_260_p1));

assign add_ln209_fu_221_p2 = ($signed(y_var_V_buf_0_0_reg_109) + $signed(mul_ln209_2_fu_217_p2));

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

assign icmp_ln887_1_fu_212_p2 = ((add_ln209_1_fu_207_p2 < a_var_V) ? 1'b1 : 1'b0);

assign icmp_ln887_fu_174_p2 = ((x_var_V_buf_0_0_reg_99 < a_var_V) ? 1'b1 : 1'b0);

assign mul_ln209_1_fu_190_p2 = ($signed(y_var_V_buf_0_0_reg_109) * $signed(sub_ln209_reg_293));

assign mul_ln209_2_fu_217_p1 = dx_var_V;

assign mul_ln209_2_fu_217_p2 = ($signed(sub_ln214_1_reg_305) * $signed(mul_ln209_2_fu_217_p1));

assign mul_ln209_3_fu_231_p2 = ($signed(mul_ln209_7_fu_227_p2) * $signed(add_ln209_1_reg_313));

assign mul_ln209_4_fu_236_p2 = ($signed(add_ln209_reg_324) * $signed(sub_ln209_reg_293));

assign mul_ln209_5_fu_250_p1 = dx_var_V;

assign mul_ln209_5_fu_250_p2 = ($signed(sub_ln214_3_fu_244_p2) * $signed(mul_ln209_5_fu_250_p1));

assign mul_ln209_6_fu_179_p2 = ($signed(sub_ln209_reg_293) * $signed(u_var_V_buf_0_0_reg_119));

assign mul_ln209_7_fu_227_p2 = ($signed(sub_ln209_reg_293) * $signed(sub_ln214_1_reg_305));

assign mul_ln209_fu_184_p2 = ($signed(mul_ln209_6_fu_179_p2) * $signed(x_var_V_buf_0_0_reg_99));

assign shl_ln209_fu_162_p0 = dx_var_V;

assign shl_ln209_fu_162_p2 = shl_ln209_fu_162_p0 << 4'd2;

assign sub_ln209_fu_168_p1 = dx_var_V;

assign sub_ln209_fu_168_p2 = ($signed(shl_ln209_fu_162_p2) - $signed(sub_ln209_fu_168_p1));

assign sub_ln214_1_fu_201_p2 = (sub_ln214_fu_195_p2 - mul_ln209_1_fu_190_p2);

assign sub_ln214_2_fu_240_p2 = ($signed(sub_ln214_1_reg_305) - $signed(mul_ln209_3_reg_331));

assign sub_ln214_3_fu_244_p2 = (sub_ln214_2_fu_240_p2 - mul_ln209_4_fu_236_p2);

assign sub_ln214_fu_195_p2 = ($signed(u_var_V_buf_0_0_reg_119) - $signed(mul_ln209_fu_184_p2));

endmodule //diffeq