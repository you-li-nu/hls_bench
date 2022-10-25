--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "2book"
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
--          access twice on address = 48(X"30")
--
-- (2) Tested Instructions
--      Derived from Figure 9.10 of NAVABI's book p267
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
  type   BYTE_MEMORY is array ( integer range <> ) of BIT_VECTOR (7 downto 0);
--
begin
  mem : process
-- START MEMORY CONTENTS
  variable memexp1       : BYTE_MEMORY (0 to 63) := -- expected value
    (
    X"80", X"15", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"E1", X"E8", X"54",
    X"00", X"A4", X"03", X"04",
    X"00", X"44", X"02", X"A4",
    X"00", X"04", X"01", X"64",
    X"02", X"F2", X"2D", X"A4",
    X"01", X"04", X"03", X"80",
    X"17", X"A4", X"04", X"80",
    X"2F", X"E0", X"E0", X"E0",
    X"E0", X"E0", X"E0", X"E0",
    X"E0", X"E0", X"E0", X"E0",
    X"E0", X"E0", X"E0", X"E0"
    );
  variable memexp2       : BYTE_MEMORY (0 to 63) := -- expected value
    (
    X"35", X"01", X"01", X"37",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"01", X"02", X"03",
    X"04", X"05", X"06", X"07",
    X"08", X"09", X"0A", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00"
    );
  variable memory1       : BYTE_MEMORY (0 to 63) :=
    (
    X"80", X"15", X"00", X"00", --0:00:  jmp  0:15 ,
    X"00", X"00", X"00", X"00", --0:04:
    X"00", X"00", X"00", X"00", --0:08:
    X"00", X"00", X"00", X"00", --0:0C:
    X"00", X"00", X"00", X"00", --0:10:
    X"00", X"E1", X"E8", X"54", --0:14:       , cla , asl , add
    X"00", X"A4", X"03", X"04", --0:18: (4:00), sta  4:03 , lda
    X"00", X"44", X"02", X"A4", --0:1C:  4:00 , add  4:02 , sta
    X"00", X"04", X"01", X"64", --0:20:  4:00 , lda  4:01 , sub
    X"02", X"F2", X"2D", X"A4", --0:24:  4:02 , brz   :2D , sta
    X"01", X"04", X"03", X"80", --0:28:  4:01 , lda  4:03 , jmp
    X"17", X"A4", X"04", X"80", --0:2C:  0:17 , sta ,4:04 , jmp
    X"2F", X"E0", X"E0", X"E0", --0:30:  0:2F , nop , nop , nop
    X"E0", X"E0", X"E0", X"E0", --0:34:   nop , nop , nop , nop
    X"E0", X"E0", X"E0", X"E0", --0:38:   nop , nop , nop , nop
    X"E0", X"E0", X"E0", X"E0"  --0:3C:   nop , nop , nop , nop
    );
  variable memory2       : BYTE_MEMORY (0 to 63) :=
    (
    X"25", X"10", X"01", X"00", --4:00: 25, 10,  1,   00,
    X"FF", X"00", X"00", X"00", --4:04: FF - 00,
    X"00", X"00", X"00", X"00", --4:08:
    X"00", X"00", X"00", X"00", --4:0C:
    X"00", X"00", X"00", X"00", --4:10:
    X"00", X"00", X"00", X"00", --4:14:
    X"00", X"00", X"00", X"00", --4:18:
    X"00", X"00", X"00", X"00", --4:1C:
    X"00", X"00", X"00", X"00", --4:20:
    X"00", X"01", X"02", X"03", --4:24:   ,  1,  2,  3,
    X"04", X"05", X"06", X"07", --4:28:  4,  5,  6,  7,
    X"08", X"09", X"0A", X"00", --4:2C:  8,  9,  A,   ,
    X"00", X"00", X"00", X"00", --4:30:
    X"00", X"00", X"00", X"00", --4:34:
    X"00", X"00", X"00", X"00", --4:38:
    X"00", X"00", X"00", X"00"  --4:3C:
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
      if (ia >= 64 and ia < 1024) or (ia >= 1088) then
        databus <= HI_IMP_8;
        assert FALSE
          report "Simulation Error : adbus has illegal address when reading."
          severity FAILURE;
      else 
	if (ia < 64) then
	  databus <= Drive (BVtoMVL7V (memory1 (ia)));
	else
	  databus <= Drive (BVtoMVL7V (memory2 (ia - 1024)));
	end if;
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then -- memory write
      wait until write_mem = '0';
      if ia < 64 then
        memory1 (ia) := MVL7VtoBV (Drive (databus));
      elsif ia >= 1024 and ia < 1088 then
        memory2 (ia - 1024) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;

    if (ia = 48) -- X"30"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
end BEHAVIORAL;
