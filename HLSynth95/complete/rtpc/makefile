#Synopsys 1076 VHDL Simdepends Version 3.0a-10052
#
#	        Copyright (c) 1990-1992 by Synopsys, Inc.
#	                    ALL RIGHTS RESERVED
#	This program is proprietary and confidential information
#	of  Synopsys, Inc. and may be used and disclosed only as
#	authorized in a  license agreement  controlling such use
#	and disclosure.
#
#

ANALYZER	= vhdlan

all :	lib/RTPC_LIB__.sim \
	lib/SYSTEM_CFG.sim 

lib/RTPC_LIB.sim \
lib/RTPC_LIB__.sim :	lib.vhd 
		${ANALYZER} -nc -w DEFAULT lib.vhd

lib/SYSTEM.sim \
lib/SYSTEM__SCHEMATIC.sim \
lib/SYSTEM_CFG.sim :	system.vhd  \
	lib/RTPC_LIB.sim  \
	lib/CONTROL__BEHAVIORAL.sim  \
	lib/CONTROL_CFG.sim  \
	lib/RTPC__BEHAVIORAL.sim  \
	lib/RTPC_CFG.sim  \
	lib/MEMORY__BEHAVIORAL.sim  \
	lib/MEMORY_CFG.sim  \
	lib/CONTROL.sim  \
	lib/RTPC.sim  \
	lib/MEMORY.sim 
		${ANALYZER} -nc -w DEFAULT system.vhd

lib/CONTROL.sim \
lib/CONTROL__BEHAVIORAL.sim \
lib/CONTROL_CFG.sim :	control.vhd  \
	lib/RTPC_LIB.sim 
		${ANALYZER} -nc -w DEFAULT control.vhd

lib/RTPC.sim \
lib/RTPC__BEHAVIORAL.sim \
lib/RTPC_CFG.sim :	rtpc.vhd  \
	lib/RTPC_LIB.sim 
		${ANALYZER} -nc -w DEFAULT rtpc.vhd

lib/MEMORY.sim \
lib/MEMORY__BEHAVIORAL.sim \
lib/MEMORY_CFG.sim :	memory.vhd  \
	lib/RTPC_LIB.sim 
		${ANALYZER} -nc -w DEFAULT memory.vhd

