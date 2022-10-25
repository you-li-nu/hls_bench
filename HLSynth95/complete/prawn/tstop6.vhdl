--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "op6"
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
--        		  variable memexp2
--        working set  :  variable memory1
--        		  variable memory2
--      Control process :
--        the condition of the end of the simulatoin :
--          access twice on address =  10(X"0A")
--
-- (2) Tested Instructions
--      Mainly tested in this vector
--        jmp direct(intra-page/inter-page)/indirect(intra-page/inter-page)
--      tested side-effectly
--        lda direct
--        sta direct
--        cla
--        cma
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
        interrupt           : out       MVL7;
        inta                : in        MVL7
  );
end;

architecture BEHAVIORAL of MEM is
  type   BYTE_MEMORY is array ( integer range <> ) of BIT_VECTOR (7 downto 0);
--
begin
  mem : process
-- START MEMORY CONTENTS
  variable memexp1       : BYTE_MEMORY (0 to 15) := -- expected value
    (
    X"90", X"0F", X"94", X"0A", --0:00:  jmp  (0:0F), jmp  (4:0A),
    X"00", X"06", X"E1", X"E2", --0:04:  00, 00-06,   cla,    cma,
    X"A4", X"08", X"80", X"0A", --0:08:  sta   4:08,  jmp   0:0A,
    X"00", X"00", X"00", X"02"  --0:0C:	 00, 00, 00, 02,
    );
  variable memexp2       : BYTE_MEMORY (0 to 11) := -- expected value
    (
    X"00", X"04", X"0B", X"A0", --4:00:  00, lda 4:0B, sta
    X"05", X"90", X"05", X"00", --4:04:  0:05, jmp (0:05),
    X"FF", X"00", X"01", X"06"  --4:08:  00-FF, 00, 01, 06,
    );
  variable memory1       : BYTE_MEMORY (0 to 15) :=
    (
    X"90", X"0F", X"94", X"0A", --0:00:  jmp  (0:0F), jmp  (4:0A),
    X"00", X"00", X"E1", X"E2", --0:04:  00, 00-06,   cla,    cma,
    X"A4", X"08", X"80", X"0A", --0:08:  sta   4:08,  jmp   0:0A,
    X"00", X"00", X"00", X"02"  --0:0C:	 00, 00, 00, 02,
    );
  variable memory2       : BYTE_MEMORY (0 to 11) :=
    (
    X"00", X"04", X"0B", X"A0", --4:00:  00, lda 4:0B, sta
    X"05", X"90", X"05", X"00", --4:04:  0:05, jmp (0:05),
    X"00", X"00", X"01", X"06"  --4:08:  00-FF, 00, 01, 06,
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
      if (ia >= 16 and ia < 1024) or (ia >= 1036) then
        databus <= HI_IMP_8;
        assert FALSE
          report "Simulation Error : adbus has illegal address when reading."
          severity FAILURE;
      else 
	if (ia < 16) then
	  databus <= Drive (BVtoMVL7V (memory1 (ia)));
	else
	  databus <= Drive (BVtoMVL7V (memory2 (ia - 1024)));
	end if;
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then -- memory write
      wait until write_mem = '0';
      if ia < 16 then
        memory1 (ia) := MVL7VtoBV (Drive (databus));
      elsif ia >= 1024 and ia < 1036 then
        memory2 (ia - 1024) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;

    if (ia = 10) -- X"0A"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
end BEHAVIORAL;
