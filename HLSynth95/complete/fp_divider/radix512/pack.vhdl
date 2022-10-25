----------------------------------------------------------------------------------
-- Radix-512 Divider Benchmark Library
--
-- VHDL Benchmark author: Alberto Nannarelli on Jan 18 1994
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------       ---------     ------------
--  Syntax            yes     Alberto Nannarelli  28 Jan 94      Synopsys
--  Functionality     yes     Alberto Nannarelli  28 Jan 94      Synopsys
--------------------------------------------------------------------------------

Library IEEE;            
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

PACKAGE divider IS

  function csa_sum(a,b,c : std_logic_vector (66 downto 0))
	   return std_logic_vector ;

  function csa_carry(a,b,c : std_logic_vector (66 downto 0))
	   return std_logic_vector ;

  function left_shift(a : std_logic_vector (66 downto 0); n : integer)
	   return std_logic_vector ;

  function right_shift(a : std_logic_vector (66 downto 0); n : integer;
		       m : integer)
	   return std_logic_vector ;

  function two_complement(a : std_logic_vector (66 downto 0))
	   return std_logic_vector ;

  function fit(a : std_logic_vector ((66*2+1) downto 0))
	   return std_logic_vector ;

  function find_m(a : std_logic_vector (14 downto 0))
	   return std_logic_vector ;

  function put_result(a : std_logic_vector (66 downto 0))
	   return std_logic_vector ;

END divider;


PACKAGE BODY divider IS
-----------------------------------------------------------------------
  -- sum calculated in Carry-Save form
  function csa_sum(a,b,c : std_logic_vector (66 downto 0))
   return std_logic_vector is
   variable s: std_logic_vector (66 downto 0);
  begin
        for i in 0 to (66) loop
	   s(i) := a(i) XOR b(i) XOR c(i) ;
        end loop;
        return s;
  end csa_sum;
-----------------------------------------------------------------------
  -- carry calculated in Carry-Save form
  function csa_carry(a,b,c : std_logic_vector (66 downto 0))
   return std_logic_vector is
   variable s: std_logic_vector (66 downto 0);
  begin
	s(0):= '0' ;
        for i in 0 to (66-1) loop
	   s(i+1) := ( a(i) AND b(i) ) OR ( a(i) AND c(i) ) 
					   OR ( c(i) AND b(i) ) ;
        end loop;
        return s;
  end csa_carry;
-----------------------------------------------------------------------
  -- left shift
  function left_shift(a : std_logic_vector (66 downto 0); n : integer)
   return std_logic_vector is
   variable s: std_logic_vector (66 downto 0);
  begin
	for i in 0 to (66-n) loop
	    s(66-i) := a(66-n-i);
	end loop;
	for i in 0 to (n-1) loop
	    s(i) := '0';
	end loop;
	return s;
  end left_shift;
-----------------------------------------------------------------------
  -- right shift (if m=1 logical shift, otherwise arithmetic shift)
  function right_shift(a : std_logic_vector (66 downto 0); n : integer;
		       m : integer)
   return std_logic_vector is
   variable s: std_logic_vector (66 downto 0);
  begin
        for i in n to 66 loop
            s(i-n) := a(i);
        end loop;
        for i in (66-n+1) to 66 loop
	  if ( m = 1 ) then
            s(i) := '0';
	  else
            s(i) := a(66);
	  end if;
        end loop;
        return s;
  end right_shift;
-----------------------------------------------------------------------
  -- 2's complement
  function two_complement(a : std_logic_vector (66 downto 0))
   return std_logic_vector is
   variable s: std_logic_vector (66 downto 0);
  begin
        for i in 0 to 66 loop
            s(i) := NOT a(i);
        end loop;
	s := s + 1;
        return s;
  end two_complement;
-----------------------------------------------------------------------
  -- fit the result of a multiplication in a shortest variable
  function fit(a : std_logic_vector ((66*2+1) downto 0))
   return std_logic_vector is
   variable s: std_logic_vector (66 downto 0);
  begin
        for i in 0 to 66 loop
            s(i) := a(i+9);
        end loop;
        return s;
  end fit;
-----------------------------------------------------------------------
  -- calculates the scaling factor M from the divider d
  function find_m(a : std_logic_vector (14 downto 0))
   return std_logic_vector is
   variable s: std_logic_vector (13 downto 0);
   variable key: std_logic_vector (4 downto 0);
   variable gamma1, gamma2, agamma1, p : std_logic_vector (14 downto 0);
   variable double_m : std_logic_vector ((14*2+1) downto 0);
  begin

    for i in 0 to 4 loop
         key(i) := a(i+9);
    end loop;

    case key is

-- 	 d(i) = 00	 gamma1 = 3.878329     gamma2 = 3.938928
	 when "00000" => gamma1 := "111110000011011" ;
			 gamma2 := "111111000001011" ;

-- 	 d(i) = 01	 gamma1 = 3.650217     gamma2 = 3.821321
	 when "00001" => gamma1 := "111010011001110" ;
			 gamma2 := "111101001001000" ;

-- 	 d(i) = 02	 gamma1 = 3.441655     gamma2 = 3.710535
	 when "00010" => gamma1 := "110111000100010" ;
			 gamma2 := "111011010111100" ;

-- 	 d(i) = 03	 gamma1 = 3.250471     gamma2 = 3.605991
	 when "00011" => gamma1 := "110100000000011" ;
			 gamma2 := "111001101100100" ;

-- 	 d(i) = 04	 gamma1 = 3.074787     gamma2 = 3.507178
	 when "00100" => gamma1 := "110001001100100" ;
			 gamma2 := "111000000111010" ;

-- 	 d(i) = 05	 gamma1 = 2.912970     gamma2 = 3.413637
	 when "00101" => gamma1 := "101110100110111" ;
			 gamma2 := "110110100111100" ;

-- 	 d(i) = 06	 gamma1 = 2.763600     gamma2 = 3.324956
	 when "00110" => gamma1 := "101100001101111" ;
			 gamma2 := "110101001100110" ;

-- 	 d(i) = 07	 gamma1 = 2.625431     gamma2 = 3.240766
	 when "00111" => gamma1 := "101010000000011" ;
			 gamma2 := "110011110110100" ;

-- 	 d(i) = 08	 gamma1 = 2.497371     gamma2 = 3.160735
	 when "01000" => gamma1 := "100111111101010" ;
			 gamma2 := "110010100100100" ;

-- 	 d(i) = 09	 gamma1 = 2.378457     gamma2 = 3.084561
	 when "01001" => gamma1 := "100110000011100" ;
			 gamma2 := "110001010110100" ;

-- 	 d(i) = 10	 gamma1 = 2.267839     gamma2 = 3.011973
	 when "01010" => gamma1 := "100100010010010" ;
			 gamma2 := "110000001100010" ;

-- 	 d(i) = 11	 gamma1 = 2.164762     gamma2 = 2.942723
	 when "01011" => gamma1 := "100010101000101" ;
			 gamma2 := "101111000101010" ;

-- 	 d(i) = 12	 gamma1 = 2.068556     gamma2 = 2.876586
	 when "01100" => gamma1 := "100001000110001" ;
			 gamma2 := "101110000001100" ;

-- 	 d(i) = 13	 gamma1 = 1.978624     gamma2 = 2.813357
	 when "01101" => gamma1 := "011111101010000" ;
			 gamma2 := "101101000000111" ;

-- 	 d(i) = 14	 gamma1 = 1.894433     gamma2 = 2.752847
	 when "01110" => gamma1 := "011110010011111" ;
			 gamma2 := "101100000010111" ;

-- 	 d(i) = 15	 gamma1 = 1.815502     gamma2 = 2.694886
	 when "01111" => gamma1 := "011101000011000" ;
			 gamma2 := "101011000111100" ;

-- 	 d(i) = 16	 gamma1 = 1.741404     gamma2 = 2.639316
	 when "10000" => gamma1 := "011011110111001" ;
			 gamma2 := "101010001110101" ;

-- 	 d(i) = 17	 gamma1 = 1.671751     gamma2 = 2.585991
	 when "10001" => gamma1 := "011010101111110" ;
			 gamma2 := "101001011000000" ;

-- 	 d(i) = 18	 gamma1 = 1.606196     gamma2 = 2.534778
	 when "10010" => gamma1 := "011001101100101" ;
			 gamma2 := "101000100011100" ;

-- 	 d(i) = 19	 gamma1 = 1.544422     gamma2 = 2.485554
	 when "10011" => gamma1 := "011000101101011" ;
			 gamma2 := "100111110001001" ;

-- 	 d(i) = 20	 gamma1 = 1.486144     gamma2 = 2.438206
	 when "10100" => gamma1 := "010111110001110" ;
			 gamma2 := "100111000000101" ;

-- 	 d(i) = 21	 gamma1 = 1.431105     gamma2 = 2.392628
	 when "10101" => gamma1 := "010110111001011" ;
			 gamma2 := "100110010010000" ;

-- 	 d(i) = 22	 gamma1 = 1.379067     gamma2 = 2.348723
	 when "10110" => gamma1 := "010110000100001" ;
			 gamma2 := "100101100101000" ;

-- 	 d(i) = 23	 gamma1 = 1.329816     gamma2 = 2.306400
	 when "10111" => gamma1 := "010101010001101" ;
			 gamma2 := "100100111001110" ;

-- 	 d(i) = 24	 gamma1 = 1.283158     gamma2 = 2.265575
	 when "11000" => gamma1 := "010100100001111" ;
			 gamma2 := "100100001111111" ;

-- 	 d(i) = 25	 gamma1 = 1.238913     gamma2 = 2.226171
	 when "11001" => gamma1 := "010011110100101" ;
			 gamma2 := "100011100111100" ;

-- 	 d(i) = 26	 gamma1 = 1.196917     gamma2 = 2.188114
	 when "11010" => gamma1 := "010011001001101" ;
			 gamma2 := "100011000000101" ;

-- 	 d(i) = 27	 gamma1 = 1.157021     gamma2 = 2.151336
	 when "11011" => gamma1 := "010010100000110" ;
			 gamma2 := "100010011010111" ;

-- 	 d(i) = 28	 gamma1 = 1.119087     gamma2 = 2.115775
	 when "11100" => gamma1 := "010001111001111" ;
			 gamma2 := "100001110110100" ;

-- 	 d(i) = 29	 gamma1 = 1.082989     gamma2 = 2.081370
	 when "11101" => gamma1 := "010001010100111" ;
			 gamma2 := "100001010011010" ;

-- 	 d(i) = 30	 gamma1 = 1.048610     gamma2 = 2.048066
	 when "11110" => gamma1 := "010000110001110" ;
			 gamma2 := "100000110001001" ;

-- 	 d(i) = 31	 gamma1 = 1.015842     gamma2 = 2.015811
	 when "11111" => gamma1 := "010000010000001" ;
			 gamma2 := "100000010000001" ;

	 when others => null;
    end case;

    double_m := gamma1*a ;

    for i in 0 to 14 loop
        agamma1(i) := double_m(i+15);
    end loop;

    p := gamma2 - agamma1 ;
    for i in 0 to 13 loop
        s(i) := p(i);
    end loop;

    return s;
  end find_m;
-----------------------------------------------------------------------
  -- load the value of the final result to the output 
  function put_result(a : std_logic_vector (66 downto 0))
   return std_logic_vector is
   variable s: std_logic_vector (52 downto 0);
  begin
        for i in 0 to 52 loop
            s(i) := a(i+1);
        end loop;
        return s;
  end put_result;
-----------------------------------------------------------------------
 
END divider;
