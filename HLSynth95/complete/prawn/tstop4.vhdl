--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "op4"
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
--          access twice on address =  191(X"0:BF") (illegal condition)
--                          address = 2573(X"A:0D") (legal condition)
--
-- (2) Tested Instructions
--      Mainly tested in this vector
--        add direct/indirect
--      tested side-effectly
--        lda direct/indirect
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
  variable memexp1       : BYTE_MEMORY (0 to 191) := -- expected value
    (
    --1	00+00=>00	z
    X"E1",		--0:00	cla
    X"E0",		--0:01	nop
    X"40", X"B0",	--0:02	add     0:B0,		00-
    X"A0", X"B4",	--0:04	sta	0:B4,		00
    X"F0", X"BE",	--0:06	bra_n	BE,
    X"F2", X"0C",	--0:08	bra_z	0C,
    X"80", X"BE",	--0:0A	jmp	0:BE,
    X"F4", X"BE",	--0:0C	bra_c	BE,
    X"F8", X"BE",	--0:0E	bra_v   BE,
    --2	7E+01=>7F
    X"00", X"B2",	--0:10	lda	0:B2		7E-
    X"40", X"B1",	--0:12	add	0:B1,		01-
    X"A0", X"B5",	--0:14	sta	0:B5,		7F
    X"F0", X"BE",	--0:16	bra_n	BE,
    X"F2", X"BE",	--0:18	bra_z	BE,
    X"F4", X"BE",	--0:1A	bra_c	BE,
    X"F8", X"BE",	--0:1C	bra_v   BE,
    --3	7F+01=>-80	nv
    X"40", X"B1",	--0:1E	add	0:B1,		01-
    X"A0", X"B6",	--0:20	sta	0:B6,		80
    X"F0", X"26",	--0:22	bra_n	26,
    X"80", X"BE",	--0:24	jmp	0:BE,
    X"F2", X"BE",	--0:26	bra_z	BE,
    X"F4", X"BE",	--0:28	bra_c	BE,
    X"F8", X"2E",	--0:2A	bra_v   2E,
    X"80", X"BE",	--0:2C	jmp	0:BE,
    --4	7F+7F=>-02	nv
    X"00", X"B3",	--0:2E	lda	0:B3,		7F-
    X"40", X"B3",	--0:30	add	0:B3,		7F-
    X"A0", X"B7",	--0:32	sta	0:B7,		FE
    X"F0", X"38",	--0:34	bra_n	38,
    X"80", X"BE",	--0:36	jmp	0:BE,
    X"F2", X"BE",	--0:38	bra_z	BE,
    X"F4", X"BE",	--0:3A	bra_c	BE,
    X"F8", X"40",	--0:3C	bra_v   40,
    X"80", X"BE",	--0:3E	jmp	0:BE,
    --5	-80+7F=>-01	n
    X"1A", X"00",	--0:40	lda	(A:00),		80-@04
    X"40", X"B3",	--0:42	add	0:B3,		7F-
    X"A0", X"B8",	--0:44	sta	0:B8,		FF
    X"F0", X"4A",	--0:46	bra_n	4A,
    X"80", X"BE",	--0:48	jmp	0:BE,
    X"F2", X"BE",	--0:4A	bra_z	BE,
    X"F4", X"BE",	--0:4C	bra_c	BE,
    X"F8", X"BE",	--0:4E	bra_v   BE,
    --6	-80+-80=>00	zcv
    X"1A", X"00",	--0:50	lda	(A:00),		80-@04
    X"5A", X"00",	--0:52	add	(A:00),		80-@04
    X"A0", X"B9",	--0:54	sta	0:B9,		00
    X"F0", X"BE",	--0:56	bra_n	BE,
    X"F2", X"5C",	--0:58	bra_z	5C,
    X"80", X"BE",	--0:5A	jmp	0:BE,
    X"F4", X"60",	--0:5C	bra_c	60,
    X"80", X"BE",	--0:5E	jmp	0:BE,
    X"F8", X"64",	--0:60	bra_v   64,
    X"80", X"BE",	--0:62	jmp	0:BE,
    --7	-7F+00+C=>-7E	n
    X"5A", X"01",	--0:64	add	(A:01),		81-@05
    X"A0", X"BA",	--0:66	sta	0:BA,		82
    X"F0", X"6C",	--0:68	bra_n	6C,
    X"80", X"BE",	--0:6A	jmp	0:BE,
    X"F2", X"BE",	--0:6C	bra_z	BE,
    X"F4", X"BE",	--0:6E	bra_c	BE,
    X"F8", X"BE",	--0:70	bra_v   BE,
    --8	-7F+-7F=>02	cv
    X"1A", X"01",	--0:72	lda	(A:01),		81-@05
    X"5A", X"01",	--0:74	add	(A:01),		81-@05
    X"A0", X"BB",	--0:76	sta	0:BB,		02
    X"F0", X"BE",	--0:BE	bra_n	BE,
    X"F2", X"BE",	--0:7A	bra_z	BE,
    X"F4", X"80",	--0:7C	bra_c	80,
    X"80", X"BE",	--0:7E	jmp	0:BE,
    X"F8", X"84",	--0:80	bra_v   84,
    X"80", X"BE",	--0:82	jmp	0:BE,
    --9	-7F+7E+C=>00	zc
    X"1A", X"01",	--0:84	lda	(A:01),		81-@05
    X"40", X"B2",	--0:86	add	0:B2,		7E-
    X"A0", X"BC",	--0:88	sta	0:BC,		00
    X"F0", X"BE",	--0:8A	bra_n	BE,
    X"F2", X"90",	--0:8C	bra_z	90,
    X"80", X"BE",	--0:8E	jmp	0:BE,
    X"F4", X"94",	--0:90	bra_c	94,
    X"80", X"BE",	--0:92	jmp	0:BE,
    X"F8", X"BE",	--0:94	bra_v   BE,
    --10	-02+-7F+C=>-80	nc
    X"1A", X"01",	--0:96	lda	(A:01),		81-@05
    X"5A", X"02",	--0:98	add	(A:02),		FE-@06
    X"A0", X"BD",	--0:9A	sta	0:BD,		80
    X"F0", X"A0",	--0:9C	bra_n	A0,
    X"80", X"BE",	--0:9E	jmp	0:BE,
    X"F2", X"BE",	--0:A0	bra_z	BE,
    X"F4", X"A6",	--0:A2	bra_c	A6,
    X"80", X"BE",	--0:A4	jmp	0:BE,
    X"F8", X"BE",	--0:A6	bra_v   BE,

    X"8A", X"08",	--0:A8	jmp	A:08,
    X"00", X"00",	--0:AA
    X"00", X"00", X"00", X"00", --0:AC

    X"00", X"01", X"7E", X"7F", --0:B0	00, 01, 7E, 7F,
    X"00", X"7F", X"80", X"FE", --0:B4	FF, 80, 7F, 01,		00, 7F, 80, FE,
    X"FF", X"00", X"82", X"02", --0:B8	00, FF, 7D, FD,		FF, 00, 82, 02,
    X"00", X"80",	--0:BC		FF, 7F,			00, 80
    X"80", X"BE"	--0:BE	jmp	0:BE
    );
  variable memexp2       : BYTE_MEMORY (0 to 15) := -- expected value
    (
    X"04", X"05", X"06", X"00", --A:00	80-@04, 81-@05, FE-@06
    X"80", X"81", X"FE", X"00", --A:04	80, 81, FE,
    X"0A", X"04",	--A:08	lda	A:04
    X"AA", X"0F",	--A:0A	sta	A:0F
    X"8A", X"0C",	--A:0C	jmp	A:0C
    X"00", X"80"	--A:0C	00, 7F,				00, 80,
    );
  variable memory1       : BYTE_MEMORY (0 to 191) :=
    (
    --1	00+00=>00	z
    X"E1",		--0:00	cla
    X"E0",		--0:01	nop
    X"40", X"B0",	--0:02	add     0:B0,		00-
    X"A0", X"B4",	--0:04	sta	0:B4,		00
    X"F0", X"BE",	--0:06	bra_n	BE,
    X"F2", X"0C",	--0:08	bra_z	0C,
    X"80", X"BE",	--0:0A	jmp	0:BE,
    X"F4", X"BE",	--0:0C	bra_c	BE,
    X"F8", X"BE",	--0:0E	bra_v   BE,
    --2	7E+01=>7F
    X"00", X"B2",	--0:10	lda	0:B2		7E-
    X"40", X"B1",	--0:12	add	0:B1,		01-
    X"A0", X"B5",	--0:14	sta	0:B5,		7F
    X"F0", X"BE",	--0:16	bra_n	BE,
    X"F2", X"BE",	--0:18	bra_z	BE,
    X"F4", X"BE",	--0:1A	bra_c	BE,
    X"F8", X"BE",	--0:1C	bra_v   BE,
    --3	7F+01=>-80	nv
    X"40", X"B1",	--0:1E	add	0:B1,		01-
    X"A0", X"B6",	--0:20	sta	0:B6,		80
    X"F0", X"26",	--0:22	bra_n	26,
    X"80", X"BE",	--0:24	jmp	0:BE,
    X"F2", X"BE",	--0:26	bra_z	BE,
    X"F4", X"BE",	--0:28	bra_c	BE,
    X"F8", X"2E",	--0:2A	bra_v   2E,
    X"80", X"BE",	--0:2C	jmp	0:BE,
    --4	7F+7F=>-02	nv
    X"00", X"B3",	--0:2E	lda	0:B3,		7F-
    X"40", X"B3",	--0:30	add	0:B3,		7F-
    X"A0", X"B7",	--0:32	sta	0:B7,		FE
    X"F0", X"38",	--0:34	bra_n	38,
    X"80", X"BE",	--0:36	jmp	0:BE,
    X"F2", X"BE",	--0:38	bra_z	BE,
    X"F4", X"BE",	--0:3A	bra_c	BE,
    X"F8", X"40",	--0:3C	bra_v   40,
    X"80", X"BE",	--0:3E	jmp	0:BE,
    --5	-80+7F=>-01	n
    X"1A", X"00",	--0:40	lda	(A:00),		80-@04
    X"40", X"B3",	--0:42	add	0:B3,		7F-
    X"A0", X"B8",	--0:44	sta	0:B8,		FF
    X"F0", X"4A",	--0:46	bra_n	4A,
    X"80", X"BE",	--0:48	jmp	0:BE,
    X"F2", X"BE",	--0:4A	bra_z	BE,
    X"F4", X"BE",	--0:4C	bra_c	BE,
    X"F8", X"BE",	--0:4E	bra_v   BE,
    --6	-80+-80=>00	zcv
    X"1A", X"00",	--0:50	lda	(A:00),		80-@04
    X"5A", X"00",	--0:52	add	(A:00),		80-@04
    X"A0", X"B9",	--0:54	sta	0:B9,		00
    X"F0", X"BE",	--0:56	bra_n	BE,
    X"F2", X"5C",	--0:58	bra_z	5C,
    X"80", X"BE",	--0:5A	jmp	0:BE,
    X"F4", X"60",	--0:5C	bra_c	60,
    X"80", X"BE",	--0:5E	jmp	0:BE,
    X"F8", X"64",	--0:60	bra_v   64,
    X"80", X"BE",	--0:62	jmp	0:BE,
    --7	-7F+00+C=>-7E	n
    X"5A", X"01",	--0:64	add	(A:01),		81-@05
    X"A0", X"BA",	--0:66	sta	0:BA,		82
    X"F0", X"6C",	--0:68	bra_n	6C,
    X"80", X"BE",	--0:6A	jmp	0:BE,
    X"F2", X"BE",	--0:6C	bra_z	BE,
    X"F4", X"BE",	--0:6E	bra_c	BE,
    X"F8", X"BE",	--0:70	bra_v   BE,
    --8	-7F+-7F=>02	cv
    X"1A", X"01",	--0:72	lda	(A:01),		81-@05
    X"5A", X"01",	--0:74	add	(A:01),		81-@05
    X"A0", X"BB",	--0:76	sta	0:BB,		02
    X"F0", X"BE",	--0:BE	bra_n	BE,
    X"F2", X"BE",	--0:7A	bra_z	BE,
    X"F4", X"80",	--0:7C	bra_c	80,
    X"80", X"BE",	--0:7E	jmp	0:BE,
    X"F8", X"84",	--0:80	bra_v   84,
    X"80", X"BE",	--0:82	jmp	0:BE,
    --9	-7F+7E+C=>00	zc
    X"1A", X"01",	--0:84	lda	(A:01),		81-@05
    X"40", X"B2",	--0:86	add	0:B2,		7E-
    X"A0", X"BC",	--0:88	sta	0:BC,		00
    X"F0", X"BE",	--0:8A	bra_n	BE,
    X"F2", X"90",	--0:8C	bra_z	90,
    X"80", X"BE",	--0:8E	jmp	0:BE,
    X"F4", X"94",	--0:90	bra_c	94,
    X"80", X"BE",	--0:92	jmp	0:BE,
    X"F8", X"BE",	--0:94	bra_v   BE,
    --10	-02+-7F+C=>-80	nc
    X"1A", X"01",	--0:96	lda	(A:01),		81-@05
    X"5A", X"02",	--0:98	add	(A:02),		FE-@06
    X"A0", X"BD",	--0:9A	sta	0:BD,		80
    X"F0", X"A0",	--0:9C	bra_n	A0,
    X"80", X"BE",	--0:9E	jmp	0:BE,
    X"F2", X"BE",	--0:A0	bra_z	BE,
    X"F4", X"A6",	--0:A2	bra_c	A6,
    X"80", X"BE",	--0:A4	jmp	0:BE,
    X"F8", X"BE",	--0:A6	bra_v   BE,

    X"8A", X"08",	--0:A8	jmp	A:08,
    X"00", X"00",	--0:AA
    X"00", X"00", X"00", X"00", --0:AC

    X"00", X"01", X"7E", X"7F", --0:B0	00, 01, 7E, 7F,
    X"FF", X"80", X"7F", X"01", --0:B4	FF, 80, 7F, 01,		00, 7F, 80, FE,
    X"00", X"FF", X"7D", X"FD", --0:B8	00, FF, 7D, FD,		FF, 00, 82, 02,
    X"FF", X"7F",	--0:BC		FF, 7F,			00, 80
    X"80", X"BE"	--0:BE	jmp	0:BE
    );
  variable memory2       : BYTE_MEMORY (0 to 15) :=
    (
    X"04", X"05", X"06", X"00", --A:00	80-@04, 81-@05, FE-@06
    X"80", X"81", X"FE", X"00", --A:04	80, 81, FE,
    X"0A", X"04",	--A:08	lda	A:04
    X"AA", X"0F",	--A:0A	sta	A:0F
    X"8A", X"0C",	--A:0C	jmp	A:0C
    X"00", X"7F"	--A:0E	00, 7F,				00, 80,
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
      if (ia >= 192 and ia < 2560) or (ia >= 2576) then
        databus <= HI_IMP_8;
        assert FALSE
          report "Simulation Error : adbus has illegal address when reading."
          severity FAILURE;
      else 
	if ia < 192 then
	  databus <= Drive (BVtoMVL7V (memory1 (ia)));
	else
	  databus <= Drive (BVtoMVL7V (memory2 (ia - 2560)));
	end if;
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then -- memory write
      wait until write_mem = '0';
      if ia < 192 then
        memory1 (ia) := MVL7VtoBV (Drive (databus));
      elsif ia >= 2560 and ia < 2576 then
        memory2 (ia - 2560) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;

    if (ia = 191) or -- X"0:BF"
       (ia = 2573)    -- X"A:0D"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
end BEHAVIORAL;
