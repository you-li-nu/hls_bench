--------------------------------------------------------------------------

-- SIMULATION TEST VECTORS FOR floating point multiplier algorithm

-- THE MODELS WERE SIMULATED ON THE Synopsys (VERSION 3.0a) SIMULATOR.

--  Developed on Mar 4, 1994 by :
--                                Jesse Pan,
--                                CADLAB,
--                                Univ. of Calif. , Irvine.
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Jesse Pan	           04 Mar 94    Synopsys
--  Functionality     yes     Jesse Pan	           04 Mar 94    Synopsys

--------------------------------------------------------------------------

use work.FPMULT_PKG.all;
entity atest is
end atest;

architecture test1 of atest is
	 component fmu
	  port (
		clk          : in bit;
		op1_sign     : in bit;
		op1_exp      : in exp;
		op1_mant     : in mantissa;
		op2_sign     : in bit;
		op2_exp      : in exp;
		op2_mant     : in mantissa;
		res_sign     : out bit;
		res_exp      : out exp;
		res_mant     : out mantissa;
		operation    : in op_type := idle;
		flags        : out bit_vector(3 downto 0)
	);
	end component;

		signal clk       : bit;
		signal op1_sign  : bit;
		signal op1_exp   : exp;
		signal op1_mant  : mantissa;
		signal op2_sign  : bit;
		signal op2_exp   : exp;
		signal op2_mant  : mantissa;
		signal res_sign  : bit;
		signal res_exp   : exp;
		signal res_mant  : mantissa;
		signal operation : op_type := idle;
		signal flags     :bit_vector(3 downto 0);

for a1 : fmu use entity work.fmu(fmu_behavior);

begin

A1 : fmu
	port map(
		clk,
		op1_sign,
		op1_exp,
		op1_mant,
		op2_sign,
		op2_exp,
		op2_mant,
		res_sign,
		res_exp,
		res_mant,
		operation,
		flags
	);
process

begin

-- ** 0 Initialize  ******
clk <= '0';
wait for 0 ns;

clk <= '1'; -- Cycle No: 0
wait for 5 ns;
clk <= '0';
wait for 5 ns;

-- *
-- ************************
-- *                      *
-- * NOMINAL TEST VECTORS *
-- *                      *
-- ************************
-- *
-- * test nominal cases 
-- * --------------------------
-- *
-- * (-0.25 * -0.5 = +0.125) -- Test Case #1
---------- 10 ns -----------

clk <= '1'; --	 Cycle No: 1

operation <= multiply;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 0 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  124 ) REPORT "Assert 1 : < res_exp /= 124 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 2 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0.75 * -2.0 = +1.5) -- Test Case #2
---------- 20 ns -----------

clk <= '1'; --	 Cycle No: 2

operation <= multiply;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 3 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 4 : < res_exp /= 127 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 5 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0.5 * 0.125 = -0.0625) -- Test Case #3
---------- 30 ns -----------

clk <= '1'; --	 Cycle No: 3

operation <= multiply;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  124 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 6 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  123 ) REPORT "Assert 7 : < res_exp /= 123 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 8 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0.625 * 1.0 = -0.625) -- Test Case #4
---------- 40 ns -----------

clk <= '1'; --	 Cycle No: 4

operation <= multiply;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "01000000000000000000000";
op2_sign <= '0';
op2_exp <=  127 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 9 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 10 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "01000000000000000000000") REPORT "Assert 11 : < res_mant /= 01000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-1.5 * -0.5 = +0.75) -- Test Case #5
---------- 50 ns -----------

clk <= '1'; --	 Cycle No: 5

operation <= multiply;
op1_sign <= '1';
op1_exp <=  127 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 12 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 13 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 14 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-2.75 * -2.75 = +7.5625) -- Test Case #6
---------- 60 ns -----------

clk <= '1'; --	 Cycle No: 6

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01100000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 15 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 16 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100100000000000000000") REPORT "Assert 17 : < res_mant /= 11100100000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-3.0 * 0.5 = -1.5) -- Test Case #7
---------- 70 ns -----------

clk <= '1'; --	 Cycle No: 7

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 18 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 19 : < res_exp /= 127 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 20 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-4.0 * 4.0 = -16) -- Test Case #8
---------- 80 ns -----------

clk <= '1'; --	 Cycle No: 8

operation <= multiply;
op1_sign <= '1';
op1_exp <=  129 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 21 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  131 ) REPORT "Assert 22 : < res_exp /= 131 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 23 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.5 * -0.25 = -0.125) -- Test Case #9
---------- 90 ns -----------

clk <= '1'; --	 Cycle No: 9

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 24 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  124 ) REPORT "Assert 25 : < res_exp /= 124 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 26 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.75 * -1.0 = -0.75) -- Test Case #10
---------- 100 ns -----------

clk <= '1'; --	 Cycle No: 10

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  127 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 27 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 28 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 29 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.75 * 0.75 = 0.5625) -- Test Case #11
---------- 110 ns -----------

clk <= '1'; --	 Cycle No: 11

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 30 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 31 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "00100000000000000000000") REPORT "Assert 32 : < res_mant /= 00100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.5 * 7.0 = 3.5) -- Test Case #12
---------- 120 ns -----------

clk <= '1'; --	 Cycle No: 12

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 33 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 34 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "11000000000000000000000") REPORT "Assert 35 : < res_mant /= 11000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (5.0 * -0.25 = -1.25) -- Test Case #13
---------- 130 ns -----------

clk <= '1'; --	 Cycle No: 13

operation <= multiply;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "01000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 36 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 37 : < res_exp /= 127 >"
	SEVERITY warning;
ASSERT (res_mant = "01000000000000000000000") REPORT "Assert 38 : < res_mant /= 01000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (9.0 * -11.0 = -99) -- Test Case #14
---------- 140 ns -----------

clk <= '1'; --	 Cycle No: 14

operation <= multiply;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "00100000000000000000000";
op2_sign <= '1';
op2_exp <=  130 ;
op2_mant <= "01100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 39 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  133 ) REPORT "Assert 40 : < res_exp /= 133 >"
	SEVERITY warning;
ASSERT (res_mant = "10001100000000000000000") REPORT "Assert 41 : < res_mant /= 10001100000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (13.5 * 0.5 = 6.75) -- Test Case #15
---------- 150 ns -----------

clk <= '1'; --	 Cycle No: 15

operation <= multiply;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "10110000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 42 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 43 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "10110000000000000000000") REPORT "Assert 44 : < res_mant /= 10110000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (19.0 * 6.0 = 114.0) -- Test Case #16
---------- 160 ns -----------

clk <= '1'; --	 Cycle No: 16

operation <= multiply;
op1_sign <= '0';
op1_exp <=  131 ;
op1_mant <= "00110000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 45 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  133 ) REPORT "Assert 46 : < res_exp /= 133 >"
	SEVERITY warning;
ASSERT (res_mant = "11001000000000000000000") REPORT "Assert 47 : < res_mant /= 11001000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0.25 * -0.5 = 0.125) -- Test Case #17 
---------- 170 ns -----------

clk <= '1'; --	 Cycle No: 17

operation <= multiply;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 48 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  124 ) REPORT "Assert 49 : < res_exp /= 124 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 50 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0.75 * -2.0 = 1.5)	-- Test Case #18
---------- 180 ns -----------

clk <= '1'; --	 Cycle No: 18

operation <= multiply;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 51 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 52 : < res_exp /= 127 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 53 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0.5 * 0.125 = -0.625) -- Test Case #19
---------- 190 ns -----------

clk <= '1'; --	 Cycle No: 19

operation <= multiply;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  124 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 54 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  123 ) REPORT "Assert 55 : < res_exp /= 123 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 56 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0.625 * 1.0 = -0.625) -- Test Case #20
---------- 200 ns -----------

clk <= '1'; --	 Cycle No: 20

operation <= multiply;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "01000000000000000000000";
op2_sign <= '0';
op2_exp <=  127 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 57 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 58 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "01000000000000000000000") REPORT "Assert 59 : < res_mant /= 01000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-1.5 * -0.5 = 0.75) -- Test Case #21
---------- 210 ns -----------

clk <= '1'; --	 Cycle No: 21

operation <= multiply;
op1_sign <= '1';
op1_exp <=  127 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 60 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 61 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 62 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-2.75 * -2.75 = 7.5625) -- Test Case #22
---------- 220 ns -----------

clk <= '1'; --	 Cycle No: 22

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01100000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 63 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 64 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100100000000000000000") REPORT "Assert 65 : < res_mant /= 11100100000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-3.0 * 0.5 = -1.5) -- Test Case #23
---------- 230 ns -----------

clk <= '1'; --	 Cycle No: 23

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 66 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 67 : < res_exp /= 127 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 68 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-4.0 * 4.0 = -16.0) -- Test Case #24
---------- 240 ns -----------

clk <= '1'; --	 Cycle No: 24

operation <= multiply;
op1_sign <= '1';
op1_exp <=  129 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 69 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  131 ) REPORT "Assert 70 : < res_exp /= 131 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 71 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.5 * -0.25 = -0.125) -- Test Case #25
---------- 250 ns -----------

clk <= '1'; --	 Cycle No: 25

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 72 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  124 ) REPORT "Assert 73 : < res_exp /= 124 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 74 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.75 * -1.0 = -0.75) -- Test Case #26 
---------- 260 ns -----------

clk <= '1'; --	 Cycle No: 26

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  127 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 75 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 76 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 77 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.75 * 0.75 = 0.5625) -- Test Case #27
---------- 270 ns -----------

clk <= '1'; --	 Cycle No: 27

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 78 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 79 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "00100000000000000000000") REPORT "Assert 80 : < res_mant /= 00100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.5 * 7.0 = 3.5) -- Test Case #28
---------- 280 ns -----------

clk <= '1'; --	 Cycle No: 28

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 81 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 82 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "11000000000000000000000") REPORT "Assert 83 : < res_mant /= 11000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (5.0 * -0.25 = -1.25) -- Test Case #29
---------- 290 ns -----------

clk <= '1'; --	 Cycle No: 29

operation <= multiply;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "01000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 84 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 85 : < res_exp /= 127 >"
	SEVERITY warning;
ASSERT (res_mant = "01000000000000000000000") REPORT "Assert 86 : < res_mant /= 01000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (9.0 * -11.0 = -99.0) -- Test Case #30
---------- 300 ns -----------

clk <= '1'; --	 Cycle No: 30

operation <= multiply;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "00100000000000000000000";
op2_sign <= '1';
op2_exp <=  130 ;
op2_mant <= "01100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 87 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  133 ) REPORT "Assert 88 : < res_exp /= 133 >"
	SEVERITY warning;
ASSERT (res_mant = "10001100000000000000000") REPORT "Assert 89 : < res_mant /= 10001100000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (13.5 * 0.5 = 6.75) -- Test Case #31
---------- 310 ns -----------

clk <= '1'; --	 Cycle No: 31

operation <= multiply;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "10110000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 90 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 91 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "10110000000000000000000") REPORT "Assert 92 : < res_mant /= 10110000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (19.0 * 6.0 = 114.0) -- Test Case #32
---------- 320 ns -----------

clk <= '1'; --	 Cycle No: 32

operation <= multiply;
op1_sign <= '0';
op1_exp <=  131 ;
op1_mant <= "00110000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 93 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  133 ) REPORT "Assert 94 : < res_exp /= 133 >"
	SEVERITY warning;
ASSERT (res_mant = "11001000000000000000000") REPORT "Assert 95 : < res_mant /= 11001000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test Idle operation
-- * -------------------
-- *  
-- * No operation -- Test Case #33
-- * Same result from before
---------- 330 ns -----------

clk <= '1'; --	 Cycle No: 33

operation <= idle;

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 96 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  133 ) REPORT "Assert 97 : < res_exp /= 133 >"
	SEVERITY warning;
ASSERT (res_mant = "11001000000000000000000") REPORT "Assert 98 : < res_mant /= 11001000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- *************************
-- *			*
-- * BOUNDARY TEST VECTORS *
-- *			*
-- *************************
-- *
-- * test POS_ZERO cases 
-- * -----------------------
-- *
-- * (-0.375 * 0 = 0) -- Test Case #34
---------- 340 ns -----------

clk <= '1'; --	 Cycle No: 34

operation <= multiply;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 99 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 100 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 101 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-2.625 * 0 = 0) -- Test Case #35
---------- 350 ns -----------

clk <= '1'; --	 Cycle No: 35

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 102 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 103 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 104 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.8125 * 0 = 0) -- Test Case #36
---------- 360 ns -----------

clk <= '1'; --	 Cycle No: 36

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 105 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 106 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 107 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (7.5 * 0 = 0) -- Test Case #37
---------- 370 ns -----------

clk <= '1'; --	 Cycle No: 37

operation <= multiply;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 108 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 109 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 110 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * -0.375 = 0) -- Test Case #38
---------- 380 ns -----------

clk <= '1'; --	 Cycle No: 38

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 111 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 112 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 113 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * -2.625 = 0) -- Test Case #39 
---------- 390 ns -----------

clk <= '1'; --	 Cycle No: 39

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 114 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 115 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 116 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * 0.8125 = 0) -- Test Case #40
---------- 400 ns -----------

clk <= '1'; --	 Cycle No: 40

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 117 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 118 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 119 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * 7.5 = 0) -- Test Case #41
---------- 410 ns -----------

clk <= '1'; --	 Cycle No: 41

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 120 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 121 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 122 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * 0 = 0) -- Test Case #42
---------- 420 ns -----------

clk <= '1'; --	 Cycle No: 42

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 123 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 124 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 125 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * MIN_POS = 0) -- Test Case #43
---------- 430 ns -----------

clk <= '1'; --	 Cycle No: 43

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 126 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 127 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 128 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * MIN_NEG = 0) -- Test Case #44
---------- 440 ns -----------

clk <= '1'; --	 Cycle No: 44

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 129 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 130 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 131 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * MAX_POS = 0) -- Test Case #45
---------- 450 ns -----------

clk <= '1'; --	 Cycle No: 45

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 132 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 133 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 134 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * MAX_NEG = 0) -- Test Case #46
---------- 460 ns -----------

clk <= '1'; --	 Cycle No: 46

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 135 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 136 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 137 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * POS_INF = 0) -- Test Case #47	
---------- 470 ns -----------

clk <= '1'; --	 Cycle No: 47

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 138 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 139 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 140 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * NEG_INF = 0) -- Test Case #48	
---------- 480 ns -----------

clk <= '1'; --	 Cycle No: 48

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 141 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 142 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 143 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 * NaN = NaN) -- Test Case #49	
---------- 490 ns -----------

clk <= '1'; --	 Cycle No: 49

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 144 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 145 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 146 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test NEG_ZERO cases
-- * ---------------------------
-- *
-- * (-0.375 * -0 = 0) -- Test Case #50
---------- 500 ns -----------

clk <= '1'; --	 Cycle No: 50

operation <= multiply;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 147 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  00000000000000000000000 ) REPORT "Assert 148 : < res_exp /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-2.625 * -0 = 0) -- Test Case #51
---------- 510 ns -----------

clk <= '1'; --	 Cycle No: 51

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 149 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 150 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 151 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.8125 * -0 = -0) -- Test Case #52
---------- 520 ns -----------

clk <= '1'; --	 Cycle No: 52

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 152 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 153 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 154 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (7.5 * -0 = -0) -- Test Case #53
---------- 530 ns -----------

clk <= '1'; --	 Cycle No: 53

operation <= multiply;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 155 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 156 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 157 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * -0.375 = 0) -- Test Case #54
---------- 540 ns -----------

clk <= '1'; --	 Cycle No: 54

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 158 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 159 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 160 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * -2.625 = 0) -- Test Case #55 
---------- 550 ns -----------

clk <= '1'; --	 Cycle No: 55

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 161 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 162 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 163 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * 0.8125 = -0) -- Test Case #56
---------- 560 ns -----------

clk <= '1'; --	 Cycle No: 56

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 164 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 165 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 166 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * 7.5 = -0) -- Test Case #57
---------- 570 ns -----------

clk <= '1'; --	 Cycle No: 57

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 167 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 168 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 169 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * 0 = -0) -- Test Case #58
---------- 580 ns -----------

clk <= '1'; --	 Cycle No: 58

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 170 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 171 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 172 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * MIN_POS = -0) -- Test Case #59
---------- 590 ns -----------

clk <= '1'; --	 Cycle No: 59

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 173 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 174 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 175 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * MIN_NEG = 0) -- Test Case #60
---------- 600 ns -----------

clk <= '1'; --	 Cycle No: 60

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 176 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 177 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 178 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * MAX_POS = -0) -- Test Case #61
---------- 610 ns -----------

clk <= '1'; --	 Cycle No: 61

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 179 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 180 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 181 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * MAX_NEG = 0) -- Test Case #62
---------- 620 ns -----------

clk <= '1'; --	 Cycle No: 62

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 182 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 183 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 184 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * POS_INF = -0) -- Test Case #63	
---------- 630 ns -----------

clk <= '1'; --	 Cycle No: 63

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 185 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 186 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 187 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * NEG_INF = 0) -- Test Case #64	
---------- 640 ns -----------

clk <= '1'; --	 Cycle No: 64

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 188 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 189 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 190 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 * NaN = NaN) -- Test Case #65
---------- 650 ns -----------

clk <= '1'; --	 Cycle No: 65

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 191 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 192 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 193 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MIN_POS cases 
-- * --------------------------
-- *
-- * (-3 * MIN_POS = - EXP[1]d, MANT[400002]x)  -- Test Case #66
---------- 660 ns -----------

clk <= '1'; --	 Cycle No: 66

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 194 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 195 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000010") REPORT "Assert 196 : < res_mant /= 10000000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-2.625 * MIN_POS = - EXP[1]d, MANT[280001]x)   -- Test Case #67
---------- 670 ns -----------

clk <= '1'; --	 Cycle No: 67

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 197 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 198 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000001") REPORT "Assert 199 : < res_mant /= 01010000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (6.5 * MIN_POS = EXP[2]d, MANT[500002]x)   -- Test Case #68
---------- 680 ns -----------

clk <= '1'; --	 Cycle No: 68

operation <= multiply;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 200 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  2 ) REPORT "Assert 201 : < res_exp /= 2 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000010") REPORT "Assert 202 : < res_mant /= 10100000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (7.5 * MIN_POS = EXP[2]d, MANT[700002]x)	 -- Test Case #69
---------- 690 ns -----------

clk <= '1'; --	 Cycle No: 69

operation <= multiply;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 203 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  2 ) REPORT "Assert 204 : < res_exp /= 2 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000010") REPORT "Assert 205 : < res_mant /= 11100000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_POS * -3 = -EXP[1]d, MANT[400002]x)   -- Test Case #70
---------- 700 ns -----------

clk <= '1'; --	 Cycle No: 70

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 206 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 207 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000010") REPORT "Assert 208 : < res_mant /= 10000000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_POS * -2.625 = -EXP[1]d, MANT[280001]x)   -- Test Case #71
---------- 710 ns -----------

clk <= '1'; --	 Cycle No: 71

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 209 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 210 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000001") REPORT "Assert 211 : < res_mant /= 01010000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_POS * 1.625 = EXP[1]d, MANT[500002]x)   -- Test Case #72
---------- 720 ns -----------

clk <= '1'; --	 Cycle No: 72

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  127 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 212 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 213 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000010") REPORT "Assert 214 : < res_mant /= 10100000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_POS * 7.5 = EXP[1]d, MANT[700002]x)         -- Test Case #73
---------- 730 ns -----------

clk <= '1'; --	 Cycle No: 73

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 215 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  2 ) REPORT "Assert 216 : < res_exp /= 2 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000010") REPORT "Assert 217 : < res_mant /= 11100000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_POS * 0 = 0 )	 -- Test Case #74
---------- 740 ns -----------

clk <= '1'; --	 Cycle No: 74

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 218 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 219 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 220 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_POS * MAX_POS = 2) -- Test Case #75
---------- 750 ns -----------

clk <= '1'; --	 Cycle No: 75

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 221 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 222 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 223 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_POS * MAX_NEG = 2) -- Test Case #76
---------- 760 ns -----------

clk <= '1'; --	 Cycle No: 76

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 224 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 225 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 226 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_POS * POS_INF =POS_INF) -- Test Case #77
---------- 770 ns -----------

clk <= '1'; --	 Cycle No: 77

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 227 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 228 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 229 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_POS * NEG_INF = NEG_INF) -- Test Case #78	
---------- 780 ns -----------

clk <= '1'; --	 Cycle No: 78

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 230 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 231 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 232 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_POS * NaN = NaN) -- Test Case #79
---------- 790 ns -----------

clk <= '1'; --	 Cycle No: 79

operation <= multiply;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "10101010101010101010101";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 233 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 234 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "10101010101010101010101") REPORT "Assert 235 : < res_mant /= 10101010101010101010101 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MIN_NEG cases 
-- * --------------------------
-- *
-- * (-3 * MIN_NEG = EXP[1], MANT[400002]x ) -- Test Case #80
---------- 800 ns -----------

clk <= '1'; --	 Cycle No: 80

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 236 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 237 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000010") REPORT "Assert 238 : < res_mant /= 10000000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-2.625 * MIN_NEG = EXP[1], MANT[280001]x ) -- Test Case #81
---------- 810 ns -----------

clk <= '1'; --	 Cycle No: 81

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 239 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 240 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000001") REPORT "Assert 241 : < res_mant /= 01010000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (6.5 * MIN_NEG = -EXP[1], MANT[500001]x ) -- Test Case #82
---------- 820 ns -----------

clk <= '1'; --	 Cycle No: 82

operation <= multiply;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 242 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  2 ) REPORT "Assert 243 : < res_exp /= 2 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000010") REPORT "Assert 244 : < res_mant /= 10100000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (7.5 * MIN_NEG = -EXP[1], MANT[700002]x )	-- Test Case #83
---------- 830 ns -----------

clk <= '1'; --	 Cycle No: 83

operation <= multiply;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 245 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  2 ) REPORT "Assert 246 : < res_exp /= 2 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000010") REPORT "Assert 247 : < res_mant /= 11100000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_NEG * -3 =  EXP[1], MANT[400002]x ) -- Test Case #84
---------- 840 ns -----------

clk <= '1'; --	 Cycle No: 84

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 248 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 249 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000010") REPORT "Assert 250 : < res_mant /= 10000000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_NEG * -2.625 = EXP[1], MANT[280001]x  ) -- Test Case #85
---------- 850 ns -----------

clk <= '1'; --	 Cycle No: 85

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 251 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 252 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000001") REPORT "Assert 253 : < res_mant /= 01010000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_NEG * 0.8125 = EXP[1], MANT[500002]x  ) -- Test Case #86
---------- 860 ns -----------

clk <= '1'; --	 Cycle No: 86

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 254 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  2 ) REPORT "Assert 255 : < res_exp /= 2 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000010") REPORT "Assert 256 : < res_mant /= 10100000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_NEG * 7.5 = -EXP[1], MANT[700002]x  ) -- Test Case #87
---------- 870 ns -----------

clk <= '1'; --	 Cycle No: 87

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 257 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  2 ) REPORT "Assert 258 : < res_exp /= 2 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000010") REPORT "Assert 259 : < res_mant /= 11100000000000000000010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_NEG * 0 = - 0) -- Test Case #88
---------- 880 ns -----------

clk <= '1'; --	 Cycle No: 88

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 260 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 261 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 262 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_NEG * MAX_POS = -2) -- Test Case #89
---------- 890 ns -----------

clk <= '1'; --	 Cycle No: 89

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 263 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 264 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 265 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_NEG * MAX_NEG = MAX_NEG)  -- Test Case #90
---------- 900 ns -----------

clk <= '1'; --	 Cycle No: 90

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 266 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 267 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 268 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_NEG * POS_INF = NEG_INF) -- Test Case #91 
---------- 910 ns -----------

clk <= '1'; --	 Cycle No: 91

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 269 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 270 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 271 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_NEG * NEG_INF = POS_INF) -- Test Case #92	
---------- 920 ns -----------

clk <= '1'; --	 Cycle No: 92

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 272 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 273 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 274 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MIN_NEG * NaN = NaN) -- Test Case #93
---------- 930 ns -----------

clk <= '1'; --	 Cycle No: 93

operation <= multiply;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 275 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 276 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 277 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MAX_POS cases 
-- * --------------------------
-- *
-- * (-0.375 * MAX_POS = - EXP[253], MANT[3fffff]x ) -- Test Case #94
---------- 940 ns -----------

clk <= '1'; --	 Cycle No: 94

operation <= multiply;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 278 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  253 ) REPORT "Assert 279 : < res_exp /= 253 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 280 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0.328125 * MAX_POS = - EXP[253], MANT[27ffff]x ) -- Test Case #95
---------- 950 ns -----------

clk <= '1'; --	 Cycle No: 95

operation <= multiply;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 281 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  253 ) REPORT "Assert 282 : < res_exp /= 253 >"
	SEVERITY warning;
ASSERT (res_mant = "01001111111111111111111") REPORT "Assert 283 : < res_mant /= 01001111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.8125 * MAX_POS = EXP[253], MANT[4fffff]x ) -- Test Case #96
---------- 960 ns -----------

clk <= '1'; --	 Cycle No: 96

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 284 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 285 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "10011111111111111111111") REPORT "Assert 286 : < res_mant /= 10011111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.9375 * MAX_POS = EXP[254], MANT[6fffff]x ) -- Test Case #97
---------- 970 ns -----------

clk <= '1'; --	 Cycle No: 97

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 287 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 288 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11011111111111111111111") REPORT "Assert 289 : < res_mant /= 11011111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_POS * -0.375 = EXP[253], MANT[3fffff]x ) -- Test Case #98
---------- 980 ns -----------

clk <= '1'; --	 Cycle No: 98

operation <= multiply;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 290 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  253 ) REPORT "Assert 291 : < res_exp /= 253 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 292 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_POS * -0.1640625 = EXP[252], MANT[27ffff]x ) -- Test Case #99 
---------- 990 ns -----------

clk <= '1'; --	 Cycle No: 99

operation <= multiply;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  124 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 293 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  252 ) REPORT "Assert 294 : < res_exp /= 252 >"
	SEVERITY warning;
ASSERT (res_mant = "01001111111111111111111") REPORT "Assert 295 : < res_mant /= 01001111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_POS * 0.8125 = EXP[254], MANT[4fffff]x ) -- Test Case #100
---------- 1000 ns -----------

clk <= '1'; --	 Cycle No: 100

operation <= multiply;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 296 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 297 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "10011111111111111111111") REPORT "Assert 298 : < res_mant /= 10011111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_POS * 0.11718755 = EXP[251], MANT[6fffff]x ) -- Test Case #101
---------- 1010 ns -----------

clk <= '1'; --	 Cycle No: 101

operation <= multiply;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  123 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 299 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  251 ) REPORT "Assert 300 : < res_exp /= 251 >"
	SEVERITY warning;
ASSERT (res_mant = "11011111111111111111111") REPORT "Assert 301 : < res_mant /= 11011111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_POS * 0 = 0) -- Test Case #102
---------- 1020 ns -----------

clk <= '1'; --	 Cycle No: 102

operation <= multiply;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 302 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 303 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 304 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_POS * MIN_POS = 2 ) -- Test Case #103
---------- 1030 ns -----------

clk <= '1'; --	 Cycle No: 103

operation <= multiply;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 305 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 306 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 307 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_POS * MIN_NEG = -2 ) -- Test Case #104
---------- 1040 ns -----------

clk <= '1'; --	 Cycle No: 104

operation <= multiply;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 308 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 309 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 310 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_POS * POS_INF = POS_INF) -- Test Case #105
---------- 1050 ns -----------

clk <= '1'; --	 Cycle No: 105

operation <= multiply;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 311 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 312 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 313 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_POS * NEG_INF = NEG_INF) -- Test Case #106
---------- 1060 ns -----------

clk <= '1'; --	 Cycle No: 106

operation <= multiply;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 314 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 315 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 316 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_POS * NaN = NaN) -- Test Case #107
---------- 1070 ns -----------

clk <= '1'; --	 Cycle No: 107

operation <= multiply;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 317 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 318 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 319 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MAX_NEG cases 
-- * ------------------
-- *
-- * (-0.375 * MAX_NEG = EXP[252], MANT[3fffff]x )  -- Test Case #108
---------- 1080 ns -----------

clk <= '1'; --	 Cycle No: 108

operation <= multiply;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 320 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  253 ) REPORT "Assert 321 : < res_exp /= 253 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 322 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0.65625 * MAX_NEG = EXP[254], MANT[27ffff]x )   -- Test Case #109
---------- 1090 ns -----------

clk <= '1'; --	 Cycle No: 109

operation <= multiply;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 323 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 324 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "01001111111111111111111") REPORT "Assert 325 : < res_mant /= 01001111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.8125 * MAX_NEG = - EXP[254], MANT[4fffff]x )   -- Test Case #110
---------- 1100 ns -----------

clk <= '1'; --	 Cycle No: 110

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 326 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 327 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "10011111111111111111111") REPORT "Assert 328 : < res_mant /= 10011111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.0585938 * MAX_NEG = - EXP[250], MANT[6fffff]x )	 -- Test Case #111
---------- 1110 ns -----------

clk <= '1'; --	 Cycle No: 111

operation <= multiply;
op1_sign <= '0';
op1_exp <=  122 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 329 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  250 ) REPORT "Assert 330 : < res_exp /= 250 >"
	SEVERITY warning;
ASSERT (res_mant = "11011111111111111111111") REPORT "Assert 331 : < res_mant /= 11011111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_NEG * -0.375 = EXP[253], MANT[3fffff]x )    -- Test Case #112
---------- 1120 ns -----------

clk <= '1'; --	 Cycle No: 112

operation <= multiply;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 332 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  253 ) REPORT "Assert 333 : < res_exp /= 253 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 334 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_NEG * -0.0205078 = EXP[249], MANT[27ffff]x )   -- Test Case #113
---------- 1130 ns -----------

clk <= '1'; --	 Cycle No: 113

operation <= multiply;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  121 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 335 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  249 ) REPORT "Assert 336 : < res_exp /= 249 >"
	SEVERITY warning;
ASSERT (res_mant = "01001111111111111111111") REPORT "Assert 337 : < res_mant /= 01001111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_NEG * 0.8125 = - EXP[254], MANT[4fffff]x )   -- Test Case #114
---------- 1140 ns -----------

clk <= '1'; --	 Cycle No: 114

operation <= multiply;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 338 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 339 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "10011111111111111111111") REPORT "Assert 340 : < res_mant /= 10011111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_NEG * 0.234375 = - EXP[252], MANT[6fffff]x )         -- Test Case #115
---------- 1150 ns -----------

clk <= '1'; --	 Cycle No: 115

operation <= multiply;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  124 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 341 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  252 ) REPORT "Assert 342 : < res_exp /= 252 >"
	SEVERITY warning;
ASSERT (res_mant = "11011111111111111111111") REPORT "Assert 343 : < res_mant /= 11011111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_NEG * 0 = - 0)	    -- Test Case #116
---------- 1160 ns -----------

clk <= '1'; --	 Cycle No: 116

operation <= multiply;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 344 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 345 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 346 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_NEG * MIN_POS = - 2 )     -- Test Case #117
---------- 1170 ns -----------

clk <= '1'; --	 Cycle No: 117

operation <= multiply;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 347 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 348 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 349 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_NEG * MIN_NEG = 2 )  -- Test Case #118
---------- 1180 ns -----------

clk <= '1'; --	 Cycle No: 118

operation <= multiply;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 350 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 351 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 352 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_NEG * POS_INF = NEG_INF) -- Test Case #119 
---------- 1190 ns -----------

clk <= '1'; --	 Cycle No: 119

operation <= multiply;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 353 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 354 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 355 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_NEG * NEG_INF = POS_INF) -- Test Case #120
---------- 1200 ns -----------

clk <= '1'; --	 Cycle No: 120

operation <= multiply;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 356 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 357 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 358 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (MAX_NEG * NaN = NaN) -- Test Case #121
---------- 1210 ns -----------

clk <= '1'; --	 Cycle No: 121

operation <= multiply;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 359 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 360 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 361 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test POS_INF cases 
-- * --------------------------
-- *
-- * (-0.375 * POS_INF = NEG_INF)  -- Test Case #122
---------- 1220 ns -----------

clk <= '1'; --	 Cycle No: 122

operation <= multiply;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 362 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 363 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 364 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-2.625 * POS_INF = NEG_INF)   -- Test Case #123
---------- 1230 ns -----------

clk <= '1'; --	 Cycle No: 123

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 365 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 366 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 367 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.8125 * POS_INF = POS_INF)   -- Test Case #124
---------- 1240 ns -----------

clk <= '1'; --	 Cycle No: 124

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 368 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 369 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 370 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (7.5 * POS_INF = POS_INF)	 -- Test Case #125
---------- 1250 ns -----------

clk <= '1'; --	 Cycle No: 125

operation <= multiply;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 371 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 372 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 373 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * -0.375 = NEG_INF)    -- Test Case #126
---------- 1260 ns -----------

clk <= '1'; --	 Cycle No: 126

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 374 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 375 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 376 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * -2.625 = NEG_INF)   -- Test Case #127
---------- 1270 ns -----------

clk <= '1'; --	 Cycle No: 127

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 377 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 378 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 379 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * 0.8125 = POS_INF) -- Test Case #128
---------- 1280 ns -----------

clk <= '1'; --	 Cycle No: 128

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 380 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 381 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 382 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * 7.5 = POS_INF) -- Test Case #129
---------- 1290 ns -----------

clk <= '1'; --	 Cycle No: 129

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 383 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 384 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 385 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * 0 = 0) -- Test Case #130
---------- 1300 ns -----------

clk <= '1'; --	 Cycle No: 130

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 386 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 387 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 388 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * MIN_POS = POS_INF) -- Test Case #131
---------- 1310 ns -----------

clk <= '1'; --	 Cycle No: 131

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 389 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 390 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 391 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * MIN_NEG = NEG_INF) -- Test Case #132
---------- 1320 ns -----------

clk <= '1'; --	 Cycle No: 132

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 392 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 393 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 394 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * MAX_POS = POS_INF) -- Test Case #133
---------- 1330 ns -----------

clk <= '1'; --	 Cycle No: 133

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 395 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 396 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 397 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * MAX_NEG = NEG_INF) -- Test Case #134
---------- 1340 ns -----------

clk <= '1'; --	 Cycle No: 134

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 398 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 399 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 400 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * POS_INF = POS_INF) -- Test Case #135
---------- 1350 ns -----------

clk <= '1'; --	 Cycle No: 135

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 401 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 402 : < res_exp /= 255 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * NEG_INF = NEG_INF) -- Test Case #136
---------- 1360 ns -----------

clk <= '1'; --	 Cycle No: 136

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 403 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 404 : < res_exp /= 255 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (POS_INF * NaN = NaN) -- Test Case #137
---------- 1370 ns -----------

clk <= '1'; --	 Cycle No: 137

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 405 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 406 : < res_exp /= 255 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test NEG_INF cases 
-- * --------------------------
-- *
-- * (-0.375 * NEG_INF = POS_INF)  -- Test Case #138
---------- 1380 ns -----------

clk <= '1'; --	 Cycle No: 138

operation <= multiply;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 407 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 408 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 409 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-2.625 * NEG_INF = POS_INF)   -- Test Case #139
---------- 1390 ns -----------

clk <= '1'; --	 Cycle No: 139

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 410 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 411 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 412 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.8125 * NEG_INF = NEG_INF)   -- Test Case #140
---------- 1400 ns -----------

clk <= '1'; --	 Cycle No: 140

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 413 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 414 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 415 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (7.5 * NEG_INF = NEG_INF)	 -- Test Case #141
---------- 1410 ns -----------

clk <= '1'; --	 Cycle No: 141

operation <= multiply;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 416 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 417 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 418 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * -0.375 = POS_INF)    -- Test Case #142
---------- 1420 ns -----------

clk <= '1'; --	 Cycle No: 142

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 419 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 420 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 421 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * -2.625 = POS_INF)   -- Test Case #143
---------- 1430 ns -----------

clk <= '1'; --	 Cycle No: 143

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 422 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 423 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 424 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * 0.8125 = NEG_INF) -- Test Case #144
---------- 1440 ns -----------

clk <= '1'; --	 Cycle No: 144

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 425 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 426 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 427 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * 7.5 = NEG_INF) -- Test Case #145
---------- 1450 ns -----------

clk <= '1'; --	 Cycle No: 145

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 428 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 429 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 430 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * 0 = - 0) -- Test Case #146
---------- 1460 ns -----------

clk <= '1'; --	 Cycle No: 146

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 431 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 432 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 433 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * MIN_POS = NEG_INF) -- Test Case #147
---------- 1470 ns -----------

clk <= '1'; --	 Cycle No: 147

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 434 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 435 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 436 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * MIN_NEG = POS_INF) -- Test Case #148
---------- 1480 ns -----------

clk <= '1'; --	 Cycle No: 148

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 437 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 438 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 439 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * MAX_POS = NEG_INF) -- Test Case #149
---------- 1490 ns -----------

clk <= '1'; --	 Cycle No: 149

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 440 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 441 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 442 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * MAX_NEG = POS_INF) -- Test Case #150
---------- 1500 ns -----------

clk <= '1'; --	 Cycle No: 150

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 443 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 444 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 445 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * POS_INF = NEG_INF) -- Test Case #151
---------- 1510 ns -----------

clk <= '1'; --	 Cycle No: 151

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 446 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 447 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 448 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * NEG_INF = POS_INF) -- Test Case #152
---------- 1520 ns -----------

clk <= '1'; --	 Cycle No: 152

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 449 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 450 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 451 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF * NaN = NaN) -- Test Case #153
---------- 1530 ns -----------

clk <= '1'; --	 Cycle No: 153

operation <= multiply;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111100";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 452 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 453 : < res_exp /= 255 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test NaN cases 
-- * --------------------------
-- *
-- * (-0.375 * NaN = NaN)  -- Test Case #154
---------- 1540 ns -----------

clk <= '1'; --	 Cycle No: 154

operation <= multiply;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 454 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 455 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 456 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-2.625 * NaN = NaN)   -- Test Case #155
---------- 1550 ns -----------

clk <= '1'; --	 Cycle No: 155

operation <= multiply;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01010101010101010101010";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 457 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 458 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01010101010101010101010") REPORT "Assert 459 : < res_mant /= 01010101010101010101010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0.8125 * NaN = NaN)   -- Test Case #156
---------- 1560 ns -----------

clk <= '1'; --	 Cycle No: 156

operation <= multiply;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 460 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 461 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 462 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (7.5 * NaN = NaN)	 -- Test Case #157
---------- 1570 ns -----------

clk <= '1'; --	 Cycle No: 157

operation <= multiply;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01010101010101010101010";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 463 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 464 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01010101010101010101010") REPORT "Assert 465 : < res_mant /= 01010101010101010101010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * -0.375 = NaN)    -- Test Case #158
---------- 1580 ns -----------

clk <= '1'; --	 Cycle No: 158

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 466 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 467 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 468 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * -2.625 = NaN)   -- Test Case #159
---------- 1590 ns -----------

clk <= '1'; --	 Cycle No: 159

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01010101010101010101010";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 469 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 470 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01010101010101010101010") REPORT "Assert 471 : < res_mant /= 01010101010101010101010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * 0.8125 = NaN) -- Test Case #160
---------- 1600 ns -----------

clk <= '1'; --	 Cycle No: 160

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 472 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 473 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 474 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * 7.5 = NaN) -- Test Case #161
---------- 1610 ns -----------

clk <= '1'; --	 Cycle No: 161

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01010101010101010101010";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 475 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 476 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01010101010101010101010") REPORT "Assert 477 : < res_mant /= 01010101010101010101010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * 0 = NaN) -- Test Case #162
---------- 1620 ns -----------

clk <= '1'; --	 Cycle No: 162

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 478 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 479 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 480 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * MIN_POS = NaN) -- Test Case #163
---------- 1630 ns -----------

clk <= '1'; --	 Cycle No: 163

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01010101010101010101010";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 481 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 482 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01010101010101010101010") REPORT "Assert 483 : < res_mant /= 01010101010101010101010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * MIN_NEG = NaN) -- Test Case #164
---------- 1640 ns -----------

clk <= '1'; --	 Cycle No: 164

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 484 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 485 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 486 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * MAX_POS = NaN) -- Test Case #165
---------- 1650 ns -----------

clk <= '1'; --	 Cycle No: 165

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01010101010101010101010";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 487 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 488 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01010101010101010101010") REPORT "Assert 489 : < res_mant /= 01010101010101010101010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * MAX_NEG = NaN) -- Test Case #166
---------- 1660 ns -----------

clk <= '1'; --	 Cycle No: 166

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 490 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 491 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 492 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * POS_INF = NaN) -- Test Case #167
---------- 1670 ns -----------

clk <= '1'; --	 Cycle No: 167

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01010101010101010101010";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 493 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 494 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01010101010101010101010") REPORT "Assert 495 : < res_mant /= 01010101010101010101010 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * NaN = NaN) -- Test Case #168
---------- 1680 ns -----------

clk <= '1'; --	 Cycle No: 168

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01010101010101010101010";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 496 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 497 : < res_exp /= 255 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NaN * NaN = NaN) -- Test Case #169
---------- 1690 ns -----------

clk <= '1'; --	 Cycle No: 169

operation <= multiply;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01010101010101010101010";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111100";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 498 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 499 : < res_exp /= 255 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


end process;
end test1;
