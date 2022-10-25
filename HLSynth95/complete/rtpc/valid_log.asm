--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Vectors to validate the logical operations
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

-- Logical test

write to memory

@ 0x40	-- Code

cau	r2,r0,1		-- Set address to store = 0x10000

-- Testing shifts

lis	r4,13
cau	r3,r0,0xdbf3	-- Set r3 = 0xdbf3d945
cal	r3,r3,0xd945

st	0(r2),r3
inc	r2,4

sar	r3,r4		-- r3 = 0xfffedf9e

st	0(r2),r3
inc	r2,4

cau	r3,r0,0xdbf3	-- Set r3 = 0xdbf3d945
cal	r3,r3,0xd945
sari	r3,15		-- r3 = 0xffffb7e7

st	0(r2),r3
inc	r2,4

cau	r3,r0,0xdbf3	-- Set r3 = 0xdbf3d945
cal	r3,r3,0xd945
sari16	r3,10		-- r3 =0xfffffff6

st	0(r2),r3
inc	r2,4

cau	r3,r0,0xdbf3	-- Set r3 = 0xdbf3d945
cal	r3,r3,0xd945
sr	r3,r4		-- r3 = 0x0006df9e

st	0(r2),r3
inc	r2,4

cau	r3,r0,0xdbf3	-- Set r3 = 0xdbf3d945
cal	r3,r3,0xd945
sri	r3,15		-- r3 = 0x0001b7e7

st	0(r2),r3
inc	r2,4

cau	r3,r0,0xdbf3	-- Set r3 = 0xdbf3d945
cal	r3,r3,0xd945
sri16	r3,10		-- r3 =0x00000036

st	0(r2),r3
inc	r2,4

cau	r7,r0,0xdbf3	-- Set r7 = 0xdbf3d945
cal	r7,r7,0xd945
srp	r7,r4		-- r6 = 0x0006df9e

st	0(r2),r6
inc	r2,4

srpi	r7,15		-- r6 = 0x0001b7e7

st	0(r2),r6
inc	r2,4

srpi16	r7,10		-- r6 =0x00000036

st	0(r2),r6
inc	r2,4

cau	r3,r0,0xdbf3	-- Set r3 = 0xdbf3d945
cal	r3,r3,0xd945
sl	r3,r4		-- r3 = 0x7b28a000

st	0(r2),r3
inc	r2,4

cau	r3,r0,0xdbf3	-- Set r3 = 0xdbf3d945
cal	r3,r3,0xd945
sli	r3,15		-- r3 = 0xeca28000

st	0(r2),r3
inc	r2,4

cau	r3,r0,0xdbf3	-- Set r3 = 0xdbf3d945
cal	r3,r3,0xd945
sli16	r3,10		-- r3 =0x14000000

st	0(r2),r3
inc	r2,4

cau	r7,r0,0xdbf3	-- Set r7 = 0xdbf3d945
cal	r7,r7,0xd945
slp	r7,r4		-- r6 = 0x7b28a000

st	0(r2),r6
inc	r2,4

slpi	r7,15		-- r6 = 0xeca28000

st	0(r2),r6
inc	r2,4

slpi16	r7,10		-- r6 =0x14000000

st	0(r2),r6
inc	r2,4

-- Testing logical operations

cau	r6,r0,0xeff0	-- Set r6 = 0xeff0459d
cal	r6,r6,0x459d
cau	r7,r0,0xdbf3	-- Set r7 = 0xdbf3d945
cal	r7,r7,0xd945

st	0(r2),r6
st	4(r2),r7
inc	r2,8

clrbl	r6,7		-- r6 changes to 0xeff0448d
clrbl	r6,11	

st	0(r2),r6
inc	r2,4

clrbu	r6,0		-- r6 changes to 0x4ff0448d
clrbu	r6,2

st	0(r2),r6
inc	r2,4

setbl	r6,7		-- r6 changes back to 0x4ff0459d
setbl	r6,11	

st	0(r2),r6
inc	r2,4

setbu	r6,0		-- r6 changes back to 0xeff0459d
setbu	r6,2

st	0(r2),r6
inc	r2,4

n	r6,r7		-- r6 = r6 and r7 = 0xcbf04105
st	0(r2),r6
inc	r2,4

cau	r6,r0,0xeff0	-- Set r6 = 0xeff0459d
cal	r6,r6,0x459d
nilz	r8,r6,0xaaaa	-- r8 = r6 and 0x0000aaaa = 0x00000088 
st	0(r2),r8
inc	r2,4

nilo	r8,r6,0xaaaa	-- r8 = r6 and 0xffffaaaa = 0xeff00088 
st	0(r2),r8
inc	r2,4

niuz	r8,r6,0xaaaa	-- r8 = r6 and 0xaaaa0000 = 0xaaa00000
st	0(r2),r8
inc	r2,4

niuo	r8,r6,0xaaaa	-- r8 = r6 and 0xaaaaffff = 0xaaa0459d
st	0(r2),r8
inc	r2,4

o	r6,r7		-- r6 = r6 or r7 = 0xfff3dddd
st	0(r2),r6
inc	r2,4

cau	r6,r0,0xeff0	-- Set r6 = 0xeff0459d
cal	r6,r6,0x459d
oiu	r8,r6,0xd653	-- r8 = r6 or 0xd6530000 = 0xfff3459d
st	0(r2),r8
inc	r2,4

oil	r8,r6,0x1a99	-- r8 = r6 or 0x00001a99 = 0xeff05f9d
st	0(r2),r8
inc	r2,4

x	r6,r7		-- r6 = r6 xor r7 = 0x34039cd8
st	0(r2),r6
inc	r2,4

cau	r6,r0,0xeff0	-- Set r6 = 0xeff0459d
cal	r6,r6,0x459d
xiu	r8,r6,0xd653	-- r8 = r6 xor 0xd6530000 = 0x39a3459d
st	0(r2),r8
inc	r2,4

xil	r8,r6,0x1a99	-- r8 = r6 xor 0x00001a99 = eff05f04
st	0(r2),r8
inc	r2,4

clz	r8,r6		-- r8 = leading zeros of r6 = 0
st	0(r2),r8
inc	r2,4

clz	r8,r7		-- r8 = leading zeros of r7 = 0
st	0(r2),r8
inc	r2,4

cal	r7,r0,35		-- r8 = leading zeros of 0x00000023 = 26
clz	r8,r7
st	0(r2),r8
inc	r2,4

wait	0xff

run

compare to memory

@ 0x10000

=0xdb 0xf3 0xd9 0x45
=0xff 0xfe 0xdf 0x9e
=0xff 0xff 0xb7 0xe7
=0xff 0xff 0xff 0xf6
=0 6 0xdf 0x9e
=0 1 0xb7 0xe7
=0 0 0 0x36
=0 6 0xdf 0x9e
=0 1 0xb7 0xe7
=0 0 0 0x36
=0x7b 0x28 0xa0 0
=0xec 0xa2 0x80 0
=0x14 0 0 0
=0x7b 0x28 0xa0 0
=0xec 0xa2 0x80 0
=0x14 0 0 0

=0xef 0xf0 0x45 0x9d
=0xdb 0xf3 0xd9 0x45
=0xef 0xf0 0x44 0x8d
=0x4f 0xf0 0x44 0x8d
=0x4f 0xf0 0x45 0x9d
=0xef 0xf0 0x45 0x9d

=0xcb 0xf0 0x41 0x05
=0 0 0 0x88 
=0xef 0xf0 0 0x88 
=0xaa 0xa0 0 0
=0xaa 0xa0 0x45 0x9d

=0xff 0xf3 0xdd 0xdd
=0xff 0xf3 0x45 0x9d
=0xef 0xf0 0x5f 0x9d

=0x34 3 0x9c 0xd8
=0x39 0xa3 0x45 0x9d
=0xef 0xf0 0x5f 4

=0 0 0 0
=0 0 0 0
=0 0 0 26

quit
