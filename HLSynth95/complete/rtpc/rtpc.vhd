--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	CPU Behavioral Model
--
-- Derived from
--	ROMP description written in verilog by Edward Czeck et al.
--	Most likely based on the IBM RT-PC Hardware Technical
--	Reference (c) 1985 (for RT PC model 10, 20, and 25)
--
-- Authors:
--	Alfred B. Thordarson (abth@ece.uci.edu)
--	and
--	Nikil Dutt, professor of CS and ECE
--	University Of California, Irvine, CA 92717
--
-- Changes:
--	Dec 1, 1993: File created by Alfred B. Thordarson
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Alfred B. Thordarson 01 Dec 93    Synopsys
--  Functionality     yes     Alfred B. Thordarson 01 Dec 93    Synopsys
--------------------------------------------------------------------------------

use STD.textio.all;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use WORK.rtpc_lib.all;

entity RTPC is
	Generic(	MEM_LATENCY : time := 100 ns;
			ADDRESS_SIZE : Dec := 24 );
	Port(		CLOCK : In Bits1;
			RESET : In Bits1;
			RWb : Out Bits1 bus;
			CSb : Out Bits1 bus := '1';
			ADDRESS : Out Bits(ADDRESS_SIZE-1 downto 0) bus;
			DATA : InOut Bits8 bus;
			WAITING : Out Bits1 );
end RTPC;

architecture BEHAVIORAL of RTPC is
begin
	process
		file REG_DEV : text is out "dump.registers";	-- File for register dump

		variable addr : Dec;				-- Address being executed
		variable instr : Dec;				-- Instruction being executed

		variable op1,op2,regA,regB : Dec;		-- Individual parts of the instruction
		variable immi : Dec;				-- Immidiate value if present

		variable offset : Dec;				-- Offset to next instruction
		variable MemoryBuffer : Dec;			-- Global variable for read/write memory

		variable reg : Regis(0 to 15);			-- General Purpose registers

		variable cc : Bits32;				-- Condition Code register
		variable mq : Bits32;				-- Multiplier quotient

		variable branch_cond : Dec;			-- Holds the branch condition
		variable branch_addr : Dec;			-- Address to be branched to
		
		variable Lin : line;				-- For the debugging utility
		variable Str : string(1 to 25);			-- Also for the debugging

		--
		-- DUMP DEBUGGING INFORMATION TO FILE
		--
		procedure debugging_utility(lined,cond_code,reg_from,reg_to: Dec) is
			variable i : Dec;
		begin
			if (lined=1) then
				Str:="-------------------------";
				write(Lin,Str);
				writeline(REG_DEV,Lin);
			end if;

			if (cond_code=1) then
				write(Lin,"Cond.code " & b2h(1,cc(less_than)) & "  Less");
				writeline(REG_DEV,Lin);
				write(Lin,"          " & b2h(1,cc(equal_to)) & "  Equal");
				writeline(REG_DEV,Lin);
				write(Lin,"          " & b2h(1,cc(greater_than)) & "  Greater");
				writeline(REG_DEV,Lin);
				write(Lin,"          " & b2h(1,cc(carry)) & "  Carry");
				writeline(REG_DEV,Lin);
				write(Lin,"          " & b2h(1,cc(overflow)) & "  Overflow");
				writeline(REG_DEV,Lin);
				write(Lin,"          " & b2h(1,cc(test_bit)) & "  Test bit");
				writeline(REG_DEV,Lin);
				if (reg_from<=reg_to) then
					Str:="                         ";
					write(Lin,Str);
					writeline(REG_DEV,Lin);
				end if;
			end if;

			for i in reg_from to reg_to loop
				if (i=reg_from) then write(Lin,"Register. " & d2h(1,i) & "  " & d2h(8,reg(i)));
				else write(Lin,"          " & d2h(1,i) & "  " & d2h(8,reg(i))); end if;
				writeline(REG_DEV,Lin);
			end loop;
		end;

		--
		-- UNIMPLEMENTED INSTRUCTIONS RUN THIS PROCEDURE
		--
		procedure Unimplemented is
		begin
			assert FALSE
			report "Unimplemented instruction " & d2h(4,instr) & " at address " & d2h(5,addr)
			severity error;
		end;

		--
		-- ILLEGAL INSTRUCTIONS RUN THIS PROCEDURE
		--
		procedure InstrIllegal is
		begin
			assert FALSE
			report "Illegal instruction " & d2h(4,instr) & " at address " & d2h(5,addr)
			severity failure;
		end;

		--
		-- TIMED-READ FROM MEMORY AT ADDRESS A INTO GLOBAL VARIABLE MEMORYBUFFER
		--
		procedure ReadMem(a: Dec) is
			variable d: Dec;
		begin
			ADDRESS <= d2b(ADDRESS_SIZE,a);
			RWb <= '1';
			CSb <= '0';
			wait for 0.9*MEM_LATENCY;
			d := b2d(DATA);
			CSb <= '1';
			wait for 0.1*MEM_LATENCY;
			MemoryBuffer:=d;

			ADDRESS <= null;
			DATA <= null;
			RWb <= null;
			CSb <= null;
		end;

		--
		-- TIMED-WRITE INTO MEMORY AT ADDRESS A FROM GLOBAL VARIABLE MEMORYBUFFER
		--
		procedure WriteMem(a: Dec) is
		begin
			ADDRESS <= d2b(ADDRESS_SIZE,a);
			DATA <= d2b(8,MemoryBuffer);
			RWb <= '0';
			CSb <= '0';
			wait for 0.9*MEM_LATENCY;
			CSb <= '1';
			wait for 0.1*MEM_LATENCY;

			ADDRESS <= null;
			DATA <= null;
			RWb <= null;
			CSb <= null;
		end;

		--
		-- CALCULATE COMPARE CONDITION CODES
		--
		procedure CalcCC(result:Dec) is
			variable i,absb : Dec;
			variable BitA,BitB : Bits32;
		begin
			if (result>0) then cc(greater_than):='1'; else cc(greater_than):='0'; end if;
			if (result=0) then cc(equal_to):='1'; else cc(equal_to):='0'; end if;
			if (result<0) then cc(less_than):='1'; else cc(less_than):='0'; end if;
		end;

		--
		-- CALCULATE ALL THE CONDITION CODES
		--
		procedure CalcCC(op,result,a,b:Dec) is
			variable i,absb : Dec;
			variable BitA,BitB : Bits32;
		begin
			if (result>0) then cc(greater_than):='1'; else cc(greater_than):='0'; end if;
			if (result=0) then cc(equal_to):='1'; else cc(equal_to):='0'; end if;
			if (result<0) then cc(less_than):='1'; else cc(less_than):='0'; end if;

			case op is
				when Addition =>
					if ((a>0) and (b>0) and (result<0)) or ((a<0) and (b<0) and (result>0)) then
						cc(overflow):='1'; else cc(overflow):='0'; end if;
					absb:=b;
				when Subtraction =>
					if ((a>0) and (b<0) and (result<0)) or ((a<0) and (b>0) and (result>0)) then
						cc(overflow):='1'; else cc(overflow):='0'; end if;
					absb:=-b;
				when others =>
					assert FALSE
					report "CalcCC for what?"
					severity failure;
			end case;

			cc(carry):='0';

			BitA:=d2b(32,a);
			BitB:=d2b(32,absb);

			for i in 31 downto 0 loop
				if ((BitA(i)='1') and (BitB(i)='1')) then cc(carry):='1'; exit; end if;
				if ((BitA(i)='0') and (BitB(i)='0')) then exit; end if;
			end loop;
		end;

		--
		-- LCS(4)
		-- LOAD CHARACTER SHORT
		-- GPA = BYTE AT MEM ADDR (B=0)?0:GPB + OP2
		--
		procedure lcs is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+op2;
			ReadMem(temp);
			reg(regA):=MemoryBuffer;
		end;

		--
		-- Load Character : gpA = Byte at mem addr (B=0)?0:gpB + immi

		--
		-- LC(CE)
		-- LOAD CHARACTER
		-- GPA = BYTE AT MEM ADDR (B=0)?0:GPB + IMMI
		--
		procedure lc is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+immi;
			ReadMem(temp);
			reg(regA):=MemoryBuffer;
		end;

		--
		-- LHAS(5)
		-- LOAD HALF ALGEBRAIC SHORT
		-- GPA = WORD AT MEM ADDR (B=0)?0:GPB + 2*OP2
		--
		procedure lhas is
			variable temp: Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+2*op2;
			ReadMem(temp);
			reg(regA):=MemoryBuffer;
			temp:=temp+1;
			ReadMem(temp);
			reg(regA):=shlbyte(reg(regA))+MemoryBuffer;
		end;

		--
		-- LHA(CA)
		-- LOAD HALF ALGEBRAIC
		-- GPA = WORD AT MEM ADDR (B=0)?0:GPB + IMMI
		--
		procedure lha is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+immi;
			ReadMem(temp);
			reg(regA):=MemoryBuffer;
			temp:=temp+1;
			ReadMem(temp);
			reg(regA):=shlbyte(reg(regA))+MemoryBuffer;
		end;

		--
		-- LHS(EB)
		-- LOAD HALF SHORT
		-- GPA = WORD AT MEM ADDR GPB
		--
		procedure lhs is
			variable temp : Dec;
		begin
			temp:=reg(regB);
			ReadMem(temp);
			reg(regA):=MemoryBuffer;
			temp:=temp+1;
			ReadMem(temp);
			reg(regA):=shlbyte(reg(regA))+MemoryBuffer;
		end;

		--
		-- LH(DA)
		-- LOAD HALF
		-- GPA = WORD AT MEM ADD (B=0)?0:GPB + IMMI
		--
		procedure lh is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+immi;
			ReadMem(temp);
			reg(regA):=MemoryBuffer;
			temp:=temp+1;
			ReadMem(temp);
			reg(regA):=shlbyte(reg(regA))+MemoryBuffer;
		end;

		--
		-- LS(7)
		-- LOAD SHORT
		-- GPA = LONG WORD AT MEM ADDR (B=0)?0:GPB + 4*OP2
		--
		procedure ls is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+4*op2;
			ReadMem(temp);
			reg(regA):=MemoryBuffer;
			temp:=temp+1;
			ReadMem(temp);
			reg(regA):=shlbyte(reg(regA))+MemoryBuffer;
			temp:=temp+1;
			ReadMem(temp);
			reg(regA):=shlbyte(reg(regA))+MemoryBuffer;
			temp:=temp+1;
			ReadMem(temp);
			reg(regA):=shlbyte(reg(regA))+MemoryBuffer;
		end;

		--
		-- L(CD)
		-- LOAD
		-- GPA = LONG WORD AT MEM ADDR (B=0)?0:GPB + IMMI
		--
		procedure l is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+immi;
			ReadMem(temp);
			reg(regA):=MemoryBuffer;
			temp:=temp+1;
			ReadMem(temp);
			reg(regA):=shlbyte(reg(regA))+MemoryBuffer;
			temp:=temp+1;
			ReadMem(temp);
			reg(regA):=shlbyte(reg(regA))+MemoryBuffer;
			temp:=temp+1;
			ReadMem(temp);
			reg(regA):=shlbyte(reg(regA))+MemoryBuffer;
		end;

		--
		-- LM(C9)
		-- LOAD MULTIPLE
		-- GP(A..15) = LONG WORDS BEG AT MEM ADDR (B=0)?0:GPB + IMMI
		--
		procedure lm is
			variable temp : Dec;
			variable i : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+immi;
			for i in regA to 15 loop
				ReadMem(temp);
				reg(i):=MemoryBuffer;
				temp:=temp+1;
				ReadMem(temp);
				reg(i):=shlbyte(reg(i))+MemoryBuffer;
				temp:=temp+1;
				ReadMem(temp);
				reg(i):=shlbyte(reg(i))+MemoryBuffer;
				temp:=temp+1;
				ReadMem(temp);
				reg(i):=shlbyte(reg(i))+MemoryBuffer;
				temp:=temp+1;
			end loop;
		end;

		--
		-- TSH(CF)
		-- TEST AND SET HALF
		-- GPA = WORD AT MEM ADDR (B=0)?0:GPB + IMMI (MARK WORD READ)
		--
		procedure tsh is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+immi;
			ReadMem(temp);
			reg(regA):=MemoryBuffer;
			temp:=temp+1;
			ReadMem(temp);
			reg(regA):=shlbyte(reg(regA))+MemoryBuffer;
			MemoryBuffer:=h2d("ff");
			temp:=temp-1;
			WriteMem(temp);
		end;

		--
		-- STCS(1)
		-- STORE CHARACTER SHORT
		-- WRITE BYTE FROM GPA TO MEM ADDR (B=0)?0:GPB + OP2
		--
		procedure stcs is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+op2;
			MemoryBuffer:=dec_bits(0,7,reg(regA));
			WriteMem(temp);
		end;

		--
		-- STC(DE)
		-- STORE CHARACTER
		-- WRITE BYTE FROM GPA TO MEM ADDR (B=0)?0:GPB + IMMI
		--
		procedure stc is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+immi;
			MemoryBuffer:=dec_bits(0,7,reg(regA));
			WriteMem(temp);
		end;

		--
		-- STHS(2)
		-- STORE HALF SHORT
		-- WRITE WORD FROM GPA TO MEM ADDR (B=0)?0:GPB + 2*OP2
		--
		procedure sths is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+2*op2;
			MemoryBuffer:=dec_bits(8,15,reg(regA));
			WriteMem(temp);
			temp:=temp+1;
			MemoryBuffer:=dec_bits(0,7,reg(regA));
			WriteMem(temp);
		end;

		--
		-- STH(DC)
		-- STORE HALF
		-- WRITE WORD FROM GPA TO MEM ADDR (B=0)?0:GPB + IMMI
		--
		procedure sth is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+immi;
			MemoryBuffer:=dec_bits(8,15,reg(regA));
			WriteMem(temp);
			temp:=temp+1;
			MemoryBuffer:=dec_bits(0,7,reg(regA));
			WriteMem(temp);
		end;

		--
		-- STS(3)
		-- STORE SHORT
		-- WRITE LONG WORD FROM GPA TO MEM ADDR (B=0)?0:GPB + 4*OP2
		--
		procedure sts is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+4*op2;
			MemoryBuffer:=dec_bits(24,31,reg(regA));
			WriteMem(temp);
			temp:=temp+1;
			MemoryBuffer:=dec_bits(16,23,reg(regA));
			WriteMem(temp);
			temp:=temp+1;
			MemoryBuffer:=dec_bits(8,15,reg(regA));
			WriteMem(temp);
			temp:=temp+1;
			MemoryBuffer:=dec_bits(0,7,reg(regA));
			WriteMem(temp);
		end;

		--
		-- ST(DD)
		-- STORE
		-- WRITE LONG WORD FROM GPA TO MEM ADDR (B=0)?0:GPB + IMMI
		--
		procedure st is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+immi;
			MemoryBuffer:=dec_bits(24,31,reg(regA));
			WriteMem(temp);
			temp:=temp+1;
			MemoryBuffer:=dec_bits(16,23,reg(regA));
			WriteMem(temp);
			temp:=temp+1;
			MemoryBuffer:=dec_bits(8,15,reg(regA));
			WriteMem(temp);
			temp:=temp+1;
			MemoryBuffer:=dec_bits(0,7,reg(regA));
			WriteMem(temp);
		end;

		--
		-- STM(D9)
		-- STORE MULTIPLE
		-- WRITE LONG WORDS FROM GP(A..15) TO MEM ADDR (B=0)?0:GPB + IMMI
		--
		procedure stm is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+immi;
			for i in regA to 15 loop
				MemoryBuffer:=dec_bits(24,31,reg(i));
				WriteMem(temp);
				temp:=temp+1;
				MemoryBuffer:=dec_bits(16,23,reg(i));
				WriteMem(temp);
				temp:=temp+1;
				MemoryBuffer:=dec_bits(8,15,reg(i));
				WriteMem(temp);
				temp:=temp+1;
				MemoryBuffer:=dec_bits(0,7,reg(i));
				WriteMem(temp);
				temp:=temp+1;
			end loop;
		end;

		--
		-- CAL(C8)
		-- COMPUTE ADDRESS LOWER HALF
		-- GPA = (B=0)?0:GPB + IMMI
		--
		procedure cal is
			variable BitsImmi : Bits32;
			variable ExtImmi : Dec;
			variable temp : Dec;
		begin
			BitsImmi:=h2b(16,"0000") & d2b(16,immi);
			ExtImmi:=b2d(BitsImmi);
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+ExtImmi;
			reg(regA):=temp;
		end;

		--
		-- CAL16(C2)
		-- COMPUTE ADDRESS LOWER HALF 16B
		-- GPA = (B=0)?0:GPB + IMMI
		--
		procedure cal16 is
			variable temp : Dec;
			variable BitsImmi : Bits32;
			variable ExtImmi : Dec;
			variable BitsTemp : Bits32;
		begin
			BitsImmi:=h2b(16,"0000") & d2b(16,immi);
			ExtImmi:=b2d(BitsImmi);
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+ExtImmi;
			temp:=temp and h2d("0000FFFF");
			reg(regA):=reg(regA) and h2d("FFFF0000");
			reg(regA):=reg(regA)+temp;
		end;

		--
		-- CAU(D8)
		-- COMPUTE ADDRESS UPPER HALF
		-- GPA = (B=0)?0:GPB + IMMI
		--
		procedure cau is
			variable BitsImmi : Bits32;
			variable ExtImmi : Dec;
			variable temp : Dec;
		begin
			BitsImmi:=d2b(16,immi) & h2b(16,"0000");
			ExtImmi:=b2d(BitsImmi);
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+ExtImmi;
			reg(regA):=temp;
		end;

		--
		-- CAS(6)
		-- COMPUTE ADDRESS SHORT
		-- GP(OP2) = (B=0)?0:GPB + GPA
		--
		procedure cas is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+reg(regA);
			reg(op2):=temp;
		end;

		--
		-- CA16(F3)
		-- COMPUTE ADDRESS 16-BIT
		-- GPA = GPA + GPB (ONLY LOWER 16 BITS)
		--
		procedure ca16 is
			variable temp : Dec;
		begin
			if (regB=0) then temp:=0; else temp:=reg(regB); end if;
			temp:=temp+reg(regA);
			temp:=temp and h2d("0000FFFF");
			reg(regA):=reg(regB) and h2d("FFFF0000");
			reg(regA):=reg(regA)+temp;
		end;

		--
		-- INC(91)
		-- INCREMENT
		-- GPA = GPA + B
		--
		procedure inc is
		begin
			reg(regA):=reg(regA)+regB;
		end;

		--
		-- DEC(93)
		-- DECREMENT
		-- GPA = GPA - B
		--
		procedure dec_instr is
		begin
			reg(regA):=reg(regA)-regB;
		end;

		--
		-- LIS(A4)
		-- LOAD IMMEDIATE SHORT
		-- GPA = B
		--
		procedure lis is
		begin
			reg(regA):=regB;
		end;

		--
		-- BALA(8A)
		-- BRANCH AND LINK ABSOLUTE
		-- BRANCH TO THE EVEN ADDRESS {0/A/B/IMMI} - IMMIDIATLY
		--
		procedure bala is
			variable temp : Bits32;
		begin
			temp:=d2b(8,0) & d2b(4,regA) & d2b(4,regB) & d2b(16,immi);
			temp(0):='0';
			branch_cond:=BranchNow;
			reg(15):=addr+offset;
			branch_addr:=b2d(temp);
		end;

		--
		-- BALAX(8B)
		-- BRANCH AND LINK ABSOLUTE X
		-- BRANCH TO THE EVEN ADDRESS {0/A/B/IMMI} - ONE DELAY SLOT
		--
		procedure balax is
			variable temp : Bits32;
		begin
			temp:=d2b(8,0) & d2b(4,regA) & d2b(4,regB) & d2b(16,immi);
			temp(0):='0';
			branch_cond:=BranchDelayed;
			reg(15):=addr+offset+4;
			branch_addr:=b2d(temp);
		end;

		--
		-- BALI(8C)
		-- BRANCH AND LINK I
		-- BRANCH RELATIVLY TO THE EVEN ADDRESS {B/IMMI/0} - IMMIDIATLY
		--
		procedure bali is
			variable BitsB : Bits(14 downto 0);
			variable temp : Bits32;
			variable i : Dec;
		begin
			BitsB:=d2b(15,regB);
			for i in 14 downto 4 loop
				BitsB(i):=BitsB(3);		-- extend sign
			end loop; 
			temp:=BitsB & d2b(16,immi) & "0";
			branch_cond:=BranchNow;
			reg(regA):=addr+offset;
			branch_addr:=addr+b2d(temp);
		end;

		--
		-- BALIX(8D)
		-- BRANCH AND LINK I X
		-- BRANCH TO THE EVEN RELATIV ADDRESS {B/IMMI/0} - ONE DELAY SLOT
		--
		procedure balix is
			variable BitsB : Bits(14 downto 0);
			variable temp : Bits32;
			variable i : Dec;
		begin
			BitsB:=d2b(15,regB);
			for i in 14 downto 4 loop
				BitsB(i):=BitsB(3);		-- extend sign
			end loop; 
			temp:=BitsB & d2b(16,immi) & "0";
			branch_cond:=BranchDelayed;
			reg(regA):=addr+offset+4;
			branch_addr:=addr+b2d(temp);
		end;

		--
		-- BALR(EC)
		-- BRANCH AND LINK
		-- BRANCH TO EVEN ADDRESS GPB - IMMIDIATLY
		--
		procedure balr is
			variable BitsB : Bits32;
		begin
			BitsB:=d2b(32,reg(regB));
			BitsB(0):='0';
			branch_cond:=BranchNow;
			reg(regA):=addr+offset;
			branch_addr:=b2d(BitsB);
		end;

		--
		-- BALRX(ED)
		-- BRANCH AND LINK X
		-- BRANCH TO EVEN ADDRESS GPB - ONE DELAY SLOT
		--
		procedure balrx is
			variable BitsB : Bits32;
		begin
			BitsB:=d2b(32,reg(regB));
			BitsB(0):='0';
			branch_cond:=BranchDelayed;
			reg(regA):=addr+offset+4;
			branch_addr:=b2d(BitsB);
		end;

		--
		-- JB(0+1/0)
		-- JUMP ON/NOT CONDITION BIT
		-- JUMP TO RELATIV {A/B/0} ON OP2 CONDITION - IMMIDIATLY
		--
		procedure jb is
			variable BitsA : Bits(26 downto 0);
			variable temp : Bits32;
			variable BitsOp2 : Bits4;
			variable i,condnr : Dec;
		begin
			if (instr/=0) then				-- NOP instruction=0
				BitsOp2:=d2b(4,op2);
				condnr:=perm_zero+b2d(BitsOp2(2 downto 0));
				if (cc(condnr)=BitsOp2(3)) then
					BitsA:=d2b(27,regA);
					for i in 26 downto 4 loop
						BitsA(i):=BitsA(3);		-- extend sign
					end loop;
					temp:=BitsA & d2b(4,regB) & "0";
					branch_cond:=BranchNow;
					branch_addr:=addr+b2d(temp);
				end if;
			end if;
		end;

		--
		-- BB(8E)
		-- BRANCH ON CONDITION BIT I
		-- BRANCH TO RELATIV {B/IMMI/0} ON TRUE A CONDITION - IMMIDIATLY
		--
		procedure bb is
			variable BitsB : Bits(14 downto 0);
			variable temp : Bits32;
			variable i : Dec;
		begin
			if (cc(16+regA)='1') then
				BitsB:=d2b(15,regB);
				for i in 14 downto 4 loop
					BitsB(i):=BitsB(3);		-- extend sign
				end loop;
				temp:=BitsB & d2b(16,immi) & "0";
				branch_cond:=BranchNow;
				branch_addr:=addr+b2d(temp);
			end if;
		end;

		--
		-- BBX(8F)
		-- BRANCH ON CONDITION BIT I X
		-- BRANCH TO RELATIV {B/IMMI/0} ON TRUE A CONDITION - ONE DELAY SLOT
		--
		procedure bbx is
			variable BitsB : Bits(14 downto 0);
			variable temp : Bits32;
			variable i : Dec;
		begin
			if (cc(16+regA)='1') then
				BitsB:=d2b(15,regB);
				for i in 14 downto 4 loop
					BitsB(i):=BitsB(3);		-- extend sign
				end loop;
				temp:=BitsB & d2b(16,immi) & "0";
				branch_cond:=BranchDelayed;
				branch_addr:=addr+b2d(temp);
			end if;
		end;

		--
		-- BBR(EE)
		-- BRANCH ON CONDITION BIT
		-- BRANCH TO EVEN ADDRESS GPB ON TRUE A CONDITION - IMMIDIATLY
		--
		procedure bbr is
			variable BitsB : Bits(14 downto 0);
			variable temp : Bits32;
			variable i : Dec;
		begin
			if (cc(16+regA)='1') then
				temp:=d2b(32,reg(regB));
				temp(0):='0';
				branch_cond:=BranchNow;
				branch_addr:=b2d(temp);
			end if;
		end;

		--
		-- BBRX(EF)
		-- BRANCH ON CONDITION BIT X
		-- BRANCH TO EVEN ADDRESS GPB ON TRUE A CONDITION - ONE DELAY SLOT
		--
		procedure bbrx is
			variable BitsB : Bits(14 downto 0);
			variable temp : Bits32;
			variable i : Dec;
		begin
			if (cc(16+regA)='1') then
				temp:=d2b(32,reg(regB));
				temp(0):='0';
				branch_cond:=BranchDelayed;
				branch_addr:=b2d(temp);
			end if;
		end;

		--
		-- BNB(88)
		-- BRANCH ON NOT CONDITION BIT I
		-- BRANCH TO RELATIV {B/IMMI/0} ON FALSE A CONDITION - IMMIDIATLY
		--
		procedure bnb is
			variable BitsB : Bits(14 downto 0);
			variable temp : Bits32;
			variable i : Dec;
		begin
			if (cc(16+regA)='0') then
				BitsB:=d2b(15,regB);
				for i in 14 downto 4 loop
					BitsB(i):=BitsB(3);		-- extend sign
				end loop;
				temp:=BitsB & d2b(16,immi) & "0";
				branch_cond:=BranchNow;
				branch_addr:=addr+b2d(temp);
			end if;
		end;

		--
		-- BNBX(89)
		-- BRANCH ON NOT CONDITION BIT I X
		-- BRANCH TO RELATIV {B/IMMI/0} ON FALSE A CONDITION - ONE DELAY SLOT
		--
		procedure bnbx is
			variable BitsB : Bits(14 downto 0);
			variable temp : Bits32;
			variable i : Dec;
		begin
			if (cc(16+regA)='0') then
				BitsB:=d2b(15,regB);
				for i in 14 downto 4 loop
					BitsB(i):=BitsB(3);		-- extend sign
				end loop;
				temp:=BitsB & d2b(16,immi) & "0";
				branch_cond:=BranchDelayed;
				branch_addr:=addr+b2d(temp);
			end if;
		end;

		--
		-- BNBR(E8)
		-- BRANCH ON NOT CONDITION BIT
		-- BRANCH TO EVEN ADDRESS GPB ON FALSE A CONDITION - IMMIDIATLY
		--
		procedure bnbr is
			variable BitsB : Bits(14 downto 0);
			variable temp : Bits32;
			variable i : Dec;
		begin
			if (cc(16+regA)='0') then
				temp:=d2b(32,reg(regB));
				temp(0):='0';
				branch_cond:=BranchNow;
				branch_addr:=b2d(temp);
			end if;
		end;

		--
		-- BNBRX(E9)
		-- BRANCH ON NOT CONDITION BIT X
		-- BRANCH TO EVEN ADDRESS GPB ON FALSE A CONDITION - ONE DELAY SLOT
		--
		procedure bnbrx is
			variable BitsB : Bits(14 downto 0);
			variable temp : Bits32;
			variable i : Dec;
		begin
			if (cc(16+regA)='0') then
				temp:=d2b(32,reg(regB));
				temp(0):='0';
				branch_cond:=BranchDelayed;
				branch_addr:=b2d(temp);
			end if;
		end;

		--
		-- THIS FUNCTION IS RUN IF THE CONDITIONS IN TI, TGTE OR TLT ARE FULFILLED 
		--
		procedure trap_instr is
		begin
			assert FALSE
			report "Trap instruction " & d2h(4,instr) & " at address " & d2h(5,addr)
			severity error;
		end;

		--
		-- TI(CC)
		-- TRAP ON CONDITION IMMEDIATE
		-- IF GPB<=>IMMI THEN TRAP (CONDITION DEPENDS ON A)
		--
		procedure ti is
			variable BitsA : Bits4;
		begin
			BitsA:=d2b(4,regA);
			if ((reg(regB)<immi) and (BitsA(2)='1')) then trap_instr; end if;
			if ((reg(regB)=immi) and (BitsA(1)='1')) then trap_instr; end if;
			if ((reg(regB)>immi) and (BitsA(0)='1'))  then trap_instr; end if;
		end;

		--
		-- TGTE(BD)
		-- TRAP IF REG GREATERTHAN OR EQ
		-- IF GPA>=GPB THEN TRAP
		--
		procedure tgte is
		begin
			if (reg(regA)>=reg(regB)) then trap_instr; end if;
		end;

		--
		-- TLT(BE)
		-- TRAP IF REG LESS THAN
		-- IF GPA<GPB THEN TRAP
		--
		procedure tlt is
		begin
			if (reg(regA)<reg(regB)) then trap_instr; end if;
		end;

		--
		-- MC03(F9)
		-- MOVE CHARACTER ZERO FROM THREE
		-- GPA(BYTE 0) = GPB(BYTE 3)
		--
		procedure mc03 is
			variable BitsA,BitsB : Bits32;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(32,reg(regB));
			BitsA(31 downto 24):=BitsB(7 downto 0);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MC13(FA)
		-- MOVE CHARACTER ONE FROM THREE
		-- GPA(BYTE 1) = GPB(BYTE 3)
		--
		procedure mc13 is
			variable BitsA,BitsB : Bits32;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(32,reg(regB));
			BitsA(23 downto 16):=BitsB(7 downto 0);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MC23(FB)
		-- MOVE CHARACTER TWO FROM THREE
		-- GPA(BYTE 2) = GPB(BYTE 3)
		--
		procedure mc23 is
			variable BitsA,BitsB : Bits32;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(32,reg(regB));
			BitsA(15 downto 8):=BitsB(7 downto 0);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MC33(FC)
		-- MOVE CHARACTER THREE FROM THREE
		-- GPA(BYTE 3) = GPB(BYTE 3)
		--
		procedure mc33 is
			variable BitsA,BitsB : Bits32;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(32,reg(regB));
			BitsA(7 downto 0):=BitsB(7 downto 0);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MC30(FD)
		-- MOVE CHARACTER THREE FROM ZERO
		-- GPA(BYTE 3) = GPB(BYTE 0)
		--
		procedure mc30 is
			variable BitsA,BitsB : Bits32;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(32,reg(regB));
			BitsA(7 downto 0):=BitsB(31 downto 24);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MC31(FE)
		-- MOVE CHARACTER THREE FROM ONE
		-- GPA(BYTE 3) = GPB(BYTE 1)
		--
		procedure mc31 is
			variable BitsA,BitsB : Bits32;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(32,reg(regB));
			BitsA(7 downto 0):=BitsB(23 downto 16);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MC32(FF)
		-- MOVE CHARACTER THREE FROM TWO
		-- GPA(BYTE 3) = GPB(BYTE 2)
		--
		procedure mc32 is
			variable BitsA,BitsB : Bits32;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(32,reg(regB));
			BitsA(7 downto 0):=BitsB(15 downto 8);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MFTB(BC)
		-- MOVE FROM TEST BIT
		-- SET A BIT IN GPA ACORDING TO GPB EQUAL TO TEST_BIT
		--
		procedure mftb is
			variable BitsA,BitsB : Bits32;
			variable bitnum : Dec;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(32,reg(regB));
			BitsB(4 downto 0):=not BitsB(4 downto 0);
			bitnum:=b2d(BitsB(4 downto 0));
			BitsA(bitnum):=cc(test_bit);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MFTBIL(9D)
		-- MOVE FROM TEST BIT I LOWER HALF
		-- SET A BIT IN GPA ACORDING TO B EQUAL TO TEST_BIT
		--
		procedure mftbil is
			variable BitsA : Bits32;
			variable BitsB : Bits4;
			variable bitnum : Dec;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(4,regB);
			BitsB:=not BitsB;
			bitnum:=b2d(BitsB);
			BitsA(bitnum):=cc(test_bit);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MFTBIU(9C)
		-- MOVE FROM TEST BIT I UPPER HALF
		-- SET A BIT IN GPA ACORDING TO B+16 EQUAL TO TEST_BIT
		--
		procedure mftbiu is
			variable BitsA : Bits32;
			variable BitsB : Bits4;
			variable bitnum : Dec;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(4,regB);
			BitsB:=not BitsB;
			bitnum:=b2d(BitsB)+16;
			BitsA(bitnum):=cc(test_bit);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MTTB(BF)
		-- MOVE TO TEST BIT
		-- SET TEST_BIT EQUAL TO A BIT IN GPA ACORDING TO GPB
		--
		procedure mttb is
			variable BitsA,BitsB : Bits32;
			variable bitnum : Dec;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(32,reg(regB));
			BitsB(4 downto 0):=not BitsB(4 downto 0);
			bitnum:=b2d(BitsB(4 downto 0));
			cc(test_bit):=BitsA(bitnum);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MTTBIL(9F)
		-- MOVE TO TEST BIT I LOWER HALF
		-- SET TEST_BIT EQUAL TO A BIT IN GPA ACORDING TO B
		--
		procedure mttbil is
			variable BitsA : Bits32;
			variable BitsB : Bits4;
			variable bitnum : Dec;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(4,regB);
			BitsB:=not BitsB;
			bitnum:=b2d(BitsB);
			cc(test_bit):=BitsA(bitnum);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- MTTBIU(9E)
		-- MOVE TO TEST BIT I UPPER HALF
		-- SET TEST_BIT EQUAL TO A BIT IN GPA ACORDING TO B+16
		--
		procedure mttbiu is
			variable BitsA : Bits32;
			variable BitsB : Bits4;
			variable bitnum : Dec;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(4,regB);
			BitsB:=not BitsB;
			bitnum:=b2d(BitsB)+16;
			cc(test_bit):=BitsA(bitnum);
			reg(regA):=b2d(BitsA);
		end;

		--
		-- A(E1)
		-- ADD
		-- GPA = GPA + GPB
		--
		procedure a is
			variable result : Dec;
		begin
			result:=reg(regA)+reg(regB);
			CalcCC(Addition,result,reg(regA),reg(regB));
			reg(regA):=result;
		end;

		--
		-- AE(F1)
		-- ADD EXTEND
		-- GPA = GPA + GPB + CARRY
		--
		procedure ae is
			variable result : Dec;
		begin
			result:=reg(regA)+reg(regB)+b2d(cc(carry));
			CalcCC(Addition,result,reg(regA),reg(regB)+b2d(cc(carry)));
			reg(regA):=result;
		end;

		--
		-- AEI(D1)
		-- ADD EXTEND IMMEDIATE
		-- GPA = GPB + IMMI + CARRY
		--
		procedure aei is
			variable result : Dec;
		begin
			result:=reg(regB)+immi+b2d(cc(carry));
			CalcCC(Addition,result,reg(regB),immi+b2d(cc(carry)));
			reg(regA):=result;
		end;

		--
		-- AI(C1)
		-- ADD IMMEDIATE
		-- GPA = GPB + IMMI
		--
		procedure ai is
			variable result : Dec;
		begin
			result:=reg(regB)+immi;
			CalcCC(Addition,result,reg(regB),immi);
			reg(regA):=result;
		end;

		--
		-- AIS(90)
		-- ADD IMMEDIATE SHORT
		-- GPA = GPA + B
		--
		procedure ais is
			variable result : Dec;
		begin
			result:=reg(regA)+regB;
			CalcCC(Addition,result,reg(regA),regB);
			reg(regA):=result;
		end;

		--
		-- ABS_INSTR(E0)
		-- ABSOLUTE
		-- GPA = ABS(GPB)
		--
		procedure abs_instr is
			variable result : Dec;
		begin
			result:=abs(reg(regB));
			CalcCC(Addition,result,0,0);
			cc(overflow):=cc(less_than);
			reg(regA):=result;
		end;

		--
		-- ONEC(F4)
		-- ONES COMPLEMENT
		-- GPA = ONE'S COMPLEMENT OF GPB
		--
		procedure onec is
			variable result : Dec;
		begin
			result:=-reg(regB)-1;
			CalcCC(result);
			reg(regA):=result;
		end;

		--
		-- TWOC(E4)
		-- TWOS COMPLEMENT
		-- GPA = TWO'S COMPLEMENT OF GPB
		--
		procedure twoc is
			variable result : Dec;
		begin
			result:=-reg(regB);
			CalcCC(Subtraction,result,0,reg(regB));
			if (result=h2d("80000000")) then cc(overflow):='1'; else cc(overflow):='0'; end if;
			reg(regA):=result;
		end;

		--
		-- C(B4)
		-- COMPARE
		-- COMPARE GPA AND GPB
		--
		procedure c is
		begin
			CalcCC(reg(regA)-reg(regB));
		end;

		--
		-- CIS(94)
		-- COMPARE IMMEDIATE SHORT
		-- COMPARE GPA AND B
		--
		procedure cis is
		begin
			CalcCC(reg(regA)-regB);
		end;

		--
		-- CI(D4)
		-- COMPARE IMMEDIATE
		-- COMPARE GPA AND IMMI
		--
		procedure ci is
		begin
			CalcCC(reg(regA)-immi);
		end;

		--
		-- CL(B3)
		-- COMPARE LOGICAL
		-- COMPARE GPA AND GPB (COND.CODE UNSIGNED)
		--
		procedure cl is
			variable i : Dec;
			variable BitsA,BitsB : Bits32;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsB:=d2b(32,reg(regB));

			cc(less_than):='0';
			cc(equal_to):='1';
			cc(greater_than):='0';

			for i in 31 downto 0 loop
				if (BitsA(i)/=BitsB(i)) then
					cc(less_than):=not BitsA(i);
					cc(equal_to):='0';
					cc(greater_than):=BitsA(i);
					exit;
				end if;
			end loop;
		end;

		--
		-- CLI(D3)
		-- COMPARE LOGICAL IMMEDIATE
		-- COMPARE GPA AND IMMI (COND.CODE UNSIGNED)
		--
		procedure cli is
			variable i : Dec;
			variable BitsA,BitsI : Bits32;
		begin
			BitsA:=d2b(32,reg(regA));
			BitsI:=d2b(32,immi);

			cc(less_than):='0';
			cc(equal_to):='1';
			cc(greater_than):='0';

			for i in 31 downto 0 loop
				if (BitsA(i)/=BitsI(i)) then
					cc(less_than):=not BitsA(i);
					cc(equal_to):='0';
					cc(greater_than):=BitsA(i);
					exit;
				end if;
			end loop;
		end;

		--
		-- EXTS(B1)
		-- EXTEND SIGN
		-- GPA = EXTENDED LOW WORD OF GPB
		--
		procedure exts is
			variable i : Dec;
			variable temp : Bits32;
		begin
			temp:=d2b(32,reg(regB));
			for i in 31 downto 16 loop
				temp(i):=temp(15);
			end loop;
			reg(regA):=b2d(temp);
			CalcCC(reg(regA));
		end;

		--
		-- S(E2)
		-- SUBTRACT
		-- GPA = GPA - GPB
		--
		procedure s is
			variable result : Dec;
		begin
			result:=subtract(reg(regA),reg(regB));
			CalcCC(Subtraction,result,reg(regA),reg(regB));
			reg(regA):=result;
		end;

		--
		-- SF(B2)
		-- SUBTRACT FROM
		-- GPA = GPB - GPA
		--
		procedure sf is
			variable result : Dec;
		begin
			result:=subtract(reg(regB),reg(regA));
			CalcCC(Subtraction,result,reg(regB),reg(regA));
			reg(regA):=result;
		end;

		--
		-- SE(F2)
		-- SUBTRACT EXTENDED
		-- GPA = GPB - GPA - CARRY
		--
		procedure se is
			variable result : Dec;
		begin
			result:=subtract(reg(regA),reg(regB));
			result:=subtract(result,b2d(not cc(carry)));
			CalcCC(Subtraction,result,reg(regA),reg(regB)+b2d(cc(carry)));
			reg(regA):=result;
		end;

		--
		-- SFI(D2)
		-- SUBTRACT FROM IMMEDIATE
		-- GPA = IMMI - GPB
		--
		procedure sfi is
			variable result : Dec;
		begin
			result:=subtract(immi,reg(regB));
			CalcCC(Subtraction,result,immi,reg(regB));
			reg(regA):=result;
		end;

		--
		-- SIS(92)
		-- SUBTRACT IMMEDIATE SHORT
		-- GPA = GPA - B
		--
		procedure sis is
			variable result : Dec;
		begin
			result:=subtract(reg(regA),regB);
			CalcCC(Subtraction,result,reg(regA),regB);
			reg(regA):=result;
		end;

		--
		-- D(B6)
		-- DIVIDE STEP
		-- PARTIAL DIVISION
		--
		procedure d is
			variable Sum,BitsA,BitsB : Bits(33 downto 0);
			variable BitsMq : Bits32;
		begin
			BitsA:=d2b(34,reg(regA));
			BitsB:=d2b(34,reg(regB));

			if (BitsA(33)=BitsB(33)) then
				BitsA:=SHL(BitsA,1,mq(31));
				Sum:=BitsA-BitsB;
			else
				BitsA:=SHL(BitsA,1,mq(31));
				Sum:=BitsA+BitsB;
			end if;

			reg(regA):=b2d(Sum(31 downto 0));
			mq:=SHL(mq,1,'0');

			if (Sum(33)=BitsB(33)) then
				mq(0):='1';
				cc(carry):='1';
			end if;

			BitsA:=d2b(34,reg(regA));
			if (Sum(33)=BitsA(33)) then
				cc(overflow):='1';
			end if;
		end;

		--
		-- M(E6)
		-- MULTIPLY STEP
		-- PARTIAL MULTIPLICATION
		--
		procedure m is
			variable BitsA,BitsB : Bits(33 downto 0);
			variable Temp : Bits32;
			variable BitsMq : Bits2;
		begin
			BitsA:=d2b(34,reg(regA));
			BitsB:=d2b(34,reg(regB));

			if (cc(carry)='0') then BitsA:=BitsA+BitsB; end if;

			BitsMq:=mq(1 downto 0);
			case BitsMq is
				when "10" => BitsA:=BitsA-BitsB-BitsB;	-- signed -2
				when "11" => BitsA:=BitsA-BitsB;	-- signed -1
				when "00" => BitsA:=BitsA;		-- signed  0
				when "01" => BitsA:=BitsA+BitsB;	-- signed +1
				when others =>
			end case;

			cc(carry):=not mq(1);

			mq:=SHR(mq,2,'0');
			mq(31 downto 30):=BitsA(1 downto 0);

			Temp:=BitsA(33 downto 2);
			reg(regA):=b2d(Temp);
		end;

		--
		-- CLRBL(99)
		-- CLEAR BIT LOWER HALF
		-- CLEAR BIT B IN LOWER(GPA)
		--
		procedure clrbl is
			variable BitA : Bits32;
		begin
			BitA:=d2b(32,reg(regA));
			BitA(15-regB):='0';
			reg(regA):=b2d(BitA);
			CalcCC(reg(regA));
		end;

		--
		-- CLRBU(98)
		-- CLEAR BIT UPPER HALF
		-- CLEAR BIT B IN UPPER(GPA)
		--
		procedure clrbu is
			variable BitA : Bits32;
		begin
			BitA:=d2b(32,reg(regA));
			BitA(31-regB):='0';
			reg(regA):=b2d(BitA);
			CalcCC(reg(regA));
		end;

		--
		-- SETBL(9B)
		-- SET BIT LOWER HALF
		-- SET BIT B IN LOWER(GPA)
		--
		procedure setbl is
			variable BitA : Bits32;
		begin
			BitA:=d2b(32,reg(regA));
			BitA(15-regB):='1';
			reg(regA):=b2d(BitA);
			CalcCC(reg(regA));
		end;

		--
		-- SETBU(9A)
		-- SET BIT UPPER HALF
		-- SET BIT B IN UPPER(GPA)
		--
		procedure setbu is
			variable BitA : Bits32;
		begin
			BitA:=d2b(32,reg(regA));
			BitA(31-regB):='1';
			reg(regA):=b2d(BitA);
			CalcCC(reg(regA));
		end;

		--
		-- N(E5)
		-- AND
		-- GPA = GPA AND GPB
		--
		procedure n is
		begin
			reg(regA):=reg(regA) and reg(regB);
			CalcCC(reg(regA));
		end;

		--
		-- NILZ(C5)
		-- AND IMMEDIATE LOWER HALF EX0
		-- GPA = GPB AND {0/IMMI}
		--
		procedure nilz is
			variable BitTemp : Bits32;
			variable temp : Dec;
		begin
			BitTemp:=h2b(16,"0000") & d2b(16,immi);
			temp:=b2d(BitTemp);
			reg(regA):=reg(regB) and temp;
			CalcCC(reg(regA));
		end;

		--
		-- NILO(C6)
		-- AND IMMEDIATE LOWER HALF EX1
		-- GPA = GPB AND {1/IMMI}
		--
		procedure nilo is
			variable BitTemp : Bits32;
			variable temp : Dec;
		begin
			BitTemp:=h2b(16,"FFFF") & d2b(16,immi);
			temp:=b2d(BitTemp);
			reg(regA):=reg(regB) and temp;
			CalcCC(reg(regA));
		end;

		--
		-- NIUZ(D5)
		-- AND IMMEDIATE UPPER HALF EX0
		-- GPA = GPB AND {IMMI/0}
		--
		procedure niuz is
			variable BitTemp : Bits32;
			variable temp : Dec;
		begin
			BitTemp:=d2b(16,immi) & h2b(16,"0000");
			temp:=b2d(BitTemp);
			reg(regA):=reg(regB) and temp;
			CalcCC(reg(regA));
		end;

		--
		-- NIUO(D6)
		-- AND IMMEDIATE UPPER HALF EX1
		-- GPA = GPB AND {IMMI/1}
		--
		procedure niuo is
			variable BitTemp : Bits32;
			variable temp : Dec;
		begin
			BitTemp:=d2b(16,immi) & h2b(16,"FFFF");
			temp:=b2d(BitTemp);
			reg(regA):=reg(regB) and temp;
			CalcCC(reg(regA));
		end;

		--
		-- O(E3)
		-- OR
		-- GPA = GPA OR GPB
		--
		procedure o is
		begin
			reg(regA):=reg(regA) or reg(regB);
			CalcCC(reg(regA));
		end;

		--
		-- OIL(C4)
		-- OR IMMEDIATE LOWER HALF
		-- GPA = GPB OR {0/IMMI}
		--
		procedure oil is
			variable BitTemp : Bits32;
			variable temp : Dec;
		begin
			BitTemp:=h2b(16,"0000") & d2b(16,immi);
			temp:=b2d(BitTemp);
			reg(regA):=reg(regB) or temp;
			CalcCC(reg(regA));
		end;

		--
		-- OIU(C3)
		-- OR IMMEDIATE UPPER HALF
		-- GPA = GPB OR {IMMI/0}
		--
		procedure oiu is
			variable BitTemp : Bits32;
			variable temp : Dec;
		begin
			BitTemp:=d2b(16,immi) & h2b(16,"0000");
			temp:=b2d(BitTemp);
			reg(regA):=reg(regB) or temp;
			CalcCC(reg(regA));
		end;

		--
		-- X(E7)
		-- XOR
		-- GPA = GPA XOR GPB
		--
		procedure x is
		begin
			reg(regA):=reg(regA) xor reg(regB);
			CalcCC(reg(regA));
		end;

		--
		-- XIL(C7)
		-- XOR IMMEDIATE LOWER HALF
		-- GPA = GPB XOR {0/IMMI}
		--
		procedure xil is
			variable BitTemp : Bits32;
			variable temp : Dec;
		begin
			BitTemp:=h2b(16,"0000") & d2b(16,immi);
			temp:=b2d(BitTemp);
			reg(regA):=reg(regB) xor temp;
			CalcCC(reg(regA));
		end;

		--
		-- XIU(D7)
		-- XOR IMMEDIATE UPPER HALF
		-- GPA = GPB XOR {IMMI/0}
		--
		procedure xiu is
			variable BitTemp : Bits32;
			variable temp : Dec;
		begin
			BitTemp:=d2b(16,immi) & h2b(16,"0000");
			temp:=b2d(BitTemp);
			reg(regA):=reg(regB) xor temp;
			CalcCC(reg(regA));
		end;

		--
		-- CLZ(F5)
		-- COUNT LEADING ZEROS
		-- GPA = COUNT OF LEADING ZEROS IN GPB
		--
		procedure clz is
			variable BitB : Bits32;
			variable i : Dec;
		begin
			BitB:=d2b(32,reg(regB));
			reg(regA):=0;
			for i in 31 downto 0 loop
				if (BitB(i)='1') then exit; end if;
				reg(regA):=reg(regA)+1;
			end loop;
		end;

		--
		-- SAR(B0)
		-- SHIFT ALGEBRAIC RIGHT
		-- GPA = GPA >> LOWEST 6 BITS OF GPB (EXTEND SIGN)
		--
		procedure sar is
			variable BitsA : Bits32;
			variable temp : Dec;			
		begin
			temp:=reg(regB) and b2d("111111");
			BitsA:=d2b(32,reg(regA));
			BitsA:=SHR(BitsA,temp,BitsA(31));
			reg(regA):=b2d(BitsA);
			CalcCC(reg(regA));
		end;

		--
		-- SARI(A0)
		-- SHIFT ALGEBRAIC RIGHT I
		-- GPA = GPA >> B (EXTEND SIGN)
		--
		procedure sari is
			variable BitsA : Bits32;
			variable Sign : Bits1;
			variable temp : Dec;			
		begin
			temp:=regB;
			BitsA:=d2b(32,reg(regA));
			BitsA:=SHR(BitsA,temp,BitsA(31));
			reg(regA):=b2d(BitsA);
			CalcCC(reg(regA));
		end;

		--
		-- SARI16(A1)
		-- SHIFT ALGEBRAIC RIGHT I +16
		-- GPA = GPA >> 16+B (EXTEND SIGN)
		--
		procedure sari16 is
			variable BitsA : Bits32;
			variable temp : Dec;			
		begin
			temp:=regB+16;
			BitsA:=d2b(32,reg(regA));
			BitsA:=SHR(BitsA,temp,BitsA(31));
			reg(regA):=b2d(BitsA);
			CalcCC(reg(regA));
		end;

		--
		-- SR(B8)
		-- SHIFT RIGHT
		-- GPA = GPA >> LOWEST 6 BITS OF GPB
		--
		procedure sr is
			variable BitsA : Bits32;
			variable temp : Dec;			
		begin
			temp:=reg(regB) and b2d("111111");
			BitsA:=d2b(32,reg(regA));
			BitsA:=SHR(BitsA,temp,'0');
			reg(regA):=b2d(BitsA);
			CalcCC(reg(regA));
		end;

		--
		-- SRI(A8)
		-- SHIFT RIGHT I
		-- GPA = GPA >> B
		--
		procedure sri is
			variable BitsA : Bits32;
			variable temp : Dec;			
		begin
			temp:=regB;
			BitsA:=d2b(32,reg(regA));
			BitsA:=SHR(BitsA,temp,'0');
			reg(regA):=b2d(BitsA);
			CalcCC(reg(regA));
		end;

		--
		-- SRI16(A9)
		-- SHIFT RIGHT I +16
		-- GPA = GPA >> 16+B
		--
		procedure sri16 is
			variable BitsA : Bits32;
			variable temp : Dec;			
		begin
			temp:=regB+16;
			BitsA:=d2b(32,reg(regA));
			BitsA:=SHR(BitsA,temp,'0');
			reg(regA):=b2d(BitsA);
			CalcCC(reg(regA));
		end;

		--
		-- SRP(B9)
		-- SHIFT RIGHT PAIRED
		-- GP(TWIN) = GPA >> LOWEST 6 BITS OF GPB
		--
		procedure srp is
			variable BitsA : Bits32;
			variable temp : Dec;			
			variable twin : Dec;
		begin
			if ((regA mod 2)=0) then
				twin:=regA+1;
			else
				twin:=regA-1;
			end if;

			temp:=reg(regB) and b2d("111111");
			BitsA:=d2b(32,reg(regA));
			BitsA:=SHR(BitsA,temp,'0');
			reg(twin):=b2d(BitsA);
			CalcCC(reg(twin));
		end;

		--
		-- SRPI(AC)
		-- SHIFT RIGHT PAIRED I
		-- GP(TWIN) = GPA >> B
		--
		procedure srpi is
			variable BitsA : Bits32;
			variable temp : Dec;			
			variable twin : Dec;
		begin
			if ((regA mod 2)=0) then
				twin:=regA+1;
			else
				twin:=regA-1;
			end if;

			temp:=regB;
			BitsA:=d2b(32,reg(regA));
			BitsA:=SHR(BitsA,temp,'0');
			reg(twin):=b2d(BitsA);
			CalcCC(reg(twin));
		end;

		--
		-- SRPI16(AD)
		-- SHIFT RIGHT PAIRED I +16
		-- GP(TWIN) = GPA >> 16+B
		--
		procedure srpi16 is
			variable BitsA : Bits32;
			variable temp : Dec;			
			variable twin : Dec;
		begin
			if ((regA mod 2)=0) then
				twin:=regA+1;
			else
				twin:=regA-1;
			end if;

			temp:=regB+16;
			BitsA:=d2b(32,reg(regA));
			BitsA:=SHR(BitsA,temp,'0');
			reg(twin):=b2d(BitsA);
			CalcCC(reg(twin));
		end;

		--
		-- SL(BA)
		-- SHIFT LEFT
		-- GPA = GPA << LOWEST 6 BITS OF GPB
		--
		procedure sl is
			variable BitA : Bits32;
			variable temp : Dec;			
		begin
			temp:=reg(regB) and b2d("111111");
			BitA:=d2b(32,reg(regA));
			BitA:=SHL(BitA,temp,'0');
			reg(regA):=b2d(BitA);
			CalcCC(reg(regA));
		end;

		--
		-- SLI(AA)
		-- SHIFT LEFT I
		-- GPA = GPA << B
		--
		procedure sli is
			variable BitA : Bits32;
			variable temp : Dec;			
		begin
			temp:=regB;
			BitA:=d2b(32,reg(regA));
			BitA:=SHL(BitA,temp,'0');
			reg(regA):=b2d(BitA);
			CalcCC(reg(regA));
		end;

		--
		-- SLI16(AB)
		-- SHIFT LEFT I +16
		-- GPA = GPA << 16+B
		--
		procedure sli16 is
			variable BitA : Bits32;
			variable temp : Dec;			
		begin
			temp:=regB+16;
			BitA:=d2b(32,reg(regA));
			BitA:=SHL(BitA,temp,'0');
			reg(regA):=b2d(BitA);
			CalcCC(reg(regA));
		end;

		--
		-- SLP(BB)
		-- SHIFT LEFT PAIRED
		-- GP(TWIN) = GPA << LOWEST 6 BITS OF GPB
		--
		procedure slp is
			variable BitA : Bits32;
			variable temp : Dec;
			variable twin : Dec;	
		begin
			if ((regA mod 2)=0) then
				twin:=regA+1;
			else
				twin:=regA-1;
			end if;

			temp:=reg(regB) and b2d("111111");
			BitA:=d2b(32,reg(regA));
			BitA:=SHL(BitA,temp,'0');
			reg(twin):=b2d(BitA);
			CalcCC(reg(twin));
		end;

		--
		-- SLPI(AE)
		-- SHIFT LEFT PAIRED I
		-- GP(TWIN) = GPA << B
		--
		procedure slpi is
			variable BitA : Bits32;
			variable temp : Dec;
			variable twin : Dec;			
		begin
			if ((regA mod 2)=0) then
				twin:=regA+1;
			else
				twin:=regA-1;
			end if;

			temp:=regB;
			BitA:=d2b(32,reg(regA));
			BitA:=SHL(BitA,temp,'0');
			reg(twin):=b2d(BitA);
			CalcCC(reg(twin));
		end;

		--
		-- SLPI16(AF)
		-- SHIFT LEFT PAIRED I +16
		-- GP(TWIN) = GPA << 16+B
		--
		procedure slpi16 is
			variable BitA : Bits32;
			variable temp : Dec;
			variable twin : Dec;			
		begin
			if ((regA mod 2)=0) then
				twin:=regA+1;
			else
				twin:=regA-1;
			end if;

			temp:=regB+16;
			BitA:=d2b(32,reg(regA));
			BitA:=SHL(BitA,temp,'0');
			reg(twin):=b2d(BitA);
			CalcCC(reg(twin));
		end;

		--
		-- MTS(B5)
		-- MOVE TO SCR
		-- SCRA = GPB
		--
		procedure mts is
		begin
			case regA is
				when 10 => mq:=d2b(32,reg(regB));
				when 15 => cc:=d2b(32,reg(regB));
				when others => Unimplemented;
			end case;
		end;

		--
		-- MFS(96)
		-- MOVE FROM SCR
		-- GPB = SCRA
		--
		procedure mfs is
		begin
			case regA is
				when 10 => reg(regB):=b2d(mq);
				when 15 => reg(regB):=b2d(cc);
				when others => Unimplemented;
			end case;
		end;

		--
		-- CLRSB(95)
		-- CLEAR SCR BIT
		-- CLEAR BIT REGB IN SCRA
		--
		procedure clrsb is
		begin
			case regA is
				when 10 => mq(regB):='0';
				when 15 => if ((regB>24) and (regB<32) and (regB/=29)) then cc(regB):='0'; end if;
				when others => Unimplemented;
			end case;
		end;

		--
		-- SETSB(97)
		-- SET SCR BIT
		-- SET BIT REGB IN SCRA
		--
		procedure setsb is
		begin
			case regA is
				when 10 => mq(regB):='1';
				when 15 => if ((regB>24) and (regB<32) and (regB/=29)) then cc(regB):='1'; end if;
				when others => Unimplemented;
			end case;
		end;

		--
		-- WAIT(F0)
		-- WAIT
		-- USED FOR DEBUGGING AND TO RETURN CONTROL TO CONTROL UNIT
		--
		procedure wwait is
			variable from_reg,to_reg : Dec;
		begin
			if (regA=15) and (regB=15) then
				offset:=0;
			else
				from_reg:=regB;
				to_reg:=regB+dec_bits(0,1,regA);
				if (to_reg=16) then from_reg:=0; to_reg:=15; end if;
				if (to_reg>16) then from_reg:=15; to_reg:=0; end if;
				debugging_utility(dec_bits(3,3,regA),dec_bits(2,2,regA),from_reg,to_reg);
			end if;
		end;

		--
		-- LPS(D0)
		-- LOAD PROGRAM STATUS
		-- *** NOT IMPLEMENTED
		--
		procedure lps is
		begin
			Unimplemented;
		end;

		--
		-- SVC(C0)
		-- SUPERVISOR CALL
		-- *** NOT IMPLEMENTED
		--
		procedure svc is
		begin
			Unimplemented;
		end;

		--
		-- IOR(CB)
		-- INPUT/OUTPUT READ
		-- *** NOT IMPLEMENTED
		--
		procedure ior is
		begin
			Unimplemented;
		end;

		--
		-- IOW(DB)
		-- INPUT/OUTPUT WRITE
		-- *** NOT IMPLEMENTED
		--
		procedure iow is
		begin
			Unimplemented;
		end;

		--
		-- EXECUTE INSTRUCTION 8OP2
		--
		procedure Execute8 is
			variable hexid : string(1 to 1);
		begin
			offset:=4;
			hexid:=d2h(1,op2);
			case hexid is
				when "0" => InstrIllegal;
				when "1" => InstrIllegal;
				when "2" => InstrIllegal;
				when "3" => InstrIllegal;
				when "4" => InstrIllegal;
				when "5" => InstrIllegal;
				when "6" => InstrIllegal;
				when "7" => InstrIllegal;
				when "8" => bnb;
				when "9" => bnbx;
				when "A" => bala;
				when "B" => balax;
				when "C" => bali;
				when "D" => balix;
				when "E" => bb;
				when "F" => bbx;
				when others => InstrIllegal;
			end case;
		end;

		--
		-- EXECUTE INSTRUCTION 9OP2
		--
		procedure Execute9 is
			variable hexid : string(1 to 1);
		begin
			offset:=2;
			hexid:=d2h(1,op2);
			case hexid is
				when "0" => ais;
				when "1" => inc;
				when "2" => sis;
				when "3" => dec_instr;
				when "4" => cis;
				when "5" => clrsb;
				when "6" => mfs;
				when "7" => setsb;
				when "8" => clrbu;
				when "9" => clrbl;
				when "A" => setbu;
				when "B" => setbl;
				when "C" => mftbiu;
				when "D" => mftbil;
				when "E" => mttbiu;
				when "F" => mttbil;
				when others => InstrIllegal;
			end case;
		end;

		--
		-- EXECUTE INSTRUCTION AOP2
		--
		procedure ExecuteA is
			variable hexid : string(1 to 1);
		begin
			offset:=2;
			hexid:=d2h(1,op2);
			case hexid is
				when "0" => sari;
				when "1" => sari16;
				when "2" => InstrIllegal;
				when "3" => InstrIllegal;
				when "4" => lis;
				when "5" => InstrIllegal;
				when "6" => InstrIllegal;
				when "7" => InstrIllegal;
				when "8" => sri;
				when "9" => sri16;
				when "A" => sli;
				when "B" => sli16;
				when "C" => srpi;
				when "D" => srpi16;
				when "E" => slpi;
				when "F" => slpi16;
				when others => InstrIllegal;
			end case;
		end;

		--
		-- EXECUTE INSTRUCTION BOP2
		--
		procedure ExecuteB is
			variable hexid : string(1 to 1);
		begin
			offset:=2;
			hexid:=d2h(1,op2);
			case hexid is
				when "0" => sar;
				when "1" => exts;
				when "2" => sf;
				when "3" => cl;
				when "4" => c;
				when "5" => mts;
				when "6" => d;
				when "7" => InstrIllegal;
				when "8" => sr;
				when "9" => srp;
				when "A" => sl;
				when "B" => slp;
				when "C" => mftb;
				when "D" => tgte;
				when "E" => tlt;
				when "F" => mttb;
				when others => InstrIllegal;
			end case;
		end;

		--
		-- EXECUTE INSTRUCTION COP2
		--
		procedure ExecuteC is
			variable hexid : string(1 to 1);
		begin
			offset:=4;
			hexid:=d2h(1,op2);
			case hexid is
				when "0" => svc;
				when "1" => ai;
				when "2" => cal16;
				when "3" => oiu;
				when "4" => oil;
				when "5" => nilz;
				when "6" => nilo;
				when "7" => xil;
				when "8" => cal;
				when "9" => lm;
				when "A" => lha;
				when "B" => ior;
				when "C" => ti;
				when "D" => l;
				when "E" => lc;
				when "F" => tsh;
				when others => InstrIllegal;
			end case;
		end;

		--
		-- EXECUTE INSTRUCTION DOP2
		--
		procedure ExecuteD is
			variable hexid : string(1 to 1);
		begin
			offset:=4;
			hexid:=d2h(1,op2);
			case hexid is
				when "0" => lps;
				when "1" => aei;
				when "2" => sfi;
				when "3" => cli;
				when "4" => ci;
				when "5" => niuz;
				when "6" => niuo;
				when "7" => xiu;
				when "8" => cau;
				when "9" => stm;
				when "A" => lh;
				when "B" => iow;
				when "C" => sth;
				when "D" => st;
				when "E" => stc;
				when "F" => InstrIllegal;
				when others => InstrIllegal;
			end case;
		end;

		--
		-- EXECUTE INSTRUCTION EOP2
		--
		procedure ExecuteE is
			variable hexid : string(1 to 1);
		begin
			offset:=2;
			hexid:=d2h(1,op2);
			case hexid is
				when "0" => abs_instr;
				when "1" => a;
				when "2" => s;
				when "3" => o;
				when "4" => twoc;
				when "5" => n;
				when "6" => m;
				when "7" => x;
				when "8" => bnbr;
				when "9" => bnbrx;
				when "A" => InstrIllegal;
				when "B" => lhs;
				when "C" => balr;
				when "D" => balrx;
				when "E" => bbr;
				when "F" => bbrx;
				when others => InstrIllegal;
			end case;
		end;

		--
		-- EXECUTE INSTRUCTION FOP2
		--
		procedure ExecuteF is
			variable hexid : string(1 to 1);
		begin
			offset:=2;
			hexid:=d2h(1,op2);
			case hexid is
				when "0" => wwait;		-- Used for returning to control
				when "1" => ae;
				when "2" => se;
				when "3" => ca16;
				when "4" => onec;
				when "5" => clz;
				when "6" => InstrIllegal;
				when "7" => InstrIllegal;
				when "8" => InstrIllegal;
				when "9" => mc03;
				when "A" => mc13;
				when "B" => mc23;
				when "C" => mc33;
				when "D" => mc30;
				when "E" => mc31;
				when "F" => mc32;
				when others => InstrIllegal;
			end case;
		end;

		--
		-- EXECUTE INSTRUCTION OP1
		--
		procedure Execute is
			variable hexid : string(1 to 1);
		begin
			offset:=2;
			hexid:=d2h(1,op1);
			case hexid is
				when "0" => jb;
				when "1" => stcs;
				when "2" => sths;
				when "3" => sts;
				when "4" => lcs;
				when "5" => lhas;
				when "6" => cas;
				when "7" => ls;
				when "8" => Execute8;
				when "9" => Execute9;
				when "A" => ExecuteA;
				when "B" => ExecuteB;
				when "C" => ExecuteC;
				when "D" => ExecuteD;
				when "E" => ExecuteE;
				when "F" => ExecuteF;
				when others => InstrIllegal;
			end case;
		end;

	begin
		if (RESET='1') then
			ADDRESS <= null;
			DATA <= null;
			RWb <= null;
			CSb <= null;
			WAITING <= '0';

			for i in 0 to 15 loop reg(i):=0; end loop;

			branch_cond:=BranchNone;
			branch_addr:=0;

			cc:=d2b(32,0);
			mq:=d2b(32,0);

			instr:=0;
			addr:=h2d("040");
			offset:=0;

			op1:=0;
			op2:=0;
			regA:=0;
			regB:=0;
			immi:=0;

			MemoryBuffer:=0;

			wait until falling_edge(RESET);

			Str:="=========================";
			write(Lin,Str);
			writeline(REG_DEV,Lin);
		else
			while (RESET='0') loop

				wait until rising_edge(CLOCK);

				-- Read instruction at addr
				ReadMem(addr);
				instr:=MemoryBuffer;
				ReadMem(addr+1);
				instr:=shlbyte(instr)+MemoryBuffer;

				-- Read immi at addr+2
				ReadMem(addr+2);
				immi:=MemoryBuffer;
				ReadMem(addr+3);
				immi:=shlbyte(immi)+MemoryBuffer;

				-- Create opcodes and operands
				op1 := dec_bits(12,15,instr);
				op2 := dec_bits(8,11,instr);
				regA := dec_bits(4,7,instr);
				regB := dec_bits(0,3,instr);

				-- Execute the instruction instr and immi
				-- Creates address offset to next instruction
				Execute;

				-- Finished or next instruction
				if (offset=0) then exit;
				else addr:=addr+offset; end if;

				-- Branches
				case branch_cond is
					when BranchDelayed =>
						branch_cond:=BranchNext;
					when BranchNow=>
						addr:=branch_addr;
						branch_cond:=BranchNone;
					when others =>
				end case;
			end loop;

			ADDRESS <= null;
			DATA <= null;
			RWb <= null;
			CSb <= null;
			WAITING <= '1';
			wait until RESET='1';
		end if;
	end process;
end BEHAVIORAL;

configuration RTPC_CFG of RTPC is
	for BEHAVIORAL
	end for;
end RTPC_CFG;
