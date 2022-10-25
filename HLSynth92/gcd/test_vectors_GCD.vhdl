--------------------------------------------------------------------------------
--
-- GCD factorization Benchmark
--
-- Source:  "Algorithmics by Brassard and Bradley "
--
-- VHDL Benchmark author: Champaka Ramachandran
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes   Champaka Ramachandran  11th Sept 92    ZYCAD
--  Functionality     yes   Champaka Ramachandran  11th Sept 92    ZYCAD
--------------------------------------------------------------------------------

use work.BIT_FUNCTIONS.all;

Entity E is
end;

architecture A of E is
   component GCD
     port (X          : in bit_vector(7 downto 0);
           Y          : in bit_vector(7 downto 0);
           Reset      : in bit;
           gcd_output : out bit_vector(7 downto 0));
   end component;

signal X, Y, gcd_output: bit_vector(7 downto 0);
signal Reset: bit;

for all : GCD use entity work.GCD(GCD) ;

begin
 INST1 : GCD port map(X, Y, Reset, gcd_output);

process

begin

  wait for 10 ns;

-- ****************************************** 
-- *                                        * 
-- *           TEST VECTORS                 * 
-- *                                        * 
-- ****************************************** 

-- X and Y are small and equal x = 1, y = 1, reset = 0

  X <= "00000001";
  Y <= "00000001";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000001"
    report "gcd_output does not match in pattern 1"
      severity error;

-- X and Y are small and divisible x = 2, y = 1, reset = 0

  X <= "00000010";
  Y <= "00000001";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000001"
    report "gcd_output does not match in pattern 2"
      severity error;

-- X and Y are small and divisible 2 times x = 6, y = 3, reset = 0

  X <= "00000110";
  Y <= "00000011";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000011"
    report "gcd_output does not match in pattern 3"
      severity error;

-- X and Y are small and divisible 4 times x = 12, y = 3, reset = 0

  X <= "00001100";
  Y <= "00000011";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000011"
    report "gcd_output does not match in pattern 4"
      severity error;

-- X and Y are small and divisible x = 1, y = 2, reset = 0

  X <= "00000001";
  Y <= "00000010";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000001"
    report "gcd_output does not match in pattern 5"
      severity error;

-- X and Y are small and divisible 2 times x = 3, y = 6, reset = 0

  X <= "00000011";
  Y <= "00000110";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000011"
    report "gcd_output does not match in pattern 6"
      severity error;

-- X and Y are small and divisible 4 times x = 3, y = 12, reset = 0

  X <= "00000011";
  Y <= "00001100";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000011"
    report "gcd_output does not match in pattern 7"
      severity error;

-- X and Y are small and divisible 4 times x = 12, y = 6, reset = 1

  X <= "00001100";
  Y <= "00000110";
  Reset <= '1';
  wait for 10 ns;
  assert gcd_output = "00000000"
    report "gcd_output does not match in pattern 8"
      severity error;

-- X and Y are not divisible x = 28, y = 5, reset = 0

  X <= "00011100";
  Y <= "00000101";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000001"
    report "gcd_output does not match in pattern 9"
      severity error;

-- X and Y are not divisible x = 5, y = 28, reset = 0

  X <= "00000101";
  Y <= "00011100";

  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000001"
    report "gcd_output does not match in pattern 10"
      severity error;

-- X and Y are not divisible x = 28, y = 5, reset = 1

  X <= "00011100";
  Y <= "00000111";
  Reset <= '1';
  wait for 10 ns;
  assert gcd_output = "00000000"
    report "gcd_output does not match in pattern 11"
      severity error;

-- X and Y are equal x = 28, y = 28, reset = 0

  X <= "00011100";
  Y <= "00011100";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00011100"
    report "gcd_output does not match in pattern 12"
      severity error;

-- X and Y are equal x = 28, y = 28, reset = 1

  X <= "00011100";
  Y <= "00011100";
  Reset <= '1';
  wait for 10 ns;
  assert gcd_output = "00000000"
    report "gcd_output does not match in pattern 13"
      severity error;

-- Y is large , x = 3, y = 192, reset = 0

  X  <= "00000011";
  Y  <= "11000000";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000011"
    report "gcd_output does not match in pattern 14"
      severity error;


-- X is large , x = 192, y = 3, reset = 0

  X  <= "00000011";
  Y  <= "11000000";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000011"
    report "gcd_output does not match in pattern 15"
      severity error;


-- X and Y are large, X > Y, and X is not divisible by Y, x = 208, y = 64, reset = 0

  X  <= "01000000";
  Y  <= "11010000";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00010000"
    report "gcd_output does not match in pattern 16"
      severity error;


-- X and Y are large, X < Y and Y is not divisible by X, x = 38, y = 158, reset = 0

  X  <= "00100110";
  Y  <= "10011110";
  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000010"
    report "gcd_output does not match in pattern 17"
      severity error;



-- X and Y are large, X > Y and X is not divisible by X, x = 158, y = 38, reset = 0

  X  <= "10011110";
  Y  <= "00100110";

  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000010"
    report "gcd_output does not match in pattern 18"
      severity error;


-- X and Y are large, almost equal and are not divisible, x = 158, y = 192, reset = 0

  X  <= "10011110";
  Y  <= "11000000";

  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000010"
    report "gcd_output does not match in pattern 19"
      severity error;


-- X and Y are large, almost equal and are not divisible, x = 158, y = 192, reset = 1

  X  <= "10011110";
  Y  <= "11000000";

  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000010"
    report "gcd_output does not match in pattern 20"
      severity error;

-- X = 0, Y is large, x = 0, y = 192, reset = 0

  X  <= "00000000";
  Y  <= "11000000";

  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000000"
    report "gcd_output does not match in pattern 21"
      severity error;


-- X is large, Y = 0, x = 192, y = 0, reset = 0

  X  <= "11000000";
  Y  <= "00000000";

  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000000"
    report "gcd_output does not match in pattern 22"
      severity error;


-- X = 0, Y = 0, x = 0, y = 0, reset = 0

  X  <= "00000000";
  Y  <= "00000000";

  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000000"
    report "gcd_output does not match in pattern 23"
      severity error;


-- X = 0, Y = 0, x = 0, y = 0, reset = 1

  X  <= "00000000";
  Y  <= "00000000";

  Reset <= '0';
  wait for 10 ns;
  assert gcd_output = "00000000"
    report "gcd_output does not match in pattern 24"
      severity error;


end process;
end;

-- configuration cgcd of E is
--   for A
--   for all: gcd
--      use entity WORK.GCD(behavior);
--   end for;
--   end for;
--end cgcd;

