// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="counter,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=3.300000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=35,HLS_SYN_LUT=203,HLS_VERSION=2020_1}" *)

module counter (
        ap_clk,
        ap_rst,
        seed_V,
        out_V,
        out_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 4'd1;
parameter    ap_ST_fsm_pp0_stage0 = 4'd2;
parameter    ap_ST_fsm_pp0_stage1 = 4'd4;
parameter    ap_ST_fsm_state5 = 4'd8;

input   ap_clk;
input   ap_rst;
input  [5:0] seed_V;
output  [3:0] out_V;
output   out_V_ap_vld;

reg out_V_ap_vld;

reg   [5:0] limit_V_in_reg_71;
reg   [3:0] limit_V_1_reg_81;
reg   [3:0] p_053_0_reg_92;
(* fsm_encoding = "none" *) reg   [3:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [0:0] icmp_ln883_fu_115_p2;
reg   [0:0] icmp_ln883_reg_218;
wire    ap_CS_fsm_pp0_stage0;
wire    ap_block_state2_pp0_stage0_iter0;
wire    ap_block_state4_pp0_stage0_iter1;
wire    ap_block_pp0_stage0_11001;
wire   [3:0] limit_V_2_fu_171_p3;
reg   [3:0] limit_V_2_reg_222;
reg    ap_enable_reg_pp0_iter0;
wire   [3:0] select_ln879_1_fu_199_p3;
reg   [3:0] select_ln879_1_reg_227;
wire   [5:0] add_ln320_fu_207_p2;
reg   [5:0] add_ln320_reg_232;
wire    ap_CS_fsm_pp0_stage1;
wire    ap_block_state3_pp0_stage1_iter0;
wire    ap_block_pp0_stage1_11001;
wire    ap_block_pp0_stage0_subdone;
reg    ap_condition_pp0_exit_iter0_state2;
reg    ap_enable_reg_pp0_iter1;
wire    ap_block_pp0_stage1_subdone;
reg   [5:0] ap_phi_mux_limit_V_in_phi_fu_74_p4;
wire    ap_block_pp0_stage0;
reg   [3:0] ap_phi_mux_limit_V_1_phi_fu_85_p4;
reg   [3:0] ap_phi_mux_p_053_0_phi_fu_97_p4;
wire    ap_CS_fsm_state5;
wire   [1:0] ctrl_V_fu_105_p4;
wire   [0:0] icmp_ln883_1_fu_137_p2;
wire   [3:0] count_V_fu_143_p2;
wire   [3:0] count_V_1_fu_157_p2;
wire   [0:0] icmp_ln879_fu_125_p2;
wire   [3:0] data_V_fu_121_p1;
wire   [0:0] icmp_ln879_1_fu_131_p2;
wire   [0:0] xor_ln879_fu_179_p2;
wire   [0:0] and_ln879_fu_185_p2;
wire   [3:0] select_ln32_fu_149_p3;
wire   [3:0] select_ln36_fu_163_p3;
wire   [3:0] select_ln879_fu_191_p3;
wire    ap_block_pp0_stage1;
reg   [3:0] ap_NS_fsm;
reg    ap_idle_pp0;
wire    ap_enable_pp0;

// power-on initialization
initial begin
#0 ap_CS_fsm = 4'd1;
#0 ap_enable_reg_pp0_iter0 = 1'b0;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
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
        if (((1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_condition_pp0_exit_iter0_state2) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
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
        if ((((1'b0 == ap_block_pp0_stage1_subdone) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
            ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
        end else if ((1'b1 == ap_CS_fsm_state1)) begin
            ap_enable_reg_pp0_iter1 <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln883_reg_218 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        limit_V_1_reg_81 <= limit_V_2_reg_222;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        limit_V_1_reg_81 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln883_reg_218 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        limit_V_in_reg_71 <= add_ln320_reg_232;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        limit_V_in_reg_71 <= seed_V;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln883_reg_218 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        p_053_0_reg_92 <= select_ln879_1_reg_227;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_053_0_reg_92 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage1_11001) & (icmp_ln883_reg_218 == 1'd0) & (1'b1 == ap_CS_fsm_pp0_stage1) & (ap_enable_reg_pp0_iter0 == 1'b1))) begin
        add_ln320_reg_232 <= add_ln320_fu_207_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        icmp_ln883_reg_218 <= icmp_ln883_fu_115_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln883_fu_115_p2 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        limit_V_2_reg_222 <= limit_V_2_fu_171_p3;
        select_ln879_1_reg_227 <= select_ln879_1_fu_199_p3;
    end
end

always @ (*) begin
    if ((icmp_ln883_fu_115_p2 == 1'd1)) begin
        ap_condition_pp0_exit_iter0_state2 = 1'b1;
    end else begin
        ap_condition_pp0_exit_iter0_state2 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (icmp_ln883_reg_218 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_phi_mux_limit_V_1_phi_fu_85_p4 = limit_V_2_reg_222;
    end else begin
        ap_phi_mux_limit_V_1_phi_fu_85_p4 = limit_V_1_reg_81;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (icmp_ln883_reg_218 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_phi_mux_limit_V_in_phi_fu_74_p4 = add_ln320_reg_232;
    end else begin
        ap_phi_mux_limit_V_in_phi_fu_74_p4 = limit_V_in_reg_71;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (icmp_ln883_reg_218 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_phi_mux_p_053_0_phi_fu_97_p4 = select_ln879_1_reg_227;
    end else begin
        ap_phi_mux_p_053_0_phi_fu_97_p4 = p_053_0_reg_92;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        out_V_ap_vld = 1'b1;
    end else begin
        out_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_pp0_stage0;
        end
        ap_ST_fsm_pp0_stage0 : begin
            if ((~((1'b0 == ap_block_pp0_stage0_subdone) & (icmp_ln883_fu_115_p2 == 1'd1) & (ap_enable_reg_pp0_iter0 == 1'b1)) & (1'b0 == ap_block_pp0_stage0_subdone))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
            end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (icmp_ln883_fu_115_p2 == 1'd1) & (ap_enable_reg_pp0_iter0 == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end
        end
        ap_ST_fsm_pp0_stage1 : begin
            if ((1'b0 == ap_block_pp0_stage1_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
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

assign add_ln320_fu_207_p2 = (6'd1 + limit_V_in_reg_71);

assign and_ln879_fu_185_p2 = (xor_ln879_fu_179_p2 & icmp_ln879_1_fu_131_p2);

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_pp0_stage1 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd3];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_subdone = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1_subdone = ~(1'b1 == 1'b1);

assign ap_block_state2_pp0_stage0_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state3_pp0_stage1_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state4_pp0_stage0_iter1 = ~(1'b1 == 1'b1);

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign count_V_1_fu_157_p2 = ($signed(4'd15) + $signed(ap_phi_mux_p_053_0_phi_fu_97_p4));

assign count_V_fu_143_p2 = (4'd1 + ap_phi_mux_p_053_0_phi_fu_97_p4);

assign ctrl_V_fu_105_p4 = {{ap_phi_mux_limit_V_in_phi_fu_74_p4[5:4]}};

assign data_V_fu_121_p1 = ap_phi_mux_limit_V_in_phi_fu_74_p4[3:0];

assign icmp_ln879_1_fu_131_p2 = ((ctrl_V_fu_105_p4 == 2'd2) ? 1'b1 : 1'b0);

assign icmp_ln879_fu_125_p2 = ((ctrl_V_fu_105_p4 == 2'd1) ? 1'b1 : 1'b0);

assign icmp_ln883_1_fu_137_p2 = ((ap_phi_mux_p_053_0_phi_fu_97_p4 == ap_phi_mux_limit_V_1_phi_fu_85_p4) ? 1'b1 : 1'b0);

assign icmp_ln883_fu_115_p2 = ((ctrl_V_fu_105_p4 == 2'd0) ? 1'b1 : 1'b0);

assign limit_V_2_fu_171_p3 = ((icmp_ln879_fu_125_p2[0:0] === 1'b1) ? data_V_fu_121_p1 : ap_phi_mux_limit_V_1_phi_fu_85_p4);

assign out_V = p_053_0_reg_92;

assign select_ln32_fu_149_p3 = ((icmp_ln883_1_fu_137_p2[0:0] === 1'b1) ? ap_phi_mux_p_053_0_phi_fu_97_p4 : count_V_fu_143_p2);

assign select_ln36_fu_163_p3 = ((icmp_ln883_1_fu_137_p2[0:0] === 1'b1) ? ap_phi_mux_p_053_0_phi_fu_97_p4 : count_V_1_fu_157_p2);

assign select_ln879_1_fu_199_p3 = ((icmp_ln879_fu_125_p2[0:0] === 1'b1) ? ap_phi_mux_p_053_0_phi_fu_97_p4 : select_ln879_fu_191_p3);

assign select_ln879_fu_191_p3 = ((and_ln879_fu_185_p2[0:0] === 1'b1) ? select_ln32_fu_149_p3 : select_ln36_fu_163_p3);

assign xor_ln879_fu_179_p2 = (icmp_ln879_fu_125_p2 ^ 1'd1);

endmodule //counter
