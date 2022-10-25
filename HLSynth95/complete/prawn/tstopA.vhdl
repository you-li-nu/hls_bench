--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "opA"
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
--        expected set :  variable memexp2
--        		  variable memexp4
--        working set  :  variable memory1 (read only)
--        		  variable memory2
--        		  variable memory3 (read only)
--        		  variable memory4
--      Control process :
--        the condition of the end of the simulatoin :
--          access twice on address =  299(X"1:2B")
--
-- (2) Tested Instructions
--      Mainly tested in this vector
--	  jsr
--	  jrt
--	  bsr
--	  brt
--	  sti
--	  cli
--	  pushf
--	  popf
--      tested side-effectly
--        lda direct
--        sta direct
--        add direct
--        sub direct
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

  variable memexp2       : BYTE_MEMORY (0 to 85) := -- expected value
    (
    --1 jsr
    X"C5", X"0A",       --1:00  jsr,    5:0A,
    --2 bsr
    X"0F", X"FF",	--1:02  lda	F:FF,		
    X"61", X"52",       --1:04  sub     1:52,
    X"AF", X"FF",       --1:06  sta     F:FF,
    X"FC", X"30",	--1:08  bsr	30,
    --3 popf & pushf
    X"01", X"51",       --1:0A  lda	1:51,
    X"41", X"54",	--1:0C  add	1:54,
    X"AF", X"FF",       --1:0E  sta	F:FF,
    X"EF", 		--1:10  popf,
    X"0F", X"FF",       --1:11  lda     F:FF,
    X"61", X"52",       --1:13  sub     1:52,
    X"AF", X"FF",       --1:15  sta     F:FF,
    X"ED", 		--1:17  pushf,
    X"0F", X"FF",       --1:18  lda     F:FF,
    X"41", X"54",       --1:1A  add     1:54,
    X"AF", X"FF",       --1:1C  sta     F:FF,
    X"EF", 		--1:1E  popf,
    X"0F", X"FF",       --1:1F  lda     F:FF,
    X"61", X"52",       --1:21  sub     1:52,
    X"AF", X"FF",       --1:23  sta     F:FF,
    X"ED", 		--1:25  pushf,
    X"0F", X"FF",       --1:26  lda     F:FF,
    X"A1", X"55",       --1:28  sta     1:55,
    X"81", X"2A",       --1:2A  jmp	1:2A
    X"00", X"00", X"00", X"00",
    --4 subroutine(short branch)
    X"0F", X"FF",       --1:30  lda     F:FF,
    X"A1", X"53",       --1:32  sta     1:53,
    X"01", X"51",       --1:34  lda     1:51,
    X"AF", X"FF",       --1:36  sta     F:FF,
    X"E7", X"ED",	--1:38  cli,	pushf
    X"0F", X"FF",       --1:3A  lda     F:FF,
    X"A1", X"51",       --1:3C  sta     1:51,
    X"01", X"53",       --1:3E  lda     1:53,
    X"AF", X"FF",       --1:40  sta     F:FF,
    X"E3", 		--1:42  brt,
    X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    --5 data area
    X"FD",	--expect FD
    X"ED",	--expect ED
    X"02",	--constant 2
    X"FC",	--expect FC
    X"01",	--constant 1
    X"EB"	--expect EB
    );
  variable memexp4       : BYTE_MEMORY (0 to 31) := -- expected value
    (
    X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
    X"FF", X"FF", X"FF", X"01", X"11", X"01", X"11", X"FF",
    X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
    X"FF", X"FF", X"FF", X"FF", X"0A", X"02", X"01", X"EB"
    );
  variable memory1	 : BYTE_MEMORY (0 to 1) :=
    (
    X"81", X"00"	--0:00	jmp	1:00,
    );
  variable memory2       : BYTE_MEMORY (0 to 85) :=
    (
    --1 jsr
    X"C5", X"0A",       --1:00  jsr,    5:0A,
    --2 bsr
    X"0F", X"FF",	--1:02  lda	F:FF,		
    X"61", X"52",       --1:04  sub     1:52,
    X"AF", X"FF",       --1:06  sta     F:FF,
    X"FC", X"30",	--1:08  bsr	30,
    --3 popf & pushf
    X"01", X"51",       --1:0A  lda	1:51,
    X"41", X"54",	--1:0C  add	1:54,
    X"AF", X"FF",       --1:0E  sta	F:FF,
    X"EF", 		--1:10  popf,
    X"0F", X"FF",       --1:11  lda     F:FF,
    X"61", X"52",       --1:13  sub     1:52,
    X"AF", X"FF",       --1:15  sta     F:FF,
    X"ED", 		--1:17  pushf,
    X"0F", X"FF",       --1:18  lda     F:FF,
    X"41", X"54",       --1:1A  add     1:54,
    X"AF", X"FF",       --1:1C  sta     F:FF,
    X"EF", 		--1:1E  popf,
    X"0F", X"FF",       --1:1F  lda     F:FF,
    X"61", X"52",       --1:21  sub     1:52,
    X"AF", X"FF",       --1:23  sta     F:FF,
    X"ED", 		--1:25  pushf,
    X"0F", X"FF",       --1:26  lda     F:FF,
    X"A1", X"55",       --1:28  sta     1:55,
    X"81", X"2A",       --1:2A  jmp	1:2A
    X"00", X"00", X"00", X"00",
    --4 subroutine(short branch)
    X"0F", X"FF",       --1:30  lda     F:FF,
    X"A1", X"53",       --1:32  sta     1:53,
    X"01", X"51",       --1:34  lda     1:51,
    X"AF", X"FF",       --1:36  sta     F:FF,
    X"E7", X"ED",	--1:38  cli,	pushf
    X"0F", X"FF",       --1:3A  lda     F:FF,
    X"A1", X"51",       --1:3C  sta     1:51,
    X"01", X"53",       --1:3E  lda     1:53,
    X"AF", X"FF",       --1:40  sta     F:FF,
    X"E3", 		--1:42  brt,
    X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",
    --5 data area
    X"00",	--expect FD
    X"EF",	--expect ED
    X"02",	--constant 2
    X"00",	--expect FC
    X"01",	--constant 1
    X"00"	--expect EB
    );
  variable memory3       : BYTE_MEMORY (0 to 19) :=
    (
    X"0F", X"FF",       --5:0A  lda     F:FF,
    X"A1", X"50",       --5:0C  sta     1:50,
    X"01", X"51",       --5:0E  lda     1:51,
    X"AF", X"FF",       --5:10  sta     F:FF,
    X"E5", X"ED",	--5:12  sti,	pushf
    X"0F", X"FF",       --5:14  lda     F:FF,
    X"A1", X"51",       --5:16  sta     1:51,
    X"01", X"50",       --5:18  lda     1:50,
    X"AF", X"FF",       --5:1A  sta     F:FF,
    X"DF", X"00"	--5:1C  jrt,
    );
  variable memory4       : BYTE_MEMORY (0 to 31) :=
    (
    X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
    X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
    X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
    X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF"
    );
-- END MEMORY CONTENTS
    variable ia, finish         : integer := 0;
  begin
    wait on read_mem, write_mem;
    ia := B2I (adbus);

    if finish = 2 then -- examine simulation results
      assert memexp2 = memory2
        report "Simulation Error : Memory2 has unexpected contents."
        severity FAILURE;
      assert memexp4 = memory4
        report "Simulation Error : Memory4 has unexpected contents."
        severity FAILURE;
      assert finish = 0
	report "Simulation is done successfully." severity ERROR;

    elsif read_mem = '1' then -- memory read
      if ((ia >= 2) and (ia < 256)) or
	 ((ia >= 342) and (ia < 1290)) or
	 ((ia >= 1310) and (ia < 4064)) then
        databus <= HI_IMP_8;
        assert FALSE
          report "Simulation Error : adbus has illegal address when reading."
          severity FAILURE;
      else 
	if (ia < 2) then
	  databus <= Drive (BVtoMVL7V (memory1 (ia)));
	elsif (ia < 342) then 
	  databus <= Drive (BVtoMVL7V (memory2 (ia - 256)));
	elsif (ia < 1310) then 
	  databus <= Drive (BVtoMVL7V (memory3 (ia - 1290)));
	else
	  databus <= Drive (BVtoMVL7V (memory4 (ia - 4064)));
	end if;
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then -- memory write
      wait until write_mem = '0';
      if (ia >= 256) and (ia < 342) then
        memory2 (ia - 256) := MVL7VtoBV (Drive (databus));
      elsif ia >= 4064 then
        memory4 (ia - 4064) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;

    if (ia = 299)    -- X"1:2B"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
end BEHAVIORAL;
