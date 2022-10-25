// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
/*******************************************************************************
Vendor: Xilinx 
Associated Filename: sc_sequ_cthread_test.cpp
Purpose:Vivado HLS Coding Style example 
Device: All 
Revision History: May 30, 2008 - initial release
                                                
*******************************************************************************
#-  (c) Copyright 2011-2019 Xilinx, Inc. All rights reserved.
#-
#-  This file contains confidential and proprietary information
#-  of Xilinx, Inc. and is protected under U.S. and
#-  international copyright and other intellectual property
#-  laws.
#-
#-  DISCLAIMER
#-  This disclaimer is not a license and does not grant any
#-  rights to the materials distributed herewith. Except as
#-  otherwise provided in a valid license issued to you by
#-  Xilinx, and to the maximum extent permitted by applicable
#-  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
#-  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
#-  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
#-  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
#-  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
#-  (2) Xilinx shall not be liable (whether in contract or tort,
#-  including negligence, or under any other theory of
#-  liability) for any loss or damage of any kind or nature
#-  related to, arising under or in connection with these
#-  materials, including for any direct, or any indirect,
#-  special, incidental, or consequential loss or damage
#-  (including loss of data, profits, goodwill, or any type of
#-  loss or damage suffered as a result of any action brought
#-  by a third party) even if such damage or loss was
#-  reasonably foreseeable or Xilinx had been advised of the
#-  possibility of the same.
#-
#-  CRITICAL APPLICATIONS
#-  Xilinx products are not designed or intended to be fail-
#-  safe, or for use in any application requiring fail-safe
#-  performance, such as life-support or safety devices or
#-  systems, Class III medical devices, nuclear facilities,
#-  applications related to the deployment of airbags, or any
#-  other applications that could lead to death, personal
#-  injury, or severe property or environmental damage
#-  (individually and collectively, "Critical
#-  Applications"). Customer assumes the sole risk and
#-  liability of any use of Xilinx products in Critical
#-  Applications, subject only to applicable laws and
#-  regulations governing limitations on product liability.
#-
#-  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
#-  PART OF THIS FILE AT ALL TIMES. 
#- ************************************************************************


This file contains confidential and proprietary information of Xilinx, Inc. and 
is protected under U.S. and international copyright and other intellectual 
property laws.

DISCLAIMER
This disclaimer is not a license and does not grant any rights to the materials 
distributed herewith. Except as otherwise provided in a valid license issued to 
you by Xilinx, and to the maximum extent permitted by applicable law: 
(1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX 
HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether 
in contract or tort, including negligence, or under any other theory of 
liability) for any loss or damage of any kind or nature related to, arising under 
or in connection with these materials, including for any direct, or any indirect, 
special, incidental, or consequential loss or damage (including loss of data, 
profits, goodwill, or any type of loss or damage suffered as a result of any 
action brought by a third party) even if such damage or loss was reasonably 
foreseeable or Xilinx had been advised of the possibility of the same.

CRITICAL APPLICATIONS
Xilinx products are not designed or intended to be fail-safe, or for use in any 
application requiring fail-safe performance, such as life-support or safety 
devices or systems, Class III medical devices, nuclear facilities, applications 
related to the deployment of airbags, or any other applications that could lead 
to death, personal injury, or severe property or environmental damage 
(individually and collectively, "Critical Applications"). Customer asresultes the 
sole risk and liability of any use of Xilinx products in Critical Applications, 
subject only to applicable laws and regulations governing limitations on product 
liability. 

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT 
ALL TIMES.

*******************************************************************************/
// Settings to operate withVivado HLSRTL sim wrappers
#ifdef __RTL_SIMULATION__
#include "sc_sequ_cthread_rtl_wrapper.h"
#define sc_sequ_cthread sc_sequ_cthread_rtl_wrapper
#else
#include "sc_sequ_cthread.h"
#endif

#include "tb_init.h"
#include "tb_driver.h"

int sc_main (int argc , char *argv[]) 
{
	// Remove simulation warnings
	sc_report_handler::set_actions("/IEEE_Std_1666/deprecated", SC_DO_NOTHING);
	sc_report_handler::set_actions( SC_ID_LOGIC_X_TO_BOOL_, SC_LOG);
	sc_report_handler::set_actions( SC_ID_VECTOR_CONTAINS_LOGIC_VALUE_, SC_LOG);
	sc_report_handler::set_actions( SC_ID_OBJECT_EXISTS_, SC_LOG);

	// Test bench signals
	sc_signal<bool>	s_reset;
	sc_signal<bool>	s_start;
	sc_signal<sc_uint<16> >	s_a;
	sc_signal<bool>	s_en;
	sc_signal<sc_uint<16> >	s_sum;
	sc_signal<bool>	s_vld;

	sc_clock s_clk("s_clk",10,SC_NS);       // Create a 10ns period clock signal

	// Test bench modules
	tb_init	U_tb_init("U_tb_init");
	sc_sequ_cthread	U_dut("U_dut");
	tb_driver	U_tb_driver("U_tb_driver");
	 
	// Generate a reset & start signal to drive the sim
	U_tb_init.clk(s_clk);
	U_tb_init.reset(s_reset);
	U_tb_init.start(s_start);

	// Connect the DUT
	U_dut.clk(s_clk);
	U_dut.reset(s_reset);
	U_dut.start(s_start);
	U_dut.a(s_a);
	U_dut.en(s_en);
	U_dut.sum(s_sum);
	U_dut.vld(s_vld);

	// Drive stimuli & Capture results
	U_tb_driver.clk(s_clk);
	U_tb_driver.reset(s_reset);
	U_tb_driver.start(s_start);
	U_tb_driver.dat_a(s_a);
	U_tb_driver.dat_en(s_en);
	U_tb_driver.out_sum(s_sum);
	U_tb_driver.out_vld(s_vld);
   
	// Sim 
	int end_time = 1100;
  
	cout << "INFO: Simulating " << endl;
	
	// start simulation 
	sc_start(end_time, SC_NS);

	// Print summary of results check
	if (U_tb_driver.retval != 0) {
		printf("Test failed  !!!\n"); 
	} else {
		printf("Test passed !\n");
  }
  return U_tb_driver.retval;
};

