--------------------------------------------------------------------------------
--
-- Traffic Light Controller (TLC) -- Simulation Vectors
--
-- Source:  Hardware C version  written by David Ku on June 8, 1988 at Stanford
--
-- VHDL Benchmark author Champaka Ramachandran
--                       University Of California, Irvine, CA 92717
--                       champaka@balboa.eng.uci.edu
--                 
-- Developed on Aug 11, 1992
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes    Champaka Ramachandran  Aug 11, 92    ZYCAD
--  Functionality     yes    Champaka Ramachandran  Aug 11, 92    ZYCAD
--------------------------------------------------------------------------------

Entity E is
end;

architecture A of E is
       Component TLC
       port (
                       Cars : in  BIT;
                       TimeoutL : in  BIT;
                       TimeoutS : in  BIT;
                       StartTimer : out  BIT;
                       HiWay : out  Bit_Vector(2 Downto 0);
                       FarmL : out  Bit_Vector(2 Downto 0);
                       state : out  bit_vector(2 downto 0)
       );
       end component ;

                       signal Cars : BIT;
                       signal TimeoutL : BIT;
                       signal TimeoutS : BIT;
                       signal StartTimer : BIT;
                       signal HiWay : Bit_Vector(2 Downto 0);
                       signal FarmL : Bit_Vector(2 Downto 0);
                       signal state : bit_vector(2 downto 0);

for all : TLC use entity work.TLC(TLC) ;

begin

INST1 : TLC port map (
                       Cars,
                       TimeoutL,
                       TimeoutS,
                       StartTimer,
                       HiWay,
                       FarmL,
                       state
                    );

process
begin

-- ****************************************** 
-- *                                        * 
-- *           TEST VECTORS                 * 
-- *                                        * 
-- ****************************************** 
--
wait for 9 ns;
--
-- Pattern #0
Cars <= '1';
TimeoutL <= '1';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 0 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "100")
report
"Assert 0 : < HiWay /= 100 >"
severity warning;

assert (FarmL = "110")
report
"Assert 0 : < FarmL /= 110 >"
severity warning;

assert (state = "100")
report
"Assert 0 : < state /= 100 >"
severity warning;
--
-- Pattern #1
Cars <= '0';
TimeoutL <= '0';
TimeoutS <= '1';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 1 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "010")
report
"Assert 1 : < HiWay /= 010 >"
severity warning;

assert (FarmL = "110")
report
"Assert 1 : < FarmL /= 110 >"
severity warning;

assert (state = "010")
report
"Assert 1 : < state /= 010 >"
severity warning;
--
-- Pattern #2
Cars <= '1';
TimeoutL <= '0';
TimeoutS <= '1';
wait for 10 ns;


assert (StartTimer = '0')
report
"Assert 2 : < StartTimer /= 0 >"
severity warning;

assert (HiWay = "110")
report
"Assert 2 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "100")
report
"Assert 2 : < FarmL /= 100 >"
severity warning;

assert (state = "010")
report
"Assert 2 : < state /= 010 >"
severity warning;
--
-- Pattern #3
Cars <= '0';
TimeoutL <= '0';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 3 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "110")
report
"Assert 3 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "100")
report
"Assert 3 : < FarmL /= 100 >"
severity warning;

assert (state = "110")
report
"Assert 3 : < state /= 110 >"
severity warning;
--
-- Pattern #4
Cars <= '0';
TimeoutL <= '0';
TimeoutS <= '1';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 4 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "110")
report
"Assert 4 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "010")
report
"Assert 4 : < FarmL /= 010 >"
severity warning;

assert (state = "000")
report
"Assert 4 : < state /= 000 >"
severity warning;
--
-- Pattern #5
Cars <= '1';
TimeoutL <= '1';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 5 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "100")
report
"Assert 5 : < HiWay /= 100 >"
severity warning;

assert (FarmL = "110")
report
"Assert 5 : < FarmL /= 110 >"
severity warning;

assert (state = "100")
report
"Assert 5 : < state /= 100 >"
severity warning;
--
-- Pattern #6
Cars <= '0';
TimeoutL <= '0';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '0')
report
"Assert 6 : < StartTimer /= 0 >"
severity warning;

assert (HiWay = "010")
report
"Assert 6 : < HiWay /= 010 >"
severity warning;

assert (FarmL = "110")
report
"Assert 6 : < FarmL /= 110 >"
severity warning;

assert (state = "110")
report
"Assert 6 : < state /= 110 >"
severity warning;
--
-- Pattern #7
Cars <= '0';
TimeoutL <= '1';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '0')
report
"Assert 7 : < StartTimer /= 0 >"
severity warning;

assert (HiWay = "110")
report
"Assert 7 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "010")
report
"Assert 7 : < FarmL /= 010 >"
severity warning;

assert (state = "110")
report
"Assert 7 : < state /= 110 >"
severity warning;
--
-- Pattern #8
Cars <= '0';
TimeoutL <= '1';
TimeoutS <= '1';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 8 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "110")
report
"Assert 8 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "010")
report
"Assert 8 : < FarmL /= 010 >"
severity warning;

assert (state = "000")
report
"Assert 8 : < state /= 000 >"
severity warning;
--
-- Pattern #9
Cars <= '1';
TimeoutL <= '0';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '0')
report
"Assert 9 : < StartTimer /= 0 >"
severity warning;

assert (HiWay = "100")
report
"Assert 9 : < HiWay /= 100 >"
severity warning;

assert (FarmL = "110")
report
"Assert 9 : < FarmL /= 110 >"
severity warning;

assert (state = "000")
report
"Assert 9 : < state /= 000 >"
severity warning;
--
-- Pattern #10
Cars <= '1';
TimeoutL <= '0';
TimeoutS <= '1';
wait for 10 ns;


assert (StartTimer = '0')
report
"Assert 10 : < StartTimer /= 0 >"
severity warning;

assert (HiWay = "100")
report
"Assert 10 : < HiWay /= 100 >"
severity warning;

assert (FarmL = "110")
report
"Assert 10 : < FarmL /= 110 >"
severity warning;

assert (state = "000")
report
"Assert 10 : < state /= 000 >"
severity warning;
--
-- Pattern #11
Cars <= '1';
TimeoutL <= '1';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 11 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "100")
report
"Assert 11 : < HiWay /= 100 >"
severity warning;

assert (FarmL = "110")
report
"Assert 11 : < FarmL /= 110 >"
severity warning;

assert (state = "100")
report
"Assert 11 : < state /= 100 >"
severity warning;
--
-- Pattern #12
Cars <= '1';
TimeoutL <= '1';
TimeoutS <= '1';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 12 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "010")
report
"Assert 12 : < HiWay /= 010 >"
severity warning;

assert (FarmL = "110")
report
"Assert 12 : < FarmL /= 110 >"
severity warning;

assert (state = "010")
report
"Assert 12 : < state /= 010 >"
severity warning;
--
-- Pattern #13
Cars <= '1';
TimeoutL <= '0';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '0')
report
"Assert 13 : < StartTimer /= 0 >"
severity warning;

assert (HiWay = "110")
report
"Assert 13 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "100")
report
"Assert 13 : < FarmL /= 100 >"
severity warning;

assert (state = "010")
report
"Assert 13 : < state /= 010 >"
severity warning;
--
-- Pattern #14
Cars <= '1';
TimeoutL <= '1';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 14 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "110")
report
"Assert 14 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "100")
report
"Assert 14 : < FarmL /= 100 >"
severity warning;

assert (state = "110")
report
"Assert 14 : < state /= 110 >"
severity warning;
--
-- Pattern #15
Cars <= '1';
TimeoutL <= '0';
TimeoutS <= '1';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 15 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "110")
report
"Assert 15 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "010")
report
"Assert 15 : < FarmL /= 010 >"
severity warning;

assert (state = "000")
report
"Assert 15 : < state /= 000 >"
severity warning;
--
-- Pattern #16
Cars <= '1';
TimeoutL <= '0';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '0')
report
"Assert 16 : < StartTimer /= 0 >"
severity warning;

assert (HiWay = "100")
report
"Assert 16 : < HiWay /= 100 >"
severity warning;

assert (FarmL = "110")
report
"Assert 16 : < FarmL /= 110 >"
severity warning;

assert (state = "000")
report
"Assert 16 : < state /= 000 >"
severity warning;
--
-- Pattern #17
Cars <= '1';
TimeoutL <= '0';
TimeoutS <= '1';
wait for 10 ns;


assert (StartTimer = '0')
report
"Assert 17 : < StartTimer /= 0 >"
severity warning;

assert (HiWay = "100")
report
"Assert 17 : < HiWay /= 100 >"
severity warning;

assert (FarmL = "110")
report
"Assert 17 : < FarmL /= 110 >"
severity warning;

assert (state = "000")
report
"Assert 17 : < state /= 000 >"
severity warning;
--
-- Pattern #18
Cars <= '1';
TimeoutL <= '1';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 18 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "100")
report
"Assert 18 : < HiWay /= 100 >"
severity warning;

assert (FarmL = "110")
report
"Assert 18 : < FarmL /= 110 >"
severity warning;

assert (state = "100")
report
"Assert 18 : < state /= 100 >"
severity warning;
--
-- Pattern #19
Cars <= '1';
TimeoutL <= '1';
TimeoutS <= '1';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 19 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "010")
report
"Assert 19 : < HiWay /= 010 >"
severity warning;

assert (FarmL = "110")
report
"Assert 19 : < FarmL /= 110 >"
severity warning;

assert (state = "010")
report
"Assert 19 : < state /= 010 >"
severity warning;
--
-- Pattern #20
Cars <= '1';
TimeoutL <= '0';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '0')
report
"Assert 20 : < StartTimer /= 0 >"
severity warning;

assert (HiWay = "110")
report
"Assert 20 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "100")
report
"Assert 20 : < FarmL /= 100 >"
severity warning;

assert (state = "010")
report
"Assert 20 : < state /= 010 >"
severity warning;
--
-- Pattern #21
Cars <= '0';
TimeoutL <= '0';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 21 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "110")
report
"Assert 21 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "100")
report
"Assert 21 : < FarmL /= 100 >"
severity warning;

assert (state = "110")
report
"Assert 21 : < state /= 110 >"
severity warning;

--
-- Pattern #22
Cars <= '0';
TimeoutL <= '0';
TimeoutS <= '0';
wait for 10 ns;


assert (StartTimer = '0')
report
"Assert 22 : < StartTimer /= 0 >"
severity warning;

assert (HiWay = "110")
report
"Assert 22 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "010")
report
"Assert 22 : < FarmL /= 010 >"
severity warning;

assert (state = "110")
report
"Assert 22 : < state /= 110  >"
severity warning;

--
-- Pattern #23
Cars <= '0';
TimeoutL <= '0';
TimeoutS <= '1';
wait for 10 ns;


assert (StartTimer = '1')
report
"Assert 23 : < StartTimer /= 1 >"
severity warning;

assert (HiWay = "110")
report
"Assert 23 : < HiWay /= 110 >"
severity warning;

assert (FarmL = "010")
report
"Assert 23 : < FarmL /= 010 >"
severity warning;

assert (state = "000")
report
"Assert 23 : < state /= 000 >"
severity warning;


end process;

end A;
