#!/bin/csh -xvf

# Set VIVADO_BIN_DIR to the directory which has vivado executable

#set VIVADO_BIN_DIR="$RDI_ROOT/prep/rdi/vivado/bin"
set VIVADO_BIN_DIR="$XILINX_VIVADO/bin"

set OUT_SIM_SNAPSHOT="counter"
set XSI_INCLUDE_DIR="$VIVADO_BIN_DIR/../data/xsim/include"
set GCC_COMPILER="/usr/bin/g++"
set XSIM_ELAB="xelab"
set OUT_EXE="run_simulation"

# Start clean
#rm -rf xsim.dir xsim.log xelab* $OUT_EXE

# Compile the HDL design into a simulatable Shared Library
$XSIM_ELAB work.counter_verilog -prj counter.prj -dll -s $OUT_SIM_SNAPSHOT -debug wave

# Compile the C++ code that interfaces with XSI of ISim
#$GCC_COMPILER -I$XSI_INCLUDE_DIR  -g -c -o xsi_loader.o xsi_loader.cpp
$GCC_COMPILER -I$XSI_INCLUDE_DIR  -O3 -c -o xsi_loader.o xsi_loader.cpp

# Compile the program that needs to simulate the HDL design
#$GCC_COMPILER -I$XSI_INCLUDE_DIR  -g -c -o testbench.o testbench.cpp
$GCC_COMPILER -I$XSI_INCLUDE_DIR  -O3 -c -o testbench.o testbench.cpp

$GCC_COMPILER -ldl -lrt  -o $OUT_EXE testbench.o xsi_loader.o

# Run the program
./$OUT_EXE
