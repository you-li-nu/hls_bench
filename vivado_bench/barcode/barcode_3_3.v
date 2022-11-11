// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="barcode,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=3.087500,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=50,HLS_SYN_LUT=435,HLS_VERSION=2020_1}" *)

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

parameter    ap_ST_fsm_state1 = 5'd1;
parameter    ap_ST_fsm_state2 = 5'd2;
parameter    ap_ST_fsm_state3 = 5'd4;
parameter    ap_ST_fsm_state4 = 5'd8;
parameter    ap_ST_fsm_state5 = 5'd16;

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
reg[3:0] data_V;
reg[2:0] addr_V;

(* fsm_encoding = "none" *) reg   [4:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [0:0] icmp_ln883_fu_242_p2;
reg   [0:0] icmp_ln883_reg_421;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln887_fu_257_p2;
reg   [0:0] icmp_ln887_reg_425;
wire   [5:0] add_ln214_fu_275_p2;
reg   [5:0] add_ln214_reg_430;
wire   [0:0] xor_ln53_fu_281_p2;
wire   [2:0] add_ln700_fu_287_p2;
wire   [0:0] icmp_ln883_1_fu_300_p2;
reg   [0:0] icmp_ln883_1_reg_446;
wire    ap_CS_fsm_state3;
wire   [0:0] icmp_ln887_1_fu_314_p2;
reg   [0:0] icmp_ln887_1_reg_450;
wire   [5:0] add_ln214_1_fu_330_p2;
reg   [5:0] add_ln214_1_reg_455;
wire   [0:0] xor_ln53_1_fu_336_p2;
wire   [0:0] icmp_ln883_2_fu_355_p2;
reg   [0:0] icmp_ln883_2_reg_466;
wire   [0:0] icmp_ln887_2_fu_369_p2;
wire    ap_CS_fsm_state4;
wire   [5:0] add_ln214_2_fu_385_p2;
wire   [3:0] add_ln700_4_fu_403_p2;
reg   [5:0] seed_V_read_assign_reg_126;
reg   [2:0] p_024_0_0_reg_135;
reg   [2:0] ap_phi_mux_p_024_1_2_phi_fu_223_p4;
reg   [3:0] p_027_0_0_reg_148;
reg   [0:0] flag_0_0_reg_161;
reg   [2:0] p_024_1_0_reg_172;
reg   [3:0] p_027_1_0_reg_183;
wire   [2:0] add_ln700_2_fu_348_p2;
reg   [2:0] ap_phi_mux_p_024_1_1_phi_fu_199_p4;
reg   [2:0] p_024_1_1_reg_195;
reg   [3:0] phi_ln700_reg_207;
wire   [3:0] phitmp_fu_341_p2;
wire   [2:0] add_ln700_3_fu_396_p2;
wire   [0:0] xor_ln53_2_fu_391_p2;
reg   [3:0] ap_phi_mux_p_027_1_2_phi_fu_234_p4;
wire   [3:0] add_ln700_1_fu_293_p2;
wire   [4:0] tmp_1_fu_247_p4;
wire   [5:0] shl_ln214_fu_263_p2;
wire   [5:0] sub_ln214_fu_269_p2;
wire   [4:0] tmp_2_fu_305_p4;
wire   [5:0] shl_ln214_1_fu_320_p2;
wire   [5:0] sub_ln214_1_fu_325_p2;
wire   [4:0] tmp_3_fu_360_p4;
wire   [5:0] shl_ln214_2_fu_375_p2;
wire   [5:0] sub_ln214_2_fu_380_p2;
reg   [4:0] ap_NS_fsm;
reg    ap_condition_65;
reg    ap_condition_83;

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
    if (((icmp_ln883_2_reg_466 == 1'd0) & (icmp_ln883_1_reg_446 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        flag_0_0_reg_161 <= icmp_ln887_2_fu_369_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        flag_0_0_reg_161 <= 1'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_2_reg_466 == 1'd0) & (icmp_ln883_1_reg_446 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        p_024_0_0_reg_135 <= ap_phi_mux_p_024_1_2_phi_fu_223_p4;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_024_0_0_reg_135 <= 3'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_242_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        if ((xor_ln53_fu_281_p2 == 1'd0)) begin
            p_024_1_0_reg_172 <= p_024_0_0_reg_135;
        end else if ((xor_ln53_fu_281_p2 == 1'd1)) begin
            p_024_1_0_reg_172 <= add_ln700_fu_287_p2;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_condition_65)) begin
        if ((xor_ln53_1_fu_336_p2 == 1'd0)) begin
            p_024_1_1_reg_195 <= p_024_1_0_reg_172;
        end else if ((xor_ln53_1_fu_336_p2 == 1'd1)) begin
            p_024_1_1_reg_195 <= add_ln700_2_fu_348_p2;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_2_reg_466 == 1'd0) & (icmp_ln883_1_reg_446 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        p_027_0_0_reg_148 <= add_ln700_4_fu_403_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_027_0_0_reg_148 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_242_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        if ((xor_ln53_fu_281_p2 == 1'd0)) begin
            p_027_1_0_reg_183 <= p_027_0_0_reg_148;
        end else if ((xor_ln53_fu_281_p2 == 1'd1)) begin
            p_027_1_0_reg_183 <= 4'd0;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_condition_65)) begin
        if ((xor_ln53_1_fu_336_p2 == 1'd0)) begin
            phi_ln700_reg_207 <= phitmp_fu_341_p2;
        end else if ((xor_ln53_1_fu_336_p2 == 1'd1)) begin
            phi_ln700_reg_207 <= 4'd1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_2_reg_466 == 1'd0) & (icmp_ln883_1_reg_446 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        seed_V_read_assign_reg_126 <= add_ln214_2_fu_385_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        seed_V_read_assign_reg_126 <= seed_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_1_fu_300_p2 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        add_ln214_1_reg_455 <= add_ln214_1_fu_330_p2;
        icmp_ln883_2_reg_466 <= icmp_ln883_2_fu_355_p2;
        icmp_ln887_1_reg_450 <= icmp_ln887_1_fu_314_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_242_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        add_ln214_reg_430 <= add_ln214_fu_275_p2;
        icmp_ln887_reg_425 <= icmp_ln887_fu_257_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        icmp_ln883_1_reg_446 <= icmp_ln883_1_fu_300_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        icmp_ln883_reg_421 <= icmp_ln883_fu_242_p2;
    end
end

always @ (*) begin
    if (((xor_ln53_2_fu_391_p2 == 1'd1) & (icmp_ln883_2_reg_466 == 1'd0) & (icmp_ln883_1_reg_446 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        addr_V = p_024_1_1_reg_195;
    end else if (((xor_ln53_1_fu_336_p2 == 1'd1) & (icmp_ln883_1_fu_300_p2 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        addr_V = p_024_1_0_reg_172;
    end else if (((xor_ln53_fu_281_p2 == 1'd1) & (icmp_ln883_fu_242_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        addr_V = p_024_0_0_reg_135;
    end else begin
        addr_V = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_condition_65)) begin
        if ((xor_ln53_1_fu_336_p2 == 1'd0)) begin
            ap_phi_mux_p_024_1_1_phi_fu_199_p4 = p_024_1_0_reg_172;
        end else if ((xor_ln53_1_fu_336_p2 == 1'd1)) begin
            ap_phi_mux_p_024_1_1_phi_fu_199_p4 = add_ln700_2_fu_348_p2;
        end else begin
            ap_phi_mux_p_024_1_1_phi_fu_199_p4 = 'bx;
        end
    end else begin
        ap_phi_mux_p_024_1_1_phi_fu_199_p4 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_condition_83)) begin
        if ((xor_ln53_2_fu_391_p2 == 1'd0)) begin
            ap_phi_mux_p_024_1_2_phi_fu_223_p4 = p_024_1_1_reg_195;
        end else if ((xor_ln53_2_fu_391_p2 == 1'd1)) begin
            ap_phi_mux_p_024_1_2_phi_fu_223_p4 = add_ln700_3_fu_396_p2;
        end else begin
            ap_phi_mux_p_024_1_2_phi_fu_223_p4 = 'bx;
        end
    end else begin
        ap_phi_mux_p_024_1_2_phi_fu_223_p4 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_condition_83)) begin
        if ((xor_ln53_2_fu_391_p2 == 1'd0)) begin
            ap_phi_mux_p_027_1_2_phi_fu_234_p4 = phi_ln700_reg_207;
        end else if ((xor_ln53_2_fu_391_p2 == 1'd1)) begin
            ap_phi_mux_p_027_1_2_phi_fu_234_p4 = 4'd0;
        end else begin
            ap_phi_mux_p_027_1_2_phi_fu_234_p4 = 'bx;
        end
    end else begin
        ap_phi_mux_p_027_1_2_phi_fu_234_p4 = 'bx;
    end
end

always @ (*) begin
    if (((xor_ln53_2_fu_391_p2 == 1'd1) & (icmp_ln883_2_reg_466 == 1'd0) & (icmp_ln883_1_reg_446 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        data_V = phi_ln700_reg_207;
    end else if (((xor_ln53_1_fu_336_p2 == 1'd1) & (icmp_ln883_1_fu_300_p2 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        data_V = add_ln700_1_fu_293_p2;
    end else if (((xor_ln53_fu_281_p2 == 1'd1) & (icmp_ln883_fu_242_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        data_V = p_027_0_0_reg_148;
    end else begin
        data_V = 'bx;
    end
end

always @ (*) begin
    if ((((xor_ln53_2_fu_391_p2 == 1'd1) & (icmp_ln883_2_reg_466 == 1'd0) & (icmp_ln883_1_reg_446 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state4)) | ((xor_ln53_1_fu_336_p2 == 1'd1) & (icmp_ln883_1_fu_300_p2 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state3)) | ((xor_ln53_fu_281_p2 == 1'd1) & (icmp_ln883_fu_242_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2)))) begin
        memw = 1'd1;
    end else if ((((icmp_ln883_2_reg_466 == 1'd0) & (icmp_ln883_1_reg_446 == 1'd0) & (xor_ln53_2_fu_391_p2 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state4)) | ((xor_ln53_1_fu_336_p2 == 1'd0) & (icmp_ln883_1_fu_300_p2 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state3)) | ((xor_ln53_fu_281_p2 == 1'd0) & (icmp_ln883_fu_242_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2)))) begin
        memw = 1'd0;
    end else begin
        memw = 'bx;
    end
end

always @ (*) begin
    if ((((xor_ln53_2_fu_391_p2 == 1'd1) & (icmp_ln883_2_reg_466 == 1'd0) & (icmp_ln883_1_reg_446 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state4)) | ((xor_ln53_1_fu_336_p2 == 1'd1) & (icmp_ln883_1_fu_300_p2 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state3)) | ((xor_ln53_fu_281_p2 == 1'd1) & (icmp_ln883_fu_242_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2)))) begin
        vld = 1'd1;
    end else if (((1'b1 == ap_CS_fsm_state1) | ((icmp_ln883_2_reg_466 == 1'd0) & (icmp_ln883_1_reg_446 == 1'd0) & (xor_ln53_2_fu_391_p2 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state4)) | ((xor_ln53_1_fu_336_p2 == 1'd0) & (icmp_ln883_1_fu_300_p2 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state3)) | ((xor_ln53_fu_281_p2 == 1'd0) & (icmp_ln883_fu_242_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2)))) begin
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
            ap_NS_fsm = ap_ST_fsm_state3;
        end
        ap_ST_fsm_state3 : begin
            if (((icmp_ln883_2_fu_355_p2 == 1'd0) & (icmp_ln883_1_fu_300_p2 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
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

assign add_ln214_1_fu_330_p2 = (6'd1 + sub_ln214_1_fu_325_p2);

assign add_ln214_2_fu_385_p2 = (6'd1 + sub_ln214_2_fu_380_p2);

assign add_ln214_fu_275_p2 = (6'd1 + sub_ln214_fu_269_p2);

assign add_ln700_1_fu_293_p2 = (p_027_1_0_reg_183 + 4'd1);

assign add_ln700_2_fu_348_p2 = (p_024_1_0_reg_172 + 3'd1);

assign add_ln700_3_fu_396_p2 = (p_024_1_1_reg_195 + 3'd1);

assign add_ln700_4_fu_403_p2 = (ap_phi_mux_p_027_1_2_phi_fu_234_p4 + 4'd1);

assign add_ln700_fu_287_p2 = (p_024_0_0_reg_135 + 3'd1);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

always @ (*) begin
    ap_condition_65 = ((icmp_ln883_1_fu_300_p2 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state3));
end

always @ (*) begin
    ap_condition_83 = ((icmp_ln883_2_reg_466 == 1'd0) & (icmp_ln883_1_reg_446 == 1'd0) & (icmp_ln883_reg_421 == 1'd0) & (1'b1 == ap_CS_fsm_state4));
end

assign eoc = 1'd0;

assign icmp_ln883_1_fu_300_p2 = ((p_024_1_0_reg_172 == num_V) ? 1'b1 : 1'b0);

assign icmp_ln883_2_fu_355_p2 = ((ap_phi_mux_p_024_1_1_phi_fu_199_p4 == num_V) ? 1'b1 : 1'b0);

assign icmp_ln883_fu_242_p2 = ((p_024_0_0_reg_135 == num_V) ? 1'b1 : 1'b0);

assign icmp_ln887_1_fu_314_p2 = ((tmp_2_fu_305_p4 == 5'd0) ? 1'b1 : 1'b0);

assign icmp_ln887_2_fu_369_p2 = ((tmp_3_fu_360_p4 == 5'd0) ? 1'b1 : 1'b0);

assign icmp_ln887_fu_257_p2 = ((tmp_1_fu_247_p4 == 5'd0) ? 1'b1 : 1'b0);

assign phitmp_fu_341_p2 = (p_027_1_0_reg_183 + 4'd2);

assign shl_ln214_1_fu_320_p2 = add_ln214_reg_430 << 6'd3;

assign shl_ln214_2_fu_375_p2 = add_ln214_1_reg_455 << 6'd3;

assign shl_ln214_fu_263_p2 = seed_V_read_assign_reg_126 << 6'd3;

assign sub_ln214_1_fu_325_p2 = (shl_ln214_1_fu_320_p2 - add_ln214_reg_430);

assign sub_ln214_2_fu_380_p2 = (shl_ln214_2_fu_375_p2 - add_ln214_1_reg_455);

assign sub_ln214_fu_269_p2 = (shl_ln214_fu_263_p2 - seed_V_read_assign_reg_126);

assign tmp_1_fu_247_p4 = {{seed_V_read_assign_reg_126[5:1]}};

assign tmp_2_fu_305_p4 = {{add_ln214_reg_430[5:1]}};

assign tmp_3_fu_360_p4 = {{add_ln214_1_reg_455[5:1]}};

assign xor_ln53_1_fu_336_p2 = (icmp_ln887_reg_425 ^ icmp_ln887_1_fu_314_p2);

assign xor_ln53_2_fu_391_p2 = (icmp_ln887_2_fu_369_p2 ^ icmp_ln887_1_reg_450);

assign xor_ln53_fu_281_p2 = (icmp_ln887_fu_257_p2 ^ flag_0_0_reg_161);

endmodule //barcode
