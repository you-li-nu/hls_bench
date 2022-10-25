--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "op2"
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
--          access twice on address = 249(X"F9") (illegal condition)
--                          address = 231(X"E7") (legal condition)
--  
-- (2) Tested Instructions
--      Mainly tested in this vector
--	  cla
--	  cma
--	  cmc
--	  asl
--	  asr
--	  nop
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
  variable memexp1       : BYTE_MEMORY (0 to 255) := -- expected value
    (
    X"00", X"E8",	--0:00	lda	0:E8,		FF-
    X"E1",		--0:02	cla,
    X"A0", X"F0",	--0:03	sta	0:F0,		00
    X"F0", X"09",	--0:05	bra_n	09,
    X"80", X"F8",	--0:07	jmp	0:F8,
    X"F2", X"F8",	--0:09	bra_z	F8,
    X"F4", X"F8",	--0:0B	bra_c	F8,
    X"F8", X"F8",	--0:0D	bra_v   F8,
    X"00", X"E9",	--0:0F	lda	0:E9,		80-
    X"E8",		--0:11	asl,
    X"E1", 		--0:12	cla,
    X"A0", X"F1",	--0:13	sta	0:F1,		00
    X"F0", X"F8",	--0:15	bra_n	F8,
    X"F2", X"1B",	--0:17	bra_z   1B,
    X"80", X"F8",	--0:19	jmp	0:F8,
    X"F4", X"1F",	--0:1B	bra_c	1F
    X"80", X"F8",	--0:1D	jmp	0:F8,
    X"F8", X"23",	--0:1F	bra_v   23
    X"80", X"F8",	--0:21	jmp	0:F8,

    X"E2", 		--0:23	cma,
    X"A0", X"F2",	--0:24	sta	0:F2,		FF
    X"F0", X"2A",	--0:26	bra_n	2A,
    X"80", X"F8",	--0:28	jmp   0:F8,
    X"F2", X"F8",	--0:2A	bra_z	F8,
    X"F4", X"30",	--0:2C	bra_c   30,
    X"80", X"F8",	--0:2E	jmp	0:F8,
    X"F8", X"34",	--0:30	bra_v	34,
    X"80", X"F8",	--0:32	jmp	0:F8,
    X"E2", 		--0:34	cma,
    X"A0", X"F3",	--0:35	sta	0:F3,		00
    X"F0", X"F8",	--0:37	bra_n   F8,
    X"F2", X"3D",	--0:39	bra_z   3D,
    X"80", X"F8",	--0:3B	jmp	0:F8,
    X"E8", 		--0:3D	asl,
    X"F2", X"42",	--0:3E	bra_z   42,
    X"80", X"F8",	--0:40	jmp	0:F8,
    X"E2", 		--0:42	cma,
    X"A0", X"F4",	--0:43	sta	0:F4,		FF
    X"F4", X"F8",	--0:45	bra_c   F8,
    X"F8", X"F8",	--0:47	bra_v   F8,
    X"00", X"EA",	--0:49  lda	0:EA		A5-
    X"E2", 		--0:4B	cma,
    X"F0", X"F8",	--0:4C	bra_n   F8,
    X"F2", X"F8",	--0:4E	bra_z   F8,
    X"A0", X"F5",	--0:50	sta	0:F5,		5A

    X"00", X"EB",	--0:52	lda	0:EB,		00-
    X"E8", 		--0:54	asl,
    X"E4", 		--0:55	cmc,
    X"F0", X"F8",	--0:56	bra_n   F8,
    X"F2", X"5C",	--0:58	bra_z   5C,
    X"80", X"F8",	--0:5A  jmp	0:F8,
    X"F4", X"60",	--0:5C	bra_c   60,
    X"80", X"F8",	--0:5E  jmp	0:F8,
    X"F8", X"F8",	--0:60	bra_v   F8,
    X"00", X"E9",	--0:62	lda	0:E9,		80-
    X"E4", 		--0:64	cmc,
    X"F0", X"69",	--0:65	bra_n   69,
    X"80", X"F8",	--0:67  jmp	0:F8,
    X"F2", X"F8",	--0:69	bra_z   F8,
    X"F4", X"F8",	--0:6B	bra_c   F8,
    X"F8", X"F8",	--0:6D	bra_v   F8,
    X"E8", 		--0:6F	asl,
    X"E4", 		--0:70	cmc,
    X"F0", X"F8",	--0:71	bra_n   F8,
    X"F2", X"77",	--0:73	bra_z   77,
    X"80", X"F8",	--0:75  jmp	0:F8,
    X"F4", X"F8",	--0:77	bra_c   F8,
    X"F8", X"7D",	--0:79	bra_v   7D,
    X"80", X"F8",	--0:7B  jmp	0:F8,

    X"00", X"EC",	--0:7D	lda	0:EC,		7F-
    X"E8", 		--0:7F  asl,
    X"F0", X"84",	--0:80	bra_n   84,
    X"80", X"F8",	--0:82  jmp	0:F8,
    X"F2", X"F8",	--0:84	bra_z   F8,
    X"F4", X"F8",	--0:86	bra_c   F8,
    X"F8", X"8C",	--0:88	bra_v   8C,
    X"80", X"F8",	--0:8A  jmp	0:F8,
    X"A0", X"F6",	--0:8C	sta	0:F6		FE

    X"00", X"EB",	--0:8E	lda	0:EB,		00-
    X"E8",		--0:90	asl
    X"E1", 		--0:91	cla
    X"E9", 		--0:92	asr
    X"F0", X"F8",	--0:93	bra_n   F8,
    X"F2", X"99",	--0:95	bra_z   99,
    X"80", X"F8",	--0:97  jmp	0:F8,
    X"F4", X"F8",	--0:99	bra_c   F8,
    X"F8", X"F8",	--0:9B	bra_v   F8,
    X"A0", X"F7",	--0:9D	sta	0:F7		00
    X"00", X"F5",	--0:9F	lda	0:F5		(5A)
    X"E9", 		--0:A1	asr
    X"A0", X"FC",	--0:A2	sta	0:FC		2D
    X"F0", X"F8",	--0:A4	bra_n   F8,
    X"F2", X"F8",	--0:A6	bra_z   F8,
    X"F4", X"F8",	--0:A8	bra_c   F8,
    X"F8", X"F8",	--0:AA	bra_v   F8,
    X"00", X"E9",	--0:AC	lda	0:E9,		80-
    X"E8", 		--0:AE	asl
    X"00", X"E9",	--0:AF	lda	0:E9,		80-
    X"E9", 		--0:B1	asr
    X"F0", X"B6",	--0:B2	bra_n   B6,
    X"80", X"F8",	--0:B4  jmp	0:F8,
    X"F2", X"F8",	--0:B6	bra_z   F8,
    X"F4", X"BC",	--0:B8	bra_c   BC,
    X"80", X"F8",	--0:BA  jmp	0:F8,
    X"F8", X"C0",	--0:BC	bra_v   C0,
    X"80", X"F8",	--0:BE  jmp	0:F8,
    X"A0", X"FD",	--0:C0	sta	0:FD		C0

    X"E0", 		--0:C2	nop
    X"A0", X"FE",	--0:C3	sta	0:FE		C0
    X"F0", X"C9",	--0:C5	bra_n   C9,
    X"80", X"F8",	--0:C7  jmp	0:F8,
    X"F2", X"F8",	--0:C9	bra_z   F8,
    X"F4", X"CF",	--0:CB	bra_c   CF,
    X"80", X"F8",	--0:CD  jmp	0:F8,
    X"F8", X"D3",	--0:CF	bra_v   D3,
    X"80", X"F8",	--0:D1  jmp	0:F8,
    X"E1", 		--0:D3	cla
    X"E8", 		--0:D4	asl
    X"E0", 		--0:D5	nop
    X"A0", X"FF",	--0:D6	sta	0:FF		00
    X"F0", X"F8",	--0:D8	bra_n   F8,
    X"F2", X"DE",	--0:DA	bra_z   DE,
    X"80", X"F8",	--0:DC  jmp	0:F8,
    X"F4", X"F8",	--0:DE	bra_c   F8,
    X"F8", X"F8",	--0:E0	bra_v   F8,
    X"00", X"E8",	--0:E2	lda	0:E8

    X"A0", X"EF", X"80", X"E6",	--0:E4  sta 0:EF, jmp 0:E6,
    X"FF", X"80", X"A5", X"00",	--0:E8	FF, 80, A5, 00

    X"7F", X"00", X"00", X"FF",	--0:EC  7F, 00, 00, 00,			    FF
    X"00", X"00", X"FF", X"00",	--0:F0	FF, FF, 00, FF,		00, 00, FF, 00
    X"FF", X"5A", X"FE", X"00",	--0:F4	00, A5, 01, FF,		FF, 5A, FE, 00
    X"80", X"F8",	--0:F8	jmp   0:F8,
    X"80", X"FA",	--0:FA	jmp   0:FA,
    X"2D", X"C0", X"C0", X"00"	--0:FC	D2, 3F, 3F, FF,		2D, C0, C0, 00
    );
  variable memory1       : BYTE_MEMORY (0 to 255) :=
    (
    X"00", X"E8",	--0:00	lda	0:E8,		FF-
    X"E1",		--0:02	cla,
    X"A0", X"F0",	--0:03	sta	0:F0,		00
    X"F0", X"09",	--0:05	bra_n	09,
    X"80", X"F8",	--0:07	jmp	0:F8,
    X"F2", X"F8",	--0:09	bra_z	F8,
    X"F4", X"F8",	--0:0B	bra_c	F8,
    X"F8", X"F8",	--0:0D	bra_v   F8,
    X"00", X"E9",	--0:0F	lda	0:E9,		80-
    X"E8",		--0:11	asl,
    X"E1", 		--0:12	cla,
    X"A0", X"F1",	--0:13	sta	0:F1,		00
    X"F0", X"F8",	--0:15	bra_n	F8,
    X"F2", X"1B",	--0:17	bra_z   1B,
    X"80", X"F8",	--0:19	jmp	0:F8,
    X"F4", X"1F",	--0:1B	bra_c	1F
    X"80", X"F8",	--0:1D	jmp	0:F8,
    X"F8", X"23",	--0:1F	bra_v   23
    X"80", X"F8",	--0:21	jmp	0:F8,

    X"E2", 		--0:23	cma,
    X"A0", X"F2",	--0:24	sta	0:F2,		FF
    X"F0", X"2A",	--0:26	bra_n	2A,
    X"80", X"F8",	--0:28	jmp   0:F8,
    X"F2", X"F8",	--0:2A	bra_z	F8,
    X"F4", X"30",	--0:2C	bra_c   30,
    X"80", X"F8",	--0:2E	jmp	0:F8,
    X"F8", X"34",	--0:30	bra_v	34,
    X"80", X"F8",	--0:32	jmp	0:F8,
    X"E2", 		--0:34	cma,
    X"A0", X"F3",	--0:35	sta	0:F3,		00
    X"F0", X"F8",	--0:37	bra_n   F8,
    X"F2", X"3D",	--0:39	bra_z   3D,
    X"80", X"F8",	--0:3B	jmp	0:F8,
    X"E8", 		--0:3D	asl,
    X"F2", X"42",	--0:3E	bra_z   42,
    X"80", X"F8",	--0:40	jmp	0:F8,
    X"E2", 		--0:42	cma,
    X"A0", X"F4",	--0:43	sta	0:F4,		FF
    X"F4", X"F8",	--0:45	bra_c   F8,
    X"F8", X"F8",	--0:47	bra_v   F8,
    X"00", X"EA",	--0:49  lda	0:EA		A5-
    X"E2", 		--0:4B	cma,
    X"F0", X"F8",	--0:4C	bra_n   F8,
    X"F2", X"F8",	--0:4E	bra_z   F8,
    X"A0", X"F5",	--0:50	sta	0:F5,		5A

    X"00", X"EB",	--0:52	lda	0:EB,		00-
    X"E8", 		--0:54	asl,
    X"E4", 		--0:55	cmc,
    X"F0", X"F8",	--0:56	bra_n   F8,
    X"F2", X"5C",	--0:58	bra_z   5C,
    X"80", X"F8",	--0:5A  jmp	0:F8,
    X"F4", X"60",	--0:5C	bra_c   60,
    X"80", X"F8",	--0:5E  jmp	0:F8,
    X"F8", X"F8",	--0:60	bra_v   F8,
    X"00", X"E9",	--0:62	lda	0:E9,		80-
    X"E4", 		--0:64	cmc,
    X"F0", X"69",	--0:65	bra_n   69,
    X"80", X"F8",	--0:67  jmp	0:F8,
    X"F2", X"F8",	--0:69	bra_z   F8,
    X"F4", X"F8",	--0:6B	bra_c   F8,
    X"F8", X"F8",	--0:6D	bra_v   F8,
    X"E8", 		--0:6F	asl,
    X"E4", 		--0:70	cmc,
    X"F0", X"F8",	--0:71	bra_n   F8,
    X"F2", X"77",	--0:73	bra_z   77,
    X"80", X"F8",	--0:75  jmp	0:F8,
    X"F4", X"F8",	--0:77	bra_c   F8,
    X"F8", X"7D",	--0:79	bra_v   7D,
    X"80", X"F8",	--0:7B  jmp	0:F8,

    X"00", X"EC",	--0:7D	lda	0:EC,		7F-
    X"E8", 		--0:7F  asl,
    X"F0", X"84",	--0:80	bra_n   84,
    X"80", X"F8",	--0:82  jmp	0:F8,
    X"F2", X"F8",	--0:84	bra_z   F8,
    X"F4", X"F8",	--0:86	bra_c   F8,
    X"F8", X"8C",	--0:88	bra_v   8C,
    X"80", X"F8",	--0:8A  jmp	0:F8,
    X"A0", X"F6",	--0:8C	sta	0:F6		FE

    X"00", X"EB",	--0:8E	lda	0:EB,		00-
    X"E8",		--0:90	asl
    X"E1", 		--0:91	cla
    X"E9", 		--0:92	asr
    X"F0", X"F8",	--0:93	bra_n   F8,
    X"F2", X"99",	--0:95	bra_z   99,
    X"80", X"F8",	--0:97  jmp	0:F8,
    X"F4", X"F8",	--0:99	bra_c   F8,
    X"F8", X"F8",	--0:9B	bra_v   F8,
    X"A0", X"F7",	--0:9D	sta	0:F7		00
    X"00", X"F5",	--0:9F	lda	0:F5		(5A)
    X"E9", 		--0:A1	asr
    X"A0", X"FC",	--0:A2	sta	0:FC		2D
    X"F0", X"F8",	--0:A4	bra_n   F8,
    X"F2", X"F8",	--0:A6	bra_z   F8,
    X"F4", X"F8",	--0:A8	bra_c   F8,
    X"F8", X"F8",	--0:AA	bra_v   F8,
    X"00", X"E9",	--0:AC	lda	0:E9,		80-
    X"E8", 		--0:AE	asl
    X"00", X"E9",	--0:AF	lda	0:E9,		80-
    X"E9", 		--0:B1	asr
    X"F0", X"B6",	--0:B2	bra_n   B6,
    X"80", X"F8",	--0:B4  jmp	0:F8,
    X"F2", X"F8",	--0:B6	bra_z   F8,
    X"F4", X"BC",	--0:B8	bra_c   BC,
    X"80", X"F8",	--0:BA  jmp	0:F8,
    X"F8", X"C0",	--0:BC	bra_v   C0,
    X"80", X"F8",	--0:BE  jmp	0:F8,
    X"A0", X"FD",	--0:C0	sta	0:FD		C0

    X"E0", 		--0:C2	nop
    X"A0", X"FE",	--0:C3	sta	0:FE		C0
    X"F0", X"C9",	--0:C5	bra_n   C9,
    X"80", X"F8",	--0:C7  jmp	0:F8,
    X"F2", X"F8",	--0:C9	bra_z   F8,
    X"F4", X"CF",	--0:CB	bra_c   CF,
    X"80", X"F8",	--0:CD  jmp	0:F8,
    X"F8", X"D3",	--0:CF	bra_v   D3,
    X"80", X"F8",	--0:D1  jmp	0:F8,
    X"E1", 		--0:D3	cla
    X"E8", 		--0:D4	asl
    X"E0", 		--0:D5	nop
    X"A0", X"FF",	--0:D6	sta	0:FF		00
    X"F0", X"F8",	--0:D8	bra_n   F8,
    X"F2", X"DE",	--0:DA	bra_z   DE,
    X"80", X"F8",	--0:DC  jmp	0:F8,
    X"F4", X"F8",	--0:DE	bra_c   F8,
    X"F8", X"F8",	--0:E0	bra_v   F8,
    X"00", X"E8",	--0:E2	lda	0:E8

    X"A0", X"EF", X"80", X"E6",	--0:E4  sta 0:EF, jmp 0:E6,
    X"FF", X"80", X"A5", X"00",	--0:E8	FF, 80, A5, 00

    X"7F", X"00", X"00", X"00",	--0:EC  7F, 00, 00, 00,			    FF
    X"FF", X"FF", X"00", X"FF",	--0:F0	FF, FF, 00, FF,		00, 00, FF, 00
    X"00", X"A5", X"01", X"FF",	--0:F4	00, A5, 01, FF,		FF, 5A, FE, 00
    X"80", X"F8",	--0:F8	jmp   0:F8,
    X"80", X"FA",	--0:FA	jmp   0:FA,
    X"D2", X"3F", X"3F", X"FF"	--0:FC	D2, 3F, 3F, FF,		2D, C0, C0, 00
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
      if ia >= 256 then
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
      if ia < 256 then
        memory1 (ia) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;
    if (ia = 249) or -- X"F9"
       (ia = 231)    -- X"E7"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
end BEHAVIORAL;
