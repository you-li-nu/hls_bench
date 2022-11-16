// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="ellipf,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=7.920000,HLS_SYN_LAT=4,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=51,HLS_SYN_LUT=507,HLS_VERSION=2020_1}" *)

module ellipf (
        ap_clk,
        ap_rst,
        in_ports_V,
        out_ports_V,
        out_ports_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 5'd1;
parameter    ap_ST_fsm_state2 = 5'd2;
parameter    ap_ST_fsm_state3 = 5'd4;
parameter    ap_ST_fsm_state4 = 5'd8;
parameter    ap_ST_fsm_state5 = 5'd16;

input   ap_clk;
input   ap_rst;
input  [31:0] in_ports_V;
output  [31:0] out_ports_V;
output   out_ports_V_ap_vld;

reg out_ports_V_ap_vld;

wire   [3:0] grp_fu_88_p2;
reg   [3:0] reg_130;
(* fsm_encoding = "none" *) reg   [4:0] ap_CS_fsm;
wire    ap_CS_fsm_state3;
wire   [3:0] grp_fu_79_p2;
wire    ap_CS_fsm_state4;
wire   [3:0] grp_fu_90_p2;
reg   [3:0] reg_182;
wire   [3:0] grp_fu_87_p2;
wire   [3:0] grp_fu_85_p2;
reg   [3:0] n8_V_reg_265;
wire   [3:0] grp_fu_82_p2;
reg   [3:0] n5_V_reg_268;
wire   [3:0] grp_fu_80_p2;
reg   [3:0] n16_V_reg_481;
wire   [3:0] grp_fu_89_p2;
reg   [3:0] n15_V_reg_484;
wire   [3:0] inp_V_fu_744_p1;
reg   [3:0] inp_V_reg_858;
reg   [3:0] sv26_V_reg_863;
reg   [3:0] sv33_V_reg_868;
reg   [3:0] sv39_V_reg_873;
reg   [2:0] tmp_reg_880;
reg   [2:0] tmp_1_reg_885;
wire    ap_CS_fsm_state5;
reg   [3:0] grp_fu_79_p1;
reg   [3:0] grp_fu_80_p0;
wire   [3:0] grp_fu_81_p2;
wire   [3:0] grp_fu_86_p2;
reg   [3:0] grp_fu_81_p0;
reg   [3:0] grp_fu_81_p1;
reg   [3:0] grp_fu_82_p0;
wire   [3:0] factor1_fu_829_p3;
wire   [3:0] grp_fu_84_p2;
reg   [3:0] grp_fu_83_p0;
reg   [3:0] grp_fu_83_p1;
reg   [3:0] grp_fu_84_p1;
reg   [3:0] grp_fu_85_p0;
reg   [3:0] grp_fu_85_p1;
reg   [3:0] grp_fu_86_p0;
reg   [3:0] grp_fu_86_p1;
reg   [3:0] grp_fu_87_p0;
reg   [3:0] grp_fu_87_p1;
reg   [3:0] grp_fu_88_p0;
reg   [3:0] grp_fu_88_p1;
reg   [3:0] grp_fu_89_p0;
reg   [3:0] grp_fu_89_p1;
wire   [3:0] grp_fu_83_p2;
reg   [3:0] grp_fu_90_p0;
reg   [3:0] grp_fu_90_p1;
wire   [3:0] factor_fu_821_p3;
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
    if ((1'b1 == ap_CS_fsm_state4)) begin
        reg_130 <= grp_fu_79_p2;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        reg_130 <= grp_fu_88_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        reg_182 <= grp_fu_87_p2;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        reg_182 <= grp_fu_90_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        inp_V_reg_858 <= inp_V_fu_744_p1;
        sv26_V_reg_863 <= {{in_ports_V[19:16]}};
        sv33_V_reg_868 <= {{in_ports_V[23:20]}};
        sv39_V_reg_873 <= {{in_ports_V[31:28]}};
        tmp_1_reg_885 <= {{in_ports_V[26:24]}};
        tmp_reg_880 <= {{in_ports_V[14:12]}};
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        n15_V_reg_484 <= grp_fu_89_p2;
        n16_V_reg_481 <= grp_fu_80_p2;
        n5_V_reg_268 <= grp_fu_82_p2;
        n8_V_reg_265 <= grp_fu_85_p2;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_79_p1 = inp_V_reg_858;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_79_p1 = grp_fu_89_p2;
    end else begin
        grp_fu_79_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_80_p0 = n16_V_reg_481;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_80_p0 = grp_fu_81_p2;
    end else begin
        grp_fu_80_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_81_p0 = reg_182;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_81_p0 = sv33_V_reg_868;
    end else begin
        grp_fu_81_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_81_p1 = n5_V_reg_268;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_81_p1 = sv39_V_reg_873;
    end else begin
        grp_fu_81_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_82_p0 = factor1_fu_829_p3;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_82_p0 = grp_fu_81_p2;
    end else begin
        grp_fu_82_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_83_p0 = reg_130;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_83_p0 = grp_fu_85_p2;
    end else begin
        grp_fu_83_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_83_p1 = grp_fu_85_p2;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_83_p1 = reg_130;
    end else begin
        grp_fu_83_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_84_p1 = n16_V_reg_481;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_84_p1 = sv26_V_reg_863;
    end else begin
        grp_fu_84_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_85_p0 = n8_V_reg_265;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_85_p0 = reg_182;
    end else begin
        grp_fu_85_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_85_p1 = grp_fu_90_p2;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_85_p1 = grp_fu_82_p2;
    end else begin
        grp_fu_85_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_86_p0 = sv39_V_reg_873;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_86_p0 = grp_fu_87_p2;
    end else begin
        grp_fu_86_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_86_p1 = n16_V_reg_481;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_86_p1 = sv39_V_reg_873;
    end else begin
        grp_fu_86_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_87_p0 = n15_V_reg_484;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_87_p0 = grp_fu_81_p2;
    end else begin
        grp_fu_87_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_87_p1 = grp_fu_79_p2;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_87_p1 = grp_fu_82_p2;
    end else begin
        grp_fu_87_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_88_p0 = n8_V_reg_265;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        grp_fu_88_p0 = inp_V_fu_744_p1;
    end else begin
        grp_fu_88_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_88_p1 = grp_fu_81_p2;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        grp_fu_88_p1 = {{in_ports_V[7:4]}};
    end else begin
        grp_fu_88_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_89_p0 = grp_fu_84_p2;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_89_p0 = reg_182;
    end else begin
        grp_fu_89_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_89_p1 = grp_fu_82_p2;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        grp_fu_89_p1 = grp_fu_83_p2;
    end else begin
        grp_fu_89_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_90_p0 = n15_V_reg_484;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        grp_fu_90_p0 = {{in_ports_V[11:8]}};
    end else begin
        grp_fu_90_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        grp_fu_90_p1 = factor_fu_821_p3;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        grp_fu_90_p1 = grp_fu_88_p2;
    end else begin
        grp_fu_90_p1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
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
            ap_NS_fsm = ap_ST_fsm_state3;
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_state4;
        end
        ap_ST_fsm_state4 : begin
            ap_NS_fsm = ap_ST_fsm_state5;
        end
        ap_ST_fsm_state5 : begin
            ap_NS_fsm = ap_ST_fsm_state1;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

assign factor1_fu_829_p3 = {{tmp_1_reg_885}, {1'd0}};

assign factor_fu_821_p3 = {{tmp_reg_880}, {1'd0}};

assign grp_fu_79_p2 = (reg_130 + grp_fu_79_p1);

assign grp_fu_80_p2 = (grp_fu_80_p0 + grp_fu_86_p2);

assign grp_fu_81_p2 = (grp_fu_81_p0 + grp_fu_81_p1);

assign grp_fu_82_p2 = (grp_fu_82_p0 + grp_fu_84_p2);

assign grp_fu_83_p2 = (grp_fu_83_p0 + grp_fu_83_p1);

assign grp_fu_84_p2 = (reg_182 + grp_fu_84_p1);

assign grp_fu_85_p2 = (grp_fu_85_p0 + grp_fu_85_p1);

assign grp_fu_86_p2 = (grp_fu_86_p0 + grp_fu_86_p1);

assign grp_fu_87_p2 = (grp_fu_87_p0 + grp_fu_87_p1);

assign grp_fu_88_p2 = (grp_fu_88_p0 + grp_fu_88_p1);

assign grp_fu_89_p2 = (grp_fu_89_p0 + grp_fu_89_p1);

assign grp_fu_90_p2 = (grp_fu_90_p0 + grp_fu_90_p1);

assign inp_V_fu_744_p1 = in_ports_V[3:0];

assign out_ports_V = {{{{{{{{grp_fu_80_p2}, {grp_fu_82_p2}}, {grp_fu_89_p2}}, {grp_fu_88_p2}}, {grp_fu_85_p2}}, {grp_fu_83_p2}}, {grp_fu_87_p2}}, {grp_fu_86_p2}};

endmodule //ellipf