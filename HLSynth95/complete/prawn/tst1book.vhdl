--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "1book"
--
-- Derived from
--           Parwan : a reduced processor
--           from Chapter 9 of NAVABI : "VHDL: Analysis and Modeling of
--           Digital Systems" MacGraw-Hill,Inc. 1993
--
-- Author: Tadatoshi Ishii
--         Information and Computer Science,
--         University Of California, Irvine, CA 92717
--
-- Developed on Nov 1, 1992
--
--   See (4) of "prawn.doc" for understanding testing strategy.
--
-- (1) Construction of file
--
--      Sets of memories :
--        expected set :  variable memexp1
--                        variable memexp2
--        working set  :  variable memory1
--                        variable memory2
--      Control process :
--        the condition of the end of the simulatoin :
--          access twice on address = 23(X"17")
--
-- (2) Tested Instructions
--      Derived from Figure 9.68 of NAVABI's book p312
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Tadatoshi Ishii      01 Nov 92    Synopsys
--  Functionality     yes     Tadatoshi Ishii	   01 Nov 92    Synopsys
--------------------------------------------------------------------------------

library work;
use work.TYPES.all;
use work.MVL7_functions.all;
use work.LIB.all;

entity MEM is
  port (
        read_mem, write_mem : in	MVL7;
        databus             : inout	WIRED_BYTE := HI_IMP_8;
        adbus               : in	TWELVE;
	interrupt	    : out	MVL7;
	inta		    : in	MVL7
  );
end;

architecture BEHAVIORAL of MEM is
  type	 BYTE_MEMORY is array ( integer range <> ) of BIT_VECTOR (7 downto 0);
--
begin
  mem : process
-- START MEMORY CONTENTS
  variable memexp1      : BYTE_MEMORY (0 to 63) := -- expected value
    (
    X"00", X"18", X"A0", X"19",
    X"20", X"1A", X"40", X"1B",
    X"E2", X"E9", X"60", X"1C",
    X"10", X"1D", X"C0", X"24",
    X"E8", X"E0", X"80", X"20",
    X"A0", X"26", X"80", X"16", --14:sta 0x26, jmp 0x16
    X"0C", X"0C", X"00", X"00",
    X"0C", X"1F", X"00", X"5A",
    X"80", X"14", X"00", X"00",
    X"E2", X"DF", X"4A", X"00", --24:cma, jrt, 4A
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00"
    );
  variable memexp2	: BYTE_MEMORY (0 to 15) :=
    (
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"10", X"00", X"FF"	--F:FF	stack pointer
    );

  variable memory1       : BYTE_MEMORY (0 to 63) :=
    (
    X"00", X"18", X"A0", X"19", --00:lda 0x18, sta 0x19
    X"20", X"1A", X"40", X"1B", --04:and 0x1A, add 0x1B
    X"E2", X"E9", X"60", X"1C", --08:cma, asr, sub 0x1C
    X"10", X"1D", X"C0", X"24", --0C:lda (0x1D),jsr 0x24
    X"E8", X"E0", X"80", X"20", --10:asl, nop, jmp 0x20
    X"A0", X"26", X"80", X"16", --14:sta 0x26, jmp 0x16
    X"0C", X"1F", X"00", X"00", --18:
    X"0C", X"1F", X"00", X"5A", --1C:
    X"80", X"14", X"00", X"00", --20:jmp 0x14,
    X"E2", X"DF", X"00", X"00", --24:cma, jrt,
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00"
    );
  variable memory2	: BYTE_MEMORY (0 to 15) :=
    (
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"FF"	--F:FF	stack pointer
    );
-- END MEMORY CONTENTS
    variable ia, finish         : integer := 0;
  begin
    wait on read_mem, write_mem;
    ia := B2I (adbus);

    if finish = 2 then -- examine simulation results
      assert memexp1 = memory1
	report "Simulation Error : Memory1 has unexpected contents."
	severity FAILURE;
      assert memexp2 = memory2
	report "Simulation Error : Memory2 has unexpected contents."
	severity FAILURE;
      assert finish = 0
        report "Simulation is done successfully." severity ERROR;

    elsif read_mem = '1' then -- memory read
      if (ia >= 64) and (ia < 4080) then
        databus <= HI_IMP_8;
	assert FALSE
	  report "Simulation Error : adbus has illegal address when reading."
	  severity FAILURE;
      else 
	if ia < 64 then
	  databus <= Drive (BVtoMVL7V (memory1 (ia)));
	else
	  databus <= Drive (BVtoMVL7V (memory2 (ia - 4080)));
	end if;
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then -- memory write
      wait until write_mem = '0';
      if ia < 64 then
        memory1 (ia) := MVL7VtoBV (Drive (databus));
      elsif ia >= 4080 then
        memory2 (ia - 4080) := MVL7VtoBV (Drive (databus));
      else 
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;

    if (ia = 23) -- X"17"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
end BEHAVIORAL;

