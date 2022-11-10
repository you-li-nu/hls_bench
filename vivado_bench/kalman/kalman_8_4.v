// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="kalman,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=8.561000,HLS_SYN_LAT=18,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=57,HLS_SYN_LUT=405,HLS_VERSION=2020_1}" *)

module kalman (
        ap_clk,
        ap_rst,
        nonce_input_V,
        in_port_V,
        out_port_V,
        out_port_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 5'd1;
parameter    ap_ST_fsm_state2 = 5'd2;
parameter    ap_ST_fsm_state3 = 5'd4;
parameter    ap_ST_fsm_state4 = 5'd8;
parameter    ap_ST_fsm_state5 = 5'd16;

input   ap_clk;
input   ap_rst;
input  [5:0] nonce_input_V;
input  [15:0] in_port_V;
output  [7:0] out_port_V;
output   out_port_V_ap_vld;

reg out_port_V_ap_vld;

(* fsm_encoding = "none" *) reg   [4:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire  signed [3:0] trunc_ln1503_fu_167_p1;
reg  signed [3:0] trunc_ln1503_reg_578;
reg  signed [3:0] trunc_ln1503_1_reg_583;
wire   [1:0] i_V_fu_197_p2;
reg   [1:0] i_V_reg_591;
wire    ap_CS_fsm_state2;
wire   [0:0] trunc_ln700_fu_203_p1;
reg   [0:0] trunc_ln700_reg_596;
wire   [0:0] icmp_ln37_fu_191_p2;
wire   [3:0] mul_ln214_fu_221_p2;
reg   [3:0] mul_ln214_reg_603;
wire   [3:0] mul_ln214_1_fu_236_p2;
reg   [3:0] mul_ln214_1_reg_608;
reg  signed [3:0] trunc_ln1503_2_reg_627;
wire   [1:0] j_V_fu_266_p2;
wire    ap_CS_fsm_state3;
wire   [1:0] i_V_1_fu_421_p2;
reg   [1:0] i_V_1_reg_643;
wire    ap_CS_fsm_state4;
wire   [0:0] trunc_ln700_1_fu_427_p1;
reg   [0:0] trunc_ln700_1_reg_648;
wire   [0:0] icmp_ln48_fu_415_p2;
wire   [3:0] zext_ln214_1_fu_431_p1;
reg   [3:0] zext_ln214_1_reg_655;
wire   [1:0] j_V_1_fu_450_p2;
wire    ap_CS_fsm_state5;
reg   [1:0] p_05_reg_111;
wire   [0:0] icmp_ln39_fu_260_p2;
reg   [1:0] p_04_reg_122;
reg   [1:0] p_01_reg_133;
wire   [0:0] icmp_ln50_fu_444_p2;
reg   [1:0] p_0_reg_144;
reg   [3:0] x_next_1_V_fu_76;
wire   [3:0] x_next_1_V_6_fu_398_p3;
reg   [3:0] x_next_1_V_3_fu_80;
wire   [3:0] x_next_1_V_5_fu_391_p3;
reg   [3:0] v_1_V_fu_84;
wire   [3:0] v_1_V_6_fu_534_p3;
reg   [3:0] v_1_V_3_fu_88;
wire   [3:0] v_1_V_5_fu_527_p3;
wire   [2:0] zext_ln214_fu_207_p1;
wire   [2:0] add_ln214_fu_211_p2;
wire   [2:0] mul_ln214_fu_221_p1;
wire   [2:0] add_ln214_1_fu_226_p2;
wire   [2:0] mul_ln214_1_fu_236_p1;
wire   [0:0] trunc_ln214_fu_276_p1;
wire   [3:0] shl_ln_fu_280_p3;
wire   [3:0] zext_ln214_2_fu_272_p1;
wire   [3:0] sub_ln214_fu_288_p2;
wire   [1:0] shl_ln214_fu_299_p2;
wire   [3:0] zext_ln214_5_fu_305_p1;
wire   [3:0] tmp_2_fu_314_p4;
wire   [3:0] tmp_3_fu_323_p4;
wire  signed [3:0] select_ln215_fu_332_p3;
wire  signed [3:0] a_V_fu_294_p2;
wire   [3:0] tmp_4_fu_346_p4;
wire   [3:0] trunc_ln215_fu_355_p1;
wire  signed [3:0] select_ln215_1_fu_358_p3;
wire  signed [3:0] k_V_fu_309_p2;
wire   [3:0] mul_ln700_fu_340_p2;
wire   [3:0] select_ln700_fu_372_p3;
wire   [3:0] add_ln700_fu_379_p2;
wire   [3:0] mul_ln700_1_fu_366_p2;
wire   [3:0] x_next_0_V_fu_385_p2;
wire   [0:0] trunc_ln214_1_fu_456_p1;
wire   [1:0] shl_ln214_1_fu_468_p2;
wire   [3:0] shl_ln214_2_fu_460_p3;
wire   [3:0] zext_ln214_6_fu_474_p1;
wire   [3:0] sub_ln214_2_fu_478_p2;
wire  signed [3:0] or_ln214_fu_484_p2;
wire   [3:0] mul_ln214_2_fu_490_p2;
wire  signed [3:0] g_V_fu_495_p2;
wire  signed [3:0] select_ln215_2_fu_500_p3;
wire   [3:0] mul_ln700_2_fu_508_p2;
wire   [3:0] select_ln700_3_fu_514_p3;
wire   [3:0] v_0_V_fu_521_p2;
reg   [4:0] ap_NS_fsm;
wire   [3:0] mul_ln214_1_fu_236_p10;
wire   [3:0] mul_ln214_fu_221_p10;

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
    if (((icmp_ln50_fu_444_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state5))) begin
        p_01_reg_133 <= i_V_1_reg_643;
    end else if (((icmp_ln37_fu_191_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        p_01_reg_133 <= 2'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln39_fu_260_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        p_04_reg_122 <= j_V_fu_266_p2;
    end else if (((icmp_ln37_fu_191_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        p_04_reg_122 <= 2'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln39_fu_260_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        p_05_reg_111 <= i_V_reg_591;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_05_reg_111 <= 2'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln50_fu_444_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state5))) begin
        p_0_reg_144 <= j_V_1_fu_450_p2;
    end else if (((icmp_ln48_fu_415_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        p_0_reg_144 <= 2'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln50_fu_444_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state5))) begin
        v_1_V_3_fu_88 <= v_1_V_5_fu_527_p3;
    end else if (((icmp_ln37_fu_191_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        v_1_V_3_fu_88 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln50_fu_444_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state5))) begin
        v_1_V_fu_84 <= v_1_V_6_fu_534_p3;
    end else if (((icmp_ln37_fu_191_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        v_1_V_fu_84 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln39_fu_260_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        x_next_1_V_3_fu_80 <= x_next_1_V_5_fu_391_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        x_next_1_V_3_fu_80 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln39_fu_260_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        x_next_1_V_fu_76 <= x_next_1_V_6_fu_398_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        x_next_1_V_fu_76 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        i_V_1_reg_643 <= i_V_1_fu_421_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        i_V_reg_591 <= i_V_fu_197_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln37_fu_191_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        mul_ln214_1_reg_608 <= mul_ln214_1_fu_236_p2;
        mul_ln214_reg_603 <= mul_ln214_fu_221_p2;
        trunc_ln700_reg_596 <= trunc_ln700_fu_203_p1;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state1)) begin
        trunc_ln1503_1_reg_583 <= {{nonce_input_V[4:1]}};
        trunc_ln1503_reg_578 <= trunc_ln1503_fu_167_p1;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln37_fu_191_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        trunc_ln1503_2_reg_627 <= {{nonce_input_V[5:2]}};
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln48_fu_415_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        trunc_ln700_1_reg_648 <= trunc_ln700_1_fu_427_p1;
        zext_ln214_1_reg_655[1 : 0] <= zext_ln214_1_fu_431_p1[1 : 0];
    end
end

always @ (*) begin
    if (((icmp_ln48_fu_415_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state4))) begin
        out_port_V_ap_vld = 1'b1;
    end else begin
        out_port_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        ap_ST_fsm_state2 : begin
            if (((icmp_ln37_fu_191_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        ap_ST_fsm_state3 : begin
            if (((icmp_ln39_fu_260_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        ap_ST_fsm_state4 : begin
            if (((icmp_ln48_fu_415_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state4))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end
        end
        ap_ST_fsm_state5 : begin
            if (((icmp_ln50_fu_444_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state5))) begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign a_V_fu_294_p2 = (mul_ln214_reg_603 + sub_ln214_fu_288_p2);

assign add_ln214_1_fu_226_p2 = (3'd3 + zext_ln214_fu_207_p1);

assign add_ln214_fu_211_p2 = ($signed(3'd5) + $signed(zext_ln214_fu_207_p1));

assign add_ln700_fu_379_p2 = (mul_ln700_fu_340_p2 + select_ln700_fu_372_p3);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

assign g_V_fu_495_p2 = (mul_ln214_2_fu_490_p2 - zext_ln214_1_reg_655);

assign i_V_1_fu_421_p2 = (p_01_reg_133 + 2'd1);

assign i_V_fu_197_p2 = (p_05_reg_111 + 2'd1);

assign icmp_ln37_fu_191_p2 = ((p_05_reg_111 == 2'd2) ? 1'b1 : 1'b0);

assign icmp_ln39_fu_260_p2 = ((p_04_reg_122 == 2'd2) ? 1'b1 : 1'b0);

assign icmp_ln48_fu_415_p2 = ((p_01_reg_133 == 2'd2) ? 1'b1 : 1'b0);

assign icmp_ln50_fu_444_p2 = ((p_0_reg_144 == 2'd2) ? 1'b1 : 1'b0);

assign j_V_1_fu_450_p2 = (p_0_reg_144 + 2'd1);

assign j_V_fu_266_p2 = (p_04_reg_122 + 2'd1);

assign k_V_fu_309_p2 = (mul_ln214_1_reg_608 - zext_ln214_5_fu_305_p1);

assign mul_ln214_1_fu_236_p1 = mul_ln214_1_fu_236_p10;

assign mul_ln214_1_fu_236_p10 = add_ln214_1_fu_226_p2;

assign mul_ln214_1_fu_236_p2 = ($signed(trunc_ln1503_1_reg_583) * $signed({{1'b0}, {mul_ln214_1_fu_236_p1}}));

assign mul_ln214_2_fu_490_p2 = ($signed(or_ln214_fu_484_p2) * $signed(trunc_ln1503_2_reg_627));

assign mul_ln214_fu_221_p1 = mul_ln214_fu_221_p10;

assign mul_ln214_fu_221_p10 = add_ln214_fu_211_p2;

assign mul_ln214_fu_221_p2 = ($signed(trunc_ln1503_reg_578) * $signed({{1'b0}, {mul_ln214_fu_221_p1}}));

assign mul_ln700_1_fu_366_p2 = ($signed(select_ln215_1_fu_358_p3) * $signed(k_V_fu_309_p2));

assign mul_ln700_2_fu_508_p2 = ($signed(g_V_fu_495_p2) * $signed(select_ln215_2_fu_500_p3));

assign mul_ln700_fu_340_p2 = ($signed(select_ln215_fu_332_p3) * $signed(a_V_fu_294_p2));

assign or_ln214_fu_484_p2 = (sub_ln214_2_fu_478_p2 | 4'd1);

assign out_port_V = {{v_1_V_fu_84}, {v_1_V_3_fu_88}};

assign select_ln215_1_fu_358_p3 = ((trunc_ln214_fu_276_p1[0:0] === 1'b1) ? tmp_4_fu_346_p4 : trunc_ln215_fu_355_p1);

assign select_ln215_2_fu_500_p3 = ((trunc_ln214_1_fu_456_p1[0:0] === 1'b1) ? x_next_1_V_fu_76 : x_next_1_V_3_fu_80);

assign select_ln215_fu_332_p3 = ((trunc_ln214_fu_276_p1[0:0] === 1'b1) ? tmp_2_fu_314_p4 : tmp_3_fu_323_p4);

assign select_ln700_3_fu_514_p3 = ((trunc_ln700_1_reg_648[0:0] === 1'b1) ? v_1_V_fu_84 : v_1_V_3_fu_88);

assign select_ln700_fu_372_p3 = ((trunc_ln700_reg_596[0:0] === 1'b1) ? x_next_1_V_fu_76 : x_next_1_V_3_fu_80);

assign shl_ln214_1_fu_468_p2 = p_0_reg_144 << 2'd1;

assign shl_ln214_2_fu_460_p3 = {{trunc_ln214_1_fu_456_p1}, {3'd0}};

assign shl_ln214_fu_299_p2 = p_04_reg_122 << 2'd1;

assign shl_ln_fu_280_p3 = {{trunc_ln214_fu_276_p1}, {3'd0}};

assign sub_ln214_2_fu_478_p2 = (shl_ln214_2_fu_460_p3 - zext_ln214_6_fu_474_p1);

assign sub_ln214_fu_288_p2 = (shl_ln_fu_280_p3 - zext_ln214_2_fu_272_p1);

assign tmp_2_fu_314_p4 = {{in_port_V[15:12]}};

assign tmp_3_fu_323_p4 = {{in_port_V[11:8]}};

assign tmp_4_fu_346_p4 = {{in_port_V[7:4]}};

assign trunc_ln1503_fu_167_p1 = nonce_input_V[3:0];

assign trunc_ln214_1_fu_456_p1 = p_0_reg_144[0:0];

assign trunc_ln214_fu_276_p1 = p_04_reg_122[0:0];

assign trunc_ln215_fu_355_p1 = in_port_V[3:0];

assign trunc_ln700_1_fu_427_p1 = p_01_reg_133[0:0];

assign trunc_ln700_fu_203_p1 = p_05_reg_111[0:0];

assign v_0_V_fu_521_p2 = (mul_ln700_2_fu_508_p2 + select_ln700_3_fu_514_p3);

assign v_1_V_5_fu_527_p3 = ((trunc_ln700_1_reg_648[0:0] === 1'b1) ? v_1_V_3_fu_88 : v_0_V_fu_521_p2);

assign v_1_V_6_fu_534_p3 = ((trunc_ln700_1_reg_648[0:0] === 1'b1) ? v_0_V_fu_521_p2 : v_1_V_fu_84);

assign x_next_0_V_fu_385_p2 = (add_ln700_fu_379_p2 + mul_ln700_1_fu_366_p2);

assign x_next_1_V_5_fu_391_p3 = ((trunc_ln700_reg_596[0:0] === 1'b1) ? x_next_1_V_3_fu_80 : x_next_0_V_fu_385_p2);

assign x_next_1_V_6_fu_398_p3 = ((trunc_ln700_reg_596[0:0] === 1'b1) ? x_next_0_V_fu_385_p2 : x_next_1_V_fu_76);

assign zext_ln214_1_fu_431_p1 = p_01_reg_133;

assign zext_ln214_2_fu_272_p1 = p_04_reg_122;

assign zext_ln214_5_fu_305_p1 = shl_ln214_fu_299_p2;

assign zext_ln214_6_fu_474_p1 = shl_ln214_1_fu_468_p2;

assign zext_ln214_fu_207_p1 = p_05_reg_111;

always @ (posedge ap_clk) begin
    zext_ln214_1_reg_655[3:2] <= 2'b00;
end

endmodule //kalman
