// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="barcode,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=2.276500,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=33,HLS_SYN_LUT=169,HLS_VERSION=2020_1}" *)

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
parameter    ap_ST_fsm_state2 = 4'd2;
parameter    ap_ST_fsm_state3 = 4'd4;
parameter    ap_ST_fsm_state4 = 4'd8;

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

(* fsm_encoding = "none" *) reg   [3:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [0:0] flag_fu_199_p2;
reg   [0:0] flag_reg_266;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln883_fu_184_p2;
wire   [5:0] add_ln214_fu_217_p2;
reg   [5:0] add_ln214_reg_271;
wire   [3:0] width_V_fu_240_p2;
reg   [3:0] width_V_reg_279;
wire    ap_CS_fsm_state3;
reg   [5:0] seed_V_read_assign_reg_130;
wire    ap_CS_fsm_state4;
reg   [3:0] p_027_0_reg_139;
reg   [0:0] flag_0_reg_152;
reg   [3:0] p_027_1_reg_163;
wire   [0:0] xor_ln53_fu_223_p2;
reg   [2:0] actnum_V_1_fu_74;
wire   [2:0] actnum_V_fu_229_p2;
wire   [4:0] tmp_1_fu_189_p4;
wire   [5:0] shl_ln214_fu_205_p2;
wire   [5:0] sub_ln214_fu_211_p2;
reg   [3:0] ap_NS_fsm;

// power-on initialization
initial begin
#0 ap_CS_fsm = 4'd1;
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (((xor_ln53_fu_223_p2 == 1'd1) & (icmp_ln883_fu_184_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        actnum_V_1_fu_74 <= actnum_V_fu_229_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        actnum_V_1_fu_74 <= 3'd0;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        flag_0_reg_152 <= flag_reg_266;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        flag_0_reg_152 <= 1'd0;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        p_027_0_reg_139 <= width_V_reg_279;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_027_0_reg_139 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_184_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        if ((xor_ln53_fu_223_p2 == 1'd0)) begin
            p_027_1_reg_163 <= p_027_0_reg_139;
        end else if ((xor_ln53_fu_223_p2 == 1'd1)) begin
            p_027_1_reg_163 <= 4'd0;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        seed_V_read_assign_reg_130 <= add_ln214_reg_271;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        seed_V_read_assign_reg_130 <= seed_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_184_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        add_ln214_reg_271 <= add_ln214_fu_217_p2;
        flag_reg_266 <= flag_fu_199_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        width_V_reg_279 <= width_V_fu_240_p2;
    end
end

always @ (*) begin
    if (((icmp_ln883_fu_184_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        if ((xor_ln53_fu_223_p2 == 1'd1)) begin
            memw = 1'd1;
        end else if ((xor_ln53_fu_223_p2 == 1'd0)) begin
            memw = 1'd0;
        end else begin
            memw = 'bx;
        end
    end else begin
        memw = 'bx;
    end
end

always @ (*) begin
    if (((xor_ln53_fu_223_p2 == 1'd1) & (icmp_ln883_fu_184_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        vld = 1'd1;
    end else if (((1'b1 == ap_CS_fsm_state1) | ((xor_ln53_fu_223_p2 == 1'd0) & (icmp_ln883_fu_184_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2)))) begin
        vld = 1'd0;
    end else begin
        vld = 'bx;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        ap_ST_fsm_state2 : begin
            if (((icmp_ln883_fu_184_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_state4;
        end
        ap_ST_fsm_state4 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign actnum_V_fu_229_p2 = (actnum_V_1_fu_74 + 3'd1);

assign add_ln214_fu_217_p2 = (6'd1 + sub_ln214_fu_211_p2);

assign addr_V = actnum_V_1_fu_74;

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign data_V = p_027_0_reg_139;

assign eoc = 1'd0;

assign flag_fu_199_p2 = ((tmp_1_fu_189_p4 == 5'd0) ? 1'b1 : 1'b0);

assign icmp_ln883_fu_184_p2 = ((actnum_V_1_fu_74 == num_V) ? 1'b1 : 1'b0);

assign shl_ln214_fu_205_p2 = seed_V_read_assign_reg_130 << 6'd3;

assign sub_ln214_fu_211_p2 = (shl_ln214_fu_205_p2 - seed_V_read_assign_reg_130);

assign tmp_1_fu_189_p4 = {{seed_V_read_assign_reg_130[5:1]}};

assign width_V_fu_240_p2 = (p_027_1_reg_163 + 4'd1);

assign xor_ln53_fu_223_p2 = (flag_fu_199_p2 ^ flag_0_reg_152);

endmodule //barcode
