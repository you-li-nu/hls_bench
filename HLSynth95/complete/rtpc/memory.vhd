--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Memory block for testing
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

use STD.textio.all;
library IEEE;
use IEEE.std_logic_1164.all;
use WORK.rtpc_lib.all;

entity MEMORY is
	Generic(	ADDRESS_SIZE : Dec := 32 );
	Port(		RWb : In Bits1 bus;
			CSb : In Bits1 bus := '1';
			ADDRESS : In Bits(ADDRESS_SIZE-1 downto 0) bus;
			DATA : InOut Bits8 bus);
end MEMORY;

architecture BEHAVIORAL of MEMORY is
	type data_memory is array (natural range <>) of Bits8;
begin
	process(CSb)
		variable mem : data_memory (2**ADDRESS_SIZE-1 downto 0);
	begin
		if falling_edge(CSb) then
			if (RWb='1') then
				DATA <= Mem(b2d(ADDRESS));
			else
				Mem(b2d(ADDRESS)) := DATA;
			end if;
		else
			DATA <= null;
		end if;
	end process;
end BEHAVIORAL;

configuration MEMORY_CFG of MEMORY is
	for BEHAVIORAL
	end for;
end MEMORY_CFG;
