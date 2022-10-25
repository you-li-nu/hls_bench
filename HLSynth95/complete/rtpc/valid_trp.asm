--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Vectors to validate the trap instructions
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

-- Trap test (a very short one)

write to memory

@ 0x40	-- Code

cal	r2,r0,123		-- r2 and r3 are equal

cal	r3,r0,125
tgte	r2,r3		-- Trap if GreaterThan

cal	r3,r0,123
tlt	r2,r3		-- Trap if LessThan

ti	1,r2,123		-- Trap if r2>123
ti	4,r2,123		-- Trap if r2<123
ti	3,r2,123		-- Trap if r2>=123 -> TRAP / PROGRAM STOPS

run

quit
