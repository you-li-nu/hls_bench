--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "op5"
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
--          access twice on address =  255(X"0:FF") (illegal condition)
--                          address = 2065(X"8:11") (legal condition)
--
-- (2) Tested Instructions
--      Mainly tested in this vector
--        sub direct/indirect
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
  variable memexp1       : BYTE_MEMORY (0 to 255) := -- expected value
    (
    --1	00-00=>00	z
    X"E1", X"E0",	--0:00	cla,	nop,
    X"68", X"00",	--0:02	sub     8:00,		00-
    X"A0", X"F0",	--0:04	sta	0:F0,		00
    X"F0", X"FE",	--0:06	bra_n	FE,
    X"F2", X"0C",	--0:08	bra_z	0C,
    X"80", X"FE",	--0:0A	jmp	0:FE,
    X"F4", X"FE",	--0:0C	bra_c	FE,
    X"F8", X"FE",	--0:0E	bra_v   FE,
    --2	7F-7E=>01
    X"00", X"E3",	--0:10	lda	0:E3		7F-
    X"68", X"02",	--0:12	sub	8:02,		7E-
    X"A0", X"F1",	--0:14	sta	0:F1,		01
    X"F0", X"FE",	--0:16	bra_n	FE,
    X"F2", X"FE",	--0:18	bra_z	FE,
    X"F4", X"FE",	--0:1A	bra_c	FE,
    X"F8", X"FE",	--0:1C	bra_v   FE,
    --3	7E-7F=>-01	nc
    X"00", X"E2",	--0:1E	lda	0:E2,		7E-
    X"68", X"03",	--0:20	sub	8:03,		7F-
    X"A0", X"F2",	--0:22	sta	0:F2,		-01
    X"F0", X"28",	--0:24	bra_n	28,
    X"80", X"FE",	--0:26	jmp	0:FE,
    X"F2", X"FE",	--0:28	bra_z	FE,
    X"F4", X"2E",	--0:2A	bra_c	2E,
    X"80", X"FE",	--0:2C	jmp	0:FE,
    X"F8", X"FE",	--0:2E	bra_v   FE,
    --4	-7F-0-B=>-02	n
    X"10", X"E5",	--0:30	lda	(0:E5),		-7F-@E9
    X"68", X"00",	--0:32	sub	8:00,		00-
    X"A0", X"F3",	--0:34	sta	0:F3,		-80
    X"F0", X"3A",	--0:36	bra_n	3A,
    X"80", X"FE",	--0:38	jmp	0:FE,
    X"F2", X"FE",	--0:3A	bra_z	FE,
    X"F4", X"FE",	--0:3C	bra_c	FE,
    X"F8", X"FE",	--0:3E	bra_v   FE,
    --5	01--7F=>-80	ncv
    X"00", X"E1",	--0:40	lda	0:E1,		01-
    X"78", X"05",	--0:42	sub	(8:05),		-7F-@09
    X"A0", X"F4",	--0:44	sta	0:F4,		-80
    X"F0", X"4A",	--0:46	bra_n	4A,
    X"80", X"FE",	--0:48	jmp	0:FE,
    X"F2", X"FE",	--0:4A	bra_z	FE,
    X"F4", X"50",	--0:4C	bra_c	50,
    X"80", X"FE",	--0:4E	jmp	0:FE,
    X"F8", X"54",	--0:50	bra_v   54,
    X"80", X"FE",	--0:52	jmp	0:FE,
    --6	-7F-7E=>7F	v
    X"E4", X"E0",	--0:54	cmc,	nop,
    X"10", X"E5",	--0:56	lda	(0:E5),		-7F-@EA
    X"68", X"02",	--0:58	sub	8:02,		7E-
    X"A0", X"F5",	--0:5A	sta	0:F5,		7F
    X"F0", X"FE",	--0:5C	bra_n	FE,
    X"F2", X"FE",	--0:5E	bra_z	FE,
    X"F4", X"FE",	--0:60	bra_c	FE,
    X"F8", X"66",	--0:62	bra_v   66,
    X"80", X"FE",	--0:64	jmp	0:FE,
    --7	01--7E=>7F	c
    X"00", X"E1",	--0:66	lda	0:E1,		01-
    X"78", X"06",	--0:68	sub	(8:06),		-7E-@0A
    X"A0", X"F6",	--0:6A	sta	0:F6,		7F
    X"F0", X"FE",	--0:6C	bra_n	FE,
    X"F2", X"FE",	--0:6E	bra_z	FE,
    X"F4", X"74",	--0:70	bra_c	74,
    X"80", X"FE",	--0:72	jmp	0:FE,
    X"F8", X"FE",	--0:74	bra_v   FE,
    --8	-80-7F=>01	v
    X"E4", X"E0",	--0:76	cmc,	nop,
    X"10", X"E4",	--0:78	lda	(0:E4),		-80-@E8
    X"68", X"03",	--0:7A	sub	8:03,		7F-
    X"A0", X"F7",	--0:7C	sta	0:F7,		01
    X"F0", X"FE",	--0:7E	bra_n	FE,
    X"F2", X"FE",	--0:80	bra_z	FE,
    X"F4", X"FE",	--0:82	bra_c	FE,
    X"F8", X"88",	--0:84	bra_v   88,
    X"80", X"FE",	--0:86	jmp	0:FE,
    --9	7F--80=>-01	ncv
    X"00", X"E3",	--0:88	lda	0:E3,		7F-
    X"78", X"04",	--0:8A	sub	(8:04),		-80-@08
    X"A0", X"F8",	--0:8C	sta	0:F8,		-01
    X"F0", X"92",	--0:8E	bra_n	92,
    X"80", X"FE",	--0:90	jmp	0:FE,
    X"F2", X"FE",	--0:92	bra_z	FE,
    X"F4", X"98",	--0:94	bra_c	98,
    X"80", X"FE",	--0:96	jmp	0:FE,
    X"F8", X"9C",	--0:98	bra_v   9C,
    X"80", X"FE",	--0:9A	jmp	0:FE,
    --10	-7F--80=>01	
    X"E4", X"E0",	--0:9C	cmc,	nop,
    X"10", X"E5",	--0:9E	lda	(0:E5),		-7F-@E9
    X"78", X"04",	--0:A0	sub	(8:04),		-80-@08
    X"A0", X"F9",	--0:A2	sta	0:F9,		01
    X"F0", X"FE",	--0:A4	bra_n	FE,
    X"F2", X"FE",	--0:A6	bra_z	FE,
    X"F4", X"FE",	--0:A8	bra_c	FE,
    X"F8", X"FE",	--0:AA	bra_v   FE,
    --11	-80--7F=>-01	nc
    X"10", X"E4",	--0:AC	lda	(0:E4),		-80-@E8
    X"78", X"05",	--0:AE	sub	(8:05),		-7F-@09
    X"A0", X"FA",	--0:B0	sta	0:FA,		-01
    X"F0", X"B6",	--0:B2	bra_n	B6,
    X"80", X"FE",	--0:B4	jmp	0:FE,
    X"F2", X"FE",	--0:B6	bra_z	FE,
    X"F4", X"BC",	--0:B8	bra_c	BC,
    X"80", X"FE",	--0:BA	jmp	0:FE,
    X"F8", X"FE",	--0:BC	bra_v   FE,
    --12	7F-7F=>00	z
    X"E4", X"E0",	--0:BE	cmc,	nop,
    X"00", X"E3",	--0:C0	lda	0:E3,		7F-
    X"68", X"03",	--0:C2	sub	8:03,		7F-
    X"A0", X"FB",	--0:C4	sta	0:FB,		00
    X"F0", X"FE",	--0:C6	bra_n	FE,
    X"F2", X"CC",	--0:C8	bra_z	CC,
    X"80", X"FE",	--0:CA	jmp	0:FE,
    X"F4", X"FE",	--0:CC	bra_c	FE,
    X"F8", X"FE",	--0:CE	bra_v   FE,
    --13	00-01=>-01	nc
    X"68", X"01",	--0:D0	sub	8:01,		01-
    X"A0", X"FC",	--0:D2	sta	0:FC,		-01
    X"F0", X"D8",	--0:D4	bra_n	D8,
    X"80", X"FE",	--0:D6	jmp	0:FE,
    X"F2", X"FE",	--0:D8	bra_z	FE,
    X"F4", X"DE",	--0:DA	bra_c	DE,
    X"80", X"FE",	--0:DC	jmp	0:FE,
    X"80", X"EC",	--0:DE	jmp	0:EC,

    X"00", X"01", X"7E", X"7F", --0:E0	00, 01, 7E, 7F,
    X"E8", X"E9", X"EA", X"00", --0:E4	-80-@E8, -7F-@E9, -7E-@EA,
    X"80", X"81", X"82", X"00", --0:E8	-80, -7F, -7E,

    X"F8", X"FE",	--0:EC	bra_v   FE,
    X"88", X"0C",	--0:EE	jmp	8:0C,

    X"00", X"01", X"FF", X"80", --0:F0	FF, FE, 00, 7F,		00, 01, -1, -80,
    X"80", X"03", X"7F", X"01", --0:F4	7F, FC, 80, FE,		-80, 03, 7F, 01,
    X"FF", X"01", X"FF", X"00", --0:F8	00, FE, 00, FF,		-1, 01, -1, 00,
    X"FF", X"00",	--0:FC		00,			-1,

    X"80", X"FE"	--0:FE	jmp	0:FE
    );
  variable memexp2       : BYTE_MEMORY (0 to 17) := -- expected value
    (
    X"00", X"01", X"7E", X"7F", --8:00	00, 01, 7E, 7F,
    X"08", X"09", X"0A", X"00", --8:04	-80-@08, -7F-@09, -7E-@0A,
    X"80", X"81", X"82", X"00", --8:08	-80, -7F, -7E, FF-00
    X"08", X"00",	--8:0C	lda     8:00,
    X"A8", X"0B",	--8:0E	sta     8:0B,
    X"88", X"10"	--8:10	jmp	8:10,
    );
  variable memory1       : BYTE_MEMORY (0 to 255) :=
    (
    --1	00-00=>00	z
    X"E1", X"E0",	--0:00	cla,	nop,
    X"68", X"00",	--0:02	sub     8:00,		00-
    X"A0", X"F0",	--0:04	sta	0:F0,		00
    X"F0", X"FE",	--0:06	bra_n	FE,
    X"F2", X"0C",	--0:08	bra_z	0C,
    X"80", X"FE",	--0:0A	jmp	0:FE,
    X"F4", X"FE",	--0:0C	bra_c	FE,
    X"F8", X"FE",	--0:0E	bra_v   FE,
    --2	7F-7E=>01
    X"00", X"E3",	--0:10	lda	0:E3		7F-
    X"68", X"02",	--0:12	sub	8:02,		7E-
    X"A0", X"F1",	--0:14	sta	0:F1,		01
    X"F0", X"FE",	--0:16	bra_n	FE,
    X"F2", X"FE",	--0:18	bra_z	FE,
    X"F4", X"FE",	--0:1A	bra_c	FE,
    X"F8", X"FE",	--0:1C	bra_v   FE,
    --3	7E-7F=>-01	nc
    X"00", X"E2",	--0:1E	lda	0:E2,		7E-
    X"68", X"03",	--0:20	sub	8:03,		7F-
    X"A0", X"F2",	--0:22	sta	0:F2,		-01
    X"F0", X"28",	--0:24	bra_n	28,
    X"80", X"FE",	--0:26	jmp	0:FE,
    X"F2", X"FE",	--0:28	bra_z	FE,
    X"F4", X"2E",	--0:2A	bra_c	2E,
    X"80", X"FE",	--0:2C	jmp	0:FE,
    X"F8", X"FE",	--0:2E	bra_v   FE,
    --4	-7F-0-B=>-02	n
    X"10", X"E5",	--0:30	lda	(0:E5),		-7F-@E9
    X"68", X"00",	--0:32	sub	8:00,		00-
    X"A0", X"F3",	--0:34	sta	0:F3,		-80
    X"F0", X"3A",	--0:36	bra_n	3A,
    X"80", X"FE",	--0:38	jmp	0:FE,
    X"F2", X"FE",	--0:3A	bra_z	FE,
    X"F4", X"FE",	--0:3C	bra_c	FE,
    X"F8", X"FE",	--0:3E	bra_v   FE,
    --5	01--7F=>-80	ncv
    X"00", X"E1",	--0:40	lda	0:E1,		01-
    X"78", X"05",	--0:42	sub	(8:05),		-7F-@09
    X"A0", X"F4",	--0:44	sta	0:F4,		-80
    X"F0", X"4A",	--0:46	bra_n	4A,
    X"80", X"FE",	--0:48	jmp	0:FE,
    X"F2", X"FE",	--0:4A	bra_z	FE,
    X"F4", X"50",	--0:4C	bra_c	50,
    X"80", X"FE",	--0:4E	jmp	0:FE,
    X"F8", X"54",	--0:50	bra_v   54,
    X"80", X"FE",	--0:52	jmp	0:FE,
    --6	-7F-7E=>7F	v
    X"E4", X"E0",	--0:54	cmc,	nop,
    X"10", X"E5",	--0:56	lda	(0:E5),		-7F-@EA
    X"68", X"02",	--0:58	sub	8:02,		7E-
    X"A0", X"F5",	--0:5A	sta	0:F5,		7F
    X"F0", X"FE",	--0:5C	bra_n	FE,
    X"F2", X"FE",	--0:5E	bra_z	FE,
    X"F4", X"FE",	--0:60	bra_c	FE,
    X"F8", X"66",	--0:62	bra_v   66,
    X"80", X"FE",	--0:64	jmp	0:FE,
    --7	01--7E=>7F	c
    X"00", X"E1",	--0:66	lda	0:E1,		01-
    X"78", X"06",	--0:68	sub	(8:06),		-7E-@0A
    X"A0", X"F6",	--0:6A	sta	0:F6,		7F
    X"F0", X"FE",	--0:6C	bra_n	FE,
    X"F2", X"FE",	--0:6E	bra_z	FE,
    X"F4", X"74",	--0:70	bra_c	74,
    X"80", X"FE",	--0:72	jmp	0:FE,
    X"F8", X"FE",	--0:74	bra_v   FE,
    --8	-80-7F=>01	v
    X"E4", X"E0",	--0:76	cmc,	nop,
    X"10", X"E4",	--0:78	lda	(0:E4),		-80-@E8
    X"68", X"03",	--0:7A	sub	8:03,		7F-
    X"A0", X"F7",	--0:7C	sta	0:F7,		01
    X"F0", X"FE",	--0:7E	bra_n	FE,
    X"F2", X"FE",	--0:80	bra_z	FE,
    X"F4", X"FE",	--0:82	bra_c	FE,
    X"F8", X"88",	--0:84	bra_v   88,
    X"80", X"FE",	--0:86	jmp	0:FE,
    --9	7F--80=>-01	ncv
    X"00", X"E3",	--0:88	lda	0:E3,		7F-
    X"78", X"04",	--0:8A	sub	(8:04),		-80-@08
    X"A0", X"F8",	--0:8C	sta	0:F8,		-01
    X"F0", X"92",	--0:8E	bra_n	92,
    X"80", X"FE",	--0:90	jmp	0:FE,
    X"F2", X"FE",	--0:92	bra_z	FE,
    X"F4", X"98",	--0:94	bra_c	98,
    X"80", X"FE",	--0:96	jmp	0:FE,
    X"F8", X"9C",	--0:98	bra_v   9C,
    X"80", X"FE",	--0:9A	jmp	0:FE,
    --10	-7F--80=>01	
    X"E4", X"E0",	--0:9C	cmc,	nop,
    X"10", X"E5",	--0:9E	lda	(0:E5),		-7F-@E9
    X"78", X"04",	--0:A0	sub	(8:04),		-80-@08
    X"A0", X"F9",	--0:A2	sta	0:F9,		01
    X"F0", X"FE",	--0:A4	bra_n	FE,
    X"F2", X"FE",	--0:A6	bra_z	FE,
    X"F4", X"FE",	--0:A8	bra_c	FE,
    X"F8", X"FE",	--0:AA	bra_v   FE,
    --11	-80--7F=>-01	nc
    X"10", X"E4",	--0:AC	lda	(0:E4),		-80-@E8
    X"78", X"05",	--0:AE	sub	(8:05),		-7F-@09
    X"A0", X"FA",	--0:B0	sta	0:FA,		-01
    X"F0", X"B6",	--0:B2	bra_n	B6,
    X"80", X"FE",	--0:B4	jmp	0:FE,
    X"F2", X"FE",	--0:B6	bra_z	FE,
    X"F4", X"BC",	--0:B8	bra_c	BC,
    X"80", X"FE",	--0:BA	jmp	0:FE,
    X"F8", X"FE",	--0:BC	bra_v   FE,
    --12	7F-7F=>00	z
    X"E4", X"E0",	--0:BE	cmc,	nop,
    X"00", X"E3",	--0:C0	lda	0:E3,		7F-
    X"68", X"03",	--0:C2	sub	8:03,		7F-
    X"A0", X"FB",	--0:C4	sta	0:FB,		00
    X"F0", X"FE",	--0:C6	bra_n	FE,
    X"F2", X"CC",	--0:C8	bra_z	CC,
    X"80", X"FE",	--0:CA	jmp	0:FE,
    X"F4", X"FE",	--0:CC	bra_c	FE,
    X"F8", X"FE",	--0:CE	bra_v   FE,
    --13	00-01=>-01	nc
    X"68", X"01",	--0:D0	sub	8:01,		01-
    X"A0", X"FC",	--0:D2	sta	0:FC,		-01
    X"F0", X"D8",	--0:D4	bra_n	D8,
    X"80", X"FE",	--0:D6	jmp	0:FE,
    X"F2", X"FE",	--0:D8	bra_z	FE,
    X"F4", X"DE",	--0:DA	bra_c	DE,
    X"80", X"FE",	--0:DC	jmp	0:FE,
    X"80", X"EC",	--0:DE	jmp	0:EC,

    X"00", X"01", X"7E", X"7F", --0:E0	00, 01, 7E, 7F,
    X"E8", X"E9", X"EA", X"00", --0:E4	-80-@E8, -7F-@E9, -7E-@EA,
    X"80", X"81", X"82", X"00", --0:E8	-80, -7F, -7E,

    X"F8", X"FE",	--0:EC	bra_v   FE,
    X"88", X"0C",	--0:EE	jmp	8:0C,

    X"FF", X"FE", X"00", X"7F", --0:F0	FF, FE, 00, 7F,		00, 01, -1, -80,
    X"7F", X"FC", X"80", X"FE", --0:F4	7F, FC, 80, FE,		-80, 03, 7F, 01,
    X"00", X"FE", X"00", X"FF", --0:F8	00, FE, 00, FF,		-1, 01, -1, 00,
    X"00", X"00",	--0:FC		00,			-1,

    X"80", X"FE"	--0:FE	jmp	0:FE
    );
  variable memory2       : BYTE_MEMORY (0 to 17) :=
    (
    X"00", X"01", X"7E", X"7F", --8:00	00, 01, 7E, 7F,
    X"08", X"09", X"0A", X"00", --8:04	-80-@08, -7F-@09, -7E-@0A,
    X"80", X"81", X"82", X"FF", --8:08	-80, -7F, -7E, FF-00
    X"08", X"00",	--8:0C	lda     8:00,
    X"A8", X"0B",	--8:0E	sta     8:0B,
    X"88", X"10"	--8:10	jmp	8:10,
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
      if (ia >= 256 and ia < 2048) or (ia >= 2066) then
        databus <= HI_IMP_8;
        assert FALSE
          report "Simulation Error : adbus has illegal address when reading."
          severity FAILURE;
      else 
	if ia < 256 then
	  databus <= Drive (BVtoMVL7V (memory1 (ia)));
	else
	  databus <= Drive (BVtoMVL7V (memory2 (ia - 2048)));
	end if;
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then -- memory write
      wait until write_mem = '0';
      if ia < 256 then
        memory1 (ia) := MVL7VtoBV (Drive (databus));
      elsif ia >= 2048 and ia < 2066 then
        memory2 (ia - 2048) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;

    if (ia = 255) or -- X"0:FF"
       (ia = 2065)    -- X"8:11"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
end BEHAVIORAL;
