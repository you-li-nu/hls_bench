--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Library Package
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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

package RTPC_LIB is

	subtype Dec is		integer;

	--
	-- Constants for the condition codes
	--
	constant perm_zero:	Dec := 24;
	constant less_than:	Dec := 25;
	constant equal_to:	Dec := 26;
	constant greater_than:	Dec := 27;
	constant carry:		Dec := 28;
	constant reserved:	Dec := 29;
	constant overflow:	Dec := 30;
	constant test_bit:	Dec := 31;

	--
	-- Other constants
	--
	constant addition:	Dec := 0;
	constant subtraction:	Dec := 1;

	constant WriteToMemory:	Dec := 0;
	constant CompareMemory:	Dec := 1;

	constant BranchDelayed:	Dec := 2;
	constant BranchNext:	Dec := 1;
	constant BranchNow:	Dec := 1;
	constant BranchNone:	Dec := 0;

	--
	-- Resolution for the bus
	--
	function WiredAnd(sources: std_logic_vector) return std_logic;

	subtype Bits1 is	WiredAnd std_logic;
	type Bits is		array(natural range <>) of Bits1;

	subtype Bits64 is	Bits(63 downto 0);
	subtype Bits32 is	Bits(31 downto 0);
	subtype Bits16 is	Bits(15 downto 0);
	subtype Bits8 is	Bits(7 downto 0);
	subtype Bits4 is	Bits(3 downto 0);
	subtype Bits2 is	Bits(1 downto 0);

	--
	-- Registers
	--
	type Regis is		array(natural range <>) of Dec;

	--
	-- Convertion functions
	--
	function b2d(p:Bits) return Dec;
	function b2d(p:Bits1) return Dec;
	function d2b(sz: Dec; p:Dec) return Bits;

	function h2b(sz: Dec; p:string) return Bits;
	function b2h(sz: Dec; p:Bits) return string;
	function b2h(sz: Dec; p:Bits1) return string;

	function h2d(p:string) return Dec;
	function d2h(sz: Dec; p:Dec) return string;

	--
	-- Other handy functions
	--
	function SHL(p:Bits;o:Dec;n:Bits1) return Bits;
	function SHR(p:Bits;o:Dec;n:Bits1) return Bits;

	function shlbyte(p:Dec) return Dec;
	function dec_bits(l,r,p:Dec) return Dec;

	function subtract(p1,p2:Dec) return Dec;

	--
	-- Overwritten operators for Bits
	--
	function "not"(r:Bits) return Bits;
	function "not"(r:Bits1) return Bits1;
	function "and"(l:Bits;r:Bits) return Bits;
	function "xor"(l:Bits;r:Bits) return Bits;
	function "or"(l:Bits;r:Bits) return Bits;

	function "+"(l:Bits;r:Bits) return Bits;
	function "-"(l:Bits;r:Bits) return Bits;

	--
	-- Overwritten operators for Dec
	--
	function "not"(r:Dec) return Dec;
	function "and"(l:Dec;r:Dec) return Dec;
	function "xor"(l:Dec;r:Dec) return Dec;
	function "or"(l:Dec;r:Dec) return Dec;

end RTPC_LIB;

package body RTPC_LIB is

	--
	-- Resolution function for a wired-and bus
	--
	function WiredAnd(sources: std_logic_vector) return std_logic is
		variable i : Dec;
		variable result : std_logic := '1';
	begin
		if (sources="") then return result; end if;

		for i in sources'RANGE loop
			if (sources(i)='0') then
				result := '0';
			end if;
		end loop;

		assert (sources/="")
		report "No drivers"
		severity note;

		return result;
	end;

	--
	-- Shift a bit-vector left by number of bits
	--
	function SHL(p:Bits;o:Dec;n:Bits1) return Bits is
		variable i : Dec;
		variable pTemp : Bits(p'LENGTH-1 downto 0);
		variable result : Bits(p'LENGTH-1 downto 0);
	begin
		pTemp:=p;
		for i in 0 to pTemp'LENGTH-1 loop
			if (i<o) then
				result(i):=n;
			else
				result(i):=pTemp(i-o);
			end if;
		end loop;
		return result;
	end;

	--
	-- Shift a bit-vector right by number of bits and fill with n
	--
	function SHR(p:Bits;o:Dec;n:Bits1) return Bits is
		variable i : Dec;
		variable pTemp : Bits(p'LENGTH-1 downto 0);
		variable result : Bits(p'LENGTH-1 downto 0);
	begin
		pTemp:=p;
		for i in 0 to pTemp'LENGTH-1 loop
			if (i>pTemp'LENGTH-1-o) then
				result(i):=n;
			else
				result(i):=pTemp(i+o);
			end if;
		end loop;
		return result;
	end;

	--
	-- Shift a decimal left by 8 bits
	--
	function shlbyte(p:Dec) return Dec is
	begin
		return b2d(SHL(d2b(32,p),8,'0'));
	end;

	--
	-- Return Decimal number acording to bits given
	--
	function dec_bits(l,r,p:Dec) return Dec is
		variable Bitsp : Bits32;
	begin
		Bitsp:=d2b(32,p);
		if (l<r) then return b2d(Bitsp(r downto l)); end if;
		if (l=r) then return b2d(Bitsp(l)); end if;
		if (l>r) then return b2d(Bitsp(l downto r)); end if;
	end;

	--
	-- Subtraction implemented because of overflow
	--
	function subtract(p1,p2:Dec) return Dec is
		variable p1Bits,p2Bits : Bits32;
		variable result : SIGNED(31 downto 0);
	begin
		p1Bits:=d2b(32,p1);
		p2Bits:=d2b(32,p2);
		result:=SIGNED(p1Bits)-SIGNED(p2Bits);
		return b2d(Bits(result));
	end;

	--
	-- Binary to Decimal convertion
	--
	function b2d(p:Bits) return Dec is
		variable i : Dec;
		variable pTemp : Bits32;
	begin
		pTemp(p'LENGTH-1 downto 0):=p;
		for i in 31 downto p'LENGTH loop
			pTemp(i):='0';
		end loop;
		return CONV_INTEGER(SIGNED(pTemp));
	end;

	--
	-- Binary to Decimal convertion - 1 bit
	--
	function b2d(p:Bits1) return Dec is
		variable pBits : Bits(0 to 0);
	begin
		pBits(0):=p;
		return b2d(pBits);
	end;

	--
	-- Decimal to Binary convertion
	--
	function d2b(sz: Dec; p:Dec) return Bits is
	begin
		return Bits(CONV_SIGNED(p,sz));
	end;

	--
	-- Returns the hex-digit of one binary nibble
	--
	function bin2hex(p:Bits) return string is
		variable i,len : Dec;
		variable temp : Bits(3 downto 0);
	begin
		len:=p'LENGTH;
		if (len>4) then len:=4; end if;

		temp(len-1 downto 0):=p;
		for i in len to 3 loop
			temp(i):='0';
		end loop;

		case temp is
			when "0000" => return "0";
			when "0001" => return "1";
			when "0010" => return "2";
			when "0011" => return "3";
			when "0100" => return "4";
			when "0101" => return "5";
			when "0110" => return "6";
			when "0111" => return "7";
			when "1000" => return "8";
			when "1001" => return "9";
			when "1010" => return "A";
			when "1011" => return "B";
			when "1100" => return "C";
			when "1101" => return "D";
			when "1110" => return "E";
			when "1111" => return "F";
			when others =>	return "?";
		end case;
	end;

	--
	-- Returns the binary nibble of a hex-digit
	--
	function hex2bin(p:string) return Bits is
		variable PTemp : string(1 to p'LENGTH);
	begin
		pTemp:=p;
		case pTemp(pTemp'LENGTH) is
			when '0' => return "0000";
			when '1' => return "0001";
			when '2' => return "0010";
			when '3' => return "0011";
			when '4' => return "0100";
			when '5' => return "0101";
			when '6' => return "0110";
			when '7' => return "0111";
			when '8' => return "1000";
			when '9' => return "1001";
			when 'a'|'A' => return "1010";
			when 'b'|'B' => return "1011";
			when 'c'|'C' => return "1100";
			when 'd'|'D' => return "1101";
			when 'e'|'E' => return "1110";
			when 'f'|'F' => return "1111";
			when others =>	return "XXXX";
		end case;
	end;

	--
	-- Hex to binary convertion
	--
	function h2b(sz: Dec; p:string) return Bits is
		variable pTemp : string(1 to p'LENGTH);
		variable result : Bits(sz-1 downto 0);
		variable offset : Dec;
		variable i : Dec;
	begin
		pTemp:=p;
		offset:=pTemp'LENGTH;
		i:=0;
		while (i<=sz-1) loop
			if (offset>=1) then result(i+3 downto i) := hex2bin(pTemp(offset to offset));
			else result(i+3 downto i) := "0000"; end if;
			offset:=offset-1;
			i:=i+4;
		end loop;

		return result;
	end;

	--
	-- Binary to hex convertion
	--
	function b2h(sz:Dec; p:Bits) return string is
		variable result : string(1 to sz);
		variable temp : Bits(p'LENGTH-1 downto 0);
		variable offset : Dec;
		variable i,len : Dec;
	begin
		temp(p'LENGTH-1 downto 0) := p;

		offset:=0;
		for i in sz downto 1 loop
			len:=4;
			if (offset+len>p'LENGTH) then len:=p'LENGTH-offset; end if;
			if (len>0) then result(i to i):=bin2hex(temp(offset+len-1 downto offset));
			else result(i):='0'; end if;
			offset:=offset+4;
		end loop;
		return result;
	end;

	--
	-- Binary to hex convertion - 1 bit
	--
	function b2h(sz:Dec; p:Bits1) return string is
		variable pBits : Bits(0 to 0);
	begin
		pBits(0):=p;
		return b2h(sz,pBits);
	end;

	--
	-- Hex to decimal convertion
	--
	function h2d(p:string) return Dec is
	begin
		return b2d(h2b(p'LENGTH*4,p));
	end;

	--
	-- Decimal to hex convertion
	--
	function d2h(sz: Dec; p:Dec) return string is
	begin
		return b2h(sz,d2b(4*sz,p));
	end;

	--
	-- Overwriting the "not" operator for Bits
	--
	function "not"(r:Bits) return Bits is
		variable i : Dec;
		variable result : Bits(r'LENGTH-1 downto 0);
	begin
		result:=r;
		for i in result'LENGTH-1 downto 0 loop
			if result(i)='0' then
				result(i):='1';
			else
				result(i):='0';
			end if;
		end loop;
		return result;
	end;

	--
	-- Overwriting the "not" operator for Bits1
	--
	function "not"(r:Bits1) return Bits1 is
		variable pBits : Bits(0 to 0);
	begin
		pBits(0):=r;
		pBits:=not pBits;
		return pBits(0);
	end;

	--
	-- Overwriting the "and" operator for Bits
	--
	function "and"(l:Bits;r:Bits) return Bits is
		variable i : Dec;
		variable lTemp,rTemp:Bits(l'LENGTH-1 downto 0);
		variable result : Bits(l'LENGTH-1 downto 0);
	begin
		assert (l'LENGTH=r'LENGTH)
		report "and Bits not of equal lengths"
		severity failure;

		lTemp:=l;
		rTemp:=r;

		for i in l'LENGTH-1 downto 0 loop
			if ((lTemp(i)='1') and (rTemp(i)='1')) then
				result(i):='1';
			else
				result(i):='0';
			end if;
		end loop;
		return result;
	end;

	--
	-- Overwriting the "xor" operator for Bits
	--
	function "xor"(l:Bits;r:Bits) return Bits is
		variable i : Dec;
		variable lTemp,rTemp:Bits(l'LENGTH-1 downto 0);
		variable result : Bits(l'LENGTH-1 downto 0);
	begin
		assert (l'LENGTH=r'LENGTH)
		report "xor Bits not of equal lengths"
		severity failure;

		lTemp:=l;
		rTemp:=r;

		for i in l'LENGTH-1 downto 0 loop
			if (((lTemp(i)='1') and (rTemp(i)='0')) or
			    ((lTemp(i)='0') and (rTemp(i)='1'))) then
				result(i):='1';
			else
				result(i):='0';
			end if;
		end loop;
		return result;
	end;

	--
	-- Overwriting the "or" operator for Bits
	--
	function "or"(l:Bits;r:Bits) return Bits is
		variable i : Dec;
		variable lTemp,rTemp:Bits(l'LENGTH-1 downto 0);
		variable result : Bits(r'LENGTH-1 downto 0);
	begin
		assert (l'LENGTH=r'LENGTH)
		report "xor Bits not of equal lengths"
		severity failure;

		lTemp:=l;
		rTemp:=r;

		for i in r'LENGTH-1 downto 0 loop
			if (lTemp(i)='1') or (rTemp(i)='1') then
				result(i):='1';
			else
				result(i):='0';
			end if;
		end loop;
		return result;
	end;

	--
	-- Overwriting the "not" operator for Dec
	--
	function "not"(r:Dec) return Dec is
	begin
		return b2d(not d2b(32,r));
	end;

	--
	-- Overwriting the "and" operator for Dec
	--
	function "and"(l:Dec;r:Dec) return Dec is
	begin
		return b2d(d2b(32,l) and d2b(32,r));
	end;

	--
	-- Overwriting the "xor" operator for Dec
	--
	function "xor"(l:Dec;r:Dec) return Dec is
	begin
		return b2d(d2b(32,l) xor d2b(32,r));
	end;

	--
	-- Overwriting the "or" operator for Dec
	--
	function "or"(l:Dec;r:Dec) return Dec is
	begin
		return b2d(d2b(32,l) or d2b(32,r));
	end;

	--
	-- Overwriting the "+" operator for Bits
	--
	function "+"(l:Bits;r:Bits) return Bits is
		variable lBits,rBits : Bits(l'LENGTH-1 downto 0);
		variable result : SIGNED(l'LENGTH-1 downto 0);
	begin
		assert (l'LENGTH=r'LENGTH)
		report "Lengths must be identical in overwritten addition for Bits"
		severity failure;

		lBits:=l;
		rBits:=r;

		result:=SIGNED(lBits)+SIGNED(rBits);

		return Bits(result);
	end;

	--
	-- Overwriting the "-" operator for Bits
	--
	function "-"(l:Bits;r:Bits) return Bits is
		variable lBits,rBits : Bits(l'LENGTH-1 downto 0);
		variable result : SIGNED(l'LENGTH-1 downto 0);
	begin
		assert (l'LENGTH=r'LENGTH)
		report "Lengths must be identical in overwritten subtraction for Bits"
		severity failure;

		lBits:=l;
		rBits:=r;

		result:=SIGNED(lBits)-SIGNED(rBits);
		return Bits(result);
	end;

end RTPC_LIB;