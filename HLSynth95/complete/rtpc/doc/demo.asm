--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Demo program used in the documentation
--	Subtracts two numbers twice and stores the results
--
-- Derived from
--	ROMP description written in verilog by Edward Czeck et al.
--	Most likely based on the IBM RT-PC Hardware Technical
--	Reference (c) 1985 (for RT PC model 10, 20, and 25)
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

@ 0x40	-- Code

cau	r2,r0,1
l	r2,0(r2)
cau	r3,r0,1
l	r3,4(r3)
s	r2,r3
cau	r3,r0,1
st	8(r3),r2
wait	0xfd

cau	r2,r0,1
l	r2,0x10(r2)
cau	r3,r0,1
l	r3,0x14(r3)
s	r2,r3
cau	r3,r0,1
st	0x18(r3),r2
wait	0xfd

wait	0xff

@ 0x10000

-- Operands A and B and space for result FF FF FF FF
=00 00 00 01
=00 00 00 02
=00 00 00 00

@ 0x10010

-- Operands A and B and space for result 80 00 23 FF
=0x7f 0xff 0xf0 00
=0xff 0xff 0xcc 01
=00 00 00 00

run

compare to memory

@ 0x10008
=0xff,0xff,0xff,0xff
@ 0x10018
=0x80,0,0x23,255

mem 0x10000 0x1001B
