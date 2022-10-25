----------------------------------------------------------------------------------
-- Radix-512 Divider Benchmark
--
-- Source:  "Division and Square Root: Digit-Recurrence Algorithms and
--           Implementations" M.D. Ergegovac, T. Lang
--
-- VHDL Benchmark author: Alberto Nannarelli on Jan 18 1994
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Alberto Nannarelli   1 Feb 94      Synopsys
--  Functionality     yes     Alberto Nannarelli   1 Feb 94      Synopsys
--
-- Modification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------       ---------     -----------
--  Syntax            yes     Alberto Nannarelli  22 Feb 94      Synopsys
--  Functionality     yes     Alberto Nannarelli  22 Feb 94      Synopsys
--
--------------------------------------------------------------------------------
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

Entity E is
   generic( simulation_delay : time := 10 ns );
end;

architecture A of E is
   component radix512
   port( x,d: in std_logic_vector (52 downto 0);
           q: out std_logic_vector (52 downto 0));
   end component;

signal x,d: std_logic_vector(52 downto 0);
signal   q: std_logic_vector(52 downto 0);

for all : radix512 use entity work.radix512(radix512) ;

begin
 INST1 : radix512 port map( x, d, q );

process

begin

  wait for simulation_delay ;

-- ****************************************** 
-- *                                        * 
-- *           TEST VECTORS                 * 
-- *                                        * 
-- ****************************************** 

---------------------------------------------------------------------------
-- x = 0.750000, d = 0.875000, q = 0.857143

  x <= "11000000000000000000000000000000000000000000000000000" ;

  d <= "11100000000000000000000000000000000000000000000000000" ;

  wait for 70 ns;
  assert q = "11011011011011011011011011011011011011011011011011011"
    report "q does not match in pattern 1"
	severity error;

---------------------------------------------------------------------------
-- x = 0.656250, d = 0.875000, q = 0.750000

  x <= "10101000000000000000000000000000000000000000000000000" ;

  d <= "11100000000000000000000000000000000000000000000000000" ;

  wait for 70 ns;
  assert q = "11000000000000000000000000000000000000000000000000000"
    report "q does not match in pattern 2"
	severity error;

---------------------------------------------------------------------------
-- x = 0.500000, d = 0.600000, q = 0.833333

  x <= "10000000000000000000000000000000000000000000000000000" ;

  d <= "10011001100110011001101000000000000000000000000000000" ;

  wait for 70 ns;
  assert q = "11010101010101010101010011000111000111000111001000101"
    report "q does not match in pattern 3"
	severity error;

---------------------------------------------------------------------------
-- x = 0.500000, d = 1.0 - 2^(-53), q = 0.5 + 2^(-53)
-- d is the maximum value in the range

  x <= "10000000000000000000000000000000000000000000000000000" ;

  d <= "11111111111111111111111111111111111111111111111111111" ;

  wait for 70 ns;
  assert q = "10000000000000000000000000000000000000000000000000001"
    report "q does not match in pattern 4"
	severity error;

---------------------------------------------------------------------------
-- x = 0.250000, d = 0.500000, q = 0.500000
-- x is the minumum value in the range
-- d is the minumum value in the range

  x <= "01000000000000000000000000000000000000000000000000000" ;

  d <= "10000000000000000000000000000000000000000000000000000" ;

  wait for 70 ns;
  assert q = "10000000000000000000000000000000000000000000000000000"
    report "q does not match in pattern 5"
	severity error;

---------------------------------------------------------------------------
-- x = 0.250000, d = 1.0 - 2^(-53), q = 0.250000
-- x is the minumum value in the range
-- d is the maximum value in the range

  x <= "01000000000000000000000000000000000000000000000000000" ;

  d <= "11111111111111111111111111111111111111111111111111111" ;

  wait for 70 ns;
  assert q = "01000000000000000000000000000000000000000000000000000"
    report "q does not match in pattern 6"
	severity error;

---------------------------------------------------------------------------
-- x = 1.0 - 2^(-53) - 2^(-52), d = 1.0 - 2^(-53), q = 1.0 - 2^(-53)
-- x and d very close to d upper bound

  x <= "11111111111111111111111111111111111111111111111111110" ;

  d <= "11111111111111111111111111111111111111111111111111111" ;

  wait for 70 ns;
  assert q = "11111111111111111111111111111111111111111111111111111"
    report "q does not match in pattern 7"
	severity error;

---------------------------------------------------------------------------
-- x = 0.500000, d = 0.5 + 2^(-53), q = 1.0 - 2^(-52)
-- x and d very close to d lowest bound

  x <= "10000000000000000000000000000000000000000000000000000" ;

  d <= "10000000000000000000000000000000000000000000000000001" ;

  wait for 70 ns;
  assert q = "11111111111111111111111111111111111111111111111111110"
    report "q does not match in pattern 8"
	severity error;

---------------------------------------------------------------------------
-- x = 0.50 - 2^(-53), d = 0.50, q = 1.0 - 2^(-53) - 2^(-52)

  x <= "01111111111111111111111111111111111111111111111111111" ;

  d <= "10000000000000000000000000000000000000000000000000000" ;

  wait for 70 ns;
  assert q = "11111111111111111111111111111111111111111111111111110"
    report "q does not match in pattern 9"
	severity error;

---------------------------------------------------------------------------
-- x = 0.50 - 2^(-53), d = 0.75 - 2^(-53), q = 0.666667

  x <= "01111111111111111111111111111111111111111111111111111" ;

  d <= "10111111111111111111111111111111111111111111111111111" ;

  wait for 70 ns;
  assert q = "10101010101010101010101010101010101010101010101010101"
    report "q does not match in pattern 10"
	severity error;

---------------------------------------------------------------------------

end process;
end;
