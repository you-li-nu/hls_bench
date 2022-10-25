--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "op7"
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
--        working set  :  variable memory1
--      Control process :
--        the condition of the end of the simulatoin :
--          access twice on address = 125(X"7D") (illegal condition)
--                          address = 127(X"7F") (legal condition)
--  
-- (2) Tested Instructions
--      Mainly tested in this vector
--	  rol
--	  ror
--      tested side-effectly
--        lda direct
--        sta direct
--        bra_n
--        bra_nn
--        bra_z
--        bra_nz
--        bra
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
    X"00", X"60",	--0:00	lda	0:60,		AA-
    X"EB",		--0:02	ror,
    X"A0", X"70",	--0:03	sta	0:70,		55
    X"F0", X"7C",	--0:05	bra_n	7C,
    X"F2", X"7C",	--0:07	bra_z	7C,
    X"00", X"61",	--0:09	lda	0:61,		00-
    X"EB", 		--0:0B	ror
    X"A0", X"71",	--0:0C	sta	0:71,		00
    X"F0", X"7C",	--0:0E	bra_n   7C,
    X"F3", X"7C",	--0:10	bra_nz  7C,
    X"00", X"62",	--0:12	lda	0:62,		FF-
    X"EB",		--0:14	ror,
    X"A0", X"72",	--0:15	sta	0:72,		FF
    X"F1", X"7C",	--0:17	bra_nn	7C,
    X"F2", X"7C",	--0:19	bra_z	7C,
    X"00", X"70",	--0:1B	lda	0:70,		55
    X"EB",		--0:1D	ror
    X"A0", X"73",	--0:1E	sta	0:73,		AA
    X"F1", X"7C",	--0:20	bra_nn	7C,
    X"F2", X"7C",	--0:22	bra_z   7C,

    X"00", X"70",	--0:24	lda	0:70,		55
    X"EB",		--0:26	rol,
    X"A0", X"74",	--0:27	sta	0:74,		AA
    X"F1", X"7C",	--0:29	bra_nn	7C,
    X"F2", X"7C",	--0:2B	bra_z	7C,
    X"00", X"61",	--0:2D	lda	0:61,		00-
    X"EB",		--0:2F	rol
    X"A0", X"75",	--0:30	sta	0:75,		00
    X"F0", X"7C",	--0:32	bra_n   7C,
    X"F3", X"7C",	--0:34	bra_nz  7C,
    X"00", X"62",	--0:36	lda	0:62,		FF-
    X"EB",		--0:38	rol,
    X"A0", X"76",	--0:39	sta	0:76,		FF
    X"F1", X"7C",	--0:3B	bra_nn	7C,
    X"F2", X"7C",	--0:3E	bra_z	7C,
    X"00", X"60",	--0:3F	lda	0:60,		AA-
    X"EB",		--0:41	rol
    X"A0", X"77",	--0:42	sta	0:77,		55
    X"F0", X"7C",	--0:44	bra_n	7C,
    X"F2", X"7C",	--0:46	bra_z   7C,
    X"FD", X"7E",	--0:48  bra	7E,

    X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",

    X"AA", X"00", X"FF", X"00", --0:60  AA, 00, FF, 00,
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",

    X"55", X"00", X"FF", X"AA", --0:70  AA, FF, 00, 55,		55, 00, FF, AA,
    X"AA", X"00", X"FF", X"55", --0:74  55, FF, 00, AA,		AA, 00, FF, 55,
    X"00", X"00", X"00", X"00",
    X"FD", X"7C",	--0:7C  bra	7C,
    X"FD", X"7E"	--0:7E  bra	7E,
    );
  variable memory1       : BYTE_MEMORY (0 to 127) :=
    (
    X"00", X"60",	--0:00	lda	0:60,		AA-
    X"EB",		--0:02	ror,
    X"A0", X"70",	--0:03	sta	0:70,		55
    X"F0", X"7C",	--0:05	bra_n	7C,
    X"F2", X"7C",	--0:07	bra_z	7C,
    X"00", X"61",	--0:09	lda	0:61,		00-
    X"EB", 		--0:0B	ror
    X"A0", X"71",	--0:0C	sta	0:71,		00
    X"F0", X"7C",	--0:0E	bra_n   7C,
    X"F3", X"7C",	--0:10	bra_nz  7C,
    X"00", X"62",	--0:12	lda	0:62,		FF-
    X"EB",		--0:14	ror,
    X"A0", X"72",	--0:15	sta	0:72,		FF
    X"F1", X"7C",	--0:17	bra_nn	7C,
    X"F2", X"7C",	--0:19	bra_z	7C,
    X"00", X"70",	--0:1B	lda	0:70,		55
    X"EB",		--0:1D	ror
    X"A0", X"73",	--0:1E	sta	0:73,		AA
    X"F1", X"7C",	--0:20	bra_nn	7C,
    X"F2", X"7C",	--0:22	bra_z   7C,

    X"00", X"70",	--0:24	lda	0:70,		55
    X"EB",		--0:26	rol,
    X"A0", X"74",	--0:27	sta	0:74,		AA
    X"F1", X"7C",	--0:29	bra_nn	7C,
    X"F2", X"7C",	--0:2B	bra_z	7C,
    X"00", X"61",	--0:2D	lda	0:61,		00-
    X"EB",		--0:2F	rol
    X"A0", X"75",	--0:30	sta	0:75,		00
    X"F0", X"7C",	--0:32	bra_n   7C,
    X"F3", X"7C",	--0:34	bra_nz  7C,
    X"00", X"62",	--0:36	lda	0:62,		FF-
    X"EB",		--0:38	rol,
    X"A0", X"76",	--0:39	sta	0:76,		FF
    X"F1", X"7C",	--0:3B	bra_nn	7C,
    X"F2", X"7C",	--0:3E	bra_z	7C,
    X"00", X"60",	--0:3F	lda	0:60,		AA-
    X"EB",		--0:41	rol
    X"A0", X"77",	--0:42	sta	0:77,		55
    X"F0", X"7C",	--0:44	bra_n	7C,
    X"F2", X"7C",	--0:46	bra_z   7C,
    X"FD", X"7E",	--0:48  bra	7E,

    X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",

    X"AA", X"00", X"FF", X"00", --0:60  AA, 00, FF, 00,
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",

    X"AA", X"FF", X"00", X"55", --0:70  AA, FF, 00, 55,		55, 00, FF, AA,
    X"55", X"FF", X"00", X"AA", --0:74  55, FF, 00, AA,		AA, 00, FF, 55,
    X"00", X"00", X"00", X"00",
    X"FD", X"7C",	--0:7C  bra	7C,
    X"FD", X"7E"	--0:7E  bra	7E,
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
      assert finish = 0
	report "Simulation is done successfully." severity ERROR;

    elsif read_mem = '1' then -- memory read
      if ia >= 128 then
        databus <= HI_IMP_8;
        assert FALSE
          report "Simulation Error : adbus has illegal address when reading."
          severity FAILURE;
      else 
	databus <= Drive (BVtoMVL7V (memory1 (ia)));
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then -- memory write
      wait until write_mem = '0';
      if ia < 128 then
        memory1 (ia) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;
    if (ia = 125) or -- X"7D"
       (ia = 127)    -- X"7F"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
end BEHAVIORAL;
