// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="counter,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=7.684000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=50,HLS_SYN_LUT=444,HLS_VERSION=2020_1}" *)

module counter (
        ap_clk,
        ap_rst,
        seed_V,
        out_V,
        out_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 4'd1;
parameter    ap_ST_fsm_state2 = 4'd2;
parameter    ap_ST_fsm_state3 = 4'd4;
parameter    ap_ST_fsm_state4 = 4'd8;

input   ap_clk;
input   ap_rst;
input  [5:0] seed_V;
output  [3:0] out_V;
output   out_V_ap_vld;

reg out_V_ap_vld;

(* fsm_encoding = "none" *) reg   [3:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
wire   [3:0] data_V_fu_131_p1;
wire   [0:0] icmp_ln883_fu_145_p2;
reg   [0:0] icmp_ln883_reg_468;
wire    ap_CS_fsm_state2;
wire   [3:0] trunc_ln320_fu_151_p1;
reg   [3:0] trunc_ln320_reg_472;
wire   [3:0] select_ln879_1_fu_235_p3;
wire   [0:0] icmp_ln883_3_fu_265_p2;
reg   [0:0] icmp_ln883_3_reg_482;
wire   [3:0] select_ln879_4_fu_345_p3;
reg   [3:0] select_ln879_4_reg_486;
wire   [5:0] add_ln214_1_fu_369_p2;
reg   [5:0] add_ln214_1_reg_496;
wire   [0:0] icmp_ln883_2_fu_375_p2;
reg   [0:0] icmp_ln883_2_reg_501;
wire   [0:0] icmp_ln879_2_fu_381_p2;
reg   [0:0] icmp_ln879_2_reg_505;
wire   [0:0] icmp_ln879_5_fu_387_p2;
reg   [0:0] icmp_ln879_5_reg_511;
wire   [0:0] icmp_ln883_5_fu_393_p2;
reg   [0:0] icmp_ln883_5_reg_516;
wire   [3:0] select_ln879_5_fu_399_p3;
reg   [3:0] select_ln879_5_reg_522;
wire   [3:0] select_ln879_7_fu_447_p3;
wire    ap_CS_fsm_state3;
wire   [3:0] add_ln1503_2_fu_453_p2;
reg   [3:0] data_V_0_0_reg_77;
reg   [5:0] ctrl_V_0_0_in_in_reg_86;
reg   [3:0] data_V_1_reg_95;
reg   [3:0] p_053_0_0_reg_106;
reg   [3:0] p_053_0_lcssa_reg_118;
wire    ap_CS_fsm_state4;
wire   [1:0] ctrl_V_fu_135_p4;
wire   [0:0] icmp_ln883_1_fu_173_p2;
wire   [3:0] add_ln700_fu_179_p2;
wire   [3:0] add_ln701_fu_193_p2;
wire   [0:0] icmp_ln879_fu_161_p2;
wire   [0:0] icmp_ln879_1_fu_167_p2;
wire   [0:0] xor_ln879_fu_215_p2;
wire   [0:0] and_ln879_fu_221_p2;
wire   [3:0] select_ln32_fu_185_p3;
wire   [3:0] select_ln36_fu_199_p3;
wire   [3:0] select_ln879_fu_227_p3;
wire   [5:0] add_ln320_fu_155_p2;
wire   [1:0] ssdm_int_V_write_ass_fu_249_p4;
wire   [3:0] data_V_2_fu_207_p3;
wire   [0:0] icmp_ln883_4_fu_283_p2;
wire   [3:0] add_ln700_1_fu_289_p2;
wire   [3:0] add_ln701_1_fu_303_p2;
wire   [0:0] icmp_ln879_3_fu_271_p2;
wire   [3:0] add_ln1503_fu_243_p2;
wire   [0:0] icmp_ln879_4_fu_277_p2;
wire   [0:0] xor_ln879_1_fu_325_p2;
wire   [0:0] and_ln879_1_fu_331_p2;
wire   [3:0] select_ln32_1_fu_295_p3;
wire   [3:0] select_ln36_1_fu_309_p3;
wire   [3:0] select_ln879_3_fu_337_p3;
wire   [5:0] add_ln214_fu_259_p2;
wire   [1:0] ssdm_int_V_write_ass_1_fu_359_p4;
wire   [3:0] select_ln879_2_fu_317_p3;
wire   [3:0] add_ln1503_1_fu_353_p2;
wire   [3:0] add_ln700_2_fu_407_p2;
wire   [3:0] add_ln701_2_fu_418_p2;
wire   [0:0] xor_ln879_2_fu_429_p2;
wire   [0:0] and_ln879_2_fu_434_p2;
wire   [3:0] select_ln32_2_fu_412_p3;
wire   [3:0] select_ln36_2_fu_423_p3;
wire   [3:0] select_ln879_6_fu_439_p3;
reg   [3:0] ap_NS_fsm;
reg    ap_condition_94;

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
    if (((icmp_ln883_2_reg_501 == 1'd0) & (icmp_ln883_3_reg_482 == 1'd0) & (icmp_ln883_reg_468 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        ctrl_V_0_0_in_in_reg_86 <= add_ln214_1_reg_496;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        ctrl_V_0_0_in_in_reg_86 <= seed_V;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_2_reg_501 == 1'd0) & (icmp_ln883_3_reg_482 == 1'd0) & (icmp_ln883_reg_468 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        data_V_0_0_reg_77 <= add_ln1503_2_fu_453_p2;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        data_V_0_0_reg_77 <= data_V_fu_131_p1;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_2_reg_501 == 1'd0) & (icmp_ln883_3_reg_482 == 1'd0) & (icmp_ln883_reg_468 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        data_V_1_reg_95 <= select_ln879_5_reg_522;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        data_V_1_reg_95 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_2_reg_501 == 1'd0) & (icmp_ln883_3_reg_482 == 1'd0) & (icmp_ln883_reg_468 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        p_053_0_0_reg_106 <= select_ln879_7_fu_447_p3;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_053_0_0_reg_106 <= 4'd0;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        if ((1'b1 == ap_condition_94)) begin
            p_053_0_lcssa_reg_118 <= select_ln879_4_fu_345_p3;
        end else if (((icmp_ln883_3_fu_265_p2 == 1'd1) & (icmp_ln883_fu_145_p2 == 1'd0))) begin
            p_053_0_lcssa_reg_118 <= select_ln879_1_fu_235_p3;
        end else if ((icmp_ln883_fu_145_p2 == 1'd1)) begin
            p_053_0_lcssa_reg_118 <= p_053_0_0_reg_106;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_3_fu_265_p2 == 1'd0) & (icmp_ln883_fu_145_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        add_ln214_1_reg_496 <= add_ln214_1_fu_369_p2;
        icmp_ln883_2_reg_501 <= icmp_ln883_2_fu_375_p2;
        select_ln879_4_reg_486 <= select_ln879_4_fu_345_p3;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_2_fu_375_p2 == 1'd0) & (icmp_ln883_3_fu_265_p2 == 1'd0) & (icmp_ln883_fu_145_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        icmp_ln879_2_reg_505 <= icmp_ln879_2_fu_381_p2;
        icmp_ln879_5_reg_511 <= icmp_ln879_5_fu_387_p2;
        icmp_ln883_5_reg_516 <= icmp_ln883_5_fu_393_p2;
        select_ln879_5_reg_522 <= select_ln879_5_fu_399_p3;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln883_fu_145_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        icmp_ln883_3_reg_482 <= icmp_ln883_3_fu_265_p2;
        trunc_ln320_reg_472 <= trunc_ln320_fu_151_p1;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        icmp_ln883_reg_468 <= icmp_ln883_fu_145_p2;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        out_V_ap_vld = 1'b1;
    end else begin
        out_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        ap_ST_fsm_state2 : begin
            if (((icmp_ln883_2_fu_375_p2 == 1'd0) & (icmp_ln883_3_fu_265_p2 == 1'd0) & (icmp_ln883_fu_145_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
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

assign add_ln1503_1_fu_353_p2 = (trunc_ln320_fu_151_p1 + 4'd2);

assign add_ln1503_2_fu_453_p2 = (trunc_ln320_reg_472 + 4'd3);

assign add_ln1503_fu_243_p2 = (4'd1 + trunc_ln320_fu_151_p1);

assign add_ln214_1_fu_369_p2 = (ctrl_V_0_0_in_in_reg_86 + 6'd3);

assign add_ln214_fu_259_p2 = (6'd2 + ctrl_V_0_0_in_in_reg_86);

assign add_ln320_fu_155_p2 = (6'd1 + ctrl_V_0_0_in_in_reg_86);

assign add_ln700_1_fu_289_p2 = (select_ln879_1_fu_235_p3 + 4'd1);

assign add_ln700_2_fu_407_p2 = (select_ln879_4_reg_486 + 4'd1);

assign add_ln700_fu_179_p2 = (4'd1 + p_053_0_0_reg_106);

assign add_ln701_1_fu_303_p2 = ($signed(select_ln879_1_fu_235_p3) + $signed(4'd15));

assign add_ln701_2_fu_418_p2 = ($signed(select_ln879_4_reg_486) + $signed(4'd15));

assign add_ln701_fu_193_p2 = ($signed(4'd15) + $signed(p_053_0_0_reg_106));

assign and_ln879_1_fu_331_p2 = (xor_ln879_1_fu_325_p2 & icmp_ln879_4_fu_277_p2);

assign and_ln879_2_fu_434_p2 = (xor_ln879_2_fu_429_p2 & icmp_ln879_5_reg_511);

assign and_ln879_fu_221_p2 = (xor_ln879_fu_215_p2 & icmp_ln879_1_fu_167_p2);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

always @ (*) begin
    ap_condition_94 = ((icmp_ln883_2_fu_375_p2 == 1'd1) & (icmp_ln883_3_fu_265_p2 == 1'd0) & (icmp_ln883_fu_145_p2 == 1'd0));
end

assign ctrl_V_fu_135_p4 = {{ctrl_V_0_0_in_in_reg_86[5:4]}};

assign data_V_2_fu_207_p3 = ((icmp_ln879_fu_161_p2[0:0] === 1'b1) ? data_V_0_0_reg_77 : data_V_1_reg_95);

assign data_V_fu_131_p1 = seed_V[3:0];

assign icmp_ln879_1_fu_167_p2 = ((ctrl_V_fu_135_p4 == 2'd2) ? 1'b1 : 1'b0);

assign icmp_ln879_2_fu_381_p2 = ((ssdm_int_V_write_ass_1_fu_359_p4 == 2'd1) ? 1'b1 : 1'b0);

assign icmp_ln879_3_fu_271_p2 = ((ssdm_int_V_write_ass_fu_249_p4 == 2'd1) ? 1'b1 : 1'b0);

assign icmp_ln879_4_fu_277_p2 = ((ssdm_int_V_write_ass_fu_249_p4 == 2'd2) ? 1'b1 : 1'b0);

assign icmp_ln879_5_fu_387_p2 = ((ssdm_int_V_write_ass_1_fu_359_p4 == 2'd2) ? 1'b1 : 1'b0);

assign icmp_ln879_fu_161_p2 = ((ctrl_V_fu_135_p4 == 2'd1) ? 1'b1 : 1'b0);

assign icmp_ln883_1_fu_173_p2 = ((p_053_0_0_reg_106 == data_V_1_reg_95) ? 1'b1 : 1'b0);

assign icmp_ln883_2_fu_375_p2 = ((ssdm_int_V_write_ass_1_fu_359_p4 == 2'd0) ? 1'b1 : 1'b0);

assign icmp_ln883_3_fu_265_p2 = ((ssdm_int_V_write_ass_fu_249_p4 == 2'd0) ? 1'b1 : 1'b0);

assign icmp_ln883_4_fu_283_p2 = ((select_ln879_1_fu_235_p3 == data_V_2_fu_207_p3) ? 1'b1 : 1'b0);

assign icmp_ln883_5_fu_393_p2 = ((select_ln879_4_fu_345_p3 == select_ln879_2_fu_317_p3) ? 1'b1 : 1'b0);

assign icmp_ln883_fu_145_p2 = ((ctrl_V_fu_135_p4 == 2'd0) ? 1'b1 : 1'b0);

assign out_V = p_053_0_lcssa_reg_118;

assign select_ln32_1_fu_295_p3 = ((icmp_ln883_4_fu_283_p2[0:0] === 1'b1) ? select_ln879_1_fu_235_p3 : add_ln700_1_fu_289_p2);

assign select_ln32_2_fu_412_p3 = ((icmp_ln883_5_reg_516[0:0] === 1'b1) ? select_ln879_4_reg_486 : add_ln700_2_fu_407_p2);

assign select_ln32_fu_185_p3 = ((icmp_ln883_1_fu_173_p2[0:0] === 1'b1) ? p_053_0_0_reg_106 : add_ln700_fu_179_p2);

assign select_ln36_1_fu_309_p3 = ((icmp_ln883_4_fu_283_p2[0:0] === 1'b1) ? select_ln879_1_fu_235_p3 : add_ln701_1_fu_303_p2);

assign select_ln36_2_fu_423_p3 = ((icmp_ln883_5_reg_516[0:0] === 1'b1) ? select_ln879_4_reg_486 : add_ln701_2_fu_418_p2);

assign select_ln36_fu_199_p3 = ((icmp_ln883_1_fu_173_p2[0:0] === 1'b1) ? p_053_0_0_reg_106 : add_ln701_fu_193_p2);

assign select_ln879_1_fu_235_p3 = ((icmp_ln879_fu_161_p2[0:0] === 1'b1) ? p_053_0_0_reg_106 : select_ln879_fu_227_p3);

assign select_ln879_2_fu_317_p3 = ((icmp_ln879_3_fu_271_p2[0:0] === 1'b1) ? add_ln1503_fu_243_p2 : data_V_2_fu_207_p3);

assign select_ln879_3_fu_337_p3 = ((and_ln879_1_fu_331_p2[0:0] === 1'b1) ? select_ln32_1_fu_295_p3 : select_ln36_1_fu_309_p3);

assign select_ln879_4_fu_345_p3 = ((icmp_ln879_3_fu_271_p2[0:0] === 1'b1) ? select_ln879_1_fu_235_p3 : select_ln879_3_fu_337_p3);

assign select_ln879_5_fu_399_p3 = ((icmp_ln879_2_fu_381_p2[0:0] === 1'b1) ? add_ln1503_1_fu_353_p2 : select_ln879_2_fu_317_p3);

assign select_ln879_6_fu_439_p3 = ((and_ln879_2_fu_434_p2[0:0] === 1'b1) ? select_ln32_2_fu_412_p3 : select_ln36_2_fu_423_p3);

assign select_ln879_7_fu_447_p3 = ((icmp_ln879_2_reg_505[0:0] === 1'b1) ? select_ln879_4_reg_486 : select_ln879_6_fu_439_p3);

assign select_ln879_fu_227_p3 = ((and_ln879_fu_221_p2[0:0] === 1'b1) ? select_ln32_fu_185_p3 : select_ln36_fu_199_p3);

assign ssdm_int_V_write_ass_1_fu_359_p4 = {{add_ln214_fu_259_p2[5:4]}};

assign ssdm_int_V_write_ass_fu_249_p4 = {{add_ln320_fu_155_p2[5:4]}};

assign trunc_ln320_fu_151_p1 = ctrl_V_0_0_in_in_reg_86[3:0];

assign xor_ln879_1_fu_325_p2 = (icmp_ln879_3_fu_271_p2 ^ 1'd1);

assign xor_ln879_2_fu_429_p2 = (icmp_ln879_2_reg_505 ^ 1'd1);

assign xor_ln879_fu_215_p2 = (icmp_ln879_fu_161_p2 ^ 1'd1);

endmodule //counter
