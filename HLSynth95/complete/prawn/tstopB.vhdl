--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "opB"
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
--          access twice on address =  121(X"79") (illegal condition)
--                          address =  125(X"7D") (legal condition)
--
-- (2) Tested Instructions
--        lda indirect
--        sta indirect
--      tested side-effectly
--        bra_n
--        bra_z
--        bra_c
--        bra_v
--        jmp direct
--        nop
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
  type	 BYTE_MEMORY is array ( integer range <> ) of BIT_VECTOR (7 downto 0);
--
begin
  mem : process
-- START MEMORY CONTENTS
  variable memexp1       : BYTE_MEMORY (0 to 143) := -- expected value
    (
    X"10", X"80", X"F2", X"78",
    X"F0", X"08", X"80", X"78",
    X"B0", X"81", X"10", X"82",
    X"F2", X"78", X"F0", X"78",
    X"E0", X"E0", X"B0", X"83",
    X"10", X"84", X"F2", X"1A",
    X"80", X"78", X"F0", X"78",
    X"B0", X"85", X"50", X"86",
    X"10", X"87", X"F2", X"78",
    X"F0", X"28", X"80", X"78",
    X"B0", X"88", X"80", X"40",
    X"E0", X"E0", X"E0", X"E0",
    X"A5", X"5A", X"00", X"FF",
    X"00", X"00", X"00", X"00",
    X"FF", X"FF", X"FF", X"00",
    X"A5", X"5A", X"00", X"FF",
    X"1F", X"E0", X"F2", X"78",
    X"F0", X"48", X"80", X"78",
    X"BF", X"E1", X"1F", X"E2",
    X"F2", X"78", X"F0", X"78",
    X"E0", X"E0", X"BF", X"E3",
    X"1F", X"E4", X"F2", X"5A",
    X"80", X"78", X"F0", X"78",
    X"BF", X"E5", X"1F", X"E6",
    X"F2", X"78", X"F0", X"66",
    X"80", X"78", X"BF", X"E7",
    X"F2", X"78", X"F8", X"78",
    X"F4", X"78", X"F0", X"7A",
    X"80", X"78", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"80", X"78", X"A0", X"7F", --0:78:   jmp   0:78,   sta   0:7F,
    X"80", X"7C", X"FF", X"FF", --0:7C:   jmp   0:7C,    FF,    00,
    X"30", X"3C", X"31", X"3D",
    X"32", X"3E", X"34", X"33",
    X"3F", X"3C", X"00", X"00",
    X"00", X"00", X"00", X"00"
    );
  variable memexp2       : BYTE_MEMORY (0 to 63) := -- expected value
    (
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"A5", X"5A", X"00", X"FF",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"CC", X"F0", X"CD", X"F1",
    X"CE", X"F2", X"CF", X"F3",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"A5", X"5A", X"00", X"FF",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00"
    );
  variable memory1       : BYTE_MEMORY (0 to 143) :=
    (
    X"10", X"80", X"F2", X"78", --0:00:   lda (0:80),   bra_z   78,
    X"F0", X"08", X"80", X"78", --0:04:   bra_n   08,   jmp   0:78,
    X"B0", X"81", X"10", X"82", --0:08:   sta (0:81),   lda (0:82),
    X"F2", X"78", X"F0", X"78", --0:0C:   bra_z   78,   bra_n   78,
    X"E0", X"E0", X"B0", X"83", --0:10:   nop,   nop,   sta (0:83),
    X"10", X"84", X"F2", X"1A", --0:14:   lda (0:84),   bra_z   1A,
    X"80", X"78", X"F0", X"78", --0:18:   jmp   0:78,   bra_n   78,
    X"B0", X"85", X"50", X"86", --0:1C:   sta (0:85),   add (0:86),
    X"10", X"87", X"F2", X"78", --0:20:   lda (0:87),   bra_z   78,
    X"F0", X"28", X"80", X"78", --0:24:   bra_n   28,   jmp   0:78,
    X"B0", X"88", X"80", X"40", --0:28:   sta (0:88),   jmp   0:40,
    X"E0", X"E0", X"E0", X"E0", --0:2C:   nop,   nop,   nop,   nop,
    X"A5", X"5A", X"00", X"FF", --0:30:    A5,    5A,    00,    FF,
    X"00", X"00", X"00", X"00", --0:34:    00,    00,    00,    00,
    X"FF", X"FF", X"FF", X"00", --0:38:    FF,    FF,    FF,    00,
    X"FF", X"FF", X"FF", X"00", --0:3C:    FF,    FF,    FF,    00,
    X"1F", X"E0", X"F2", X"78", --0:40:   lda (F:E0),   bra_z   78,
    X"F0", X"48", X"80", X"78", --0:44:   bra_n   48,   jmp   0:78,
    X"BF", X"E1", X"1F", X"E2", --0:48:   sta (F:E1),   lda (F:E2),
    X"F2", X"78", X"F0", X"78", --0:4C:   bra_z   78,   bra_n   78,
    X"E0", X"E0", X"BF", X"E3", --0:50:   nop,   nop,   sta (F:E3),
    X"1F", X"E4", X"F2", X"5A", --0:54:   lda (F:E4),   bra_z   5A,
    X"80", X"78", X"F0", X"78", --0:58:   jmp   0:78,   bra_n   78,
    X"BF", X"E5", X"1F", X"E6", --0:5C:   sta (F:E5),   lda (F:E6),
    X"F2", X"78", X"F0", X"66", --0:60:   bra_z   78,   bra_n   66,
    X"80", X"78", X"BF", X"E7", --0:64:   jmp   0:78,   sta (F:E7),
    X"F2", X"78", X"F8", X"78", --0:68:   bra_z   78,   bra_v   78,
    X"F4", X"78", X"F0", X"7A", --0:6C:   bra_c   78,   bra_n   7A,
    X"80", X"78", X"00", X"00", --0:70:   jmp   0:78,    00,    00,
    X"00", X"00", X"00", X"00", --0:74:    00,    00,    00,    00,
    X"80", X"78", X"A0", X"7F", --0:78:   jmp   0:78,   sta   0:7F,
    X"80", X"7C", X"FF", X"00", --0:7C:   jmp   0:7C,    FF,    00,
    X"30", X"3C", X"31", X"3D", --0:80:
    X"32", X"3E", X"34", X"33", --0:84:
    X"3F", X"3C", X"00", X"00", --0:88:
    X"00", X"00", X"00", X"00"  --0:8C:
    );
  variable memory2       : BYTE_MEMORY (0 to 63) :=
    (
    X"00", X"00", X"00", X"00", --F:C0:
    X"00", X"00", X"00", X"00", --F:C4:
    X"00", X"00", X"00", X"00", --F:C8:
    X"A5", X"5A", X"00", X"FF", --F:CC:    A5,    5A,    00,    FF,
    X"00", X"00", X"00", X"00", --F:D0:
    X"00", X"00", X"00", X"00", --F:D4:
    X"00", X"00", X"00", X"00", --F:D8:
    X"00", X"00", X"00", X"00", --F:DC:
    X"CC", X"F0", X"CD", X"F1", --F:E0:
    X"CE", X"F2", X"CF", X"F3", --F:E4:
    X"00", X"00", X"00", X"00", --F:E8:
    X"00", X"00", X"00", X"00", --F:EC:
    X"FF", X"FF", X"FF", X"00", --F:F0:    FF,    FF,    FF,    00,
    X"00", X"00", X"00", X"00", --F:F4:
    X"00", X"00", X"00", X"00", --F:F8:
    X"00", X"00", X"00", X"00"  --F:FC:
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
      if (ia >= 144 and ia < 4032) then
        databus <= HI_IMP_8;
        assert FALSE
          report "Simulation Error : adbus has illegal address when reading."
          severity FAILURE;
      else 
	if (ia < 144) then
	  databus <= Drive (BVtoMVL7V (memory1 (ia)));
	else
	  databus <= Drive (BVtoMVL7V (memory2 (ia - 4032)));
	end if;
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then
      wait until write_mem = '0';
      if ia < 144 then
        memory1 (ia) := MVL7VtoBV (Drive (databus));
      elsif ia >= 4032 then
        memory2 (ia - 4032) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;
    
    if (ia = 121) or -- X"79"
       (ia = 125)    -- X"7D"
    then -- stop simulation if these address are found twice
      finish := finish +1;
    end if;
  end process mem;
end BEHAVIORAL;
