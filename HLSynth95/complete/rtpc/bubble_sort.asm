--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Test program - Bubble Sort
--
-- Authors:
--	Alfred B. Thordarson (abth@ece.uci.edu)
--	and
--	Nikil Dutt, professor of CS and ECE
--	University Of California, Irvine, CA 92717
--
-- Changes:
--	Dec 1, 1993: File created by Alfred B. Thordarson
--
--------------------------------------------------------------------------------

write to memory
@ 0x40

cau	r10,r0,1	-- R10 = 0x10000
cal	r10,r10,0

l	r11,0(r10)	-- R11 = Length of string (stored in 0x10000)
inc	r10,4		-- R10 incremented => R10 = start of string = 0x10004

bala	0x1000		-- Branch to Bubble-sort

wait	0xff		-- Program done

--------------------------------------------------------------------------------
-- Bubble Sort - Algorithm
-- ===========
-- Arguments: R10 = Address of string to sort
--            R11 = Number of bytes in string
-- Uses:      R12 = Loop variable 1
--            R13 = Loop variable 2
--            R14 = Address of byte to compare to byte at R14-1
--            R8  = Byte one to compare
--            R9  = Byte two to compare
--------------------------------------------------------------------------------
@ 0x1000
cal	r12,r0,0	-- Loop1 initialate = 0

cas	r14,r10,r0	-- Address of byte to compare = Address of last byte of string
a	r14,r11
sis	r14,1

cas	r13,r11,r0	-- Loop2 initialate = Length - 1
dec	r13,1

lcs	r8,0(r14)	-- Load two bytes to be compared
sis	r14,1
lcs	r9,0(r14)

c	r8,r9		-- Switch if r8<r9
bb	11,+4		-- CC 11 is GreaterThan

stcs	0(r14),r8	-- Store them switched
stcs	1(r14),r9

sis	r13,1		-- Jump Loop2
c	r13,r12		-- Jump if LoopVariable GreaterThan OuterLoopVariable
bb	11,-10		-- CC 11 is GreaterThan

ais	r12,1		-- Jump Loop1 (cc 11 is GreaterThan)
c	r12,r11		-- Jump if LoopVariable LessThan StringLength
bb	9,-19		-- CC 9 is LessThan

balr	r15,r15		-- Return

@ 0x10000
=0 0 0 1a
"Your lucky color has faded."
run
mem 0x10000 0x1001e

@ 0x10000
=0 0 0 0x20
"It's an IBM; it's got an excuse."
run
mem 0x10000 0x10024

quit