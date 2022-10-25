# *******************************************************************************
# Vendor: Xilinx 
# Associated Filename: run_hls.tcl
# Purpose: Tcl commands to setup Vivado HLS tutorial example
# Device: All 
# Revision History: March 31, 2013 - initial release
#                                                 
# *******************************************************************************
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

# 
# This file contains confidential and proprietary information of Xilinx, Inc. and 
# is protected under U.S. and international copyright and other intellectual 
# property laws.
# 
# DISCLAIMER
# This disclaimer is not a license and does not grant any rights to the materials 
# distributed herewith. Except as otherwise provided in a valid license issued to 
# you by Xilinx, and to the maximum extent permitted by applicable law: 
# (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX 
# HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
# INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
# FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether 
# in contract or tort, including negligence, or under any other theory of 
# liability) for any loss or damage of any kind or nature related to, arising under 
# or in connection with these materials, including for any direct, or any indirect, 
# special, incidental, or consequential loss or damage (including loss of data, 
# profits, goodwill, or any type of loss or damage suffered as a result of any 
# action brought by a third party) even if such damage or loss was reasonably 
# foreseeable or Xilinx had been advised of the possibility of the same.
# 
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-safe, or for use in any 
# application requiring fail-safe performance, such as life-support or safety 
# devices or systems, Class III medical devices, nuclear facilities, applications 
# related to the deployment of airbags, or any other applications that could lead 
# to death, personal injury, or severe property or environmental damage 
# (individually and collectively, "Critical Applications"). Customer assumes the 
# sole risk and liability of any use of Xilinx products in Critical Applications, 
# subject only to applicable laws and regulations governing limitations on product 
# liability. 
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT 
# ALL TIMES.

# Project settings
open_project proj -reset

# Add the file for synthsis
add_files fft_top.cpp

# Add testbench files for co-simulation
add_files -tb fft_tb.cpp
add_files -tb data/stimulus_00.dat
add_files -tb data/stimulus_01.dat
add_files -tb data/stimulus_02.dat
add_files -tb data/stimulus_03.dat
add_files -tb data/stimulus_04.dat
add_files -tb data/stimulus_05.dat
add_files -tb data/stimulus_06.dat
add_files -tb data/stimulus_07.dat
add_files -tb data/stimulus_08.dat
add_files -tb data/stimulus_09.dat
add_files -tb data/stimulus_10.dat
add_files -tb data/stimulus_11.dat
add_files -tb data/stimulus_12.dat
add_files -tb data/stimulus_13.dat
add_files -tb data/stimulus_14.dat
add_files -tb data/stimulus_15.dat
add_files -tb data/stimulus_16.dat
add_files -tb data/stimulus_17.dat
add_files -tb data/stimulus_18.dat
add_files -tb data/stimulus_19.dat
add_files -tb data/stimulus_00.res
add_files -tb data/stimulus_01.res
add_files -tb data/stimulus_02.res
add_files -tb data/stimulus_03.res
add_files -tb data/stimulus_04.res
add_files -tb data/stimulus_05.res
add_files -tb data/stimulus_06.res
add_files -tb data/stimulus_07.res
add_files -tb data/stimulus_08.res
add_files -tb data/stimulus_09.res
add_files -tb data/stimulus_10.res
add_files -tb data/stimulus_11.res
add_files -tb data/stimulus_12.res
add_files -tb data/stimulus_13.res
add_files -tb data/stimulus_14.res
add_files -tb data/stimulus_15.res
add_files -tb data/stimulus_16.res
add_files -tb data/stimulus_17.res
add_files -tb data/stimulus_18.res
add_files -tb data/stimulus_19.res

# Set top module of the design
set_top fft_top

# Solution settings
open_solution -reset solution1

# Define technology 
set_part  {xcvu9p-flga2104-2-i}

# Set the target clock period
create_clock -period 3.3

# Set to 0: to run setup
# Set to 1: to run setup and synthesis
# Set to 2: to run setup, synthesis and RTL simulation
# Set to 3: to run setup, synthesis, RTL simulation and RTL synthesis
# Any other value will run setup only
set hls_exec 1

# Run C simulation
csim_design

# Set any optimization directives
config_dataflow -default_channel fifo -fifo_depth 1
# End of directives

if {$hls_exec == 1} {
	# Run Synthesis and Exit
	csynth_design
	
} elseif {$hls_exec == 2} {
	# Run Synthesis, RTL Simulation and Exit
	csynth_design
	
	cosim_design -rtl verilog
} elseif {$hls_exec == 3} { 
	# Run Synthesis, RTL Simulation, RTL implementation and Exit
	csynth_design
	
	cosim_design -rtl verilog

	export_design
} else {
	# Default is to exit after setup
	csynth_design
}
exit


