--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Vectors to validate branching and jump instructions
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

-- Branch and jump test

write to memory

@ 0x40	-- Code

cau	r2,r0,1		-- r2 = address to write results to

-- Testing BALA and BALAX

lis	r3,1		-- write 1 to address r2
st	0(r2),r3
inc	r2,4

lis	r3,2
bala	0x120		-- write 2 to address r2 (absolute ####)

lis	r3,3		-- write 3 to address r2
st	0(r2),r3
inc	r2,4

balax	0x12E		-- write 4,5,6 and 7 to address r2 (absolute ####)
lis	r3,4
nop			-- 4 bytes for slot

lis	r3,8		-- write 8 to address r2
st	0(r2),r3
inc	r2,4

cal	r15,r0,0xe9f5	-- r15 should not be changed by the below instructions

-- Testing JB and JNB

jnb	0,5		-- jump if PermanentZero is 0
	
lis	r3,15		-- error
st	0(r2),r3
inc	r2,4

jb	0,5		-- jump if PermanentZero is 1 - never

lis	r3,9		-- write 9 to address r2
st	0(r2),r3
inc	r2,4

-- Testing BB, BNB, BBR and BNBR

bnb	0,6		-- branch if PermanentZero is 0
	
lis	r3,15		-- error
st	0(r2),r3
inc	r2,4

bb	0,9		-- branch if PermanentZero is 1 - never

lis	r3,10		-- write 10 to address r2
st	0(r2),r3
inc	r2,4

st	0(r2),r15	-- r15 is e9a5
inc	r2,4

cal	r7,r0,0xAE	-- r7 is address of next cal-instruction below (abs ####)
bnbr	0,r7		-- branch if PermanentZero is 0
	
lis	r3,15		-- error
st	0(r2),r3
inc	r2,4

cal	r7,r0,0xC2	-- r7 is address of the instruction after r15 has been stored (abs ####)
bbr	0,r7		-- branch if PermanentZero is 1 - never

lis	r3,11		-- write 11 to address r2
st	0(r2),r3
inc	r2,4

st	0(r2),r15	-- r15 is e9a5
inc	r2,4

-- Testing BBX, BNBX, BBRX and BNBRX

lis	r3,12		-- write 12 to address r2
st	0(r2),r3
bnbx	0,8		-- branch if PermanentZero is 0
inc	r2,4
nop			-- 4 byte slot

lis	r3,15		-- error
st	0(r2),r3
inc	r2,4

lis	r3,13
st	0(r2),r3
bbx	0,11		-- branch if PermanentZero is 1 - never
inc	r2,4
nop			-- 4 byte slot

lis	r3,14		-- write 14 to address r2
st	0(r2),r3
inc	r2,4

st	0(r2),r15	-- r15 is e9f5
inc	r2,4

cal	r7,r0,0x106	-- r7 is address of next cal-instruction below (abs ####)
bnbrx	0,r7		-- branch if PermanentZero is 0
nop
nop			-- 4 byte slot (no instruction found for slot)
	
lis	r3,15		-- error
st	0(r2),r3
inc	r2,4

cal	r7,r0,0x11E	-- r7 is address of the instruction after r15 has been stored (abs ####)
bbrx	0,r7		-- branch if PermanentZero is 1 - never
nop
nop			-- 4 byte slot (no instruction found for slot)

lis	r3,0		-- write 0 to address r2
st	0(r2),r3
inc	r2,4

st	0(r2),r15	-- r15 is e9f5
inc	r2,4

wait	0xff

------------------------------------------------------------------
-- #SUB1 write r3 to address and return
------------------------------------------------------------------

-- Testing BALR

st	0(r2),r3
inc	r2,4

st	0(r2),r15	-- store return address
inc	r2,4

balr	r15,r15


------------------------------------------------------------------
-- #SUB2 write r3,5,6 and 7 to address r2 return with slot
------------------------------------------------------------------

-- Testing BALI, BALIX and BALRX

st	0(r2),r3	-- write r3 to address r2
inc	r2,4

lis	r3,5
bali	r1,15		-- write 5 to address r2 (relative #SUB3#)

balix	r1,20		-- write 6 to address r2 (relative #SUB4#)
lis	r3,6
nop			-- 4 bytes for slot

lis	r3,7		-- write 7 to address r2
st	0(r2),r3
inc	r2,4

st	0(r2),r15	-- store return address

balrx	r15,r15		-- return with slot
inc	r2,4
nop			-- 4 bytes for slot


------------------------------------------------------------------
-- #SUB3 write r3 to address r2 and return
------------------------------------------------------------------

st	0(r2),r3	-- write r3 to address r2
inc	r2,4

st	0(r2),r1	-- store return address
inc	r2,4

balr	r1,r1		-- return


------------------------------------------------------------------
-- #SUB4 write r3 to address r2 and return with slot
------------------------------------------------------------------

st	0(r2),r3	-- write r3 to address r2
inc	r2,4

st	0(r2),r1	-- store return address

balrx	r1,r1		-- return with slot
inc	r2,4
nop			-- 4 bytes for slot

run

compare to memory

@ 0x10000
=0 0 0 1
=0 0 0 2
=0 0 0 0x52
=0 0 0 3
=0 0 0 4
=0 0 0 5
=0 0 1 0x3a
=0 0 0 6
=0 0 1 0x42
=0 0 0 7
=0 0 0 0x62
=0 0 0 8
=0 0 0 9
=0 0 0 10
=0 0 0xe9 0xf5
=0 0 0 11
=0 0 0xe9 0xf5
=0 0 0 12
=0 0 0 13
=0 0 0 14
=0 0 0xe9 0xf5
=0 0 0 0
=0 0 0xe9 0xf5

quit
