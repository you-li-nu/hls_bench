--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "op3"
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
--          access twice on address =  121(X"0:79") (illegal condition)
--                          address = 1301(X"5:15") (legal condition)
--
-- (2) Tested Instructions
--      Mainly tested in this vector
--        and direct/indirect
--      tested side-effectly
--        lda direct
--        sta direct
--        bra_n
--        bra_z
--        bra_c
--        bra_v
--        jmp direct
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
  variable memexp1       : BYTE_MEMORY (0 to 127) := -- expected value
    (
    X"05", X"0C",	--0:00	lda	5:0C,		FF-
    X"20", X"71",	--0:02	and     0:71,		00-
    X"A0", X"73",	--0:04	sta	0:73,		00
    X"F0", X"78",	--0:06	bra_n	78,
    X"F2", X"0C",	--0:08	bra_z	0C,
    X"80", X"78",	--0:0A	jmp	0:78,
    X"F4", X"78",	--0:0C	bra_c	78,
    X"F8", X"78",	--0:0E	bra_v   78,

    X"20", X"70",	--0:10	and	0:70,		FF-
    X"A0", X"74",	--0:12	sta	0:74,		00
    X"F0", X"78",	--0:14	bra_n	78,
    X"F2", X"1A",	--0:16	bra_z	1A,
    X"80", X"78",	--0:18	jmp	0:78,
    X"F4", X"78",	--0:1A	bra_c	78,
    X"F8", X"78",	--0:1C	bra_v   78,

    X"00", X"60",	--0:1E	lda	0:60,		A5-
    X"35", X"01",	--0:20	and	(5:01),		5A-@09
    X"A0", X"75",	--0:22	sta	0:75,		00
    X"F0", X"78",	--0:24	bra_n	78,
    X"F2", X"2A",	--0:26	bra_z	2A,
    X"80", X"78",	--0:28	jmp	0:78,
    X"F4", X"78",	--0:2A	bra_c	78,
    X"F8", X"78",	--0:2C	bra_v   78,

    X"05", X"0E",	--0:2E	lda	5:0E,		80-
    X"E8",		--0:30	asl
    X"E0",		--0:31	nop
    X"00", X"61",	--0:32	lda	0:61,		5A-
    X"35", X"01",	--0:34	and	(5:01),		5A-@09
    X"A0", X"76",	--0:36	sta	0:76,		5A
    X"F0", X"78",	--0:38	bra_n	78,
    X"F2", X"78",	--0:3A	bra_z	78,
    X"F4", X"40",	--0:3C	bra_c	40,
    X"80", X"78",	--0:3E	jmp	0:78,
    X"F8", X"44",	--0:40	bra_v   44,
    X"80", X"78",	--0:42	jmp	0:78,

    X"00", X"60",	--0:44	lda	0:60,		A5-
    X"35", X"00",	--0:46	and	(5:00),		A5-@08
    X"A0", X"77",	--0:48	sta	0:77,		A5
    X"F0", X"4E",	--0:4A	bra_n	4E,
    X"80", X"78",	--0:4C	jmp	0:78,
    X"F2", X"78",	--0:4E	bra_z	78,
    X"F4", X"54",	--0:50	bra_c	54,
    X"80", X"78",	--0:52	jmp	0:78,
    X"F8", X"58",	--0:54	bra_v   58,
    X"80", X"78",	--0:56	jmp	0:78,
    X"85", X"04",	--0:58	jmp	5:04,

    X"00", X"00", --0:5A
    X"00", X"00", X"00", X"00", --0:5C
    X"A5", X"5A", X"00", X"00", --0:60	A5, 5A,
    X"00", X"00", X"00", X"00", --0:64
    X"00", X"00", X"00", X"00", --0:68
    X"00", X"00", X"00", X"00", --0:6C

    X"FF", X"00", X"80", X"00", --0:70	FF, 00, 80, FF,		FF, 00, 80, 00,
    X"00", X"00", X"5A", X"A5", --0:74	FF, FF, A5, 5A,		00, 00, 5A, A5,
    X"80", X"78",	--0:78	jmp	0:78
    X"00", X"00",	--0:7A
    X"00", X"00", X"00", X"00"	--0:7C
    );
  variable memexp2       : BYTE_MEMORY (0 to 23) := -- expected value
    (
    X"08", X"09", X"00", X"00", --5:00	A5-@08, 5A-@09,
    X"85", X"10",	--5:04	jmp	5:10
    X"00", X"00",	--5:06
    X"A5", X"5A", X"00", X"00", --5:08	A5, 5A,
    X"FF", X"00", X"80", X"00",	--5:0C
    X"05", X"0C", X"A5", X"17", --5:10	lda 5:0C, sta 5:17,
    X"85", X"14", X"00", X"FF"  --5:14  jmp 5:14
    );
  variable memory1       : BYTE_MEMORY (0 to 127) :=
    (
    X"05", X"0C",	--0:00	lda	5:0C,		FF-
    X"20", X"71",	--0:02	and     0:71,		00-
    X"A0", X"73",	--0:04	sta	0:73,		00
    X"F0", X"78",	--0:06	bra_n	78,
    X"F2", X"0C",	--0:08	bra_z	0C,
    X"80", X"78",	--0:0A	jmp	0:78,
    X"F4", X"78",	--0:0C	bra_c	78,
    X"F8", X"78",	--0:0E	bra_v   78,

    X"20", X"70",	--0:10	and	0:70,		FF-
    X"A0", X"74",	--0:12	sta	0:74,		00
    X"F0", X"78",	--0:14	bra_n	78,
    X"F2", X"1A",	--0:16	bra_z	1A,
    X"80", X"78",	--0:18	jmp	0:78,
    X"F4", X"78",	--0:1A	bra_c	78,
    X"F8", X"78",	--0:1C	bra_v   78,

    X"00", X"60",	--0:1E	lda	0:60,		A5-
    X"35", X"01",	--0:20	and	(5:01),		5A-@09
    X"A0", X"75",	--0:22	sta	0:75,		00
    X"F0", X"78",	--0:24	bra_n	78,
    X"F2", X"2A",	--0:26	bra_z	2A,
    X"80", X"78",	--0:28	jmp	0:78,
    X"F4", X"78",	--0:2A	bra_c	78,
    X"F8", X"78",	--0:2C	bra_v   78,

    X"05", X"0E",	--0:2E	lda	5:0E,		80-
    X"E8",		--0:30	asl
    X"E0",		--0:31	nop
    X"00", X"61",	--0:32	lda	0:61,		5A
    X"35", X"01",	--0:34	and	(5:01),		5A-@09
    X"A0", X"76",	--0:36	sta	0:76,		5A
    X"F0", X"78",	--0:38	bra_n	78,
    X"F2", X"78",	--0:3A	bra_z	78,
    X"F4", X"40",	--0:3C	bra_c	40,
    X"80", X"78",	--0:3E	jmp	0:78,
    X"F8", X"44",	--0:40	bra_v   44,
    X"80", X"78",	--0:42	jmp	0:78,

    X"00", X"60",	--0:44	lda	0:60,		A5-
    X"35", X"00",	--0:46	and	(5:00),		A5-@08
    X"A0", X"77",	--0:48	sta	0:77,		A5
    X"F0", X"4E",	--0:4A	bra_n	4E,
    X"80", X"78",	--0:4C	jmp	0:78,
    X"F2", X"78",	--0:4E	bra_z	78,
    X"F4", X"54",	--0:50	bra_c	54,
    X"80", X"78",	--0:52	jmp	0:78,
    X"F8", X"58",	--0:54	bra_v   58,
    X"80", X"78",	--0:56	jmp	0:78,
    X"85", X"04",	--0:58	jmp	5:04,

    X"00", X"00", --0:5A
    X"00", X"00", X"00", X"00", --0:5C
    X"A5", X"5A", X"00", X"00", --0:60	A5, 5A,
    X"00", X"00", X"00", X"00", --0:64
    X"00", X"00", X"00", X"00", --0:68
    X"00", X"00", X"00", X"00", --0:6C

    X"FF", X"00", X"80", X"FF", --0:70	FF, 00, 80, FF,		FF, 00, 80, 00,
    X"FF", X"FF", X"A5", X"5A", --0:74	FF, FF, A5, 5A,		00, 00, 5A, A5,
    X"80", X"78",	--0:78	jmp	0:78
    X"00", X"00",	--0:7A
    X"00", X"00", X"00", X"00"	--0:7C
    );
  variable memory2       : BYTE_MEMORY (0 to 23) :=
    (
    X"08", X"09", X"00", X"00", --5:00	A5-@08, 5A-@09,
    X"85", X"10",	--5:04	jmp	5:10
    X"00", X"00",	--5:06
    X"A5", X"5A", X"00", X"00", --5:08	A5, 5A,
    X"FF", X"00", X"80", X"00",	--5:0C	FF,   , 80,
    X"05", X"0C", X"A5", X"17", --5:10	lda 5:0C, sta 5:17,
    X"85", X"14", X"00", X"00"  --5:14  jmp 5:14
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
      if (ia >= 128 and ia < 1280) or (ia >= 1304) then
        databus <= HI_IMP_8;
        assert FALSE
          report "Simulation Error : adbus has illegal address when reading."
          severity FAILURE;
      else 
	if ia < 128 then
	  databus <= Drive (BVtoMVL7V (memory1 (ia)));
	else
	  databus <= Drive (BVtoMVL7V (memory2 (ia - 1280)));
	end if;
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then -- memory write
      wait until write_mem = '0';
      if ia < 128 then
        memory1 (ia) := MVL7VtoBV (Drive (databus));
      elsif ia >= 1280 and ia < 1304 then
        memory2 (ia - 1280) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;

    if (ia = 121) or -- X"0:79"
       (ia = 1301)   -- X"5:15"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
end BEHAVIORAL;
