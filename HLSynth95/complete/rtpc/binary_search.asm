--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Test program - Binary Search
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

l	r11,0(r10)	-- R11 = Address of last byte of string to search in
a	r11,r10
ais	r11,7

l	r12,4(r10)	-- R12 = Byte to search for

inc	r10,8		-- R10 incremented => R10 = start of string = 0x10004

bala	0x1000		-- Branch to Binary Search

wait	0x89		-- Print out address of byte or zero if not found
wait	0xff		-- Program done

--------------------------------------------------------------------------------
-- Binary Search - Algorithm
-- =============
-- Arguments: R10 = Address of first byte in string to search
--            R11 = Address of last byte in string to search
--            R12 = Byte to search for
-- Uses:      R13 = Middle byte
--            R14 = Byte being checked
--            R9  = 0/Address of place where found
--------------------------------------------------------------------------------
@ 0x1000
cas	r13,r10,r11	-- Calculate middle address
sri	r13,1

lcs	r14,0(r13)	-- Load byte

c	r14,r12
bb	10,+20		-- If EqualTo jump
bb	11,+10		-- If GreaterThan jump

-- LessThan
c	r10,r11		-- If NotFound then jump there
bnb	9,+18

ai	r10,r13,0
ais	r10,1
bnb	8,-14		-- Recursive jump

-- GreaterThan
c	r10,r11		-- If NotFound then jump there
bnb	9,+7

ai	r11,r13,0
sis	r11,1
bnb	8,-22		-- Recursive jump

-- EqualTo
ai	r9,r13,0
balr	r15,r15		-- Return

-- NotFound
cal	r9,r0,0
balr	r15,r15		-- Return

@ 0x10000
=0 0 0 20	-- String Length
=0 0 0 169	-- Byte to search for
=12 26 39 45 51 63 78 85 92 98 111 126 132 149 158 169 170 172 183 246
run
mem 0x10000 0x1001e

quit