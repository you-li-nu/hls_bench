// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="gcd2,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=4.125000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=29,HLS_SYN_LUT=191,HLS_VERSION=2020_1}" *)

module gcd2 (
        ap_clk,
        ap_rst,
        x_var_V,
        y_var_V,
        gcd_output_V,
        gcd_output_V_ap_vld
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
output  [3:0] gcd_output_V;
output   gcd_output_V_ap_vld;

reg gcd_output_V_ap_vld;

(* fsm_encoding = "none" *) reg   [4:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [0:0] icmp_ln883_fu_116_p2;
reg   [0:0] icmp_ln883_reg_176;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln887_fu_122_p2;
reg   [0:0] icmp_ln887_reg_180;
wire   [3:0] select_ln12_fu_128_p3;
reg   [3:0] select_ln12_reg_186;
wire    ap_CS_fsm_state3;
wire   [3:0] select_ln12_1_fu_135_p3;
reg   [3:0] select_ln12_1_reg_194;
wire   [0:0] icmp_ln883_1_fu_142_p2;
reg   [0:0] icmp_ln883_1_reg_201;
wire   [0:0] icmp_ln887_1_fu_148_p2;
reg   [0:0] icmp_ln887_1_reg_205;
wire   [3:0] select_ln12_2_fu_154_p3;
wire    ap_CS_fsm_state4;
wire   [3:0] select_ln12_3_fu_160_p3;
reg   [3:0] x_var_V_buf_0_0_reg_57;
reg   [3:0] y_var_V_buf_0_0_reg_67;
reg   [3:0] x_var_V_buf_0_lcssa_reg_77;
wire    ap_CS_fsm_state5;
reg   [3:0] grp_fu_88_p0;
reg   [3:0] grp_fu_88_p1;
wire   [3:0] grp_fu_88_p2;
reg   [4:0] ap_NS_fsm;
reg    ap_condition_144;
reg    ap_condition_148;

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
    if (((icmp_ln883_1_reg_201 == 1'd0) & (icmp_ln883_reg_176 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        x_var_V_buf_0_0_reg_57 <= select_ln12_2_fu_154_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        x_var_V_buf_0_0_reg_57 <= x_var_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_1_fu_142_p2 == 1'd1) & (icmp_ln883_reg_176 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        x_var_V_buf_0_lcssa_reg_77 <= select_ln12_fu_128_p3;
    end else if (((icmp_ln883_fu_116_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        x_var_V_buf_0_lcssa_reg_77 <= x_var_V_buf_0_0_reg_57;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_1_reg_201 == 1'd0) & (icmp_ln883_reg_176 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        y_var_V_buf_0_0_reg_67 <= select_ln12_3_fu_160_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        y_var_V_buf_0_0_reg_67 <= y_var_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_reg_176 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        icmp_ln883_1_reg_201 <= icmp_ln883_1_fu_142_p2;
        select_ln12_1_reg_194 <= select_ln12_1_fu_135_p3;
        select_ln12_reg_186 <= select_ln12_fu_128_p3;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        icmp_ln883_reg_176 <= icmp_ln883_fu_116_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_1_fu_142_p2 == 1'd0) & (icmp_ln883_reg_176 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        icmp_ln887_1_reg_205 <= icmp_ln887_1_fu_148_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_116_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        icmp_ln887_reg_180 <= icmp_ln887_fu_122_p2;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        gcd_output_V_ap_vld = 1'b1;
    end else begin
        gcd_output_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if ((icmp_ln883_reg_176 == 1'd0)) begin
        if ((1'b1 == ap_condition_148)) begin
            grp_fu_88_p0 = select_ln12_reg_186;
        end else if ((1'b1 == ap_condition_144)) begin
            grp_fu_88_p0 = select_ln12_1_reg_194;
        end else if (((icmp_ln887_reg_180 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
            grp_fu_88_p0 = x_var_V_buf_0_0_reg_57;
        end else if (((icmp_ln887_reg_180 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
            grp_fu_88_p0 = y_var_V_buf_0_0_reg_67;
        end else begin
            grp_fu_88_p0 = 'bx;
        end
    end else begin
        grp_fu_88_p0 = 'bx;
    end
end

always @ (*) begin
    if ((icmp_ln883_reg_176 == 1'd0)) begin
        if ((1'b1 == ap_condition_148)) begin
            grp_fu_88_p1 = select_ln12_1_reg_194;
        end else if ((1'b1 == ap_condition_144)) begin
            grp_fu_88_p1 = select_ln12_reg_186;
        end else if (((icmp_ln887_reg_180 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
            grp_fu_88_p1 = y_var_V_buf_0_0_reg_67;
        end else if (((icmp_ln887_reg_180 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
            grp_fu_88_p1 = x_var_V_buf_0_0_reg_57;
        end else begin
            grp_fu_88_p1 = 'bx;
        end
    end else begin
        grp_fu_88_p1 = 'bx;
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
            if (((icmp_ln883_1_fu_142_p2 == 1'd0) & (icmp_ln883_reg_176 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
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

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

always @ (*) begin
    ap_condition_144 = ((icmp_ln887_1_reg_205 == 1'd1) & (icmp_ln883_1_reg_201 == 1'd0) & (1'b1 == ap_CS_fsm_state4));
end

always @ (*) begin
    ap_condition_148 = ((icmp_ln887_1_reg_205 == 1'd0) & (icmp_ln883_1_reg_201 == 1'd0) & (1'b1 == ap_CS_fsm_state4));
end

assign gcd_output_V = x_var_V_buf_0_lcssa_reg_77;

assign grp_fu_88_p2 = (grp_fu_88_p0 - grp_fu_88_p1);

assign icmp_ln883_1_fu_142_p2 = ((select_ln12_fu_128_p3 == select_ln12_1_fu_135_p3) ? 1'b1 : 1'b0);

assign icmp_ln883_fu_116_p2 = ((x_var_V_buf_0_0_reg_57 == y_var_V_buf_0_0_reg_67) ? 1'b1 : 1'b0);

assign icmp_ln887_1_fu_148_p2 = ((select_ln12_fu_128_p3 < select_ln12_1_fu_135_p3) ? 1'b1 : 1'b0);

assign icmp_ln887_fu_122_p2 = ((x_var_V_buf_0_0_reg_57 < y_var_V_buf_0_0_reg_67) ? 1'b1 : 1'b0);

assign select_ln12_1_fu_135_p3 = ((icmp_ln887_reg_180[0:0] === 1'b1) ? grp_fu_88_p2 : y_var_V_buf_0_0_reg_67);

assign select_ln12_2_fu_154_p3 = ((icmp_ln887_1_reg_205[0:0] === 1'b1) ? select_ln12_reg_186 : grp_fu_88_p2);

assign select_ln12_3_fu_160_p3 = ((icmp_ln887_1_reg_205[0:0] === 1'b1) ? grp_fu_88_p2 : select_ln12_1_reg_194);

assign select_ln12_fu_128_p3 = ((icmp_ln887_reg_180[0:0] === 1'b1) ? x_var_V_buf_0_0_reg_57 : grp_fu_88_p2);

endmodule //gcd2
