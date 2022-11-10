// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2020.1
// Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="diffeq,hls_ip_2020_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k70t-fbv676-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=7.765000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=42,HLS_SYN_LUT=216,HLS_VERSION=2020_1}" *)

module diffeq (
        ap_clk,
        ap_rst,
        vars_V,
        Xoutport_V,
        Xoutport_V_ap_vld,
        Youtport_V,
        Youtport_V_ap_vld,
        Uoutport_V,
        Uoutport_V_ap_vld
);

parameter    ap_ST_fsm_state1 = 3'd1;
parameter    ap_ST_fsm_pp0_stage0 = 3'd2;
parameter    ap_ST_fsm_state4 = 3'd4;

input   ap_clk;
input   ap_rst;
input  [19:0] vars_V;
output  [3:0] Xoutport_V;
output   Xoutport_V_ap_vld;
output  [3:0] Youtport_V;
output   Youtport_V_ap_vld;
output  [3:0] Uoutport_V;
output   Uoutport_V_ap_vld;

reg Xoutport_V_ap_vld;
reg Youtport_V_ap_vld;
reg Uoutport_V_ap_vld;

reg  signed [3:0] p_0441_0_reg_95;
reg  signed [3:0] p_0438_0_reg_106;
reg  signed [3:0] p_0437_0_reg_117;
wire   [3:0] x_var_V_fu_210_p1;
(* fsm_encoding = "none" *) reg   [2:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg   [3:0] a_var_V_reg_322;
wire  signed [3:0] dx_var_V_fu_244_p4;
reg  signed [3:0] dx_var_V_reg_327;
wire  signed [3:0] t1_V_fu_272_p2;
reg  signed [3:0] t1_V_reg_333;
wire   [0:0] icmp_ln887_fu_278_p2;
reg   [0:0] icmp_ln887_reg_339;
wire    ap_CS_fsm_pp0_stage0;
wire    ap_block_state2_pp0_stage0_iter0;
wire    ap_block_state3_pp0_stage0_iter1;
wire    ap_block_pp0_stage0_11001;
wire  signed [3:0] u_var_V_1_fu_289_p2;
reg  signed [3:0] u_var_V_1_reg_343;
reg    ap_enable_reg_pp0_iter0;
wire   [3:0] y_var_V_1_fu_296_p2;
reg   [3:0] y_var_V_1_reg_348;
wire   [3:0] x_var_V_1_fu_302_p2;
reg   [3:0] x_var_V_1_reg_353;
wire    ap_block_pp0_stage0_subdone;
reg    ap_condition_pp0_exit_iter0_state2;
reg    ap_enable_reg_pp0_iter1;
reg  signed [3:0] ap_phi_mux_p_0441_0_phi_fu_99_p4;
wire    ap_block_pp0_stage0;
reg  signed [3:0] ap_phi_mux_p_0438_0_phi_fu_110_p4;
reg  signed [3:0] ap_phi_mux_p_0437_0_phi_fu_121_p4;
wire    ap_CS_fsm_state4;
wire  signed [3:0] mul_ln209_fu_128_p2;
wire   [1:0] tmp_1_fu_254_p4;
wire   [3:0] and_ln_fu_264_p3;
wire   [3:0] t4_V_fu_129_p2;
wire   [3:0] t6_V_fu_283_p2;
wire   [3:0] t5_V_fu_130_p2;
wire   [3:0] y1_V_fu_131_p2;
reg   [2:0] ap_NS_fsm;
reg    ap_idle_pp0;
wire    ap_enable_pp0;

// power-on initialization
initial begin
#0 ap_CS_fsm = 3'd1;
#0 ap_enable_reg_pp0_iter0 = 1'b0;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter0 <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_condition_pp0_exit_iter0_state2) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_enable_reg_pp0_iter0 <= 1'b0;
        end else if ((1'b1 == ap_CS_fsm_state1)) begin
            ap_enable_reg_pp0_iter0 <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_condition_pp0_exit_iter0_state2))) begin
            ap_enable_reg_pp0_iter1 <= (1'b1 ^ ap_condition_pp0_exit_iter0_state2);
        end else if ((1'b0 == ap_block_pp0_stage0_subdone)) begin
            ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
        end else if ((1'b1 == ap_CS_fsm_state1)) begin
            ap_enable_reg_pp0_iter1 <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln887_reg_339 == 1'd1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        p_0437_0_reg_117 <= u_var_V_1_reg_343;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_0437_0_reg_117 <= {{vars_V[11:8]}};
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln887_reg_339 == 1'd1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        p_0438_0_reg_106 <= y_var_V_1_reg_348;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_0438_0_reg_106 <= {{vars_V[7:4]}};
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln887_reg_339 == 1'd1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        p_0441_0_reg_95 <= x_var_V_1_reg_353;
    end else if ((1'b1 == ap_CS_fsm_state1)) begin
        p_0441_0_reg_95 <= x_var_V_fu_210_p1;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state1)) begin
        a_var_V_reg_322 <= {{vars_V[15:12]}};
        dx_var_V_reg_327 <= {{vars_V[19:16]}};
        t1_V_reg_333 <= t1_V_fu_272_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        icmp_ln887_reg_339 <= icmp_ln887_fu_278_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln887_fu_278_p2 == 1'd1) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        u_var_V_1_reg_343 <= u_var_V_1_fu_289_p2;
        x_var_V_1_reg_353 <= x_var_V_1_fu_302_p2;
        y_var_V_1_reg_348 <= y_var_V_1_fu_296_p2;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        Uoutport_V_ap_vld = 1'b1;
    end else begin
        Uoutport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        Xoutport_V_ap_vld = 1'b1;
    end else begin
        Xoutport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        Youtport_V_ap_vld = 1'b1;
    end else begin
        Youtport_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if ((icmp_ln887_fu_278_p2 == 1'd0)) begin
        ap_condition_pp0_exit_iter0_state2 = 1'b1;
    end else begin
        ap_condition_pp0_exit_iter0_state2 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (icmp_ln887_reg_339 == 1'd1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_phi_mux_p_0437_0_phi_fu_121_p4 = u_var_V_1_reg_343;
    end else begin
        ap_phi_mux_p_0437_0_phi_fu_121_p4 = p_0437_0_reg_117;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (icmp_ln887_reg_339 == 1'd1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_phi_mux_p_0438_0_phi_fu_110_p4 = y_var_V_1_reg_348;
    end else begin
        ap_phi_mux_p_0438_0_phi_fu_110_p4 = p_0438_0_reg_106;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (icmp_ln887_reg_339 == 1'd1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_phi_mux_p_0441_0_phi_fu_99_p4 = x_var_V_1_reg_353;
    end else begin
        ap_phi_mux_p_0441_0_phi_fu_99_p4 = p_0441_0_reg_95;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_pp0_stage0;
        end
        ap_ST_fsm_pp0_stage0 : begin
            if (~((1'b0 == ap_block_pp0_stage0_subdone) & (icmp_ln887_fu_278_p2 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (icmp_ln887_fu_278_p2 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end
        end
        ap_ST_fsm_state4 : begin
            ap_NS_fsm = ap_ST_fsm_state1;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign Uoutport_V = p_0437_0_reg_117;

assign Xoutport_V = p_0441_0_reg_95;

assign Youtport_V = p_0438_0_reg_106;

assign and_ln_fu_264_p3 = {{tmp_1_fu_254_p4}, {2'd0}};

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd2];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_subdone = ~(1'b1 == 1'b1);

assign ap_block_state2_pp0_stage0_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state3_pp0_stage0_iter1 = ~(1'b1 == 1'b1);

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign dx_var_V_fu_244_p4 = {{vars_V[19:16]}};

assign icmp_ln887_fu_278_p2 = ((ap_phi_mux_p_0441_0_phi_fu_99_p4 < a_var_V_reg_322) ? 1'b1 : 1'b0);

assign mul_ln209_fu_128_p2 = ($signed(t1_V_reg_333) * $signed(ap_phi_mux_p_0437_0_phi_fu_121_p4));

assign t1_V_fu_272_p2 = ($signed(and_ln_fu_264_p3) - $signed(dx_var_V_fu_244_p4));

assign t4_V_fu_129_p2 = ($signed(mul_ln209_fu_128_p2) * $signed(ap_phi_mux_p_0441_0_phi_fu_99_p4));

assign t5_V_fu_130_p2 = ($signed(ap_phi_mux_p_0438_0_phi_fu_110_p4) * $signed(t1_V_reg_333));

assign t6_V_fu_283_p2 = ($signed(ap_phi_mux_p_0437_0_phi_fu_121_p4) - $signed(t4_V_fu_129_p2));

assign tmp_1_fu_254_p4 = {{vars_V[17:16]}};

assign u_var_V_1_fu_289_p2 = (t6_V_fu_283_p2 - t5_V_fu_130_p2);

assign x_var_V_1_fu_302_p2 = ($signed(dx_var_V_reg_327) + $signed(ap_phi_mux_p_0441_0_phi_fu_99_p4));

assign x_var_V_fu_210_p1 = vars_V[3:0];

assign y1_V_fu_131_p2 = ($signed(u_var_V_1_fu_289_p2) * $signed(dx_var_V_reg_327));

assign y_var_V_1_fu_296_p2 = ($signed(y1_V_fu_131_p2) + $signed(ap_phi_mux_p_0438_0_phi_fu_110_p4));

endmodule //diffeq
