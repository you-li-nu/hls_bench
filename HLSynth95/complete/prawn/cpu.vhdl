--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : CPU Behavioral Model
--
-- Derived from
--           Parwan : a reduced processor
--           from Chapter 9 of NAVABI : "VHDL: Analysis and Modeling of
--           Digital Systems" McGraw-Hill,Inc. 1993
--
-- Author: Tadatoshi Ishii
--         Information and Computer Science,
--         University Of California, Irvine, CA 92717
--
-- Developed on Nov 1, 1992
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

--
entity CPU is -- {
  generic (
	    READ_HIGH_TIME, READ_LOW_TIME,
	    WRITE_HIGH_TIME, WRITE_LOW_TIME : time := 200 ns;
	    CYCLE_TIME			    : time := 400 ns
	  );
  port (
	clk		    : in	MVL7;
	rst		    : in	MVL7;
	read_mem, write_mem : out	MVL7;
	databus		    : inout	WIRED_BYTE;
	adbus		    : out	TWELVE;
	interrupt	    : in	MVL7;
	inta		    : out	MVL7
      );
end CPU; -- }
--
architecture BEHAVIORAL of CPU is
begin
  process
    --
    -- declare necessary variables.
    --
    variable pc				: TWELVE;
    variable ac, byte1, byte2, byte3	: BYTE;
    variable i, v, c, z, n, i_status	: MVL7;
    variable flag			: MVL7_VECTOR (4 downto 0);
    variable temp			: MVL7_VECTOR (9 downto 0);

  begin -- {
    --
    -- start process description.
    --
    if rst = '1' then -- {
      --
      -- handle reset.
      --
      pc := ZERO_12;
      databus <= HI_IMP_8;
      adbus <= ZERO_12;
      read_mem <= '0';
      write_mem <= '0';
      inta <= '0';
      i := '0';
      v := '0';
      c := '0';
      z := '0';
      n := '0';
      wait for CYCLE_TIME;
    else -- }{
      --
      -- if there is no reset, execute following part.
      --
      -- check the interrupt request and the interrupt flag.
      --
      if (interrupt = '1') and (i = '1') then -- {
        i_status := '1';
      else -- }{
	i_status := '0';
      end if; -- }
      flag := i & v & c & z & n;
      --
      -- read first byte into byte1, increment the program counter.
      -- if interrupt was accepted,
      -- read first byte of start address of interrupt handling routine.
      --
      adbus <= pc;
      if (i_status = '1') then inta <= '1'; else read_mem <= '1'; end if;
      wait for READ_HIGH_TIME;
      byte1 := Drive (databus);
      if (i_status = '1') then inta <= '0'; else read_mem <= '0'; end if;
      wait for READ_LOW_TIME;
      if (i_status = '0') then pc (7 downto 0) := INC (pc (7 downto 0)); end if;

      --
      -- start decode & execution.
      --
      if ((byte1 (7 downto 4) = SINGLE_BYTE_INST) or
	 (byte1 (7 downto 0) = JRT)) and (i_status = '0')
      then -- {
	--
	-- execute single-byte instructions.
	--
	if (byte1 (3 downto 2) = PUSHPOP) or
	   (byte1 (7 downto 0) = JRT) or 
	   (byte1 (3 downto 0) = BRT) or 
	   (byte1 (3 downto 0) = IRT) 
	then -- {
	  --
	  -- execute single-byte instructions which need stack operations.
	  --
	  -- read the stack pointer for all instructions
	  -- which need stack operations.
	  --
	  adbus <= STACKP;
	  read_mem <= '1'; wait for READ_HIGH_TIME;
	  byte3 := Drive (databus);
	  read_mem <= '0'; wait for READ_LOW_TIME;
	  if byte1 (1) = '1' then -- {
	    --
	    -- execute instructions which need to pop data from the stack,
	    -- which are POP & POPF & JRT & BRT & IRT.
	    --
	    adbus <= "1111" & byte3;
	    read_mem <= '1'; wait for READ_HIGH_TIME;
	    if (byte1 = JRT) or
	       (byte1 (3 downto 0) = BRT) or
	       (byte1 (3 downto 0) = IRT)
	    then -- {
	      --
	      -- execute return instructions.
	      --
	      if (byte1 (3 downto 0) = IRT) then -- {
		--
		-- pop flags from the stack for IRT,
		-- increment the stack pointer for popping flags.
		--
		flag := Drive (databus (4 downto 0));
		i:=flag(4);v:=flag(3);c:=flag(2);z:=flag(1);n:=flag(0);
		read_mem <= '0'; wait for READ_LOW_TIME;
		byte3 := INC (byte3);
		adbus <= "1111" & byte3;
		read_mem <= '1'; wait for READ_HIGH_TIME;
	      end if; -- }
	      --
	      -- pop offset part of address from the stack
	      -- for all return instructions,
	      -- return to the original(caller) control sequence.
	      --
	      pc (7 downto 0) := Drive (databus);
	      if (byte1 (3 downto 0) /= BRT) then -- {
		--
		-- pop page part of address from the stack for IRT & JRT,
		-- increment the stack pointer for popping the address,
		-- return to the original(caller) control sequence.
		--
		read_mem <= '0'; wait for READ_LOW_TIME;
		byte3 := INC (byte3);
		adbus <= "1111" & byte3;
		read_mem <= '1'; wait for READ_HIGH_TIME;
		pc (11 downto 8) := Drive (databus (3 downto 0));
	      end if; -- }
	    elsif byte1 (0) = '0' then -- }{
	      --
	      -- execute POP.
	      --
	      ac := Drive (databus);
	    else -- }{
	      --
	      -- execute POPF.
	      --
	      flag := Drive (databus (4 downto 0));
	      i:=flag(4);v:=flag(3);c:=flag(2);z:=flag(1);n:=flag(0);
		    --
	    end if; -- } return instructions / POP / POPF
	    	    --
	    read_mem <= '0'; wait for READ_LOW_TIME;
	    --
	    -- increment the stack pointer
	    -- for all instructions which need pop operation.
	    --
	    byte3 := INC (byte3);
	  else -- }{
	    --
	    -- execute instructions which need to push datum onto the stack,
	    -- which are PUSH & PUSHF.
	    --
	    -- decrement the stack pointer
	    -- for all instructions which need pop operation.
	    --
	    byte3 := byte3 - "00000001"; wait for CYCLE_TIME;
	    adbus <= "1111" & byte3;
	    if byte1 (0) = '0' then -- {
	      --
	      --  execute PUSH.
	      --
	      databus <= Drive (ac);
	    else -- }{
	      --
	      -- execute PUSHF.
	      --
	      databus <= Drive ("000" & flag);
	    end if; -- }
	    write_mem <= '1'; wait for WRITE_HIGH_TIME;
	    write_mem <= '0'; wait for WRITE_LOW_TIME;
		  --
	  end if; -- } instructions which need pop / push operations
		  --
	  --
	  -- write the stack pointer incremented/decremented
	  -- for all instructions which need stack operations.
	  --
	  databus <= Drive (byte3);
	  adbus  <= STACKP;
	  write_mem <= '1'; wait for WRITE_HIGH_TIME;
	  write_mem <= '0'; wait for WRITE_LOW_TIME;
	  databus <= HI_IMP_8;
	else -- }{
	  --
	  -- execute single-byte instructions
	  -- which do not need the stack operations.
	  --
	  case byte1 (3 downto 0) is -- {
	    when NOP => null;
	    when CLA =>
	      ac := ZERO_8;
	    when CMA =>
	      ac := not ac;
	      if ac = ZERO_8 then z := '1'; else z := '0'; end if;
	      n := ac (7);
	    when CMC =>
	      c := not c;
	    when STI =>
	      i := '1';
	    when CLI =>
	      i := '0';
	    when ASL =>
	      c := ac (7);
	      ac := ac (6 downto 0) & '0';
	      n := ac(7);
	      if c /= n then v := '1'; else v := '0'; end if;
	      if ac = ZERO_8 then z := '1'; else z := '0'; end if;
	    when ASR =>
	      ac := ac (7) & ac (7 downto 1);
	      if ac = ZERO_8 then z := '1'; else z := '0'; end if;
	      n := ac (7);
	    when ROL =>
	      ac := ac (6 downto 0) & ac (7);
	      if ac = ZERO_8 then z := '1'; else z := '0'; end if;
	      n := ac (7);
	    when ROR =>
	      ac := ac(0) & ac (7 downto 1);
	      if ac = ZERO_8 then z := '1'; else z := '0'; end if;
	      n := ac (7);
	    when others => null;
	  end case; -- }
		-- 
	end if; -- } instructions which need / do not need stack operations
		--
      else -- }{
      --
      -- execute two-byte instructions.
      --
      -- read second byte into byte2, increment the program counter.
      -- if interrupt was accepted,
      -- read second byte of start address of interrupt handling routine.
      --
	adbus <= pc;
	if (i_status='1') then inta <= '1'; else read_mem <= '1'; end if;
	wait for READ_HIGH_TIME;
	byte2 := Drive (databus);
	if (i_status='1') then inta <= '0'; else read_mem <= '0'; end if;
	wait for READ_LOW_TIME;
	if (i_status='0') then pc (7 downto 0) := INC (pc (7 downto 0)); end if;

	if (byte1 (7 downto 4) = JSR) or (byte1 (7 downto 0) = BSR) or
	   (i_status = '1')
	then -- {
	  --
	  -- execute subroutine instructions/interrupt handling.
	  --
	  -- read the stack pointer, decrement it.
	  --
          adbus <= STACKP;
          read_mem <= '1'; wait for READ_HIGH_TIME;
          byte3 := Drive (databus);
          read_mem <= '0'; wait for READ_LOW_TIME;
	  byte3 := byte3 - "00000001"; wait for CYCLE_TIME;
	  if (byte1 (7 downto 0) /= BSR) then -- {
	    --
	    -- push page part of address onto the stack
	    -- for JRT and interrupt handling,
	    -- increment the stack pointer for pushing the address.
	    --
	    adbus <= "1111" & byte3;
	    databus <= Drive (ZERO_4 & pc (11 downto 8));
	    write_mem <= '1'; wait for WRITE_HIGH_TIME;
	    write_mem <= '0'; wait for WRITE_LOW_TIME;
	    byte3 := byte3 - "00000001";
	  end if; -- }
	  --
	  -- push offset part of address onto the stack
	  -- for subroutine instructions and interrupt handling.
	  --
          adbus <= "1111" & byte3;
	  databus <= Drive (pc (7 downto 0));
	  write_mem <= '1'; wait for WRITE_HIGH_TIME;
	  write_mem <= '0'; wait for WRITE_LOW_TIME;
	  if (i_status = '1') then -- {
	    --
	    -- push flags onto the stack for interrupt handling,
	    -- decrement the stack pointer for pushing flags
	    --
	    byte3 := byte3 - "00000001";
	    adbus <= "1111" & byte3;
	    databus <= Drive ("000" & flag);
	    write_mem <= '1'; wait for WRITE_HIGH_TIME;
	    write_mem <= '0'; wait for WRITE_LOW_TIME;
	    i := '0';
	  end if; -- }
	  --
	  -- write the stack pointer decremented
	  -- for subroutine instructions/interrupt handling
	  --
	  databus <= Drive (byte3);
	  adbus  <= STACKP;
	  write_mem <= '1'; wait for WRITE_HIGH_TIME;
	  write_mem <= '0'; wait for WRITE_LOW_TIME;
	  databus <= HI_IMP_8;
	  --
	  -- change the control sequence to the designated address.
	  --
	  if (byte1 (7 downto 0) /= BSR) then -- {
	    pc := byte1 (3 downto 0) & byte2;
	  else -- }{
	    pc := pc (11 downto 8) & byte2;
	  end if; -- }
	elsif byte1 (7 downto 4) = BR then -- }{
	  --
	  -- execute branch instructions.
	  --
	  if
	    (byte1(3 downto 0)="0000" and n='1') or		      -- BRA_N
	    (byte1(3 downto 0)="0001" and n='0') or		      -- BRA_NN
	    (byte1(3 downto 0)="0010" and z='1') or		      -- BRA_Z
	    (byte1(3 downto 0)="0011" and z='0') or		      -- BRA_NZ
	    (byte1(3 downto 0)="0100" and c='1') or		      -- BRA_C
	    (byte1(3 downto 0)="0101" and c='0') or		      -- BRA_NC
	    (byte1(3 downto 0)="0110" and ((not c)and(not z))='1') or -- BRA_HI
	    (byte1(3 downto 0)="0111" and (c or z)='1') or	      -- BRA_LO
	    (byte1(3 downto 0)="1000" and v='1' ) or		      -- BRA_V
	    (byte1(3 downto 0)="1001" and v='0' ) or		      -- BRA_NV
	    (byte1(3 downto 0)="1010" and (n xor v)='1') or	      -- BRA_LT
	    (byte1(3 downto 0)="1011" and nxor (n, v)='1') or	      -- BRA_GE
	    (byte1(3 downto 0)="1101") or			      -- BRA
	    (byte1(3 downto 0)="1110" and (z or (n xor v))='1') or    -- BRA_LE
	    (byte1(3 downto 0)="1111" and ((not z)and nxor(n,v))='1') -- BRA_GT
	  then -- {
	    --
	    -- change the control sequence to the designated address.
	    --
	    pc (7 downto 0) := byte2;
	  end if; -- }
	else -- }{
	--
	-- execute all other two-byte instructions
	--
	  if byte1 (4) = INDIRECT then -- {
	    --
	    -- use byte1 and byte2 to get destination address.
	    --
	    adbus (11 downto 8) <= byte1 (3 downto 0);
	    adbus (7 downto 0) <= byte2;
	    read_mem <= '1'; wait for READ_HIGH_TIME;
	    byte2 := Drive (databus);
	    read_mem <= '0'; wait for READ_LOW_TIME;
		  --
	  end if; -- } indirect
		  --
	  if byte1 (7 downto 5) = JMP then -- {
	    --
	    -- execute JMP instruction,
	    -- change the control sequence to the destination address.
	    --
	    pc := byte1 (3 downto 0) & byte2;
	  elsif byte1 (7 downto 5) =STA then -- }{
	    --
	    -- execute STA instruction, write ac to the destination address.
	    --
	    adbus <= byte1 (3 downto 0) & byte2;
	    databus <= Drive (ac);
	    write_mem <= '1'; wait for WRITE_HIGH_TIME;
	    write_mem <= '0'; wait for WRITE_LOW_TIME;
	    databus <= HI_IMP_8;
	  else -- }{
	    --
	    -- read operand for LDA, AND, ADD, SUB.
	    --
	    -- read the contents of the destination memory onto databus.
	    --
	    adbus (11 downto 8) <= byte1 (3 downto 0);
	    adbus (7 downto 0) <= byte2;
	    read_mem <= '1'; wait for READ_HIGH_TIME;
	    case byte1 (7 downto 5) is -- {
	      --
	      -- execute LDA, AND, ADD, and SUB.
	      --
	      when LDA =>
		ac := Drive (databus);
	      when ANN =>
		ac := ac and Drive (databus);
	      when ADD =>
		temp := add_cv (ac, Drive (databus), c);
		ac := temp (7 downto 0);
		c := temp (8);
		v := temp (9);
	      when SBB =>
		temp := sub_cv (ac, Drive (databus), c);
		ac := temp (7 downto 0);
		c := temp (8);
		v := temp (9);
	      when others => null;
	    end case; -- }
	    --
	    -- change zero flag & negative flag.
	    --
	    if ac = ZERO_8 then z := '1'; else z := '0'; end if;
	    n := ac (7);
	    --
	    -- remove memory from databus;
	    --
	    read_mem <= '0'; wait for READ_LOW_TIME;
		  --
	  end if; -- } JMP / STA / LDA,AND,ADD,SUB
		  --
		--
	end if; -- } subroutine & interrupt / branch / other two-byte inst's
		--
	      --
      end if; -- } single-byte / two-byte instructions
	      --
	    --
    end if; -- } reset / otherwise
	    --
  end process; -- }
end BEHAVIORAL;
