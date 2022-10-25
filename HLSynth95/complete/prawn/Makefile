#-------------------------------------------------------------------------------
#-
#-   Prawn CPU Benchmark : Makefile for Zycad VHDL Simlator v1.0
#-
#- Author: Tadatoshi Ishii
#-         Information and Computer Science,
#-         University Of California, Irvine, CA 92717
#-
#- Developed on Nov 1, 1992
#-
#-------------------------------------------------------------------------------

all:	tst1book.rst tst2book.rst tstop1.rst tstop2.rst tstop3.rst tstop4.rst tstop5.rst tstop6.rst tstop7.rst tstop8.rst tstop9.rst tstopA.rst tstopB.rst tstopC.rst

TYPES.sim:	types.vhdl
	zvan types.vhdl

MVL7_FUNCTIONS.sim:	TYPES.sim MVL7_functions.vhdl
	zvan MVL7_functions.vhdl

LIB.sim:	TYPES.sim lib.vhdl
	zvan lib.vhdl

CPU.sim:	MVL7_FUNCTIONS.sim LIB.sim cpu.vhdl
	zvan cpu.vhdl

MEM.sim:	LIB.sim mem.vhdl
	zvan mem.vhdl

SIM.sim:	LIB.sim CPU.sim MEM.sim sim.vhdl
	zvan sim.vhdl

run.out:	SIM.sim
	zvsim -i cmd.i -t ns SIM

clean:
	/bin/rm -f run.out \
	CPU.mra CPU.sim CPU__BEHAVIORAL.sim \
	LIB.sim LIB__.sim \
	MEM.mra MEM.sim MEM__BEHAVIORAL.sim \
	MVL7_FUNCTIONS.sim MVL7_FUNCTIONS__.sim \
	SIM.mra SIM.sim SIM__INPUT_OUTPUT.sim \
	TYPES.sim TYPES__.sim


tst1book.rst:	tst1book.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tst1book.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tst1book.rst
	cat tst1book.rst

tst2book.rst:	tst2book.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tst2book.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tst2book.rst
	cat tst2book.rst

tstop1.rst:	tstop1.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstop1.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstop1.rst
	cat tstop1.rst

tstop2.rst:	tstop2.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstop2.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstop2.rst
	cat tstop2.rst

tstop3.rst:	tstop3.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstop3.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstop3.rst
	cat tstop3.rst

tstop4.rst:	tstop4.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstop4.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstop4.rst
	cat tstop4.rst

tstop5.rst:	tstop5.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstop5.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstop5.rst
	cat tstop5.rst

tstop6.rst:	tstop6.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstop6.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstop6.rst
	cat tstop6.rst

tstop7.rst:	tstop7.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstop7.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstop7.rst
	cat tstop7.rst

tstop8.rst:	tstop8.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstop8.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstop8.rst
	cat tstop8.rst

tstop9.rst:	tstop9.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstop9.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstop9.rst
	cat tstop9.rst

tstopA.rst:	tstopA.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstopA.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstopA.rst
	cat tstopA.rst

tstopB.rst:	tstopB.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstopB.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstopB.rst
	cat tstopB.rst

tstopC.rst:	tstopC.vhdl cmd.i LIB.sim CPU.sim sim.vhdl
	/bin/cp tstopC.vhdl mem.vhdl
	make run.out
	/bin/mv run.out tstopC.rst
	cat tstopC.rst

