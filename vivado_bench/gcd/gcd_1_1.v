// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="gcd2,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=4.125000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=15,HLS_SYN_LUT=152,HLS_VERSION=2020_1}" *)

module gcd2 (
        ap_clk,
        ap_rst,
        x_var_V,
        y_var_V,
        gcd_output_V,
        gcd_output_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 3'd1;
parameter    ap_ST_fsm_state2 = 3'd2;
parameter    ap_ST_fsm_state3 = 3'd4;

input   ap_clk;
input   ap_rst;
input  [3:0] x_var_V;
input  [3:0] y_var_V;
output  [3:0] gcd_output_V;
output   gcd_output_V_ap_vld;

reg gcd_output_V_ap_vld;

(* fsm_encoding = "none" *) reg   [2:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [3:0] select_ln13_fu_109_p3;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln883_fu_85_p2;
wire   [3:0] select_ln13_2_fu_149_p3;
wire   [0:0] icmp_ln883_1_fu_125_p2;
wire   [3:0] select_ln13_3_fu_157_p3;
reg   [3:0] x_var_V_buf_0_0_reg_55;
reg   [3:0] y_var_V_buf_0_0_reg_65;
reg   [3:0] x_var_V_buf_0_lcssa_reg_74;
wire    ap_CS_fsm_state3;
wire   [0:0] icmp_ln887_fu_91_p2;
wire   [3:0] sub_ln701_1_fu_103_p2;
wire   [3:0] sub_ln701_fu_97_p2;
wire   [3:0] select_ln13_1_fu_117_p3;
wire   [0:0] icmp_ln887_1_fu_131_p2;
wire   [3:0] sub_ln701_3_fu_143_p2;
wire   [3:0] sub_ln701_2_fu_137_p2;
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
    if (((icmp_ln883_1_fu_125_p2 == 1'd0) & (icmp_ln883_fu_85_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        x_var_V_buf_0_0_reg_55 <= select_ln13_2_fu_149_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        x_var_V_buf_0_0_reg_55 <= x_var_V;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        if (((icmp_ln883_1_fu_125_p2 == 1'd1) & (icmp_ln883_fu_85_p2 == 1'd0))) begin
            x_var_V_buf_0_lcssa_reg_74 <= select_ln13_fu_109_p3;
        end else if ((icmp_ln883_fu_85_p2 == 1'd1)) begin
            x_var_V_buf_0_lcssa_reg_74 <= x_var_V_buf_0_0_reg_55;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_1_fu_125_p2 == 1'd0) & (icmp_ln883_fu_85_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        y_var_V_buf_0_0_reg_65 <= select_ln13_3_fu_157_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        y_var_V_buf_0_0_reg_65 <= y_var_V;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        gcd_output_V_ap_vld = 1'b1;
    end else begin
        gcd_output_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        ap_ST_fsm_state2 : begin
            if (((icmp_ln883_1_fu_125_p2 == 1'd0) & (icmp_ln883_fu_85_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
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

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign gcd_output_V = x_var_V_buf_0_lcssa_reg_74;

assign icmp_ln883_1_fu_125_p2 = ((select_ln13_fu_109_p3 == select_ln13_1_fu_117_p3) ? 1'b1 : 1'b0);

assign icmp_ln883_fu_85_p2 = ((x_var_V_buf_0_0_reg_55 == y_var_V_buf_0_0_reg_65) ? 1'b1 : 1'b0);

assign icmp_ln887_1_fu_131_p2 = ((select_ln13_fu_109_p3 < select_ln13_1_fu_117_p3) ? 1'b1 : 1'b0);

assign icmp_ln887_fu_91_p2 = ((x_var_V_buf_0_0_reg_55 < y_var_V_buf_0_0_reg_65) ? 1'b1 : 1'b0);

assign select_ln13_1_fu_117_p3 = ((icmp_ln887_fu_91_p2[0:0] === 1'b1) ? sub_ln701_fu_97_p2 : y_var_V_buf_0_0_reg_65);

assign select_ln13_2_fu_149_p3 = ((icmp_ln887_1_fu_131_p2[0:0] === 1'b1) ? select_ln13_fu_109_p3 : sub_ln701_3_fu_143_p2);

assign select_ln13_3_fu_157_p3 = ((icmp_ln887_1_fu_131_p2[0:0] === 1'b1) ? sub_ln701_2_fu_137_p2 : select_ln13_1_fu_117_p3);

assign select_ln13_fu_109_p3 = ((icmp_ln887_fu_91_p2[0:0] === 1'b1) ? x_var_V_buf_0_0_reg_55 : sub_ln701_1_fu_103_p2);

assign sub_ln701_1_fu_103_p2 = (x_var_V_buf_0_0_reg_55 - y_var_V_buf_0_0_reg_65);

assign sub_ln701_2_fu_137_p2 = (select_ln13_1_fu_117_p3 - select_ln13_fu_109_p3);

assign sub_ln701_3_fu_143_p2 = (select_ln13_fu_109_p3 - select_ln13_1_fu_117_p3);

assign sub_ln701_fu_97_p2 = (y_var_V_buf_0_0_reg_65 - x_var_V_buf_0_0_reg_55);

endmodule //gcd2
