--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	System connection for testing
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
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Alfred B. Thordarson 01 Dec 93    Synopsys
--  Functionality     yes     Alfred B. Thordarson 01 Dec 93    Synopsys
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.rtpc_lib.all;

entity SYSTEM is
	Generic(	CLOCK_CYCLE : time := 1 ns;
			MEM_LATENCY : time := 3 ns;
			ADDRESS_SIZE : Dec := 20 );
end SYSTEM;

architecture SCHEMATIC of SYSTEM is

	signal RWb : Bits1 bus;
	signal CSb : Bits1 bus;
	signal ADDRESS_BUS : Bits(ADDRESS_SIZE-1 downto 0) bus;
	signal DATA_BUS : Bits8 bus;
	signal N_3 : Bits1;
	signal N_2 : Bits1;
	signal N_1 : Bits1;

	component CONTROL
		Generic(	CLOCK_CYCLE : time := 10 ns;
				MEM_LATENCY : time := 100 ns;
				ADDRESS_SIZE : Dec := 24 );
		Port(		CLOCK : InOut Bits1 := '0';
				RESET : Out Bits1 := '1';
				RWb : Out Bits1 bus;
				CSb : Out Bits1 bus := '1';
				ADDRESS : Out Bits(ADDRESS_SIZE-1 downto 0) bus;
				DATA : InOut Bits8 bus;
				WAITING : In Bits1 );
	end component;

	component RTPC
		Generic(	MEM_LATENCY : time := 100 ns;
				ADDRESS_SIZE : Dec := 24 );
		Port(		CLOCK : In Bits1;
				RESET : In Bits1;
				RWb : Out Bits1 bus;
				CSb : Out Bits1 bus := '1';
				ADDRESS : Out Bits(ADDRESS_SIZE-1 downto 0) bus;
				DATA : InOut Bits8 bus;
				WAITING : Out Bits1 );
	end component;

	component MEMORY
		Generic(	ADDRESS_SIZE : Dec := 32 );
		Port(		RWb : In Bits1 bus;
				CSb : In Bits1 bus := '1';
				ADDRESS : In Bits(ADDRESS_SIZE-1 downto 0) bus;
				DATA : InOut Bits8 bus);
	end component;

begin

	c_control:CONTROL
		Generic Map(	CLOCK_CYCLE => CLOCK_CYCLE,
				MEM_LATENCY => MEM_LATENCY,
				ADDRESS_SIZE => ADDRESS_SIZE )
		Port Map(	CLOCK => N_1,
				RESET => N_2,
				RWb => RWb,
				CSb => CSb,
				ADDRESS => ADDRESS_BUS,
				DATA => DATA_BUS,
				WAITING => N_3 );
	c_rtpc:RTPC
		Generic Map(	MEM_LATENCY => MEM_LATENCY,
				ADDRESS_SIZE => ADDRESS_SIZE )
		Port Map(	CLOCK => N_1,
				RESET => N_2,
				RWb => RWb,
				CSb => CSb,
				ADDRESS => ADDRESS_BUS,
				DATA => DATA_BUS,
				WAITING => N_3 );
	c_memory:MEMORY
		Generic Map(	ADDRESS_SIZE => ADDRESS_SIZE )
		Port Map(	RWb => RWb, 
				CSb => CSb,
				ADDRESS => ADDRESS_BUS,
				DATA => DATA_BUS );
end SCHEMATIC;

configuration SYSTEM_CFG of SYSTEM is
	for SCHEMATIC
		for c_control:CONTROL
			use configuration WORK.CONTROL_CFG;
		end for;
		for c_rtpc:RTPC
			use configuration WORK.RTPC_CFG;
		end for;
		for c_memory:MEMORY
			use configuration WORK.MEMORY_CFG;
		end for;
	end for;
end SYSTEM_CFG;
