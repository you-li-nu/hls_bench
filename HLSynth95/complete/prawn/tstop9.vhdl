--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Behavioral Memory Model for test named "op9"
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
--        working set  :  variable memory1 (no write is occured)
--        		  variable memory2 (only Stack Pointer is written)
--      Control process :
--        the condition of the end of the simulatoin :
--          access twice on address =  253(X"0:FD") (illegal condition)
--                          address =  255(X"0:FF") (legal condition)
--
-- (2) Tested Instructions
--      Mainly tested in this vector
--	  bra_n
--	  bra_nn
--	  bra_z
--	  bra_nz
--	  bra_c
--	  bra_nc
--	  bra_v
--	  bra_nv
--	  bra_hi
--	  bra_lo
--	  bra_lt
--	  bra_gt
--	  bra_le
--	  bra_ge
--      tested side-effectly
--	  popf
--	  nop
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

  variable memexp2       : BYTE_MEMORY (0 to 15) := -- expected value
    (
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"FF", X"01", X"02", X"03", X"09", X"0A", X"0C", X"00"
    );
  variable memory1       : BYTE_MEMORY (0 to 255) :=
    (
    --1 popf 0000
    X"EF", X"E0",       --0:00  popf,	nop,
    X"F0", X"FC",       --0:02  bra_n	0:FC,
    X"E0", X"E0",       --0:04  nop,	nop,
    X"F1", X"0A",       --0:06  bra_nn	0:0A,
    X"FD", X"FC",       --0:08  bra	0:FC,
    X"F2", X"FC",       --0:0A  bra_z	0:FC,
    X"E0", X"E0",       --0:0C  nop,	nop,
    X"F3", X"12",       --0:0E  bra_nz	0:12,
    X"FD", X"FC",       --0:10  bra	0:FC,
    X"F4", X"FC",       --0:12  bra_c	0:FC,
    X"E0", X"E0",       --0:14  nop,	nop,
    X"F5", X"1A",       --0:16  bra_nc	0:1A,
    X"FD", X"FC",       --0:18  bra	0:FC,
    X"F6", X"1E",       --0:1A  bra_hi	0:1E,
    X"FD", X"FC",       --0:1C  bra	0:FC,
    X"F7", X"FC",       --0:1E  bra_lo	0:FC,
    X"E0", X"E0",       --0:20  nop,	nop,
    X"F8", X"FC",       --0:22  bra_v	0:FC,
    X"E0", X"E0",       --0:24  nop,	nop,
    X"F9", X"2A",       --0:26  bra_nv	0:2A,
    X"FD", X"FC",       --0:28  bra	0:FC,
    X"FA", X"FC",       --0:2A  bra_lt	0:FC,
    X"E0", X"E0",       --0:2C  nop,	nop,
    X"FB", X"32",       --0:2E  bra_ge	0:32,
    X"FD", X"FC",       --0:30  bra	0:FC,
    X"FE", X"FC",       --0:32  bra_le	0:FC,
    X"E0", X"E0",       --0:34  nop,	nop,
    X"FF", X"40",       --0:36  bra_gt	0:40,
    X"FD", X"FC",       --0:38  bra	0:FC,
    X"E0", X"E0",       --0:3A  nop,	nop,
    X"E0", X"E0",       --0:3C  nop,	nop,
    X"E0", X"E0",       --0:3E  nop,	nop,
    --2 popf 1111
    X"EF", X"E0",       --0:40  popf,	nop,
    X"F0", X"46",       --0:42  bra_n	0:46,
    X"FD", X"FC",       --0:44  bra	0:FC,
    X"F1", X"FC",       --0:46  bra_nn	0:FC,
    X"E0", X"E0",       --0:48  nop,	nop,
    X"F2", X"4E",       --0:4A  bra_z	0:4E,
    X"FD", X"FC",       --0:4C  bra	0:FC,
    X"F3", X"FC",       --0:4E  bra_nz	0:FC,
    X"E0", X"E0",       --0:50  nop,	nop,
    X"F4", X"56",       --0:52  bra_c	0:56,
    X"FD", X"FC",       --0:54  bra	0:FC,
    X"F5", X"FC",       --0:56  bra_nc	0:FC,
    X"E0", X"E0",       --0:58  nop,	nop,
    X"F6", X"FC",       --0:5A  bra_hi	0:FC,
    X"E0", X"E0",       --0:5C  nop,	nop,
    X"F7", X"62",       --0:5E  bra_lo	0:62,
    X"FD", X"FC",       --0:60  bra	0:FC,
    X"F8", X"66",       --0:62  bra_v	0:66,
    X"FD", X"FC",       --0:64  bra	0:FC,
    X"F9", X"FC",       --0:66  bra_nv	0:FC,
    X"E0", X"E0",       --0:68  nop,	nop,
    X"FA", X"FC",       --0:6A  bra_lt	0:FC,
    X"E0", X"E0",       --0:6C  nop,	nop,
    X"FB", X"72",       --0:6E  bra_ge	0:72,
    X"FD", X"FC",       --0:70  bra	0:FC,
    X"FE", X"76",       --0:72  bra_le	0:76,
    X"FD", X"FC",       --0:74  bra	0:FC,
    X"FF", X"FC",       --0:76  bra_gt	0:FC,
    X"E0", X"E0",       --0:78  nop,	nop,
    X"E0", X"E0",       --0:7A  nop,	nop,
    X"E0", X"E0",       --0:7C  nop,	nop,
    X"E0", X"E0",       --0:7E  nop,	nop,
    --3 popf 0001
    X"EF", X"E0",       --0:80  popf,	nop,
    X"FE", X"86",       --0:82  bra_le	0:86,
    X"FD", X"FC",       --0:84  bra	0:FC,
    X"FF", X"FC",       --0:86  bra_gt	0:FC,
    --4 popf 0010
    X"EF", X"E0",       --0:88  popf,	nop,
    X"FE", X"8E",       --0:8A  bra_le	0:8E,
    X"FD", X"FC",       --0:8C  bra	0:FC,
    X"FF", X"FC",       --0:8E  bra_gt	0:FC,
    --5 popf 0011
    X"EF", X"E0",       --0:90  popf,	nop,
    X"F6", X"FC",       --0:92  bra_hi	0:FC,
    X"F7", X"98",       --0:94  bra_lo	0:98,
    X"FD", X"FC",       --0:96  bra	0:FC,
    X"FA", X"9C",       --0:98  bra_lt	0:9C,
    X"FD", X"FC",       --0:9A  bra	0:FC,
    X"FB", X"FC",       --0:9C  bra_ge	0:FC,
    X"FE", X"A2",       --0:9E  bra_le	0:A2,
    X"FD", X"FC",       --0:A0  bra	0:FC,
    X"FF", X"FC",       --0:A2  bra_gt	0:FC,
    --6 popf 1001
    X"EF", X"E0",       --0:A4  popf,	nop,
    X"FE", X"FC",       --0:A6  bra_le	0:FC,
    X"FF", X"AC",       --0:A8  bra_gt	0:AC,
    X"FD", X"FC",       --0:AA  bra	0:FC,
    --7 popf 1010
    X"EF", X"E0",       --0:AC  popf,	nop,
    X"FE", X"B2",       --0:AE  bra_le	0:B2,
    X"FD", X"FC",       --0:B0  bra	0:FC,
    X"FF", X"FC",       --0:B2  bra_gt	0:FC,
    --8 popf 1100
    X"EF", X"E0",       --0:B4  popf,	nop,
    X"F6", X"FC",       --0:B6  bra_hi	0:FC,
    X"F7", X"BC",       --0:B8  bra_lo	0:BC,
    X"FD", X"FC",       --0:BA  bra	0:FC,
    X"FA", X"C0",       --0:BC  bra_lt	0:C0,
    X"FD", X"FC",       --0:BE  bra	0:FC,
    X"FB", X"FC",       --0:C0  bra_ge	0:FC,
    X"FE", X"C6",       --0:C2  bra_le	0:C6,
    X"FD", X"FC",       --0:C4  bra	0:FC,
    X"FF", X"FC",       --0:C6  bra_gt	0:FC,

    X"EF",		--0:C8	popf,	-- dummy
    X"FD", X"FE",	--0:C9  bra	0:FE,

    X"00", X"00", X"00", X"00", X"00",

    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",

    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",

    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"00", X"00", X"00", X"00",

    X"80", X"FC",	--0:FC	jmp	0:FC,
    X"80", X"FE"	--0:FE	jmp	0:FE,
    );
  variable memory2       : BYTE_MEMORY (0 to 15) :=
    (
    X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
    X"FF", X"01", X"02", X"03", X"09", X"0A", X"0C", X"F7"
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
      assert finish = 0
	report "Simulation is done successfully." severity ERROR;

    elsif read_mem = '1' then -- memory read
      if (ia >= 256) and (ia < 4080)  then
        databus <= HI_IMP_8;
        assert FALSE
          report "Simulation Error : adbus has illegal address when reading."
          severity FAILURE;
      else 
	if ia < 256 then
	  databus <= Drive (BVtoMVL7V (memory1 (ia)));
	else
	  databus <= Drive (BVtoMVL7V (memory2 (ia - 4080)));
	end if;
      end if;
      wait until read_mem = '0';
      databus <= HI_IMP_8;
    elsif write_mem = '1' then -- memory write
      wait until write_mem = '0';
      if ia = 4095 then
        memory2 (ia - 4080) := MVL7VtoBV (Drive (databus));
      else
        assert FALSE
          report "Simulation Error : adbus has illegal address when writing."
          severity FAILURE;
      end if;
    end if;

    if (ia = 253) or -- X"0:FD"
       (ia = 255)    -- X"A:FF"
    then -- stop simulation if these address are found twice
      finish := finish + 1;
    end if;
  end process mem;
end BEHAVIORAL;
