// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="diffeq_easy,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=7.525000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=52,HLS_SYN_LUT=393,HLS_VERSION=2020_1}" *)

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

wire   [3:0] x_var_V_fu_142_p1;
(* fsm_encoding = "none" *) reg   [4:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [0:0] icmp_ln887_fu_166_p2;
reg   [0:0] icmp_ln887_reg_364;
wire    ap_CS_fsm_state2;
wire  signed [3:0] add_ln214_fu_214_p2;
reg  signed [3:0] add_ln214_reg_368;
wire   [3:0] add_ln209_fu_220_p2;
reg   [3:0] add_ln209_reg_375;
wire   [3:0] add_ln214_3_fu_226_p2;
reg   [3:0] add_ln214_3_reg_383;
wire   [0:0] icmp_ln887_1_fu_232_p2;
reg   [0:0] icmp_ln887_1_reg_389;
wire   [3:0] add_ln214_1_fu_238_p2;
reg   [3:0] add_ln214_1_reg_393;
wire  signed [3:0] add_ln214_4_fu_280_p2;
reg  signed [3:0] add_ln214_4_reg_400;
wire    ap_CS_fsm_state3;
wire   [3:0] add_ln209_1_fu_286_p2;
reg   [3:0] add_ln209_1_reg_407;
wire   [0:0] icmp_ln887_2_fu_291_p2;
reg   [0:0] icmp_ln887_2_reg_415;
wire   [3:0] add_ln214_5_fu_332_p2;
wire    ap_CS_fsm_state4;
wire   [3:0] add_ln209_2_fu_338_p2;
wire   [3:0] add_ln214_2_fu_343_p2;
reg   [3:0] p_0426_0_0_reg_86;
reg   [3:0] p_0423_0_0_reg_96;
reg  signed [3:0] t1_V_0_reg_106;
reg   [3:0] t1_V_lcssa_reg_116;
reg   [3:0] p_0423_0_lcssa_reg_129;
wire    ap_CS_fsm_state5;
wire   [3:0] shl_ln214_fu_172_p2;
wire  signed [3:0] sub_ln214_fu_178_p2;
wire   [3:0] mul_ln209_fu_184_p2;
wire   [3:0] shl_ln214_1_fu_196_p2;
wire   [3:0] sub_ln214_9_fu_202_p2;
wire   [3:0] add_ln214_6_fu_208_p2;
wire   [3:0] sub_ln214_1_fu_190_p2;
wire   [3:0] shl_ln214_2_fu_244_p2;
wire  signed [3:0] sub_ln214_2_fu_249_p2;
wire   [3:0] mul_ln209_1_fu_254_p2;
wire   [3:0] shl_ln214_3_fu_264_p2;
wire   [3:0] sub_ln214_10_fu_269_p2;
wire   [3:0] add_ln214_7_fu_275_p2;
wire   [3:0] sub_ln214_3_fu_259_p2;
wire   [3:0] shl_ln214_4_fu_296_p2;
wire  signed [3:0] sub_ln214_4_fu_301_p2;
wire   [3:0] mul_ln209_2_fu_306_p2;
wire   [3:0] shl_ln214_5_fu_316_p2;
wire   [3:0] sub_ln214_11_fu_321_p2;
wire   [3:0] add_ln214_8_fu_327_p2;
wire   [3:0] sub_ln214_5_fu_311_p2;
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
    if (((icmp_ln887_2_reg_415 == 1'd0) & (icmp_ln887_1_reg_389 == 1'd0) & (icmp_ln887_reg_364 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        p_0423_0_0_reg_96 <= add_ln209_2_fu_338_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_0423_0_0_reg_96 <= {{vars_V[7:4]}};
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_2_fu_291_p2 == 1'd1) & (icmp_ln887_1_reg_389 == 1'd0) & (icmp_ln887_reg_364 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        p_0423_0_lcssa_reg_129 <= add_ln209_1_fu_286_p2;
    end else if (((icmp_ln887_1_fu_232_p2 == 1'd1) & (icmp_ln887_fu_166_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        p_0423_0_lcssa_reg_129 <= add_ln209_fu_220_p2;
    end else if (((icmp_ln887_fu_166_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        p_0423_0_lcssa_reg_129 <= p_0423_0_0_reg_96;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_2_reg_415 == 1'd0) & (icmp_ln887_1_reg_389 == 1'd0) & (icmp_ln887_reg_364 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        p_0426_0_0_reg_86 <= add_ln214_2_fu_343_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_0426_0_0_reg_86 <= x_var_V_fu_142_p1;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_2_reg_415 == 1'd0) & (icmp_ln887_1_reg_389 == 1'd0) & (icmp_ln887_reg_364 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        t1_V_0_reg_106 <= add_ln214_5_fu_332_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        t1_V_0_reg_106 <= {{vars_V[11:8]}};
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_2_fu_291_p2 == 1'd1) & (icmp_ln887_1_reg_389 == 1'd0) & (icmp_ln887_reg_364 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        t1_V_lcssa_reg_116 <= add_ln214_4_fu_280_p2;
    end else if (((icmp_ln887_1_fu_232_p2 == 1'd1) & (icmp_ln887_fu_166_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        t1_V_lcssa_reg_116 <= add_ln214_fu_214_p2;
    end else if (((icmp_ln887_fu_166_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        t1_V_lcssa_reg_116 <= t1_V_0_reg_106;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_reg_389 == 1'd0) & (icmp_ln887_reg_364 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        add_ln209_1_reg_407 <= add_ln209_1_fu_286_p2;
        add_ln214_4_reg_400 <= add_ln214_4_fu_280_p2;
        icmp_ln887_2_reg_415 <= icmp_ln887_2_fu_291_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_fu_166_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        add_ln209_reg_375 <= add_ln209_fu_220_p2;
        add_ln214_3_reg_383 <= add_ln214_3_fu_226_p2;
        add_ln214_reg_368 <= add_ln214_fu_214_p2;
        icmp_ln887_1_reg_389 <= icmp_ln887_1_fu_232_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_1_fu_232_p2 == 1'd0) & (icmp_ln887_fu_166_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        add_ln214_1_reg_393 <= add_ln214_1_fu_238_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        icmp_ln887_reg_364 <= icmp_ln887_fu_166_p2;
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
            if (((icmp_ln887_2_fu_291_p2 == 1'd0) & (icmp_ln887_1_reg_389 == 1'd0) & (icmp_ln887_reg_364 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
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

assign Uoutport_V = t1_V_lcssa_reg_116;

assign Xoutport_V = 4'd15;

assign Youtport_V = p_0423_0_lcssa_reg_129;

assign add_ln209_1_fu_286_p2 = ($signed(add_ln209_reg_375) + $signed(add_ln214_4_fu_280_p2));

assign add_ln209_2_fu_338_p2 = (add_ln209_1_reg_407 + add_ln214_5_fu_332_p2);

assign add_ln209_fu_220_p2 = ($signed(p_0423_0_0_reg_96) + $signed(add_ln214_fu_214_p2));

assign add_ln214_1_fu_238_p2 = (p_0426_0_0_reg_86 + 4'd2);

assign add_ln214_2_fu_343_p2 = (p_0426_0_0_reg_86 + 4'd3);

assign add_ln214_3_fu_226_p2 = (p_0426_0_0_reg_86 + 4'd1);

assign add_ln214_4_fu_280_p2 = (add_ln214_7_fu_275_p2 + sub_ln214_3_fu_259_p2);

assign add_ln214_5_fu_332_p2 = (add_ln214_8_fu_327_p2 + sub_ln214_5_fu_311_p2);

assign add_ln214_6_fu_208_p2 = (p_0423_0_0_reg_96 + sub_ln214_9_fu_202_p2);

assign add_ln214_7_fu_275_p2 = (add_ln209_reg_375 + sub_ln214_10_fu_269_p2);

assign add_ln214_8_fu_327_p2 = (add_ln209_1_reg_407 + sub_ln214_11_fu_321_p2);

assign add_ln214_fu_214_p2 = (add_ln214_6_fu_208_p2 + sub_ln214_1_fu_190_p2);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

assign icmp_ln887_1_fu_232_p2 = ((add_ln214_3_fu_226_p2 == 4'd15) ? 1'b1 : 1'b0);

assign icmp_ln887_2_fu_291_p2 = ((add_ln214_1_reg_393 == 4'd15) ? 1'b1 : 1'b0);

assign icmp_ln887_fu_166_p2 = ((p_0426_0_0_reg_86 == 4'd15) ? 1'b1 : 1'b0);

assign mul_ln209_1_fu_254_p2 = ($signed(add_ln214_reg_368) * $signed(sub_ln214_2_fu_249_p2));

assign mul_ln209_2_fu_306_p2 = ($signed(add_ln214_4_reg_400) * $signed(sub_ln214_4_fu_301_p2));

assign mul_ln209_fu_184_p2 = ($signed(t1_V_0_reg_106) * $signed(sub_ln214_fu_178_p2));

assign shl_ln214_1_fu_196_p2 = p_0423_0_0_reg_96 << 4'd2;

assign shl_ln214_2_fu_244_p2 = add_ln214_3_reg_383 << 4'd2;

assign shl_ln214_3_fu_264_p2 = add_ln209_reg_375 << 4'd2;

assign shl_ln214_4_fu_296_p2 = add_ln214_1_reg_393 << 4'd2;

assign shl_ln214_5_fu_316_p2 = add_ln209_1_reg_407 << 4'd2;

assign shl_ln214_fu_172_p2 = p_0426_0_0_reg_86 << 4'd2;

assign sub_ln214_10_fu_269_p2 = (4'd0 - shl_ln214_3_fu_264_p2);

assign sub_ln214_11_fu_321_p2 = (4'd0 - shl_ln214_5_fu_316_p2);

assign sub_ln214_1_fu_190_p2 = ($signed(t1_V_0_reg_106) - $signed(mul_ln209_fu_184_p2));

assign sub_ln214_2_fu_249_p2 = (shl_ln214_2_fu_244_p2 - add_ln214_3_reg_383);

assign sub_ln214_3_fu_259_p2 = ($signed(add_ln214_reg_368) - $signed(mul_ln209_1_fu_254_p2));

assign sub_ln214_4_fu_301_p2 = (shl_ln214_4_fu_296_p2 - add_ln214_1_reg_393);

assign sub_ln214_5_fu_311_p2 = ($signed(add_ln214_4_reg_400) - $signed(mul_ln209_2_fu_306_p2));

assign sub_ln214_9_fu_202_p2 = (4'd0 - shl_ln214_1_fu_196_p2);

assign sub_ln214_fu_178_p2 = (shl_ln214_fu_172_p2 - p_0426_0_0_reg_86);

assign x_var_V_fu_142_p1 = vars_V[3:0];

endmodule //diffeq_easy