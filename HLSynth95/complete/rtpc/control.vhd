--------------------------------------------------------------------------------
--
-- RTPC CPU Benchmark :
--	Control block for testing
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
use STD.textio.all;
use WORK.rtpc_lib.all;

entity CONTROL is
	Generic(	CLOCK_CYCLE : time := 10 ns;
			MEM_LATENCY : time := 100 ns;
			ADDRESS_SIZE : Dec := 24 );
	Port(		CLOCK : InOut Bits1 := '0';
			RESET : Out Bits1 := '1';
			RWb : Out Bits1 bus;
			CSb : Out Bits1 bus := '1';
			ADDRESS : Out Bits(ADDRESS_SIZE-1 downto 0) bus;
			DATA : InOut Bits8 bus;
			WAITING : In Bits1 );
end CONTROL;

architecture BEHAVIORAL of CONTROL is
begin
	process
		file MEM_DEV : text is out "dump.memory";	-- File to print memory-dumps to
		file ERR_DEV : text is out "dump.errors";	-- File to print compare-errors to
		file PRO_DEV : text is in "program";		-- File from which we read the control-program
		variable L : line;				-- Line to read to
		variable S : string(1 to 300);			-- String to work on

		variable addrMode : Dec := WriteToMemory;	-- Addressing mode / whether to compare or write number to memory
		variable dump1,dump2 : Dec;			-- Addresses from and to which a memory-dump shall be done
		variable base : Dec;				-- Offset in a string from where to extract the next number
		variable d : Dec;				-- Data to be written or compared to memory

		variable i : Dec;				-- Loop variable

		variable addr : Dec;				-- Address in memory
		variable MemoryBuffer : Dec;			-- Buffer from which you write to and read into from memory

		--
		-- Clears the read-program string
		--
		function clear_string(sz: Dec) return string is
			variable temp : string (1 to sz);
		begin
			return temp;
		end;

		--
		-- Extracts a number from the string p, if there is one starting at base
		--
		function extract_hex(base: Dec; p: string) return Dec is
			variable i, ind : Dec;
		begin
			ind := base;
			while TRUE loop
				case p(ind) is
					when '0' to '9' | 'a' to 'f' | 'A' to 'F' =>
						ind:=ind+1;
					when others =>
						exit;
				end case;
			end loop;
			if (ind=base)  then return(-1); end if;
			return h2d("0" & p(base to ind-1));
		end;

		--
		-- Calculates the next base of a number in the string p
		--
		function next_base(base: Dec; p: string) return Dec is
			variable i, ind: Dec;
		begin
			ind := base;
			while TRUE loop
				case p(ind) is
					when '0' to '9' | 'a' to 'f' | 'A' to 'F' =>
						ind:=ind+1;
					when others =>
						exit;
				end case;
			end loop;
			return(ind+1);
		end;
	
		--
		-- Timed-read from memory at address a into global variable MemoryBuffer
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
		-- Timed-write into memory at address a from global variable MemoryBuffer
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
		-- Ascii-code of Decimal numbers
		--
		function ascii(N: Dec) return string is
		begin
			case N is
				when 32 => return " ";

				when 39 => return "'";

				when 44 => return ",";

				when 65 => return "A";
				when 66 => return "B";
				when 67 => return "C";
				when 68 => return "D";
				when 69 => return "E";
				when 70 => return "F";
				when 71 => return "G";
				when 72 => return "H";
				when 73 => return "I";
				when 74 => return "J";
				when 75 => return "K";
				when 76 => return "L";
				when 77 => return "M";
				when 78 => return "N";
				when 79 => return "O";
				when 80 => return "P";
				when 81 => return "Q";
				when 82 => return "R";
				when 83 => return "S";
				when 84 => return "T";
				when 85 => return "U";
				when 86 => return "V";
				when 87 => return "W";
				when 88 => return "X";
				when 89 => return "Y";
				when 90 => return "Z";

				when 97 => return "a";
				when 98 => return "b";
				when 99 => return "c";
				when 100 => return "d";
				when 101 => return "e";
				when 102 => return "f";
				when 103 => return "g";
				when 104 => return "h";
				when 105 => return "i";
				when 106 => return "j";
				when 107 => return "k";
				when 108 => return "l";
				when 109 => return "m";
				when 110 => return "n";
				when 111 => return "o";
				when 112 => return "p";
				when 113 => return "q";
				when 114 => return "r";
				when 115 => return "s";
				when 116 => return "t";
				when 117 => return "u";
				when 118 => return "v";
				when 119 => return "w";
				when 120 => return "x";
				when 121 => return "y";
				when 122 => return "z";

				when others => return "?";
			end case;
		end;

	begin
		if endfile(PRO_DEV) then
			assert FALSE
			report "File end"
			severity failure;
		end if;

		readline(PRO_DEV,L);

		S := clear_string(S'LENGTH);
		read(L,S(1 to L'LENGTH));
	
		case S(1 to 3) is
			when "COM"|"com" =>			-- Compare the comming data to Memory
				addrMode:=CompareMemory;
			when "MEM"|"mem" =>			-- Dump Memory to file
				base:=5;
				dump1:=extract_hex(base,S);
				base:=next_base(base,S);
				dump2:=extract_hex(base,S);
				
				write(L,"@" & d2h(5,dump1-(dump1 mod 4)));
				writeline(MEM_DEV,L);

				base:=1;
				S := clear_string(S'LENGTH);
				S(1 to 11):="00 00 00 00";

				for i in dump1 to dump2 loop
					ReadMem(i);
					S(base to base+2):=d2h(2,MemoryBuffer) & " ";
					base:=base+3;
					if (base=13) then
						write(L,S(1 to 11));
						writeline(MEM_DEV,L);
						base:=1;
					end if;
				end loop;

				if (S(1)/=' ') then
					write(L,S(1 to base-2));
					writeline(MEM_DEV,L);				
				end if;
			when "QUI"|"qui" =>			-- Quit
				assert FALSE
				report "File quit"
				severity failure;
			when "RUN"|"run" =>			-- Run the program
				ADDRESS <= null;
				DATA <= null;
				RWb <= null;
				CSb <= null;
				RESET <= '0';

				S(1 to 25):="=========================";
				write(L,S(1 to 25));
				writeline(ERR_DEV,L);

				S(1 to 25):="=========================";
				write(L,S(1 to 25));
				writeline(MEM_DEV,L);

				wait until rising_edge(WAITING);

				RESET <= '1';
				wait for CLOCK_CYCLE;
			when "WRI"|"wri" =>			-- Write the comming data to memory
				addrMode:=WriteToMemory;
			when others =>
				case S(1) is
					when '@' =>
						base:=3;
						addr := extract_hex(base,S);
					when '0' to '9' | 'a' to 'f' | 'A' to 'F'=>
						base:=1;
						d := extract_hex(base,S);
						while (d/=-1) loop
							if (addrMode=WriteToMemory) then
								MemoryBuffer:=d;
								WriteMem(addr);
							end if;

							if (addrMode=CompareMemory) then
								ReadMem(addr);
								if (MemoryBuffer/=d) then
									write(L,d2h(5,addr) & " = " & d2h(2,MemoryBuffer) & "(" & ascii(MemoryBuffer) & ")" & " /= " & d2h(2,d) & "(" & ascii(d) & ")");
									writeline(ERR_DEV,L);
								end if;
							end if;

							addr:=addr+1;
							base:=next_base(base,S);
							d := extract_hex(base,S);
						end loop;
					when others =>
				end case;
		end case;
	end process;

	CLOCK <= not CLOCK after CLOCK_CYCLE;	
end BEHAVIORAL;

configuration CONTROL_CFG of CONTROL is
	for BEHAVIORAL
	end for;
end CONTROL_CFG;