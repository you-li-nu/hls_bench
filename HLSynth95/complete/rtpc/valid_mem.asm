--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Vectors to validate the address and memory instructions
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

-- Calculate address and Load/Store test

write to memory

@ 0x40	-- Code

cau	r1,r0,1		-- r1 = address to load from
cau	r2,r0,2		-- r2 = address to store to 
st	0(r2),r1
st	4(r2),r2
inc	r2,8

lcs	r3,0(r1)	-- move D to 0x20004
stcs	0(r2),r3

lcs	r3,1(r1)	-- move o to 0x20005
stcs	1(r2),r3
inc	r1,2
inc	r2,2

lc	r3,0(r1)	-- move n to 0x20006
stc	0(r2),r3

lc	r3,1(r1)	-- move ' to 0x20007
stc	1(r2),r3
inc	r1,2
inc	r2,2

lhas	r3,0(r1)	-- move "t " to 0x20008
sths	0(r2),r3

lhas	r3,1(r1)	-- move us to 0x2000A
sths	1(r2),r3
inc	r1,4
inc	r2,4

lha	r3,0(r1)	-- move "e " to 0x2000C
sth	0(r2),r3

lha	r3,2(r1)	-- move fo to 0x2000E
sth	2(r2),r3
inc	r1,4
inc	r2,4

lhs	r3,r1		-- move rc to 0x20010
sth	0(r2),r3
inc	r1,2

lhs	r3,r1		-- move "e," to 0x20012
sth	2(r2),r3
inc	r1,2
inc	r2,4

lh	r3,0(r1)	-- move " u" to 0x20014
sth	0(r2),r3

lh	r3,2(r1)	-- move "se" to 0x20016
sth	2(r2),r3
inc	r1,4
inc	r2,4

ls	r3,0(r1)	-- move " a b" to 0x20018
sts	0(r2),r3

ls	r3,1(r1)	-- move "igge" to 0x2001C
sts	1(r2),r3
inc	r1,8
inc	r2,8

l	r3,0(r1)	-- move "r ha" to 0x20020
st	0(r2),r3

l	r3,4(r1)	-- move "mmer" to 0x20024
st	4(r2),r3
inc	r1,8
inc	r2,8

lm	r3,0(r1)	-- move "It's not what you say in your argument, it's how lou" to 0x20028
stm	0(r2),r3

lm	r3,52(r1)	-- move "d you say itDon't let schooling get in the way of yo" to 0x2005C
stm	52(r2),r3

inc	r1,10		-- Increment r1 by 104
inc	r1,10
inc	r1,10
inc	r1,10
inc	r1,10
inc	r1,10
inc	r1,10
inc	r1,10
inc	r1,10
inc	r1,10
inc	r1,4

inc	r2,10		-- Increment r2 by 104
inc	r2,10
inc	r2,10
inc	r2,10
inc	r2,10
inc	r2,10
inc	r2,10
inc	r2,10
inc	r2,10
inc	r2,10
inc	r2,4

tsh	r3,0(r1)	-- move "ur" to 0x20090 marked => u->0xff
sth	0(r2),r3

tsh	r3,2(r1)	-- move " e" to 0x20092 marked => ' '->0xff
sth	2(r2),r3
inc	r2,4

lh	r3,0(r1)	-- move 0xff"r" to 0x0094
sth	0(r2),r3

lh	r3,2(r1)	-- move 0xff"e" to 0x0096
sth	2(r2),r3
inc	r1,4
inc	r2,4

lis	r2,0		-- Address 0x30000 is where the rest of the storing is to go
cau	r2,r2,3

cau	r10,r0,26	-- 0x30000 r10=upper 26 and lower 15
cal	r10,r10,15
st	0(r2),r10
inc	r2,4

cau	r10,r10,3268	-- 0x30004 r10=upper r10+3268 and lower r10+0xef25
cal	r10,r10,0xef25
st	0(r2),r10
inc	r2,4

cas	r10,r10,r10	-- 0x30008 r10=r10+r10=2*r10
st	0(r2),r10
inc	r2,4

lis	r9,8		-- 0x3000C r9=8
st	0(r2),r9
inc	r2,4

lis	r9,5		-- 0x30010 r9=5
st	0(r2),r9
inc	r2,4

cas	r10,r10,r10	-- 0x30014 r10=r10+r10=2*r10
st	0(r2),r10
inc	r2,4

cas	r11,r9,r10	-- 0x30018 r11=r10+r9
st	0(r2),r11
inc	r2,4

cal16	r10,r10,0xcb5d	-- 0x3001C r10=r10+0xcb5d (lower 16 bits)
st	0(r2),r10
inc	r2,4

cal16	r9,r9,0x1fff	-- 0x30020 r9=r9+0x1fff
st	0(r2),r9
inc	r2,4

cal16	r10,r9,0xf015	-- 0x30024 r10=r9+10 (lower 16 bits)
st	0(r2),r10
inc	r2,4

ca16	r9,r10		-- 0x30028 r9=r9+r10 (lower 16 bits)
st	0(r2),r9
inc	r2,4

ca16	r9,r10		-- 0x3002C r9=r9+r10 (lower 16 bits)
st	0(r2),r9
inc	r2,4

ca16	r9,r10		-- 0x30030 r9=r9+r10 (lower 16 bits)
st	0(r2),r9
inc	r2,4

ca16	r9,r9		-- 0x30034 r9=r9+r9 (lower 16 bits)
st	0(r2),r9
inc	r2,4

ca16	r9,r9		-- 0x30038 r9=r9+r9 (lower 16 bits)
st	0(r2),r9
inc	r2,4

lis	r10,5		-- 0x3003C r10=5
st	0(r2),r10
inc	r2,4

dec	r10,2		-- 0x30040 r10=3
st	0(r2),r10
inc	r2,4

dec	r10,2		-- 0x30044 r10=1
st	0(r2),r10
inc	r2,4

dec	r10,2		-- 0x30048 r10=-1
st	0(r2),r10
inc	r2,4

dec	r10,2		-- 0x3004C r10=-3
st	0(r2),r10
inc	r2,4

dec	r10,2		-- 0x30050 r10=-5
st	0(r2),r10
inc	r2,4

wait	0xff

@ 0x10000
"Don't use force, use a bigger hammer"
"It's not what you say in your argument, it's how loud you say it"
"Don't let schooling get in the way of your education"

run

compare to memory

-- Loads and Stores

@ 0x20000
=00 01 00 00
=00 02 00 00
"Don't use force, use a bigger hammer"
"It's not what you say in your argument, it's how loud you say it"
"Don't let schooling get in the way of your e"

=0xff
"r"
=0xff
"e"

-- Calculate addresses

@ 0x30000
=0 26 0 15
=0xc 0xde 0xef 0x34
=0x19 0xbd 0xde 0x68
=0 0 0 8
=0 0 0 5
=0x33 0x7b 0xbc 0xd0
=0x33 0x7b 0xbc 0xd5
=0x33 0x7b 0x88 0x2d
=0 0 0x20 0x04
=0x33 0x7b 0x10 0x19
=0x33 0x7b 0x30 0x1d
=0x33 0x7b 0x40 0x36
=0x33 0x7b 0x50 0x4f
=0x33 0x7b 0xa0 0x9e
=0x33 0x7b 0x41 0x3c

=0 0 0 5
=0 0 0 3
=0 0 0 1
=0xff 0xff 0xff 0xff
=0xff 0xff 0xff 0xfd
=0xff 0xff 0xff 0xfb

quit
