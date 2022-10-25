--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Vectors to validate the multiply and divide instructions
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

-- Multiply and divide test

write to memory

@ 0x40	-- Code

cau	r2,r0,1		-- r2 = 0x10000 where a put the results

cal	r3,r0,0xfea9	-- r3 = 0x0000fea9 = 65193

cau	r4,r0,0xffff	-- r4 = 0xffffffff = -1
cal	r4,r4,0xffff

mts	r10,r3		-- store r3 in multiplier quotient
s	r3,r3

m	r3,r4		-- multiply partly 32/2 = 16 times
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4
m	r3,r4

mfs	r5,r10		-- result is -65193 = 0xffffffff0157 = r3 and upper of r5

st	0(r2),r3
st	4(r2),r5
inc	r2,8

-- Divide operation

cal	r3,r0,0xbea9	-- r3 = 0xbea9 = 48809
mts	r10,r3		-- store r3 in multiplier quotient
sari16	r3,15		-- extend sign of r3 throughout r3

cal	r4,r0,0x23	-- r2 = 0x23 = 35

d	r3,r4		-- divide partly 32 times
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4
d	r3,r4

cas	r5,r3,r0	-- check if r3 and r5 are the same sign
x	r5,r4
jnb	1,2

a	r3,r4		-- if not same sign then add
 
mfs	r5,r10		-- result 1394 and remainder 19 = 0x572 [0x13]

st	0(r2),r5
st	4(r2),r3
inc	r2,8

wait	0xff

run

compare to memory

@ 0x10000

=0xff 0xff 0xff 0xff	-- Multiplier upper 32
=0xff 0xff 1 0x57	-- Multiplier lower 32

=0 0 5 0x72		-- Divide results
=0 0 0 0x13		-- Divide remainder

quit
