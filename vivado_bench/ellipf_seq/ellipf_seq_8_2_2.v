// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="ellipf_seq,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=7.405000,HLS_SYN_LAT=10,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=72,HLS_SYN_LUT=306,HLS_VERSION=2020_1}" *)

module ellipf_seq (
        ap_clk,
        ap_rst,
        in_ports_V,
        out_ports_V,
        out_ports_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 4'd1;
parameter    ap_ST_fsm_state2 = 4'd2;
parameter    ap_ST_fsm_state3 = 4'd4;
parameter    ap_ST_fsm_state4 = 4'd8;

input   ap_clk;
input   ap_rst;
input  [31:0] in_ports_V;
output  [31:0] out_ports_V;
output   out_ports_V_ap_vld;

reg out_ports_V_ap_vld;

(* fsm_encoding = "none" *) reg   [3:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [2:0] i_V_fu_123_p2;
reg   [2:0] i_V_reg_377;
wire    ap_CS_fsm_state2;
wire   [3:0] inp_V_fu_129_p1;
reg   [3:0] inp_V_reg_382;
wire   [0:0] icmp_ln887_fu_117_p2;
wire   [3:0] sv39_V_fu_173_p4;
reg   [3:0] sv39_V_reg_387;
wire   [3:0] n1_V_fu_183_p2;
reg   [3:0] n1_V_reg_393;
wire   [3:0] n2_V_fu_189_p2;
reg   [3:0] n2_V_reg_399;
wire   [3:0] n3_V_fu_195_p2;
reg   [3:0] n3_V_reg_405;
wire   [3:0] n5_V_fu_207_p2;
reg   [3:0] n5_V_reg_411;
reg   [2:0] tmp_1_reg_418;
reg   [2:0] tmp_2_reg_423;
wire   [31:0] ret_V_fu_349_p9;
wire    ap_CS_fsm_state3;
reg   [31:0] in_ports_V_buf_0_reg_95;
reg   [2:0] p_0305_0_reg_106;
wire    ap_CS_fsm_state4;
wire   [3:0] sv2_V_fu_133_p4;
wire   [3:0] sv33_V_fu_163_p4;
wire   [3:0] sv13_V_fu_143_p4;
wire   [3:0] sv26_V_fu_153_p4;
wire   [3:0] add_ln209_fu_201_p2;
wire   [3:0] n8_V_fu_233_p2;
wire   [3:0] add_ln209_4_fu_241_p2;
wire   [3:0] n9_V_fu_237_p2;
wire   [3:0] add_ln209_6_fu_251_p2;
wire   [3:0] n15_V_fu_246_p2;
wire   [3:0] n16_V_fu_256_p2;
wire   [3:0] factor_fu_277_p3;
wire   [3:0] add_ln209_11_fu_284_p2;
wire   [3:0] factor1_fu_296_p3;
wire   [3:0] n19_V_fu_266_p2;
wire   [3:0] n17_V_fu_261_p2;
wire   [3:0] add_ln209_14_fu_309_p2;
wire   [3:0] n28_V_fu_290_p2;
wire   [3:0] add_ln209_17_fu_326_p2;
wire   [3:0] n29_V_fu_303_p2;
wire   [3:0] n20_V_fu_272_p2;
wire   [3:0] sv39_o_V_fu_343_p2;
wire   [3:0] sv33_o_V_fu_337_p2;
wire   [3:0] sv26_o_V_fu_331_p2;
wire   [3:0] sv13_o_V_fu_320_p2;
wire   [3:0] sv2_o_V_fu_314_p2;
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
    if ((1'b1 == ap_CS_fsm_state3)) begin
        in_ports_V_buf_0_reg_95 <= ret_V_fu_349_p9;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        in_ports_V_buf_0_reg_95 <= in_ports_V;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        p_0305_0_reg_106 <= i_V_reg_377;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_0305_0_reg_106 <= 3'd0;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        i_V_reg_377 <= i_V_fu_123_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln887_fu_117_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        inp_V_reg_382 <= inp_V_fu_129_p1;
        n1_V_reg_393 <= n1_V_fu_183_p2;
        n2_V_reg_399 <= n2_V_fu_189_p2;
        n3_V_reg_405 <= n3_V_fu_195_p2;
        n5_V_reg_411 <= n5_V_fu_207_p2;
        sv39_V_reg_387 <= {{in_ports_V_buf_0_reg_95[31:28]}};
        tmp_1_reg_418 <= {{in_ports_V_buf_0_reg_95[14:12]}};
        tmp_2_reg_423 <= {{in_ports_V_buf_0_reg_95[26:24]}};
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        out_ports_V_ap_vld = 1'b1;
    end else begin
        out_ports_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        ap_ST_fsm_state2 : begin
            if (((icmp_ln887_fu_117_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        ap_ST_fsm_state4 : begin
            ap_NS_fsm = ap_ST_fsm_state1;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign add_ln209_11_fu_284_p2 = (n15_V_fu_246_p2 + factor_fu_277_p3);

assign add_ln209_14_fu_309_p2 = (n17_V_fu_261_p2 + inp_V_reg_382);

assign add_ln209_17_fu_326_p2 = (n9_V_fu_237_p2 + n5_V_reg_411);

assign add_ln209_4_fu_241_p2 = (n8_V_fu_233_p2 + n1_V_reg_393);

assign add_ln209_6_fu_251_p2 = (n9_V_fu_237_p2 + sv39_V_reg_387);

assign add_ln209_fu_201_p2 = (n3_V_fu_195_p2 + sv26_V_fu_153_p4);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign factor1_fu_296_p3 = {{tmp_2_reg_423}, {1'd0}};

assign factor_fu_277_p3 = {{tmp_1_reg_418}, {1'd0}};

assign i_V_fu_123_p2 = (p_0305_0_reg_106 + 3'd1);

assign icmp_ln887_fu_117_p2 = ((p_0305_0_reg_106 == 3'd4) ? 1'b1 : 1'b0);

assign inp_V_fu_129_p1 = in_ports_V_buf_0_reg_95[3:0];

assign n15_V_fu_246_p2 = (n3_V_reg_405 + add_ln209_4_fu_241_p2);

assign n16_V_fu_256_p2 = (n2_V_reg_399 + add_ln209_6_fu_251_p2);

assign n17_V_fu_261_p2 = (n1_V_reg_393 + n15_V_fu_246_p2);

assign n19_V_fu_266_p2 = (n9_V_fu_237_p2 + n16_V_fu_256_p2);

assign n1_V_fu_183_p2 = (inp_V_fu_129_p1 + sv2_V_fu_133_p4);

assign n20_V_fu_272_p2 = (sv39_V_reg_387 + n16_V_fu_256_p2);

assign n28_V_fu_290_p2 = (n8_V_fu_233_p2 + add_ln209_11_fu_284_p2);

assign n29_V_fu_303_p2 = (factor1_fu_296_p3 + n19_V_fu_266_p2);

assign n2_V_fu_189_p2 = (sv33_V_fu_163_p4 + sv39_V_fu_173_p4);

assign n3_V_fu_195_p2 = (sv13_V_fu_143_p4 + n1_V_fu_183_p2);

assign n5_V_fu_207_p2 = (n2_V_fu_189_p2 + add_ln209_fu_201_p2);

assign n8_V_fu_233_p2 = (n3_V_reg_405 + n5_V_reg_411);

assign n9_V_fu_237_p2 = (n2_V_reg_399 + n5_V_reg_411);

assign out_ports_V = in_ports_V_buf_0_reg_95;

assign ret_V_fu_349_p9 = {{{{{{{{sv39_o_V_fu_343_p2}, {n29_V_fu_303_p2}}, {sv33_o_V_fu_337_p2}}, {sv26_o_V_fu_331_p2}}, {n28_V_fu_290_p2}}, {sv13_o_V_fu_320_p2}}, {sv2_o_V_fu_314_p2}}, {n20_V_fu_272_p2}};

assign sv13_V_fu_143_p4 = {{in_ports_V_buf_0_reg_95[11:8]}};

assign sv13_o_V_fu_320_p2 = (n17_V_fu_261_p2 + n28_V_fu_290_p2);

assign sv26_V_fu_153_p4 = {{in_ports_V_buf_0_reg_95[19:16]}};

assign sv26_o_V_fu_331_p2 = (n8_V_fu_233_p2 + add_ln209_17_fu_326_p2);

assign sv2_V_fu_133_p4 = {{in_ports_V_buf_0_reg_95[7:4]}};

assign sv2_o_V_fu_314_p2 = (n15_V_fu_246_p2 + add_ln209_14_fu_309_p2);

assign sv33_V_fu_163_p4 = {{in_ports_V_buf_0_reg_95[23:20]}};

assign sv33_o_V_fu_337_p2 = (n19_V_fu_266_p2 + n29_V_fu_303_p2);

assign sv39_V_fu_173_p4 = {{in_ports_V_buf_0_reg_95[31:28]}};

assign sv39_o_V_fu_343_p2 = (n16_V_fu_256_p2 + n20_V_fu_272_p2);

endmodule //ellipf_seq