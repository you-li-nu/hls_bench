--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Vectors to validate move and insert instructions
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

-- Moving and inserting test

write to memory

@ 0x40	-- Code

cau	r2,r0,1		-- set store address to 0x10000

-- Testing move-instructions

cau	r1,r0,0xfe93	-- set r1 to 0xfe93a034
cal	r1,r1,0xa034

cau	r3,r0,0	-- clear r3

st	0(r2),r1
st	4(r2),r3
inc	r2,8

mc03	r3,r1

st	0(r2),r1
st	4(r2),r3
inc	r2,8

mc13	r3,r1

st	0(r2),r1
st	4(r2),r3
inc	r2,8

mc23	r3,r1

st	0(r2),r1
st	4(r2),r3
inc	r2,8

mc33	r3,r1

st	0(r2),r1
st	4(r2),r3
inc	r2,8

mc30	r3,r1

st	0(r2),r1
st	4(r2),r3
inc	r2,8

mc31	r3,r1

st	0(r2),r1
st	4(r2),r3
inc	r2,8

mc32	r3,r1

st	0(r2),r1
st	4(r2),r3
inc	r2,8

-- Testing insert-test_bit-instructions
 
cau	r3,r0,0xffff	-- Set all bits in r3
cal	r3,r3,0xffff

st	0(r2),r3
inc	r2,4

lis	r4,10
mftb	r3,r4		-- Set bit 10 of r3 = test_bit=0

lis	r4,12
mftb	r3,r4		-- Set bit 12 of r3 = test_bit=0

st	0(r2),r3
inc	r2,4

mftbil	r3,3		-- Set bit 3 of lower-half = test_bit=0
mftbil	r3,7		-- Set bit 7 of lower-half = test_bit=0

st	0(r2),r3
inc	r2,4

mftbiu	r3,3		-- Set bit 3 of upper-half = test_bit=0
mftbiu	r3,7		-- Set bit 7 of upper-half = test_bit=0

st	0(r2),r3
inc	r2,4

mfs	r6,s15		-- Get condition-codes into r6
st	0(r2),r6	-- Store them at address r2
inc	r2,4

lis	r4,0
mttb	r3,r4

mfs	r6,s15		-- Get condition-codes into r6
st	0(r2),r6	-- Store them at address r2
inc	r2,4

lis	r4,12
mttb	r3,r4

mfs	r6,s15		-- Get condition-codes into r6
st	0(r2),r6	-- Store them at address r2
inc	r2,4

mttbil	r3,2

mfs	r6,s15		-- Get condition-codes into r6
st	0(r2),r6	-- Store them at address r2
inc	r2,4

mttbil	r3,3

mfs	r6,s15		-- Get condition-codes into r6
st	0(r2),r6	-- Store them at address r2
inc	r2,4

mttbil	r3,5

mfs	r6,s15		-- Get condition-codes into r6
st	0(r2),r6	-- Store them at address r2
inc	r2,4

mttbil	r3,7

mfs	r6,s15		-- Get condition-codes into r6
st	0(r2),r6	-- Store them at address r2
inc	r2,4

wait	0xff

run

compare to memory

@ 0x10000

=0xfe 0x93 0xa0 0x34
=0 0 0 0
=0xfe 0x93 0xa0 0x34
=0x34 0 0 0
=0xfe 0x93 0xa0 0x34
=0x34 0x34 0 0
=0xfe 0x93 0xa0 0x34
=0x34 0x34 0x34 0
=0xfe 0x93 0xa0 0x34
=0x34 0x34 0x34 0x34

=0xfe 0x93 0xa0 0x34
=0x34 0x34 0x34 0xfe

=0xfe 0x93 0xa0 0x34
=0x34 0x34 0x34 0x93

=0xfe 0x93 0xa0 0x34
=0x34 0x34 0x34 0xa0

=0xff 0xff 0xff 0xff
=0xff 0xd7 0xff 0xff

=0xff 0xd7 0xee 0xff
=0xee 0xd7 0xee 0xff

=0 0 0 0
=0x80 0 0 0
=0 0 0 0
=0x80 0 0 0
=0 0 0 0
=0x80 0 0 0
=0 0 0 0

quit
