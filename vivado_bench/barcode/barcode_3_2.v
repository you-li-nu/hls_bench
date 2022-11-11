// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="barcode,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=2.276500,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=37,HLS_SYN_LUT=223,HLS_VERSION=2020_1}" *)

module barcode (
        ap_clk,
        ap_rst,
        seed_V,
        num_V,
        vld,
        eoc,
        memw,
        data_V,
        addr_V
);

parameter    ap_ST_fsm_state1 = 4'd1;
parameter    ap_ST_fsm_pp0_stage0 = 4'd2;
parameter    ap_ST_fsm_pp0_stage1 = 4'd4;
parameter    ap_ST_fsm_state5 = 4'd8;

input   ap_clk;
input   ap_rst;
input  [5:0] seed_V;
input  [2:0] num_V;
output   vld;
output   eoc;
output   memw;
output  [3:0] data_V;
output  [2:0] addr_V;

reg vld;
reg memw;

reg   [5:0] seed_V_read_assign_reg_132;
reg   [3:0] p_027_0_reg_141;
reg   [0:0] flag_0_reg_154;
(* fsm_encoding = "none" *) reg   [3:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [0:0] icmp_ln883_fu_186_p2;
reg   [0:0] icmp_ln883_reg_265;
wire    ap_CS_fsm_pp0_stage0;
wire    ap_block_state2_pp0_stage0_iter0;
wire    ap_block_state4_pp0_stage0_iter1;
wire    ap_block_pp0_stage0_11001;
wire   [0:0] flag_fu_201_p2;
reg   [0:0] flag_reg_269;
reg    ap_enable_reg_pp0_iter0;
wire   [5:0] add_ln214_fu_219_p2;
reg   [5:0] add_ln214_reg_274;
wire   [0:0] xor_ln53_fu_225_p2;
reg   [0:0] xor_ln53_reg_279;
wire   [3:0] width_V_fu_242_p2;
reg   [3:0] width_V_reg_283;
wire    ap_CS_fsm_pp0_stage1;
wire    ap_block_state3_pp0_stage1_iter0;
wire    ap_block_pp0_stage1_11001;
wire    ap_block_pp0_stage0_subdone;
reg    ap_condition_pp0_exit_iter0_state2;
reg    ap_enable_reg_pp0_iter1;
wire    ap_block_pp0_stage1_subdone;
reg   [5:0] ap_phi_mux_seed_V_read_assign_phi_fu_135_p4;
wire    ap_block_pp0_stage0;
reg   [3:0] ap_phi_mux_p_027_0_phi_fu_146_p4;
reg   [0:0] ap_phi_mux_flag_0_phi_fu_158_p4;
reg   [3:0] ap_phi_reg_pp0_iter0_p_027_1_reg_165;
reg   [2:0] actnum_V_1_fu_76;
wire   [2:0] actnum_V_fu_231_p2;
wire    ap_block_pp0_stage0_01001;
wire    ap_block_pp0_stage1_01001;
wire   [4:0] tmp_1_fu_191_p4;
wire   [5:0] shl_ln214_fu_207_p2;
wire   [5:0] sub_ln214_fu_213_p2;
wire    ap_block_pp0_stage1;
reg   [3:0] ap_NS_fsm;
reg    ap_idle_pp0;
wire    ap_enable_pp0;
reg    ap_condition_59;
reg    ap_condition_210;

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
    if (((xor_ln53_fu_225_p2 == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln883_fu_186_p2 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        actnum_V_1_fu_76 <= actnum_V_fu_231_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        actnum_V_1_fu_76 <= 3'd0;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_condition_59)) begin
        if ((xor_ln53_fu_225_p2 == 1'd0)) begin
            ap_phi_reg_pp0_iter0_p_027_1_reg_165 <= ap_phi_mux_p_027_0_phi_fu_146_p4;
        end else if ((xor_ln53_fu_225_p2 == 1'd1)) begin
            ap_phi_reg_pp0_iter0_p_027_1_reg_165 <= 4'd0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln883_reg_265 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        flag_0_reg_154 <= flag_reg_269;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        flag_0_reg_154 <= 1'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln883_reg_265 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        p_027_0_reg_141 <= width_V_reg_283;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_027_0_reg_141 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln883_reg_265 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        seed_V_read_assign_reg_132 <= add_ln214_reg_274;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        seed_V_read_assign_reg_132 <= seed_V;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln883_fu_186_p2 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        add_ln214_reg_274 <= add_ln214_fu_219_p2;
        flag_reg_269 <= flag_fu_201_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        icmp_ln883_reg_265 <= icmp_ln883_fu_186_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage1_11001) & (icmp_ln883_reg_265 == 1'd0) & (1'b1 == ap_CS_fsm_pp0_stage1) & (ap_enable_reg_pp0_iter0 == 1'b1))) begin
        width_V_reg_283 <= width_V_fu_242_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln883_fu_186_p2 == 1'd0) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        xor_ln53_reg_279 <= xor_ln53_fu_225_p2;
    end
end

always @ (*) begin
    if ((icmp_ln883_fu_186_p2 == 1'd1)) begin
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
    if (((icmp_ln883_reg_265 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (1'b0 == ap_block_pp0_stage0))) begin
        ap_phi_mux_flag_0_phi_fu_158_p4 = flag_reg_269;
    end else begin
        ap_phi_mux_flag_0_phi_fu_158_p4 = flag_0_reg_154;
    end
end

always @ (*) begin
    if (((icmp_ln883_reg_265 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (1'b0 == ap_block_pp0_stage0))) begin
        ap_phi_mux_p_027_0_phi_fu_146_p4 = width_V_reg_283;
    end else begin
        ap_phi_mux_p_027_0_phi_fu_146_p4 = p_027_0_reg_141;
    end
end

always @ (*) begin
    if (((icmp_ln883_reg_265 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (1'b0 == ap_block_pp0_stage0))) begin
        ap_phi_mux_seed_V_read_assign_phi_fu_135_p4 = add_ln214_reg_274;
    end else begin
        ap_phi_mux_seed_V_read_assign_phi_fu_135_p4 = seed_V_read_assign_reg_132;
    end
end

always @ (*) begin
    if ((1'b1 == ap_condition_210)) begin
        if ((xor_ln53_reg_279 == 1'd1)) begin
            memw = 1'd1;
        end else if ((xor_ln53_reg_279 == 1'd0)) begin
            memw = 1'd0;
        end else begin
            memw = 'bx;
        end
    end else begin
        memw = 'bx;
    end
end

always @ (*) begin
    if (((xor_ln53_reg_279 == 1'd1) & (icmp_ln883_reg_265 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (1'b0 == ap_block_pp0_stage0_01001))) begin
        vld = 1'd1;
    end else if (((1'b1 == ap_CS_fsm_state1) | ((xor_ln53_reg_279 == 1'd0) & (icmp_ln883_reg_265 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (1'b0 == ap_block_pp0_stage0_01001)))) begin
        vld = 1'd0;
    end else begin
        vld = 'bx;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_pp0_stage0;
        end
        ap_ST_fsm_pp0_stage0 : begin
            if ((~((1'b0 == ap_block_pp0_stage0_subdone) & (icmp_ln883_fu_186_p2 == 1'd1) & (ap_enable_reg_pp0_iter0 == 1'b1)) & (1'b0 == ap_block_pp0_stage0_subdone))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
            end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (icmp_ln883_fu_186_p2 == 1'd1) & (ap_enable_reg_pp0_iter0 == 1'b1))) begin
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

assign actnum_V_fu_231_p2 = (actnum_V_1_fu_76 + 3'd1);

assign add_ln214_fu_219_p2 = (6'd1 + sub_ln214_fu_213_p2);

assign addr_V = actnum_V_1_fu_76;

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_pp0_stage1 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_01001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_subdone = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1_01001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1_subdone = ~(1'b1 == 1'b1);

assign ap_block_state2_pp0_stage0_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state3_pp0_stage1_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state4_pp0_stage0_iter1 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_condition_210 = ((icmp_ln883_reg_265 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (1'b0 == ap_block_pp0_stage0_01001));
end

always @ (*) begin
    ap_condition_59 = ((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln883_fu_186_p2 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0));
end

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign data_V = p_027_0_reg_141;

assign eoc = 1'd0;

assign flag_fu_201_p2 = ((tmp_1_fu_191_p4 == 5'd0) ? 1'b1 : 1'b0);

assign icmp_ln883_fu_186_p2 = ((actnum_V_1_fu_76 == num_V) ? 1'b1 : 1'b0);

assign shl_ln214_fu_207_p2 = ap_phi_mux_seed_V_read_assign_phi_fu_135_p4 << 6'd3;

assign sub_ln214_fu_213_p2 = (shl_ln214_fu_207_p2 - ap_phi_mux_seed_V_read_assign_phi_fu_135_p4);

assign tmp_1_fu_191_p4 = {{ap_phi_mux_seed_V_read_assign_phi_fu_135_p4[5:1]}};

assign width_V_fu_242_p2 = (ap_phi_reg_pp0_iter0_p_027_1_reg_165 + 4'd1);

assign xor_ln53_fu_225_p2 = (flag_fu_201_p2 ^ ap_phi_mux_flag_0_phi_fu_158_p4);

endmodule //barcode
