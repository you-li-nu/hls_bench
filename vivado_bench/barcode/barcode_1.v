// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="barcode,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=2.395000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=16,HLS_SYN_LUT=125,HLS_VERSION=2020_1}" *)

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

parameter    ap_ST_fsm_state1 = 2'd1;
parameter    ap_ST_fsm_state2 = 2'd2;

input   ap_clk;
input   ap_rst;
input  [5:0] seed_V;
input  [2:0] num_V;
output   vld;
output   eoc;
output   memw;
output  [3:0] data_V;
output  [2:0] addr_V;

(* fsm_encoding = "none" *) reg   [1:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [0:0] flag_fu_172_p2;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln883_fu_157_p2;
wire   [5:0] add_ln214_fu_190_p2;
wire   [2:0] actnum_V_1_fu_208_p3;
wire   [3:0] width_V_fu_222_p3;
reg   [5:0] seed_V_read_assign_reg_114;
reg   [2:0] p_026_0_reg_123;
reg   [3:0] p_029_0_reg_134;
reg   [0:0] flag_0_reg_146;
wire   [4:0] tmp_fu_162_p4;
wire   [5:0] shl_ln214_fu_178_p2;
wire   [5:0] sub_ln214_fu_184_p2;
wire   [0:0] xor_ln53_fu_196_p2;
wire   [2:0] actnum_V_fu_202_p2;
wire   [3:0] add_ln700_fu_216_p2;
reg   [1:0] ap_NS_fsm;

// power-on initialization
initial begin
#0 ap_CS_fsm = 2'd1;
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_157_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        flag_0_reg_146 <= flag_fu_172_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        flag_0_reg_146 <= 1'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_157_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        p_026_0_reg_123 <= actnum_V_1_fu_208_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_026_0_reg_123 <= 3'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_157_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        p_029_0_reg_134 <= width_V_fu_222_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_029_0_reg_134 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_157_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        seed_V_read_assign_reg_114 <= add_ln214_fu_190_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        seed_V_read_assign_reg_114 <= seed_V;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        ap_ST_fsm_state2 : begin
            if (((icmp_ln883_fu_157_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
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

assign actnum_V_1_fu_208_p3 = ((xor_ln53_fu_196_p2[0:0] === 1'b1) ? actnum_V_fu_202_p2 : p_026_0_reg_123);

assign actnum_V_fu_202_p2 = (3'd1 + p_026_0_reg_123);

assign add_ln214_fu_190_p2 = (6'd1 + sub_ln214_fu_184_p2);

assign add_ln700_fu_216_p2 = (4'd1 + p_029_0_reg_134);

assign addr_V = num_V;

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign data_V = p_029_0_reg_134;

assign eoc = 1'd1;

assign flag_fu_172_p2 = ((tmp_fu_162_p4 == 5'd0) ? 1'b1 : 1'b0);

assign icmp_ln883_fu_157_p2 = ((p_026_0_reg_123 == num_V) ? 1'b1 : 1'b0);

assign memw = 1'd1;

assign shl_ln214_fu_178_p2 = seed_V_read_assign_reg_114 << 6'd3;

assign sub_ln214_fu_184_p2 = (shl_ln214_fu_178_p2 - seed_V_read_assign_reg_114);

assign tmp_fu_162_p4 = {{seed_V_read_assign_reg_114[5:1]}};

assign vld = 1'd1;

assign width_V_fu_222_p3 = ((xor_ln53_fu_196_p2[0:0] === 1'b1) ? 4'd1 : add_ln700_fu_216_p2);

assign xor_ln53_fu_196_p2 = (flag_fu_172_p2 ^ flag_0_reg_146);

endmodule //barcode