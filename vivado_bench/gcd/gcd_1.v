// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="gcd2,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=1.980000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=10,HLS_SYN_LUT=85,HLS_VERSION=2020_1}" *)

module gcd2 (
        ap_clk,
        ap_rst,
        x_var_V,
        y_var_V,
        gcd_output_V,
        gcd_output_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 2'd1;
parameter    ap_ST_fsm_state2 = 2'd2;

input   ap_clk;
input   ap_rst;
input  [3:0] x_var_V;
input  [3:0] y_var_V;
output  [3:0] gcd_output_V;
output   gcd_output_V_ap_vld;

reg gcd_output_V_ap_vld;

(* fsm_encoding = "none" *) reg   [1:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [3:0] select_ln12_fu_86_p3;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln883_fu_62_p2;
wire   [3:0] select_ln12_1_fu_94_p3;
reg   [3:0] x_var_V_buf_0_reg_43;
reg   [3:0] y_var_V_buf_0_reg_53;
wire   [0:0] icmp_ln887_fu_68_p2;
wire   [3:0] sub_ln701_1_fu_80_p2;
wire   [3:0] sub_ln701_fu_74_p2;
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
    if (((icmp_ln883_fu_62_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        x_var_V_buf_0_reg_43 <= select_ln12_fu_86_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        x_var_V_buf_0_reg_43 <= x_var_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_62_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        y_var_V_buf_0_reg_53 <= select_ln12_1_fu_94_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        y_var_V_buf_0_reg_53 <= y_var_V;
    end
end

always @ (*) begin
    if (((icmp_ln883_fu_62_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
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
            if (((icmp_ln883_fu_62_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
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

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign gcd_output_V = x_var_V_buf_0_reg_43;

assign icmp_ln883_fu_62_p2 = ((x_var_V_buf_0_reg_43 == y_var_V_buf_0_reg_53) ? 1'b1 : 1'b0);

assign icmp_ln887_fu_68_p2 = ((x_var_V_buf_0_reg_43 < y_var_V_buf_0_reg_53) ? 1'b1 : 1'b0);

assign select_ln12_1_fu_94_p3 = ((icmp_ln887_fu_68_p2[0:0] === 1'b1) ? sub_ln701_fu_74_p2 : y_var_V_buf_0_reg_53);

assign select_ln12_fu_86_p3 = ((icmp_ln887_fu_68_p2[0:0] === 1'b1) ? x_var_V_buf_0_reg_43 : sub_ln701_1_fu_80_p2);

assign sub_ln701_1_fu_80_p2 = (x_var_V_buf_0_reg_43 - y_var_V_buf_0_reg_53);

assign sub_ln701_fu_74_p2 = (y_var_V_buf_0_reg_53 - x_var_V_buf_0_reg_43);

endmodule //gcd2
