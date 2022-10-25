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
--        expected set :  variable memexp3
--        		  variable memexp6
--        working set  :  variable memory1 (read only)
--        		  variable memory2 (read only)
--        		  variable memory3
--        		  variable memory4 (read only)
--        		  variable memory5 (read only)
--        		  variable memory6
--      Control process :
--        the condition of the end of the simulatoin :
--          access twice on address =  283(X"1:1B")
--
-- (2) Tested Instructions
--      Mainly these which are tested in this vector are instructions and
--      functions related to interrupt handling.
--
--      There are two process which handshake data. They are switched by
--      schedulers. Interrupt signal randamly invoke schedulers. 
--      Two process have critical region guarded by interrupt enable flag. 
--      Interrupt signal randomly switch these two process while data are
--      passed from process1 to process2. After all of data are passed,
--      process1 show the end of the simulation to enter infinite loop
--      which have specified address.
--
--      process1   : take data from buffer and sum them
--      process2   : take data from data area and put to buffer
--      scheduler1 : switch process1 to process2
--      scheduler2 : switch process2 to process1
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

  variable memexp3       : BYTE_MEMORY (0 to 47) := -- expected value
    (
    X"00",		--2:00	FLAG
    X"88",		--2:01	SUM
    X"21",		--2:02	DP
    X"10",		--2:03	DATA
    X"01",		--2:04	constant 1
    ----TEMPTEMPTEMPTEMPTEMPTEMP
    X"20",		--2:05	constant X"12"
--    X"2F",		--2:05	constant X"2F"
    X"FB",		--2:06	process table for process 1(save SP here)
    X"EB",		--2:07	process table for process 2(save SP here)
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    -- data area from 2:10 to 2:2F
    X"00", X"01", X"02", X"03", X"04", X"05", X"06", X"07",
    X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F",
    X"10", X"11", X"12", X"13", X"14", X"15", X"16", X"17",
    X"18", X"19", X"1A", X"1B", X"1C", X"1D", X"1E", X"1F"
    );
  variable memexp6       : BYTE_MEMORY (0 to 31) := -- expected value
    (
    X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
    X"FF", X"FF", X"FF", X"10", X"10", X"10", X"01", X"FF",
    X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
    X"FF", X"FF", X"FF", X"00", X"1A", X"03", X"00", X"EF"
    );
  variable memory1	 : BYTE_MEMORY (0 to 17) :=
    (
    -- process 1 (infinite loop)
    -- if (flag <> 1) then
    --   flag := 0;
    --   sum := sum + data;
    -- end if;
    X"E5", 		--0:00	sti,		interrupt enable
    X"02", X"00",	--0:01	lda	2:00,	fetch flag
    X"F2", X"01",	--0:03	bra_z	01,
    X"E7", X"E1",	--0:05	cli,	cla,	start critical region 
    X"A2", X"00",	--0:07	sta	2:00,	flag := 0;
    X"02", X"01",	--0:09	lda	2:01,	fetch sum
    X"42", X"03",	--0:0B	add	2:03,	sum + data
    X"A2", X"01",	--0:0D	sta	2:01,   sum := sum + data
    X"E5", 		--0:0F	sti,		end critical region
    X"FD", X"01"	--0:10	bra	01,	continue
    );
  variable memory2       : BYTE_MEMORY (0 to 27) :=
    (
    -- process 2 (infinite loop)
    -- if (flag = 0) then
    --   flag := X"FF";
    --   data := (dp);
    -- end if;
    -- dp := dp + 1;
    -- if (dp > X"2F") then
    --   STOP
    -- end if;
    X"02", X"00",	--1:00	lda	2:00,	fetch flag
    X"F3", X"00",	--1:02	bra_nz	00,
    X"F5", X"07",	--1:04	bra_nc	07,
    X"E4",		--1:06	cmc,
    X"E7", X"E2",	--1:07	cli,	cma,	start critical region 
    X"A2", X"00",	--1:09	sta	2:00,	flag := X"FF";
    X"12", X"02",	--1:0B	lda	(2:02),	fetch contents of dp
    X"A2", X"03",	--1:0D	sta	2:03,   data := (dp)
    X"E5", 		--1:0F	sti,		end critical region
    X"02", X"02",	--1:10	lda	2:02,	fetch dp
    X"42", X"04",	--1:12	add	2:04,	dp + 1
    X"A2", X"02",	--1:14	sta	2:02,	dp := dp + 1
    X"62", X"05",	--1:16	sub	2:05,	dp - X"2F"
    X"FE", X"00",	--1:18	bra_le	00,	continue
    X"81", X"1A"	--1:1A	jmp	1:1A,	STOP
    );
  variable memory3       : BYTE_MEMORY (0 to 47) :=
    (
    X"00",		--2:00	FLAG -- handshake flag
    X"00",		--2:01	SUM
    X"10",		--2:02	DP -- data start at 2:10
    X"00",		--2:03	DATA -- handshake buffer
    X"01",		--2:04	constant 1
    ----TEMPTEMPTEMPTEMPTEMPTEMP
    X"20",		--2:05	constant X"12"
--    X"2F",		--2:05	constant X"2F"
    X"00",		--2:06	process table for process 1(save SP here)
    X"EB",		--2:07	process table for process 2(save SP here)
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    -- data area from 2:10 to 2:2F
    X"00", X"01", X"02", X"03", X"04", X"05", X"06", X"07",
    X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F",
    X"10", X"11", X"12", X"13", X"14", X"15", X"16", X"17",
    X"18", X"19", X"1A", X"1B", X"1C", X"1D", X"1E", X"1F"
    );
  variable memory4       : BYTE_MEMORY (0 to 11) :=
    (
    -- interrupt routine : scheduler 1 (change process1 to process2)
    X"FF", X"EC",	--3:00	"trash",push,		save ac
    X"0F", X"FF",	--3:02	lda	F:FF,
    X"A2", X"06",	--3:04	sta,	2:06,	save SP for process1
    X"02", X"07",	--3:06	lda	2:07,
    X"AF", X"FF",	--3:08	sta	F:FF,	load SP for process2
    X"EE", 		--3:0A	pop,		load ac
    X"E6"		--3:0B	irt,		start process2
    );
  variable memory5       : BYTE_MEMORY (0 to 11) :=
    (
    -- interrupt routine : scheduler 2 (change process2 to process1)
    X"FF", X"EC",	--4:00	"trash",push,		save ac
    X"0F", X"FF",	--4:02	lda	F:FF,
    X"A2", X"07",	--4:04	sta,	2:07,	save SP for process2
    X"02", X"06",	--4:06	lda	2:06,
    X"AF", X"FF",	--4:08	sta	F:FF,	load SP for process1
    X"EE", 		--4:0A	pop,		load ac
    X"E6"		--4:0B	irt,		start process1
    );
  variable memory6       : BYTE_MEMORY (0 to 31) := -- for stack
    (
    X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
    X"FF", X"FF", X"FF", X"FF", X"10", X"00", X"01", X"FF",
    X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
    X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF"
    );
-- END MEMORY CONTENTS
    variable ia, finish         : integer := 0;
  begin
    wait on read_mem, write_mem;
    ia := B2I (adbus);

    if finish = 2 then -- examine simulation results
      assert memexp3 = memory3
        report "Simulation Error : Memory3 has unexpected contents."
        severity FAILURE;
      assert memexp6 = memory6
        report "Simulation Error : Memory6 has unexpected contents."
        severity FAILURE;
      assert finish = 0
	report "Simulation is done successfully." severity ERROR;

    elsif read_mem = '1' then -- memory read
      if ((ia >= 18) and (ia < 256)) or
	 ((ia >= 284) and (ia < 512)) or
	 ((ia >= 560) and (ia < 768)) or
	 ((ia >= 780) and (ia < 1024)) or
	 ((ia >= 1036) and (ia < 4064)) then
        databus <= HI_IMP_8;
        assert FALSE
          report "Simulation Error : adbus has illegal address when reading."
          severity FAILURE;
      else 
	if (ia < 18) then
	  databus <= Drive (BVtoMVL7V (memory1 (ia)));
	elsif (ia < 284) then 
	  databus <= Drive (BVtoMVL7V (memory2 (ia - 256)));
	elsif (ia < 560) then 
	  databus <= Drive (BVtoMVL7V (memory3 (ia - 512)));
	elsif (ia < 780) then 
	  databus <= Drive (BVtoMVL7V (memory4 (ia - 768)));
	elsif (ia < 1036) then 
	  databus <= Drive (BVtoMVL7V (memory5 (ia - 1024)));
	else
	  databus <= Drive (BVtoMVL7V (memory6 (ia - 4064)));
	end if;
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then -- memory write
      wait until write_mem = '0';
      if (ia >= 512) and (ia < 560) then
        memory3 (ia - 512) := MVL7VtoBV (Drive (databus));
      elsif ia >= 4064 then
        memory6 (ia - 4064) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;

    if (ia = 283)    -- X"1:1B"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
  makeint : process 
    variable int0 : BIT_VECTOR (7 downto 0) := X"01";
    variable int1 : BIT_VECTOR (7 downto 0) := X"03";
    variable int2 : BIT_VECTOR (7 downto 0) := X"04";
  begin
    -- change process 1 to 2
    wait for 5000 ns;
    interrupt <= '1';
    wait until inta = '1';
    interrupt <= '0';
    databus <= Drive (BVtoMVL7V (int1));
    wait until inta = '0';
    databus <= HI_IMP_8;
    wait until inta = '1';
    databus <= Drive (BVtoMVL7V (int0));
    wait until inta = '0';
    databus <= HI_IMP_8;
    -- change process 2 to 1
    wait for 25000 ns;
    interrupt <= '1';
    wait until inta = '1';
    interrupt <= '0';
    databus <= Drive (BVtoMVL7V (int2));
    wait until inta = '0';
    databus <= HI_IMP_8;
    wait until inta = '1';
    databus <= Drive (BVtoMVL7V (int0));
    wait until inta = '0';
    databus <= HI_IMP_8;
    wait for 20000 ns;
  end process makeint;
end BEHAVIORAL;
