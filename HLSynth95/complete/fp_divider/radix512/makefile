# -----------------------------------------------------------------
# 
#  Radix-512 Divider Benchmark Makefile
# 
#  VHDL Benchmark author: Alberto Nannarelli on Jan 18 1994
# 
#  Makefile
# 
# -----------------------------------------------------------------

ANALYZER	= vhdlan

all:  E_A.sim

E.sim \
E__A.sim \
E_A.sim :        test_vectors.vhdl  \
        RADIX512.sim  \
        RADIX512__RADIX512.sim 
		${ANALYZER} -nc -w DEFAULT test_vectors.vhdl

RADIX512.sim \
RADIX512__RADIX512.sim :	radix512.vhdl \
DIVIDER.sim \
DIVIDER__.sim
		${ANALYZER} -nc -w DEFAULT radix512.vhdl

DIVIDER.sim \
DIVIDER__.sim :	pack.vhdl 
		${ANALYZER} -nc -w DEFAULT pack.vhdl

