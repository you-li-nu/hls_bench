
#! /bin/sh
# This is a shell archive.  Remove anything before this line, then unpack
# it by saving it into a file and typing "sh file".  To overwrite existing
# files, type "sh file -c".  You can also feed this as standard input via
# unshar, or by typing "sh <file", e.g..  If this archive is complete, you
# will see the following message at the end:
#		"End of shell archive."
# Contents:  frisc/frisc.hc frisc/frisc.pat frisc/frisc.mon
#   frisc/add_16.sif frisc/frisc.sif frisc/subtract_16.sif
#   frisc/frisc.out.gold
# Wrapped by synthesis@sirius on Thu Jul 26 17:16:34 1990
PATH=/bin:/usr/bin:/usr/ucb ; export PATH
if test -f 'frisc/frisc.hc' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'frisc/frisc.hc'\"
else
echo shar: Extracting \"'frisc/frisc.hc'\" \(6062 characters\)
sed "s/^X//" >'frisc/frisc.hc' <<'END_OF_FILE'
X/*
X *
X *	MacPitts FRISC
X *
X *	Rajesh Gupta 
X *	Nov 8, 1989
X *
X *	edited: 4/23/90 5/21/90
X *
X
X
X DESCRIPTION:
X
X	frisc describes operation of a simple risc microprocessor.
X	The current hardwareC is adoped from frisc description 
X	written in V. 
X
X	Literature reference:
X
X
X	J. R. Southard, ``MacPitts: An Approach to Silicon Compilation'',
X	IEEE Computer, 1983 (pp 74-82).
X
X	Operation:
X	----------
X
X	on "reset" the processor loads PC and Stack Ptr from memory:
X
X		PC <= mem[0]
X		SP <= mem[1]
X
X	else during normal operation, the processor does the following 
X	operation until no opcodes are left:
X
X		Instr Reg, I = mem[PC]
X		PC++
X
X	normal opcode are 1 byte each, while extended opcodes are 2 
X	consecutive byte long. So each instruction fetch can fetch from
X	2 to 4 instructions.
X
X	On interrupts (irq), stack data register and accumulator results 
X	are saved in memory. Interrupt service routine is loaded from
X	address 2.
X
X		SP++
X		mem[SP] <= b
X		SP++
X		mem[SP] <= a
X		b = m
X		a = PC
X		m = SP + 1
X		PC = mem[2]
X
X	Interrupts are services following the next rising  edge of the
X	clock. Once an interrupt is being processed, further interrupt
X	requests are disabled.
X
X *
X */
X
X#include "../templates/library.hc"
X#define cpusize		16	/* # of bit computer */
X#define	DataSize	16
X
Xprocess frisc(reset, rd, wr, irq, iack, address, data, peaki, peakp, peaks, peaka, peakb)
X
X	/*
X	in port clock;				 clock signal 
X	*/
X	in port reset; 				/* reset line */
X	out port rd;				/* read signal */
X	out port wr;				/* write signal */
X	in port irq;				/* interrupt request */
X	out port iack;				/* interrupt ack */
X	out port address[cpusize];		/* address bus */
X	inout port data[cpusize];		/* data bus */
X
X	out port peaki[cpusize];
X	out port peakp[cpusize];
X	out port peaks[cpusize];
X	out port peaka[cpusize];
X	out port peakb[cpusize];
X{
X	register p[cpusize];			/* program counter */
X	register s[cpusize];			/* stack pointer */
X	register m[cpusize];			/* frame pointer */
X	register a[cpusize];			/* accumulator */
X	register b[cpusize];			/* stack data register*/
X	register i[cpusize];			/* instruction buffer */
X	boolean t[cpusize];			/* temporary */
X
X	/* direct connections for debug */
X	peakp = p;
X	peaks = s;
X	peaki = i;
X	peaka = a;
X	peakb = b;
X
X	/* we can also sample and hold reset and irq  */
X
X	if (reset) [
X
X		< write rd = 1; write address = 0x00; >
X	
X		< write rd = 0; p = read(data); >
X	
X		< write rd = 1; write address = 0x01; >
X	
X		< write rd = 0; s = read(data); >
X
X	] else [
X		if (irq) [ 				/* interrupt request? */
X			s = s+1;
X
X			< write wr = 1; write address = s; write data = b; >
X
X			write wr = 0; 
X			b = a; s = s+1; 
X
X			< write wr = 1; write address = s; write data = b; >
X	
X			write wr = 0; 
X			b = m; a = p; m = s+1; 
X	
X			< write rd = 1; write address = 2; >
X	
X			< write rd = 0; p = read(data); >
X	
X			write iack = 1;
X			write iack = 0; 
X		];
X
X		< write rd = 1; write address = p ; > 
X	
X		/* fetch opcodes from memory */
X
X		< write rd = 0; i = read(data); >
X
X		/* increment program counter */
X
X		p = p+1;			
X
X		/* select opcode; decode and execute */
X		while (i != 0) {	/* until no opcodes left in buffer */
X			switch (i[0:3]) { 
X
X			case 1: 			/* extended opcode */	
X				switch (i[4:7]) {
X
X				case 0:			/* nand */
X					b = !(a & b); 
X					a = b;
X					< write rd = 1;  write address = s; >
X					< write rd = 0; b = read(data); >
X					s = s-1;
X					break;
X				case 1:			/* subtract */
X					b = b - a; a = b;
X					< write rd = 1; write address = s; >
X					write rd = 0; 
X					b = read(data);
X					s = s - 1;
X					break;
X				case 2:			/* shift right */
X					a = a >> 1;
X					break; 
X				};
X				i = i >> 4 ; 		
X				break;
X	
X			case 2:			/* constant */
X				s = s + 1;
X
X				< write wr = 1; write address = s;  write data = b; >
X				write wr = 0; 
X				b = a; 
X				< write rd = 1; write address = p; >
X				< write rd = 0; a = read(data) ; >
X				p = p + 1;
X				break;
X			case 3:			/* get S */
X				s = s + 1;
X				< write wr = 1; write address = s; >
X				write data = b;
X				write wr = 0; 
X				b = a; 
X				a = s; 
X				break;
X			case 4:			/* set S */
X				s = a; 
X				a = b;
X				< write rd = 1; write address = s; >
X
X				write rd = 0; 
X				b = read(data);
X
X				s = s - 1; a = b;
X				< write rd = 1; write address = s; >
X
X				write rd = 0; 
X				b = read(data);
X
X				s = s - 1;
X				break;
X			case 5:			/* get M */
X				s = s + 1;
X				< write wr = 1; write address = s; >
X				write data = b;
X
X				write wr = 0; 
X				b = a; a = m;
X				break;
X			case 6:			/* load */
X				[ 
X				< write rd = 1; write address = a; >
X				< write rd = 0; a = read(data); > 
X				];
X				break;
X			case 7:			/* store */
X				< write wr = 1; write address = b; >
X				write data = a;
X
X				write wr = 0; 
X				a = b; 
X				< write rd = 1; write address = s; >
X
X				write rd = 0; 
X				b = read(data);
X
X				s = s - 1; 
X				break;
X			case 8:			/* go to */
X				p = a; a = b;
X				< write rd = 1; write address = s; >
X	
X				write rd = 0; 
X				b = read(data); 
X
X				s = s - 1;
X				break;
X			case 9:			/* if */
X				if (b > 0) p = a;
X				a = b; 
X
X				< write rd = 1; write address = s; >
X
X				write rd = 0; 
X				b = read(data);
X
X				s = s - 1;
X				break;
X			case 10:		/* end */
X				a = b;
X				< write rd = 1; write address = s; >
X
X				write rd = 0; 
X				b = read(data); 
X
X				s = s - 1;
X				break;
X			case 11:		/* mark */
X				s = s + 1;
X				< write wr = 1; write address = s; >
X				write data = b;
X
X				write wr = 0; 
X				b = a; a = m; m = s+2;
X				break;
X			case 12:		/* call */
X				t = p; p = a; a = t;
X				break;
X			case 13:		/* return */
X				p = b; b = a; s = m; a = b;
X
X				< write rd = 1; write address = s; >
X
X				write rd = 0; 
X				b = read(data);
X
X				s = s - 1;
X				m = b; b = a; a = b;
X
X				< write rd = 1; write address = s; >
X
X				write rd = 0; 
X				b = read(data);
X
X				s = s - 1;
X				break;
X			case 14:		/* add */
X				[
X				b = b + a; a = b;
X				< write rd = 1; write address = s; >
X
X				< write rd = 0; b = read(data);> ];
X
X				s = s - 1;
X				break;
X			case 15:		/* increment */
X				a = a + 1;
X				break;
X			};
X			i = i >> 4;			/* shift out opcode */
X		} /* while  (i != 0) */
X	]
X} /* process frisc */
END_OF_FILE
if test 6062 -ne `wc -c <'frisc/frisc.hc'`; then
    echo shar: \"'frisc/frisc.hc'\" unpacked with wrong size!
fi
# end of 'frisc/frisc.hc'
fi
if test -f 'frisc/frisc.pat' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'frisc/frisc.pat'\"
else
echo shar: Extracting \"'frisc/frisc.pat'\" \(5612 characters\)
sed "s/^X//" >'frisc/frisc.pat' <<'END_OF_FILE'
X# frisc.pat: no memory version, i.e., external memory is simulated by
X#	manually supplying the corresponding data
X#
X# memory map:
X#
X#	pc (p) : 		starts 000F (Hex)
X#	stack (s) :		starts 00FF (Hex)
X#	interrupt service:	starts 0FFF (Hex)
X#
X# This test executes the  following assembly program:
X#
X#	612F
X#	106E
X#	IRQ
X#				a	b
X#				----	-----
X#	a <= mem[a]		612F	
X#	a = a >> 1		B097
X#	a++			C097
X#	b = !(a & b)			FFFF
X#	a = b			FFFF
X#	b <= mem[s]			1234
X#	s--
X#	a <= mem[a]		5678
X#	b = b+a				68AC
X#	a = b			68AC
X#	b <= mem[s]			0000
X#	s--
X#
X# IRQ:
X#
X# 	increment SP to 10FF
X# 	mem[SP] <= B
X# 	B = A; SP++ to 20FF
X# 	mem[SP] <= B
X# 	B = M; A = PC (400F) ; M = SP+1 
X# 	PC = mem[2]
X# 	IACK = 1 
X# 	IACK = 0
X#
X# 
X# (These conventions apply only to MERCURY simulations)
X# convention: all inputs to the processor change when CLK signal is low
X# and these are sampled by the processor in the following rising edge of CLK
X#
X#
X#
X#	               +-------------+                     +-------------
X#	              /               \                   /
X#	             /                 \                 /
X#	            /^                  \               /
X#	-^--------+/ |                   +-------------+
X#        |           |
X# inputs change      sampled
X#
X# Note for ariadne simulations CLK EN RESET signals are ignored
X# a "-" implies input driver for that signal is disabled
X#
X#.inputs CLK EN RESET reset[0:0] irq[0:0] data[0:0] data[1:1] data[2:2] data[3:3] data[4:4] data[5:5] data[6:6] data[7:7] data[8:8] data[9:9] data[10:10] data[11:11] data[12:12] data[13:13] data[14:14] data[15:15] ;
X##
X#111 00 ---- ---- ---- ----;
X#010 00 ---- ---- ---- ----;
X#110 00 ---- ---- ---- ----;
X#010 00 ---- ---- ---- ----;
X#110 00 ---- ---- ---- ----;
X## reset start
X#010 10 ---- ---- ---- ----;
X#110 10 0000 0000 0000 0000;
X#010 10 0000 0000 0000 0000;
X## rd = 1 in this clock
X#110 10 0000 0000 0000 0000;
X## reset end
X#010 00 0000 0000 0000 1111;
X## rd = 0 in this clock
X#110 00 0000 0000 0000 1111;
X#010 00 0000 0000 0000 1111;
X## rd = 1 now for address = 1
X#110 00 0000 0000 0000 0000;
X#010 00 0000 0000 1111 1111;
X## rd = 0 
X#110 00 0000 0000 1111 1111;
X#010 00 0000 0000 1111 1111;
X## now reset is sampled low
X## rd = 1 address = p
X## opcode = 6 ; load a = 000F; next opcode = F ; shr 1; incr a
X#110 00 0000 0000 0000 0000;
X#010 00 0110 1000 0100 1111;
X## rd = 0
X#110 00 0110 1000 0100 1111;
X#010 00 0110 1000 0100 1111;
X#110 00 0000 0000 0000 0000;
X#010 00 0000 0000 0000 1111;
X#110 00 0000 0000 0000 1111;
X#010 00 0000 0000 0000 1111;
X#110 00 0000 0000 0000 0000;
X#010 00 0000 0000 0000 0000;
X#110 00 0000 0000 0000 0000;
X#010 00 0000 0000 0000 0000;
X#110 00 0000 0000 0000 0000;
X#010 00 0000 0000 0000 0000;
X#110 00 0000 0000 0000 0000;
X#010 00 0000 0000 0000 0000;
X#110 00 0000 0000 0000 0000;
X#010 00 0000 0000 0000 0000;
X#
X############################################################################
X# pattern file for ARIADNE
X############################################################################
X#
X# memory contents: (all in Hex) <lsb:msb>
X#
X# 0000		000F (PC)
X# 1000		00FF (SP)
X# 2000		0FFF (Starting Address for interrupt service routine)
X# 000F		612F
X#
X# This test program loads the PC and STACK pointer, fetches an instruction
X# that contains four successive opcodes as follows:
X#
X#	a <= mem[0000] = 000F
X#	shr 1
X#	a++
X#	b = !(a & b)
X#	a = b
X#	b <= mem[s]
X#	s--
X#	a <= mem[a]
X#	b = b+a
X#	a = b
X#	b <= mem[s]
X#	s--
X#
X# expected results: 
X#
X# load PC = 000F; SP = 00FF; 
X# load I = 612F; 
X# increment PC = 100F
X# execute first opcode (6) : load A = 612F; shift out first byte from I
X# execute second opcode (12): a = a << 1 => a = B097
X# execute third opcode (F): a++ => a = C097
X#
X# interrupt processing:
X#
X# 	increment SP to 10FF
X# 	mem[SP] <= B
X# 	B = A; SP++ to 20FF
X# 	mem[SP] <= B
X# 	B = M; A = PC (400F) ; M = SP+1 
X# 	PC = mem[2]
X# 	IACK = 1 
X# 	IACK = 0
X#
X#
X.inputs CLK EN RESET reset[0:0] irq[0:0] data[0:0] data[1:1] data[2:2] data[3:3] data[4:4] data[5:5] data[6:6] data[7:7] data[8:8] data[9:9] data[10:10] data[11:11] data[12:12] data[13:13] data[14:14] data[15:15] ;
X#
X1 10 00 0000 0000 0000 0000;
X1 10 00 ---- ---- ---- ----;
X# reset sequence
X# rd = 1 
X# rd = 0 ; data = 000F
X# rd = 1 ; address = 1
X# rd = 0 ; data = 00FF
X1 10 10 ---- ---- ---- ----;
X1 10 10 0000 0000 0000 1111;
X1 10 10 ---- ---- ---- ----;
X1 10 10 0000 0000 1111 1111;
X# reset end
X1 10 00 ---- ---- ---- ----;
X# rd = 1 ; address = p = 000F
X# rd = 0 ; data = 612F
X1 10 00 ---- ---- ---- ----;
X1 10 00 0110 1000 0100 1111;
X#
X# now Instr Reg has 3 instructions to work on
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X# another 3 instructions 
X1 10 00 1000 0000 0110 0111;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 1000 0100 1100 0010;
X1 10 00 ---- ---- ---- ----;
X1 10 00 1010 0110 1110 0001;
X1 10 00 ---- ---- ---- ----;
X1 10 00 0000 0000 0000 0000;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X# let us now raise the interrupt request
X1 10 01 ---- ---- ---- ----;
X1 10 01 ---- ---- ---- ----;
X1 10 01 ---- ---- ---- ----;
X1 10 01 ---- ---- ---- ----;
X1 10 01 ---- ---- ---- ----;
X1 10 01 ---- ---- ---- ----;
X1 10 01 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
X1 10 00 ---- ---- ---- ----;
END_OF_FILE
if test 5612 -ne `wc -c <'frisc/frisc.pat'`; then
    echo shar: \"'frisc/frisc.pat'\" unpacked with wrong size!
fi
# end of 'frisc/frisc.pat'
fi
if test -f 'frisc/frisc.mon' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'frisc/frisc.mon'\"
else
echo shar: Extracting \"'frisc/frisc.mon'\" \(1678 characters\)
sed "s/^X//" >'frisc/frisc.mon' <<'END_OF_FILE'
Xreset[0:0]
Xirq[0:0]
Xiack[0:0]
Xrd[0:0]
Xwr[0:0]
XHEX ADDR0 address[0:0] address[1:1] address[2:2] address[3:3]
XHEX ADDR1 address[4:4] address[5:5] address[6:6] address[7:7]
XHEX ADDR2 address[8:8] address[9:9] address[10:10] address[11:11]
XHEX ADDR3 address[12:12] address[13:13] address[14:14] address[15:15]
XHEX peakI0 peaki[0:0] peaki[1:1] peaki[2:2] peaki[3:3]
XHEX peakI1 peaki[4:4] peaki[5:5] peaki[6:6] peaki[7:7]
XHEX peakI2 peaki[8:8] peaki[9:9] peaki[10:10] peaki[11:11]
XHEX peakI3 peaki[12:12] peaki[13:13] peaki[14:14] peaki[15:15]
XHEX peakP0 peakp[0:0] peakp[1:1] peakp[2:2] peakp[3:3]
XHEX peakP1 peakp[4:4] peakp[5:5] peakp[6:6] peakp[7:7]
XHEX peakP2 peakp[8:8] peakp[9:9] peakp[10:10] peakp[11:11]
XHEX peakP3 peakp[12:12] peakp[13:13] peakp[14:14] peakp[15:15]
XHEX peakS0 peaks[0:0] peaks[1:1] peaks[2:2] peaks[3:3]
XHEX peakS1 peaks[4:4] peaks[5:5] peaks[6:6] peaks[7:7]
XHEX peakS2 peaks[8:8] peaks[9:9] peaks[10:10] peaks[11:11]
XHEX peakS3 peaks[12:12] peaks[13:13] peaks[14:14] peaks[15:15]
XHEX peakA0 peaka[0:0] peaka[1:1] peaka[2:2] peaka[3:3]
XHEX peakA1 peaka[4:4] peaka[5:5] peaka[6:6] peaka[7:7]
XHEX peakA2 peaka[8:8] peaka[9:9] peaka[10:10] peaka[11:11]
XHEX peakA3 peaka[12:12] peaka[13:13] peaka[14:14] peaka[15:15]
XHEX peakB0 peakb[0:0] peakb[1:1] peakb[2:2] peakb[3:3]
XHEX peakB1 peakb[4:4] peakb[5:5] peakb[6:6] peakb[7:7]
XHEX peakB2 peakb[8:8] peakb[9:9] peakb[10:10] peakb[11:11]
XHEX peakB3 peakb[12:12] peakb[13:13] peakb[14:14] peakb[15:15]
XHEX DATA0 data[0:0] data[1:1] data[2:2] data[3:3]
XHEX DATA1 data[4:4] data[5:5] data[6:6] data[7:7]
XHEX DATA2 data[8:8] data[9:9] data[10:10] data[11:11]
XHEX DATA3 data[12:12] data[13:13] data[14:14] data[15:15]
END_OF_FILE
if test 1678 -ne `wc -c <'frisc/frisc.mon'`; then
    echo shar: \"'frisc/frisc.mon'\" unpacked with wrong size!
fi
# end of 'frisc/frisc.mon'
fi
if test -f 'frisc/add_16.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'frisc/add_16.sif'\"
else
echo shar: Extracting \"'frisc/add_16.sif'\" \(7125 characters\)
sed "s/^X//" >'frisc/add_16.sif' <<'END_OF_FILE'
X#
X#	Sif model add_16	Printed Tue Jul 24 15:04:10 1990
X#
X.model add_16 sequencing ; 
X  .inputs op1[16] op2[16] ;
X  .outputs return_value[17] ;
X    #	Index 1
X    .polargraph 1 3;
X    .variable T92 T88 T82 T76 
X	T70 T64 T58 T52 
X	T46 T40 T34 T28 
X	T22 T16 T10 T4 
X	T1 ;
X    #	3 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 operation;
X      .inputs op1[0:0] op2[0:0] op1[1:1] op2[1:1] 
X	op1[2:2] op2[2:2] op1[3:3] op2[3:3] 
X	op1[4:4] op2[4:4] op1[5:5] op2[5:5] 
X	op1[6:6] op2[6:6] op1[7:7] op2[7:7] 
X	op1[8:8] op2[8:8] op1[9:9] op2[9:9] 
X	op1[10:10] op2[10:10] op1[11:11] op2[11:11] 
X	op1[12:12] op2[12:12] op1[13:13] op2[13:13] 
X	op1[14:14] op2[14:14] op1[15:15] op2[15:15] 
X	;
X      .outputs T1[0:0] T4[0:0] T10[0:0] T16[0:0] 
X	T22[0:0] T28[0:0] T34[0:0] T40[0:0] 
X	T46[0:0] T52[0:0] T58[0:0] T64[0:0] 
X	T70[0:0] T76[0:0] T82[0:0] T88[0:0] 
X	T92[0:0] ;
X      .successors 3 ;	#  predecessors 1 
X      .operation logic 1 ;
X        #	Expression 0
X        T1[0:0] = ((op1[0:0]  op2[0:0]' )+(op1[0:0]'  op2[0:0] ));
X        T2[0:0] = (op1[0:0]  op2[0:0] );
X        T3[0:0] = ((op1[1:1]  op2[1:1]' )+(op1[1:1]'  op2[1:1] ));
X        T4[0:0] = ((T3[0:0]  T2[0:0]' )+(T3[0:0]'  T2[0:0] ));
X        T5[0:0] = (op1[1:1]  op2[1:1] );
X        T6[0:0] = (op1[1:1] +op2[1:1] );
X        T7[0:0] = (T2[0:0]  T6[0:0] );
X        T8[0:0] = (T5[0:0] +T7[0:0] );
X        T9[0:0] = ((op1[2:2]  op2[2:2]' )+(op1[2:2]'  op2[2:2] ));
X        T10[0:0] = ((T9[0:0]  T8[0:0]' )+(T9[0:0]'  T8[0:0] ));
X        T11[0:0] = (op1[2:2]  op2[2:2] );
X        T12[0:0] = (op1[2:2] +op2[2:2] );
X        T13[0:0] = (T8[0:0]  T12[0:0] );
X        T14[0:0] = (T11[0:0] +T13[0:0] );
X        T15[0:0] = ((op1[3:3]  op2[3:3]' )+(op1[3:3]'  op2[3:3] ));
X        T16[0:0] = ((T15[0:0]  T14[0:0]' )+(T15[0:0]'  T14[0:0] ));
X        T17[0:0] = (op1[3:3]  op2[3:3] );
X        T18[0:0] = (op1[3:3] +op2[3:3] );
X        T19[0:0] = (T14[0:0]  T18[0:0] );
X        T20[0:0] = (T17[0:0] +T19[0:0] );
X        T21[0:0] = ((op1[4:4]  op2[4:4]' )+(op1[4:4]'  op2[4:4] ));
X        T22[0:0] = ((T21[0:0]  T20[0:0]' )+(T21[0:0]'  T20[0:0] ));
X        T23[0:0] = (op1[4:4]  op2[4:4] );
X        T24[0:0] = (op1[4:4] +op2[4:4] );
X        T25[0:0] = (T20[0:0]  T24[0:0] );
X        T26[0:0] = (T23[0:0] +T25[0:0] );
X        T27[0:0] = ((op1[5:5]  op2[5:5]' )+(op1[5:5]'  op2[5:5] ));
X        T28[0:0] = ((T27[0:0]  T26[0:0]' )+(T27[0:0]'  T26[0:0] ));
X        T29[0:0] = (op1[5:5]  op2[5:5] );
X        T30[0:0] = (op1[5:5] +op2[5:5] );
X        T31[0:0] = (T26[0:0]  T30[0:0] );
X        T32[0:0] = (T29[0:0] +T31[0:0] );
X        T33[0:0] = ((op1[6:6]  op2[6:6]' )+(op1[6:6]'  op2[6:6] ));
X        T34[0:0] = ((T33[0:0]  T32[0:0]' )+(T33[0:0]'  T32[0:0] ));
X        T35[0:0] = (op1[6:6]  op2[6:6] );
X        T36[0:0] = (op1[6:6] +op2[6:6] );
X        T37[0:0] = (T32[0:0]  T36[0:0] );
X        T38[0:0] = (T35[0:0] +T37[0:0] );
X        T39[0:0] = ((op1[7:7]  op2[7:7]' )+(op1[7:7]'  op2[7:7] ));
X        T40[0:0] = ((T39[0:0]  T38[0:0]' )+(T39[0:0]'  T38[0:0] ));
X        T41[0:0] = (op1[7:7]  op2[7:7] );
X        T42[0:0] = (op1[7:7] +op2[7:7] );
X        T43[0:0] = (T38[0:0]  T42[0:0] );
X        T44[0:0] = (T41[0:0] +T43[0:0] );
X        T45[0:0] = ((op1[8:8]  op2[8:8]' )+(op1[8:8]'  op2[8:8] ));
X        T46[0:0] = ((T45[0:0]  T44[0:0]' )+(T45[0:0]'  T44[0:0] ));
X        T47[0:0] = (op1[8:8]  op2[8:8] );
X        T48[0:0] = (op1[8:8] +op2[8:8] );
X        T49[0:0] = (T44[0:0]  T48[0:0] );
X        T50[0:0] = (T47[0:0] +T49[0:0] );
X        T51[0:0] = ((op1[9:9]  op2[9:9]' )+(op1[9:9]'  op2[9:9] ));
X        T52[0:0] = ((T51[0:0]  T50[0:0]' )+(T51[0:0]'  T50[0:0] ));
X        T53[0:0] = (op1[9:9]  op2[9:9] );
X        T54[0:0] = (op1[9:9] +op2[9:9] );
X        T55[0:0] = (T50[0:0]  T54[0:0] );
X        T56[0:0] = (T53[0:0] +T55[0:0] );
X        T57[0:0] = ((op1[10:10]  op2[10:10]' )+(op1[10:10]'  op2[10:10] ));
X        T58[0:0] = ((T57[0:0]  T56[0:0]' )+(T57[0:0]'  T56[0:0] ));
X        T59[0:0] = (op1[10:10]  op2[10:10] );
X        T60[0:0] = (op1[10:10] +op2[10:10] );
X        T61[0:0] = (T56[0:0]  T60[0:0] );
X        T62[0:0] = (T59[0:0] +T61[0:0] );
X        T63[0:0] = ((op1[11:11]  op2[11:11]' )+(op1[11:11]'  op2[11:11] ));
X        T64[0:0] = ((T63[0:0]  T62[0:0]' )+(T63[0:0]'  T62[0:0] ));
X        T65[0:0] = (op1[11:11]  op2[11:11] );
X        T66[0:0] = (op1[11:11] +op2[11:11] );
X        T67[0:0] = (T62[0:0]  T66[0:0] );
X        T68[0:0] = (T65[0:0] +T67[0:0] );
X        T69[0:0] = ((op1[12:12]  op2[12:12]' )+(op1[12:12]'  op2[12:12] ));
X        T70[0:0] = ((T69[0:0]  T68[0:0]' )+(T69[0:0]'  T68[0:0] ));
X        T71[0:0] = (op1[12:12]  op2[12:12] );
X        T72[0:0] = (op1[12:12] +op2[12:12] );
X        T73[0:0] = (T68[0:0]  T72[0:0] );
X        T74[0:0] = (T71[0:0] +T73[0:0] );
X        T75[0:0] = ((op1[13:13]  op2[13:13]' )+(op1[13:13]'  op2[13:13] ));
X        T76[0:0] = ((T75[0:0]  T74[0:0]' )+(T75[0:0]'  T74[0:0] ));
X        T77[0:0] = (op1[13:13]  op2[13:13] );
X        T78[0:0] = (op1[13:13] +op2[13:13] );
X        T79[0:0] = (T74[0:0]  T78[0:0] );
X        T80[0:0] = (T77[0:0] +T79[0:0] );
X        T81[0:0] = ((op1[14:14]  op2[14:14]' )+(op1[14:14]'  op2[14:14] ));
X        T82[0:0] = ((T81[0:0]  T80[0:0]' )+(T81[0:0]'  T80[0:0] ));
X        T83[0:0] = (op1[14:14]  op2[14:14] );
X        T84[0:0] = (op1[14:14] +op2[14:14] );
X        T85[0:0] = (T80[0:0]  T84[0:0] );
X        T86[0:0] = (T83[0:0] +T85[0:0] );
X        T87[0:0] = ((op1[15:15]  op2[15:15]' )+(op1[15:15]'  op2[15:15] ));
X        T88[0:0] = ((T87[0:0]  T86[0:0]' )+(T87[0:0]'  T86[0:0] ));
X        T89[0:0] = (op1[15:15]  op2[15:15] );
X        T90[0:0] = (op1[15:15] +op2[15:15] );
X        T91[0:0] = (T86[0:0]  T90[0:0] );
X        T92[0:0] = (T89[0:0] +T91[0:0] );
X        .attribute delay 31 level;
X        .attribute area 400 literal;
X      .endoperation;
X    .endnode;
X
X    .node 3 nop;	#	sink node
X      .successors ;	#  predecessors 2 
X    .endnode;
X
X    .attribute hercules direct_connect return_value[0:0] T1[0:0] ;
X    .attribute hercules direct_connect return_value[1:1] T4[0:0] ;
X    .attribute hercules direct_connect return_value[2:2] T10[0:0] ;
X    .attribute hercules direct_connect return_value[3:3] T16[0:0] ;
X    .attribute hercules direct_connect return_value[4:4] T22[0:0] ;
X    .attribute hercules direct_connect return_value[5:5] T28[0:0] ;
X    .attribute hercules direct_connect return_value[6:6] T34[0:0] ;
X    .attribute hercules direct_connect return_value[7:7] T40[0:0] ;
X    .attribute hercules direct_connect return_value[8:8] T46[0:0] ;
X    .attribute hercules direct_connect return_value[9:9] T52[0:0] ;
X    .attribute hercules direct_connect return_value[10:10] T58[0:0] ;
X    .attribute hercules direct_connect return_value[11:11] T64[0:0] ;
X    .attribute hercules direct_connect return_value[12:12] T70[0:0] ;
X    .attribute hercules direct_connect return_value[13:13] T76[0:0] ;
X    .attribute hercules direct_connect return_value[14:14] T82[0:0] ;
X    .attribute hercules direct_connect return_value[15:15] T88[0:0] ;
X    .attribute hercules direct_connect return_value[16:16] T92[0:0] ;
X    .endpolargraph;
X.endmodel add_16 ;
END_OF_FILE
if test 7125 -ne `wc -c <'frisc/add_16.sif'`; then
    echo shar: \"'frisc/add_16.sif'\" unpacked with wrong size!
fi
# end of 'frisc/add_16.sif'
fi
if test -f 'frisc/frisc.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'frisc/frisc.sif'\"
else
echo shar: Extracting \"'frisc/frisc.sif'\" \(190703 characters\)
sed "s/^X//" >'frisc/frisc.sif' <<'END_OF_FILE'
X#
X#	Sif model frisc	Printed Tue Jul 24 15:04:42 1990
X#
X.model frisc sequencing process; 
X  .inputs port reset port irq ;
X  .outputs port rd port wr port iack port address[16] 
X	port peaki[16] port peakp[16] port peaks[16] port peaka[16] 
X	port peakb[16] ;
X  .inouts port data[16] ;
X    #	Index 1
X    .polargraph 1 5;
X    .variable M6[16] M7[16] M8[16] M9[16] 
X	M10[16] M11[16] T2[16] T3[16] 
X	X188 X187 X186 X185 
X	X184 X183 X182 X181 
X	X180 X179 X178 X177 
X	X176 X175 X174 X173 
X	X172 X171 X170 X169 
X	X168 X167 X166 X165 
X	X164 X163 X162 X161 
X	X160 X159 X158 X157 
X	X156 X155 X154 X153 
X	X152 X151 X150 X149 
X	X148 X147 X146 X145 
X	X144 X143 X142 X141 
X	X140 X139 X138 X137 
X	X136 X135 X134 X133 
X	X132 X131 X130 X129 
X	X128 X127 X126 X125 
X	X124 X123 X122 X121 
X	X120 X119 X118 X117 
X	X116 X115 X114 X113 
X	X112 X111 X110 X109 
X	M3[16] X108 X107 X106 
X	X105 X104 X103 X102 
X	X101 X100 X99 X98 
X	X97 X96 X95 X94 
X	X93 T36 T21[17] T18[17] 
X	T19[17] T16[16] T20[16] T17[16] 
X	T24[17] T50[17] T47[17] T41[17] 
X	T39[17] T35[17] T33[17] T29[17] 
X	T44[16] T43[17] T51[17] T48[17] 
X	T31[16] T26[16] T23[16] T49[16] 
X	T46[16] T40[16] T38[16] T34[16] 
X	T32[16] T28[16] T45[17] T42[17] 
X	T30[17] T27[17] T25[17] T22[17] 
X	T14[4] T13[4] T53 T11[17] 
X	X80 X79 X78 X77 
X	X76 X75 X74 X73 
X	X72 X71 X70 X69 
X	X68 X67 X66 X65 
X	X64 X63 X62 X61 
X	X60 X59 X58 X57 
X	X56 X55 X54 X53 
X	X52 X51 X50 X49 
X	X48 X47 X46 X45 
X	X44 X43 X42 X41 
X	X40 X39 X38 X37 
X	X36 X35 X34 X33 
X	X32 X31 X30 X29 
X	X28 X27 X26 X25 
X	X24 X23 X22 X21 
X	X20 X19 X18 X17 
X	T7[17] T12 T10 M2[16] 
X	T9[16] X1 X2 X3 
X	X4 X5 X6 X7 
X	X8 X9 X10 X11 
X	X12 X13 X14 X15 
X	X16 M1[16] T8[16] T6[17] 
X	T5[17] T4 T1 ;
X    .variable register t[16] register i[16] register b[16] register a[16] 
X	register m[16] register s[16] register p[16] ;
X    #	5 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 cond;
X      .successors 3 ;	#  predecessors 1 
X      .cond reset[0:0] T1[0:0] ;	#	Latched
X      .case 1 ;
X        #	Index 2
X        .polargraph 1 10;
X        #	10 nodes
X        .node 1 nop;	#	source node
X          .successors 2 3 ;
X        .endnode;
X
X        .node 2 operation;
X          .inputs 0b1 ;
X          .outputs rd[0:0] ;
X          .successors 4 5 ;	#  predecessors 1 
X          .attribute constraint delay 2 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 3 operation;
X          .inputs 0b0000000000000000 ;
X          .outputs address[0:15] ;
X          .successors 4 5 ;	#  predecessors 1 
X          .attribute constraint delay 3 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 4 operation;
X          .inputs 0b0 ;
X          .outputs rd[0:0] ;
X          .successors 6 7 ;	#  predecessors 2 3 
X          .attribute constraint delay 4 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 5 operation;
X          .inputs data[0:15] ;
X          .outputs T2[0:15] ;
X          .successors 6 7 ;	#  predecessors 2 3 
X          .attribute constraint delay 5 1 cycles;
X          .operation read;
X        .endnode;
X
X        .node 6 operation;
X          .inputs 0b1 ;
X          .outputs rd[0:0] ;
X          .successors 8 9 ;	#  predecessors 4 5 
X          .attribute constraint delay 6 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 7 operation;
X          .inputs 0b1000000000000000 ;
X          .outputs address[0:15] ;
X          .successors 8 9 ;	#  predecessors 4 5 
X          .attribute constraint delay 7 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 8 operation;
X          .inputs 0b0 ;
X          .outputs rd[0:0] ;
X          .successors 10 ;	#  predecessors 6 7 
X          .attribute constraint delay 8 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 9 operation;
X          .inputs data[0:15] ;
X          .outputs T3[0:15] ;
X          .successors 10 ;	#  predecessors 6 7 
X          .attribute constraint delay 9 1 cycles;
X          .operation read;
X        .endnode;
X
X        .node 10 nop;	#	sink node
X          .successors ;	#  predecessors 8 9 
X        .endnode;
X
X        .attribute constraint delay 2 1 cycles;
X        .attribute constraint delay 3 1 cycles;
X        .attribute constraint delay 4 1 cycles;
X        .attribute constraint delay 5 1 cycles;
X        .attribute constraint delay 6 1 cycles;
X        .attribute constraint delay 7 1 cycles;
X        .attribute constraint delay 8 1 cycles;
X        .attribute constraint delay 9 1 cycles;
X        .endpolargraph;
X      .endcase;
X      .case 0 ;
X        #	Index 3
X        .polargraph 1 11;
X        #	11 nodes
X        .node 1 nop;	#	source node
X          .successors 2 ;
X        .endnode;
X
X        .node 2 cond;
X          .successors 3 4 ;	#  predecessors 1 
X          .cond irq[0:0] T4[0:0] ;	#	Latched
X          .case 1 ;
X            #	Index 4
X            .polargraph 1 19;
X            #	19 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 proc;
X              .inputs s[0:15] 0b1000000000000000 ;
X              .outputs T5[0:16] ;
X              .successors 3 4 5 ;	#  predecessors 1 
X              .proc add with (16);
X            .endnode;
X
X            .node 3 operation;
X              .inputs 0b1 ;
X              .outputs wr[0:0] ;
X              .successors 6 ;	#  predecessors 2 
X              .attribute constraint delay 3 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 4 operation;
X              .inputs T5[0:15] ;
X              .outputs address[0:15] ;
X              .successors 6 ;	#  predecessors 2 
X              .attribute constraint delay 4 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 5 operation;
X              .inputs b[0:15] ;
X              .outputs data[0:15] ;
X              .successors 6 ;	#  predecessors 2 
X              .attribute constraint delay 5 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 6 operation;
X              .inputs 0b0 ;
X              .outputs wr[0:0] ;
X              .successors 7 ;	#  predecessors 3 4 5 
X              .attribute constraint delay 6 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 7 proc;
X              .inputs T5[0:15] 0b1000000000000000 ;
X              .outputs T6[0:16] ;
X              .successors 8 9 10 ;	#  predecessors 6 
X              .proc add with (16);
X            .endnode;
X
X            .node 8 operation;
X              .inputs 0b1 ;
X              .outputs wr[0:0] ;
X              .successors 11 ;	#  predecessors 7 
X              .attribute constraint delay 8 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 9 operation;
X              .inputs T6[0:15] ;
X              .outputs address[0:15] ;
X              .successors 11 ;	#  predecessors 7 
X              .attribute constraint delay 9 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 10 operation;
X              .inputs a[0:15] ;
X              .outputs data[0:15] ;
X              .successors 11 ;	#  predecessors 7 
X              .attribute constraint delay 10 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 11 operation;
X              .inputs 0b0 ;
X              .outputs wr[0:0] ;
X              .successors 12 ;	#  predecessors 8 9 10 
X              .attribute constraint delay 11 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 12 proc;
X              .inputs T6[0:15] 0b1000000000000000 ;
X              .outputs T7[0:16] ;
X              .successors 13 14 ;	#  predecessors 11 
X              .proc add with (16);
X            .endnode;
X
X            .node 13 operation;
X              .inputs 0b1 ;
X              .outputs rd[0:0] ;
X              .successors 15 16 ;	#  predecessors 12 
X              .attribute constraint delay 13 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 14 operation;
X              .inputs 0b0100000000000000 ;
X              .outputs address[0:15] ;
X              .successors 15 16 ;	#  predecessors 12 
X              .attribute constraint delay 14 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 15 operation;
X              .inputs 0b0 ;
X              .outputs rd[0:0] ;
X              .successors 17 ;	#  predecessors 13 14 
X              .attribute constraint delay 15 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 16 operation;
X              .inputs data[0:15] ;
X              .outputs T8[0:15] ;
X              .successors 17 ;	#  predecessors 13 14 
X              .attribute constraint delay 16 1 cycles;
X              .operation read;
X            .endnode;
X
X            .node 17 operation;
X              .inputs 0b1 ;
X              .outputs iack[0:0] ;
X              .successors 18 ;	#  predecessors 15 16 
X              .attribute constraint delay 17 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 18 operation;
X              .inputs 0b0 ;
X              .outputs iack[0:0] ;
X              .successors 19 ;	#  predecessors 17 
X              .attribute constraint delay 18 1 cycles;
X              .operation write;
X            .endnode;
X
X            .node 19 nop;	#	sink node
X              .successors ;	#  predecessors 18 
X            .endnode;
X
X            .attribute constraint delay 3 1 cycles;
X            .attribute constraint delay 4 1 cycles;
X            .attribute constraint delay 5 1 cycles;
X            .attribute constraint delay 6 1 cycles;
X            .attribute constraint delay 8 1 cycles;
X            .attribute constraint delay 9 1 cycles;
X            .attribute constraint delay 10 1 cycles;
X            .attribute constraint delay 11 1 cycles;
X            .attribute constraint delay 13 1 cycles;
X            .attribute constraint delay 14 1 cycles;
X            .attribute constraint delay 15 1 cycles;
X            .attribute constraint delay 16 1 cycles;
X            .attribute constraint delay 17 1 cycles;
X            .attribute constraint delay 18 1 cycles;
X            .endpolargraph;
X          .endcase;
X          .case 0 ;
X            #	Index 5
X            .polargraph 1 2;
X            #	2 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 nop;	#	sink node
X              .successors ;	#  predecessors 1 
X            .endnode;
X
X            .endpolargraph;
X          .endcase;
X          .endcond;
X        .endnode;
X
X        .node 3 operation;
X          .inputs 0b1 ;
X          .outputs rd[0:0] ;
X          .successors 6 7 ;	#  predecessors 2 
X          .attribute constraint delay 3 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 4 operation;
X          .inputs T4[0:0] T8[15:15] p[15:15] T8[14:14] 
X	p[14:14] T8[13:13] p[13:13] T8[12:12] 
X	p[12:12] T8[11:11] p[11:11] T8[10:10] 
X	p[10:10] T8[9:9] p[9:9] T8[8:8] 
X	p[8:8] T8[7:7] p[7:7] T8[6:6] 
X	p[6:6] T8[5:5] p[5:5] T8[4:4] 
X	p[4:4] T8[3:3] p[3:3] T8[2:2] 
X	p[2:2] T8[1:1] p[1:1] T8[0:0] 
X	p[0:0] ;
X          .outputs M1[0:0] M1[1:1] M1[2:2] M1[3:3] 
X	M1[4:4] M1[5:5] M1[6:6] M1[7:7] 
X	M1[8:8] M1[9:9] M1[10:10] M1[11:11] 
X	M1[12:12] M1[13:13] M1[14:14] M1[15:15] 
X	X1[0:0] X2[0:0] X3[0:0] X4[0:0] 
X	X5[0:0] X6[0:0] X7[0:0] X8[0:0] 
X	X9[0:0] X10[0:0] X11[0:0] X12[0:0] 
X	X13[0:0] X14[0:0] X15[0:0] X16[0:0] 
X	;
X          .successors 5 ;	#  predecessors 2 
X          .operation logic 1 ;
X            #	Expression 0
X            M1[0:0] = X16[0:0] ;
X            M1[1:1] = X15[0:0] ;
X            M1[2:2] = X14[0:0] ;
X            M1[3:3] = X13[0:0] ;
X            M1[4:4] = X12[0:0] ;
X            M1[5:5] = X11[0:0] ;
X            M1[6:6] = X10[0:0] ;
X            M1[7:7] = X9[0:0] ;
X            M1[8:8] = X8[0:0] ;
X            M1[9:9] = X7[0:0] ;
X            M1[10:10] = X6[0:0] ;
X            M1[11:11] = X5[0:0] ;
X            M1[12:12] = X4[0:0] ;
X            M1[13:13] = X3[0:0] ;
X            M1[14:14] = X2[0:0] ;
X            M1[15:15] = X1[0:0] ;
X            X1[0:0] = ((V1_T4_0_0[0:0]  T8[15:15] )+(V0_T4_0_0[0:0]  p[15:15] ));
X            X2[0:0] = ((V1_T4_0_0[0:0]  T8[14:14] )+(V0_T4_0_0[0:0]  p[14:14] ));
X            X3[0:0] = ((V1_T4_0_0[0:0]  T8[13:13] )+(V0_T4_0_0[0:0]  p[13:13] ));
X            X4[0:0] = ((V1_T4_0_0[0:0]  T8[12:12] )+(V0_T4_0_0[0:0]  p[12:12] ));
X            X5[0:0] = ((V1_T4_0_0[0:0]  T8[11:11] )+(V0_T4_0_0[0:0]  p[11:11] ));
X            X6[0:0] = ((V1_T4_0_0[0:0]  T8[10:10] )+(V0_T4_0_0[0:0]  p[10:10] ));
X            X7[0:0] = ((V1_T4_0_0[0:0]  T8[9:9] )+(V0_T4_0_0[0:0]  p[9:9] ));
X            X8[0:0] = ((V1_T4_0_0[0:0]  T8[8:8] )+(V0_T4_0_0[0:0]  p[8:8] ));
X            X9[0:0] = ((V1_T4_0_0[0:0]  T8[7:7] )+(V0_T4_0_0[0:0]  p[7:7] ));
X            X10[0:0] = ((V1_T4_0_0[0:0]  T8[6:6] )+(V0_T4_0_0[0:0]  p[6:6] ));
X            X11[0:0] = ((V1_T4_0_0[0:0]  T8[5:5] )+(V0_T4_0_0[0:0]  p[5:5] ));
X            X12[0:0] = ((V1_T4_0_0[0:0]  T8[4:4] )+(V0_T4_0_0[0:0]  p[4:4] ));
X            X13[0:0] = ((V1_T4_0_0[0:0]  T8[3:3] )+(V0_T4_0_0[0:0]  p[3:3] ));
X            X14[0:0] = ((V1_T4_0_0[0:0]  T8[2:2] )+(V0_T4_0_0[0:0]  p[2:2] ));
X            X15[0:0] = ((V1_T4_0_0[0:0]  T8[1:1] )+(V0_T4_0_0[0:0]  p[1:1] ));
X            X16[0:0] = ((V1_T4_0_0[0:0]  T8[0:0] )+(V0_T4_0_0[0:0]  p[0:0] ));
X            V0_T4_0_0[0:0] = T4[0:0]' ;
X            V1_T4_0_0[0:0] = T4[0:0] ;
X            .attribute delay 2 level;
X            .attribute area 130 literal;
X          .endoperation;
X        .endnode;
X
X        .node 5 operation;
X          .inputs M1[0:15] ;
X          .outputs address[0:15] ;
X          .successors 6 7 ;	#  predecessors 4 
X          .attribute constraint delay 5 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 6 operation;
X          .inputs 0b0 ;
X          .outputs rd[0:0] ;
X          .successors 8 ;	#  predecessors 3 5 
X          .attribute constraint delay 6 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 7 operation;
X          .inputs data[0:15] ;
X          .outputs T9[0:15] ;
X          .successors 8 ;	#  predecessors 3 5 
X          .attribute constraint delay 7 1 cycles;
X          .operation read;
X        .endnode;
X
X        .node 8 operation;
X          .inputs X16[0:0] X15[0:0] X14[0:0] X13[0:0] 
X	X12[0:0] X11[0:0] X10[0:0] X9[0:0] 
X	X8[0:0] X7[0:0] X6[0:0] X5[0:0] 
X	X4[0:0] X3[0:0] X2[0:0] X1[0:0] 
X	T9[0:0] T9[1:1] T9[2:2] T9[3:3] 
X	T9[4:4] T9[5:5] T9[6:6] T9[7:7] 
X	T9[8:8] T9[9:9] T9[10:10] T9[11:11] 
X	T9[12:12] T9[13:13] T9[14:14] T9[15:15] 
X	;
X          .outputs M2[0:0] M2[1:1] M2[2:2] M2[3:3] 
X	M2[4:4] M2[5:5] M2[6:6] M2[7:7] 
X	M2[8:8] M2[9:9] M2[10:10] M2[11:11] 
X	M2[12:12] M2[13:13] M2[14:14] M2[15:15] 
X	T10[0:0] ;
X          .successors 9 ;	#  predecessors 6 7 
X          .operation logic 2 ;
X            #	Expression 0
X            M2[0:0] = X16[0:0] ;
X            M2[1:1] = X15[0:0] ;
X            M2[2:2] = X14[0:0] ;
X            M2[3:3] = X13[0:0] ;
X            M2[4:4] = X12[0:0] ;
X            M2[5:5] = X11[0:0] ;
X            M2[6:6] = X10[0:0] ;
X            M2[7:7] = X9[0:0] ;
X            M2[8:8] = X8[0:0] ;
X            M2[9:9] = X7[0:0] ;
X            M2[10:10] = X6[0:0] ;
X            M2[11:11] = X5[0:0] ;
X            M2[12:12] = X4[0:0] ;
X            M2[13:13] = X3[0:0] ;
X            M2[14:14] = X2[0:0] ;
X            M2[15:15] = X1[0:0] ;
X            T10[0:0] = (V0000000000000000_T9_0_15[0:0] )';
X            V0000000000000000_T9_0_15[0:0] = (((((((((((((((T9[0:0]'  T9[1:1]' ) T9[2:2]' ) T9[3:3]' ) T9[4:4]' ) T9[5:5]' ) T9[6:6]' ) T9[7:7]' ) T9[8:8]' ) T9[9:9]' ) T9[10:10]' ) T9[11:11]' ) T9[12:12]' ) T9[13:13]' ) T9[14:14]' ) T9[15:15]' );
X            .attribute delay 16 level;
X            .attribute area 49 literal;
X          .endoperation;
X        .endnode;
X
X        .node 9 proc;
X          .inputs M2[0:15] 0b1000000000000000 ;
X          .outputs T11[0:16] ;
X          .successors 10 ;	#  predecessors 8 
X          .proc add with (16);
X        .endnode;
X
X        .node 10 cond;
X          .successors 11 ;	#  predecessors 9 
X          .cond T10[0:0] T12[0:0] ;	#	Latched
X          .case 1 ;
X            #	Index 6
X            .polargraph 1 5;
X            #	5 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 operation;
X              .inputs T4[0:0] m[15:15] b[15:15] m[14:14] 
X	b[14:14] m[13:13] b[13:13] m[12:12] 
X	b[12:12] m[11:11] b[11:11] m[10:10] 
X	b[10:10] m[9:9] b[9:9] m[8:8] 
X	b[8:8] m[7:7] b[7:7] m[6:6] 
X	b[6:6] m[5:5] b[5:5] m[4:4] 
X	b[4:4] m[3:3] b[3:3] m[2:2] 
X	b[2:2] m[1:1] b[1:1] m[0:0] 
X	b[0:0] p[15:15] a[15:15] p[14:14] 
X	a[14:14] p[13:13] a[13:13] p[12:12] 
X	a[12:12] p[11:11] a[11:11] p[10:10] 
X	a[10:10] p[9:9] a[9:9] p[8:8] 
X	a[8:8] p[7:7] a[7:7] p[6:6] 
X	a[6:6] p[5:5] a[5:5] p[4:4] 
X	a[4:4] p[3:3] a[3:3] p[2:2] 
X	a[2:2] p[1:1] a[1:1] p[0:0] 
X	a[0:0] T7[15:15] T7[14:14] T7[13:13] 
X	T7[12:12] T7[11:11] T7[10:10] T7[9:9] 
X	T7[8:8] T7[7:7] T7[6:6] T7[5:5] 
X	T7[4:4] T7[3:3] T7[2:2] T7[1:1] 
X	T7[0:0] T6[15:15] s[15:15] T6[14:14] 
X	s[14:14] T6[13:13] s[13:13] T6[12:12] 
X	s[12:12] T6[11:11] s[11:11] T6[10:10] 
X	s[10:10] T6[9:9] s[9:9] T6[8:8] 
X	s[8:8] T6[7:7] s[7:7] T6[6:6] 
X	s[6:6] T6[5:5] s[5:5] T6[4:4] 
X	s[4:4] T6[3:3] s[3:3] T6[2:2] 
X	s[2:2] T6[1:1] s[1:1] T6[0:0] 
X	s[0:0] ;
X              .outputs X17[0:0] X18[0:0] X19[0:0] X20[0:0] 
X	X21[0:0] X22[0:0] X23[0:0] X24[0:0] 
X	X25[0:0] X26[0:0] X27[0:0] X28[0:0] 
X	X29[0:0] X30[0:0] X31[0:0] X32[0:0] 
X	X33[0:0] X34[0:0] X35[0:0] X36[0:0] 
X	X37[0:0] X38[0:0] X39[0:0] X40[0:0] 
X	X41[0:0] X42[0:0] X43[0:0] X44[0:0] 
X	X45[0:0] X46[0:0] X47[0:0] X48[0:0] 
X	X49[0:0] X50[0:0] X51[0:0] X52[0:0] 
X	X53[0:0] X54[0:0] X55[0:0] X56[0:0] 
X	X57[0:0] X58[0:0] X59[0:0] X60[0:0] 
X	X61[0:0] X62[0:0] X63[0:0] X64[0:0] 
X	X65[0:0] X66[0:0] X67[0:0] X68[0:0] 
X	X69[0:0] X70[0:0] X71[0:0] X72[0:0] 
X	X73[0:0] X74[0:0] X75[0:0] X76[0:0] 
X	X77[0:0] X78[0:0] X79[0:0] X80[0:0] 
X	;
X              .successors 3 ;	#  predecessors 1 
X              .operation logic 3 ;
X                #	Expression 0
X                X17[0:0] = ((V1_T4_0_0[0:0]  m[15:15] )+(V0_T4_0_0[0:0]  b[15:15] ));
X                X18[0:0] = ((V1_T4_0_0[0:0]  m[14:14] )+(V0_T4_0_0[0:0]  b[14:14] ));
X                X19[0:0] = ((V1_T4_0_0[0:0]  m[13:13] )+(V0_T4_0_0[0:0]  b[13:13] ));
X                X20[0:0] = ((V1_T4_0_0[0:0]  m[12:12] )+(V0_T4_0_0[0:0]  b[12:12] ));
X                X21[0:0] = ((V1_T4_0_0[0:0]  m[11:11] )+(V0_T4_0_0[0:0]  b[11:11] ));
X                X22[0:0] = ((V1_T4_0_0[0:0]  m[10:10] )+(V0_T4_0_0[0:0]  b[10:10] ));
X                X23[0:0] = ((V1_T4_0_0[0:0]  m[9:9] )+(V0_T4_0_0[0:0]  b[9:9] ));
X                X24[0:0] = ((V1_T4_0_0[0:0]  m[8:8] )+(V0_T4_0_0[0:0]  b[8:8] ));
X                X25[0:0] = ((V1_T4_0_0[0:0]  m[7:7] )+(V0_T4_0_0[0:0]  b[7:7] ));
X                X26[0:0] = ((V1_T4_0_0[0:0]  m[6:6] )+(V0_T4_0_0[0:0]  b[6:6] ));
X                X27[0:0] = ((V1_T4_0_0[0:0]  m[5:5] )+(V0_T4_0_0[0:0]  b[5:5] ));
X                X28[0:0] = ((V1_T4_0_0[0:0]  m[4:4] )+(V0_T4_0_0[0:0]  b[4:4] ));
X                X29[0:0] = ((V1_T4_0_0[0:0]  m[3:3] )+(V0_T4_0_0[0:0]  b[3:3] ));
X                X30[0:0] = ((V1_T4_0_0[0:0]  m[2:2] )+(V0_T4_0_0[0:0]  b[2:2] ));
X                X31[0:0] = ((V1_T4_0_0[0:0]  m[1:1] )+(V0_T4_0_0[0:0]  b[1:1] ));
X                X32[0:0] = ((V1_T4_0_0[0:0]  m[0:0] )+(V0_T4_0_0[0:0]  b[0:0] ));
X                X33[0:0] = ((V1_T4_0_0[0:0]  p[15:15] )+(V0_T4_0_0[0:0]  a[15:15] ));
X                X34[0:0] = ((V1_T4_0_0[0:0]  p[14:14] )+(V0_T4_0_0[0:0]  a[14:14] ));
X                X35[0:0] = ((V1_T4_0_0[0:0]  p[13:13] )+(V0_T4_0_0[0:0]  a[13:13] ));
X                X36[0:0] = ((V1_T4_0_0[0:0]  p[12:12] )+(V0_T4_0_0[0:0]  a[12:12] ));
X                X37[0:0] = ((V1_T4_0_0[0:0]  p[11:11] )+(V0_T4_0_0[0:0]  a[11:11] ));
X                X38[0:0] = ((V1_T4_0_0[0:0]  p[10:10] )+(V0_T4_0_0[0:0]  a[10:10] ));
X                X39[0:0] = ((V1_T4_0_0[0:0]  p[9:9] )+(V0_T4_0_0[0:0]  a[9:9] ));
X                X40[0:0] = ((V1_T4_0_0[0:0]  p[8:8] )+(V0_T4_0_0[0:0]  a[8:8] ));
X                X41[0:0] = ((V1_T4_0_0[0:0]  p[7:7] )+(V0_T4_0_0[0:0]  a[7:7] ));
X                X42[0:0] = ((V1_T4_0_0[0:0]  p[6:6] )+(V0_T4_0_0[0:0]  a[6:6] ));
X                X43[0:0] = ((V1_T4_0_0[0:0]  p[5:5] )+(V0_T4_0_0[0:0]  a[5:5] ));
X                X44[0:0] = ((V1_T4_0_0[0:0]  p[4:4] )+(V0_T4_0_0[0:0]  a[4:4] ));
X                X45[0:0] = ((V1_T4_0_0[0:0]  p[3:3] )+(V0_T4_0_0[0:0]  a[3:3] ));
X                X46[0:0] = ((V1_T4_0_0[0:0]  p[2:2] )+(V0_T4_0_0[0:0]  a[2:2] ));
X                X47[0:0] = ((V1_T4_0_0[0:0]  p[1:1] )+(V0_T4_0_0[0:0]  a[1:1] ));
X                X48[0:0] = ((V1_T4_0_0[0:0]  p[0:0] )+(V0_T4_0_0[0:0]  a[0:0] ));
X                X49[0:0] = ((V1_T4_0_0[0:0]  T7[15:15] )+(V0_T4_0_0[0:0]  m[15:15] ));
X                X50[0:0] = ((V1_T4_0_0[0:0]  T7[14:14] )+(V0_T4_0_0[0:0]  m[14:14] ));
X                X51[0:0] = ((V1_T4_0_0[0:0]  T7[13:13] )+(V0_T4_0_0[0:0]  m[13:13] ));
X                X52[0:0] = ((V1_T4_0_0[0:0]  T7[12:12] )+(V0_T4_0_0[0:0]  m[12:12] ));
X                X53[0:0] = ((V1_T4_0_0[0:0]  T7[11:11] )+(V0_T4_0_0[0:0]  m[11:11] ));
X                X54[0:0] = ((V1_T4_0_0[0:0]  T7[10:10] )+(V0_T4_0_0[0:0]  m[10:10] ));
X                X55[0:0] = ((V1_T4_0_0[0:0]  T7[9:9] )+(V0_T4_0_0[0:0]  m[9:9] ));
X                X56[0:0] = ((V1_T4_0_0[0:0]  T7[8:8] )+(V0_T4_0_0[0:0]  m[8:8] ));
X                X57[0:0] = ((V1_T4_0_0[0:0]  T7[7:7] )+(V0_T4_0_0[0:0]  m[7:7] ));
X                X58[0:0] = ((V1_T4_0_0[0:0]  T7[6:6] )+(V0_T4_0_0[0:0]  m[6:6] ));
X                X59[0:0] = ((V1_T4_0_0[0:0]  T7[5:5] )+(V0_T4_0_0[0:0]  m[5:5] ));
X                X60[0:0] = ((V1_T4_0_0[0:0]  T7[4:4] )+(V0_T4_0_0[0:0]  m[4:4] ));
X                X61[0:0] = ((V1_T4_0_0[0:0]  T7[3:3] )+(V0_T4_0_0[0:0]  m[3:3] ));
X                X62[0:0] = ((V1_T4_0_0[0:0]  T7[2:2] )+(V0_T4_0_0[0:0]  m[2:2] ));
X                X63[0:0] = ((V1_T4_0_0[0:0]  T7[1:1] )+(V0_T4_0_0[0:0]  m[1:1] ));
X                X64[0:0] = ((V1_T4_0_0[0:0]  T7[0:0] )+(V0_T4_0_0[0:0]  m[0:0] ));
X                X65[0:0] = ((V1_T4_0_0[0:0]  T6[15:15] )+(V0_T4_0_0[0:0]  s[15:15] ));
X                X66[0:0] = ((V1_T4_0_0[0:0]  T6[14:14] )+(V0_T4_0_0[0:0]  s[14:14] ));
X                X67[0:0] = ((V1_T4_0_0[0:0]  T6[13:13] )+(V0_T4_0_0[0:0]  s[13:13] ));
X                X68[0:0] = ((V1_T4_0_0[0:0]  T6[12:12] )+(V0_T4_0_0[0:0]  s[12:12] ));
X                X69[0:0] = ((V1_T4_0_0[0:0]  T6[11:11] )+(V0_T4_0_0[0:0]  s[11:11] ));
X                X70[0:0] = ((V1_T4_0_0[0:0]  T6[10:10] )+(V0_T4_0_0[0:0]  s[10:10] ));
X                X71[0:0] = ((V1_T4_0_0[0:0]  T6[9:9] )+(V0_T4_0_0[0:0]  s[9:9] ));
X                X72[0:0] = ((V1_T4_0_0[0:0]  T6[8:8] )+(V0_T4_0_0[0:0]  s[8:8] ));
X                X73[0:0] = ((V1_T4_0_0[0:0]  T6[7:7] )+(V0_T4_0_0[0:0]  s[7:7] ));
X                X74[0:0] = ((V1_T4_0_0[0:0]  T6[6:6] )+(V0_T4_0_0[0:0]  s[6:6] ));
X                X75[0:0] = ((V1_T4_0_0[0:0]  T6[5:5] )+(V0_T4_0_0[0:0]  s[5:5] ));
X                X76[0:0] = ((V1_T4_0_0[0:0]  T6[4:4] )+(V0_T4_0_0[0:0]  s[4:4] ));
X                X77[0:0] = ((V1_T4_0_0[0:0]  T6[3:3] )+(V0_T4_0_0[0:0]  s[3:3] ));
X                X78[0:0] = ((V1_T4_0_0[0:0]  T6[2:2] )+(V0_T4_0_0[0:0]  s[2:2] ));
X                X79[0:0] = ((V1_T4_0_0[0:0]  T6[1:1] )+(V0_T4_0_0[0:0]  s[1:1] ));
X                X80[0:0] = ((V1_T4_0_0[0:0]  T6[0:0] )+(V0_T4_0_0[0:0]  s[0:0] ));
X                V0_T4_0_0[0:0] = T4[0:0]' ;
X                V1_T4_0_0[0:0] = T4[0:0] ;
X                .attribute delay 2 level;
X                .attribute area 450 literal;
X              .endoperation;
X            .endnode;
X
X            .node 3 operation;
X              .inputs 0b0 0b0 0b0 0b0 
X	0b0 0b0 0b0 0b0 
X	0b0 0b0 0b0 0b0 
X	0b0 0b0 0b0 0b0 
X	T9[15:15] T9[14:14] T9[13:13] T9[12:12] 
X	T9[11:11] T9[10:10] T9[9:9] T9[8:8] 
X	T9[7:7] T9[6:6] T9[5:5] T9[4:4] 
X	T9[3:3] T9[2:2] T9[1:1] T9[0:0] 
X	X17[0:0] X18[0:0] X19[0:0] X20[0:0] 
X	X21[0:0] X22[0:0] X23[0:0] X24[0:0] 
X	X25[0:0] X26[0:0] X27[0:0] X28[0:0] 
X	X29[0:0] X30[0:0] X31[0:0] X32[0:0] 
X	X33[0:0] X34[0:0] X35[0:0] X36[0:0] 
X	X37[0:0] X38[0:0] X39[0:0] X40[0:0] 
X	X41[0:0] X42[0:0] X43[0:0] X44[0:0] 
X	X45[0:0] X46[0:0] X47[0:0] X48[0:0] 
X	X49[0:0] X50[0:0] X51[0:0] X52[0:0] 
X	X53[0:0] X54[0:0] X55[0:0] X56[0:0] 
X	X57[0:0] X58[0:0] X59[0:0] X60[0:0] 
X	X61[0:0] X62[0:0] X63[0:0] X64[0:0] 
X	X65[0:0] X66[0:0] X67[0:0] X68[0:0] 
X	X69[0:0] X70[0:0] X71[0:0] X72[0:0] 
X	X73[0:0] X74[0:0] X75[0:0] X76[0:0] 
X	X77[0:0] X78[0:0] X79[0:0] X80[0:0] 
X	T11[15:15] T11[14:14] T11[13:13] T11[12:12] 
X	T11[11:11] T11[10:10] T11[9:9] T11[8:8] 
X	T11[7:7] T11[6:6] T11[5:5] T11[4:4] 
X	T11[3:3] T11[2:2] T11[1:1] T11[0:0] 
X	;
X              .outputs t[15:15] t[14:14] t[13:13] t[12:12] 
X	t[11:11] t[10:10] t[9:9] t[8:8] 
X	t[7:7] t[6:6] t[5:5] t[4:4] 
X	t[3:3] t[2:2] t[1:1] t[0:0] 
X	i[15:15] i[14:14] i[13:13] i[12:12] 
X	i[11:11] i[10:10] i[9:9] i[8:8] 
X	i[7:7] i[6:6] i[5:5] i[4:4] 
X	i[3:3] i[2:2] i[1:1] i[0:0] 
X	b[15:15] b[14:14] b[13:13] b[12:12] 
X	b[11:11] b[10:10] b[9:9] b[8:8] 
X	b[7:7] b[6:6] b[5:5] b[4:4] 
X	b[3:3] b[2:2] b[1:1] b[0:0] 
X	a[15:15] a[14:14] a[13:13] a[12:12] 
X	a[11:11] a[10:10] a[9:9] a[8:8] 
X	a[7:7] a[6:6] a[5:5] a[4:4] 
X	a[3:3] a[2:2] a[1:1] a[0:0] 
X	m[15:15] m[14:14] m[13:13] m[12:12] 
X	m[11:11] m[10:10] m[9:9] m[8:8] 
X	m[7:7] m[6:6] m[5:5] m[4:4] 
X	m[3:3] m[2:2] m[1:1] m[0:0] 
X	s[15:15] s[14:14] s[13:13] s[12:12] 
X	s[11:11] s[10:10] s[9:9] s[8:8] 
X	s[7:7] s[6:6] s[5:5] s[4:4] 
X	s[3:3] s[2:2] s[1:1] s[0:0] 
X	p[15:15] p[14:14] p[13:13] p[12:12] 
X	p[11:11] p[10:10] p[9:9] p[8:8] 
X	p[7:7] p[6:6] p[5:5] p[4:4] 
X	p[3:3] p[2:2] p[1:1] p[0:0] 
X	;
X              .successors 4 ;	#  predecessors 2 
X              .attribute constraint delay 3 1 cycles;
X              .operation load_register;
X            .endnode;
X
X            .node 4 loop;
X              .successors 5 ;	#  predecessors 3 
X              .loop T53[0:0] ;	#	
X                #	Index 7
X                .polargraph 1 4;
X                #	4 nodes
X                .node 1 nop;	#	source node
X                  .successors 2 ;
X                .endnode;
X
X                .node 2 cond;
X                  .successors 3 ;	#  predecessors 1 
X                  .cond i[0:3] T13[0:3] ;	#	Latched
X                  .case 1 ;
X                    #	Index 8
X                    .polargraph 1 3;
X                    #	3 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 ;
X                    .endnode;
X
X                    .node 2 cond;
X                      .successors 3 ;	#  predecessors 1 
X                      .cond i[4:7] T14[0:3] ;	#	Latched
X                      .case 0 ;
X                        #	Index 9
X                        .polargraph 1 8;
X                        #	8 nodes
X                        .node 1 nop;	#	source node
X                          .successors 2 3 4 7 ;
X                        .endnode;
X
X                        .node 2 operation;
X                          .inputs a[0:0] a[1:1] a[2:2] a[3:3] 
X	a[4:4] a[5:5] a[6:6] a[7:7] 
X	a[8:8] a[9:9] a[10:10] a[11:11] 
X	a[12:12] a[13:13] a[14:14] a[15:15] 
X	b[0:0] b[1:1] b[2:2] b[3:3] 
X	b[4:4] b[5:5] b[6:6] b[7:7] 
X	b[8:8] b[9:9] b[10:10] b[11:11] 
X	b[12:12] b[13:13] b[14:14] b[15:15] 
X	;
X                          .outputs T16[0:0] T16[1:1] T16[2:2] T16[3:3] 
X	T16[4:4] T16[5:5] T16[6:6] T16[7:7] 
X	T16[8:8] T16[9:9] T16[10:10] T16[11:11] 
X	T16[12:12] T16[13:13] T16[14:14] T16[15:15] 
X	;
X                          .successors 8 ;	#  predecessors 1 
X                          .operation logic 4 ;
X                            #	Expression 0
X                            T15[0:0] = (a[0:0]  b[0:0] );
X                            T15[1:1] = (a[1:1]  b[1:1] );
X                            T15[2:2] = (a[2:2]  b[2:2] );
X                            T15[3:3] = (a[3:3]  b[3:3] );
X                            T15[4:4] = (a[4:4]  b[4:4] );
X                            T15[5:5] = (a[5:5]  b[5:5] );
X                            T15[6:6] = (a[6:6]  b[6:6] );
X                            T15[7:7] = (a[7:7]  b[7:7] );
X                            T15[8:8] = (a[8:8]  b[8:8] );
X                            T15[9:9] = (a[9:9]  b[9:9] );
X                            T15[10:10] = (a[10:10]  b[10:10] );
X                            T15[11:11] = (a[11:11]  b[11:11] );
X                            T15[12:12] = (a[12:12]  b[12:12] );
X                            T15[13:13] = (a[13:13]  b[13:13] );
X                            T15[14:14] = (a[14:14]  b[14:14] );
X                            T15[15:15] = (a[15:15]  b[15:15] );
X                            T16[0:0] = T15[0:0]' ;
X                            T16[1:1] = T15[1:1]' ;
X                            T16[2:2] = T15[2:2]' ;
X                            T16[3:3] = T15[3:3]' ;
X                            T16[4:4] = T15[4:4]' ;
X                            T16[5:5] = T15[5:5]' ;
X                            T16[6:6] = T15[6:6]' ;
X                            T16[7:7] = T15[7:7]' ;
X                            T16[8:8] = T15[8:8]' ;
X                            T16[9:9] = T15[9:9]' ;
X                            T16[10:10] = T15[10:10]' ;
X                            T16[11:11] = T15[11:11]' ;
X                            T16[12:12] = T15[12:12]' ;
X                            T16[13:13] = T15[13:13]' ;
X                            T16[14:14] = T15[14:14]' ;
X                            T16[15:15] = T15[15:15]' ;
X                            .attribute delay 1 level;
X                            .attribute area 64 literal;
X                          .endoperation;
X                        .endnode;
X
X                        .node 3 operation;
X                          .inputs 0b1 ;
X                          .outputs rd[0:0] ;
X                          .successors 5 6 ;	#  predecessors 1 
X                          .attribute constraint delay 3 1 cycles;
X                          .operation write;
X                        .endnode;
X
X                        .node 4 operation;
X                          .inputs s[0:15] ;
X                          .outputs address[0:15] ;
X                          .successors 5 6 ;	#  predecessors 1 
X                          .attribute constraint delay 4 1 cycles;
X                          .operation write;
X                        .endnode;
X
X                        .node 5 operation;
X                          .inputs 0b0 ;
X                          .outputs rd[0:0] ;
X                          .successors 8 ;	#  predecessors 3 4 
X                          .attribute constraint delay 5 1 cycles;
X                          .operation write;
X                        .endnode;
X
X                        .node 6 operation;
X                          .inputs data[0:15] ;
X                          .outputs T17[0:15] ;
X                          .successors 8 ;	#  predecessors 3 4 
X                          .attribute constraint delay 6 1 cycles;
X                          .operation read;
X                        .endnode;
X
X                        .node 7 proc;
X                          .inputs s[0:15] 0b1000000000000000 ;
X                          .outputs T18[0:16] ;
X                          .successors 8 ;	#  predecessors 1 
X                          .proc subtract with (16);
X                        .endnode;
X
X                        .node 8 nop;	#	sink node
X                          .successors ;	#  predecessors 2 5 6 7 
X                        .endnode;
X
X                        .attribute constraint delay 3 1 cycles;
X                        .attribute constraint delay 4 1 cycles;
X                        .attribute constraint delay 5 1 cycles;
X                        .attribute constraint delay 6 1 cycles;
X                        .endpolargraph;
X                      .endcase;
X                      .case 1 ;
X                        #	Index 10
X                        .polargraph 1 8;
X                        #	8 nodes
X                        .node 1 nop;	#	source node
X                          .successors 2 3 4 6 7 ;
X                        .endnode;
X
X                        .node 2 proc;
X                          .inputs b[0:15] a[0:15] ;
X                          .outputs T19[0:16] ;
X                          .successors 8 ;	#  predecessors 1 
X                          .proc subtract with (16);
X                        .endnode;
X
X                        .node 3 operation;
X                          .inputs 0b1 ;
X                          .outputs rd[0:0] ;
X                          .successors 5 ;	#  predecessors 1 
X                          .attribute constraint delay 3 1 cycles;
X                          .operation write;
X                        .endnode;
X
X                        .node 4 operation;
X                          .inputs s[0:15] ;
X                          .outputs address[0:15] ;
X                          .successors 5 ;	#  predecessors 1 
X                          .attribute constraint delay 4 1 cycles;
X                          .operation write;
X                        .endnode;
X
X                        .node 5 operation;
X                          .inputs 0b0 ;
X                          .outputs rd[0:0] ;
X                          .successors 8 ;	#  predecessors 3 4 
X                          .attribute constraint delay 5 1 cycles;
X                          .operation write;
X                        .endnode;
X
X                        .node 6 operation;
X                          .inputs data[0:15] ;
X                          .outputs T20[0:15] ;
X                          .successors 8 ;	#  predecessors 1 
X                          .attribute constraint delay 6 1 cycles;
X                          .operation read;
X                        .endnode;
X
X                        .node 7 proc;
X                          .inputs s[0:15] 0b1000000000000000 ;
X                          .outputs T21[0:16] ;
X                          .successors 8 ;	#  predecessors 1 
X                          .proc subtract with (16);
X                        .endnode;
X
X                        .node 8 nop;	#	sink node
X                          .successors ;	#  predecessors 2 5 6 7 
X                        .endnode;
X
X                        .attribute constraint delay 3 1 cycles;
X                        .attribute constraint delay 4 1 cycles;
X                        .attribute constraint delay 5 1 cycles;
X                        .attribute constraint delay 6 1 cycles;
X                        .endpolargraph;
X                      .endcase;
X                      .case 2 ;
X                        #	Index 11
X                        .polargraph 1 2;
X                        #	2 nodes
X                        .node 1 nop;	#	source node
X                          .successors 2 ;
X                        .endnode;
X
X                        .node 2 nop;	#	sink node
X                          .successors ;	#  predecessors 1 
X                        .endnode;
X
X                        .endpolargraph;
X                      .endcase;
X                      .endcond;
X                    .endnode;
X
X                    .node 3 nop;	#	sink node
X                      .successors ;	#  predecessors 2 
X                    .endnode;
X
X                    .endpolargraph;
X                  .endcase;
X                  .case 2 ;
X                    #	Index 12
X                    .polargraph 1 12;
X                    #	12 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 11 ;
X                    .endnode;
X
X                    .node 2 proc;
X                      .inputs s[0:15] 0b1000000000000000 ;
X                      .outputs T22[0:16] ;
X                      .successors 3 4 5 ;	#  predecessors 1 
X                      .proc add with (16);
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs 0b1 ;
X                      .outputs wr[0:0] ;
X                      .successors 7 8 6 ;	#  predecessors 2 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs T22[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 7 8 6 ;	#  predecessors 2 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs b[0:15] ;
X                      .outputs data[0:15] ;
X                      .successors 7 8 6 ;	#  predecessors 2 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 6 operation;
X                      .inputs 0b0 ;
X                      .outputs wr[0:0] ;
X                      .successors 12 ;	#  predecessors 3 4 5 
X                      .attribute constraint delay 6 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 7 operation;
X                      .inputs 0b1 ;
X                      .outputs rd[0:0] ;
X                      .successors 9 10 ;	#  predecessors 3 4 5 
X                      .attribute constraint delay 7 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 8 operation;
X                      .inputs p[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 9 10 ;	#  predecessors 3 4 5 
X                      .attribute constraint delay 8 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 9 operation;
X                      .inputs 0b0 ;
X                      .outputs rd[0:0] ;
X                      .successors 12 ;	#  predecessors 7 8 
X                      .attribute constraint delay 9 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 10 operation;
X                      .inputs data[0:15] ;
X                      .outputs T23[0:15] ;
X                      .successors 12 ;	#  predecessors 7 8 
X                      .attribute constraint delay 10 1 cycles;
X                      .operation read;
X                    .endnode;
X
X                    .node 11 proc;
X                      .inputs p[0:15] 0b1000000000000000 ;
X                      .outputs T24[0:16] ;
X                      .successors 12 ;	#  predecessors 1 
X                      .proc add with (16);
X                    .endnode;
X
X                    .node 12 nop;	#	sink node
X                      .successors ;	#  predecessors 6 9 10 11 
X                    .endnode;
X
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .attribute constraint delay 6 1 cycles;
X                    .attribute constraint delay 7 1 cycles;
X                    .attribute constraint delay 8 1 cycles;
X                    .attribute constraint delay 9 1 cycles;
X                    .attribute constraint delay 10 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 3 ;
X                    #	Index 13
X                    .polargraph 1 7;
X                    #	7 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 5 ;
X                    .endnode;
X
X                    .node 2 proc;
X                      .inputs s[0:15] 0b1000000000000000 ;
X                      .outputs T25[0:16] ;
X                      .successors 3 4 ;	#  predecessors 1 
X                      .proc add with (16);
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs 0b1 ;
X                      .outputs wr[0:0] ;
X                      .successors 6 ;	#  predecessors 2 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs T25[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 6 ;	#  predecessors 2 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs b[0:15] ;
X                      .outputs data[0:15] ;
X                      .successors 7 ;	#  predecessors 1 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 6 operation;
X                      .inputs 0b0 ;
X                      .outputs wr[0:0] ;
X                      .successors 7 ;	#  predecessors 3 4 
X                      .attribute constraint delay 6 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 7 nop;	#	sink node
X                      .successors ;	#  predecessors 5 6 
X                    .endnode;
X
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .attribute constraint delay 6 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 4 ;
X                    #	Index 14
X                    .polargraph 1 12;
X                    #	12 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 3 5 6 10 ;
X                    .endnode;
X
X                    .node 2 operation;
X                      .inputs 0b1 ;
X                      .outputs rd[0:0] ;
X                      .successors 4 ;	#  predecessors 1 
X                      .attribute constraint delay 2 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs a[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 4 ;	#  predecessors 1 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs 0b0 ;
X                      .outputs rd[0:0] ;
X                      .successors 7 8 ;	#  predecessors 2 3 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs data[0:15] ;
X                      .outputs T26[0:15] ;
X                      .successors 12 ;	#  predecessors 1 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation read;
X                    .endnode;
X
X                    .node 6 proc;
X                      .inputs a[0:15] 0b1000000000000000 ;
X                      .outputs T27[0:16] ;
X                      .successors 11 7 8 ;	#  predecessors 1 
X                      .proc subtract with (16);
X                    .endnode;
X
X                    .node 7 operation;
X                      .inputs 0b1 ;
X                      .outputs rd[0:0] ;
X                      .successors 9 ;	#  predecessors 4 6 
X                      .attribute constraint delay 7 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 8 operation;
X                      .inputs T27[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 9 ;	#  predecessors 4 6 
X                      .attribute constraint delay 8 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 9 operation;
X                      .inputs 0b0 ;
X                      .outputs rd[0:0] ;
X                      .successors 12 ;	#  predecessors 7 8 
X                      .attribute constraint delay 9 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 10 operation;
X                      .inputs data[0:15] ;
X                      .outputs T28[0:15] ;
X                      .successors 12 ;	#  predecessors 1 
X                      .attribute constraint delay 10 1 cycles;
X                      .operation read;
X                    .endnode;
X
X                    .node 11 proc;
X                      .inputs T27[0:15] 0b1000000000000000 ;
X                      .outputs T29[0:16] ;
X                      .successors 12 ;	#  predecessors 6 
X                      .proc subtract with (16);
X                    .endnode;
X
X                    .node 12 nop;	#	sink node
X                      .successors ;	#  predecessors 5 9 10 11 
X                    .endnode;
X
X                    .attribute constraint delay 2 1 cycles;
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .attribute constraint delay 7 1 cycles;
X                    .attribute constraint delay 8 1 cycles;
X                    .attribute constraint delay 9 1 cycles;
X                    .attribute constraint delay 10 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 5 ;
X                    #	Index 15
X                    .polargraph 1 7;
X                    #	7 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 5 ;
X                    .endnode;
X
X                    .node 2 proc;
X                      .inputs s[0:15] 0b1000000000000000 ;
X                      .outputs T30[0:16] ;
X                      .successors 3 4 ;	#  predecessors 1 
X                      .proc add with (16);
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs 0b1 ;
X                      .outputs wr[0:0] ;
X                      .successors 6 ;	#  predecessors 2 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs T30[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 6 ;	#  predecessors 2 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs b[0:15] ;
X                      .outputs data[0:15] ;
X                      .successors 7 ;	#  predecessors 1 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 6 operation;
X                      .inputs 0b0 ;
X                      .outputs wr[0:0] ;
X                      .successors 7 ;	#  predecessors 3 4 
X                      .attribute constraint delay 6 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 7 nop;	#	sink node
X                      .successors ;	#  predecessors 5 6 
X                    .endnode;
X
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .attribute constraint delay 6 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 6 ;
X                    #	Index 16
X                    .polargraph 1 6;
X                    #	6 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 3 ;
X                    .endnode;
X
X                    .node 2 operation;
X                      .inputs 0b1 ;
X                      .outputs rd[0:0] ;
X                      .successors 4 5 ;	#  predecessors 1 
X                      .attribute constraint delay 2 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs a[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 4 5 ;	#  predecessors 1 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs 0b0 ;
X                      .outputs rd[0:0] ;
X                      .successors 6 ;	#  predecessors 2 3 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs data[0:15] ;
X                      .outputs T31[0:15] ;
X                      .successors 6 ;	#  predecessors 2 3 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation read;
X                    .endnode;
X
X                    .node 6 nop;	#	sink node
X                      .successors ;	#  predecessors 4 5 
X                    .endnode;
X
X                    .attribute constraint delay 2 1 cycles;
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 7 ;
X                    #	Index 17
X                    .polargraph 1 11;
X                    #	11 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 3 4 10 ;
X                    .endnode;
X
X                    .node 2 operation;
X                      .inputs 0b1 ;
X                      .outputs wr[0:0] ;
X                      .successors 6 7 5 ;	#  predecessors 1 
X                      .attribute constraint delay 2 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs b[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 6 7 5 ;	#  predecessors 1 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs a[0:15] ;
X                      .outputs data[0:15] ;
X                      .successors 9 ;	#  predecessors 1 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs 0b0 ;
X                      .outputs wr[0:0] ;
X                      .successors 11 ;	#  predecessors 2 3 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 6 operation;
X                      .inputs 0b1 ;
X                      .outputs rd[0:0] ;
X                      .successors 8 ;	#  predecessors 2 3 
X                      .attribute constraint delay 6 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 7 operation;
X                      .inputs s[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 8 ;	#  predecessors 2 3 
X                      .attribute constraint delay 7 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 8 operation;
X                      .inputs 0b0 ;
X                      .outputs rd[0:0] ;
X                      .successors 11 ;	#  predecessors 6 7 
X                      .attribute constraint delay 8 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 9 operation;
X                      .inputs data[0:15] ;
X                      .outputs T32[0:15] ;
X                      .successors 11 ;	#  predecessors 4 
X                      .attribute constraint delay 9 1 cycles;
X                      .operation read;
X                    .endnode;
X
X                    .node 10 proc;
X                      .inputs s[0:15] 0b1000000000000000 ;
X                      .outputs T33[0:16] ;
X                      .successors 11 ;	#  predecessors 1 
X                      .proc subtract with (16);
X                    .endnode;
X
X                    .node 11 nop;	#	sink node
X                      .successors ;	#  predecessors 5 8 9 10 
X                    .endnode;
X
X                    .attribute constraint delay 2 1 cycles;
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .attribute constraint delay 6 1 cycles;
X                    .attribute constraint delay 7 1 cycles;
X                    .attribute constraint delay 8 1 cycles;
X                    .attribute constraint delay 9 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 8 ;
X                    #	Index 18
X                    .polargraph 1 7;
X                    #	7 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 3 5 6 ;
X                    .endnode;
X
X                    .node 2 operation;
X                      .inputs 0b1 ;
X                      .outputs rd[0:0] ;
X                      .successors 4 ;	#  predecessors 1 
X                      .attribute constraint delay 2 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs s[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 4 ;	#  predecessors 1 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs 0b0 ;
X                      .outputs rd[0:0] ;
X                      .successors 7 ;	#  predecessors 2 3 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs data[0:15] ;
X                      .outputs T34[0:15] ;
X                      .successors 7 ;	#  predecessors 1 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation read;
X                    .endnode;
X
X                    .node 6 proc;
X                      .inputs s[0:15] 0b1000000000000000 ;
X                      .outputs T35[0:16] ;
X                      .successors 7 ;	#  predecessors 1 
X                      .proc subtract with (16);
X                    .endnode;
X
X                    .node 7 nop;	#	sink node
X                      .successors ;	#  predecessors 4 5 6 
X                    .endnode;
X
X                    .attribute constraint delay 2 1 cycles;
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 9 ;
X                    #	Index 19
X                    .polargraph 1 8;
X                    #	8 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 3 4 6 7 ;
X                    .endnode;
X
X                    .node 2 operation;
X                      .inputs b[0:0] b[1:1] b[2:2] b[3:3] 
X	b[4:4] b[5:5] b[6:6] b[7:7] 
X	b[8:8] b[9:9] b[10:10] b[11:11] 
X	b[12:12] b[13:13] b[14:14] b[15:15] 
X	;
X                      .outputs T36[0:0] ;
X                      .successors 8 ;	#  predecessors 1 
X                      .operation logic 5 ;
X                        #	Expression 0
X                        c_0_T37[0:0] =  0 ;
X                        d_0_T37[0:0] =  1 ;
X                        c_1_T37[0:0] = ((c_0_T37[0:0]  (b[0:0] + 0' ))+(d_0_T37[0:0]  (b[0:0]   0' )));
X                        d_1_T37[0:0] = ((c_0_T37[0:0]  (b[0:0]'   0 ))+(d_0_T37[0:0]  (b[0:0]' + 0 )));
X                        c_2_T37[0:0] = ((c_1_T37[0:0]  (b[1:1] + 0' ))+(d_1_T37[0:0]  (b[1:1]   0' )));
X                        d_2_T37[0:0] = ((c_1_T37[0:0]  (b[1:1]'   0 ))+(d_1_T37[0:0]  (b[1:1]' + 0 )));
X                        c_3_T37[0:0] = ((c_2_T37[0:0]  (b[2:2] + 0' ))+(d_2_T37[0:0]  (b[2:2]   0' )));
X                        d_3_T37[0:0] = ((c_2_T37[0:0]  (b[2:2]'   0 ))+(d_2_T37[0:0]  (b[2:2]' + 0 )));
X                        c_4_T37[0:0] = ((c_3_T37[0:0]  (b[3:3] + 0' ))+(d_3_T37[0:0]  (b[3:3]   0' )));
X                        d_4_T37[0:0] = ((c_3_T37[0:0]  (b[3:3]'   0 ))+(d_3_T37[0:0]  (b[3:3]' + 0 )));
X                        c_5_T37[0:0] = ((c_4_T37[0:0]  (b[4:4] + 0' ))+(d_4_T37[0:0]  (b[4:4]   0' )));
X                        d_5_T37[0:0] = ((c_4_T37[0:0]  (b[4:4]'   0 ))+(d_4_T37[0:0]  (b[4:4]' + 0 )));
X                        c_6_T37[0:0] = ((c_5_T37[0:0]  (b[5:5] + 0' ))+(d_5_T37[0:0]  (b[5:5]   0' )));
X                        d_6_T37[0:0] = ((c_5_T37[0:0]  (b[5:5]'   0 ))+(d_5_T37[0:0]  (b[5:5]' + 0 )));
X                        c_7_T37[0:0] = ((c_6_T37[0:0]  (b[6:6] + 0' ))+(d_6_T37[0:0]  (b[6:6]   0' )));
X                        d_7_T37[0:0] = ((c_6_T37[0:0]  (b[6:6]'   0 ))+(d_6_T37[0:0]  (b[6:6]' + 0 )));
X                        c_8_T37[0:0] = ((c_7_T37[0:0]  (b[7:7] + 0' ))+(d_7_T37[0:0]  (b[7:7]   0' )));
X                        d_8_T37[0:0] = ((c_7_T37[0:0]  (b[7:7]'   0 ))+(d_7_T37[0:0]  (b[7:7]' + 0 )));
X                        c_9_T37[0:0] = ((c_8_T37[0:0]  (b[8:8] + 0' ))+(d_8_T37[0:0]  (b[8:8]   0' )));
X                        d_9_T37[0:0] = ((c_8_T37[0:0]  (b[8:8]'   0 ))+(d_8_T37[0:0]  (b[8:8]' + 0 )));
X                        c_10_T37[0:0] = ((c_9_T37[0:0]  (b[9:9] + 0' ))+(d_9_T37[0:0]  (b[9:9]   0' )));
X                        d_10_T37[0:0] = ((c_9_T37[0:0]  (b[9:9]'   0 ))+(d_9_T37[0:0]  (b[9:9]' + 0 )));
X                        c_11_T37[0:0] = ((c_10_T37[0:0]  (b[10:10] + 0' ))+(d_10_T37[0:0]  (b[10:10]   0' )));
X                        d_11_T37[0:0] = ((c_10_T37[0:0]  (b[10:10]'   0 ))+(d_10_T37[0:0]  (b[10:10]' + 0 )));
X                        c_12_T37[0:0] = ((c_11_T37[0:0]  (b[11:11] + 0' ))+(d_11_T37[0:0]  (b[11:11]   0' )));
X                        d_12_T37[0:0] = ((c_11_T37[0:0]  (b[11:11]'   0 ))+(d_11_T37[0:0]  (b[11:11]' + 0 )));
X                        c_13_T37[0:0] = ((c_12_T37[0:0]  (b[12:12] + 0' ))+(d_12_T37[0:0]  (b[12:12]   0' )));
X                        d_13_T37[0:0] = ((c_12_T37[0:0]  (b[12:12]'   0 ))+(d_12_T37[0:0]  (b[12:12]' + 0 )));
X                        c_14_T37[0:0] = ((c_13_T37[0:0]  (b[13:13] + 0' ))+(d_13_T37[0:0]  (b[13:13]   0' )));
X                        d_14_T37[0:0] = ((c_13_T37[0:0]  (b[13:13]'   0 ))+(d_13_T37[0:0]  (b[13:13]' + 0 )));
X                        c_15_T37[0:0] = ((c_14_T37[0:0]  (b[14:14] + 0' ))+(d_14_T37[0:0]  (b[14:14]   0' )));
X                        d_15_T37[0:0] = ((c_14_T37[0:0]  (b[14:14]'   0 ))+(d_14_T37[0:0]  (b[14:14]' + 0 )));
X                        c_16_T37[0:0] = ((c_15_T37[0:0]  (b[15:15] + 0' ))+(d_15_T37[0:0]  (b[15:15]   0' )));
X                        d_16_T37[0:0] = ((c_15_T37[0:0]  (b[15:15]'   0 ))+(d_15_T37[0:0]  (b[15:15]' + 0 )));
X                        T37[0:0] = c_16_T37[0:0] ;
X                        T36[0:0] = T37[0:0] ;
X                        .attribute delay 33 level;
X                        .attribute area 356 literal;
X                      .endoperation;
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs 0b1 ;
X                      .outputs rd[0:0] ;
X                      .successors 5 ;	#  predecessors 1 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs s[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 5 ;	#  predecessors 1 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs 0b0 ;
X                      .outputs rd[0:0] ;
X                      .successors 8 ;	#  predecessors 3 4 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 6 operation;
X                      .inputs data[0:15] ;
X                      .outputs T38[0:15] ;
X                      .successors 8 ;	#  predecessors 1 
X                      .attribute constraint delay 6 1 cycles;
X                      .operation read;
X                    .endnode;
X
X                    .node 7 proc;
X                      .inputs s[0:15] 0b1000000000000000 ;
X                      .outputs T39[0:16] ;
X                      .successors 8 ;	#  predecessors 1 
X                      .proc subtract with (16);
X                    .endnode;
X
X                    .node 8 nop;	#	sink node
X                      .successors ;	#  predecessors 2 5 6 7 
X                    .endnode;
X
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .attribute constraint delay 6 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 10 ;
X                    #	Index 20
X                    .polargraph 1 7;
X                    #	7 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 3 5 6 ;
X                    .endnode;
X
X                    .node 2 operation;
X                      .inputs 0b1 ;
X                      .outputs rd[0:0] ;
X                      .successors 4 ;	#  predecessors 1 
X                      .attribute constraint delay 2 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs s[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 4 ;	#  predecessors 1 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs 0b0 ;
X                      .outputs rd[0:0] ;
X                      .successors 7 ;	#  predecessors 2 3 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs data[0:15] ;
X                      .outputs T40[0:15] ;
X                      .successors 7 ;	#  predecessors 1 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation read;
X                    .endnode;
X
X                    .node 6 proc;
X                      .inputs s[0:15] 0b1000000000000000 ;
X                      .outputs T41[0:16] ;
X                      .successors 7 ;	#  predecessors 1 
X                      .proc subtract with (16);
X                    .endnode;
X
X                    .node 7 nop;	#	sink node
X                      .successors ;	#  predecessors 4 5 6 
X                    .endnode;
X
X                    .attribute constraint delay 2 1 cycles;
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 11 ;
X                    #	Index 21
X                    .polargraph 1 8;
X                    #	8 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 5 ;
X                    .endnode;
X
X                    .node 2 proc;
X                      .inputs s[0:15] 0b1000000000000000 ;
X                      .outputs T42[0:16] ;
X                      .successors 7 3 4 ;	#  predecessors 1 
X                      .proc add with (16);
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs 0b1 ;
X                      .outputs wr[0:0] ;
X                      .successors 6 ;	#  predecessors 2 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs T42[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 6 ;	#  predecessors 2 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs b[0:15] ;
X                      .outputs data[0:15] ;
X                      .successors 8 ;	#  predecessors 1 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 6 operation;
X                      .inputs 0b0 ;
X                      .outputs wr[0:0] ;
X                      .successors 8 ;	#  predecessors 3 4 
X                      .attribute constraint delay 6 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 7 proc;
X                      .inputs T42[0:15] 0b0100000000000000 ;
X                      .outputs T43[0:16] ;
X                      .successors 8 ;	#  predecessors 2 
X                      .proc add with (16);
X                    .endnode;
X
X                    .node 8 nop;	#	sink node
X                      .successors ;	#  predecessors 5 6 7 
X                    .endnode;
X
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .attribute constraint delay 6 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 12 ;
X                    #	Index 22
X                    .polargraph 1 2;
X                    #	2 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 ;
X                    .endnode;
X
X                    .node 2 nop;	#	sink node
X                      .successors ;	#  predecessors 1 
X                    .endnode;
X
X                    .endpolargraph;
X                  .endcase;
X                  .case 13 ;
X                    #	Index 23
X                    .polargraph 1 12;
X                    #	12 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 3 5 6 10 ;
X                    .endnode;
X
X                    .node 2 operation;
X                      .inputs 0b1 ;
X                      .outputs rd[0:0] ;
X                      .successors 4 ;	#  predecessors 1 
X                      .attribute constraint delay 2 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs m[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 4 ;	#  predecessors 1 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs 0b0 ;
X                      .outputs rd[0:0] ;
X                      .successors 7 8 ;	#  predecessors 2 3 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs data[0:15] ;
X                      .outputs T44[0:15] ;
X                      .successors 12 ;	#  predecessors 1 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation read;
X                    .endnode;
X
X                    .node 6 proc;
X                      .inputs m[0:15] 0b1000000000000000 ;
X                      .outputs T45[0:16] ;
X                      .successors 11 7 8 ;	#  predecessors 1 
X                      .proc subtract with (16);
X                    .endnode;
X
X                    .node 7 operation;
X                      .inputs 0b1 ;
X                      .outputs rd[0:0] ;
X                      .successors 9 ;	#  predecessors 4 6 
X                      .attribute constraint delay 7 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 8 operation;
X                      .inputs T45[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 9 ;	#  predecessors 4 6 
X                      .attribute constraint delay 8 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 9 operation;
X                      .inputs 0b0 ;
X                      .outputs rd[0:0] ;
X                      .successors 12 ;	#  predecessors 7 8 
X                      .attribute constraint delay 9 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 10 operation;
X                      .inputs data[0:15] ;
X                      .outputs T46[0:15] ;
X                      .successors 12 ;	#  predecessors 1 
X                      .attribute constraint delay 10 1 cycles;
X                      .operation read;
X                    .endnode;
X
X                    .node 11 proc;
X                      .inputs T45[0:15] 0b1000000000000000 ;
X                      .outputs T47[0:16] ;
X                      .successors 12 ;	#  predecessors 6 
X                      .proc subtract with (16);
X                    .endnode;
X
X                    .node 12 nop;	#	sink node
X                      .successors ;	#  predecessors 5 9 10 11 
X                    .endnode;
X
X                    .attribute constraint delay 2 1 cycles;
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .attribute constraint delay 7 1 cycles;
X                    .attribute constraint delay 8 1 cycles;
X                    .attribute constraint delay 9 1 cycles;
X                    .attribute constraint delay 10 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 14 ;
X                    #	Index 24
X                    .polargraph 1 8;
X                    #	8 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 7 ;
X                    .endnode;
X
X                    .node 2 proc;
X                      .inputs b[0:15] a[0:15] ;
X                      .outputs T48[0:16] ;
X                      .successors 3 4 ;	#  predecessors 1 
X                      .proc add with (16);
X                    .endnode;
X
X                    .node 3 operation;
X                      .inputs 0b1 ;
X                      .outputs rd[0:0] ;
X                      .successors 5 6 ;	#  predecessors 2 
X                      .attribute constraint delay 3 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 4 operation;
X                      .inputs s[0:15] ;
X                      .outputs address[0:15] ;
X                      .successors 5 6 ;	#  predecessors 2 
X                      .attribute constraint delay 4 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 5 operation;
X                      .inputs 0b0 ;
X                      .outputs rd[0:0] ;
X                      .successors 8 ;	#  predecessors 3 4 
X                      .attribute constraint delay 5 1 cycles;
X                      .operation write;
X                    .endnode;
X
X                    .node 6 operation;
X                      .inputs data[0:15] ;
X                      .outputs T49[0:15] ;
X                      .successors 8 ;	#  predecessors 3 4 
X                      .attribute constraint delay 6 1 cycles;
X                      .operation read;
X                    .endnode;
X
X                    .node 7 proc;
X                      .inputs s[0:15] 0b1000000000000000 ;
X                      .outputs T50[0:16] ;
X                      .successors 8 ;	#  predecessors 1 
X                      .proc subtract with (16);
X                    .endnode;
X
X                    .node 8 nop;	#	sink node
X                      .successors ;	#  predecessors 5 6 7 
X                    .endnode;
X
X                    .attribute constraint delay 3 1 cycles;
X                    .attribute constraint delay 4 1 cycles;
X                    .attribute constraint delay 5 1 cycles;
X                    .attribute constraint delay 6 1 cycles;
X                    .endpolargraph;
X                  .endcase;
X                  .case 15 ;
X                    #	Index 25
X                    .polargraph 1 3;
X                    #	3 nodes
X                    .node 1 nop;	#	source node
X                      .successors 2 ;
X                    .endnode;
X
X                    .node 2 proc;
X                      .inputs a[0:15] 0b1000000000000000 ;
X                      .outputs T51[0:16] ;
X                      .successors 3 ;	#  predecessors 1 
X                      .proc add with (16);
X                    .endnode;
X
X                    .node 3 nop;	#	sink node
X                      .successors ;	#  predecessors 2 
X                    .endnode;
X
X                    .endpolargraph;
X                  .endcase;
X                  .endcond;
X                .endnode;
X
X                .node 3 operation;
X                  .inputs i[4:4] i[5:5] i[6:6] i[7:7] 
X	i[8:8] i[9:9] i[10:10] i[11:11] 
X	i[12:12] i[13:13] i[14:14] i[15:15] 
X	T13[0:0] T13[1:1] T13[2:2] T13[3:3] 
X	a[1:1] a[2:2] a[3:3] a[4:4] 
X	a[5:5] a[6:6] a[7:7] a[8:8] 
X	a[9:9] a[10:10] a[11:11] a[12:12] 
X	a[13:13] a[14:14] a[15:15] t[15:15] 
X	p[15:15] t[14:14] p[14:14] t[13:13] 
X	p[13:13] t[12:12] p[12:12] t[11:11] 
X	p[11:11] t[10:10] p[10:10] t[9:9] 
X	p[9:9] t[8:8] p[8:8] t[7:7] 
X	p[7:7] t[6:6] p[6:6] t[5:5] 
X	p[5:5] t[4:4] p[4:4] t[3:3] 
X	p[3:3] t[2:2] p[2:2] t[1:1] 
X	p[1:1] t[0:0] p[0:0] T28[15:15] 
X	b[15:15] T32[15:15] T34[15:15] T38[15:15] 
X	T40[15:15] T46[15:15] T49[15:15] T28[14:14] 
X	b[14:14] T32[14:14] T34[14:14] T38[14:14] 
X	T40[14:14] T46[14:14] T49[14:14] T28[13:13] 
X	b[13:13] T32[13:13] T34[13:13] T38[13:13] 
X	T40[13:13] T46[13:13] T49[13:13] T28[12:12] 
X	b[12:12] T32[12:12] T34[12:12] T38[12:12] 
X	T40[12:12] T46[12:12] T49[12:12] T28[11:11] 
X	b[11:11] T32[11:11] T34[11:11] T38[11:11] 
X	T40[11:11] T46[11:11] T49[11:11] T28[10:10] 
X	b[10:10] T32[10:10] T34[10:10] T38[10:10] 
X	T40[10:10] T46[10:10] T49[10:10] T28[9:9] 
X	b[9:9] T32[9:9] T34[9:9] T38[9:9] 
X	T40[9:9] T46[9:9] T49[9:9] T28[8:8] 
X	b[8:8] T32[8:8] T34[8:8] T38[8:8] 
X	T40[8:8] T46[8:8] T49[8:8] T28[7:7] 
X	b[7:7] T32[7:7] T34[7:7] T38[7:7] 
X	T40[7:7] T46[7:7] T49[7:7] T28[6:6] 
X	b[6:6] T32[6:6] T34[6:6] T38[6:6] 
X	T40[6:6] T46[6:6] T49[6:6] T28[5:5] 
X	b[5:5] T32[5:5] T34[5:5] T38[5:5] 
X	T40[5:5] T46[5:5] T49[5:5] T28[4:4] 
X	b[4:4] T32[4:4] T34[4:4] T38[4:4] 
X	T40[4:4] T46[4:4] T49[4:4] T28[3:3] 
X	b[3:3] T32[3:3] T34[3:3] T38[3:3] 
X	T40[3:3] T46[3:3] T49[3:3] T28[2:2] 
X	b[2:2] T32[2:2] T34[2:2] T38[2:2] 
X	T40[2:2] T46[2:2] T49[2:2] T28[1:1] 
X	b[1:1] T32[1:1] T34[1:1] T38[1:1] 
X	T40[1:1] T46[1:1] T49[1:1] a[0:0] 
X	T28[0:0] b[0:0] T32[0:0] T34[0:0] 
X	T38[0:0] T40[0:0] T46[0:0] T49[0:0] 
X	T23[15:15] T25[15:15] T26[15:15] m[15:15] 
X	T31[15:15] T48[15:15] T51[15:15] T23[14:14] 
X	T25[14:14] T26[14:14] m[14:14] T31[14:14] 
X	T48[14:14] T51[14:14] T23[13:13] T25[13:13] 
X	T26[13:13] m[13:13] T31[13:13] T48[13:13] 
X	T51[13:13] T23[12:12] T25[12:12] T26[12:12] 
X	m[12:12] T31[12:12] T48[12:12] T51[12:12] 
X	T23[11:11] T25[11:11] T26[11:11] m[11:11] 
X	T31[11:11] T48[11:11] T51[11:11] T23[10:10] 
X	T25[10:10] T26[10:10] m[10:10] T31[10:10] 
X	T48[10:10] T51[10:10] T23[9:9] T25[9:9] 
X	T26[9:9] m[9:9] T31[9:9] T48[9:9] 
X	T51[9:9] T23[8:8] T25[8:8] T26[8:8] 
X	m[8:8] T31[8:8] T48[8:8] T51[8:8] 
X	T23[7:7] T25[7:7] T26[7:7] m[7:7] 
X	T31[7:7] T48[7:7] T51[7:7] T23[6:6] 
X	T25[6:6] T26[6:6] m[6:6] T31[6:6] 
X	T48[6:6] T51[6:6] T23[5:5] T25[5:5] 
X	T26[5:5] m[5:5] T31[5:5] T48[5:5] 
X	T51[5:5] T23[4:4] T25[4:4] T26[4:4] 
X	m[4:4] T31[4:4] T48[4:4] T51[4:4] 
X	T23[3:3] T25[3:3] T26[3:3] m[3:3] 
X	T31[3:3] T48[3:3] T51[3:3] T23[2:2] 
X	T25[2:2] T26[2:2] m[2:2] T31[2:2] 
X	T48[2:2] T51[2:2] T23[1:1] T25[1:1] 
X	T26[1:1] m[1:1] T31[1:1] T48[1:1] 
X	T51[1:1] T23[0:0] T25[0:0] T26[0:0] 
X	m[0:0] T31[0:0] T48[0:0] T51[0:0] 
X	T43[15:15] T44[15:15] T43[14:14] T44[14:14] 
X	T43[13:13] T44[13:13] T43[12:12] T44[12:12] 
X	T43[11:11] T44[11:11] T43[10:10] T44[10:10] 
X	T43[9:9] T44[9:9] T43[8:8] T44[8:8] 
X	T43[7:7] T44[7:7] T43[6:6] T44[6:6] 
X	T43[5:5] T44[5:5] T43[4:4] T44[4:4] 
X	T43[3:3] T44[3:3] T43[2:2] T44[2:2] 
X	T43[1:1] T44[1:1] T43[0:0] T44[0:0] 
X	T22[15:15] T29[15:15] T30[15:15] s[15:15] 
X	T33[15:15] T35[15:15] T39[15:15] T41[15:15] 
X	T42[15:15] T47[15:15] T50[15:15] T22[14:14] 
X	T29[14:14] T30[14:14] s[14:14] T33[14:14] 
X	T35[14:14] T39[14:14] T41[14:14] T42[14:14] 
X	T47[14:14] T50[14:14] T22[13:13] T29[13:13] 
X	T30[13:13] s[13:13] T33[13:13] T35[13:13] 
X	T39[13:13] T41[13:13] T42[13:13] T47[13:13] 
X	T50[13:13] T22[12:12] T29[12:12] T30[12:12] 
X	s[12:12] T33[12:12] T35[12:12] T39[12:12] 
X	T41[12:12] T42[12:12] T47[12:12] T50[12:12] 
X	T22[11:11] T29[11:11] T30[11:11] s[11:11] 
X	T33[11:11] T35[11:11] T39[11:11] T41[11:11] 
X	T42[11:11] T47[11:11] T50[11:11] T22[10:10] 
X	T29[10:10] T30[10:10] s[10:10] T33[10:10] 
X	T35[10:10] T39[10:10] T41[10:10] T42[10:10] 
X	T47[10:10] T50[10:10] T22[9:9] T29[9:9] 
X	T30[9:9] s[9:9] T33[9:9] T35[9:9] 
X	T39[9:9] T41[9:9] T42[9:9] T47[9:9] 
X	T50[9:9] T22[8:8] T29[8:8] T30[8:8] 
X	s[8:8] T33[8:8] T35[8:8] T39[8:8] 
X	T41[8:8] T42[8:8] T47[8:8] T50[8:8] 
X	T22[7:7] T29[7:7] T30[7:7] s[7:7] 
X	T33[7:7] T35[7:7] T39[7:7] T41[7:7] 
X	T42[7:7] T47[7:7] T50[7:7] T22[6:6] 
X	T29[6:6] T30[6:6] s[6:6] T33[6:6] 
X	T35[6:6] T39[6:6] T41[6:6] T42[6:6] 
X	T47[6:6] T50[6:6] T22[5:5] T29[5:5] 
X	T30[5:5] s[5:5] T33[5:5] T35[5:5] 
X	T39[5:5] T41[5:5] T42[5:5] T47[5:5] 
X	T50[5:5] T22[4:4] T29[4:4] T30[4:4] 
X	s[4:4] T33[4:4] T35[4:4] T39[4:4] 
X	T41[4:4] T42[4:4] T47[4:4] T50[4:4] 
X	T22[3:3] T29[3:3] T30[3:3] s[3:3] 
X	T33[3:3] T35[3:3] T39[3:3] T41[3:3] 
X	T42[3:3] T47[3:3] T50[3:3] T22[2:2] 
X	T29[2:2] T30[2:2] s[2:2] T33[2:2] 
X	T35[2:2] T39[2:2] T41[2:2] T42[2:2] 
X	T47[2:2] T50[2:2] T22[1:1] T29[1:1] 
X	T30[1:1] s[1:1] T33[1:1] T35[1:1] 
X	T39[1:1] T41[1:1] T42[1:1] T47[1:1] 
X	T50[1:1] T22[0:0] T29[0:0] T30[0:0] 
X	s[0:0] T33[0:0] T35[0:0] T39[0:0] 
X	T41[0:0] T42[0:0] T47[0:0] T50[0:0] 
X	T24[15:15] T24[14:14] T24[13:13] T24[12:12] 
X	T24[11:11] T24[10:10] T24[9:9] T24[8:8] 
X	T24[7:7] T24[6:6] T24[5:5] T24[4:4] 
X	T24[3:3] T24[2:2] T24[1:1] T24[0:0] 
X	T14[0:0] T14[1:1] T14[2:2] T14[3:3] 
X	T17[15:15] T20[15:15] T17[14:14] T20[14:14] 
X	T17[13:13] T20[13:13] T17[12:12] T20[12:12] 
X	T17[11:11] T20[11:11] T17[10:10] T20[10:10] 
X	T17[9:9] T20[9:9] T17[8:8] T20[8:8] 
X	T17[7:7] T20[7:7] T17[6:6] T20[6:6] 
X	T17[5:5] T20[5:5] T17[4:4] T20[4:4] 
X	T17[3:3] T20[3:3] T17[2:2] T20[2:2] 
X	T17[1:1] T20[1:1] T17[0:0] T20[0:0] 
X	T16[15:15] T19[15:15] T16[14:14] T19[14:14] 
X	T16[13:13] T19[13:13] T16[12:12] T19[12:12] 
X	T16[11:11] T19[11:11] T16[10:10] T19[10:10] 
X	T16[9:9] T19[9:9] T16[8:8] T19[8:8] 
X	T16[7:7] T19[7:7] T16[6:6] T19[6:6] 
X	T16[5:5] T19[5:5] T16[4:4] T19[4:4] 
X	T16[3:3] T19[3:3] T16[2:2] T19[2:2] 
X	T16[1:1] T19[1:1] T16[0:0] T19[0:0] 
X	T18[15:15] T21[15:15] T18[14:14] T21[14:14] 
X	T18[13:13] T21[13:13] T18[12:12] T21[12:12] 
X	T18[11:11] T21[11:11] T18[10:10] T21[10:10] 
X	T18[9:9] T21[9:9] T18[8:8] T21[8:8] 
X	T18[7:7] T21[7:7] T18[6:6] T21[6:6] 
X	T18[5:5] T21[5:5] T18[4:4] T21[4:4] 
X	T18[3:3] T21[3:3] T18[2:2] T21[2:2] 
X	T18[1:1] T21[1:1] T18[0:0] T21[0:0] 
X	T36[0:0] ;
X                  .outputs M3[0:0] M3[1:1] M3[2:2] M3[3:3] 
X	M3[4:4] M3[5:5] M3[6:6] M3[7:7] 
X	M3[8:8] M3[9:9] M3[10:10] M3[11:11] 
X	M3[12:12] M3[13:13] M3[14:14] M3[15:15] 
X	X93[0:0] X94[0:0] X95[0:0] X96[0:0] 
X	X97[0:0] X98[0:0] X99[0:0] X100[0:0] 
X	X101[0:0] X102[0:0] X103[0:0] X104[0:0] 
X	X105[0:0] X106[0:0] X107[0:0] X108[0:0] 
X	X109[0:0] X110[0:0] X111[0:0] X112[0:0] 
X	X113[0:0] X114[0:0] X115[0:0] X116[0:0] 
X	X117[0:0] X118[0:0] X119[0:0] X120[0:0] 
X	X121[0:0] X122[0:0] X123[0:0] X124[0:0] 
X	X125[0:0] X126[0:0] X127[0:0] X128[0:0] 
X	X129[0:0] X130[0:0] X131[0:0] X132[0:0] 
X	X133[0:0] X134[0:0] X135[0:0] X136[0:0] 
X	X137[0:0] X138[0:0] X139[0:0] X140[0:0] 
X	X141[0:0] X142[0:0] X143[0:0] X144[0:0] 
X	X145[0:0] X146[0:0] X147[0:0] X148[0:0] 
X	X149[0:0] X150[0:0] X151[0:0] X152[0:0] 
X	X153[0:0] X154[0:0] X155[0:0] X156[0:0] 
X	X157[0:0] X158[0:0] X159[0:0] X160[0:0] 
X	X161[0:0] X162[0:0] X163[0:0] X164[0:0] 
X	X165[0:0] X166[0:0] X167[0:0] X168[0:0] 
X	X169[0:0] X170[0:0] X171[0:0] X172[0:0] 
X	X173[0:0] X174[0:0] X175[0:0] X176[0:0] 
X	X177[0:0] X178[0:0] X179[0:0] X180[0:0] 
X	X181[0:0] X182[0:0] X183[0:0] X184[0:0] 
X	X185[0:0] X186[0:0] X187[0:0] X188[0:0] 
X	T53[0:0] ;
X                  .successors 4 ;	#  predecessors 2 
X                  .operation logic 6 ;
X                    #	Expression 0
X                    M3[0:0] = X92[0:0] ;
X                    M3[1:1] = X91[0:0] ;
X                    M3[2:2] = X90[0:0] ;
X                    M3[3:3] = X89[0:0] ;
X                    M3[4:4] = X88[0:0] ;
X                    M3[5:5] = X87[0:0] ;
X                    M3[6:6] = X86[0:0] ;
X                    M3[7:7] = X85[0:0] ;
X                    M3[8:8] = X84[0:0] ;
X                    M3[9:9] = X83[0:0] ;
X                    M3[10:10] = X82[0:0] ;
X                    M3[11:11] = X81[0:0] ;
X                    M3[12:12] =  0 ;
X                    M3[13:13] =  0 ;
X                    M3[14:14] =  0 ;
X                    M3[15:15] =  0 ;
X                    M4[0:0] = i[4:4] ;
X                    M4[1:1] = i[5:5] ;
X                    M4[2:2] = i[6:6] ;
X                    M4[3:3] = i[7:7] ;
X                    M4[4:4] = i[8:8] ;
X                    M4[5:5] = i[9:9] ;
X                    M4[6:6] = i[10:10] ;
X                    M4[7:7] = i[11:11] ;
X                    M4[8:8] = i[12:12] ;
X                    M4[9:9] = i[13:13] ;
X                    M4[10:10] = i[14:14] ;
X                    M4[11:11] = i[15:15] ;
X                    M4[12:12] =  0 ;
X                    M4[13:13] =  0 ;
X                    M4[14:14] =  0 ;
X                    M4[15:15] =  0 ;
X                    X81[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[15:15] ))+(V0100_T13_0_3[0:0]  i[15:15] ))+(V1100_T13_0_3[0:0]  i[15:15] ))+(V0010_T13_0_3[0:0]  i[15:15] ))+(V1010_T13_0_3[0:0]  i[15:15] ))+(V0110_T13_0_3[0:0]  i[15:15] ))+(V1110_T13_0_3[0:0]  i[15:15] ))+(V0001_T13_0_3[0:0]  i[15:15] ))+(V1001_T13_0_3[0:0]  i[15:15] ))+(V0101_T13_0_3[0:0]  i[15:15] ))+(V1101_T13_0_3[0:0]  i[15:15] ))+(V0011_T13_0_3[0:0]  i[15:15] ))+(V1011_T13_0_3[0:0]  i[15:15] ))+(V0111_T13_0_3[0:0]  i[15:15] ))+(V1111_T13_0_3[0:0]  i[15:15] ));
X                    X82[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[14:14] ))+(V0100_T13_0_3[0:0]  i[14:14] ))+(V1100_T13_0_3[0:0]  i[14:14] ))+(V0010_T13_0_3[0:0]  i[14:14] ))+(V1010_T13_0_3[0:0]  i[14:14] ))+(V0110_T13_0_3[0:0]  i[14:14] ))+(V1110_T13_0_3[0:0]  i[14:14] ))+(V0001_T13_0_3[0:0]  i[14:14] ))+(V1001_T13_0_3[0:0]  i[14:14] ))+(V0101_T13_0_3[0:0]  i[14:14] ))+(V1101_T13_0_3[0:0]  i[14:14] ))+(V0011_T13_0_3[0:0]  i[14:14] ))+(V1011_T13_0_3[0:0]  i[14:14] ))+(V0111_T13_0_3[0:0]  i[14:14] ))+(V1111_T13_0_3[0:0]  i[14:14] ));
X                    X83[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[13:13] ))+(V0100_T13_0_3[0:0]  i[13:13] ))+(V1100_T13_0_3[0:0]  i[13:13] ))+(V0010_T13_0_3[0:0]  i[13:13] ))+(V1010_T13_0_3[0:0]  i[13:13] ))+(V0110_T13_0_3[0:0]  i[13:13] ))+(V1110_T13_0_3[0:0]  i[13:13] ))+(V0001_T13_0_3[0:0]  i[13:13] ))+(V1001_T13_0_3[0:0]  i[13:13] ))+(V0101_T13_0_3[0:0]  i[13:13] ))+(V1101_T13_0_3[0:0]  i[13:13] ))+(V0011_T13_0_3[0:0]  i[13:13] ))+(V1011_T13_0_3[0:0]  i[13:13] ))+(V0111_T13_0_3[0:0]  i[13:13] ))+(V1111_T13_0_3[0:0]  i[13:13] ));
X                    X84[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[12:12] ))+(V0100_T13_0_3[0:0]  i[12:12] ))+(V1100_T13_0_3[0:0]  i[12:12] ))+(V0010_T13_0_3[0:0]  i[12:12] ))+(V1010_T13_0_3[0:0]  i[12:12] ))+(V0110_T13_0_3[0:0]  i[12:12] ))+(V1110_T13_0_3[0:0]  i[12:12] ))+(V0001_T13_0_3[0:0]  i[12:12] ))+(V1001_T13_0_3[0:0]  i[12:12] ))+(V0101_T13_0_3[0:0]  i[12:12] ))+(V1101_T13_0_3[0:0]  i[12:12] ))+(V0011_T13_0_3[0:0]  i[12:12] ))+(V1011_T13_0_3[0:0]  i[12:12] ))+(V0111_T13_0_3[0:0]  i[12:12] ))+(V1111_T13_0_3[0:0]  i[12:12] ));
X                    X85[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[11:11] ))+(V0100_T13_0_3[0:0]  i[11:11] ))+(V1100_T13_0_3[0:0]  i[11:11] ))+(V0010_T13_0_3[0:0]  i[11:11] ))+(V1010_T13_0_3[0:0]  i[11:11] ))+(V0110_T13_0_3[0:0]  i[11:11] ))+(V1110_T13_0_3[0:0]  i[11:11] ))+(V0001_T13_0_3[0:0]  i[11:11] ))+(V1001_T13_0_3[0:0]  i[11:11] ))+(V0101_T13_0_3[0:0]  i[11:11] ))+(V1101_T13_0_3[0:0]  i[11:11] ))+(V0011_T13_0_3[0:0]  i[11:11] ))+(V1011_T13_0_3[0:0]  i[11:11] ))+(V0111_T13_0_3[0:0]  i[11:11] ))+(V1111_T13_0_3[0:0]  i[11:11] ));
X                    X86[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[10:10] ))+(V0100_T13_0_3[0:0]  i[10:10] ))+(V1100_T13_0_3[0:0]  i[10:10] ))+(V0010_T13_0_3[0:0]  i[10:10] ))+(V1010_T13_0_3[0:0]  i[10:10] ))+(V0110_T13_0_3[0:0]  i[10:10] ))+(V1110_T13_0_3[0:0]  i[10:10] ))+(V0001_T13_0_3[0:0]  i[10:10] ))+(V1001_T13_0_3[0:0]  i[10:10] ))+(V0101_T13_0_3[0:0]  i[10:10] ))+(V1101_T13_0_3[0:0]  i[10:10] ))+(V0011_T13_0_3[0:0]  i[10:10] ))+(V1011_T13_0_3[0:0]  i[10:10] ))+(V0111_T13_0_3[0:0]  i[10:10] ))+(V1111_T13_0_3[0:0]  i[10:10] ));
X                    X87[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[9:9] ))+(V0100_T13_0_3[0:0]  i[9:9] ))+(V1100_T13_0_3[0:0]  i[9:9] ))+(V0010_T13_0_3[0:0]  i[9:9] ))+(V1010_T13_0_3[0:0]  i[9:9] ))+(V0110_T13_0_3[0:0]  i[9:9] ))+(V1110_T13_0_3[0:0]  i[9:9] ))+(V0001_T13_0_3[0:0]  i[9:9] ))+(V1001_T13_0_3[0:0]  i[9:9] ))+(V0101_T13_0_3[0:0]  i[9:9] ))+(V1101_T13_0_3[0:0]  i[9:9] ))+(V0011_T13_0_3[0:0]  i[9:9] ))+(V1011_T13_0_3[0:0]  i[9:9] ))+(V0111_T13_0_3[0:0]  i[9:9] ))+(V1111_T13_0_3[0:0]  i[9:9] ));
X                    X88[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[8:8] ))+(V0100_T13_0_3[0:0]  i[8:8] ))+(V1100_T13_0_3[0:0]  i[8:8] ))+(V0010_T13_0_3[0:0]  i[8:8] ))+(V1010_T13_0_3[0:0]  i[8:8] ))+(V0110_T13_0_3[0:0]  i[8:8] ))+(V1110_T13_0_3[0:0]  i[8:8] ))+(V0001_T13_0_3[0:0]  i[8:8] ))+(V1001_T13_0_3[0:0]  i[8:8] ))+(V0101_T13_0_3[0:0]  i[8:8] ))+(V1101_T13_0_3[0:0]  i[8:8] ))+(V0011_T13_0_3[0:0]  i[8:8] ))+(V1011_T13_0_3[0:0]  i[8:8] ))+(V0111_T13_0_3[0:0]  i[8:8] ))+(V1111_T13_0_3[0:0]  i[8:8] ));
X                    X89[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[7:7] ))+(V0100_T13_0_3[0:0]  i[7:7] ))+(V1100_T13_0_3[0:0]  i[7:7] ))+(V0010_T13_0_3[0:0]  i[7:7] ))+(V1010_T13_0_3[0:0]  i[7:7] ))+(V0110_T13_0_3[0:0]  i[7:7] ))+(V1110_T13_0_3[0:0]  i[7:7] ))+(V0001_T13_0_3[0:0]  i[7:7] ))+(V1001_T13_0_3[0:0]  i[7:7] ))+(V0101_T13_0_3[0:0]  i[7:7] ))+(V1101_T13_0_3[0:0]  i[7:7] ))+(V0011_T13_0_3[0:0]  i[7:7] ))+(V1011_T13_0_3[0:0]  i[7:7] ))+(V0111_T13_0_3[0:0]  i[7:7] ))+(V1111_T13_0_3[0:0]  i[7:7] ));
X                    X90[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[6:6] ))+(V0100_T13_0_3[0:0]  i[6:6] ))+(V1100_T13_0_3[0:0]  i[6:6] ))+(V0010_T13_0_3[0:0]  i[6:6] ))+(V1010_T13_0_3[0:0]  i[6:6] ))+(V0110_T13_0_3[0:0]  i[6:6] ))+(V1110_T13_0_3[0:0]  i[6:6] ))+(V0001_T13_0_3[0:0]  i[6:6] ))+(V1001_T13_0_3[0:0]  i[6:6] ))+(V0101_T13_0_3[0:0]  i[6:6] ))+(V1101_T13_0_3[0:0]  i[6:6] ))+(V0011_T13_0_3[0:0]  i[6:6] ))+(V1011_T13_0_3[0:0]  i[6:6] ))+(V0111_T13_0_3[0:0]  i[6:6] ))+(V1111_T13_0_3[0:0]  i[6:6] ));
X                    X91[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[5:5] ))+(V0100_T13_0_3[0:0]  i[5:5] ))+(V1100_T13_0_3[0:0]  i[5:5] ))+(V0010_T13_0_3[0:0]  i[5:5] ))+(V1010_T13_0_3[0:0]  i[5:5] ))+(V0110_T13_0_3[0:0]  i[5:5] ))+(V1110_T13_0_3[0:0]  i[5:5] ))+(V0001_T13_0_3[0:0]  i[5:5] ))+(V1001_T13_0_3[0:0]  i[5:5] ))+(V0101_T13_0_3[0:0]  i[5:5] ))+(V1101_T13_0_3[0:0]  i[5:5] ))+(V0011_T13_0_3[0:0]  i[5:5] ))+(V1011_T13_0_3[0:0]  i[5:5] ))+(V0111_T13_0_3[0:0]  i[5:5] ))+(V1111_T13_0_3[0:0]  i[5:5] ));
X                    X92[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  M4[4:4] ))+(V0100_T13_0_3[0:0]  i[4:4] ))+(V1100_T13_0_3[0:0]  i[4:4] ))+(V0010_T13_0_3[0:0]  i[4:4] ))+(V1010_T13_0_3[0:0]  i[4:4] ))+(V0110_T13_0_3[0:0]  i[4:4] ))+(V1110_T13_0_3[0:0]  i[4:4] ))+(V0001_T13_0_3[0:0]  i[4:4] ))+(V1001_T13_0_3[0:0]  i[4:4] ))+(V0101_T13_0_3[0:0]  i[4:4] ))+(V1101_T13_0_3[0:0]  i[4:4] ))+(V0011_T13_0_3[0:0]  i[4:4] ))+(V1011_T13_0_3[0:0]  i[4:4] ))+(V0111_T13_0_3[0:0]  i[4:4] ))+(V1111_T13_0_3[0:0]  i[4:4] ));
X                    T52[0:0] = (V0000000000000000_M3_0_15[0:0] )';
X                    M5[0:0] = a[1:1] ;
X                    M5[1:1] = a[2:2] ;
X                    M5[2:2] = a[3:3] ;
X                    M5[3:3] = a[4:4] ;
X                    M5[4:4] = a[5:5] ;
X                    M5[5:5] = a[6:6] ;
X                    M5[6:6] = a[7:7] ;
X                    M5[7:7] = a[8:8] ;
X                    M5[8:8] = a[9:9] ;
X                    M5[9:9] = a[10:10] ;
X                    M5[10:10] = a[11:11] ;
X                    M5[11:11] = a[12:12] ;
X                    M5[12:12] = a[13:13] ;
X                    M5[13:13] = a[14:14] ;
X                    M5[14:14] = a[15:15] ;
X                    M5[15:15] =  0 ;
X                    X93[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[15:15] ))+(V0100_T13_0_3[0:0]  t[15:15] ))+(V1100_T13_0_3[0:0]  t[15:15] ))+(V0010_T13_0_3[0:0]  t[15:15] ))+(V1010_T13_0_3[0:0]  t[15:15] ))+(V0110_T13_0_3[0:0]  t[15:15] ))+(V1110_T13_0_3[0:0]  t[15:15] ))+(V0001_T13_0_3[0:0]  t[15:15] ))+(V1001_T13_0_3[0:0]  t[15:15] ))+(V0101_T13_0_3[0:0]  t[15:15] ))+(V1101_T13_0_3[0:0]  t[15:15] ))+(V0011_T13_0_3[0:0]  p[15:15] ))+(V1011_T13_0_3[0:0]  t[15:15] ))+(V0111_T13_0_3[0:0]  t[15:15] ))+(V1111_T13_0_3[0:0]  t[15:15] ));
X                    X94[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[14:14] ))+(V0100_T13_0_3[0:0]  t[14:14] ))+(V1100_T13_0_3[0:0]  t[14:14] ))+(V0010_T13_0_3[0:0]  t[14:14] ))+(V1010_T13_0_3[0:0]  t[14:14] ))+(V0110_T13_0_3[0:0]  t[14:14] ))+(V1110_T13_0_3[0:0]  t[14:14] ))+(V0001_T13_0_3[0:0]  t[14:14] ))+(V1001_T13_0_3[0:0]  t[14:14] ))+(V0101_T13_0_3[0:0]  t[14:14] ))+(V1101_T13_0_3[0:0]  t[14:14] ))+(V0011_T13_0_3[0:0]  p[14:14] ))+(V1011_T13_0_3[0:0]  t[14:14] ))+(V0111_T13_0_3[0:0]  t[14:14] ))+(V1111_T13_0_3[0:0]  t[14:14] ));
X                    X95[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[13:13] ))+(V0100_T13_0_3[0:0]  t[13:13] ))+(V1100_T13_0_3[0:0]  t[13:13] ))+(V0010_T13_0_3[0:0]  t[13:13] ))+(V1010_T13_0_3[0:0]  t[13:13] ))+(V0110_T13_0_3[0:0]  t[13:13] ))+(V1110_T13_0_3[0:0]  t[13:13] ))+(V0001_T13_0_3[0:0]  t[13:13] ))+(V1001_T13_0_3[0:0]  t[13:13] ))+(V0101_T13_0_3[0:0]  t[13:13] ))+(V1101_T13_0_3[0:0]  t[13:13] ))+(V0011_T13_0_3[0:0]  p[13:13] ))+(V1011_T13_0_3[0:0]  t[13:13] ))+(V0111_T13_0_3[0:0]  t[13:13] ))+(V1111_T13_0_3[0:0]  t[13:13] ));
X                    X96[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[12:12] ))+(V0100_T13_0_3[0:0]  t[12:12] ))+(V1100_T13_0_3[0:0]  t[12:12] ))+(V0010_T13_0_3[0:0]  t[12:12] ))+(V1010_T13_0_3[0:0]  t[12:12] ))+(V0110_T13_0_3[0:0]  t[12:12] ))+(V1110_T13_0_3[0:0]  t[12:12] ))+(V0001_T13_0_3[0:0]  t[12:12] ))+(V1001_T13_0_3[0:0]  t[12:12] ))+(V0101_T13_0_3[0:0]  t[12:12] ))+(V1101_T13_0_3[0:0]  t[12:12] ))+(V0011_T13_0_3[0:0]  p[12:12] ))+(V1011_T13_0_3[0:0]  t[12:12] ))+(V0111_T13_0_3[0:0]  t[12:12] ))+(V1111_T13_0_3[0:0]  t[12:12] ));
X                    X97[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[11:11] ))+(V0100_T13_0_3[0:0]  t[11:11] ))+(V1100_T13_0_3[0:0]  t[11:11] ))+(V0010_T13_0_3[0:0]  t[11:11] ))+(V1010_T13_0_3[0:0]  t[11:11] ))+(V0110_T13_0_3[0:0]  t[11:11] ))+(V1110_T13_0_3[0:0]  t[11:11] ))+(V0001_T13_0_3[0:0]  t[11:11] ))+(V1001_T13_0_3[0:0]  t[11:11] ))+(V0101_T13_0_3[0:0]  t[11:11] ))+(V1101_T13_0_3[0:0]  t[11:11] ))+(V0011_T13_0_3[0:0]  p[11:11] ))+(V1011_T13_0_3[0:0]  t[11:11] ))+(V0111_T13_0_3[0:0]  t[11:11] ))+(V1111_T13_0_3[0:0]  t[11:11] ));
X                    X98[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[10:10] ))+(V0100_T13_0_3[0:0]  t[10:10] ))+(V1100_T13_0_3[0:0]  t[10:10] ))+(V0010_T13_0_3[0:0]  t[10:10] ))+(V1010_T13_0_3[0:0]  t[10:10] ))+(V0110_T13_0_3[0:0]  t[10:10] ))+(V1110_T13_0_3[0:0]  t[10:10] ))+(V0001_T13_0_3[0:0]  t[10:10] ))+(V1001_T13_0_3[0:0]  t[10:10] ))+(V0101_T13_0_3[0:0]  t[10:10] ))+(V1101_T13_0_3[0:0]  t[10:10] ))+(V0011_T13_0_3[0:0]  p[10:10] ))+(V1011_T13_0_3[0:0]  t[10:10] ))+(V0111_T13_0_3[0:0]  t[10:10] ))+(V1111_T13_0_3[0:0]  t[10:10] ));
X                    X99[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[9:9] ))+(V0100_T13_0_3[0:0]  t[9:9] ))+(V1100_T13_0_3[0:0]  t[9:9] ))+(V0010_T13_0_3[0:0]  t[9:9] ))+(V1010_T13_0_3[0:0]  t[9:9] ))+(V0110_T13_0_3[0:0]  t[9:9] ))+(V1110_T13_0_3[0:0]  t[9:9] ))+(V0001_T13_0_3[0:0]  t[9:9] ))+(V1001_T13_0_3[0:0]  t[9:9] ))+(V0101_T13_0_3[0:0]  t[9:9] ))+(V1101_T13_0_3[0:0]  t[9:9] ))+(V0011_T13_0_3[0:0]  p[9:9] ))+(V1011_T13_0_3[0:0]  t[9:9] ))+(V0111_T13_0_3[0:0]  t[9:9] ))+(V1111_T13_0_3[0:0]  t[9:9] ));
X                    X100[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[8:8] ))+(V0100_T13_0_3[0:0]  t[8:8] ))+(V1100_T13_0_3[0:0]  t[8:8] ))+(V0010_T13_0_3[0:0]  t[8:8] ))+(V1010_T13_0_3[0:0]  t[8:8] ))+(V0110_T13_0_3[0:0]  t[8:8] ))+(V1110_T13_0_3[0:0]  t[8:8] ))+(V0001_T13_0_3[0:0]  t[8:8] ))+(V1001_T13_0_3[0:0]  t[8:8] ))+(V0101_T13_0_3[0:0]  t[8:8] ))+(V1101_T13_0_3[0:0]  t[8:8] ))+(V0011_T13_0_3[0:0]  p[8:8] ))+(V1011_T13_0_3[0:0]  t[8:8] ))+(V0111_T13_0_3[0:0]  t[8:8] ))+(V1111_T13_0_3[0:0]  t[8:8] ));
X                    X101[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[7:7] ))+(V0100_T13_0_3[0:0]  t[7:7] ))+(V1100_T13_0_3[0:0]  t[7:7] ))+(V0010_T13_0_3[0:0]  t[7:7] ))+(V1010_T13_0_3[0:0]  t[7:7] ))+(V0110_T13_0_3[0:0]  t[7:7] ))+(V1110_T13_0_3[0:0]  t[7:7] ))+(V0001_T13_0_3[0:0]  t[7:7] ))+(V1001_T13_0_3[0:0]  t[7:7] ))+(V0101_T13_0_3[0:0]  t[7:7] ))+(V1101_T13_0_3[0:0]  t[7:7] ))+(V0011_T13_0_3[0:0]  p[7:7] ))+(V1011_T13_0_3[0:0]  t[7:7] ))+(V0111_T13_0_3[0:0]  t[7:7] ))+(V1111_T13_0_3[0:0]  t[7:7] ));
X                    X102[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[6:6] ))+(V0100_T13_0_3[0:0]  t[6:6] ))+(V1100_T13_0_3[0:0]  t[6:6] ))+(V0010_T13_0_3[0:0]  t[6:6] ))+(V1010_T13_0_3[0:0]  t[6:6] ))+(V0110_T13_0_3[0:0]  t[6:6] ))+(V1110_T13_0_3[0:0]  t[6:6] ))+(V0001_T13_0_3[0:0]  t[6:6] ))+(V1001_T13_0_3[0:0]  t[6:6] ))+(V0101_T13_0_3[0:0]  t[6:6] ))+(V1101_T13_0_3[0:0]  t[6:6] ))+(V0011_T13_0_3[0:0]  p[6:6] ))+(V1011_T13_0_3[0:0]  t[6:6] ))+(V0111_T13_0_3[0:0]  t[6:6] ))+(V1111_T13_0_3[0:0]  t[6:6] ));
X                    X103[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[5:5] ))+(V0100_T13_0_3[0:0]  t[5:5] ))+(V1100_T13_0_3[0:0]  t[5:5] ))+(V0010_T13_0_3[0:0]  t[5:5] ))+(V1010_T13_0_3[0:0]  t[5:5] ))+(V0110_T13_0_3[0:0]  t[5:5] ))+(V1110_T13_0_3[0:0]  t[5:5] ))+(V0001_T13_0_3[0:0]  t[5:5] ))+(V1001_T13_0_3[0:0]  t[5:5] ))+(V0101_T13_0_3[0:0]  t[5:5] ))+(V1101_T13_0_3[0:0]  t[5:5] ))+(V0011_T13_0_3[0:0]  p[5:5] ))+(V1011_T13_0_3[0:0]  t[5:5] ))+(V0111_T13_0_3[0:0]  t[5:5] ))+(V1111_T13_0_3[0:0]  t[5:5] ));
X                    X104[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[4:4] ))+(V0100_T13_0_3[0:0]  t[4:4] ))+(V1100_T13_0_3[0:0]  t[4:4] ))+(V0010_T13_0_3[0:0]  t[4:4] ))+(V1010_T13_0_3[0:0]  t[4:4] ))+(V0110_T13_0_3[0:0]  t[4:4] ))+(V1110_T13_0_3[0:0]  t[4:4] ))+(V0001_T13_0_3[0:0]  t[4:4] ))+(V1001_T13_0_3[0:0]  t[4:4] ))+(V0101_T13_0_3[0:0]  t[4:4] ))+(V1101_T13_0_3[0:0]  t[4:4] ))+(V0011_T13_0_3[0:0]  p[4:4] ))+(V1011_T13_0_3[0:0]  t[4:4] ))+(V0111_T13_0_3[0:0]  t[4:4] ))+(V1111_T13_0_3[0:0]  t[4:4] ));
X                    X105[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[3:3] ))+(V0100_T13_0_3[0:0]  t[3:3] ))+(V1100_T13_0_3[0:0]  t[3:3] ))+(V0010_T13_0_3[0:0]  t[3:3] ))+(V1010_T13_0_3[0:0]  t[3:3] ))+(V0110_T13_0_3[0:0]  t[3:3] ))+(V1110_T13_0_3[0:0]  t[3:3] ))+(V0001_T13_0_3[0:0]  t[3:3] ))+(V1001_T13_0_3[0:0]  t[3:3] ))+(V0101_T13_0_3[0:0]  t[3:3] ))+(V1101_T13_0_3[0:0]  t[3:3] ))+(V0011_T13_0_3[0:0]  p[3:3] ))+(V1011_T13_0_3[0:0]  t[3:3] ))+(V0111_T13_0_3[0:0]  t[3:3] ))+(V1111_T13_0_3[0:0]  t[3:3] ));
X                    X106[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[2:2] ))+(V0100_T13_0_3[0:0]  t[2:2] ))+(V1100_T13_0_3[0:0]  t[2:2] ))+(V0010_T13_0_3[0:0]  t[2:2] ))+(V1010_T13_0_3[0:0]  t[2:2] ))+(V0110_T13_0_3[0:0]  t[2:2] ))+(V1110_T13_0_3[0:0]  t[2:2] ))+(V0001_T13_0_3[0:0]  t[2:2] ))+(V1001_T13_0_3[0:0]  t[2:2] ))+(V0101_T13_0_3[0:0]  t[2:2] ))+(V1101_T13_0_3[0:0]  t[2:2] ))+(V0011_T13_0_3[0:0]  p[2:2] ))+(V1011_T13_0_3[0:0]  t[2:2] ))+(V0111_T13_0_3[0:0]  t[2:2] ))+(V1111_T13_0_3[0:0]  t[2:2] ));
X                    X107[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[1:1] ))+(V0100_T13_0_3[0:0]  t[1:1] ))+(V1100_T13_0_3[0:0]  t[1:1] ))+(V0010_T13_0_3[0:0]  t[1:1] ))+(V1010_T13_0_3[0:0]  t[1:1] ))+(V0110_T13_0_3[0:0]  t[1:1] ))+(V1110_T13_0_3[0:0]  t[1:1] ))+(V0001_T13_0_3[0:0]  t[1:1] ))+(V1001_T13_0_3[0:0]  t[1:1] ))+(V0101_T13_0_3[0:0]  t[1:1] ))+(V1101_T13_0_3[0:0]  t[1:1] ))+(V0011_T13_0_3[0:0]  p[1:1] ))+(V1011_T13_0_3[0:0]  t[1:1] ))+(V0111_T13_0_3[0:0]  t[1:1] ))+(V1111_T13_0_3[0:0]  t[1:1] ));
X                    X108[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  t[0:0] ))+(V0100_T13_0_3[0:0]  t[0:0] ))+(V1100_T13_0_3[0:0]  t[0:0] ))+(V0010_T13_0_3[0:0]  t[0:0] ))+(V1010_T13_0_3[0:0]  t[0:0] ))+(V0110_T13_0_3[0:0]  t[0:0] ))+(V1110_T13_0_3[0:0]  t[0:0] ))+(V0001_T13_0_3[0:0]  t[0:0] ))+(V1001_T13_0_3[0:0]  t[0:0] ))+(V0101_T13_0_3[0:0]  t[0:0] ))+(V1101_T13_0_3[0:0]  t[0:0] ))+(V0011_T13_0_3[0:0]  p[0:0] ))+(V1011_T13_0_3[0:0]  t[0:0] ))+(V0111_T13_0_3[0:0]  t[0:0] ))+(V1111_T13_0_3[0:0]  t[0:0] ));
X                    X109[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X189[0:0] ))+(V0100_T13_0_3[0:0]  a[15:15] ))+(V1100_T13_0_3[0:0]  a[15:15] ))+(V0010_T13_0_3[0:0]  T28[15:15] ))+(V1010_T13_0_3[0:0]  a[15:15] ))+(V0110_T13_0_3[0:0]  b[15:15] ))+(V1110_T13_0_3[0:0]  T32[15:15] ))+(V0001_T13_0_3[0:0]  T34[15:15] ))+(V1001_T13_0_3[0:0]  T38[15:15] ))+(V0101_T13_0_3[0:0]  T40[15:15] ))+(V1101_T13_0_3[0:0]  a[15:15] ))+(V0011_T13_0_3[0:0]  b[15:15] ))+(V1011_T13_0_3[0:0]  T46[15:15] ))+(V0111_T13_0_3[0:0]  T49[15:15] ))+(V1111_T13_0_3[0:0]  b[15:15] ));
X                    X110[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X190[0:0] ))+(V0100_T13_0_3[0:0]  a[14:14] ))+(V1100_T13_0_3[0:0]  a[14:14] ))+(V0010_T13_0_3[0:0]  T28[14:14] ))+(V1010_T13_0_3[0:0]  a[14:14] ))+(V0110_T13_0_3[0:0]  b[14:14] ))+(V1110_T13_0_3[0:0]  T32[14:14] ))+(V0001_T13_0_3[0:0]  T34[14:14] ))+(V1001_T13_0_3[0:0]  T38[14:14] ))+(V0101_T13_0_3[0:0]  T40[14:14] ))+(V1101_T13_0_3[0:0]  a[14:14] ))+(V0011_T13_0_3[0:0]  b[14:14] ))+(V1011_T13_0_3[0:0]  T46[14:14] ))+(V0111_T13_0_3[0:0]  T49[14:14] ))+(V1111_T13_0_3[0:0]  b[14:14] ));
X                    X111[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X191[0:0] ))+(V0100_T13_0_3[0:0]  a[13:13] ))+(V1100_T13_0_3[0:0]  a[13:13] ))+(V0010_T13_0_3[0:0]  T28[13:13] ))+(V1010_T13_0_3[0:0]  a[13:13] ))+(V0110_T13_0_3[0:0]  b[13:13] ))+(V1110_T13_0_3[0:0]  T32[13:13] ))+(V0001_T13_0_3[0:0]  T34[13:13] ))+(V1001_T13_0_3[0:0]  T38[13:13] ))+(V0101_T13_0_3[0:0]  T40[13:13] ))+(V1101_T13_0_3[0:0]  a[13:13] ))+(V0011_T13_0_3[0:0]  b[13:13] ))+(V1011_T13_0_3[0:0]  T46[13:13] ))+(V0111_T13_0_3[0:0]  T49[13:13] ))+(V1111_T13_0_3[0:0]  b[13:13] ));
X                    X112[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X192[0:0] ))+(V0100_T13_0_3[0:0]  a[12:12] ))+(V1100_T13_0_3[0:0]  a[12:12] ))+(V0010_T13_0_3[0:0]  T28[12:12] ))+(V1010_T13_0_3[0:0]  a[12:12] ))+(V0110_T13_0_3[0:0]  b[12:12] ))+(V1110_T13_0_3[0:0]  T32[12:12] ))+(V0001_T13_0_3[0:0]  T34[12:12] ))+(V1001_T13_0_3[0:0]  T38[12:12] ))+(V0101_T13_0_3[0:0]  T40[12:12] ))+(V1101_T13_0_3[0:0]  a[12:12] ))+(V0011_T13_0_3[0:0]  b[12:12] ))+(V1011_T13_0_3[0:0]  T46[12:12] ))+(V0111_T13_0_3[0:0]  T49[12:12] ))+(V1111_T13_0_3[0:0]  b[12:12] ));
X                    X113[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X193[0:0] ))+(V0100_T13_0_3[0:0]  a[11:11] ))+(V1100_T13_0_3[0:0]  a[11:11] ))+(V0010_T13_0_3[0:0]  T28[11:11] ))+(V1010_T13_0_3[0:0]  a[11:11] ))+(V0110_T13_0_3[0:0]  b[11:11] ))+(V1110_T13_0_3[0:0]  T32[11:11] ))+(V0001_T13_0_3[0:0]  T34[11:11] ))+(V1001_T13_0_3[0:0]  T38[11:11] ))+(V0101_T13_0_3[0:0]  T40[11:11] ))+(V1101_T13_0_3[0:0]  a[11:11] ))+(V0011_T13_0_3[0:0]  b[11:11] ))+(V1011_T13_0_3[0:0]  T46[11:11] ))+(V0111_T13_0_3[0:0]  T49[11:11] ))+(V1111_T13_0_3[0:0]  b[11:11] ));
X                    X114[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X194[0:0] ))+(V0100_T13_0_3[0:0]  a[10:10] ))+(V1100_T13_0_3[0:0]  a[10:10] ))+(V0010_T13_0_3[0:0]  T28[10:10] ))+(V1010_T13_0_3[0:0]  a[10:10] ))+(V0110_T13_0_3[0:0]  b[10:10] ))+(V1110_T13_0_3[0:0]  T32[10:10] ))+(V0001_T13_0_3[0:0]  T34[10:10] ))+(V1001_T13_0_3[0:0]  T38[10:10] ))+(V0101_T13_0_3[0:0]  T40[10:10] ))+(V1101_T13_0_3[0:0]  a[10:10] ))+(V0011_T13_0_3[0:0]  b[10:10] ))+(V1011_T13_0_3[0:0]  T46[10:10] ))+(V0111_T13_0_3[0:0]  T49[10:10] ))+(V1111_T13_0_3[0:0]  b[10:10] ));
X                    X115[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X195[0:0] ))+(V0100_T13_0_3[0:0]  a[9:9] ))+(V1100_T13_0_3[0:0]  a[9:9] ))+(V0010_T13_0_3[0:0]  T28[9:9] ))+(V1010_T13_0_3[0:0]  a[9:9] ))+(V0110_T13_0_3[0:0]  b[9:9] ))+(V1110_T13_0_3[0:0]  T32[9:9] ))+(V0001_T13_0_3[0:0]  T34[9:9] ))+(V1001_T13_0_3[0:0]  T38[9:9] ))+(V0101_T13_0_3[0:0]  T40[9:9] ))+(V1101_T13_0_3[0:0]  a[9:9] ))+(V0011_T13_0_3[0:0]  b[9:9] ))+(V1011_T13_0_3[0:0]  T46[9:9] ))+(V0111_T13_0_3[0:0]  T49[9:9] ))+(V1111_T13_0_3[0:0]  b[9:9] ));
X                    X116[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X196[0:0] ))+(V0100_T13_0_3[0:0]  a[8:8] ))+(V1100_T13_0_3[0:0]  a[8:8] ))+(V0010_T13_0_3[0:0]  T28[8:8] ))+(V1010_T13_0_3[0:0]  a[8:8] ))+(V0110_T13_0_3[0:0]  b[8:8] ))+(V1110_T13_0_3[0:0]  T32[8:8] ))+(V0001_T13_0_3[0:0]  T34[8:8] ))+(V1001_T13_0_3[0:0]  T38[8:8] ))+(V0101_T13_0_3[0:0]  T40[8:8] ))+(V1101_T13_0_3[0:0]  a[8:8] ))+(V0011_T13_0_3[0:0]  b[8:8] ))+(V1011_T13_0_3[0:0]  T46[8:8] ))+(V0111_T13_0_3[0:0]  T49[8:8] ))+(V1111_T13_0_3[0:0]  b[8:8] ));
X                    X117[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X197[0:0] ))+(V0100_T13_0_3[0:0]  a[7:7] ))+(V1100_T13_0_3[0:0]  a[7:7] ))+(V0010_T13_0_3[0:0]  T28[7:7] ))+(V1010_T13_0_3[0:0]  a[7:7] ))+(V0110_T13_0_3[0:0]  b[7:7] ))+(V1110_T13_0_3[0:0]  T32[7:7] ))+(V0001_T13_0_3[0:0]  T34[7:7] ))+(V1001_T13_0_3[0:0]  T38[7:7] ))+(V0101_T13_0_3[0:0]  T40[7:7] ))+(V1101_T13_0_3[0:0]  a[7:7] ))+(V0011_T13_0_3[0:0]  b[7:7] ))+(V1011_T13_0_3[0:0]  T46[7:7] ))+(V0111_T13_0_3[0:0]  T49[7:7] ))+(V1111_T13_0_3[0:0]  b[7:7] ));
X                    X118[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X198[0:0] ))+(V0100_T13_0_3[0:0]  a[6:6] ))+(V1100_T13_0_3[0:0]  a[6:6] ))+(V0010_T13_0_3[0:0]  T28[6:6] ))+(V1010_T13_0_3[0:0]  a[6:6] ))+(V0110_T13_0_3[0:0]  b[6:6] ))+(V1110_T13_0_3[0:0]  T32[6:6] ))+(V0001_T13_0_3[0:0]  T34[6:6] ))+(V1001_T13_0_3[0:0]  T38[6:6] ))+(V0101_T13_0_3[0:0]  T40[6:6] ))+(V1101_T13_0_3[0:0]  a[6:6] ))+(V0011_T13_0_3[0:0]  b[6:6] ))+(V1011_T13_0_3[0:0]  T46[6:6] ))+(V0111_T13_0_3[0:0]  T49[6:6] ))+(V1111_T13_0_3[0:0]  b[6:6] ));
X                    X119[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X199[0:0] ))+(V0100_T13_0_3[0:0]  a[5:5] ))+(V1100_T13_0_3[0:0]  a[5:5] ))+(V0010_T13_0_3[0:0]  T28[5:5] ))+(V1010_T13_0_3[0:0]  a[5:5] ))+(V0110_T13_0_3[0:0]  b[5:5] ))+(V1110_T13_0_3[0:0]  T32[5:5] ))+(V0001_T13_0_3[0:0]  T34[5:5] ))+(V1001_T13_0_3[0:0]  T38[5:5] ))+(V0101_T13_0_3[0:0]  T40[5:5] ))+(V1101_T13_0_3[0:0]  a[5:5] ))+(V0011_T13_0_3[0:0]  b[5:5] ))+(V1011_T13_0_3[0:0]  T46[5:5] ))+(V0111_T13_0_3[0:0]  T49[5:5] ))+(V1111_T13_0_3[0:0]  b[5:5] ));
X                    X120[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X200[0:0] ))+(V0100_T13_0_3[0:0]  a[4:4] ))+(V1100_T13_0_3[0:0]  a[4:4] ))+(V0010_T13_0_3[0:0]  T28[4:4] ))+(V1010_T13_0_3[0:0]  a[4:4] ))+(V0110_T13_0_3[0:0]  b[4:4] ))+(V1110_T13_0_3[0:0]  T32[4:4] ))+(V0001_T13_0_3[0:0]  T34[4:4] ))+(V1001_T13_0_3[0:0]  T38[4:4] ))+(V0101_T13_0_3[0:0]  T40[4:4] ))+(V1101_T13_0_3[0:0]  a[4:4] ))+(V0011_T13_0_3[0:0]  b[4:4] ))+(V1011_T13_0_3[0:0]  T46[4:4] ))+(V0111_T13_0_3[0:0]  T49[4:4] ))+(V1111_T13_0_3[0:0]  b[4:4] ));
X                    X121[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X201[0:0] ))+(V0100_T13_0_3[0:0]  a[3:3] ))+(V1100_T13_0_3[0:0]  a[3:3] ))+(V0010_T13_0_3[0:0]  T28[3:3] ))+(V1010_T13_0_3[0:0]  a[3:3] ))+(V0110_T13_0_3[0:0]  b[3:3] ))+(V1110_T13_0_3[0:0]  T32[3:3] ))+(V0001_T13_0_3[0:0]  T34[3:3] ))+(V1001_T13_0_3[0:0]  T38[3:3] ))+(V0101_T13_0_3[0:0]  T40[3:3] ))+(V1101_T13_0_3[0:0]  a[3:3] ))+(V0011_T13_0_3[0:0]  b[3:3] ))+(V1011_T13_0_3[0:0]  T46[3:3] ))+(V0111_T13_0_3[0:0]  T49[3:3] ))+(V1111_T13_0_3[0:0]  b[3:3] ));
X                    X122[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X202[0:0] ))+(V0100_T13_0_3[0:0]  a[2:2] ))+(V1100_T13_0_3[0:0]  a[2:2] ))+(V0010_T13_0_3[0:0]  T28[2:2] ))+(V1010_T13_0_3[0:0]  a[2:2] ))+(V0110_T13_0_3[0:0]  b[2:2] ))+(V1110_T13_0_3[0:0]  T32[2:2] ))+(V0001_T13_0_3[0:0]  T34[2:2] ))+(V1001_T13_0_3[0:0]  T38[2:2] ))+(V0101_T13_0_3[0:0]  T40[2:2] ))+(V1101_T13_0_3[0:0]  a[2:2] ))+(V0011_T13_0_3[0:0]  b[2:2] ))+(V1011_T13_0_3[0:0]  T46[2:2] ))+(V0111_T13_0_3[0:0]  T49[2:2] ))+(V1111_T13_0_3[0:0]  b[2:2] ));
X                    X123[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X203[0:0] ))+(V0100_T13_0_3[0:0]  a[1:1] ))+(V1100_T13_0_3[0:0]  a[1:1] ))+(V0010_T13_0_3[0:0]  T28[1:1] ))+(V1010_T13_0_3[0:0]  a[1:1] ))+(V0110_T13_0_3[0:0]  b[1:1] ))+(V1110_T13_0_3[0:0]  T32[1:1] ))+(V0001_T13_0_3[0:0]  T34[1:1] ))+(V1001_T13_0_3[0:0]  T38[1:1] ))+(V0101_T13_0_3[0:0]  T40[1:1] ))+(V1101_T13_0_3[0:0]  a[1:1] ))+(V0011_T13_0_3[0:0]  b[1:1] ))+(V1011_T13_0_3[0:0]  T46[1:1] ))+(V0111_T13_0_3[0:0]  T49[1:1] ))+(V1111_T13_0_3[0:0]  b[1:1] ));
X                    X124[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X204[0:0] ))+(V0100_T13_0_3[0:0]  a[0:0] ))+(V1100_T13_0_3[0:0]  a[0:0] ))+(V0010_T13_0_3[0:0]  T28[0:0] ))+(V1010_T13_0_3[0:0]  a[0:0] ))+(V0110_T13_0_3[0:0]  b[0:0] ))+(V1110_T13_0_3[0:0]  T32[0:0] ))+(V0001_T13_0_3[0:0]  T34[0:0] ))+(V1001_T13_0_3[0:0]  T38[0:0] ))+(V0101_T13_0_3[0:0]  T40[0:0] ))+(V1101_T13_0_3[0:0]  a[0:0] ))+(V0011_T13_0_3[0:0]  b[0:0] ))+(V1011_T13_0_3[0:0]  T46[0:0] ))+(V0111_T13_0_3[0:0]  T49[0:0] ))+(V1111_T13_0_3[0:0]  b[0:0] ));
X                    X125[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X205[0:0] ))+(V0100_T13_0_3[0:0]  T23[15:15] ))+(V1100_T13_0_3[0:0]  T25[15:15] ))+(V0010_T13_0_3[0:0]  T26[15:15] ))+(V1010_T13_0_3[0:0]  m[15:15] ))+(V0110_T13_0_3[0:0]  T31[15:15] ))+(V1110_T13_0_3[0:0]  b[15:15] ))+(V0001_T13_0_3[0:0]  b[15:15] ))+(V1001_T13_0_3[0:0]  b[15:15] ))+(V0101_T13_0_3[0:0]  b[15:15] ))+(V1101_T13_0_3[0:0]  m[15:15] ))+(V0011_T13_0_3[0:0]  p[15:15] ))+(V1011_T13_0_3[0:0]  a[15:15] ))+(V0111_T13_0_3[0:0]  T48[15:15] ))+(V1111_T13_0_3[0:0]  T51[15:15] ));
X                    X126[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X206[0:0] ))+(V0100_T13_0_3[0:0]  T23[14:14] ))+(V1100_T13_0_3[0:0]  T25[14:14] ))+(V0010_T13_0_3[0:0]  T26[14:14] ))+(V1010_T13_0_3[0:0]  m[14:14] ))+(V0110_T13_0_3[0:0]  T31[14:14] ))+(V1110_T13_0_3[0:0]  b[14:14] ))+(V0001_T13_0_3[0:0]  b[14:14] ))+(V1001_T13_0_3[0:0]  b[14:14] ))+(V0101_T13_0_3[0:0]  b[14:14] ))+(V1101_T13_0_3[0:0]  m[14:14] ))+(V0011_T13_0_3[0:0]  p[14:14] ))+(V1011_T13_0_3[0:0]  a[14:14] ))+(V0111_T13_0_3[0:0]  T48[14:14] ))+(V1111_T13_0_3[0:0]  T51[14:14] ));
X                    X127[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X207[0:0] ))+(V0100_T13_0_3[0:0]  T23[13:13] ))+(V1100_T13_0_3[0:0]  T25[13:13] ))+(V0010_T13_0_3[0:0]  T26[13:13] ))+(V1010_T13_0_3[0:0]  m[13:13] ))+(V0110_T13_0_3[0:0]  T31[13:13] ))+(V1110_T13_0_3[0:0]  b[13:13] ))+(V0001_T13_0_3[0:0]  b[13:13] ))+(V1001_T13_0_3[0:0]  b[13:13] ))+(V0101_T13_0_3[0:0]  b[13:13] ))+(V1101_T13_0_3[0:0]  m[13:13] ))+(V0011_T13_0_3[0:0]  p[13:13] ))+(V1011_T13_0_3[0:0]  a[13:13] ))+(V0111_T13_0_3[0:0]  T48[13:13] ))+(V1111_T13_0_3[0:0]  T51[13:13] ));
X                    X128[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X208[0:0] ))+(V0100_T13_0_3[0:0]  T23[12:12] ))+(V1100_T13_0_3[0:0]  T25[12:12] ))+(V0010_T13_0_3[0:0]  T26[12:12] ))+(V1010_T13_0_3[0:0]  m[12:12] ))+(V0110_T13_0_3[0:0]  T31[12:12] ))+(V1110_T13_0_3[0:0]  b[12:12] ))+(V0001_T13_0_3[0:0]  b[12:12] ))+(V1001_T13_0_3[0:0]  b[12:12] ))+(V0101_T13_0_3[0:0]  b[12:12] ))+(V1101_T13_0_3[0:0]  m[12:12] ))+(V0011_T13_0_3[0:0]  p[12:12] ))+(V1011_T13_0_3[0:0]  a[12:12] ))+(V0111_T13_0_3[0:0]  T48[12:12] ))+(V1111_T13_0_3[0:0]  T51[12:12] ));
X                    X129[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X209[0:0] ))+(V0100_T13_0_3[0:0]  T23[11:11] ))+(V1100_T13_0_3[0:0]  T25[11:11] ))+(V0010_T13_0_3[0:0]  T26[11:11] ))+(V1010_T13_0_3[0:0]  m[11:11] ))+(V0110_T13_0_3[0:0]  T31[11:11] ))+(V1110_T13_0_3[0:0]  b[11:11] ))+(V0001_T13_0_3[0:0]  b[11:11] ))+(V1001_T13_0_3[0:0]  b[11:11] ))+(V0101_T13_0_3[0:0]  b[11:11] ))+(V1101_T13_0_3[0:0]  m[11:11] ))+(V0011_T13_0_3[0:0]  p[11:11] ))+(V1011_T13_0_3[0:0]  a[11:11] ))+(V0111_T13_0_3[0:0]  T48[11:11] ))+(V1111_T13_0_3[0:0]  T51[11:11] ));
X                    X130[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X210[0:0] ))+(V0100_T13_0_3[0:0]  T23[10:10] ))+(V1100_T13_0_3[0:0]  T25[10:10] ))+(V0010_T13_0_3[0:0]  T26[10:10] ))+(V1010_T13_0_3[0:0]  m[10:10] ))+(V0110_T13_0_3[0:0]  T31[10:10] ))+(V1110_T13_0_3[0:0]  b[10:10] ))+(V0001_T13_0_3[0:0]  b[10:10] ))+(V1001_T13_0_3[0:0]  b[10:10] ))+(V0101_T13_0_3[0:0]  b[10:10] ))+(V1101_T13_0_3[0:0]  m[10:10] ))+(V0011_T13_0_3[0:0]  p[10:10] ))+(V1011_T13_0_3[0:0]  a[10:10] ))+(V0111_T13_0_3[0:0]  T48[10:10] ))+(V1111_T13_0_3[0:0]  T51[10:10] ));
X                    X131[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X211[0:0] ))+(V0100_T13_0_3[0:0]  T23[9:9] ))+(V1100_T13_0_3[0:0]  T25[9:9] ))+(V0010_T13_0_3[0:0]  T26[9:9] ))+(V1010_T13_0_3[0:0]  m[9:9] ))+(V0110_T13_0_3[0:0]  T31[9:9] ))+(V1110_T13_0_3[0:0]  b[9:9] ))+(V0001_T13_0_3[0:0]  b[9:9] ))+(V1001_T13_0_3[0:0]  b[9:9] ))+(V0101_T13_0_3[0:0]  b[9:9] ))+(V1101_T13_0_3[0:0]  m[9:9] ))+(V0011_T13_0_3[0:0]  p[9:9] ))+(V1011_T13_0_3[0:0]  a[9:9] ))+(V0111_T13_0_3[0:0]  T48[9:9] ))+(V1111_T13_0_3[0:0]  T51[9:9] ));
X                    X132[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X212[0:0] ))+(V0100_T13_0_3[0:0]  T23[8:8] ))+(V1100_T13_0_3[0:0]  T25[8:8] ))+(V0010_T13_0_3[0:0]  T26[8:8] ))+(V1010_T13_0_3[0:0]  m[8:8] ))+(V0110_T13_0_3[0:0]  T31[8:8] ))+(V1110_T13_0_3[0:0]  b[8:8] ))+(V0001_T13_0_3[0:0]  b[8:8] ))+(V1001_T13_0_3[0:0]  b[8:8] ))+(V0101_T13_0_3[0:0]  b[8:8] ))+(V1101_T13_0_3[0:0]  m[8:8] ))+(V0011_T13_0_3[0:0]  p[8:8] ))+(V1011_T13_0_3[0:0]  a[8:8] ))+(V0111_T13_0_3[0:0]  T48[8:8] ))+(V1111_T13_0_3[0:0]  T51[8:8] ));
X                    X133[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X213[0:0] ))+(V0100_T13_0_3[0:0]  T23[7:7] ))+(V1100_T13_0_3[0:0]  T25[7:7] ))+(V0010_T13_0_3[0:0]  T26[7:7] ))+(V1010_T13_0_3[0:0]  m[7:7] ))+(V0110_T13_0_3[0:0]  T31[7:7] ))+(V1110_T13_0_3[0:0]  b[7:7] ))+(V0001_T13_0_3[0:0]  b[7:7] ))+(V1001_T13_0_3[0:0]  b[7:7] ))+(V0101_T13_0_3[0:0]  b[7:7] ))+(V1101_T13_0_3[0:0]  m[7:7] ))+(V0011_T13_0_3[0:0]  p[7:7] ))+(V1011_T13_0_3[0:0]  a[7:7] ))+(V0111_T13_0_3[0:0]  T48[7:7] ))+(V1111_T13_0_3[0:0]  T51[7:7] ));
X                    X134[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X214[0:0] ))+(V0100_T13_0_3[0:0]  T23[6:6] ))+(V1100_T13_0_3[0:0]  T25[6:6] ))+(V0010_T13_0_3[0:0]  T26[6:6] ))+(V1010_T13_0_3[0:0]  m[6:6] ))+(V0110_T13_0_3[0:0]  T31[6:6] ))+(V1110_T13_0_3[0:0]  b[6:6] ))+(V0001_T13_0_3[0:0]  b[6:6] ))+(V1001_T13_0_3[0:0]  b[6:6] ))+(V0101_T13_0_3[0:0]  b[6:6] ))+(V1101_T13_0_3[0:0]  m[6:6] ))+(V0011_T13_0_3[0:0]  p[6:6] ))+(V1011_T13_0_3[0:0]  a[6:6] ))+(V0111_T13_0_3[0:0]  T48[6:6] ))+(V1111_T13_0_3[0:0]  T51[6:6] ));
X                    X135[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X215[0:0] ))+(V0100_T13_0_3[0:0]  T23[5:5] ))+(V1100_T13_0_3[0:0]  T25[5:5] ))+(V0010_T13_0_3[0:0]  T26[5:5] ))+(V1010_T13_0_3[0:0]  m[5:5] ))+(V0110_T13_0_3[0:0]  T31[5:5] ))+(V1110_T13_0_3[0:0]  b[5:5] ))+(V0001_T13_0_3[0:0]  b[5:5] ))+(V1001_T13_0_3[0:0]  b[5:5] ))+(V0101_T13_0_3[0:0]  b[5:5] ))+(V1101_T13_0_3[0:0]  m[5:5] ))+(V0011_T13_0_3[0:0]  p[5:5] ))+(V1011_T13_0_3[0:0]  a[5:5] ))+(V0111_T13_0_3[0:0]  T48[5:5] ))+(V1111_T13_0_3[0:0]  T51[5:5] ));
X                    X136[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X216[0:0] ))+(V0100_T13_0_3[0:0]  T23[4:4] ))+(V1100_T13_0_3[0:0]  T25[4:4] ))+(V0010_T13_0_3[0:0]  T26[4:4] ))+(V1010_T13_0_3[0:0]  m[4:4] ))+(V0110_T13_0_3[0:0]  T31[4:4] ))+(V1110_T13_0_3[0:0]  b[4:4] ))+(V0001_T13_0_3[0:0]  b[4:4] ))+(V1001_T13_0_3[0:0]  b[4:4] ))+(V0101_T13_0_3[0:0]  b[4:4] ))+(V1101_T13_0_3[0:0]  m[4:4] ))+(V0011_T13_0_3[0:0]  p[4:4] ))+(V1011_T13_0_3[0:0]  a[4:4] ))+(V0111_T13_0_3[0:0]  T48[4:4] ))+(V1111_T13_0_3[0:0]  T51[4:4] ));
X                    X137[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X217[0:0] ))+(V0100_T13_0_3[0:0]  T23[3:3] ))+(V1100_T13_0_3[0:0]  T25[3:3] ))+(V0010_T13_0_3[0:0]  T26[3:3] ))+(V1010_T13_0_3[0:0]  m[3:3] ))+(V0110_T13_0_3[0:0]  T31[3:3] ))+(V1110_T13_0_3[0:0]  b[3:3] ))+(V0001_T13_0_3[0:0]  b[3:3] ))+(V1001_T13_0_3[0:0]  b[3:3] ))+(V0101_T13_0_3[0:0]  b[3:3] ))+(V1101_T13_0_3[0:0]  m[3:3] ))+(V0011_T13_0_3[0:0]  p[3:3] ))+(V1011_T13_0_3[0:0]  a[3:3] ))+(V0111_T13_0_3[0:0]  T48[3:3] ))+(V1111_T13_0_3[0:0]  T51[3:3] ));
X                    X138[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X218[0:0] ))+(V0100_T13_0_3[0:0]  T23[2:2] ))+(V1100_T13_0_3[0:0]  T25[2:2] ))+(V0010_T13_0_3[0:0]  T26[2:2] ))+(V1010_T13_0_3[0:0]  m[2:2] ))+(V0110_T13_0_3[0:0]  T31[2:2] ))+(V1110_T13_0_3[0:0]  b[2:2] ))+(V0001_T13_0_3[0:0]  b[2:2] ))+(V1001_T13_0_3[0:0]  b[2:2] ))+(V0101_T13_0_3[0:0]  b[2:2] ))+(V1101_T13_0_3[0:0]  m[2:2] ))+(V0011_T13_0_3[0:0]  p[2:2] ))+(V1011_T13_0_3[0:0]  a[2:2] ))+(V0111_T13_0_3[0:0]  T48[2:2] ))+(V1111_T13_0_3[0:0]  T51[2:2] ));
X                    X139[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X219[0:0] ))+(V0100_T13_0_3[0:0]  T23[1:1] ))+(V1100_T13_0_3[0:0]  T25[1:1] ))+(V0010_T13_0_3[0:0]  T26[1:1] ))+(V1010_T13_0_3[0:0]  m[1:1] ))+(V0110_T13_0_3[0:0]  T31[1:1] ))+(V1110_T13_0_3[0:0]  b[1:1] ))+(V0001_T13_0_3[0:0]  b[1:1] ))+(V1001_T13_0_3[0:0]  b[1:1] ))+(V0101_T13_0_3[0:0]  b[1:1] ))+(V1101_T13_0_3[0:0]  m[1:1] ))+(V0011_T13_0_3[0:0]  p[1:1] ))+(V1011_T13_0_3[0:0]  a[1:1] ))+(V0111_T13_0_3[0:0]  T48[1:1] ))+(V1111_T13_0_3[0:0]  T51[1:1] ));
X                    X140[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X220[0:0] ))+(V0100_T13_0_3[0:0]  T23[0:0] ))+(V1100_T13_0_3[0:0]  T25[0:0] ))+(V0010_T13_0_3[0:0]  T26[0:0] ))+(V1010_T13_0_3[0:0]  m[0:0] ))+(V0110_T13_0_3[0:0]  T31[0:0] ))+(V1110_T13_0_3[0:0]  b[0:0] ))+(V0001_T13_0_3[0:0]  b[0:0] ))+(V1001_T13_0_3[0:0]  b[0:0] ))+(V0101_T13_0_3[0:0]  b[0:0] ))+(V1101_T13_0_3[0:0]  m[0:0] ))+(V0011_T13_0_3[0:0]  p[0:0] ))+(V1011_T13_0_3[0:0]  a[0:0] ))+(V0111_T13_0_3[0:0]  T48[0:0] ))+(V1111_T13_0_3[0:0]  T51[0:0] ));
X                    X141[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[15:15] ))+(V0100_T13_0_3[0:0]  m[15:15] ))+(V1100_T13_0_3[0:0]  m[15:15] ))+(V0010_T13_0_3[0:0]  m[15:15] ))+(V1010_T13_0_3[0:0]  m[15:15] ))+(V0110_T13_0_3[0:0]  m[15:15] ))+(V1110_T13_0_3[0:0]  m[15:15] ))+(V0001_T13_0_3[0:0]  m[15:15] ))+(V1001_T13_0_3[0:0]  m[15:15] ))+(V0101_T13_0_3[0:0]  m[15:15] ))+(V1101_T13_0_3[0:0]  T43[15:15] ))+(V0011_T13_0_3[0:0]  m[15:15] ))+(V1011_T13_0_3[0:0]  T44[15:15] ))+(V0111_T13_0_3[0:0]  m[15:15] ))+(V1111_T13_0_3[0:0]  m[15:15] ));
X                    X142[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[14:14] ))+(V0100_T13_0_3[0:0]  m[14:14] ))+(V1100_T13_0_3[0:0]  m[14:14] ))+(V0010_T13_0_3[0:0]  m[14:14] ))+(V1010_T13_0_3[0:0]  m[14:14] ))+(V0110_T13_0_3[0:0]  m[14:14] ))+(V1110_T13_0_3[0:0]  m[14:14] ))+(V0001_T13_0_3[0:0]  m[14:14] ))+(V1001_T13_0_3[0:0]  m[14:14] ))+(V0101_T13_0_3[0:0]  m[14:14] ))+(V1101_T13_0_3[0:0]  T43[14:14] ))+(V0011_T13_0_3[0:0]  m[14:14] ))+(V1011_T13_0_3[0:0]  T44[14:14] ))+(V0111_T13_0_3[0:0]  m[14:14] ))+(V1111_T13_0_3[0:0]  m[14:14] ));
X                    X143[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[13:13] ))+(V0100_T13_0_3[0:0]  m[13:13] ))+(V1100_T13_0_3[0:0]  m[13:13] ))+(V0010_T13_0_3[0:0]  m[13:13] ))+(V1010_T13_0_3[0:0]  m[13:13] ))+(V0110_T13_0_3[0:0]  m[13:13] ))+(V1110_T13_0_3[0:0]  m[13:13] ))+(V0001_T13_0_3[0:0]  m[13:13] ))+(V1001_T13_0_3[0:0]  m[13:13] ))+(V0101_T13_0_3[0:0]  m[13:13] ))+(V1101_T13_0_3[0:0]  T43[13:13] ))+(V0011_T13_0_3[0:0]  m[13:13] ))+(V1011_T13_0_3[0:0]  T44[13:13] ))+(V0111_T13_0_3[0:0]  m[13:13] ))+(V1111_T13_0_3[0:0]  m[13:13] ));
X                    X144[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[12:12] ))+(V0100_T13_0_3[0:0]  m[12:12] ))+(V1100_T13_0_3[0:0]  m[12:12] ))+(V0010_T13_0_3[0:0]  m[12:12] ))+(V1010_T13_0_3[0:0]  m[12:12] ))+(V0110_T13_0_3[0:0]  m[12:12] ))+(V1110_T13_0_3[0:0]  m[12:12] ))+(V0001_T13_0_3[0:0]  m[12:12] ))+(V1001_T13_0_3[0:0]  m[12:12] ))+(V0101_T13_0_3[0:0]  m[12:12] ))+(V1101_T13_0_3[0:0]  T43[12:12] ))+(V0011_T13_0_3[0:0]  m[12:12] ))+(V1011_T13_0_3[0:0]  T44[12:12] ))+(V0111_T13_0_3[0:0]  m[12:12] ))+(V1111_T13_0_3[0:0]  m[12:12] ));
X                    X145[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[11:11] ))+(V0100_T13_0_3[0:0]  m[11:11] ))+(V1100_T13_0_3[0:0]  m[11:11] ))+(V0010_T13_0_3[0:0]  m[11:11] ))+(V1010_T13_0_3[0:0]  m[11:11] ))+(V0110_T13_0_3[0:0]  m[11:11] ))+(V1110_T13_0_3[0:0]  m[11:11] ))+(V0001_T13_0_3[0:0]  m[11:11] ))+(V1001_T13_0_3[0:0]  m[11:11] ))+(V0101_T13_0_3[0:0]  m[11:11] ))+(V1101_T13_0_3[0:0]  T43[11:11] ))+(V0011_T13_0_3[0:0]  m[11:11] ))+(V1011_T13_0_3[0:0]  T44[11:11] ))+(V0111_T13_0_3[0:0]  m[11:11] ))+(V1111_T13_0_3[0:0]  m[11:11] ));
X                    X146[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[10:10] ))+(V0100_T13_0_3[0:0]  m[10:10] ))+(V1100_T13_0_3[0:0]  m[10:10] ))+(V0010_T13_0_3[0:0]  m[10:10] ))+(V1010_T13_0_3[0:0]  m[10:10] ))+(V0110_T13_0_3[0:0]  m[10:10] ))+(V1110_T13_0_3[0:0]  m[10:10] ))+(V0001_T13_0_3[0:0]  m[10:10] ))+(V1001_T13_0_3[0:0]  m[10:10] ))+(V0101_T13_0_3[0:0]  m[10:10] ))+(V1101_T13_0_3[0:0]  T43[10:10] ))+(V0011_T13_0_3[0:0]  m[10:10] ))+(V1011_T13_0_3[0:0]  T44[10:10] ))+(V0111_T13_0_3[0:0]  m[10:10] ))+(V1111_T13_0_3[0:0]  m[10:10] ));
X                    X147[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[9:9] ))+(V0100_T13_0_3[0:0]  m[9:9] ))+(V1100_T13_0_3[0:0]  m[9:9] ))+(V0010_T13_0_3[0:0]  m[9:9] ))+(V1010_T13_0_3[0:0]  m[9:9] ))+(V0110_T13_0_3[0:0]  m[9:9] ))+(V1110_T13_0_3[0:0]  m[9:9] ))+(V0001_T13_0_3[0:0]  m[9:9] ))+(V1001_T13_0_3[0:0]  m[9:9] ))+(V0101_T13_0_3[0:0]  m[9:9] ))+(V1101_T13_0_3[0:0]  T43[9:9] ))+(V0011_T13_0_3[0:0]  m[9:9] ))+(V1011_T13_0_3[0:0]  T44[9:9] ))+(V0111_T13_0_3[0:0]  m[9:9] ))+(V1111_T13_0_3[0:0]  m[9:9] ));
X                    X148[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[8:8] ))+(V0100_T13_0_3[0:0]  m[8:8] ))+(V1100_T13_0_3[0:0]  m[8:8] ))+(V0010_T13_0_3[0:0]  m[8:8] ))+(V1010_T13_0_3[0:0]  m[8:8] ))+(V0110_T13_0_3[0:0]  m[8:8] ))+(V1110_T13_0_3[0:0]  m[8:8] ))+(V0001_T13_0_3[0:0]  m[8:8] ))+(V1001_T13_0_3[0:0]  m[8:8] ))+(V0101_T13_0_3[0:0]  m[8:8] ))+(V1101_T13_0_3[0:0]  T43[8:8] ))+(V0011_T13_0_3[0:0]  m[8:8] ))+(V1011_T13_0_3[0:0]  T44[8:8] ))+(V0111_T13_0_3[0:0]  m[8:8] ))+(V1111_T13_0_3[0:0]  m[8:8] ));
X                    X149[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[7:7] ))+(V0100_T13_0_3[0:0]  m[7:7] ))+(V1100_T13_0_3[0:0]  m[7:7] ))+(V0010_T13_0_3[0:0]  m[7:7] ))+(V1010_T13_0_3[0:0]  m[7:7] ))+(V0110_T13_0_3[0:0]  m[7:7] ))+(V1110_T13_0_3[0:0]  m[7:7] ))+(V0001_T13_0_3[0:0]  m[7:7] ))+(V1001_T13_0_3[0:0]  m[7:7] ))+(V0101_T13_0_3[0:0]  m[7:7] ))+(V1101_T13_0_3[0:0]  T43[7:7] ))+(V0011_T13_0_3[0:0]  m[7:7] ))+(V1011_T13_0_3[0:0]  T44[7:7] ))+(V0111_T13_0_3[0:0]  m[7:7] ))+(V1111_T13_0_3[0:0]  m[7:7] ));
X                    X150[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[6:6] ))+(V0100_T13_0_3[0:0]  m[6:6] ))+(V1100_T13_0_3[0:0]  m[6:6] ))+(V0010_T13_0_3[0:0]  m[6:6] ))+(V1010_T13_0_3[0:0]  m[6:6] ))+(V0110_T13_0_3[0:0]  m[6:6] ))+(V1110_T13_0_3[0:0]  m[6:6] ))+(V0001_T13_0_3[0:0]  m[6:6] ))+(V1001_T13_0_3[0:0]  m[6:6] ))+(V0101_T13_0_3[0:0]  m[6:6] ))+(V1101_T13_0_3[0:0]  T43[6:6] ))+(V0011_T13_0_3[0:0]  m[6:6] ))+(V1011_T13_0_3[0:0]  T44[6:6] ))+(V0111_T13_0_3[0:0]  m[6:6] ))+(V1111_T13_0_3[0:0]  m[6:6] ));
X                    X151[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[5:5] ))+(V0100_T13_0_3[0:0]  m[5:5] ))+(V1100_T13_0_3[0:0]  m[5:5] ))+(V0010_T13_0_3[0:0]  m[5:5] ))+(V1010_T13_0_3[0:0]  m[5:5] ))+(V0110_T13_0_3[0:0]  m[5:5] ))+(V1110_T13_0_3[0:0]  m[5:5] ))+(V0001_T13_0_3[0:0]  m[5:5] ))+(V1001_T13_0_3[0:0]  m[5:5] ))+(V0101_T13_0_3[0:0]  m[5:5] ))+(V1101_T13_0_3[0:0]  T43[5:5] ))+(V0011_T13_0_3[0:0]  m[5:5] ))+(V1011_T13_0_3[0:0]  T44[5:5] ))+(V0111_T13_0_3[0:0]  m[5:5] ))+(V1111_T13_0_3[0:0]  m[5:5] ));
X                    X152[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[4:4] ))+(V0100_T13_0_3[0:0]  m[4:4] ))+(V1100_T13_0_3[0:0]  m[4:4] ))+(V0010_T13_0_3[0:0]  m[4:4] ))+(V1010_T13_0_3[0:0]  m[4:4] ))+(V0110_T13_0_3[0:0]  m[4:4] ))+(V1110_T13_0_3[0:0]  m[4:4] ))+(V0001_T13_0_3[0:0]  m[4:4] ))+(V1001_T13_0_3[0:0]  m[4:4] ))+(V0101_T13_0_3[0:0]  m[4:4] ))+(V1101_T13_0_3[0:0]  T43[4:4] ))+(V0011_T13_0_3[0:0]  m[4:4] ))+(V1011_T13_0_3[0:0]  T44[4:4] ))+(V0111_T13_0_3[0:0]  m[4:4] ))+(V1111_T13_0_3[0:0]  m[4:4] ));
X                    X153[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[3:3] ))+(V0100_T13_0_3[0:0]  m[3:3] ))+(V1100_T13_0_3[0:0]  m[3:3] ))+(V0010_T13_0_3[0:0]  m[3:3] ))+(V1010_T13_0_3[0:0]  m[3:3] ))+(V0110_T13_0_3[0:0]  m[3:3] ))+(V1110_T13_0_3[0:0]  m[3:3] ))+(V0001_T13_0_3[0:0]  m[3:3] ))+(V1001_T13_0_3[0:0]  m[3:3] ))+(V0101_T13_0_3[0:0]  m[3:3] ))+(V1101_T13_0_3[0:0]  T43[3:3] ))+(V0011_T13_0_3[0:0]  m[3:3] ))+(V1011_T13_0_3[0:0]  T44[3:3] ))+(V0111_T13_0_3[0:0]  m[3:3] ))+(V1111_T13_0_3[0:0]  m[3:3] ));
X                    X154[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[2:2] ))+(V0100_T13_0_3[0:0]  m[2:2] ))+(V1100_T13_0_3[0:0]  m[2:2] ))+(V0010_T13_0_3[0:0]  m[2:2] ))+(V1010_T13_0_3[0:0]  m[2:2] ))+(V0110_T13_0_3[0:0]  m[2:2] ))+(V1110_T13_0_3[0:0]  m[2:2] ))+(V0001_T13_0_3[0:0]  m[2:2] ))+(V1001_T13_0_3[0:0]  m[2:2] ))+(V0101_T13_0_3[0:0]  m[2:2] ))+(V1101_T13_0_3[0:0]  T43[2:2] ))+(V0011_T13_0_3[0:0]  m[2:2] ))+(V1011_T13_0_3[0:0]  T44[2:2] ))+(V0111_T13_0_3[0:0]  m[2:2] ))+(V1111_T13_0_3[0:0]  m[2:2] ));
X                    X155[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[1:1] ))+(V0100_T13_0_3[0:0]  m[1:1] ))+(V1100_T13_0_3[0:0]  m[1:1] ))+(V0010_T13_0_3[0:0]  m[1:1] ))+(V1010_T13_0_3[0:0]  m[1:1] ))+(V0110_T13_0_3[0:0]  m[1:1] ))+(V1110_T13_0_3[0:0]  m[1:1] ))+(V0001_T13_0_3[0:0]  m[1:1] ))+(V1001_T13_0_3[0:0]  m[1:1] ))+(V0101_T13_0_3[0:0]  m[1:1] ))+(V1101_T13_0_3[0:0]  T43[1:1] ))+(V0011_T13_0_3[0:0]  m[1:1] ))+(V1011_T13_0_3[0:0]  T44[1:1] ))+(V0111_T13_0_3[0:0]  m[1:1] ))+(V1111_T13_0_3[0:0]  m[1:1] ));
X                    X156[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  m[0:0] ))+(V0100_T13_0_3[0:0]  m[0:0] ))+(V1100_T13_0_3[0:0]  m[0:0] ))+(V0010_T13_0_3[0:0]  m[0:0] ))+(V1010_T13_0_3[0:0]  m[0:0] ))+(V0110_T13_0_3[0:0]  m[0:0] ))+(V1110_T13_0_3[0:0]  m[0:0] ))+(V0001_T13_0_3[0:0]  m[0:0] ))+(V1001_T13_0_3[0:0]  m[0:0] ))+(V0101_T13_0_3[0:0]  m[0:0] ))+(V1101_T13_0_3[0:0]  T43[0:0] ))+(V0011_T13_0_3[0:0]  m[0:0] ))+(V1011_T13_0_3[0:0]  T44[0:0] ))+(V0111_T13_0_3[0:0]  m[0:0] ))+(V1111_T13_0_3[0:0]  m[0:0] ));
X                    X157[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X221[0:0] ))+(V0100_T13_0_3[0:0]  T22[15:15] ))+(V1100_T13_0_3[0:0]  T25[15:15] ))+(V0010_T13_0_3[0:0]  T29[15:15] ))+(V1010_T13_0_3[0:0]  T30[15:15] ))+(V0110_T13_0_3[0:0]  s[15:15] ))+(V1110_T13_0_3[0:0]  T33[15:15] ))+(V0001_T13_0_3[0:0]  T35[15:15] ))+(V1001_T13_0_3[0:0]  T39[15:15] ))+(V0101_T13_0_3[0:0]  T41[15:15] ))+(V1101_T13_0_3[0:0]  T42[15:15] ))+(V0011_T13_0_3[0:0]  s[15:15] ))+(V1011_T13_0_3[0:0]  T47[15:15] ))+(V0111_T13_0_3[0:0]  T50[15:15] ))+(V1111_T13_0_3[0:0]  s[15:15] ));
X                    X158[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X222[0:0] ))+(V0100_T13_0_3[0:0]  T22[14:14] ))+(V1100_T13_0_3[0:0]  T25[14:14] ))+(V0010_T13_0_3[0:0]  T29[14:14] ))+(V1010_T13_0_3[0:0]  T30[14:14] ))+(V0110_T13_0_3[0:0]  s[14:14] ))+(V1110_T13_0_3[0:0]  T33[14:14] ))+(V0001_T13_0_3[0:0]  T35[14:14] ))+(V1001_T13_0_3[0:0]  T39[14:14] ))+(V0101_T13_0_3[0:0]  T41[14:14] ))+(V1101_T13_0_3[0:0]  T42[14:14] ))+(V0011_T13_0_3[0:0]  s[14:14] ))+(V1011_T13_0_3[0:0]  T47[14:14] ))+(V0111_T13_0_3[0:0]  T50[14:14] ))+(V1111_T13_0_3[0:0]  s[14:14] ));
X                    X159[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X223[0:0] ))+(V0100_T13_0_3[0:0]  T22[13:13] ))+(V1100_T13_0_3[0:0]  T25[13:13] ))+(V0010_T13_0_3[0:0]  T29[13:13] ))+(V1010_T13_0_3[0:0]  T30[13:13] ))+(V0110_T13_0_3[0:0]  s[13:13] ))+(V1110_T13_0_3[0:0]  T33[13:13] ))+(V0001_T13_0_3[0:0]  T35[13:13] ))+(V1001_T13_0_3[0:0]  T39[13:13] ))+(V0101_T13_0_3[0:0]  T41[13:13] ))+(V1101_T13_0_3[0:0]  T42[13:13] ))+(V0011_T13_0_3[0:0]  s[13:13] ))+(V1011_T13_0_3[0:0]  T47[13:13] ))+(V0111_T13_0_3[0:0]  T50[13:13] ))+(V1111_T13_0_3[0:0]  s[13:13] ));
X                    X160[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X224[0:0] ))+(V0100_T13_0_3[0:0]  T22[12:12] ))+(V1100_T13_0_3[0:0]  T25[12:12] ))+(V0010_T13_0_3[0:0]  T29[12:12] ))+(V1010_T13_0_3[0:0]  T30[12:12] ))+(V0110_T13_0_3[0:0]  s[12:12] ))+(V1110_T13_0_3[0:0]  T33[12:12] ))+(V0001_T13_0_3[0:0]  T35[12:12] ))+(V1001_T13_0_3[0:0]  T39[12:12] ))+(V0101_T13_0_3[0:0]  T41[12:12] ))+(V1101_T13_0_3[0:0]  T42[12:12] ))+(V0011_T13_0_3[0:0]  s[12:12] ))+(V1011_T13_0_3[0:0]  T47[12:12] ))+(V0111_T13_0_3[0:0]  T50[12:12] ))+(V1111_T13_0_3[0:0]  s[12:12] ));
X                    X161[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X225[0:0] ))+(V0100_T13_0_3[0:0]  T22[11:11] ))+(V1100_T13_0_3[0:0]  T25[11:11] ))+(V0010_T13_0_3[0:0]  T29[11:11] ))+(V1010_T13_0_3[0:0]  T30[11:11] ))+(V0110_T13_0_3[0:0]  s[11:11] ))+(V1110_T13_0_3[0:0]  T33[11:11] ))+(V0001_T13_0_3[0:0]  T35[11:11] ))+(V1001_T13_0_3[0:0]  T39[11:11] ))+(V0101_T13_0_3[0:0]  T41[11:11] ))+(V1101_T13_0_3[0:0]  T42[11:11] ))+(V0011_T13_0_3[0:0]  s[11:11] ))+(V1011_T13_0_3[0:0]  T47[11:11] ))+(V0111_T13_0_3[0:0]  T50[11:11] ))+(V1111_T13_0_3[0:0]  s[11:11] ));
X                    X162[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X226[0:0] ))+(V0100_T13_0_3[0:0]  T22[10:10] ))+(V1100_T13_0_3[0:0]  T25[10:10] ))+(V0010_T13_0_3[0:0]  T29[10:10] ))+(V1010_T13_0_3[0:0]  T30[10:10] ))+(V0110_T13_0_3[0:0]  s[10:10] ))+(V1110_T13_0_3[0:0]  T33[10:10] ))+(V0001_T13_0_3[0:0]  T35[10:10] ))+(V1001_T13_0_3[0:0]  T39[10:10] ))+(V0101_T13_0_3[0:0]  T41[10:10] ))+(V1101_T13_0_3[0:0]  T42[10:10] ))+(V0011_T13_0_3[0:0]  s[10:10] ))+(V1011_T13_0_3[0:0]  T47[10:10] ))+(V0111_T13_0_3[0:0]  T50[10:10] ))+(V1111_T13_0_3[0:0]  s[10:10] ));
X                    X163[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X227[0:0] ))+(V0100_T13_0_3[0:0]  T22[9:9] ))+(V1100_T13_0_3[0:0]  T25[9:9] ))+(V0010_T13_0_3[0:0]  T29[9:9] ))+(V1010_T13_0_3[0:0]  T30[9:9] ))+(V0110_T13_0_3[0:0]  s[9:9] ))+(V1110_T13_0_3[0:0]  T33[9:9] ))+(V0001_T13_0_3[0:0]  T35[9:9] ))+(V1001_T13_0_3[0:0]  T39[9:9] ))+(V0101_T13_0_3[0:0]  T41[9:9] ))+(V1101_T13_0_3[0:0]  T42[9:9] ))+(V0011_T13_0_3[0:0]  s[9:9] ))+(V1011_T13_0_3[0:0]  T47[9:9] ))+(V0111_T13_0_3[0:0]  T50[9:9] ))+(V1111_T13_0_3[0:0]  s[9:9] ));
X                    X164[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X228[0:0] ))+(V0100_T13_0_3[0:0]  T22[8:8] ))+(V1100_T13_0_3[0:0]  T25[8:8] ))+(V0010_T13_0_3[0:0]  T29[8:8] ))+(V1010_T13_0_3[0:0]  T30[8:8] ))+(V0110_T13_0_3[0:0]  s[8:8] ))+(V1110_T13_0_3[0:0]  T33[8:8] ))+(V0001_T13_0_3[0:0]  T35[8:8] ))+(V1001_T13_0_3[0:0]  T39[8:8] ))+(V0101_T13_0_3[0:0]  T41[8:8] ))+(V1101_T13_0_3[0:0]  T42[8:8] ))+(V0011_T13_0_3[0:0]  s[8:8] ))+(V1011_T13_0_3[0:0]  T47[8:8] ))+(V0111_T13_0_3[0:0]  T50[8:8] ))+(V1111_T13_0_3[0:0]  s[8:8] ));
X                    X165[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X229[0:0] ))+(V0100_T13_0_3[0:0]  T22[7:7] ))+(V1100_T13_0_3[0:0]  T25[7:7] ))+(V0010_T13_0_3[0:0]  T29[7:7] ))+(V1010_T13_0_3[0:0]  T30[7:7] ))+(V0110_T13_0_3[0:0]  s[7:7] ))+(V1110_T13_0_3[0:0]  T33[7:7] ))+(V0001_T13_0_3[0:0]  T35[7:7] ))+(V1001_T13_0_3[0:0]  T39[7:7] ))+(V0101_T13_0_3[0:0]  T41[7:7] ))+(V1101_T13_0_3[0:0]  T42[7:7] ))+(V0011_T13_0_3[0:0]  s[7:7] ))+(V1011_T13_0_3[0:0]  T47[7:7] ))+(V0111_T13_0_3[0:0]  T50[7:7] ))+(V1111_T13_0_3[0:0]  s[7:7] ));
X                    X166[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X230[0:0] ))+(V0100_T13_0_3[0:0]  T22[6:6] ))+(V1100_T13_0_3[0:0]  T25[6:6] ))+(V0010_T13_0_3[0:0]  T29[6:6] ))+(V1010_T13_0_3[0:0]  T30[6:6] ))+(V0110_T13_0_3[0:0]  s[6:6] ))+(V1110_T13_0_3[0:0]  T33[6:6] ))+(V0001_T13_0_3[0:0]  T35[6:6] ))+(V1001_T13_0_3[0:0]  T39[6:6] ))+(V0101_T13_0_3[0:0]  T41[6:6] ))+(V1101_T13_0_3[0:0]  T42[6:6] ))+(V0011_T13_0_3[0:0]  s[6:6] ))+(V1011_T13_0_3[0:0]  T47[6:6] ))+(V0111_T13_0_3[0:0]  T50[6:6] ))+(V1111_T13_0_3[0:0]  s[6:6] ));
X                    X167[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X231[0:0] ))+(V0100_T13_0_3[0:0]  T22[5:5] ))+(V1100_T13_0_3[0:0]  T25[5:5] ))+(V0010_T13_0_3[0:0]  T29[5:5] ))+(V1010_T13_0_3[0:0]  T30[5:5] ))+(V0110_T13_0_3[0:0]  s[5:5] ))+(V1110_T13_0_3[0:0]  T33[5:5] ))+(V0001_T13_0_3[0:0]  T35[5:5] ))+(V1001_T13_0_3[0:0]  T39[5:5] ))+(V0101_T13_0_3[0:0]  T41[5:5] ))+(V1101_T13_0_3[0:0]  T42[5:5] ))+(V0011_T13_0_3[0:0]  s[5:5] ))+(V1011_T13_0_3[0:0]  T47[5:5] ))+(V0111_T13_0_3[0:0]  T50[5:5] ))+(V1111_T13_0_3[0:0]  s[5:5] ));
X                    X168[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X232[0:0] ))+(V0100_T13_0_3[0:0]  T22[4:4] ))+(V1100_T13_0_3[0:0]  T25[4:4] ))+(V0010_T13_0_3[0:0]  T29[4:4] ))+(V1010_T13_0_3[0:0]  T30[4:4] ))+(V0110_T13_0_3[0:0]  s[4:4] ))+(V1110_T13_0_3[0:0]  T33[4:4] ))+(V0001_T13_0_3[0:0]  T35[4:4] ))+(V1001_T13_0_3[0:0]  T39[4:4] ))+(V0101_T13_0_3[0:0]  T41[4:4] ))+(V1101_T13_0_3[0:0]  T42[4:4] ))+(V0011_T13_0_3[0:0]  s[4:4] ))+(V1011_T13_0_3[0:0]  T47[4:4] ))+(V0111_T13_0_3[0:0]  T50[4:4] ))+(V1111_T13_0_3[0:0]  s[4:4] ));
X                    X169[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X233[0:0] ))+(V0100_T13_0_3[0:0]  T22[3:3] ))+(V1100_T13_0_3[0:0]  T25[3:3] ))+(V0010_T13_0_3[0:0]  T29[3:3] ))+(V1010_T13_0_3[0:0]  T30[3:3] ))+(V0110_T13_0_3[0:0]  s[3:3] ))+(V1110_T13_0_3[0:0]  T33[3:3] ))+(V0001_T13_0_3[0:0]  T35[3:3] ))+(V1001_T13_0_3[0:0]  T39[3:3] ))+(V0101_T13_0_3[0:0]  T41[3:3] ))+(V1101_T13_0_3[0:0]  T42[3:3] ))+(V0011_T13_0_3[0:0]  s[3:3] ))+(V1011_T13_0_3[0:0]  T47[3:3] ))+(V0111_T13_0_3[0:0]  T50[3:3] ))+(V1111_T13_0_3[0:0]  s[3:3] ));
X                    X170[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X234[0:0] ))+(V0100_T13_0_3[0:0]  T22[2:2] ))+(V1100_T13_0_3[0:0]  T25[2:2] ))+(V0010_T13_0_3[0:0]  T29[2:2] ))+(V1010_T13_0_3[0:0]  T30[2:2] ))+(V0110_T13_0_3[0:0]  s[2:2] ))+(V1110_T13_0_3[0:0]  T33[2:2] ))+(V0001_T13_0_3[0:0]  T35[2:2] ))+(V1001_T13_0_3[0:0]  T39[2:2] ))+(V0101_T13_0_3[0:0]  T41[2:2] ))+(V1101_T13_0_3[0:0]  T42[2:2] ))+(V0011_T13_0_3[0:0]  s[2:2] ))+(V1011_T13_0_3[0:0]  T47[2:2] ))+(V0111_T13_0_3[0:0]  T50[2:2] ))+(V1111_T13_0_3[0:0]  s[2:2] ));
X                    X171[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X235[0:0] ))+(V0100_T13_0_3[0:0]  T22[1:1] ))+(V1100_T13_0_3[0:0]  T25[1:1] ))+(V0010_T13_0_3[0:0]  T29[1:1] ))+(V1010_T13_0_3[0:0]  T30[1:1] ))+(V0110_T13_0_3[0:0]  s[1:1] ))+(V1110_T13_0_3[0:0]  T33[1:1] ))+(V0001_T13_0_3[0:0]  T35[1:1] ))+(V1001_T13_0_3[0:0]  T39[1:1] ))+(V0101_T13_0_3[0:0]  T41[1:1] ))+(V1101_T13_0_3[0:0]  T42[1:1] ))+(V0011_T13_0_3[0:0]  s[1:1] ))+(V1011_T13_0_3[0:0]  T47[1:1] ))+(V0111_T13_0_3[0:0]  T50[1:1] ))+(V1111_T13_0_3[0:0]  s[1:1] ));
X                    X172[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  X236[0:0] ))+(V0100_T13_0_3[0:0]  T22[0:0] ))+(V1100_T13_0_3[0:0]  T25[0:0] ))+(V0010_T13_0_3[0:0]  T29[0:0] ))+(V1010_T13_0_3[0:0]  T30[0:0] ))+(V0110_T13_0_3[0:0]  s[0:0] ))+(V1110_T13_0_3[0:0]  T33[0:0] ))+(V0001_T13_0_3[0:0]  T35[0:0] ))+(V1001_T13_0_3[0:0]  T39[0:0] ))+(V0101_T13_0_3[0:0]  T41[0:0] ))+(V1101_T13_0_3[0:0]  T42[0:0] ))+(V0011_T13_0_3[0:0]  s[0:0] ))+(V1011_T13_0_3[0:0]  T47[0:0] ))+(V0111_T13_0_3[0:0]  T50[0:0] ))+(V1111_T13_0_3[0:0]  s[0:0] ));
X                    X173[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[15:15] ))+(V0100_T13_0_3[0:0]  T24[15:15] ))+(V1100_T13_0_3[0:0]  p[15:15] ))+(V0010_T13_0_3[0:0]  p[15:15] ))+(V1010_T13_0_3[0:0]  p[15:15] ))+(V0110_T13_0_3[0:0]  p[15:15] ))+(V1110_T13_0_3[0:0]  p[15:15] ))+(V0001_T13_0_3[0:0]  a[15:15] ))+(V1001_T13_0_3[0:0]  X237[0:0] ))+(V0101_T13_0_3[0:0]  p[15:15] ))+(V1101_T13_0_3[0:0]  p[15:15] ))+(V0011_T13_0_3[0:0]  a[15:15] ))+(V1011_T13_0_3[0:0]  b[15:15] ))+(V0111_T13_0_3[0:0]  p[15:15] ))+(V1111_T13_0_3[0:0]  p[15:15] ));
X                    X174[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[14:14] ))+(V0100_T13_0_3[0:0]  T24[14:14] ))+(V1100_T13_0_3[0:0]  p[14:14] ))+(V0010_T13_0_3[0:0]  p[14:14] ))+(V1010_T13_0_3[0:0]  p[14:14] ))+(V0110_T13_0_3[0:0]  p[14:14] ))+(V1110_T13_0_3[0:0]  p[14:14] ))+(V0001_T13_0_3[0:0]  a[14:14] ))+(V1001_T13_0_3[0:0]  X238[0:0] ))+(V0101_T13_0_3[0:0]  p[14:14] ))+(V1101_T13_0_3[0:0]  p[14:14] ))+(V0011_T13_0_3[0:0]  a[14:14] ))+(V1011_T13_0_3[0:0]  b[14:14] ))+(V0111_T13_0_3[0:0]  p[14:14] ))+(V1111_T13_0_3[0:0]  p[14:14] ));
X                    X175[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[13:13] ))+(V0100_T13_0_3[0:0]  T24[13:13] ))+(V1100_T13_0_3[0:0]  p[13:13] ))+(V0010_T13_0_3[0:0]  p[13:13] ))+(V1010_T13_0_3[0:0]  p[13:13] ))+(V0110_T13_0_3[0:0]  p[13:13] ))+(V1110_T13_0_3[0:0]  p[13:13] ))+(V0001_T13_0_3[0:0]  a[13:13] ))+(V1001_T13_0_3[0:0]  X239[0:0] ))+(V0101_T13_0_3[0:0]  p[13:13] ))+(V1101_T13_0_3[0:0]  p[13:13] ))+(V0011_T13_0_3[0:0]  a[13:13] ))+(V1011_T13_0_3[0:0]  b[13:13] ))+(V0111_T13_0_3[0:0]  p[13:13] ))+(V1111_T13_0_3[0:0]  p[13:13] ));
X                    X176[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[12:12] ))+(V0100_T13_0_3[0:0]  T24[12:12] ))+(V1100_T13_0_3[0:0]  p[12:12] ))+(V0010_T13_0_3[0:0]  p[12:12] ))+(V1010_T13_0_3[0:0]  p[12:12] ))+(V0110_T13_0_3[0:0]  p[12:12] ))+(V1110_T13_0_3[0:0]  p[12:12] ))+(V0001_T13_0_3[0:0]  a[12:12] ))+(V1001_T13_0_3[0:0]  X240[0:0] ))+(V0101_T13_0_3[0:0]  p[12:12] ))+(V1101_T13_0_3[0:0]  p[12:12] ))+(V0011_T13_0_3[0:0]  a[12:12] ))+(V1011_T13_0_3[0:0]  b[12:12] ))+(V0111_T13_0_3[0:0]  p[12:12] ))+(V1111_T13_0_3[0:0]  p[12:12] ));
X                    X177[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[11:11] ))+(V0100_T13_0_3[0:0]  T24[11:11] ))+(V1100_T13_0_3[0:0]  p[11:11] ))+(V0010_T13_0_3[0:0]  p[11:11] ))+(V1010_T13_0_3[0:0]  p[11:11] ))+(V0110_T13_0_3[0:0]  p[11:11] ))+(V1110_T13_0_3[0:0]  p[11:11] ))+(V0001_T13_0_3[0:0]  a[11:11] ))+(V1001_T13_0_3[0:0]  X241[0:0] ))+(V0101_T13_0_3[0:0]  p[11:11] ))+(V1101_T13_0_3[0:0]  p[11:11] ))+(V0011_T13_0_3[0:0]  a[11:11] ))+(V1011_T13_0_3[0:0]  b[11:11] ))+(V0111_T13_0_3[0:0]  p[11:11] ))+(V1111_T13_0_3[0:0]  p[11:11] ));
X                    X178[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[10:10] ))+(V0100_T13_0_3[0:0]  T24[10:10] ))+(V1100_T13_0_3[0:0]  p[10:10] ))+(V0010_T13_0_3[0:0]  p[10:10] ))+(V1010_T13_0_3[0:0]  p[10:10] ))+(V0110_T13_0_3[0:0]  p[10:10] ))+(V1110_T13_0_3[0:0]  p[10:10] ))+(V0001_T13_0_3[0:0]  a[10:10] ))+(V1001_T13_0_3[0:0]  X242[0:0] ))+(V0101_T13_0_3[0:0]  p[10:10] ))+(V1101_T13_0_3[0:0]  p[10:10] ))+(V0011_T13_0_3[0:0]  a[10:10] ))+(V1011_T13_0_3[0:0]  b[10:10] ))+(V0111_T13_0_3[0:0]  p[10:10] ))+(V1111_T13_0_3[0:0]  p[10:10] ));
X                    X179[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[9:9] ))+(V0100_T13_0_3[0:0]  T24[9:9] ))+(V1100_T13_0_3[0:0]  p[9:9] ))+(V0010_T13_0_3[0:0]  p[9:9] ))+(V1010_T13_0_3[0:0]  p[9:9] ))+(V0110_T13_0_3[0:0]  p[9:9] ))+(V1110_T13_0_3[0:0]  p[9:9] ))+(V0001_T13_0_3[0:0]  a[9:9] ))+(V1001_T13_0_3[0:0]  X243[0:0] ))+(V0101_T13_0_3[0:0]  p[9:9] ))+(V1101_T13_0_3[0:0]  p[9:9] ))+(V0011_T13_0_3[0:0]  a[9:9] ))+(V1011_T13_0_3[0:0]  b[9:9] ))+(V0111_T13_0_3[0:0]  p[9:9] ))+(V1111_T13_0_3[0:0]  p[9:9] ));
X                    X180[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[8:8] ))+(V0100_T13_0_3[0:0]  T24[8:8] ))+(V1100_T13_0_3[0:0]  p[8:8] ))+(V0010_T13_0_3[0:0]  p[8:8] ))+(V1010_T13_0_3[0:0]  p[8:8] ))+(V0110_T13_0_3[0:0]  p[8:8] ))+(V1110_T13_0_3[0:0]  p[8:8] ))+(V0001_T13_0_3[0:0]  a[8:8] ))+(V1001_T13_0_3[0:0]  X244[0:0] ))+(V0101_T13_0_3[0:0]  p[8:8] ))+(V1101_T13_0_3[0:0]  p[8:8] ))+(V0011_T13_0_3[0:0]  a[8:8] ))+(V1011_T13_0_3[0:0]  b[8:8] ))+(V0111_T13_0_3[0:0]  p[8:8] ))+(V1111_T13_0_3[0:0]  p[8:8] ));
X                    X181[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[7:7] ))+(V0100_T13_0_3[0:0]  T24[7:7] ))+(V1100_T13_0_3[0:0]  p[7:7] ))+(V0010_T13_0_3[0:0]  p[7:7] ))+(V1010_T13_0_3[0:0]  p[7:7] ))+(V0110_T13_0_3[0:0]  p[7:7] ))+(V1110_T13_0_3[0:0]  p[7:7] ))+(V0001_T13_0_3[0:0]  a[7:7] ))+(V1001_T13_0_3[0:0]  X245[0:0] ))+(V0101_T13_0_3[0:0]  p[7:7] ))+(V1101_T13_0_3[0:0]  p[7:7] ))+(V0011_T13_0_3[0:0]  a[7:7] ))+(V1011_T13_0_3[0:0]  b[7:7] ))+(V0111_T13_0_3[0:0]  p[7:7] ))+(V1111_T13_0_3[0:0]  p[7:7] ));
X                    X182[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[6:6] ))+(V0100_T13_0_3[0:0]  T24[6:6] ))+(V1100_T13_0_3[0:0]  p[6:6] ))+(V0010_T13_0_3[0:0]  p[6:6] ))+(V1010_T13_0_3[0:0]  p[6:6] ))+(V0110_T13_0_3[0:0]  p[6:6] ))+(V1110_T13_0_3[0:0]  p[6:6] ))+(V0001_T13_0_3[0:0]  a[6:6] ))+(V1001_T13_0_3[0:0]  X246[0:0] ))+(V0101_T13_0_3[0:0]  p[6:6] ))+(V1101_T13_0_3[0:0]  p[6:6] ))+(V0011_T13_0_3[0:0]  a[6:6] ))+(V1011_T13_0_3[0:0]  b[6:6] ))+(V0111_T13_0_3[0:0]  p[6:6] ))+(V1111_T13_0_3[0:0]  p[6:6] ));
X                    X183[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[5:5] ))+(V0100_T13_0_3[0:0]  T24[5:5] ))+(V1100_T13_0_3[0:0]  p[5:5] ))+(V0010_T13_0_3[0:0]  p[5:5] ))+(V1010_T13_0_3[0:0]  p[5:5] ))+(V0110_T13_0_3[0:0]  p[5:5] ))+(V1110_T13_0_3[0:0]  p[5:5] ))+(V0001_T13_0_3[0:0]  a[5:5] ))+(V1001_T13_0_3[0:0]  X247[0:0] ))+(V0101_T13_0_3[0:0]  p[5:5] ))+(V1101_T13_0_3[0:0]  p[5:5] ))+(V0011_T13_0_3[0:0]  a[5:5] ))+(V1011_T13_0_3[0:0]  b[5:5] ))+(V0111_T13_0_3[0:0]  p[5:5] ))+(V1111_T13_0_3[0:0]  p[5:5] ));
X                    X184[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[4:4] ))+(V0100_T13_0_3[0:0]  T24[4:4] ))+(V1100_T13_0_3[0:0]  p[4:4] ))+(V0010_T13_0_3[0:0]  p[4:4] ))+(V1010_T13_0_3[0:0]  p[4:4] ))+(V0110_T13_0_3[0:0]  p[4:4] ))+(V1110_T13_0_3[0:0]  p[4:4] ))+(V0001_T13_0_3[0:0]  a[4:4] ))+(V1001_T13_0_3[0:0]  X248[0:0] ))+(V0101_T13_0_3[0:0]  p[4:4] ))+(V1101_T13_0_3[0:0]  p[4:4] ))+(V0011_T13_0_3[0:0]  a[4:4] ))+(V1011_T13_0_3[0:0]  b[4:4] ))+(V0111_T13_0_3[0:0]  p[4:4] ))+(V1111_T13_0_3[0:0]  p[4:4] ));
X                    X185[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[3:3] ))+(V0100_T13_0_3[0:0]  T24[3:3] ))+(V1100_T13_0_3[0:0]  p[3:3] ))+(V0010_T13_0_3[0:0]  p[3:3] ))+(V1010_T13_0_3[0:0]  p[3:3] ))+(V0110_T13_0_3[0:0]  p[3:3] ))+(V1110_T13_0_3[0:0]  p[3:3] ))+(V0001_T13_0_3[0:0]  a[3:3] ))+(V1001_T13_0_3[0:0]  X249[0:0] ))+(V0101_T13_0_3[0:0]  p[3:3] ))+(V1101_T13_0_3[0:0]  p[3:3] ))+(V0011_T13_0_3[0:0]  a[3:3] ))+(V1011_T13_0_3[0:0]  b[3:3] ))+(V0111_T13_0_3[0:0]  p[3:3] ))+(V1111_T13_0_3[0:0]  p[3:3] ));
X                    X186[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[2:2] ))+(V0100_T13_0_3[0:0]  T24[2:2] ))+(V1100_T13_0_3[0:0]  p[2:2] ))+(V0010_T13_0_3[0:0]  p[2:2] ))+(V1010_T13_0_3[0:0]  p[2:2] ))+(V0110_T13_0_3[0:0]  p[2:2] ))+(V1110_T13_0_3[0:0]  p[2:2] ))+(V0001_T13_0_3[0:0]  a[2:2] ))+(V1001_T13_0_3[0:0]  X250[0:0] ))+(V0101_T13_0_3[0:0]  p[2:2] ))+(V1101_T13_0_3[0:0]  p[2:2] ))+(V0011_T13_0_3[0:0]  a[2:2] ))+(V1011_T13_0_3[0:0]  b[2:2] ))+(V0111_T13_0_3[0:0]  p[2:2] ))+(V1111_T13_0_3[0:0]  p[2:2] ));
X                    X187[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[1:1] ))+(V0100_T13_0_3[0:0]  T24[1:1] ))+(V1100_T13_0_3[0:0]  p[1:1] ))+(V0010_T13_0_3[0:0]  p[1:1] ))+(V1010_T13_0_3[0:0]  p[1:1] ))+(V0110_T13_0_3[0:0]  p[1:1] ))+(V1110_T13_0_3[0:0]  p[1:1] ))+(V0001_T13_0_3[0:0]  a[1:1] ))+(V1001_T13_0_3[0:0]  X251[0:0] ))+(V0101_T13_0_3[0:0]  p[1:1] ))+(V1101_T13_0_3[0:0]  p[1:1] ))+(V0011_T13_0_3[0:0]  a[1:1] ))+(V1011_T13_0_3[0:0]  b[1:1] ))+(V0111_T13_0_3[0:0]  p[1:1] ))+(V1111_T13_0_3[0:0]  p[1:1] ));
X                    X188[0:0] = ((((((((((((((( 0 +(V1000_T13_0_3[0:0]  p[0:0] ))+(V0100_T13_0_3[0:0]  T24[0:0] ))+(V1100_T13_0_3[0:0]  p[0:0] ))+(V0010_T13_0_3[0:0]  p[0:0] ))+(V1010_T13_0_3[0:0]  p[0:0] ))+(V0110_T13_0_3[0:0]  p[0:0] ))+(V1110_T13_0_3[0:0]  p[0:0] ))+(V0001_T13_0_3[0:0]  a[0:0] ))+(V1001_T13_0_3[0:0]  X252[0:0] ))+(V0101_T13_0_3[0:0]  p[0:0] ))+(V1101_T13_0_3[0:0]  p[0:0] ))+(V0011_T13_0_3[0:0]  a[0:0] ))+(V1011_T13_0_3[0:0]  b[0:0] ))+(V0111_T13_0_3[0:0]  p[0:0] ))+(V1111_T13_0_3[0:0]  p[0:0] ));
X                    X189[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[15:15] ))+(V1000_T14_0_3[0:0]  T20[15:15] ))+(V0100_T14_0_3[0:0]  b[15:15] ));
X                    X190[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[14:14] ))+(V1000_T14_0_3[0:0]  T20[14:14] ))+(V0100_T14_0_3[0:0]  b[14:14] ));
X                    X191[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[13:13] ))+(V1000_T14_0_3[0:0]  T20[13:13] ))+(V0100_T14_0_3[0:0]  b[13:13] ));
X                    X192[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[12:12] ))+(V1000_T14_0_3[0:0]  T20[12:12] ))+(V0100_T14_0_3[0:0]  b[12:12] ));
X                    X193[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[11:11] ))+(V1000_T14_0_3[0:0]  T20[11:11] ))+(V0100_T14_0_3[0:0]  b[11:11] ));
X                    X194[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[10:10] ))+(V1000_T14_0_3[0:0]  T20[10:10] ))+(V0100_T14_0_3[0:0]  b[10:10] ));
X                    X195[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[9:9] ))+(V1000_T14_0_3[0:0]  T20[9:9] ))+(V0100_T14_0_3[0:0]  b[9:9] ));
X                    X196[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[8:8] ))+(V1000_T14_0_3[0:0]  T20[8:8] ))+(V0100_T14_0_3[0:0]  b[8:8] ));
X                    X197[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[7:7] ))+(V1000_T14_0_3[0:0]  T20[7:7] ))+(V0100_T14_0_3[0:0]  b[7:7] ));
X                    X198[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[6:6] ))+(V1000_T14_0_3[0:0]  T20[6:6] ))+(V0100_T14_0_3[0:0]  b[6:6] ));
X                    X199[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[5:5] ))+(V1000_T14_0_3[0:0]  T20[5:5] ))+(V0100_T14_0_3[0:0]  b[5:5] ));
X                    X200[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[4:4] ))+(V1000_T14_0_3[0:0]  T20[4:4] ))+(V0100_T14_0_3[0:0]  b[4:4] ));
X                    X201[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[3:3] ))+(V1000_T14_0_3[0:0]  T20[3:3] ))+(V0100_T14_0_3[0:0]  b[3:3] ));
X                    X202[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[2:2] ))+(V1000_T14_0_3[0:0]  T20[2:2] ))+(V0100_T14_0_3[0:0]  b[2:2] ));
X                    X203[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[1:1] ))+(V1000_T14_0_3[0:0]  T20[1:1] ))+(V0100_T14_0_3[0:0]  b[1:1] ));
X                    X204[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T17[0:0] ))+(V1000_T14_0_3[0:0]  T20[0:0] ))+(V0100_T14_0_3[0:0]  b[0:0] ));
X                    X205[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[15:15] ))+(V1000_T14_0_3[0:0]  T19[15:15] ))+(V0100_T14_0_3[0:0]  M5[15:15] ));
X                    X206[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[14:14] ))+(V1000_T14_0_3[0:0]  T19[14:14] ))+(V0100_T14_0_3[0:0]  M5[14:14] ));
X                    X207[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[13:13] ))+(V1000_T14_0_3[0:0]  T19[13:13] ))+(V0100_T14_0_3[0:0]  M5[13:13] ));
X                    X208[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[12:12] ))+(V1000_T14_0_3[0:0]  T19[12:12] ))+(V0100_T14_0_3[0:0]  M5[12:12] ));
X                    X209[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[11:11] ))+(V1000_T14_0_3[0:0]  T19[11:11] ))+(V0100_T14_0_3[0:0]  M5[11:11] ));
X                    X210[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[10:10] ))+(V1000_T14_0_3[0:0]  T19[10:10] ))+(V0100_T14_0_3[0:0]  M5[10:10] ));
X                    X211[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[9:9] ))+(V1000_T14_0_3[0:0]  T19[9:9] ))+(V0100_T14_0_3[0:0]  M5[9:9] ));
X                    X212[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[8:8] ))+(V1000_T14_0_3[0:0]  T19[8:8] ))+(V0100_T14_0_3[0:0]  M5[8:8] ));
X                    X213[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[7:7] ))+(V1000_T14_0_3[0:0]  T19[7:7] ))+(V0100_T14_0_3[0:0]  M5[7:7] ));
X                    X214[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[6:6] ))+(V1000_T14_0_3[0:0]  T19[6:6] ))+(V0100_T14_0_3[0:0]  M5[6:6] ));
X                    X215[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[5:5] ))+(V1000_T14_0_3[0:0]  T19[5:5] ))+(V0100_T14_0_3[0:0]  M5[5:5] ));
X                    X216[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[4:4] ))+(V1000_T14_0_3[0:0]  T19[4:4] ))+(V0100_T14_0_3[0:0]  M5[4:4] ));
X                    X217[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[3:3] ))+(V1000_T14_0_3[0:0]  T19[3:3] ))+(V0100_T14_0_3[0:0]  M5[3:3] ));
X                    X218[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[2:2] ))+(V1000_T14_0_3[0:0]  T19[2:2] ))+(V0100_T14_0_3[0:0]  M5[2:2] ));
X                    X219[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[1:1] ))+(V1000_T14_0_3[0:0]  T19[1:1] ))+(V0100_T14_0_3[0:0]  M5[1:1] ));
X                    X220[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T16[0:0] ))+(V1000_T14_0_3[0:0]  T19[0:0] ))+(V0100_T14_0_3[0:0]  M5[0:0] ));
X                    X221[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[15:15] ))+(V1000_T14_0_3[0:0]  T21[15:15] ))+(V0100_T14_0_3[0:0]  s[15:15] ));
X                    X222[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[14:14] ))+(V1000_T14_0_3[0:0]  T21[14:14] ))+(V0100_T14_0_3[0:0]  s[14:14] ));
X                    X223[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[13:13] ))+(V1000_T14_0_3[0:0]  T21[13:13] ))+(V0100_T14_0_3[0:0]  s[13:13] ));
X                    X224[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[12:12] ))+(V1000_T14_0_3[0:0]  T21[12:12] ))+(V0100_T14_0_3[0:0]  s[12:12] ));
X                    X225[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[11:11] ))+(V1000_T14_0_3[0:0]  T21[11:11] ))+(V0100_T14_0_3[0:0]  s[11:11] ));
X                    X226[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[10:10] ))+(V1000_T14_0_3[0:0]  T21[10:10] ))+(V0100_T14_0_3[0:0]  s[10:10] ));
X                    X227[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[9:9] ))+(V1000_T14_0_3[0:0]  T21[9:9] ))+(V0100_T14_0_3[0:0]  s[9:9] ));
X                    X228[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[8:8] ))+(V1000_T14_0_3[0:0]  T21[8:8] ))+(V0100_T14_0_3[0:0]  s[8:8] ));
X                    X229[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[7:7] ))+(V1000_T14_0_3[0:0]  T21[7:7] ))+(V0100_T14_0_3[0:0]  s[7:7] ));
X                    X230[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[6:6] ))+(V1000_T14_0_3[0:0]  T21[6:6] ))+(V0100_T14_0_3[0:0]  s[6:6] ));
X                    X231[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[5:5] ))+(V1000_T14_0_3[0:0]  T21[5:5] ))+(V0100_T14_0_3[0:0]  s[5:5] ));
X                    X232[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[4:4] ))+(V1000_T14_0_3[0:0]  T21[4:4] ))+(V0100_T14_0_3[0:0]  s[4:4] ));
X                    X233[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[3:3] ))+(V1000_T14_0_3[0:0]  T21[3:3] ))+(V0100_T14_0_3[0:0]  s[3:3] ));
X                    X234[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[2:2] ))+(V1000_T14_0_3[0:0]  T21[2:2] ))+(V0100_T14_0_3[0:0]  s[2:2] ));
X                    X235[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[1:1] ))+(V1000_T14_0_3[0:0]  T21[1:1] ))+(V0100_T14_0_3[0:0]  s[1:1] ));
X                    X236[0:0] = ((((((((((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+ 0 )+(V0000_T14_0_3[0:0]  T18[0:0] ))+(V1000_T14_0_3[0:0]  T21[0:0] ))+(V0100_T14_0_3[0:0]  s[0:0] ));
X                    X237[0:0] = ((V1_T36_0_0[0:0]  a[15:15] )+(V0_T36_0_0[0:0]  p[15:15] ));
X                    X238[0:0] = ((V1_T36_0_0[0:0]  a[14:14] )+(V0_T36_0_0[0:0]  p[14:14] ));
X                    X239[0:0] = ((V1_T36_0_0[0:0]  a[13:13] )+(V0_T36_0_0[0:0]  p[13:13] ));
X                    X240[0:0] = ((V1_T36_0_0[0:0]  a[12:12] )+(V0_T36_0_0[0:0]  p[12:12] ));
X                    X241[0:0] = ((V1_T36_0_0[0:0]  a[11:11] )+(V0_T36_0_0[0:0]  p[11:11] ));
X                    X242[0:0] = ((V1_T36_0_0[0:0]  a[10:10] )+(V0_T36_0_0[0:0]  p[10:10] ));
X                    X243[0:0] = ((V1_T36_0_0[0:0]  a[9:9] )+(V0_T36_0_0[0:0]  p[9:9] ));
X                    X244[0:0] = ((V1_T36_0_0[0:0]  a[8:8] )+(V0_T36_0_0[0:0]  p[8:8] ));
X                    X245[0:0] = ((V1_T36_0_0[0:0]  a[7:7] )+(V0_T36_0_0[0:0]  p[7:7] ));
X                    X246[0:0] = ((V1_T36_0_0[0:0]  a[6:6] )+(V0_T36_0_0[0:0]  p[6:6] ));
X                    X247[0:0] = ((V1_T36_0_0[0:0]  a[5:5] )+(V0_T36_0_0[0:0]  p[5:5] ));
X                    X248[0:0] = ((V1_T36_0_0[0:0]  a[4:4] )+(V0_T36_0_0[0:0]  p[4:4] ));
X                    X249[0:0] = ((V1_T36_0_0[0:0]  a[3:3] )+(V0_T36_0_0[0:0]  p[3:3] ));
X                    X250[0:0] = ((V1_T36_0_0[0:0]  a[2:2] )+(V0_T36_0_0[0:0]  p[2:2] ));
X                    X251[0:0] = ((V1_T36_0_0[0:0]  a[1:1] )+(V0_T36_0_0[0:0]  p[1:1] ));
X                    X252[0:0] = ((V1_T36_0_0[0:0]  a[0:0] )+(V0_T36_0_0[0:0]  p[0:0] ));
X                    T53[0:0] = T52[0:0]' ;
X                    V0_T36_0_0[0:0] = T36[0:0]' ;
X                    V1_T36_0_0[0:0] = T36[0:0] ;
X                    V0100_T14_0_3[0:0] = (((T14[0:0]'  T14[1:1] ) T14[2:2]' ) T14[3:3]' );
X                    V1000_T14_0_3[0:0] = (((T14[0:0]  T14[1:1]' ) T14[2:2]' ) T14[3:3]' );
X                    V0000_T14_0_3[0:0] = (((T14[0:0]'  T14[1:1]' ) T14[2:2]' ) T14[3:3]' );
X                    V0000000000000000_M3_0_15[0:0] = (((((((((((((((M3[0:0]'  M3[1:1]' ) M3[2:2]' ) M3[3:3]' ) M3[4:4]' ) M3[5:5]' ) M3[6:6]' ) M3[7:7]' ) M3[8:8]' ) M3[9:9]' ) M3[10:10]' ) M3[11:11]' ) M3[12:12]' ) M3[13:13]' ) M3[14:14]' ) M3[15:15]' );
X                    V1111_T13_0_3[0:0] = (((T13[0:0]  T13[1:1] ) T13[2:2] ) T13[3:3] );
X                    V0111_T13_0_3[0:0] = (((T13[0:0]'  T13[1:1] ) T13[2:2] ) T13[3:3] );
X                    V1011_T13_0_3[0:0] = (((T13[0:0]  T13[1:1]' ) T13[2:2] ) T13[3:3] );
X                    V0011_T13_0_3[0:0] = (((T13[0:0]'  T13[1:1]' ) T13[2:2] ) T13[3:3] );
X                    V1101_T13_0_3[0:0] = (((T13[0:0]  T13[1:1] ) T13[2:2]' ) T13[3:3] );
X                    V0101_T13_0_3[0:0] = (((T13[0:0]'  T13[1:1] ) T13[2:2]' ) T13[3:3] );
X                    V1001_T13_0_3[0:0] = (((T13[0:0]  T13[1:1]' ) T13[2:2]' ) T13[3:3] );
X                    V0001_T13_0_3[0:0] = (((T13[0:0]'  T13[1:1]' ) T13[2:2]' ) T13[3:3] );
X                    V1110_T13_0_3[0:0] = (((T13[0:0]  T13[1:1] ) T13[2:2] ) T13[3:3]' );
X                    V0110_T13_0_3[0:0] = (((T13[0:0]'  T13[1:1] ) T13[2:2] ) T13[3:3]' );
X                    V1010_T13_0_3[0:0] = (((T13[0:0]  T13[1:1]' ) T13[2:2] ) T13[3:3]' );
X                    V0010_T13_0_3[0:0] = (((T13[0:0]'  T13[1:1]' ) T13[2:2] ) T13[3:3]' );
X                    V1100_T13_0_3[0:0] = (((T13[0:0]  T13[1:1] ) T13[2:2]' ) T13[3:3]' );
X                    V0100_T13_0_3[0:0] = (((T13[0:0]'  T13[1:1] ) T13[2:2]' ) T13[3:3]' );
X                    V1000_T13_0_3[0:0] = (((T13[0:0]  T13[1:1]' ) T13[2:2]' ) T13[3:3]' );
X                    .attribute delay 35 level;
X                    .attribute area 8686 literal;
X                  .endoperation;
X                .endnode;
X
X                .node 4 nop;	#	sink node
X                  .successors ;	#  predecessors 3 
X                .endnode;
X
X                .endpolargraph;
X              .attribute hercules loop_load t[15:15] X93[0:0] ;
X              .attribute hercules loop_load t[14:14] X94[0:0] ;
X              .attribute hercules loop_load t[13:13] X95[0:0] ;
X              .attribute hercules loop_load t[12:12] X96[0:0] ;
X              .attribute hercules loop_load t[11:11] X97[0:0] ;
X              .attribute hercules loop_load t[10:10] X98[0:0] ;
X              .attribute hercules loop_load t[9:9] X99[0:0] ;
X              .attribute hercules loop_load t[8:8] X100[0:0] ;
X              .attribute hercules loop_load t[7:7] X101[0:0] ;
X              .attribute hercules loop_load t[6:6] X102[0:0] ;
X              .attribute hercules loop_load t[5:5] X103[0:0] ;
X              .attribute hercules loop_load t[4:4] X104[0:0] ;
X              .attribute hercules loop_load t[3:3] X105[0:0] ;
X              .attribute hercules loop_load t[2:2] X106[0:0] ;
X              .attribute hercules loop_load t[1:1] X107[0:0] ;
X              .attribute hercules loop_load t[0:0] X108[0:0] ;
X              .attribute hercules loop_load i[15:15] M3[15:15] ;
X              .attribute hercules loop_load i[14:14] M3[14:14] ;
X              .attribute hercules loop_load i[13:13] M3[13:13] ;
X              .attribute hercules loop_load i[12:12] M3[12:12] ;
X              .attribute hercules loop_load i[11:11] M3[11:11] ;
X              .attribute hercules loop_load i[10:10] M3[10:10] ;
X              .attribute hercules loop_load i[9:9] M3[9:9] ;
X              .attribute hercules loop_load i[8:8] M3[8:8] ;
X              .attribute hercules loop_load i[7:7] M3[7:7] ;
X              .attribute hercules loop_load i[6:6] M3[6:6] ;
X              .attribute hercules loop_load i[5:5] M3[5:5] ;
X              .attribute hercules loop_load i[4:4] M3[4:4] ;
X              .attribute hercules loop_load i[3:3] M3[3:3] ;
X              .attribute hercules loop_load i[2:2] M3[2:2] ;
X              .attribute hercules loop_load i[1:1] M3[1:1] ;
X              .attribute hercules loop_load i[0:0] M3[0:0] ;
X              .attribute hercules loop_load b[15:15] X109[0:0] ;
X              .attribute hercules loop_load b[14:14] X110[0:0] ;
X              .attribute hercules loop_load b[13:13] X111[0:0] ;
X              .attribute hercules loop_load b[12:12] X112[0:0] ;
X              .attribute hercules loop_load b[11:11] X113[0:0] ;
X              .attribute hercules loop_load b[10:10] X114[0:0] ;
X              .attribute hercules loop_load b[9:9] X115[0:0] ;
X              .attribute hercules loop_load b[8:8] X116[0:0] ;
X              .attribute hercules loop_load b[7:7] X117[0:0] ;
X              .attribute hercules loop_load b[6:6] X118[0:0] ;
X              .attribute hercules loop_load b[5:5] X119[0:0] ;
X              .attribute hercules loop_load b[4:4] X120[0:0] ;
X              .attribute hercules loop_load b[3:3] X121[0:0] ;
X              .attribute hercules loop_load b[2:2] X122[0:0] ;
X              .attribute hercules loop_load b[1:1] X123[0:0] ;
X              .attribute hercules loop_load b[0:0] X124[0:0] ;
X              .attribute hercules loop_load a[15:15] X125[0:0] ;
X              .attribute hercules loop_load a[14:14] X126[0:0] ;
X              .attribute hercules loop_load a[13:13] X127[0:0] ;
X              .attribute hercules loop_load a[12:12] X128[0:0] ;
X              .attribute hercules loop_load a[11:11] X129[0:0] ;
X              .attribute hercules loop_load a[10:10] X130[0:0] ;
X              .attribute hercules loop_load a[9:9] X131[0:0] ;
X              .attribute hercules loop_load a[8:8] X132[0:0] ;
X              .attribute hercules loop_load a[7:7] X133[0:0] ;
X              .attribute hercules loop_load a[6:6] X134[0:0] ;
X              .attribute hercules loop_load a[5:5] X135[0:0] ;
X              .attribute hercules loop_load a[4:4] X136[0:0] ;
X              .attribute hercules loop_load a[3:3] X137[0:0] ;
X              .attribute hercules loop_load a[2:2] X138[0:0] ;
X              .attribute hercules loop_load a[1:1] X139[0:0] ;
X              .attribute hercules loop_load a[0:0] X140[0:0] ;
X              .attribute hercules loop_load m[15:15] X141[0:0] ;
X              .attribute hercules loop_load m[14:14] X142[0:0] ;
X              .attribute hercules loop_load m[13:13] X143[0:0] ;
X              .attribute hercules loop_load m[12:12] X144[0:0] ;
X              .attribute hercules loop_load m[11:11] X145[0:0] ;
X              .attribute hercules loop_load m[10:10] X146[0:0] ;
X              .attribute hercules loop_load m[9:9] X147[0:0] ;
X              .attribute hercules loop_load m[8:8] X148[0:0] ;
X              .attribute hercules loop_load m[7:7] X149[0:0] ;
X              .attribute hercules loop_load m[6:6] X150[0:0] ;
X              .attribute hercules loop_load m[5:5] X151[0:0] ;
X              .attribute hercules loop_load m[4:4] X152[0:0] ;
X              .attribute hercules loop_load m[3:3] X153[0:0] ;
X              .attribute hercules loop_load m[2:2] X154[0:0] ;
X              .attribute hercules loop_load m[1:1] X155[0:0] ;
X              .attribute hercules loop_load m[0:0] X156[0:0] ;
X              .attribute hercules loop_load s[15:15] X157[0:0] ;
X              .attribute hercules loop_load s[14:14] X158[0:0] ;
X              .attribute hercules loop_load s[13:13] X159[0:0] ;
X              .attribute hercules loop_load s[12:12] X160[0:0] ;
X              .attribute hercules loop_load s[11:11] X161[0:0] ;
X              .attribute hercules loop_load s[10:10] X162[0:0] ;
X              .attribute hercules loop_load s[9:9] X163[0:0] ;
X              .attribute hercules loop_load s[8:8] X164[0:0] ;
X              .attribute hercules loop_load s[7:7] X165[0:0] ;
X              .attribute hercules loop_load s[6:6] X166[0:0] ;
X              .attribute hercules loop_load s[5:5] X167[0:0] ;
X              .attribute hercules loop_load s[4:4] X168[0:0] ;
X              .attribute hercules loop_load s[3:3] X169[0:0] ;
X              .attribute hercules loop_load s[2:2] X170[0:0] ;
X              .attribute hercules loop_load s[1:1] X171[0:0] ;
X              .attribute hercules loop_load s[0:0] X172[0:0] ;
X              .attribute hercules loop_load p[15:15] X173[0:0] ;
X              .attribute hercules loop_load p[14:14] X174[0:0] ;
X              .attribute hercules loop_load p[13:13] X175[0:0] ;
X              .attribute hercules loop_load p[12:12] X176[0:0] ;
X              .attribute hercules loop_load p[11:11] X177[0:0] ;
X              .attribute hercules loop_load p[10:10] X178[0:0] ;
X              .attribute hercules loop_load p[9:9] X179[0:0] ;
X              .attribute hercules loop_load p[8:8] X180[0:0] ;
X              .attribute hercules loop_load p[7:7] X181[0:0] ;
X              .attribute hercules loop_load p[6:6] X182[0:0] ;
X              .attribute hercules loop_load p[5:5] X183[0:0] ;
X              .attribute hercules loop_load p[4:4] X184[0:0] ;
X              .attribute hercules loop_load p[3:3] X185[0:0] ;
X              .attribute hercules loop_load p[2:2] X186[0:0] ;
X              .attribute hercules loop_load p[1:1] X187[0:0] ;
X              .attribute hercules loop_load p[0:0] X188[0:0] ;
X              .endloop;
X            .endnode;
X
X            .node 5 nop;	#	sink node
X              .successors ;	#  predecessors 4 
X            .endnode;
X
X            .attribute constraint delay 3 1 cycles;
X            .endpolargraph;
X          .endcase;
X          .case 0 ;
X            #	Index 26
X            .polargraph 1 2;
X            #	2 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 nop;	#	sink node
X              .successors ;	#  predecessors 1 
X            .endnode;
X
X            .endpolargraph;
X          .endcase;
X          .endcond;
X        .endnode;
X
X        .node 11 nop;	#	sink node
X          .successors ;	#  predecessors 10 
X        .endnode;
X
X        .attribute constraint delay 3 1 cycles;
X        .attribute constraint delay 5 1 cycles;
X        .attribute constraint delay 6 1 cycles;
X        .attribute constraint delay 7 1 cycles;
X        .endpolargraph;
X      .endcase;
X      .endcond;
X    .endnode;
X
X    .node 3 operation;
X      .inputs T1[0:0] i[15:15] i[14:14] i[13:13] 
X	i[12:12] i[11:11] i[10:10] i[9:9] 
X	i[8:8] i[7:7] i[6:6] i[5:5] 
X	i[4:4] i[3:3] i[2:2] i[1:1] 
X	i[0:0] b[15:15] b[14:14] b[13:13] 
X	b[12:12] b[11:11] b[10:10] b[9:9] 
X	b[8:8] b[7:7] b[6:6] b[5:5] 
X	b[4:4] b[3:3] b[2:2] b[1:1] 
X	b[0:0] a[15:15] a[14:14] a[13:13] 
X	a[12:12] a[11:11] a[10:10] a[9:9] 
X	a[8:8] a[7:7] a[6:6] a[5:5] 
X	a[4:4] a[3:3] a[2:2] a[1:1] 
X	a[0:0] m[15:15] m[14:14] m[13:13] 
X	m[12:12] m[11:11] m[10:10] m[9:9] 
X	m[8:8] m[7:7] m[6:6] m[5:5] 
X	m[4:4] m[3:3] m[2:2] m[1:1] 
X	m[0:0] T3[15:15] T3[14:14] T3[13:13] 
X	T3[12:12] T3[11:11] T3[10:10] T3[9:9] 
X	T3[8:8] T3[7:7] T3[6:6] T3[5:5] 
X	T3[4:4] T3[3:3] T3[2:2] T3[1:1] 
X	T3[0:0] T2[15:15] T2[14:14] T2[13:13] 
X	T2[12:12] T2[11:11] T2[10:10] T2[9:9] 
X	T2[8:8] T2[7:7] T2[6:6] T2[5:5] 
X	T2[4:4] T2[3:3] T2[2:2] T2[1:1] 
X	T2[0:0] T12[0:0] T9[15:15] T9[14:14] 
X	T9[13:13] T9[12:12] T9[11:11] T9[10:10] 
X	T9[9:9] T9[8:8] T9[7:7] T9[6:6] 
X	T9[5:5] T9[4:4] T9[3:3] T9[2:2] 
X	T9[1:1] T9[0:0] X17[0:0] X18[0:0] 
X	X19[0:0] X20[0:0] X21[0:0] X22[0:0] 
X	X23[0:0] X24[0:0] X25[0:0] X26[0:0] 
X	X27[0:0] X28[0:0] X29[0:0] X30[0:0] 
X	X31[0:0] X32[0:0] X33[0:0] X34[0:0] 
X	X35[0:0] X36[0:0] X37[0:0] X38[0:0] 
X	X39[0:0] X40[0:0] X41[0:0] X42[0:0] 
X	X43[0:0] X44[0:0] X45[0:0] X46[0:0] 
X	X47[0:0] X48[0:0] X49[0:0] X50[0:0] 
X	X51[0:0] X52[0:0] X53[0:0] X54[0:0] 
X	X55[0:0] X56[0:0] X57[0:0] X58[0:0] 
X	X59[0:0] X60[0:0] X61[0:0] X62[0:0] 
X	X63[0:0] X64[0:0] s[15:15] X65[0:0] 
X	s[14:14] X66[0:0] s[13:13] X67[0:0] 
X	s[12:12] X68[0:0] s[11:11] X69[0:0] 
X	s[10:10] X70[0:0] s[9:9] X71[0:0] 
X	s[8:8] X72[0:0] s[7:7] X73[0:0] 
X	s[6:6] X74[0:0] s[5:5] X75[0:0] 
X	s[4:4] X76[0:0] s[3:3] X77[0:0] 
X	s[2:2] X78[0:0] s[1:1] X79[0:0] 
X	s[0:0] X80[0:0] p[15:15] T11[15:15] 
X	p[14:14] T11[14:14] p[13:13] T11[13:13] 
X	p[12:12] T11[12:12] p[11:11] T11[11:11] 
X	p[10:10] T11[10:10] p[9:9] T11[9:9] 
X	p[8:8] T11[8:8] p[7:7] T11[7:7] 
X	p[6:6] T11[6:6] p[5:5] T11[5:5] 
X	p[4:4] T11[4:4] p[3:3] T11[3:3] 
X	p[2:2] T11[2:2] p[1:1] T11[1:1] 
X	p[0:0] T11[0:0] ;
X      .outputs M6[0:0] M6[1:1] M6[2:2] M6[3:3] 
X	M6[4:4] M6[5:5] M6[6:6] M6[7:7] 
X	M6[8:8] M6[9:9] M6[10:10] M6[11:11] 
X	M6[12:12] M6[13:13] M6[14:14] M6[15:15] 
X	M7[0:0] M7[1:1] M7[2:2] M7[3:3] 
X	M7[4:4] M7[5:5] M7[6:6] M7[7:7] 
X	M7[8:8] M7[9:9] M7[10:10] M7[11:11] 
X	M7[12:12] M7[13:13] M7[14:14] M7[15:15] 
X	M8[0:0] M8[1:1] M8[2:2] M8[3:3] 
X	M8[4:4] M8[5:5] M8[6:6] M8[7:7] 
X	M8[8:8] M8[9:9] M8[10:10] M8[11:11] 
X	M8[12:12] M8[13:13] M8[14:14] M8[15:15] 
X	M9[0:0] M9[1:1] M9[2:2] M9[3:3] 
X	M9[4:4] M9[5:5] M9[6:6] M9[7:7] 
X	M9[8:8] M9[9:9] M9[10:10] M9[11:11] 
X	M9[12:12] M9[13:13] M9[14:14] M9[15:15] 
X	M10[0:0] M10[1:1] M10[2:2] M10[3:3] 
X	M10[4:4] M10[5:5] M10[6:6] M10[7:7] 
X	M10[8:8] M10[9:9] M10[10:10] M10[11:11] 
X	M10[12:12] M10[13:13] M10[14:14] M10[15:15] 
X	M11[0:0] M11[1:1] M11[2:2] M11[3:3] 
X	M11[4:4] M11[5:5] M11[6:6] M11[7:7] 
X	M11[8:8] M11[9:9] M11[10:10] M11[11:11] 
X	M11[12:12] M11[13:13] M11[14:14] M11[15:15] 
X	;
X      .successors 4 ;	#  predecessors 2 
X      .operation logic 7 ;
X        #	Expression 0
X        M6[0:0] = X348[0:0] ;
X        M6[1:1] = X347[0:0] ;
X        M6[2:2] = X346[0:0] ;
X        M6[3:3] = X345[0:0] ;
X        M6[4:4] = X344[0:0] ;
X        M6[5:5] = X343[0:0] ;
X        M6[6:6] = X342[0:0] ;
X        M6[7:7] = X341[0:0] ;
X        M6[8:8] = X340[0:0] ;
X        M6[9:9] = X339[0:0] ;
X        M6[10:10] = X338[0:0] ;
X        M6[11:11] = X337[0:0] ;
X        M6[12:12] = X336[0:0] ;
X        M6[13:13] = X335[0:0] ;
X        M6[14:14] = X334[0:0] ;
X        M6[15:15] = X333[0:0] ;
X        M7[0:0] = X332[0:0] ;
X        M7[1:1] = X331[0:0] ;
X        M7[2:2] = X330[0:0] ;
X        M7[3:3] = X329[0:0] ;
X        M7[4:4] = X328[0:0] ;
X        M7[5:5] = X327[0:0] ;
X        M7[6:6] = X326[0:0] ;
X        M7[7:7] = X325[0:0] ;
X        M7[8:8] = X324[0:0] ;
X        M7[9:9] = X323[0:0] ;
X        M7[10:10] = X322[0:0] ;
X        M7[11:11] = X321[0:0] ;
X        M7[12:12] = X320[0:0] ;
X        M7[13:13] = X319[0:0] ;
X        M7[14:14] = X318[0:0] ;
X        M7[15:15] = X317[0:0] ;
X        M8[0:0] = X316[0:0] ;
X        M8[1:1] = X315[0:0] ;
X        M8[2:2] = X314[0:0] ;
X        M8[3:3] = X313[0:0] ;
X        M8[4:4] = X312[0:0] ;
X        M8[5:5] = X311[0:0] ;
X        M8[6:6] = X310[0:0] ;
X        M8[7:7] = X309[0:0] ;
X        M8[8:8] = X308[0:0] ;
X        M8[9:9] = X307[0:0] ;
X        M8[10:10] = X306[0:0] ;
X        M8[11:11] = X305[0:0] ;
X        M8[12:12] = X304[0:0] ;
X        M8[13:13] = X303[0:0] ;
X        M8[14:14] = X302[0:0] ;
X        M8[15:15] = X301[0:0] ;
X        M9[0:0] = X300[0:0] ;
X        M9[1:1] = X299[0:0] ;
X        M9[2:2] = X298[0:0] ;
X        M9[3:3] = X297[0:0] ;
X        M9[4:4] = X296[0:0] ;
X        M9[5:5] = X295[0:0] ;
X        M9[6:6] = X294[0:0] ;
X        M9[7:7] = X293[0:0] ;
X        M9[8:8] = X292[0:0] ;
X        M9[9:9] = X291[0:0] ;
X        M9[10:10] = X290[0:0] ;
X        M9[11:11] = X289[0:0] ;
X        M9[12:12] = X288[0:0] ;
X        M9[13:13] = X287[0:0] ;
X        M9[14:14] = X286[0:0] ;
X        M9[15:15] = X285[0:0] ;
X        M10[0:0] = X284[0:0] ;
X        M10[1:1] = X283[0:0] ;
X        M10[2:2] = X282[0:0] ;
X        M10[3:3] = X281[0:0] ;
X        M10[4:4] = X280[0:0] ;
X        M10[5:5] = X279[0:0] ;
X        M10[6:6] = X278[0:0] ;
X        M10[7:7] = X277[0:0] ;
X        M10[8:8] = X276[0:0] ;
X        M10[9:9] = X275[0:0] ;
X        M10[10:10] = X274[0:0] ;
X        M10[11:11] = X273[0:0] ;
X        M10[12:12] = X272[0:0] ;
X        M10[13:13] = X271[0:0] ;
X        M10[14:14] = X270[0:0] ;
X        M10[15:15] = X269[0:0] ;
X        M11[0:0] = X268[0:0] ;
X        M11[1:1] = X267[0:0] ;
X        M11[2:2] = X266[0:0] ;
X        M11[3:3] = X265[0:0] ;
X        M11[4:4] = X264[0:0] ;
X        M11[5:5] = X263[0:0] ;
X        M11[6:6] = X262[0:0] ;
X        M11[7:7] = X261[0:0] ;
X        M11[8:8] = X260[0:0] ;
X        M11[9:9] = X259[0:0] ;
X        M11[10:10] = X258[0:0] ;
X        M11[11:11] = X257[0:0] ;
X        M11[12:12] = X256[0:0] ;
X        M11[13:13] = X255[0:0] ;
X        M11[14:14] = X254[0:0] ;
X        M11[15:15] = X253[0:0] ;
X        X253[0:0] = ((V1_T1_0_0[0:0]  i[15:15] )+(V0_T1_0_0[0:0]  X349[0:0] ));
X        X254[0:0] = ((V1_T1_0_0[0:0]  i[14:14] )+(V0_T1_0_0[0:0]  X350[0:0] ));
X        X255[0:0] = ((V1_T1_0_0[0:0]  i[13:13] )+(V0_T1_0_0[0:0]  X351[0:0] ));
X        X256[0:0] = ((V1_T1_0_0[0:0]  i[12:12] )+(V0_T1_0_0[0:0]  X352[0:0] ));
X        X257[0:0] = ((V1_T1_0_0[0:0]  i[11:11] )+(V0_T1_0_0[0:0]  X353[0:0] ));
X        X258[0:0] = ((V1_T1_0_0[0:0]  i[10:10] )+(V0_T1_0_0[0:0]  X354[0:0] ));
X        X259[0:0] = ((V1_T1_0_0[0:0]  i[9:9] )+(V0_T1_0_0[0:0]  X355[0:0] ));
X        X260[0:0] = ((V1_T1_0_0[0:0]  i[8:8] )+(V0_T1_0_0[0:0]  X356[0:0] ));
X        X261[0:0] = ((V1_T1_0_0[0:0]  i[7:7] )+(V0_T1_0_0[0:0]  X357[0:0] ));
X        X262[0:0] = ((V1_T1_0_0[0:0]  i[6:6] )+(V0_T1_0_0[0:0]  X358[0:0] ));
X        X263[0:0] = ((V1_T1_0_0[0:0]  i[5:5] )+(V0_T1_0_0[0:0]  X359[0:0] ));
X        X264[0:0] = ((V1_T1_0_0[0:0]  i[4:4] )+(V0_T1_0_0[0:0]  X360[0:0] ));
X        X265[0:0] = ((V1_T1_0_0[0:0]  i[3:3] )+(V0_T1_0_0[0:0]  X361[0:0] ));
X        X266[0:0] = ((V1_T1_0_0[0:0]  i[2:2] )+(V0_T1_0_0[0:0]  X362[0:0] ));
X        X267[0:0] = ((V1_T1_0_0[0:0]  i[1:1] )+(V0_T1_0_0[0:0]  X363[0:0] ));
X        X268[0:0] = ((V1_T1_0_0[0:0]  i[0:0] )+(V0_T1_0_0[0:0]  X364[0:0] ));
X        X269[0:0] = ((V1_T1_0_0[0:0]  b[15:15] )+(V0_T1_0_0[0:0]  X365[0:0] ));
X        X270[0:0] = ((V1_T1_0_0[0:0]  b[14:14] )+(V0_T1_0_0[0:0]  X366[0:0] ));
X        X271[0:0] = ((V1_T1_0_0[0:0]  b[13:13] )+(V0_T1_0_0[0:0]  X367[0:0] ));
X        X272[0:0] = ((V1_T1_0_0[0:0]  b[12:12] )+(V0_T1_0_0[0:0]  X368[0:0] ));
X        X273[0:0] = ((V1_T1_0_0[0:0]  b[11:11] )+(V0_T1_0_0[0:0]  X369[0:0] ));
X        X274[0:0] = ((V1_T1_0_0[0:0]  b[10:10] )+(V0_T1_0_0[0:0]  X370[0:0] ));
X        X275[0:0] = ((V1_T1_0_0[0:0]  b[9:9] )+(V0_T1_0_0[0:0]  X371[0:0] ));
X        X276[0:0] = ((V1_T1_0_0[0:0]  b[8:8] )+(V0_T1_0_0[0:0]  X372[0:0] ));
X        X277[0:0] = ((V1_T1_0_0[0:0]  b[7:7] )+(V0_T1_0_0[0:0]  X373[0:0] ));
X        X278[0:0] = ((V1_T1_0_0[0:0]  b[6:6] )+(V0_T1_0_0[0:0]  X374[0:0] ));
X        X279[0:0] = ((V1_T1_0_0[0:0]  b[5:5] )+(V0_T1_0_0[0:0]  X375[0:0] ));
X        X280[0:0] = ((V1_T1_0_0[0:0]  b[4:4] )+(V0_T1_0_0[0:0]  X376[0:0] ));
X        X281[0:0] = ((V1_T1_0_0[0:0]  b[3:3] )+(V0_T1_0_0[0:0]  X377[0:0] ));
X        X282[0:0] = ((V1_T1_0_0[0:0]  b[2:2] )+(V0_T1_0_0[0:0]  X378[0:0] ));
X        X283[0:0] = ((V1_T1_0_0[0:0]  b[1:1] )+(V0_T1_0_0[0:0]  X379[0:0] ));
X        X284[0:0] = ((V1_T1_0_0[0:0]  b[0:0] )+(V0_T1_0_0[0:0]  X380[0:0] ));
X        X285[0:0] = ((V1_T1_0_0[0:0]  a[15:15] )+(V0_T1_0_0[0:0]  X381[0:0] ));
X        X286[0:0] = ((V1_T1_0_0[0:0]  a[14:14] )+(V0_T1_0_0[0:0]  X382[0:0] ));
X        X287[0:0] = ((V1_T1_0_0[0:0]  a[13:13] )+(V0_T1_0_0[0:0]  X383[0:0] ));
X        X288[0:0] = ((V1_T1_0_0[0:0]  a[12:12] )+(V0_T1_0_0[0:0]  X384[0:0] ));
X        X289[0:0] = ((V1_T1_0_0[0:0]  a[11:11] )+(V0_T1_0_0[0:0]  X385[0:0] ));
X        X290[0:0] = ((V1_T1_0_0[0:0]  a[10:10] )+(V0_T1_0_0[0:0]  X386[0:0] ));
X        X291[0:0] = ((V1_T1_0_0[0:0]  a[9:9] )+(V0_T1_0_0[0:0]  X387[0:0] ));
X        X292[0:0] = ((V1_T1_0_0[0:0]  a[8:8] )+(V0_T1_0_0[0:0]  X388[0:0] ));
X        X293[0:0] = ((V1_T1_0_0[0:0]  a[7:7] )+(V0_T1_0_0[0:0]  X389[0:0] ));
X        X294[0:0] = ((V1_T1_0_0[0:0]  a[6:6] )+(V0_T1_0_0[0:0]  X390[0:0] ));
X        X295[0:0] = ((V1_T1_0_0[0:0]  a[5:5] )+(V0_T1_0_0[0:0]  X391[0:0] ));
X        X296[0:0] = ((V1_T1_0_0[0:0]  a[4:4] )+(V0_T1_0_0[0:0]  X392[0:0] ));
X        X297[0:0] = ((V1_T1_0_0[0:0]  a[3:3] )+(V0_T1_0_0[0:0]  X393[0:0] ));
X        X298[0:0] = ((V1_T1_0_0[0:0]  a[2:2] )+(V0_T1_0_0[0:0]  X394[0:0] ));
X        X299[0:0] = ((V1_T1_0_0[0:0]  a[1:1] )+(V0_T1_0_0[0:0]  X395[0:0] ));
X        X300[0:0] = ((V1_T1_0_0[0:0]  a[0:0] )+(V0_T1_0_0[0:0]  X396[0:0] ));
X        X301[0:0] = ((V1_T1_0_0[0:0]  m[15:15] )+(V0_T1_0_0[0:0]  X397[0:0] ));
X        X302[0:0] = ((V1_T1_0_0[0:0]  m[14:14] )+(V0_T1_0_0[0:0]  X398[0:0] ));
X        X303[0:0] = ((V1_T1_0_0[0:0]  m[13:13] )+(V0_T1_0_0[0:0]  X399[0:0] ));
X        X304[0:0] = ((V1_T1_0_0[0:0]  m[12:12] )+(V0_T1_0_0[0:0]  X400[0:0] ));
X        X305[0:0] = ((V1_T1_0_0[0:0]  m[11:11] )+(V0_T1_0_0[0:0]  X401[0:0] ));
X        X306[0:0] = ((V1_T1_0_0[0:0]  m[10:10] )+(V0_T1_0_0[0:0]  X402[0:0] ));
X        X307[0:0] = ((V1_T1_0_0[0:0]  m[9:9] )+(V0_T1_0_0[0:0]  X403[0:0] ));
X        X308[0:0] = ((V1_T1_0_0[0:0]  m[8:8] )+(V0_T1_0_0[0:0]  X404[0:0] ));
X        X309[0:0] = ((V1_T1_0_0[0:0]  m[7:7] )+(V0_T1_0_0[0:0]  X405[0:0] ));
X        X310[0:0] = ((V1_T1_0_0[0:0]  m[6:6] )+(V0_T1_0_0[0:0]  X406[0:0] ));
X        X311[0:0] = ((V1_T1_0_0[0:0]  m[5:5] )+(V0_T1_0_0[0:0]  X407[0:0] ));
X        X312[0:0] = ((V1_T1_0_0[0:0]  m[4:4] )+(V0_T1_0_0[0:0]  X408[0:0] ));
X        X313[0:0] = ((V1_T1_0_0[0:0]  m[3:3] )+(V0_T1_0_0[0:0]  X409[0:0] ));
X        X314[0:0] = ((V1_T1_0_0[0:0]  m[2:2] )+(V0_T1_0_0[0:0]  X410[0:0] ));
X        X315[0:0] = ((V1_T1_0_0[0:0]  m[1:1] )+(V0_T1_0_0[0:0]  X411[0:0] ));
X        X316[0:0] = ((V1_T1_0_0[0:0]  m[0:0] )+(V0_T1_0_0[0:0]  X412[0:0] ));
X        X317[0:0] = ((V1_T1_0_0[0:0]  T3[15:15] )+(V0_T1_0_0[0:0]  X413[0:0] ));
X        X318[0:0] = ((V1_T1_0_0[0:0]  T3[14:14] )+(V0_T1_0_0[0:0]  X414[0:0] ));
X        X319[0:0] = ((V1_T1_0_0[0:0]  T3[13:13] )+(V0_T1_0_0[0:0]  X415[0:0] ));
X        X320[0:0] = ((V1_T1_0_0[0:0]  T3[12:12] )+(V0_T1_0_0[0:0]  X416[0:0] ));
X        X321[0:0] = ((V1_T1_0_0[0:0]  T3[11:11] )+(V0_T1_0_0[0:0]  X417[0:0] ));
X        X322[0:0] = ((V1_T1_0_0[0:0]  T3[10:10] )+(V0_T1_0_0[0:0]  X418[0:0] ));
X        X323[0:0] = ((V1_T1_0_0[0:0]  T3[9:9] )+(V0_T1_0_0[0:0]  X419[0:0] ));
X        X324[0:0] = ((V1_T1_0_0[0:0]  T3[8:8] )+(V0_T1_0_0[0:0]  X420[0:0] ));
X        X325[0:0] = ((V1_T1_0_0[0:0]  T3[7:7] )+(V0_T1_0_0[0:0]  X421[0:0] ));
X        X326[0:0] = ((V1_T1_0_0[0:0]  T3[6:6] )+(V0_T1_0_0[0:0]  X422[0:0] ));
X        X327[0:0] = ((V1_T1_0_0[0:0]  T3[5:5] )+(V0_T1_0_0[0:0]  X423[0:0] ));
X        X328[0:0] = ((V1_T1_0_0[0:0]  T3[4:4] )+(V0_T1_0_0[0:0]  X424[0:0] ));
X        X329[0:0] = ((V1_T1_0_0[0:0]  T3[3:3] )+(V0_T1_0_0[0:0]  X425[0:0] ));
X        X330[0:0] = ((V1_T1_0_0[0:0]  T3[2:2] )+(V0_T1_0_0[0:0]  X426[0:0] ));
X        X331[0:0] = ((V1_T1_0_0[0:0]  T3[1:1] )+(V0_T1_0_0[0:0]  X427[0:0] ));
X        X332[0:0] = ((V1_T1_0_0[0:0]  T3[0:0] )+(V0_T1_0_0[0:0]  X428[0:0] ));
X        X333[0:0] = ((V1_T1_0_0[0:0]  T2[15:15] )+(V0_T1_0_0[0:0]  X429[0:0] ));
X        X334[0:0] = ((V1_T1_0_0[0:0]  T2[14:14] )+(V0_T1_0_0[0:0]  X430[0:0] ));
X        X335[0:0] = ((V1_T1_0_0[0:0]  T2[13:13] )+(V0_T1_0_0[0:0]  X431[0:0] ));
X        X336[0:0] = ((V1_T1_0_0[0:0]  T2[12:12] )+(V0_T1_0_0[0:0]  X432[0:0] ));
X        X337[0:0] = ((V1_T1_0_0[0:0]  T2[11:11] )+(V0_T1_0_0[0:0]  X433[0:0] ));
X        X338[0:0] = ((V1_T1_0_0[0:0]  T2[10:10] )+(V0_T1_0_0[0:0]  X434[0:0] ));
X        X339[0:0] = ((V1_T1_0_0[0:0]  T2[9:9] )+(V0_T1_0_0[0:0]  X435[0:0] ));
X        X340[0:0] = ((V1_T1_0_0[0:0]  T2[8:8] )+(V0_T1_0_0[0:0]  X436[0:0] ));
X        X341[0:0] = ((V1_T1_0_0[0:0]  T2[7:7] )+(V0_T1_0_0[0:0]  X437[0:0] ));
X        X342[0:0] = ((V1_T1_0_0[0:0]  T2[6:6] )+(V0_T1_0_0[0:0]  X438[0:0] ));
X        X343[0:0] = ((V1_T1_0_0[0:0]  T2[5:5] )+(V0_T1_0_0[0:0]  X439[0:0] ));
X        X344[0:0] = ((V1_T1_0_0[0:0]  T2[4:4] )+(V0_T1_0_0[0:0]  X440[0:0] ));
X        X345[0:0] = ((V1_T1_0_0[0:0]  T2[3:3] )+(V0_T1_0_0[0:0]  X441[0:0] ));
X        X346[0:0] = ((V1_T1_0_0[0:0]  T2[2:2] )+(V0_T1_0_0[0:0]  X442[0:0] ));
X        X347[0:0] = ((V1_T1_0_0[0:0]  T2[1:1] )+(V0_T1_0_0[0:0]  X443[0:0] ));
X        X348[0:0] = ((V1_T1_0_0[0:0]  T2[0:0] )+(V0_T1_0_0[0:0]  X444[0:0] ));
X        X349[0:0] = ((V1_T12_0_0[0:0]  i[15:15] )+(V0_T12_0_0[0:0]  T9[15:15] ));
X        X350[0:0] = ((V1_T12_0_0[0:0]  i[14:14] )+(V0_T12_0_0[0:0]  T9[14:14] ));
X        X351[0:0] = ((V1_T12_0_0[0:0]  i[13:13] )+(V0_T12_0_0[0:0]  T9[13:13] ));
X        X352[0:0] = ((V1_T12_0_0[0:0]  i[12:12] )+(V0_T12_0_0[0:0]  T9[12:12] ));
X        X353[0:0] = ((V1_T12_0_0[0:0]  i[11:11] )+(V0_T12_0_0[0:0]  T9[11:11] ));
X        X354[0:0] = ((V1_T12_0_0[0:0]  i[10:10] )+(V0_T12_0_0[0:0]  T9[10:10] ));
X        X355[0:0] = ((V1_T12_0_0[0:0]  i[9:9] )+(V0_T12_0_0[0:0]  T9[9:9] ));
X        X356[0:0] = ((V1_T12_0_0[0:0]  i[8:8] )+(V0_T12_0_0[0:0]  T9[8:8] ));
X        X357[0:0] = ((V1_T12_0_0[0:0]  i[7:7] )+(V0_T12_0_0[0:0]  T9[7:7] ));
X        X358[0:0] = ((V1_T12_0_0[0:0]  i[6:6] )+(V0_T12_0_0[0:0]  T9[6:6] ));
X        X359[0:0] = ((V1_T12_0_0[0:0]  i[5:5] )+(V0_T12_0_0[0:0]  T9[5:5] ));
X        X360[0:0] = ((V1_T12_0_0[0:0]  i[4:4] )+(V0_T12_0_0[0:0]  T9[4:4] ));
X        X361[0:0] = ((V1_T12_0_0[0:0]  i[3:3] )+(V0_T12_0_0[0:0]  T9[3:3] ));
X        X362[0:0] = ((V1_T12_0_0[0:0]  i[2:2] )+(V0_T12_0_0[0:0]  T9[2:2] ));
X        X363[0:0] = ((V1_T12_0_0[0:0]  i[1:1] )+(V0_T12_0_0[0:0]  T9[1:1] ));
X        X364[0:0] = ((V1_T12_0_0[0:0]  i[0:0] )+(V0_T12_0_0[0:0]  T9[0:0] ));
X        X365[0:0] = ((V1_T12_0_0[0:0]  b[15:15] )+(V0_T12_0_0[0:0]  X17[0:0] ));
X        X366[0:0] = ((V1_T12_0_0[0:0]  b[14:14] )+(V0_T12_0_0[0:0]  X18[0:0] ));
X        X367[0:0] = ((V1_T12_0_0[0:0]  b[13:13] )+(V0_T12_0_0[0:0]  X19[0:0] ));
X        X368[0:0] = ((V1_T12_0_0[0:0]  b[12:12] )+(V0_T12_0_0[0:0]  X20[0:0] ));
X        X369[0:0] = ((V1_T12_0_0[0:0]  b[11:11] )+(V0_T12_0_0[0:0]  X21[0:0] ));
X        X370[0:0] = ((V1_T12_0_0[0:0]  b[10:10] )+(V0_T12_0_0[0:0]  X22[0:0] ));
X        X371[0:0] = ((V1_T12_0_0[0:0]  b[9:9] )+(V0_T12_0_0[0:0]  X23[0:0] ));
X        X372[0:0] = ((V1_T12_0_0[0:0]  b[8:8] )+(V0_T12_0_0[0:0]  X24[0:0] ));
X        X373[0:0] = ((V1_T12_0_0[0:0]  b[7:7] )+(V0_T12_0_0[0:0]  X25[0:0] ));
X        X374[0:0] = ((V1_T12_0_0[0:0]  b[6:6] )+(V0_T12_0_0[0:0]  X26[0:0] ));
X        X375[0:0] = ((V1_T12_0_0[0:0]  b[5:5] )+(V0_T12_0_0[0:0]  X27[0:0] ));
X        X376[0:0] = ((V1_T12_0_0[0:0]  b[4:4] )+(V0_T12_0_0[0:0]  X28[0:0] ));
X        X377[0:0] = ((V1_T12_0_0[0:0]  b[3:3] )+(V0_T12_0_0[0:0]  X29[0:0] ));
X        X378[0:0] = ((V1_T12_0_0[0:0]  b[2:2] )+(V0_T12_0_0[0:0]  X30[0:0] ));
X        X379[0:0] = ((V1_T12_0_0[0:0]  b[1:1] )+(V0_T12_0_0[0:0]  X31[0:0] ));
X        X380[0:0] = ((V1_T12_0_0[0:0]  b[0:0] )+(V0_T12_0_0[0:0]  X32[0:0] ));
X        X381[0:0] = ((V1_T12_0_0[0:0]  a[15:15] )+(V0_T12_0_0[0:0]  X33[0:0] ));
X        X382[0:0] = ((V1_T12_0_0[0:0]  a[14:14] )+(V0_T12_0_0[0:0]  X34[0:0] ));
X        X383[0:0] = ((V1_T12_0_0[0:0]  a[13:13] )+(V0_T12_0_0[0:0]  X35[0:0] ));
X        X384[0:0] = ((V1_T12_0_0[0:0]  a[12:12] )+(V0_T12_0_0[0:0]  X36[0:0] ));
X        X385[0:0] = ((V1_T12_0_0[0:0]  a[11:11] )+(V0_T12_0_0[0:0]  X37[0:0] ));
X        X386[0:0] = ((V1_T12_0_0[0:0]  a[10:10] )+(V0_T12_0_0[0:0]  X38[0:0] ));
X        X387[0:0] = ((V1_T12_0_0[0:0]  a[9:9] )+(V0_T12_0_0[0:0]  X39[0:0] ));
X        X388[0:0] = ((V1_T12_0_0[0:0]  a[8:8] )+(V0_T12_0_0[0:0]  X40[0:0] ));
X        X389[0:0] = ((V1_T12_0_0[0:0]  a[7:7] )+(V0_T12_0_0[0:0]  X41[0:0] ));
X        X390[0:0] = ((V1_T12_0_0[0:0]  a[6:6] )+(V0_T12_0_0[0:0]  X42[0:0] ));
X        X391[0:0] = ((V1_T12_0_0[0:0]  a[5:5] )+(V0_T12_0_0[0:0]  X43[0:0] ));
X        X392[0:0] = ((V1_T12_0_0[0:0]  a[4:4] )+(V0_T12_0_0[0:0]  X44[0:0] ));
X        X393[0:0] = ((V1_T12_0_0[0:0]  a[3:3] )+(V0_T12_0_0[0:0]  X45[0:0] ));
X        X394[0:0] = ((V1_T12_0_0[0:0]  a[2:2] )+(V0_T12_0_0[0:0]  X46[0:0] ));
X        X395[0:0] = ((V1_T12_0_0[0:0]  a[1:1] )+(V0_T12_0_0[0:0]  X47[0:0] ));
X        X396[0:0] = ((V1_T12_0_0[0:0]  a[0:0] )+(V0_T12_0_0[0:0]  X48[0:0] ));
X        X397[0:0] = ((V1_T12_0_0[0:0]  m[15:15] )+(V0_T12_0_0[0:0]  X49[0:0] ));
X        X398[0:0] = ((V1_T12_0_0[0:0]  m[14:14] )+(V0_T12_0_0[0:0]  X50[0:0] ));
X        X399[0:0] = ((V1_T12_0_0[0:0]  m[13:13] )+(V0_T12_0_0[0:0]  X51[0:0] ));
X        X400[0:0] = ((V1_T12_0_0[0:0]  m[12:12] )+(V0_T12_0_0[0:0]  X52[0:0] ));
X        X401[0:0] = ((V1_T12_0_0[0:0]  m[11:11] )+(V0_T12_0_0[0:0]  X53[0:0] ));
X        X402[0:0] = ((V1_T12_0_0[0:0]  m[10:10] )+(V0_T12_0_0[0:0]  X54[0:0] ));
X        X403[0:0] = ((V1_T12_0_0[0:0]  m[9:9] )+(V0_T12_0_0[0:0]  X55[0:0] ));
X        X404[0:0] = ((V1_T12_0_0[0:0]  m[8:8] )+(V0_T12_0_0[0:0]  X56[0:0] ));
X        X405[0:0] = ((V1_T12_0_0[0:0]  m[7:7] )+(V0_T12_0_0[0:0]  X57[0:0] ));
X        X406[0:0] = ((V1_T12_0_0[0:0]  m[6:6] )+(V0_T12_0_0[0:0]  X58[0:0] ));
X        X407[0:0] = ((V1_T12_0_0[0:0]  m[5:5] )+(V0_T12_0_0[0:0]  X59[0:0] ));
X        X408[0:0] = ((V1_T12_0_0[0:0]  m[4:4] )+(V0_T12_0_0[0:0]  X60[0:0] ));
X        X409[0:0] = ((V1_T12_0_0[0:0]  m[3:3] )+(V0_T12_0_0[0:0]  X61[0:0] ));
X        X410[0:0] = ((V1_T12_0_0[0:0]  m[2:2] )+(V0_T12_0_0[0:0]  X62[0:0] ));
X        X411[0:0] = ((V1_T12_0_0[0:0]  m[1:1] )+(V0_T12_0_0[0:0]  X63[0:0] ));
X        X412[0:0] = ((V1_T12_0_0[0:0]  m[0:0] )+(V0_T12_0_0[0:0]  X64[0:0] ));
X        X413[0:0] = ((V1_T12_0_0[0:0]  s[15:15] )+(V0_T12_0_0[0:0]  X65[0:0] ));
X        X414[0:0] = ((V1_T12_0_0[0:0]  s[14:14] )+(V0_T12_0_0[0:0]  X66[0:0] ));
X        X415[0:0] = ((V1_T12_0_0[0:0]  s[13:13] )+(V0_T12_0_0[0:0]  X67[0:0] ));
X        X416[0:0] = ((V1_T12_0_0[0:0]  s[12:12] )+(V0_T12_0_0[0:0]  X68[0:0] ));
X        X417[0:0] = ((V1_T12_0_0[0:0]  s[11:11] )+(V0_T12_0_0[0:0]  X69[0:0] ));
X        X418[0:0] = ((V1_T12_0_0[0:0]  s[10:10] )+(V0_T12_0_0[0:0]  X70[0:0] ));
X        X419[0:0] = ((V1_T12_0_0[0:0]  s[9:9] )+(V0_T12_0_0[0:0]  X71[0:0] ));
X        X420[0:0] = ((V1_T12_0_0[0:0]  s[8:8] )+(V0_T12_0_0[0:0]  X72[0:0] ));
X        X421[0:0] = ((V1_T12_0_0[0:0]  s[7:7] )+(V0_T12_0_0[0:0]  X73[0:0] ));
X        X422[0:0] = ((V1_T12_0_0[0:0]  s[6:6] )+(V0_T12_0_0[0:0]  X74[0:0] ));
X        X423[0:0] = ((V1_T12_0_0[0:0]  s[5:5] )+(V0_T12_0_0[0:0]  X75[0:0] ));
X        X424[0:0] = ((V1_T12_0_0[0:0]  s[4:4] )+(V0_T12_0_0[0:0]  X76[0:0] ));
X        X425[0:0] = ((V1_T12_0_0[0:0]  s[3:3] )+(V0_T12_0_0[0:0]  X77[0:0] ));
X        X426[0:0] = ((V1_T12_0_0[0:0]  s[2:2] )+(V0_T12_0_0[0:0]  X78[0:0] ));
X        X427[0:0] = ((V1_T12_0_0[0:0]  s[1:1] )+(V0_T12_0_0[0:0]  X79[0:0] ));
X        X428[0:0] = ((V1_T12_0_0[0:0]  s[0:0] )+(V0_T12_0_0[0:0]  X80[0:0] ));
X        X429[0:0] = ((V1_T12_0_0[0:0]  p[15:15] )+(V0_T12_0_0[0:0]  T11[15:15] ));
X        X430[0:0] = ((V1_T12_0_0[0:0]  p[14:14] )+(V0_T12_0_0[0:0]  T11[14:14] ));
X        X431[0:0] = ((V1_T12_0_0[0:0]  p[13:13] )+(V0_T12_0_0[0:0]  T11[13:13] ));
X        X432[0:0] = ((V1_T12_0_0[0:0]  p[12:12] )+(V0_T12_0_0[0:0]  T11[12:12] ));
X        X433[0:0] = ((V1_T12_0_0[0:0]  p[11:11] )+(V0_T12_0_0[0:0]  T11[11:11] ));
X        X434[0:0] = ((V1_T12_0_0[0:0]  p[10:10] )+(V0_T12_0_0[0:0]  T11[10:10] ));
X        X435[0:0] = ((V1_T12_0_0[0:0]  p[9:9] )+(V0_T12_0_0[0:0]  T11[9:9] ));
X        X436[0:0] = ((V1_T12_0_0[0:0]  p[8:8] )+(V0_T12_0_0[0:0]  T11[8:8] ));
X        X437[0:0] = ((V1_T12_0_0[0:0]  p[7:7] )+(V0_T12_0_0[0:0]  T11[7:7] ));
X        X438[0:0] = ((V1_T12_0_0[0:0]  p[6:6] )+(V0_T12_0_0[0:0]  T11[6:6] ));
X        X439[0:0] = ((V1_T12_0_0[0:0]  p[5:5] )+(V0_T12_0_0[0:0]  T11[5:5] ));
X        X440[0:0] = ((V1_T12_0_0[0:0]  p[4:4] )+(V0_T12_0_0[0:0]  T11[4:4] ));
X        X441[0:0] = ((V1_T12_0_0[0:0]  p[3:3] )+(V0_T12_0_0[0:0]  T11[3:3] ));
X        X442[0:0] = ((V1_T12_0_0[0:0]  p[2:2] )+(V0_T12_0_0[0:0]  T11[2:2] ));
X        X443[0:0] = ((V1_T12_0_0[0:0]  p[1:1] )+(V0_T12_0_0[0:0]  T11[1:1] ));
X        X444[0:0] = ((V1_T12_0_0[0:0]  p[0:0] )+(V0_T12_0_0[0:0]  T11[0:0] ));
X        V0_T12_0_0[0:0] = T12[0:0]' ;
X        V1_T12_0_0[0:0] = T12[0:0] ;
X        V0_T1_0_0[0:0] = T1[0:0]' ;
X        V1_T1_0_0[0:0] = T1[0:0] ;
X        .attribute delay 4 level;
X        .attribute area 1444 literal;
X      .endoperation;
X    .endnode;
X
X    .node 4 operation;
X      .inputs M11[0:15] M10[0:15] M9[0:15] M8[0:15] 
X	M7[0:15] M6[0:15] ;
X      .outputs i[0:15] b[0:15] a[0:15] m[0:15] 
X	s[0:15] p[0:15] ;
X      .successors 5 ;	#  predecessors 3 
X      .attribute constraint delay 4 1 cycles;
X      .operation load_register;
X    .endnode;
X
X    .node 5 nop;	#	sink node
X      .successors ;	#  predecessors 4 
X    .endnode;
X
X    .attribute constraint delay 4 1 cycles;
X    .attribute hercules direct_connect peaki[0:0] i[0:0] ;
X    .attribute hercules direct_connect peaki[1:1] i[1:1] ;
X    .attribute hercules direct_connect peaki[2:2] i[2:2] ;
X    .attribute hercules direct_connect peaki[3:3] i[3:3] ;
X    .attribute hercules direct_connect peaki[4:4] i[4:4] ;
X    .attribute hercules direct_connect peaki[5:5] i[5:5] ;
X    .attribute hercules direct_connect peaki[6:6] i[6:6] ;
X    .attribute hercules direct_connect peaki[7:7] i[7:7] ;
X    .attribute hercules direct_connect peaki[8:8] i[8:8] ;
X    .attribute hercules direct_connect peaki[9:9] i[9:9] ;
X    .attribute hercules direct_connect peaki[10:10] i[10:10] ;
X    .attribute hercules direct_connect peaki[11:11] i[11:11] ;
X    .attribute hercules direct_connect peaki[12:12] i[12:12] ;
X    .attribute hercules direct_connect peaki[13:13] i[13:13] ;
X    .attribute hercules direct_connect peaki[14:14] i[14:14] ;
X    .attribute hercules direct_connect peaki[15:15] i[15:15] ;
X    .attribute hercules direct_connect peakp[0:0] p[0:0] ;
X    .attribute hercules direct_connect peakp[1:1] p[1:1] ;
X    .attribute hercules direct_connect peakp[2:2] p[2:2] ;
X    .attribute hercules direct_connect peakp[3:3] p[3:3] ;
X    .attribute hercules direct_connect peakp[4:4] p[4:4] ;
X    .attribute hercules direct_connect peakp[5:5] p[5:5] ;
X    .attribute hercules direct_connect peakp[6:6] p[6:6] ;
X    .attribute hercules direct_connect peakp[7:7] p[7:7] ;
X    .attribute hercules direct_connect peakp[8:8] p[8:8] ;
X    .attribute hercules direct_connect peakp[9:9] p[9:9] ;
X    .attribute hercules direct_connect peakp[10:10] p[10:10] ;
X    .attribute hercules direct_connect peakp[11:11] p[11:11] ;
X    .attribute hercules direct_connect peakp[12:12] p[12:12] ;
X    .attribute hercules direct_connect peakp[13:13] p[13:13] ;
X    .attribute hercules direct_connect peakp[14:14] p[14:14] ;
X    .attribute hercules direct_connect peakp[15:15] p[15:15] ;
X    .attribute hercules direct_connect peaks[0:0] s[0:0] ;
X    .attribute hercules direct_connect peaks[1:1] s[1:1] ;
X    .attribute hercules direct_connect peaks[2:2] s[2:2] ;
X    .attribute hercules direct_connect peaks[3:3] s[3:3] ;
X    .attribute hercules direct_connect peaks[4:4] s[4:4] ;
X    .attribute hercules direct_connect peaks[5:5] s[5:5] ;
X    .attribute hercules direct_connect peaks[6:6] s[6:6] ;
X    .attribute hercules direct_connect peaks[7:7] s[7:7] ;
X    .attribute hercules direct_connect peaks[8:8] s[8:8] ;
X    .attribute hercules direct_connect peaks[9:9] s[9:9] ;
X    .attribute hercules direct_connect peaks[10:10] s[10:10] ;
X    .attribute hercules direct_connect peaks[11:11] s[11:11] ;
X    .attribute hercules direct_connect peaks[12:12] s[12:12] ;
X    .attribute hercules direct_connect peaks[13:13] s[13:13] ;
X    .attribute hercules direct_connect peaks[14:14] s[14:14] ;
X    .attribute hercules direct_connect peaks[15:15] s[15:15] ;
X    .attribute hercules direct_connect peaka[0:0] a[0:0] ;
X    .attribute hercules direct_connect peaka[1:1] a[1:1] ;
X    .attribute hercules direct_connect peaka[2:2] a[2:2] ;
X    .attribute hercules direct_connect peaka[3:3] a[3:3] ;
X    .attribute hercules direct_connect peaka[4:4] a[4:4] ;
X    .attribute hercules direct_connect peaka[5:5] a[5:5] ;
X    .attribute hercules direct_connect peaka[6:6] a[6:6] ;
X    .attribute hercules direct_connect peaka[7:7] a[7:7] ;
X    .attribute hercules direct_connect peaka[8:8] a[8:8] ;
X    .attribute hercules direct_connect peaka[9:9] a[9:9] ;
X    .attribute hercules direct_connect peaka[10:10] a[10:10] ;
X    .attribute hercules direct_connect peaka[11:11] a[11:11] ;
X    .attribute hercules direct_connect peaka[12:12] a[12:12] ;
X    .attribute hercules direct_connect peaka[13:13] a[13:13] ;
X    .attribute hercules direct_connect peaka[14:14] a[14:14] ;
X    .attribute hercules direct_connect peaka[15:15] a[15:15] ;
X    .attribute hercules direct_connect peakb[0:0] b[0:0] ;
X    .attribute hercules direct_connect peakb[1:1] b[1:1] ;
X    .attribute hercules direct_connect peakb[2:2] b[2:2] ;
X    .attribute hercules direct_connect peakb[3:3] b[3:3] ;
X    .attribute hercules direct_connect peakb[4:4] b[4:4] ;
X    .attribute hercules direct_connect peakb[5:5] b[5:5] ;
X    .attribute hercules direct_connect peakb[6:6] b[6:6] ;
X    .attribute hercules direct_connect peakb[7:7] b[7:7] ;
X    .attribute hercules direct_connect peakb[8:8] b[8:8] ;
X    .attribute hercules direct_connect peakb[9:9] b[9:9] ;
X    .attribute hercules direct_connect peakb[10:10] b[10:10] ;
X    .attribute hercules direct_connect peakb[11:11] b[11:11] ;
X    .attribute hercules direct_connect peakb[12:12] b[12:12] ;
X    .attribute hercules direct_connect peakb[13:13] b[13:13] ;
X    .attribute hercules direct_connect peakb[14:14] b[14:14] ;
X    .attribute hercules direct_connect peakb[15:15] b[15:15] ;
X    .endpolargraph;
X.endmodel frisc ;
END_OF_FILE
if test 190703 -ne `wc -c <'frisc/frisc.sif'`; then
    echo shar: \"'frisc/frisc.sif'\" unpacked with wrong size!
fi
# end of 'frisc/frisc.sif'
fi
if test -f 'frisc/subtract_16.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'frisc/subtract_16.sif'\"
else
echo shar: Extracting \"'frisc/subtract_16.sif'\" \(6011 characters\)
sed "s/^X//" >'frisc/subtract_16.sif' <<'END_OF_FILE'
X#
X#	Sif model subtract_16	Printed Tue Jul 24 15:04:17 1990
X#
X.model subtract_16 sequencing ; 
X  .inputs op1[16] op2[16] ;
X  .outputs return_value[17] ;
X    #	Index 1
X    .polargraph 1 4;
X    .variable T2[17] T1[17] ;
X    #	4 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 operation;
X      .inputs op2[0:0] op2[1:1] op2[2:2] op2[3:3] 
X	op2[4:4] op2[5:5] op2[6:6] op2[7:7] 
X	op2[8:8] op2[9:9] op2[10:10] op2[11:11] 
X	op2[12:12] op2[13:13] op2[14:14] op2[15:15] 
X	;
X      .outputs T1[0:0] T1[1:1] T1[2:2] T1[3:3] 
X	T1[4:4] T1[5:5] T1[6:6] T1[7:7] 
X	T1[8:8] T1[9:9] T1[10:10] T1[11:11] 
X	T1[12:12] T1[13:13] T1[14:14] T1[15:15] 
X	;
X      .successors 3 ;	#  predecessors 1 
X      .operation logic 1 ;
X        #	Expression 0
X        c_T1[0:0] =  1 ;
X        T1[0:0] = ((((( 0'  op2[0:0]' ) c_T1[0:0]' )+(( 0  op2[0:0] ) c_T1[0:0]' ))+(( 0'  op2[0:0] ) c_T1[0:0] ))+(( 0  op2[0:0]' ) c_T1[0:0] ));
X        c_T1[1:1] = (( 0  op2[0:0]' )+(c_T1[0:0]  ( 0 +op2[0:0]' )));
X        T1[1:1] = ((((( 0'  op2[1:1]' ) c_T1[1:1]' )+(( 0  op2[1:1] ) c_T1[1:1]' ))+(( 0'  op2[1:1] ) c_T1[1:1] ))+(( 0  op2[1:1]' ) c_T1[1:1] ));
X        c_T1[2:2] = (( 0  op2[1:1]' )+(c_T1[1:1]  ( 0 +op2[1:1]' )));
X        T1[2:2] = ((((( 0'  op2[2:2]' ) c_T1[2:2]' )+(( 0  op2[2:2] ) c_T1[2:2]' ))+(( 0'  op2[2:2] ) c_T1[2:2] ))+(( 0  op2[2:2]' ) c_T1[2:2] ));
X        c_T1[3:3] = (( 0  op2[2:2]' )+(c_T1[2:2]  ( 0 +op2[2:2]' )));
X        T1[3:3] = ((((( 0'  op2[3:3]' ) c_T1[3:3]' )+(( 0  op2[3:3] ) c_T1[3:3]' ))+(( 0'  op2[3:3] ) c_T1[3:3] ))+(( 0  op2[3:3]' ) c_T1[3:3] ));
X        c_T1[4:4] = (( 0  op2[3:3]' )+(c_T1[3:3]  ( 0 +op2[3:3]' )));
X        T1[4:4] = ((((( 0'  op2[4:4]' ) c_T1[4:4]' )+(( 0  op2[4:4] ) c_T1[4:4]' ))+(( 0'  op2[4:4] ) c_T1[4:4] ))+(( 0  op2[4:4]' ) c_T1[4:4] ));
X        c_T1[5:5] = (( 0  op2[4:4]' )+(c_T1[4:4]  ( 0 +op2[4:4]' )));
X        T1[5:5] = ((((( 0'  op2[5:5]' ) c_T1[5:5]' )+(( 0  op2[5:5] ) c_T1[5:5]' ))+(( 0'  op2[5:5] ) c_T1[5:5] ))+(( 0  op2[5:5]' ) c_T1[5:5] ));
X        c_T1[6:6] = (( 0  op2[5:5]' )+(c_T1[5:5]  ( 0 +op2[5:5]' )));
X        T1[6:6] = ((((( 0'  op2[6:6]' ) c_T1[6:6]' )+(( 0  op2[6:6] ) c_T1[6:6]' ))+(( 0'  op2[6:6] ) c_T1[6:6] ))+(( 0  op2[6:6]' ) c_T1[6:6] ));
X        c_T1[7:7] = (( 0  op2[6:6]' )+(c_T1[6:6]  ( 0 +op2[6:6]' )));
X        T1[7:7] = ((((( 0'  op2[7:7]' ) c_T1[7:7]' )+(( 0  op2[7:7] ) c_T1[7:7]' ))+(( 0'  op2[7:7] ) c_T1[7:7] ))+(( 0  op2[7:7]' ) c_T1[7:7] ));
X        c_T1[8:8] = (( 0  op2[7:7]' )+(c_T1[7:7]  ( 0 +op2[7:7]' )));
X        T1[8:8] = ((((( 0'  op2[8:8]' ) c_T1[8:8]' )+(( 0  op2[8:8] ) c_T1[8:8]' ))+(( 0'  op2[8:8] ) c_T1[8:8] ))+(( 0  op2[8:8]' ) c_T1[8:8] ));
X        c_T1[9:9] = (( 0  op2[8:8]' )+(c_T1[8:8]  ( 0 +op2[8:8]' )));
X        T1[9:9] = ((((( 0'  op2[9:9]' ) c_T1[9:9]' )+(( 0  op2[9:9] ) c_T1[9:9]' ))+(( 0'  op2[9:9] ) c_T1[9:9] ))+(( 0  op2[9:9]' ) c_T1[9:9] ));
X        c_T1[10:10] = (( 0  op2[9:9]' )+(c_T1[9:9]  ( 0 +op2[9:9]' )));
X        T1[10:10] = ((((( 0'  op2[10:10]' ) c_T1[10:10]' )+(( 0  op2[10:10] ) c_T1[10:10]' ))+(( 0'  op2[10:10] ) c_T1[10:10] ))+(( 0  op2[10:10]' ) c_T1[10:10] ));
X        c_T1[11:11] = (( 0  op2[10:10]' )+(c_T1[10:10]  ( 0 +op2[10:10]' )));
X        T1[11:11] = ((((( 0'  op2[11:11]' ) c_T1[11:11]' )+(( 0  op2[11:11] ) c_T1[11:11]' ))+(( 0'  op2[11:11] ) c_T1[11:11] ))+(( 0  op2[11:11]' ) c_T1[11:11] ));
X        c_T1[12:12] = (( 0  op2[11:11]' )+(c_T1[11:11]  ( 0 +op2[11:11]' )));
X        T1[12:12] = ((((( 0'  op2[12:12]' ) c_T1[12:12]' )+(( 0  op2[12:12] ) c_T1[12:12]' ))+(( 0'  op2[12:12] ) c_T1[12:12] ))+(( 0  op2[12:12]' ) c_T1[12:12] ));
X        c_T1[13:13] = (( 0  op2[12:12]' )+(c_T1[12:12]  ( 0 +op2[12:12]' )));
X        T1[13:13] = ((((( 0'  op2[13:13]' ) c_T1[13:13]' )+(( 0  op2[13:13] ) c_T1[13:13]' ))+(( 0'  op2[13:13] ) c_T1[13:13] ))+(( 0  op2[13:13]' ) c_T1[13:13] ));
X        c_T1[14:14] = (( 0  op2[13:13]' )+(c_T1[13:13]  ( 0 +op2[13:13]' )));
X        T1[14:14] = ((((( 0'  op2[14:14]' ) c_T1[14:14]' )+(( 0  op2[14:14] ) c_T1[14:14]' ))+(( 0'  op2[14:14] ) c_T1[14:14] ))+(( 0  op2[14:14]' ) c_T1[14:14] ));
X        c_T1[15:15] = (( 0  op2[14:14]' )+(c_T1[14:14]  ( 0 +op2[14:14]' )));
X        T1[15:15] = ((((( 0'  op2[15:15]' ) c_T1[15:15]' )+(( 0  op2[15:15] ) c_T1[15:15]' ))+(( 0'  op2[15:15] ) c_T1[15:15] ))+(( 0  op2[15:15]' ) c_T1[15:15] ));
X        c_T1[16:16] = (( 0  op2[15:15]' )+(c_T1[15:15]  ( 0 +op2[15:15]' )));
X        T1[16:16] = c_T1[15:15] ;
X        .attribute delay 35 level;
X        .attribute area 514 literal;
X      .endoperation;
X    .endnode;
X
X    .node 3 proc;
X      .inputs op1[0:15] T1[0:15] ;
X      .outputs T2[0:16] ;
X      .successors 4 ;	#  predecessors 2 
X      .proc add with (16);
X    .endnode;
X
X    .node 4 nop;	#	sink node
X      .successors ;	#  predecessors 3 
X    .endnode;
X
X    .attribute hercules direct_connect return_value[0:0] T2[0:0] ;
X    .attribute hercules direct_connect return_value[1:1] T2[1:1] ;
X    .attribute hercules direct_connect return_value[2:2] T2[2:2] ;
X    .attribute hercules direct_connect return_value[3:3] T2[3:3] ;
X    .attribute hercules direct_connect return_value[4:4] T2[4:4] ;
X    .attribute hercules direct_connect return_value[5:5] T2[5:5] ;
X    .attribute hercules direct_connect return_value[6:6] T2[6:6] ;
X    .attribute hercules direct_connect return_value[7:7] T2[7:7] ;
X    .attribute hercules direct_connect return_value[8:8] T2[8:8] ;
X    .attribute hercules direct_connect return_value[9:9] T2[9:9] ;
X    .attribute hercules direct_connect return_value[10:10] T2[10:10] ;
X    .attribute hercules direct_connect return_value[11:11] T2[11:11] ;
X    .attribute hercules direct_connect return_value[12:12] T2[12:12] ;
X    .attribute hercules direct_connect return_value[13:13] T2[13:13] ;
X    .attribute hercules direct_connect return_value[14:14] T2[14:14] ;
X    .attribute hercules direct_connect return_value[15:15] T2[15:15] ;
X    .attribute hercules direct_connect return_value[16:16] T2[16:16] ;
X    .endpolargraph;
X.endmodel subtract_16 ;
END_OF_FILE
if test 6011 -ne `wc -c <'frisc/subtract_16.sif'`; then
    echo shar: \"'frisc/subtract_16.sif'\" unpacked with wrong size!
fi
# end of 'frisc/subtract_16.sif'
fi
if test -f 'frisc/frisc.out.gold' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'frisc/frisc.out.gold'\"
else
echo shar: Extracting \"'frisc/frisc.out.gold'\" \(7073 characters\)
sed "s/^X//" >'frisc/frisc.out.gold' <<'END_OF_FILE'
X117 ariadne extract
Xreset[0:0]
Xirq[0:0]
Xiack[0:0]
Xrd[0:0]
Xwr[0:0]
XHEX ADDR0 address[0:0] address[1:1] address[2:2] address[3:3]
XHEX ADDR1 address[4:4] address[5:5] address[6:6] address[7:7]
XHEX ADDR2 address[8:8] address[9:9] address[10:10] address[11:11]
XHEX ADDR3 address[12:12] address[13:13] address[14:14] address[15:15]
XHEX peakI0 peaki[0:0] peaki[1:1] peaki[2:2] peaki[3:3]
XHEX peakI1 peaki[4:4] peaki[5:5] peaki[6:6] peaki[7:7]
XHEX peakI2 peaki[8:8] peaki[9:9] peaki[10:10] peaki[11:11]
XHEX peakI3 peaki[12:12] peaki[13:13] peaki[14:14] peaki[15:15]
XHEX peakP0 peakp[0:0] peakp[1:1] peakp[2:2] peakp[3:3]
XHEX peakP1 peakp[4:4] peakp[5:5] peakp[6:6] peakp[7:7]
XHEX peakP2 peakp[8:8] peakp[9:9] peakp[10:10] peakp[11:11]
XHEX peakP3 peakp[12:12] peakp[13:13] peakp[14:14] peakp[15:15]
XHEX peakS0 peaks[0:0] peaks[1:1] peaks[2:2] peaks[3:3]
XHEX peakS1 peaks[4:4] peaks[5:5] peaks[6:6] peaks[7:7]
XHEX peakS2 peaks[8:8] peaks[9:9] peaks[10:10] peaks[11:11]
XHEX peakS3 peaks[12:12] peaks[13:13] peaks[14:14] peaks[15:15]
XHEX peakA0 peaka[0:0] peaka[1:1] peaka[2:2] peaka[3:3]
XHEX peakA1 peaka[4:4] peaka[5:5] peaka[6:6] peaka[7:7]
XHEX peakA2 peaka[8:8] peaka[9:9] peaka[10:10] peaka[11:11]
XHEX peakA3 peaka[12:12] peaka[13:13] peaka[14:14] peaka[15:15]
XHEX peakB0 peakb[0:0] peakb[1:1] peakb[2:2] peakb[3:3]
XHEX peakB1 peakb[4:4] peakb[5:5] peakb[6:6] peakb[7:7]
XHEX peakB2 peakb[8:8] peakb[9:9] peakb[10:10] peakb[11:11]
XHEX peakB3 peakb[12:12] peakb[13:13] peakb[14:14] peakb[15:15]
XHEX DATA0 data[0:0] data[1:1] data[2:2] data[3:3]
XHEX DATA1 data[4:4] data[5:5] data[6:6] data[7:7]
XHEX DATA2 data[8:8] data[9:9] data[10:10] data[11:11]
XHEX DATA3 data[12:12] data[13:13] data[14:14] data[15:15]
X     0:000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
X     1:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
X     2:100000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000
X     3:100100000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000001111
X     4:100000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000001111
X     5:100101000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000011111111
X     6:000001000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000011111111
X     7:000001000000000000000000000000000000000000000000011110000000011111111000000000000000000000000000000000000000011111111
X     8:000100000000000001111000000000000000000000000000011110000000011111111000000000000000000000000000000000110100001001111
X     9:000000000000000001111000000000000000000000000000011110000000011111111000000000000000000000000000000000110100001001111
X    10:000000000000000001111011010000100111110000000000011110000000011111111000000000000000000000000000000000110100001001111
X    11:000100000000000000000011010000100111110000000000011110000000011111111000000000000000000000000000000000110100001001111
X    12:000000000000000000000100001001111000010000000000011110000000011111111011010000100111100000000000000000110100001001111
X    13:000000000000000000000111100000000000010000000000011110000000011111111110100001001111000000000000000000110100001001111
X    14:000000000000000000000000000000000000010000000000011110000000011111111001100001001111000000000000000000110100001001111
X    15:000101000000000001111000000000000000010000000000011110000000011111111001100001001111000000000000000000110100001001111
X    16:000001000000000001111000000000000000010000000000011110000000011111111001100001001111000000000000000001000000001100111
X    17:000001000000000001111100000000110011101000000000011110000000011111111001100001001111000000000000000001000000001100111
X    18:000100000000011111111100000000110011101000000000011110000000011111111001100001001111000000000000000001000000001100111
X    19:000000000000011111111011001110000000001000000000011111111111101111111111111111111111110000100110000101000010011000010
X    20:000101111111111111111011001110000000001000000000011111111111101111111111111111111111110000100110000101000010011000010
X    21:000001111111111111111011100000000000001000000000011111111111101111111101001101110000110000100110000101010011011100001
X    22:000101111111101111111011100000000000001000000000011111111111101111111101001101110000110000100110000101010011011100001
X    23:000001111111101111111000000000000000001000000000011110111111101111111011000010101001100000000000000000000000000000000
X    24:000100100000000001111000000000000000001000000000011110111111101111111011000010101001100000000000000000000000000000000
X    25:000000100000000001111000000000000000001000000000011110111111101111111011000010101001100000000000000000000000000000000
X    26:000000100000000001111000000000000000011000000000011110000000011111111001100001001111000000000000000000000000000000000
X    27:010011000000011111111000000000000000011000000000011110000000011111111001100001001111000000000000000000000000000000000
X    28:010001000000011111111000000000000000011000000000011110000000011111111001100001001111000000000000000000000000000000000
X    29:010010100000011111111000000000000000011000000000011110000000011111111001100001001111000000000000000000011000010011110
X    30:010000100000011111111000000000000000011000000000011110000000011111111001100001001111000000000000000000011000010011110
X    31:010100100000000000000000000000000000011000000000011110000000011111111001100001001111000000000000000000011000010011110
X    32:010000100000000000000000000000000000011000000000011110000000011111111001100001001111000000000000000000011000010011110
X    33:011000100000000000000000000000000000011000000000011110000000011111111001100001001111000000000000000000011000010011110
X    34:000000100000000000000000000000000000011000000000011110000000011111111001100001001111000000000000000000011000010011110
X    35:000100011000010011110000000000000000011000000000011110000000011111111001100001001111000000000000000000011000010011110
X    36:000000011000010011110000000000000000011000000000011110000000011111111001100001001111000000000000000000011000010011110
X    37:000000011000010011110001100001001111010110000100111100100000011111111110000000000111100000000000000000011000010011110
X    38:000000011000010011110000010011110000011000000000011110100000011111111101100001001111000000000000000000011000010011110
X    39:000000011000010011110000000000000000000000000000000000000000000000000000000000000000000000000000000000011000010011110
X    40:000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000010011110
X    41:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000010011110
X    42:000000000000000000000001100001001111010000000000000000000000000000000000000000000000000000000000000000011000010011110
END_OF_FILE
if test 7073 -ne `wc -c <'frisc/frisc.out.gold'`; then
    echo shar: \"'frisc/frisc.out.gold'\" unpacked with wrong size!
fi
# end of 'frisc/frisc.out.gold'
fi
echo shar: End of shell archive.
exit 0


