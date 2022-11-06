// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="diffeq,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=15.530000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=66,HLS_SYN_LUT=344,HLS_VERSION=2020_1}" *)

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
parameter    ap_ST_fsm_pp0_stage0 = 3'd2;
parameter    ap_ST_fsm_state5 = 3'd4;

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

reg  signed [3:0] x_var_V_buf_0_0_reg_97;
reg  signed [3:0] x_var_V_buf_0_0_reg_97_pp0_iter1_reg;
(* fsm_encoding = "none" *) reg   [2:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
wire    ap_block_state2_pp0_stage0_iter0;
wire    ap_block_state3_pp0_stage0_iter1;
wire    ap_block_state4_pp0_stage0_iter2;
wire    ap_block_pp0_stage0_11001;
reg  signed [3:0] u_var_V_buf_0_0_reg_107;
reg  signed [3:0] u_var_V_buf_0_0_reg_107_pp0_iter1_reg;
reg  signed [3:0] y_var_V_buf_0_0_reg_117;
wire    ap_CS_fsm_state1;
wire  signed [3:0] sub_ln209_fu_166_p2;
reg  signed [3:0] sub_ln209_reg_295;
wire   [0:0] icmp_ln887_fu_172_p2;
reg   [0:0] icmp_ln887_reg_303;
reg   [0:0] icmp_ln887_reg_303_pp0_iter1_reg;
wire   [3:0] mul_ln209_fu_182_p2;
reg   [3:0] mul_ln209_reg_307;
wire  signed [3:0] add_ln209_1_fu_188_p2;
reg  signed [3:0] add_ln209_1_reg_312;
reg    ap_enable_reg_pp0_iter0;
wire   [0:0] icmp_ln887_1_fu_193_p2;
reg   [0:0] icmp_ln887_1_reg_318;
reg   [0:0] icmp_ln887_1_reg_318_pp0_iter1_reg;
wire   [3:0] add_ln209_3_fu_198_p2;
reg   [3:0] add_ln209_3_reg_322;
wire  signed [3:0] sub_ln214_1_fu_213_p2;
reg    ap_enable_reg_pp0_iter1;
wire  signed [3:0] add_ln209_fu_224_p2;
reg  signed [3:0] add_ln209_reg_332;
wire  signed [3:0] sub_ln214_3_fu_251_p2;
reg  signed [3:0] sub_ln214_3_reg_338;
wire   [3:0] add_ln209_2_fu_261_p2;
reg    ap_enable_reg_pp0_iter2;
wire    ap_block_pp0_stage0_subdone;
reg    ap_predicate_tran4to5_state2;
reg  signed [3:0] ap_phi_mux_x_var_V_buf_0_0_phi_fu_100_p4;
wire    ap_block_pp0_stage0;
reg  signed [3:0] ap_phi_mux_u_var_V_buf_0_0_phi_fu_110_p4;
reg  signed [3:0] ap_phi_mux_y_var_V_buf_0_0_phi_fu_120_p4;
reg   [3:0] u_var_V_buf_0_lcssa_reg_127;
reg   [3:0] y_var_V_buf_0_lcssa_reg_138;
reg   [3:0] x_var_V_buf_0_lcssa_reg_149;
wire    ap_CS_fsm_state5;
wire  signed [3:0] shl_ln209_fu_160_p0;
wire   [3:0] shl_ln209_fu_160_p2;
wire  signed [3:0] sub_ln209_fu_166_p1;
wire  signed [3:0] mul_ln209_6_fu_177_p2;
wire  signed [3:0] add_ln209_1_fu_188_p1;
wire  signed [3:0] add_ln209_3_fu_198_p1;
wire   [3:0] sub_ln214_fu_208_p2;
wire   [3:0] mul_ln209_1_fu_203_p2;
wire  signed [3:0] mul_ln209_2_fu_219_p1;
wire   [3:0] mul_ln209_2_fu_219_p2;
wire  signed [3:0] mul_ln209_7_fu_230_p2;
wire   [3:0] mul_ln209_3_fu_235_p2;
wire   [3:0] sub_ln214_2_fu_245_p2;
wire   [3:0] mul_ln209_4_fu_240_p2;
wire  signed [3:0] mul_ln209_5_fu_257_p1;
wire   [3:0] mul_ln209_5_fu_257_p2;
reg   [2:0] ap_NS_fsm;
reg    ap_idle_pp0;
wire    ap_enable_pp0;
reg    ap_condition_240;

// power-on initialization
initial begin
#0 ap_CS_fsm = 3'd1;
#0 ap_enable_reg_pp0_iter0 = 1'b0;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_enable_reg_pp0_iter2 = 1'b0;
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter0 <= 1'b0;
    end else begin
        if (((ap_predicate_tran4to5_state2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (1'b0 == ap_block_pp0_stage0_subdone))) begin
            ap_enable_reg_pp0_iter0 <= 1'b0;
        end else if ((1'b1 == ap_CS_fsm_state1)) begin
            ap_enable_reg_pp0_iter0 <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if ((1'b0 == ap_block_pp0_stage0_subdone)) begin
            ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter2 <= 1'b0;
    end else begin
        if ((1'b0 == ap_block_pp0_stage0_subdone)) begin
            ap_enable_reg_pp0_iter2 <= ap_enable_reg_pp0_iter1;
        end else if ((1'b1 == ap_CS_fsm_state1)) begin
            ap_enable_reg_pp0_iter2 <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_reg_318 == 1'd1) & (icmp_ln887_reg_303 == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        u_var_V_buf_0_0_reg_107 <= sub_ln214_3_fu_251_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        u_var_V_buf_0_0_reg_107 <= u_var_V;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        if ((1'b1 == ap_condition_240)) begin
            u_var_V_buf_0_lcssa_reg_127 <= sub_ln214_1_fu_213_p2;
        end else if (((icmp_ln887_reg_303_pp0_iter1_reg == 1'd0) & (ap_enable_reg_pp0_iter2 == 1'b1))) begin
            u_var_V_buf_0_lcssa_reg_127 <= u_var_V_buf_0_0_reg_107_pp0_iter1_reg;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_reg_318 == 1'd1) & (icmp_ln887_reg_303 == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        x_var_V_buf_0_0_reg_97 <= add_ln209_3_reg_322;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        x_var_V_buf_0_0_reg_97 <= x_var_V;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        if ((1'b1 == ap_condition_240)) begin
            x_var_V_buf_0_lcssa_reg_149 <= add_ln209_1_reg_312;
        end else if (((icmp_ln887_reg_303_pp0_iter1_reg == 1'd0) & (ap_enable_reg_pp0_iter2 == 1'b1))) begin
            x_var_V_buf_0_lcssa_reg_149 <= x_var_V_buf_0_0_reg_97_pp0_iter1_reg;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_reg_318_pp0_iter1_reg == 1'd1) & (icmp_ln887_reg_303_pp0_iter1_reg == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter2 == 1'b1))) begin
        y_var_V_buf_0_0_reg_117 <= add_ln209_2_fu_261_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        y_var_V_buf_0_0_reg_117 <= y_var_V;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        if ((1'b1 == ap_condition_240)) begin
            y_var_V_buf_0_lcssa_reg_138 <= add_ln209_fu_224_p2;
        end else if (((icmp_ln887_reg_303_pp0_iter1_reg == 1'd0) & (ap_enable_reg_pp0_iter2 == 1'b1))) begin
            y_var_V_buf_0_lcssa_reg_138 <= y_var_V_buf_0_0_reg_117;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_fu_172_p2 == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        add_ln209_1_reg_312 <= add_ln209_1_fu_188_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_fu_193_p2 == 1'd1) & (icmp_ln887_fu_172_p2 == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        add_ln209_3_reg_322 <= add_ln209_3_fu_198_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_reg_303 == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        add_ln209_reg_332 <= add_ln209_fu_224_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_fu_172_p2 == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        icmp_ln887_1_reg_318 <= icmp_ln887_1_fu_193_p2;
        mul_ln209_reg_307 <= mul_ln209_fu_182_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        icmp_ln887_1_reg_318_pp0_iter1_reg <= icmp_ln887_1_reg_318;
        icmp_ln887_reg_303 <= icmp_ln887_fu_172_p2;
        icmp_ln887_reg_303_pp0_iter1_reg <= icmp_ln887_reg_303;
        u_var_V_buf_0_0_reg_107_pp0_iter1_reg <= u_var_V_buf_0_0_reg_107;
        x_var_V_buf_0_0_reg_97_pp0_iter1_reg <= x_var_V_buf_0_0_reg_97;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state1)) begin
        sub_ln209_reg_295 <= sub_ln209_fu_166_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_reg_318 == 1'd1) & (icmp_ln887_reg_303 == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        sub_ln214_3_reg_338 <= sub_ln214_3_fu_251_p2;
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
    if (((ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if (((icmp_ln887_1_reg_318 == 1'd1) & (icmp_ln887_reg_303 == 1'd1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (1'b0 == ap_block_pp0_stage0))) begin
        ap_phi_mux_u_var_V_buf_0_0_phi_fu_110_p4 = sub_ln214_3_fu_251_p2;
    end else begin
        ap_phi_mux_u_var_V_buf_0_0_phi_fu_110_p4 = u_var_V_buf_0_0_reg_107;
    end
end

always @ (*) begin
    if (((icmp_ln887_1_reg_318 == 1'd1) & (icmp_ln887_reg_303 == 1'd1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (1'b0 == ap_block_pp0_stage0))) begin
        ap_phi_mux_x_var_V_buf_0_0_phi_fu_100_p4 = add_ln209_3_reg_322;
    end else begin
        ap_phi_mux_x_var_V_buf_0_0_phi_fu_100_p4 = x_var_V_buf_0_0_reg_97;
    end
end

always @ (*) begin
    if (((icmp_ln887_1_reg_318_pp0_iter1_reg == 1'd1) & (icmp_ln887_reg_303_pp0_iter1_reg == 1'd1) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b0 == ap_block_pp0_stage0))) begin
        ap_phi_mux_y_var_V_buf_0_0_phi_fu_120_p4 = add_ln209_2_fu_261_p2;
    end else begin
        ap_phi_mux_y_var_V_buf_0_0_phi_fu_120_p4 = y_var_V_buf_0_0_reg_117;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_pp0_stage0;
        end
        ap_ST_fsm_pp0_stage0 : begin
            if (~((ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else if (((ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone))) begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end
        end
        ap_ST_fsm_state5 : begin
            ap_NS_fsm = ap_ST_fsm_state1;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign Uoutport_V = u_var_V_buf_0_lcssa_reg_127;

assign Xoutport_V = x_var_V_buf_0_lcssa_reg_149;

assign Youtport_V = y_var_V_buf_0_lcssa_reg_138;

assign add_ln209_1_fu_188_p1 = dx_var_V;

assign add_ln209_1_fu_188_p2 = ($signed(ap_phi_mux_x_var_V_buf_0_0_phi_fu_100_p4) + $signed(add_ln209_1_fu_188_p1));

assign add_ln209_2_fu_261_p2 = ($signed(add_ln209_reg_332) + $signed(mul_ln209_5_fu_257_p2));

assign add_ln209_3_fu_198_p1 = dx_var_V;

assign add_ln209_3_fu_198_p2 = ($signed(add_ln209_1_fu_188_p2) + $signed(add_ln209_3_fu_198_p1));

assign add_ln209_fu_224_p2 = ($signed(ap_phi_mux_y_var_V_buf_0_0_phi_fu_120_p4) + $signed(mul_ln209_2_fu_219_p2));

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd2];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_subdone = ~(1'b1 == 1'b1);

assign ap_block_state2_pp0_stage0_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state3_pp0_stage0_iter1 = ~(1'b1 == 1'b1);

assign ap_block_state4_pp0_stage0_iter2 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_condition_240 = ((icmp_ln887_1_reg_318 == 1'd0) & (icmp_ln887_reg_303 == 1'd1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0));
end

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

always @ (*) begin
    ap_predicate_tran4to5_state2 = ((icmp_ln887_1_fu_193_p2 == 1'd0) | (icmp_ln887_fu_172_p2 == 1'd0));
end

assign icmp_ln887_1_fu_193_p2 = ((add_ln209_1_fu_188_p2 < a_var_V) ? 1'b1 : 1'b0);

assign icmp_ln887_fu_172_p2 = ((ap_phi_mux_x_var_V_buf_0_0_phi_fu_100_p4 < a_var_V) ? 1'b1 : 1'b0);

assign mul_ln209_1_fu_203_p2 = ($signed(ap_phi_mux_y_var_V_buf_0_0_phi_fu_120_p4) * $signed(sub_ln209_reg_295));

assign mul_ln209_2_fu_219_p1 = dx_var_V;

assign mul_ln209_2_fu_219_p2 = ($signed(sub_ln214_1_fu_213_p2) * $signed(mul_ln209_2_fu_219_p1));

assign mul_ln209_3_fu_235_p2 = ($signed(mul_ln209_7_fu_230_p2) * $signed(add_ln209_1_reg_312));

assign mul_ln209_4_fu_240_p2 = ($signed(add_ln209_fu_224_p2) * $signed(sub_ln209_reg_295));

assign mul_ln209_5_fu_257_p1 = dx_var_V;

assign mul_ln209_5_fu_257_p2 = ($signed(sub_ln214_3_reg_338) * $signed(mul_ln209_5_fu_257_p1));

assign mul_ln209_6_fu_177_p2 = ($signed(sub_ln209_reg_295) * $signed(ap_phi_mux_u_var_V_buf_0_0_phi_fu_110_p4));

assign mul_ln209_7_fu_230_p2 = ($signed(sub_ln209_reg_295) * $signed(sub_ln214_1_fu_213_p2));

assign mul_ln209_fu_182_p2 = ($signed(mul_ln209_6_fu_177_p2) * $signed(ap_phi_mux_x_var_V_buf_0_0_phi_fu_100_p4));

assign shl_ln209_fu_160_p0 = dx_var_V;

assign shl_ln209_fu_160_p2 = shl_ln209_fu_160_p0 << 4'd2;

assign sub_ln209_fu_166_p1 = dx_var_V;

assign sub_ln209_fu_166_p2 = ($signed(shl_ln209_fu_160_p2) - $signed(sub_ln209_fu_166_p1));

assign sub_ln214_1_fu_213_p2 = (sub_ln214_fu_208_p2 - mul_ln209_1_fu_203_p2);

assign sub_ln214_2_fu_245_p2 = ($signed(sub_ln214_1_fu_213_p2) - $signed(mul_ln209_3_fu_235_p2));

assign sub_ln214_3_fu_251_p2 = (sub_ln214_2_fu_245_p2 - mul_ln209_4_fu_240_p2);

assign sub_ln214_fu_208_p2 = ($signed(u_var_V_buf_0_0_reg_107) - $signed(mul_ln209_reg_307));

endmodule //diffeq
