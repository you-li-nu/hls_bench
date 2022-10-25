--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Vectors to validate some of the arithmetic instructions
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

-- Arithmetic test except for multiply and divide

write to memory

@ 0x40	-- Code

-- Testing adding

cau	r2,r0,1		-- address to store results is in 0x10000

cau	r3,r0,0x1fe5	-- r3 = 0x1fe5adbc = 535145916
cal	r3,r3,0xadbc
cau	r4,r0,0xef67	-- r4 = 0xef6776ff = -278432001
cal	r4,r4,0x76ff

st	0(r2),r3
st	4(r2),r4
inc	r2,8

a	r3,r4		-- r3 = r3 + r4 = 256713915 = 0x0f4d24bb
st	0(r2),r3
inc	r2,4

mfs	r5,s15		-- condition-codes stored in memory = 0x18000000 GT='1', CARRY='1'
st	0(r2),r5
inc	r2,4

-- i: 0x0000decb
cau	r3,r0,0		-- i,r3,r4 = 0x0000decb00000001ffffbcd1
cal	r3,r3,1
cau	r4,r0,0xffff
cal	r4,r4,0xbcd1
cau	r7,r0,0xffff	-- r7,r5,r6 = 0xffffffff324ddeffffffffff
cal	r7,r7,0xffff
cau	r5,r0,0x324d
cal	r5,r5,0xdeff
cau	r6,r0,0xffff
cal	r6,r6,0xffff

a	r6,r4		-- add i,r3,r4+r7,r5,r6 = 0000deca 324ddf01 ffffbcd0 and carry
ae	r5,r3
aei	r7,r7,0xdecb

st	0(r2),r7
st	4(r2),r5
st	8(r2),r6
inc	r2,12

mfs	r5,s15		-- condition-codes stored in memory = 0x18000000 GT='1' and CARRY='1'
st	0(r2),r5
inc	r2,4

cau	r4,r0,0xffff	-- r4=0xffffbcd1 = -17199
cal	r4,r4,0xbcd1

ai	r5,r4,10000	-- r5 = -7199 = 0xffffe3e1
st	0(r2),r5
inc	r2,4

ai	r5,r5,10000	-- r5 = 0x00000af1
st	0(r2),r5
inc	r2,4

ais	r5,15		-- r5 = 0x00000b00
st	0(r2),r5
inc	r2,4

cau	r4,r0,0xffff	-- r4=0xffffbcd1 = -17199
cal	r4,r4,0xbcd1

abs	r5,r4
st	0(r2),r5	-- r5 = abs(r4) = 17199 = 0x0000432f
inc	r2,4

abs	r5,r5
st	0(r2),r5	-- r5 = abs(r5) = 17199 = 0x0000432f
inc	r2,4

onec	r5,r4		-- One's complement = 0x0000432e
st	0(r2),r5
inc	r2,4

twoc	r5,r4		-- Two's complement = 0x0000432f
st	0(r2),r5
inc	r2,4

-- Testing subtraction

cau	r3,r0,0x1fe5	-- r3 = 0x1fe5adbc = 535145916
cal	r3,r3,0xadbc
cau	r4,r0,0xef67	-- r4 = 0xef6776ff = -278432001
cal	r4,r4,0x76ff

st	0(r2),r3
st	4(r2),r4
inc	r2,8

s	r3,r4		-- r3 = r3 - r4 = 813577917 = 0x307e36bd
st	0(r2),r3
inc	r2,4

mfs	r5,s15		-- condition-codes stored in memory = 0x08000000 GT='1'
st	0(r2),r5
inc	r2,4

cau	r8,r0,0		-- r8,r3,r4 = 0x0000decb00000001ffffbcd1
cal	r8,r8,0xdecb
cau	r3,r0,0
cal	r3,r3,1
cau	r4,r0,0xffff
cal	r4,r4,0xbcd1
cau	r7,r0,0xffff	-- r7,r5,r6 = 0xffffffff324ddeffffffffff
cal	r7,r7,0xffff
cau	r5,r0,0x324d
cal	r5,r5,0xdeff
cau	r6,r0,0xffff
cal	r6,r6,0xffff

s	r6,r4		-- sub r8,r3,r4+r7,r5,r6 =  ffff2134 324ddefe 0000432e
se	r5,r3
se	r7,r8

st	0(r2),r7
st	4(r2),r5
st	8(r2),r6
inc	r2,12

mfs	r5,s15		-- condition-codes stored in memory = 0x12000000 LT='1' and CARRY='1'
st	0(r2),r5
inc	r2,4

cau	r3,r0,0x1fe5	-- r3 = 0x1fe5adbc = 535145916
cal	r3,r3,0xadbc
cau	r4,r0,0xef67	-- r4 = 0xef6776ff = -278432001
cal	r4,r4,0x76ff

sf	r3,r4		-- r3 = r4 - r3 = 0xcf81c943 and carry
st	0(r2),r3
inc	r2,4

cau	r4,r0,0xffff	-- r4=0xffffbcd1 = -17199
cal	r4,r4,0xbcd1

sfi	r5,0,r4		-- r5 = 17199 = 0x0000432f
st	0(r2),r5
inc	r2,4

sis	r5,10		-- r5 = 0x00004325
st	0(r2),r5
inc	r2,4

sis	r5,15		-- r5 = 0x00004316
st	0(r2),r5
inc	r2,4

-- Testing comparisons

ais	r2,0

cau	r3,r0,0x1fe5	-- r3 = 0x1fe5adbc = 535145916
cal	r3,r3,0xadbc
cau	r4,r0,0xef67	-- r4 = 0xef6776ff = -278432001
cal	r4,r4,0x76ff
c	r3,r4		-- conditioncodes = 0x08000000 GT
mfs	r7,s15
st	0(r2),r7
inc	r2,4

cal	r3,r0,234
cal	r4,r0,234
c	r3,r4		-- conditioncodes = 0x04000000 EQ
mfs	r7,s15
st	0(r2),r7
inc	r2,4

cal	r3,r0,100
cal	r4,r0,234
c	r3,r4		-- conditioncodes = 0x02000000 LT
mfs	r7,s15
st	0(r2),r7
inc	r2,4

cal	r3,r0,15
cis	r3,10		-- conditioncodes = 0x08000000 GT
mfs	r7,s15
st	0(r2),r7
inc	r2,4

cal	r3,r0,15
cis	r3,15		-- conditioncodes = 0x04000000 EQ
mfs	r7,s15
st	0(r2),r7
inc	r2,4

cal	r3,r0,43000
ci	r3,43001	-- conditioncodes = 0x02000000 LT
mfs	r7,s15
st	0(r2),r7
inc	r2,4

cau	r3,r0,0x1fe5	-- r3 = 0x1fe5adbc = 535145916
cal	r3,r3,0xadbc
cau	r4,r0,0xef67	-- r4 = 0xef6776ff = -278432001
cal	r4,r4,0x76ff
cl	r3,r4		-- conditioncodes = 0x02000000 LT
mfs	r7,s15
st	0(r2),r7
inc	r2,4

cau	r3,r0,0x1fe5	-- r3 = 0x1fe5adbc = 535145916
cal	r3,r3,0xadbc
cau	r4,r0,0xef67	-- r4 = 0xef6776ff = -278432001
cal	r4,r4,0x76ff
cl	r4,r3		-- conditioncodes = 0x08000000 GT
mfs	r7,s15
st	0(r2),r7
inc	r2,4

cau	r3,r0,0xefff
cal	r3,r3,0xffff
cli	r3,0x8000	-- conditioncodes = 0x02000000 LT
mfs	r7,s15
st	0(r2),r7
inc	r2,4

cau	r4,r0,0xef67	-- r4 = 0xef6796ff
cal	r4,r4,0x96ff
exts	r3,r4
st	0(r2),r3	-- r3 = 0xffff96ff
inc	r2,4

wait	0xff

run

compare to memory

@ 0x10000

=0x1f 0xe5 0xad 0xbc
=0xef 0x67 0x76 0xff
=0x0f 0x4d 0x24 0xbb
=0x18 0 0 0
=0 0 0xde 0xca 
=0x32 0x4d 0xdf 0x01
=0xff 0xff 0xbc 0xd0
=0x18 0 0 0
=0xff 0xff 0xe3 0xe1
=0 0 0x0a 0xf1
=0 0 0xb 0
=0 0 0x43 0x2f
=0 0 0x43 0x2f
=0 0 0x43 0x2e
=0 0 0x43 0x2f

=0x1f 0xe5 0xad 0xbc
=0xef 0x67 0x76 0xff
=0x30 0x7e 0x36 0xbd
=0x08 0 0 0
=0xff 0xff 0x21 0x34
=0x32 0x4d 0xde 0xfe
=0 0 0x43 0x2e
=0x12 0 0 0
=0xcf 0x81 0xc9 0x43
=0 0 0x43 0x2f
=0 0 0x43 0x25
=0 0 0x43 0x16

=8 0 0 0
=4 0 0 0
=2 0 0 0
=8 0 0 0
=4 0 0 0
=2 0 0 0
=2 0 0 0
=8 0 0 0
=2 0 0 0
=0xff 0xff 0x96 0xff

quit
