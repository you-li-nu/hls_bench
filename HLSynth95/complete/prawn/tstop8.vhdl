--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "op8"
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
--          access twice on address =  125(X"0:7D") (illegal condition)
--                          address =  127(X"0:7F") (legal condition)
--
-- (2) Tested Instructions
--      Mainly tested in this vector
--	  push
--	  pop
--	  pushf
--	  popf
--      tested side-effectly
--        lda direct
--        sta direct
--	  bra_n
--	  bra_nn
--	  bra_z
--	  bra_nz
--	  bra_c
--	  bra_nc
--	  bra_v
--	  bra_nv
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
    --1 push
    X"00", X"60",       --0:00  lda,    0:60,		00-
    X"EC", 		--0:02  push,
    X"00", X"61",       --0:03  lda     0:61,           FF-
    X"EC", 		--0:05  push,
    X"00", X"62",       --0:06  lda	0:62,		55-
    X"EC",		--0:08  push,
    X"00", X"63",       --0:09  lda	0:63,		AA-
    X"EC", 		--0:0B  push,
    X"00", X"64",       --0:0C  lda     0:64,           01-
    X"AF", X"FF",       --0:0E  sta     F:FF,
    X"00", X"65",       --0:10  lda     0:65,           33-
    X"EC", 		--0:12  push,
    X"00", X"60",       --0:13  lda     0:60,           00-
    X"EC", 		--0:15  push,
    X"0F", X"FF",       --0:16  lda     F:FF,           (FF)
    X"A0", X"70",       --0:18  sta     0:70,           FF
    X"00", X"66",       --0:1A  lda     0:66,           FB-
    X"AF", X"FF",       --0:1C  sta     F:FF,           FB
    --2 pop
    X"EE", 		--0:1E  pop,
    X"A0", X"71",       --0:1F  sta	0:71,		AA
    X"EE", 		--0:21  pop,
    X"A0", X"72",       --0:22  sta	0:72,		55
    X"EE", 		--0:24  pop,
    X"A0", X"73",       --0:25  sta	0:73,		FF
    X"EE", 		--0:27  pop,
    X"A0", X"74",       --0:28  sta	0:74,		00
    X"EE", 		--0:2A  pop,
    X"A0", X"75",       --0:2B  sta	0:75,		FF
    X"EE", 		--0:2D  pop,
    X"A0", X"76",       --0:2E  sta	0:76,		33
    X"0F", X"FF",       --0:30  lda	F:FF,		(01)
    X"A0", X"77",       --0:32  sta	0:77,		01
    --3 popf & pushf
    X"00", X"67",       --0:34  lda	0:67,		EE-
    X"AF", X"FF",       --0:36  sta	F:FF,
    X"EF", 		--0:38  popf,
    X"F0", X"7C",       --0:39  bra_n	0:7C,
    X"F2", X"7C",       --0:3B  bra_z	0:7C,
    X"F4", X"7C",       --0:3D  bra_c	0:7C,
    X"F8", X"7C",       --0:3F  bra_v	0:7C,
    X"00", X"68",       --0:41  lda	0:68,		DF-
    X"AF", X"FF",       --0:43  sta	F:FF,
    X"ED", 		--0:45  pushf,
    --
    X"00", X"69",       --0:46  lda	0:69,		ED-
    X"AF", X"FF",       --0:48  sta	F:FF,
    X"EF", 		--0:4A  popf,
    X"F1", X"7C",       --0:4B  bra_nn	0:7C,
    X"F3", X"7C",       --0:4D  bra_nz	0:7C,
    X"F5", X"7C",       --0:4F  bra_nc	0:7C,
    X"F9", X"7C",       --0:51  bra_nv	0:7C,
    X"00", X"6A",       --0:53  lda	0:6A,		DE-
    X"AF", X"FF",       --0:55  sta	F:FF,
    X"ED", 		--0:57  pushf,
    X"FD", X"7E",	--0:58	bra	7E,

    X"00", X"00", X"00", X"00", X"00", X"00",

    X"00", X"FF", X"55", X"AA",	--0:60	00, FF, 55, AA,
    X"01", X"33", X"FB", X"EE", --0:64	01, 33, FB, EE,
    X"DF", X"ED", X"DE", X"00", --0:68	DF, ED, DE,
    X"00", X"00", X"00", X"00",

    X"FF", X"AA", X"55", X"FF", --0:70	00, 55, AA, 00,	-FF, AA, 55, FF,
    X"00", X"FF", X"33", X"01", --0:74	FF, 00, CC, FE,	-00, FF, 33, 01,
    X"00", X"00", X"00", X"00", --0:78
    X"80", X"7C",	--0:7C	jmp	0:7C,
    X"80", X"7E"	--0:7E	jmp	0:7E,
    );
  variable memexp2       : BYTE_MEMORY (0 to 255) := -- expected value
    (
    X"33", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"1D", X"01", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"FF", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"AA", X"55", X"FF", X"00", X"DD"
    );
  variable memory1       : BYTE_MEMORY (0 to 127) :=
    (
    --1 push
    X"00", X"60",       --0:00  lda,    0:60,		00-
    X"EC", 		--0:02  push,
    X"00", X"61",       --0:03  lda     0:61,           FF-
    X"EC", 		--0:05  push,
    X"00", X"62",       --0:06  lda	0:62,		55-
    X"EC",		--0:08  push,
    X"00", X"63",       --0:09  lda	0:63,		AA-
    X"EC", 		--0:0B  push,
    X"00", X"64",       --0:0C  lda     0:64,           01-
    X"AF", X"FF",       --0:0E  sta     F:FF,
    X"00", X"65",       --0:10  lda     0:65,           33-
    X"EC", 		--0:12  push,
    X"00", X"60",       --0:13  lda     0:60,           00-
    X"EC", 		--0:15  push,
    X"0F", X"FF",       --0:16  lda     F:FF,           (FF)
    X"A0", X"70",       --0:18  sta     0:70,           FF
    X"00", X"66",       --0:1A  lda     0:66,           FB-
    X"AF", X"FF",       --0:1C  sta     F:FF,           FB
    --2 pop
    X"EE", 		--0:1E  pop,
    X"A0", X"71",       --0:1F  sta	0:71,		AA
    X"EE", 		--0:21  pop,
    X"A0", X"72",       --0:22  sta	0:72,		55
    X"EE", 		--0:24  pop,
    X"A0", X"73",       --0:25  sta	0:73,		FF
    X"EE", 		--0:27  pop,
    X"A0", X"74",       --0:28  sta	0:74,		00
    X"EE", 		--0:2A  pop,
    X"A0", X"75",       --0:2B  sta	0:75,		FF
    X"EE", 		--0:2D  pop,
    X"A0", X"76",       --0:2E  sta	0:76,		33
    X"0F", X"FF",       --0:30  lda	F:FF,		(01)
    X"A0", X"77",       --0:32  sta	0:77,		01
    --3 popf & pushf
    X"00", X"67",       --0:34  lda	0:67,		EE-
    X"AF", X"FF",       --0:36  sta	F:FF,
    X"EF", 		--0:38  popf,
    X"F0", X"7C",       --0:39  bra_n	0:7C,
    X"F2", X"7C",       --0:3B  bra_z	0:7C,
    X"F4", X"7C",       --0:3D  bra_c	0:7C,
    X"F8", X"7C",       --0:3F  bra_v	0:7C,
    X"00", X"68",       --0:41  lda	0:68,		DF-
    X"AF", X"FF",       --0:43  sta	F:FF,
    X"ED", 		--0:45  pushf,
    --
    X"00", X"69",       --0:46  lda	0:69,		ED-
    X"AF", X"FF",       --0:48  sta	F:FF,
    X"EF", 		--0:4A  popf,
    X"F1", X"7C",       --0:4B  bra_nn	0:7C,
    X"F3", X"7C",       --0:4D  bra_nz	0:7C,
    X"F5", X"7C",       --0:4F  bra_nc	0:7C,
    X"F9", X"7C",       --0:51  bra_nv	0:7C,
    X"00", X"6A",       --0:53  lda	0:6A,		DE-
    X"AF", X"FF",       --0:55  sta	F:FF,
    X"ED", 		--0:57  pushf,
    X"FD", X"7E",	--0:58	bra	7E,

    X"00", X"00", X"00", X"00", X"00", X"00",

    X"00", X"FF", X"55", X"AA",	--0:60	00, FF, 55, AA,
    X"01", X"33", X"FB", X"EE", --0:64	01, 33, FB, EE,
    X"DF", X"ED", X"DE", X"00", --0:68	DF, ED, DE,
    X"00", X"00", X"00", X"00",

    X"00", X"55", X"AA", X"00", --0:70	00, 55, AA, 00,	-FF, AA, 55, FF,
    X"FF", X"00", X"CC", X"FE", --0:74	FF, 00, CC, FE,	-00, FF, 33, 01,
    X"00", X"00", X"00", X"00", --0:78
    X"80", X"7C",	--0:7C	jmp	0:7C,
    X"80", X"7E"	--0:7E	jmp	0:7E,
    );
  variable memory2       : BYTE_MEMORY (0 to 255) :=
    (
    X"CC", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"E2", X"FE", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"FF", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"55", X"AA", X"00", X"FF", X"FF"
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
      if (ia >= 128) and (ia < 3840)  then
        databus <= HI_IMP_8;
        assert FALSE
          report "Simulation Error : adbus has illegal address when reading."
          severity FAILURE;
      else 
	if (ia < 128) then
	  databus <= Drive (BVtoMVL7V (memory1 (ia)));
	else
	  databus <= Drive (BVtoMVL7V (memory2 (ia - 3840)));
	end if;
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then -- memory write
      wait until write_mem = '0';
      if ia < 128 then
        memory1 (ia) := MVL7VtoBV (Drive (databus));
      elsif ia >= 3840 then
        memory2 (ia - 3840) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;

    if (ia = 125) or -- X"0:7D"
       (ia = 127)    -- X"A:7F"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
end BEHAVIORAL;
