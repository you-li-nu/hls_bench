// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="ellipf,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=pipeline,HLS_SYN_CLOCK=7.405000,HLS_SYN_LAT=2,HLS_SYN_TPT=2,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=33,HLS_SYN_LUT=261,HLS_VERSION=2020_1}" *)

module ellipf (
        ap_clk,
        ap_rst,
        in_ports_V,
        out_ports_V,
        out_ports_V_ap_vld
);

parameter    ap_ST_fsm_pp0_stage0 = 2'd1;
parameter    ap_ST_fsm_pp0_stage1 = 2'd2;

input   ap_clk;
input   ap_rst;
input  [31:0] in_ports_V;
output  [31:0] out_ports_V;
output   out_ports_V_ap_vld;

reg out_ports_V_ap_vld;

wire   [3:0] inp_V_fu_81_p1;
reg   [3:0] inp_V_reg_322;
(* fsm_encoding = "none" *) reg   [1:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage1;
wire    ap_block_state2_pp0_stage1_iter0;
wire    ap_block_pp0_stage1_11001;
wire   [3:0] sv39_V_fu_125_p4;
reg   [3:0] sv39_V_reg_327;
wire   [3:0] n1_V_fu_135_p2;
reg   [3:0] n1_V_reg_333;
wire   [3:0] n2_V_fu_141_p2;
reg   [3:0] n2_V_reg_339;
wire   [3:0] n3_V_fu_147_p2;
reg   [3:0] n3_V_reg_345;
wire   [3:0] n5_V_fu_159_p2;
reg   [3:0] n5_V_reg_351;
reg   [2:0] tmp_reg_358;
reg   [2:0] tmp_1_reg_363;
reg    ap_enable_reg_pp0_iter1;
wire    ap_block_state1_pp0_stage0_iter0;
wire    ap_block_state3_pp0_stage0_iter1;
wire    ap_block_pp0_stage0_subdone;
wire    ap_CS_fsm_pp0_stage0;
wire    ap_block_pp0_stage1_subdone;
wire    ap_block_pp0_stage0_01001;
wire    ap_block_pp0_stage0_11001;
wire    ap_block_pp0_stage1;
wire   [3:0] sv2_V_fu_85_p4;
wire   [3:0] sv33_V_fu_115_p4;
wire   [3:0] sv13_V_fu_95_p4;
wire   [3:0] sv26_V_fu_105_p4;
wire   [3:0] add_ln209_fu_153_p2;
wire    ap_block_pp0_stage0;
wire   [3:0] n8_V_fu_185_p2;
wire   [3:0] add_ln209_4_fu_193_p2;
wire   [3:0] n9_V_fu_189_p2;
wire   [3:0] add_ln209_6_fu_203_p2;
wire   [3:0] n15_V_fu_198_p2;
wire   [3:0] n16_V_fu_208_p2;
wire   [3:0] factor_fu_229_p3;
wire   [3:0] add_ln209_11_fu_236_p2;
wire   [3:0] factor1_fu_248_p3;
wire   [3:0] n19_V_fu_218_p2;
wire   [3:0] n17_V_fu_213_p2;
wire   [3:0] add_ln209_14_fu_261_p2;
wire   [3:0] n28_V_fu_242_p2;
wire   [3:0] add_ln209_17_fu_278_p2;
wire   [3:0] n29_V_fu_255_p2;
wire   [3:0] n20_V_fu_224_p2;
wire   [3:0] sv39_o_V_fu_295_p2;
wire   [3:0] sv33_o_V_fu_289_p2;
wire   [3:0] sv26_o_V_fu_283_p2;
wire   [3:0] sv13_o_V_fu_272_p2;
wire   [3:0] sv2_o_V_fu_266_p2;
reg   [1:0] ap_NS_fsm;
wire    ap_reset_idle_pp0;
reg    ap_idle_pp0;
wire    ap_enable_pp0;

// power-on initialization
initial begin
#0 ap_CS_fsm = 2'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_pp0_stage0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_pp0_stage1_subdone) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
            ap_enable_reg_pp0_iter1 <= 1'b1;
        end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == 1'b0) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_enable_reg_pp0_iter1 <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage1_11001) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        inp_V_reg_322 <= inp_V_fu_81_p1;
        n1_V_reg_333 <= n1_V_fu_135_p2;
        n2_V_reg_339 <= n2_V_fu_141_p2;
        n3_V_reg_345 <= n3_V_fu_147_p2;
        n5_V_reg_351 <= n5_V_fu_159_p2;
        sv39_V_reg_327 <= {{in_ports_V[31:28]}};
        tmp_1_reg_363 <= {{in_ports_V[26:24]}};
        tmp_reg_358 <= {{in_ports_V[14:12]}};
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter1 == 1'b0) & (1'b1 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

assign ap_reset_idle_pp0 = 1'b0;

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_enable_reg_pp0_iter1 == 1'b1))) begin
        out_ports_V_ap_vld = 1'b1;
    end else begin
        out_ports_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_pp0_stage0 : begin
            if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_reset_idle_pp0 == 1'b0))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
            end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_reset_idle_pp0 == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
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
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign add_ln209_11_fu_236_p2 = (n15_V_fu_198_p2 + factor_fu_229_p3);

assign add_ln209_14_fu_261_p2 = (n17_V_fu_213_p2 + inp_V_reg_322);

assign add_ln209_17_fu_278_p2 = (n9_V_fu_189_p2 + n5_V_reg_351);

assign add_ln209_4_fu_193_p2 = (n8_V_fu_185_p2 + n1_V_reg_333);

assign add_ln209_6_fu_203_p2 = (n9_V_fu_189_p2 + sv39_V_reg_327);

assign add_ln209_fu_153_p2 = (n3_V_fu_147_p2 + sv26_V_fu_105_p4);

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_pp0_stage1 = ap_CS_fsm[32'd1];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_01001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_subdone = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1_subdone = ~(1'b1 == 1'b1);

assign ap_block_state1_pp0_stage0_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state2_pp0_stage1_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state3_pp0_stage0_iter1 = ~(1'b1 == 1'b1);

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign factor1_fu_248_p3 = {{tmp_1_reg_363}, {1'd0}};

assign factor_fu_229_p3 = {{tmp_reg_358}, {1'd0}};

assign inp_V_fu_81_p1 = in_ports_V[3:0];

assign n15_V_fu_198_p2 = (n3_V_reg_345 + add_ln209_4_fu_193_p2);

assign n16_V_fu_208_p2 = (n2_V_reg_339 + add_ln209_6_fu_203_p2);

assign n17_V_fu_213_p2 = (n1_V_reg_333 + n15_V_fu_198_p2);

assign n19_V_fu_218_p2 = (n9_V_fu_189_p2 + n16_V_fu_208_p2);

assign n1_V_fu_135_p2 = (inp_V_fu_81_p1 + sv2_V_fu_85_p4);

assign n20_V_fu_224_p2 = (sv39_V_reg_327 + n16_V_fu_208_p2);

assign n28_V_fu_242_p2 = (n8_V_fu_185_p2 + add_ln209_11_fu_236_p2);

assign n29_V_fu_255_p2 = (factor1_fu_248_p3 + n19_V_fu_218_p2);

assign n2_V_fu_141_p2 = (sv33_V_fu_115_p4 + sv39_V_fu_125_p4);

assign n3_V_fu_147_p2 = (sv13_V_fu_95_p4 + n1_V_fu_135_p2);

assign n5_V_fu_159_p2 = (n2_V_fu_141_p2 + add_ln209_fu_153_p2);

assign n8_V_fu_185_p2 = (n3_V_reg_345 + n5_V_reg_351);

assign n9_V_fu_189_p2 = (n2_V_reg_339 + n5_V_reg_351);

assign out_ports_V = {{{{{{{{sv39_o_V_fu_295_p2}, {n29_V_fu_255_p2}}, {sv33_o_V_fu_289_p2}}, {sv26_o_V_fu_283_p2}}, {n28_V_fu_242_p2}}, {sv13_o_V_fu_272_p2}}, {sv2_o_V_fu_266_p2}}, {n20_V_fu_224_p2}};

assign sv13_V_fu_95_p4 = {{in_ports_V[11:8]}};

assign sv13_o_V_fu_272_p2 = (n17_V_fu_213_p2 + n28_V_fu_242_p2);

assign sv26_V_fu_105_p4 = {{in_ports_V[19:16]}};

assign sv26_o_V_fu_283_p2 = (n8_V_fu_185_p2 + add_ln209_17_fu_278_p2);

assign sv2_V_fu_85_p4 = {{in_ports_V[7:4]}};

assign sv2_o_V_fu_266_p2 = (n15_V_fu_198_p2 + add_ln209_14_fu_261_p2);

assign sv33_V_fu_115_p4 = {{in_ports_V[23:20]}};

assign sv33_o_V_fu_289_p2 = (n19_V_fu_218_p2 + n29_V_fu_255_p2);

assign sv39_V_fu_125_p4 = {{in_ports_V[31:28]}};

assign sv39_o_V_fu_295_p2 = (n16_V_fu_208_p2 + n20_V_fu_224_p2);

endmodule //ellipf
