--------------------------------------------------------------------------
--
-- SIMULATION TEST VECTORS FOR floating point addition/subtraction algorithm
--
-- THE MODELS WERE SIMULATED ON THE SYNOPSYS (VERSION 3.0) SIMULATOR.
--
--  Developed on May 1, 1993 by :
--                                Bob McIlhenny,
--                                CADLAB,
--                                Univ. of Calif. , Irvine.
--  Modified on Dec 7, 1993 by : 
--				  Jesse Pan,
--			          University of California, Irvine	
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Jesse Pan	           07 Dec 93    Synopsys
--  Functionality     yes     Jesse Pan	           07 Dec 93    Synopsys
--------------------------------------------------------------------------

library mvl_7;
use mvl_7.types.all;
use work.fpadd_pkg.all;
use mvl_7.arithmetic.all;
use mvl_7.arithsupp.all;

entity atest is
end atest;

architecture test1 of atest is
	 component fau
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

for a1 : fau use entity work.fau(fau_behavior);

begin

A1 : fau
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
-- * test nominal cases for ADD
-- * --------------------------
-- *
-- *  Test Case #1.A
---------- 10 ns -----------

clk <= '1'; --	 Cycle No: 1

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 0 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 1 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 2 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

--  Test Case #2.B
---------- 20 ns -----------

clk <= '1'; --   Cycle No: 2

operation <= add;
op1_sign <= '1';
op1_exp <=  123 ;
op1_mant <= "000"&X"00005";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "000"&X"00000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 3 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 4 : < res_exp /= 126 >"
        SEVERITY warning;
ASSERT (res_mant = "001"&X"00001") REPORT "Assert 5 : < res_mant /= 00100000000000000000001 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #3.C
---------- 30 ns -----------

clk <= '1'; --   Cycle No: 3

operation <= add;
op1_sign <= '1';
op1_exp <=  123 ;
op1_mant <= "000"&X"00004";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "000"&X"00000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 6 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 7 : < res_exp /= 126 >"
        SEVERITY warning;
ASSERT (res_mant = "00100000000000000000000") REPORT "Assert 8 : < res_mant /= 00100000000000000000000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #4.D
---------- 40 ns -----------

clk <= '1'; --   Cycle No: 4

operation <= add;
op1_sign <= '1';
op1_exp <=  123 ;
op1_mant <= "000"&X"00004";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "000"&X"00001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 9 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 10 : < res_exp /= 126 >"
        SEVERITY warning;
ASSERT (res_mant = "00100000000000000000010") REPORT "Assert 11 : < res_mant /= 00100000000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #5.A

---------- 50 ns -----------

clk <= '1'; --	 Cycle No: 5

operation <= add;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 12 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 13 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01100000000000000000000") REPORT "Assert 14 : < res_mant /= 01100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- Test Case #6.B
---------- 60 ns -----------

clk <= '1'; --   Cycle No: 6

operation <= add;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "000"&X"00009";
op2_sign <= '1';
op2_exp <=  130 ;
op2_mant <= "000"&X"00001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 15 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 16 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80002") REPORT "Assert 17 : < res_mant /= 00010000000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #7.C
---------- 70 ns -----------

clk <= '1'; --   Cycle No: 7

operation <= add;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "000"&X"00008";
op2_sign <= '1';
op2_exp <=  130 ;
op2_mant <= "000"&X"00004";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 18 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 19 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80004") REPORT "Assert 20 : < res_mant /= 00010000000000000000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #8.D
---------- 80 ns -----------

clk <= '1'; --   Cycle No: 8

operation <= add;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "000"&X"00008";
op2_sign <= '1';
op2_exp <=  130 ;
op2_mant <= "000"&X"00005";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 21 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 22 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80006") REPORT "Assert 23 : < res_mant /= 00010000000000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- *  Test Case #9.A
---------- 90 ns -----------

clk <= '1'; --	 Cycle No: 9

operation <= add;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  124 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 24 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 25 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 26 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *  Test Case #10.B
---------- 100 ns -----------

clk <= '1'; --   Cycle No: 10

operation <= add;
op1_sign <= '1';
op1_exp <=  122 ;
op1_mant <= "111"&X"ffff3";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "000"&X"00001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 27 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 28 : < res_exp /= 125 >"
        SEVERITY warning;
ASSERT (res_mant = "110"&X"00004") REPORT "Assert 29 : < res_mant /= 11000000000000000000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #11.C
---------- 110 ns -----------

clk <= '1'; --   Cycle No: 11

operation <= add;
op1_sign <= '1';
op1_exp <=  122 ;
op1_mant <= "111"&X"ffffc";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "000"&X"00002";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 30 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 31 : < res_exp /= 125 >"
        SEVERITY warning;
ASSERT (res_mant = "11000000000000000000100") REPORT "Assert 32 : < res_mant /= 11000000000000000000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #12.D
---------- 120 ns -----------

clk <= '1'; --   Cycle No: 12

operation <= add;
op1_sign <= '1';
op1_exp <=  122 ;
op1_mant <= "111"&X"ffff4";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "000"&X"00003";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 33 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 34 : < res_exp /= 125 >"
        SEVERITY warning;
ASSERT (res_mant = "110"&X"00008") REPORT "Assert 35 : < res_mant /= 11000000000000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #13.A
---------- 130 ns -----------

clk <= '1'; --	 Cycle No: 13

operation <= add;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "01000000000000000000000";
op2_sign <= '0';
op2_exp <=  127 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 36 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 37 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 38 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #14.B
---------- 140 ns -----------

clk <= '1'; --   Cycle No: 14

operation <= add;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "111"&X"fffe1";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "001"&X"00002";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 39 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 40 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "110"&X"0000c") REPORT "Assert 41 : < res_mant /= 11000000000000000001100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #15.C
---------- 150 ns -----------

clk <= '1'; --   Cycle No: 15

operation <= add;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "111"&X"fffe4";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "010"&X"00003";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 42 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 43 : < res_exp /= 129 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00006") REPORT "Assert 44 : < res_mant /= 00000000000000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #16.D
---------- 160 ns -----------

clk <= '1'; --   Cycle No: 16

operation <= add;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "111"&X"fffe4";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "010"&X"00004";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 45 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 46 : < res_exp /= 129 >"
        SEVERITY warning;
ASSERT (res_mant = "00000000000000000001000") REPORT "Assert 47 : < res_mant /= 00000000000000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- *  Test Case #17.A
---------- 170 ns -----------

clk <= '1'; --	 Cycle No: 17

operation <= add;
op1_sign <= '1';
op1_exp <=  127 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 48 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 49 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 50 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *  Test Case #18.B
---------- 180 ns -----------

clk <= '1'; --   Cycle No: 18

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"0000b";
op2_sign <= '1';
op2_exp <=  123 ;
op2_mant <= "000"&X"00034";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 51 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 52 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"4000d") REPORT "Assert 53 : < res_mant /= 00001000000000000001101 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #19.C
---------- 50 ns -----------

clk <= '1'; --   Cycle No: 19

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"0000b";
op2_sign <= '1';
op2_exp <=  123 ;
op2_mant <= "000"&X"00030";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 54 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 55 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"4000c") REPORT "Assert 56 : < res_mant /= 00001000000000000001100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #20.D
---------- 200 ns -----------

clk <= '1'; --   Cycle No: 20

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"0000c";
op2_sign <= '1';
op2_exp <=  123 ;
op2_mant <= "000"&X"00030";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 57 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 58 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"4000e") REPORT "Assert 59 : < res_mant /= 00001000000000000001110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #21.A
---------- 210 ns -----------

clk <= '1'; --	 Cycle No: 21

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01100000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 60 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 61 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "01100000000000000000000") REPORT "Assert 62 : < res_mant /= 01100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #22.B
---------- 220 ns -----------

clk <= '1'; --   Cycle No: 22

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"0000b";
op2_sign <= '1';
op2_exp <=  132 ;
op2_mant <= "000"&X"00001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 63 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  132 ) REPORT "Assert 64 : < res_exp /= 132 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80002") REPORT "Assert 65 : < res_mant /= 00010000000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #23.C
---------- 230 ns -----------

clk <= '1'; --   Cycle No: 23

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"00008";
op2_sign <= '1';
op2_exp <=  132 ;
op2_mant <= "000"&X"00006";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 66 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  132 ) REPORT "Assert 67 : < res_exp /= 132 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80006") REPORT "Assert 68 : < res_mant /= 00010000000000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #24.D
---------- 240 ns -----------

clk <= '1'; --   Cycle No: 24

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"00008";
op2_sign <= '1';
op2_exp <=  132 ;
op2_mant <= "000"&X"00007";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 69 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  132 ) REPORT "Assert 70 : < res_exp /= 132 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80008") REPORT "Assert 71 : < res_mant /= 00010000000000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #25.A
---------- 250 ns -----------

clk <= '1'; --	 Cycle No: 25

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 72 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 73 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01000000000000000000000") REPORT "Assert 74 : < res_mant /= 01000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- *  Test Case #26.B
---------- 260 ns -----------

clk <= '1'; --   Cycle No: 26

operation <= add;
op1_sign <= '1';
op1_exp <=  129 ;
op1_mant <= "001"&X"00001";
op2_sign <= '0';
op2_exp <=  121 ;
op2_mant <= "111"&X"fff70";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 75 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 76 : < res_exp /= 129 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"f0002") REPORT "Assert 77 : < res_mant /= 00011110000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #27.C
---------- 270 ns -----------

clk <= '1'; --   Cycle No: 27

operation <= add;
op1_sign <= '1';
op1_exp <=  129 ;
op1_mant <= "001"&X"00002";
op2_sign <= '0';
op2_exp <=  121 ;
op2_mant <= "111"&X"fff80";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 78 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 79 : < res_exp /= 129 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"f0002") REPORT "Assert 80 : < res_mant /= 00011110000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #28.D
---------- 280 ns -----------

clk <= '1'; --   Cycle No: 28

operation <= add;
op1_sign <= '1';
op1_exp <=  129 ;
op1_mant <= "001"&X"00003";
op2_sign <= '0';
op2_exp <=  121 ;
op2_mant <= "111"&X"fff80";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 81 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 82 : < res_exp /= 129 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"f0004") REPORT "Assert 83 : < res_mant /= 00011110000000000000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #29.A
---------- 290 ns -----------

clk <= '1'; --	 Cycle No: 29

operation <= add;
op1_sign <= '1';
op1_exp <=  129 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 84 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 85 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 86 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #30.B
---------- 300 ns -----------

clk <= '1'; --   Cycle No: 30

operation <= add;
op1_sign <= '1';
op1_exp <=  138 ;
op1_mant <= "000"&X"20003";
op2_sign <= '0';
op2_exp <=  130 ;
op2_mant <= "111"&X"fff21";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 87 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  138 ) REPORT "Assert 88 : < res_exp /= 138 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"10004") REPORT "Assert 89 : < res_mant /= 00000010000000000000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #31.C
---------- 310 ns -----------

clk <= '1'; --   Cycle No: 31

operation <= add;
op1_sign <= '1';
op1_exp <=  138 ;
op1_mant <= "000"&X"20006";
op2_sign <= '0';
op2_exp <=  130 ;
op2_mant <= "111"&X"fff80";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 90 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  138 ) REPORT "Assert 91 : < res_exp /= 138 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"10006") REPORT "Assert 92 : < res_mant /= 00000010000000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #32.D
---------- 320 ns -----------

clk <= '1'; --   Cycle No: 32

operation <= add;
op1_sign <= '1';
op1_exp <=  138 ;
op1_mant <= "000"&X"20007";
op2_sign <= '0';
op2_exp <=  130 ;
op2_mant <= "111"&X"fff80";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 93 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  138 ) REPORT "Assert 94 : < res_exp /= 138 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"10008") REPORT "Assert 95 : < res_mant /= 00000010000000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- *  Test Case #33.A
---------- 330 ns -----------

clk <= '1'; --	 Cycle No: 33

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 96 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 97 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 98 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #34.B
---------- 340 ns -----------

clk <= '1'; --   Cycle No: 34

operation <= add;
op1_sign <= '0';
op1_exp <=  110 ;
op1_mant <= "001"&X"00020";
op2_sign <= '1';
op2_exp <=  106 ;
op2_mant <= "111"&X"fffa6";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 99 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  110 ) REPORT "Assert 100 : < res_exp /= 110 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00026") REPORT "Assert 101 : < res_mant /= 00000000000000000100110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #35.C
---------- 350 ns -----------

clk <= '1'; --   Cycle No: 35

operation <= add;
op1_sign <= '0';
op1_exp <=  110 ;
op1_mant <= "001"&X"00021";
op2_sign <= '1';
op2_exp <=  106 ;
op2_mant <= "111"&X"fffa8";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 102 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  110 ) REPORT "Assert 103 : < res_exp /= 110 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00026") REPORT "Assert 104 : < res_mant /= 00000000000000000100110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #36.D
---------- 360 ns -----------

clk <= '1'; --   Cycle No: 36

operation <= add;
op1_sign <= '0';
op1_exp <=  110 ;
op1_mant <= "001"&X"00022";
op2_sign <= '1';
op2_exp <=  106 ;
op2_mant <= "111"&X"fffa8";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 105 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  110 ) REPORT "Assert 106 : < res_exp /= 110 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00028") REPORT "Assert 107 : < res_mant /= 00000000000000000101000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #37.A
---------- 370 ns -----------

clk <= '1'; --	 Cycle No: 37

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  127 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 108 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 109 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 110 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #38.B
---------- 380 ns -----------

clk <= '1'; --   Cycle No: 38

operation <= add;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "111"&X"fff71";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "000"&X"10005";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 111 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 112 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00006") REPORT "Assert 113 : < res_mant /= 00000000000000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- Test Case #39.C
---------- 390 ns -----------

clk <= '1'; --   Cycle No: 39

operation <= add;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "000"&X"ffe80";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "001"&X"00005";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 114 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 115 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"f7006") REPORT "Assert 116 : < res_mant /= 00011110111000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #40.D
---------- 400 ns -----------

clk <= '1'; --   Cycle No: 40

operation <= add;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "000"&X"ffe80";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "001"&X"00006";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 117 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 118 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"f7008") REPORT "Assert 119 : < res_mant /= 00011110111000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #41.A
---------- 410 ns -----------

clk <= '1'; --	 Cycle No: 41

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 120 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 121 : < res_exp /= 127 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 122 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #42.B 
---------- 420 ns -----------

clk <= '1'; --   Cycle No: 42

operation <= add;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "000"&X"00007";
op2_sign <= '0';
op2_exp <=  123 ;
op2_mant <= "000"&X"00001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 123 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  123 ) REPORT "Assert 124 : < res_exp /= 123 >"
        SEVERITY warning;
ASSERT (res_mant = "001"&X"00002") REPORT "Assert 125 : < res_mant /= 00100000000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #43.C
---------- 430 ns -----------

clk <= '1'; --   Cycle No: 43

operation <= add;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "000"&X"00004";
op2_sign <= '0';
op2_exp <=  123 ;
op2_mant <= "000"&X"00008";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 126 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  123 ) REPORT "Assert 127 : < res_exp /= 123 >"
        SEVERITY warning;
ASSERT (res_mant = "00100000000000000001000") REPORT "Assert 128 : < res_mant /= 00100000000000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #44.D
---------- 440 ns -----------

clk <= '1'; --   Cycle No: 44

operation <= add;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "000"&X"00004";
op2_sign <= '0';
op2_exp <=  123 ;
op2_mant <= "000"&X"00009";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 129 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  123 ) REPORT "Assert 130 : < res_exp /= 123 >"
        SEVERITY warning;
ASSERT (res_mant = "001"&X"0000a") REPORT "Assert 131 : < res_mant /= 00100000000000000001010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #45.A
---------- 450 ns -----------

clk <= '1'; --	 Cycle No: 45

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 132 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 133 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 134 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #46.B
---------- 460 ns -----------

clk <= '1'; --   Cycle No: 46

operation <= add;
op1_sign <= '0';
op1_exp <=  139 ;
op1_mant <= "000"&X"00048";
op2_sign <= '0';
op2_exp <=  128 ;
op2_mant <= "000"&X"00401";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 135 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  139 ) REPORT "Assert 136 : < res_exp /= 139 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"01049") REPORT "Assert 137 : < res_mant /= 00000000001000001001001 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #47.C
---------- 470 ns -----------

clk <= '1'; --   Cycle No: 47

operation <= add;
op1_sign <= '0';
op1_exp <=  139 ;
op1_mant <= "000"&X"00048";
op2_sign <= '0';
op2_exp <=  128 ;
op2_mant <= "000"&X"00400";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 138 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  139 ) REPORT "Assert 139 : < res_exp /= 139 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"01048") REPORT "Assert 140 : < res_mant /= 00000000001000001001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #48.D
---------- 480 ns -----------

clk <= '1'; --   Cycle No: 48

operation <= add;
op1_sign <= '0';
op1_exp <=  139 ;
op1_mant <= "000"&X"00049";
op2_sign <= '0';
op2_exp <=  128 ;
op2_mant <= "000"&X"00400";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 141 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  139 ) REPORT "Assert 142 : < res_exp /= 139 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"0104a") REPORT "Assert 143 : < res_mant /= 00000010000000001001010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- *  Test Case #49.A
---------- 490 ns -----------

clk <= '1'; --	 Cycle No: 49

operation <= add;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "01000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 144 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 145 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "00110000000000000000000") REPORT "Assert 146 : < res_mant /= 00110000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #50.B
---------- 500 ns -----------

clk <= '1'; --   Cycle No: 50

operation <= add;
op1_sign <= '0';
op1_exp <=  128 ;
op1_mant <= "000"&X"1000d";
op2_sign <= '1';
op2_exp <=  120 ;
op2_mant <= "111"&X"fff5f";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 147 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 148 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"0000e") REPORT "Assert 149 : < res_mant /= 00000000000000000001110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #51.C
---------- 510 ns -----------

clk <= '1'; --   Cycle No: 51

operation <= add;
op1_sign <= '0';
op1_exp <=  128 ;
op1_mant <= "000"&X"1000e";
op2_sign <= '1';
op2_exp <=  121 ;
op2_mant <= "111"&X"fffe0";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 150 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 151 : < res_exp /= 127 >"
        SEVERITY warning;
ASSERT (res_mant = "111"&X"e001c") REPORT "Assert 152 : < res_mant /= 11111100000000000011100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #52.D
---------- 520 ns -----------

clk <= '1'; --   Cycle No: 52

operation <= add;
op1_sign <= '0';
op1_exp <=  128 ;
op1_mant <= "000"&X"1000f";
op2_sign <= '1';
op2_exp <=  121 ;
op2_mant <= "111"&X"fffe0";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 153 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 154 : < res_exp /= 127 >"
        SEVERITY warning;
ASSERT (res_mant = "111"&X"e001e") REPORT "Assert 155 : < res_mant /= 11111100000000000011110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- *  Test Case #53.A
---------- 530 ns -----------

clk <= '1'; --	 Cycle No: 53

operation <= add;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "00100000000000000000000";
op2_sign <= '1';
op2_exp <=  130 ;
op2_mant <= "01100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 156 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 157 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 158 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #54.B
---------- 540 ns -----------

clk <= '1'; --   Cycle No: 54

operation <= add;
op1_sign <= '0';
op1_exp <=  149 ;
op1_mant <= "111"&X"ffff7";
op2_sign <= '1';
op2_exp <=  153 ;
op2_mant <= "001"&X"00021";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 159 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  153 ) REPORT "Assert 160 : < res_exp /= 153 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00022") REPORT "Assert 161 : < res_mant /= 00000000000000000100010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #55.C
---------- 550 ns -----------

clk <= '1'; --   Cycle No: 55

operation <= add;
op1_sign <= '0';
op1_exp <=  149 ;
op1_mant <= "111"&X"ffff8";
op2_sign <= '1';
op2_exp <=  153 ;
op2_mant <= "001"&X"00022";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 162 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  153 ) REPORT "Assert 163 : < res_exp /= 153 >"
        SEVERITY warning;
ASSERT (res_mant = "00000000000000000100010") REPORT "Assert 164 : < res_mant /= 00000000000000000100010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #56.D
---------- 560 ns -----------

clk <= '1'; --   Cycle No: 56

operation <= add;
op1_sign <= '0';
op1_exp <=  149 ;
op1_mant <= "111"&X"ffff8";
op2_sign <= '1';
op2_exp <=  153 ;
op2_mant <= "001"&X"00023";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 165 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  153 ) REPORT "Assert 166 : < res_exp /= 153 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00024") REPORT "Assert 167 : < res_mant /= 00000000000000000100100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #57.A
---------- 570 ns -----------

clk <= '1'; --	 Cycle No: 57

operation <= add;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "10110000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 168 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 169 : < res_exp /= 130 >"
	SEVERITY warning;
ASSERT (res_mant = "11000000000000000000000") REPORT "Assert 170 : < res_mant /= 11000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #58.B
---------- 580 ns -----------

clk <= '1'; --   Cycle No: 58

operation <= add;
op1_sign <= '0';
op1_exp <=  141 ;
op1_mant <= "000"&X"00103";
op2_sign <= '0';
op2_exp <=  125 ;
op2_mant <= "000"&X"08001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 171 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  141 ) REPORT "Assert 172 : < res_exp /= 141 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00184") REPORT "Assert 173 : < res_mant /= 00000000000000110000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #59.C
---------- 590 ns -----------

clk <= '1'; --   Cycle No: 59

operation <= add;
op1_sign <= '0';
op1_exp <=  141 ;
op1_mant <= "000"&X"00106";
op2_sign <= '0';
op2_exp <=  125 ;
op2_mant <= "000"&X"08000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 174 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  141 ) REPORT "Assert 175 : < res_exp /= 141 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00186") REPORT "Assert 176 : < res_mant /= 00000000000000110000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #60.D
---------- 600 ns -----------

clk <= '1'; --   Cycle No: 60

operation <= add;
op1_sign <= '0';
op1_exp <=  141 ;
op1_mant <= "000"&X"00107";
op2_sign <= '0';
op2_exp <=  125 ;
op2_mant <= "000"&X"08000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 177 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  141 ) REPORT "Assert 178 : < res_exp /= 141 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00188") REPORT "Assert 179 : < res_mant /= 00000000000000110001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #61.A
---------- 610 ns -----------

clk <= '1'; --	 Cycle No: 61

operation <= add;
op1_sign <= '0';
op1_exp <=  131 ;
op1_mant <= "00110000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 180 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  131 ) REPORT "Assert 181 : < res_exp /= 131 >"
	SEVERITY warning;
ASSERT (res_mant = "10010000000000000000000") REPORT "Assert 182 : < res_mant /= 10010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- * Test Case #62.B
---------- 620 ns -----------

clk <= '1'; --   Cycle No: 62

operation <= add;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "000"&X"0020f";
op2_sign <= '0';
op2_exp <=  128 ;
op2_mant <= "000"&X"02003";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 183 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 184 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "01000000000101000010000") REPORT "Assert 185 : < res_mant /= 01000000000101000010000>"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #63.C
---------- 630 ns -----------

clk <= '1'; --   Cycle No: 63

operation <= add;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "000"&X"0020e";
op2_sign <= '0';
op2_exp <=  128 ;
op2_mant <= "000"&X"02002";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 186 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 187 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "010"&X"00a0e") REPORT "Assert 188 : < res_mant /= 01000000000101000010000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #64.D
---------- 640 ns -----------

clk <= '1'; --   Cycle No: 64

operation <= add;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "000"&X"0020f";
op2_sign <= '0';
op2_exp <=  128 ;
op2_mant <= "000"&X"02002";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 189 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 190 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "010"&X"00a10") REPORT "Assert 191 : < res_mant /= 01000000000101000010000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test nominal cases for SUBTRACT
-- * -------------------------------
-- *  
-- * Test Case #65.A 
---------- 650 ns -----------
clk <= '1'; --	 Cycle No: 65

operation <= subtract;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 192 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 193 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 194 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #66.B
---------- 660 ns -----------

clk <= '1'; --   Cycle No: 66

operation <= subtract;
op1_sign <= '1';
op1_exp <=  122 ;
op1_mant <= "111"&X"ffff3";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "000"&X"00001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 195 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 196 : < res_exp /= 125 >"
        SEVERITY warning;
ASSERT (res_mant = "110"&X"00004") REPORT "Assert 197 : < res_mant /= 11000000000000000000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #67.C
---------- 670 ns -----------

clk <= '1'; --   Cycle No: 67

operation <= subtract;
op1_sign <= '1';
op1_exp <=  122 ;
op1_mant <= "111"&X"ffffc";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "000"&X"00002";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 198 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 199 : < res_exp /= 125 >"
        SEVERITY warning;
ASSERT (res_mant = "110"&X"00004") REPORT "Assert 200 : < res_mant /= 11000000000000000000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- * Test Case #68.D
---------- 680 ns -----------

clk <= '1'; --   Cycle No: 68

operation <= subtract;
op1_sign <= '1';
op1_exp <=  122 ;
op1_mant <= "111"&X"ffff4";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "000"&X"00003";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 201 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 202 : < res_exp /= 125 >"
        SEVERITY warning;
ASSERT (res_mant = "110"&X"00008") REPORT "Assert 203 : < res_mant /= 11000000000000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- * Test Case #69.A
---------- 690 ns -----------

clk <= '1'; --	 Cycle No: 69

operation <= subtract;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 204 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 205 : < res_exp /= 127 >"
	SEVERITY warning;
ASSERT (res_mant = "01000000000000000000000") REPORT "Assert 206 : < res_mant /= 01000000000000000000000 >"
	 SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #70.B
---------- 700 ns -----------

clk <= '1'; --   Cycle No: 70

operation <= subtract;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "111"&X"fffe2";
op2_sign <= '1';
op2_exp <=  129 ;
op2_mant <= "001"&X"00002";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 207 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 208 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "110"&X"0000c") REPORT "Assert 209 : < res_mant /= 11000000000000000001100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #71.C
---------- 710 ns -----------

clk <= '1'; --   Cycle No: 71

operation <= subtract;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "111"&X"fffe4";
op2_sign <= '1';
op2_exp <=  129 ;
op2_mant <= "010"&X"00003";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 210 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 211 : < res_exp /= 129 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00006") REPORT "Assert 212 : < res_mant /= 00000000000000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #72.D
---------- 720 ns -----------

clk <= '1'; --   Cycle No: 72

operation <= subtract;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "111"&X"fffe4";
op2_sign <= '1';
op2_exp <=  129 ;
op2_mant <= "010"&X"00004";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 213 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 214 : < res_exp /= 129 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00008") REPORT "Assert 215 : < res_mant /= 00000000000000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- * Test Case #73.A
---------- 730 ns -----------

clk <= '1'; --	 Cycle No: 73

operation <= subtract;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  124 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 216 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 217 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "01000000000000000000000") REPORT "Assert 218 : < res_mant /= 01000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #74.B
---------- 740 ns -----------

clk <= '1'; --   Cycle No: 74

operation <= subtract;
op1_sign <= '1';
op1_exp <=  123 ;
op1_mant <= "000"&X"00005";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "000"&X"00000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 219 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 220 : < res_exp /= 126 >"
        SEVERITY warning;
ASSERT (res_mant = "001"&X"00001") REPORT "Assert 221 : < res_mant /= 00100000000000000000001 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #75.C
---------- 750 ns -----------

clk <= '1'; --   Cycle No: 75

operation <= subtract;
op1_sign <= '1';
op1_exp <=  123 ;
op1_mant <= "000"&X"00004";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "000"&X"00000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 222 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 223 : < res_exp /= 126 >"
        SEVERITY warning;
ASSERT (res_mant = "00100000000000000000000") REPORT "Assert 224 : < res_mant /= 00100000000000000000000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #76.D
---------- 760 ns -----------

clk <= '1'; --   Cycle No: 76

operation <= subtract;
op1_sign <= '1';
op1_exp <=  123 ;
op1_mant <= "000"&X"00004";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "000"&X"00001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 225 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 226 : < res_exp /= 126 >"
        SEVERITY warning;
ASSERT (res_mant = "001"&X"00002") REPORT "Assert 227 : < res_mant /= 00100000000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- * Test Case #77.A
---------- 770 ns -----------

clk <= '1'; --	 Cycle No: 77

operation <= subtract;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "01000000000000000000000";
op2_sign <= '0';
op2_exp <=  127 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 228 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 229 : < res_exp /= 127 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 230 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #78.B
---------- 780 ns -----------

clk <= '1'; --   Cycle No: 78

operation <= subtract;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "000"&X"00009";
op2_sign <= '0';
op2_exp <=  130 ;
op2_mant <= "000"&X"00001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 231 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 232 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80002") REPORT "Assert 233 : < res_mant /= 00010000000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #79.C
---------- 790 ns -----------

clk <= '1'; --   Cycle No: 79

operation <= subtract;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "000"&X"00008";
op2_sign <= '0';
op2_exp <=  130 ;
op2_mant <= "000"&X"00004";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 234 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 235 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80004") REPORT "Assert 236 : < res_mant /= 00010000000000000000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #80.D
---------- 800 ns -----------

clk <= '1'; --   Cycle No: 80

operation <= subtract;
op1_sign <= '1';
op1_exp <=  126 ;
op1_mant <= "000"&X"00008";
op2_sign <= '0';
op2_exp <=  130 ;
op2_mant <= "000"&X"00005";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 237 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 238 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80006") REPORT "Assert 239 : < res_mant /= 00010000000000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- * Test Case #81.A
---------- 810 ns -----------

clk <= '1'; --	 Cycle No: 81

operation <= subtract;
op1_sign <= '1';
op1_exp <=  127 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 240 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 241 : < res_exp /= 127 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 242 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #82.B
---------- 820 ns -----------

clk <= '1'; --   Cycle No: 82

operation <= subtract;
op1_sign <= '1';
op1_exp <=  129 ;
op1_mant <= "001"&X"00001";
op2_sign <= '1';
op2_exp <=  121 ;
op2_mant <= "111"&X"fff70";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 243 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 244 : < res_exp /= 129 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"f0002") REPORT "Assert 245 : < res_mant /= 00011110000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #83.C
---------- 830 ns -----------

clk <= '1'; --   Cycle No: 83

operation <= subtract;
op1_sign <= '1';
op1_exp <=  129 ;
op1_mant <= "001"&X"00002";
op2_sign <= '1';
op2_exp <=  121 ;
op2_mant <= "111"&X"fff80";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 246 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 247 : < res_exp /= 129 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"f0002") REPORT "Assert 248 : < res_mant /= 00011110000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #84.D
---------- 840 ns -----------

clk <= '1'; --   Cycle No: 84

operation <= subtract;
op1_sign <= '1';
op1_exp <=  129 ;
op1_mant <= "001"&X"00003";
op2_sign <= '1';
op2_exp <=  121 ;
op2_mant <= "111"&X"fff80";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 249 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 250 : < res_exp /= 129 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"f0004") REPORT "Assert 251 : < res_mant /= 00011110000000000000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- Test Case #85.A
---------- 850 ns -----------

clk <= '1'; --	 Cycle No: 85

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01100000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 252 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 253 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 254 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #86.B
---------- 860 ns -----------

clk <= '1'; --   Cycle No: 86

operation <= subtract;
op1_sign <= '1';
op1_exp <=  138 ;
op1_mant <= "000"&X"20003";
op2_sign <= '1';
op2_exp <=  130 ;
op2_mant <= "111"&X"fff21";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 255 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  138 ) REPORT "Assert 256 : < res_exp /= 138 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"10004") REPORT "Assert 257 : < res_mant /= 00000010000000000000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #87.C
---------- 870 ns -----------

clk <= '1'; --   Cycle No: 87

operation <= subtract;
op1_sign <= '1';
op1_exp <=  138 ;
op1_mant <= "000"&X"20006";
op2_sign <= '1';
op2_exp <=  130 ;
op2_mant <= "111"&X"fff80";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 258 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  138 ) REPORT "Assert 259 : < res_exp /= 138 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"10006") REPORT "Assert 260 : < res_mant /= 00000010000000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #88.D
---------- 880 ns -----------

clk <= '1'; --   Cycle No: 88

operation <= subtract;
op1_sign <= '1';
op1_exp <=  138 ;
op1_mant <= "000"&X"20007";
op2_sign <= '1';
op2_exp <=  130 ;
op2_mant <= "111"&X"fff80";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 261 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  138 ) REPORT "Assert 262 : < res_exp /= 138 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"10008") REPORT "Assert 263 : < res_mant /= 00000010000000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- Test Case #89.A
---------- 890 ns -----------

clk <= '1'; --	 Cycle No: 89

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 264 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 265 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "11000000000000000000000") REPORT "Assert 266 : < res_mant /= 11000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #90.B
---------- 900 ns -----------

clk <= '1'; --   Cycle No: 90

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"0000b";
op2_sign <= '0';
op2_exp <=  123 ;
op2_mant <= "000"&X"00034";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 267 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 268 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"4000d") REPORT "Assert 269 : < res_mant /= 00001000000000000001101 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #91.C
---------- 910 ns -----------

clk <= '1'; --   Cycle No: 91

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"0000b";
op2_sign <= '0';
op2_exp <=  123 ;
op2_mant <= "000"&X"00030";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 270 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 271 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"4000c") REPORT "Assert 272 : < res_mant /= 00001000000000000001100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #92.D
---------- 920 ns -----------

clk <= '1'; --   Cycle No: 92

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"0000c";
op2_sign <= '0';
op2_exp <=  123 ;
op2_mant <= "000"&X"00030";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 273 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 274 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"4000e") REPORT "Assert 275 : < res_mant /= 00001000000000000001110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- Test Case #93.A
---------- 930 ns -----------

clk <= '1'; --	 Cycle No: 93

operation <= subtract;
op1_sign <= '1';
op1_exp <=  129 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 276 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 277 : < res_exp /= 130 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 278 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #94.B
---------- 940 ns -----------

clk <= '1'; --   Cycle No: 94

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"00008";
op2_sign <= '0';
op2_exp <=  132 ;
op2_mant <= "000"&X"00001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 279 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  132 ) REPORT "Assert 280 : < res_exp /= 132 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80002") REPORT "Assert 281 : < res_mant /= 00010000000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #95.C
---------- 950 ns -----------

clk <= '1'; --   Cycle No: 95

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"00008";
op2_sign <= '0';
op2_exp <=  132 ;
op2_mant <= "000"&X"00006";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 282 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  132 ) REPORT "Assert 283 : < res_exp /= 132 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80006") REPORT "Assert 284 : < res_mant /= 00010000000000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #96.D
---------- 960 ns -----------

clk <= '1'; --   Cycle No: 96

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "000"&X"00008";
op2_sign <= '0';
op2_exp <=  132 ;
op2_mant <= "000"&X"00007";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 285 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  132 ) REPORT "Assert 286 : < res_exp /= 132 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"80008") REPORT "Assert 287 : < res_mant /= 00010000000000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- Test Case #97.A
---------- 970 ns -----------

clk <= '1'; --	 Cycle No: 97

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 288 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 289 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 290 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #98.B
---------- 980 ns -----------

clk <= '1'; --   Cycle No: 98

operation <= subtract;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "000"&X"00007";
op2_sign <= '1';
op2_exp <=  123 ;
op2_mant <= "000"&X"00001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 291 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  123) REPORT "Assert 292 : < res_exp /= 123 >"
        SEVERITY warning;
ASSERT (res_mant = "001"&X"00002") REPORT "Assert 293 : < res_mant /= 00100000000000000000010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #99.C
---------- 990 ns -----------

clk <= '1'; --   Cycle No: 99

operation <= subtract;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "000"&X"00004";
op2_sign <= '1';
op2_exp <=  123 ;
op2_mant <= "000"&X"00008";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 294 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  123 ) REPORT "Assert 295 : < res_exp /= 123 >"
        SEVERITY warning;
ASSERT (res_mant = "001"&X"00008") REPORT "Assert 296 : < res_mant /= 00100000000000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #100.D
---------- 1000 ns -----------

clk <= '1'; --   Cycle No: 100

operation <= subtract;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "000"&X"00004";
op2_sign <= '1';
op2_exp <=  123 ;
op2_mant <= "000"&X"00009";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 297 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  123 ) REPORT "Assert 298 : < res_exp /= 123 >"
        SEVERITY warning;
ASSERT (res_mant = "001"&X"0000a") REPORT "Assert 299 : < res_mant /= 00100000000000000001010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- Test Case #101.A 
---------- 1010 ns -----------

clk <= '1'; --	 Cycle No: 101

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  127 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 300 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 301 : < res_exp /= 127 >"
	SEVERITY warning;
ASSERT (res_mant = "11000000000000000000000") REPORT "Assert 302 : < res_mant /= 11000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #102.B
---------- 1020 ns -----------

clk <= '1'; --   Cycle No: 102

operation <= subtract;
op1_sign <= '0';
op1_exp <=  139 ;
op1_mant <= "000"&X"00048";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "000"&X"00401";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 303 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  139 ) REPORT "Assert 304 : < res_exp /= 139 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"01049") REPORT "Assert 305 : < res_mant /= 00000000001000000101001 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #103.C
---------- 1030 ns -----------

clk <= '1'; --   Cycle No: 103

operation <= subtract;
op1_sign <= '0';
op1_exp <=  139 ;
op1_mant <= "000"&X"00048";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "000"&X"00400";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 306 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  139 ) REPORT "Assert 307 : < res_exp /= 139 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"01048") REPORT "Assert 308 : < res_mant /= 00000000001000001001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #104.D
---------- 1040 ns -----------

clk <= '1'; --   Cycle No: 104

operation <= subtract;
op1_sign <= '0';
op1_exp <=  139 ;
op1_mant <= "000"&X"00049";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "000"&X"00400";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 309 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  139 ) REPORT "Assert 310 : < res_exp /= 139 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"0104a") REPORT "Assert 311 : < res_mant /= 00000000001000001001010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- Test Case #105.A
---------- 1050 ns -----------

clk <= '1'; --	 Cycle No: 105

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 312 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 313 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 314 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #106.B
---------- 1060 ns -----------

clk <= '1'; --   Cycle No: 106

operation <= subtract;
op1_sign <= '0';
op1_exp <=  110 ;
op1_mant <= "001"&X"00020";
op2_sign <= '0';
op2_exp <=  106 ;
op2_mant <= "111"&X"fffa6";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 315 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  110 ) REPORT "Assert 316 : < res_exp /= 110 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00026") REPORT "Assert 317 : < res_mant /= 00000000000000000101100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #107.C
---------- 1070 ns -----------

clk <= '1'; --   Cycle No: 107

operation <= subtract;
op1_sign <= '0';
op1_exp <=  110 ;
op1_mant <= "001"&X"00021";
op2_sign <= '0';
op2_exp <=  106 ;
op2_mant <= "111"&X"fffa8";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 318 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  110 ) REPORT "Assert 319 : < res_exp /= 110 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00026") REPORT "Assert 320 : < res_mant /= 00000000000000000100110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #108.D
---------- 1080 ns -----------

clk <= '1'; --   Cycle No: 108

operation <= subtract;
op1_sign <= '0';
op1_exp <=  110 ;
op1_mant <= "001"&X"00022";
op2_sign <= '0';
op2_exp <=  106 ;
op2_mant <= "111"&X"fffa8";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 321 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  110 ) REPORT "Assert 322 : < res_exp /= 110 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00028") REPORT "Assert 323 : < res_mant /= 00000000000000000101000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- Test Case #109.A
---------- 1090 ns -----------

clk <= '1'; --	 Cycle No: 109

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 324 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 325 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 326 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #110.B
---------- 1100 ns -----------

clk <= '1'; --   Cycle No: 110

operation <= subtract;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "111"&X"fff71";
op2_sign <= '0';
op2_exp <=  128 ;
op2_mant <= "000"&X"10005";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 327 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 328 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00006") REPORT "Assert 329 : < res_mant /= 00000000000000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #111.C
---------- 1110 ns -----------

clk <= '1'; --   Cycle No: 111

operation <= subtract;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "000"&X"ffe80";
op2_sign <= '0';
op2_exp <=  128 ;
op2_mant <= "001"&X"00005";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 330 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 331 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"f7006") REPORT "Assert 332 : < res_mant /= 00011110111000000000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- * Test Case #112.D
---------- 1120  ns -----------

clk <= '1'; --   Cycle No: 112

operation <= subtract;
op1_sign <= '0';
op1_exp <=  120 ;
op1_mant <= "000"&X"ffe80";
op2_sign <= '0';
op2_exp <=  128 ;
op2_mant <= "001"&X"00006";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 333 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 334 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"f7008") REPORT "Assert 335 : < res_mant /= 00011110111000000001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- Test Case #113.A
---------- 1130 ns -----------

clk <= '1'; --	 Cycle No: 113

operation <= subtract;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "01000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 336 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 337 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 338 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #114.B
---------- 1140 ns -----------

clk <= '1'; --   Cycle No: 114

operation <= subtract;
op1_sign <= '0';
op1_exp <=  141 ;
op1_mant <= "000"&X"00103";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "000"&X"08001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 339 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  141 ) REPORT "Assert 340 : < res_exp /= 141 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00184") REPORT "Assert 341 : < res_mant /= 00000000000000110000100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #115.C
---------- 1150 ns -----------

clk <= '1'; --   Cycle No: 115

operation <= subtract;
op1_sign <= '0';
op1_exp <=  141 ;
op1_mant <= "000"&X"00106";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "000"&X"08000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 342 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  141 ) REPORT "Assert 343 : < res_exp /= 141 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00186") REPORT "Assert 344 : < res_mant /= 00000000000000110000110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #116.D
---------- 1160 ns -----------

clk <= '1'; --   Cycle No: 116

operation <= subtract;
op1_sign <= '0';
op1_exp <=  141 ;
op1_mant <= "000"&X"00107";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "000"&X"08000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 345 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  141 ) REPORT "Assert 346 : < res_exp /= 141 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00188") REPORT "Assert 347 : < res_mant /= 00000000000000110001000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- * Test Case #117.A
---------- 1170 ns -----------

clk <= '1'; --	 Cycle No: 117

operation <= subtract;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "00100000000000000000000";
op2_sign <= '1';
op2_exp <=  130 ;
op2_mant <= "01100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 348 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  131 ) REPORT "Assert 349 : < res_exp /= 131 >"
	SEVERITY warning;
ASSERT (res_mant = "01000000000000000000000") REPORT "Assert 350 : < res_mant /= 01000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #118.B
---------- 1180 ns -----------

clk <= '1'; --   Cycle No: 118

operation <= subtract;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "000"&X"0020f";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "000"&X"02003";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 351 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 352 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "010"&X"00a10") REPORT "Assert 353 : < res_mant /= 01000000000101000010000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #119.C
---------- 1190 ns -----------

clk <= '1'; --   Cycle No: 119

operation <= subtract;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "000"&X"0020e";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "000"&X"02002";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 354 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 355 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "010"&X"00a0e") REPORT "Assert 356 : < res_mant /= 01000000000101000001110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #120.D
---------- 1200 ns -----------

clk <= '1'; --   Cycle No: 120

operation <= subtract;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "000"&X"0020f";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "000"&X"02002";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 357 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 358 : < res_exp /= 130 >"
        SEVERITY warning;
ASSERT (res_mant = "010"&X"00a10") REPORT "Assert 359 : < res_mant /= 01000000000101000010000 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- * Test Case #121.A
---------- 1210 ns -----------

clk <= '1'; --	 Cycle No: 121

operation <= subtract;
op1_sign <= '0';
op1_exp <=  130 ;
op1_mant <= "10110000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 360 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 361 : < res_exp /= 130 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 362 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #122.B
---------- 1220 ns -----------

clk <= '1'; --   Cycle No: 122

operation <= subtract;
op1_sign <= '0';
op1_exp <=  128 ;
op1_mant <= "000"&X"1000d";
op2_sign <= '0';
op2_exp <=  120 ;
op2_mant <= "111"&X"fff5f";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 363 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 364 : < res_exp /= 128 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"0000e") REPORT "Assert 365 : < res_mant /= 00000000000000000001110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #123.C
---------- 1230 ns -----------

clk <= '1'; --   Cycle No: 123

operation <= subtract;
op1_sign <= '0';
op1_exp <=  128 ;
op1_mant <= "000"&X"1000e";
op2_sign <= '0';
op2_exp <=  121 ;
op2_mant <= "111"&X"fffe0";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 366 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 367 : < res_exp /= 127 >"
        SEVERITY warning;
ASSERT (res_mant = "111"&X"e001c") REPORT "Assert 368 : < res_mant /= 11111100000000000011100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #124.D
---------- 1240 ns -----------

clk <= '1'; --   Cycle No: 124

operation <= subtract;
op1_sign <= '0';
op1_exp <=  128 ;
op1_mant <= "000"&X"1000f";
op2_sign <= '0';
op2_exp <=  121 ;
op2_mant <= "111"&X"fffe0";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 369 : < res_sign /= 0 >"
        SEVERITY warning;
ASSERT (res_exp =  127 ) REPORT "Assert 370 : < res_exp /= 127 >"
        SEVERITY warning;
ASSERT (res_mant = "111"&X"e001e") REPORT "Assert 371 : < res_mant /= 11111100000000000011110 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



-- * Test Case #125.A
---------- 1250 ns -----------

clk <= '1'; --	 Cycle No: 125

operation <= subtract;
op1_sign <= '0';
op1_exp <=  131 ;
op1_mant <= "00110000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 372 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  130 ) REPORT "Assert 373 : < res_exp /= 130 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 374 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #126.B
---------- 1260 ns -----------

clk <= '1'; --   Cycle No: 126

operation <= subtract;
op1_sign <= '0';
op1_exp <=  149 ;
op1_mant <= "111"&X"ffff7";
op2_sign <= '0';
op2_exp <=  153 ;
op2_mant <= "001"&X"00021";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 375 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  153 ) REPORT "Assert 376 : < res_exp /= 153 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00022") REPORT "Assert 377 : < res_mant /= 00000000000000000100010 >"
        SEVERITY warning;


-- * Test Case #127.C
---------- 1270 ns -----------

clk <= '1'; --   Cycle No: 127

operation <= subtract;
op1_sign <= '0';
op1_exp <=  149 ;
op1_mant <= "111"&X"ffff8";
op2_sign <= '0';
op2_exp <=  153 ;
op2_mant <= "001"&X"00022";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 378 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  153 ) REPORT "Assert 379 : < res_exp /= 153 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00022") REPORT "Assert 380 : < res_mant /= 00000000000000000100010 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;


-- * Test Case #128.D
---------- 1280 ns -----------

clk <= '1'; --   Cycle No: 128

operation <= subtract;
op1_sign <= '0';
op1_exp <=  149 ;
op1_mant <= "111"&X"ffff8";
op2_sign <= '0';
op2_exp <=  153 ;
op2_mant <= "001"&X"00023";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 381 : < res_sign /= 1 >"
        SEVERITY warning;
ASSERT (res_exp =  153 ) REPORT "Assert 382 : < res_exp /= 153 >"
        SEVERITY warning;
ASSERT (res_mant = "000"&X"00024") REPORT "Assert 383 : < res_mant /= 00000000000000000100100 >"
        SEVERITY warning;
clk <= '0';
wait for 5 ns;



--****************************************************************************
--****************************************************************************
--
-- *
-- * test Idle operation
-- * -------------------
-- *  
-- * No operation -- Test Case #129
-- * Same result from before
---------- 1290 ns -----------

clk <= '1'; --	 Cycle No: 129

operation <= idle;

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 384 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  153 ) REPORT "Assert 385 : < res_exp /= 153 >"
	SEVERITY warning;
ASSERT (res_mant = "000"&X"00024") REPORT "Assert 386 : < res_mant /= 00000000000000000100100 >"
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
-- * test POS_ZERO cases for ADD
-- * -----------------------
-- *
-- *  Test Case #130
---------- 1300 ns -----------

clk <= '1'; --	 Cycle No: 130

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 387 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 388 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 389 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #131
---------- 1310 ns -----------

clk <= '1'; --	 Cycle No: 131

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 390 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 391 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 392 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *  Test Case #132
---------- 1320 ns -----------

clk <= '1'; --	 Cycle No: 132

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 393 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 394 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 395 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *  Test Case #133
---------- 1330 ns -----------

clk <= '1'; --	 Cycle No: 133

operation <= add;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 396 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 397 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 398 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #134
---------- 1340 ns -----------

clk <= '1'; --	 Cycle No: 134

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 399 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 400 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 401 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #135 
---------- 1350 ns -----------

clk <= '1'; --	 Cycle No: 135

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 402 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 403 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 404 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #136
---------- 400 ns -----------

clk <= '1'; --	 Cycle No: 136

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 405 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 406 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 407 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #137
---------- 1370 ns -----------

clk <= '1'; --	 Cycle No: 137

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 408 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 409 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 410 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (0 + 0 = 0) -- Test Case #138
---------- 420 ns -----------

clk <= '1'; --	 Cycle No: 138

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 411 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 412 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 413 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #139
---------- 1390 ns -----------

clk <= '1'; --	 Cycle No: 139

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 414 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 415 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 416 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #140
---------- 1400 ns -----------

clk <= '1'; --	 Cycle No: 140

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 417 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 418 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 419 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #141
---------- 1410 ns -----------

clk <= '1'; --	 Cycle No: 141

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 420 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 421 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 422 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #142
---------- 1420 ns -----------

clk <= '1'; --	 Cycle No: 142

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 423 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 424 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 425 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #143	
---------- 1430 ns -----------

clk <= '1'; --	 Cycle No: 143

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 426 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 427 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 428 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #144	
---------- 1440 ns -----------

clk <= '1'; --	 Cycle No: 144

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 429 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 430 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 431 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #145	
---------- 1450 ns -----------

clk <= '1'; --	 Cycle No: 145

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 432 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 433 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 434 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test POS_ZERO cases for SUBTRACT
-- * --------------------------------
-- *
-- * Test Case #146
---------- 1460 ns -----------

clk <= '1'; --	 Cycle No: 146

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 435 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 436 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 437 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #147
---------- 1470 ns -----------

clk <= '1'; --	 Cycle No: 147

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 438 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 439 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 440 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #148
---------- 1480 ns -----------

clk <= '1'; --	 Cycle No: 148

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 441 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 442 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 443 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #149
---------- 1490 ns -----------

clk <= '1'; --	 Cycle No: 149

operation <= subtract;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 444 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 445 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 446 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #150
---------- 1500 ns -----------

clk <= '1'; --	 Cycle No: 150

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 447 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 448 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 449 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #151 
---------- 1510 ns -----------

clk <= '1'; --	 Cycle No: 151

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 450 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 451 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 452 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #152
---------- 152 ns -----------

clk <= '1'; --	 Cycle No: 152

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 453 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 454 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 455 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #153
---------- 1530 ns -----------

clk <= '1'; --	 Cycle No: 153

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 456 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 457 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 458 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #154
---------- 1540 ns -----------

clk <= '1'; --	 Cycle No: 154

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 459 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 460 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 461 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #155
---------- 1550 ns -----------

clk <= '1'; --	 Cycle No: 155

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 462 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 463 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 464 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #156
---------- 1560 ns -----------

clk <= '1'; --	 Cycle No: 156

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 465 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 466 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 467 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #157
---------- 1570 ns -----------

clk <= '1'; --	 Cycle No: 157

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 468 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 469 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 470 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #158	
---------- 1580 ns -----------

clk <= '1'; --	 Cycle No: 158

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 471 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 472 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 473 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #159	
---------- 1590 ns -----------

clk <= '1'; --	 Cycle No: 159

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 474 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 475 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 476 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #160
---------- 1600 ns -----------

clk <= '1'; --	 Cycle No: 160

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 477 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 478 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 479 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #161
---------- 1610 ns -----------

clk <= '1'; --	 Cycle No: 161

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 480 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 481 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 482 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test NEG_ZERO cases for ADD
-- * ---------------------------
-- *
-- * Test Case #162
---------- 1620 ns -----------

clk <= '1'; --	 Cycle No: 162

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 483 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 484 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 485 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #163
---------- 1630 ns -----------

clk <= '1'; --	 Cycle No: 163

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 486 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 487 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 488 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #164
---------- 1640 ns -----------

clk <= '1'; --	 Cycle No: 164

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 489 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 490 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 491 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #165
---------- 1650 ns -----------

clk <= '1'; --	 Cycle No: 165

operation <= add;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 492 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 493 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 494 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #166
---------- 1660 ns -----------

clk <= '1'; --	 Cycle No: 166

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 495 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 496 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 497 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #167 
---------- 1670 ns -----------

clk <= '1'; --	 Cycle No:167  

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 498 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 499 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 500 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #168
---------- 1680 ns -----------

clk <= '1'; --	 Cycle No: 168

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 501 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 502 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 503 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #169
---------- 1690 ns -----------

clk <= '1'; --	 Cycle No: 169

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 504 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 505 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 506 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #170
---------- 1700 ns -----------

clk <= '1'; --	 Cycle No: 170

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 507 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 508 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 509 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #171	
---------- 1710 ns -----------

clk <= '1'; --	 Cycle No: 171

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 510 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 511 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 512 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (-0 + MIN_NEG = MIN_NEG) -- Test Case #172
---------- 1720 ns -----------

clk <= '1'; --	 Cycle No: 172

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 513 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 514 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 515 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #173
---------- 1730 ns -----------

clk <= '1'; --	 Cycle No: 173

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 516 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 517 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 518 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #174
---------- 1740 ns -----------

clk <= '1'; --	 Cycle No: 174

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 519 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 520 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 521 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #175	
---------- 1750 ns -----------

clk <= '1'; --	 Cycle No: 175

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 522 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 523 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 524 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #176	
---------- 1760 ns -----------

clk <= '1'; --	 Cycle No: 176

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 525 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 526 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 527 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #177
---------- 1770 ns -----------

clk <= '1'; --	 Cycle No: 177

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 528 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 529 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 530 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test NEG_ZERO cases for SUBTRACT
-- * --------------------------------
-- *
-- * Test Case #178
---------- 1780 ns -----------

clk <= '1'; --	 Cycle No: 178

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 531 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 532 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 533 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #179
---------- 1790 ns -----------

clk <= '1'; --	 Cycle No: 179

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 534 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 535 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 536 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #180
---------- 1800 ns -----------

clk <= '1'; --	 Cycle No: 180

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 537 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 538 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 539 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #181
---------- 1810 ns -----------

clk <= '1'; --	 Cycle No: 181

operation <= subtract;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 540 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 541 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 542 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #182
---------- 1820 ns -----------

clk <= '1'; --	 Cycle No: 182

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 543 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 544 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 545 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #183 
---------- 1830 ns -----------

clk <= '1'; --	 Cycle No: 183

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 546 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 547 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 548 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #184
---------- 1840 ns -----------

clk <= '1'; --	 Cycle No: 184

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 549 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 550 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 551 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #185
---------- 1850 ns -----------

clk <= '1'; --	 Cycle No: 185

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 552 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 553 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 554 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #186
---------- 1860 ns -----------

clk <= '1'; --	 Cycle No: 186

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 555 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 556 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 557 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #187
---------- 1870 ns -----------

clk <= '1'; --	 Cycle No: 187

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 558 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 559 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 560 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #188
---------- 1880 ns -----------

clk <= '1'; --	 Cycle No: 188

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 561 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 562 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 563 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #189
---------- 1890 ns -----------

clk <= '1'; --	 Cycle No: 189

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 564 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 565 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 566 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #190	
---------- 1900 ns -----------

clk <= '1'; --	 Cycle No: 190

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 567 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 568 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 569 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #191	
---------- 1910 ns -----------

clk <= '1'; --	 Cycle No: 191

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 570 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 571 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 572 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #192
---------- 1920 ns -----------

clk <= '1'; --	 Cycle No: 192

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 573 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 574 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 575 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #193
---------- 1930 ns -----------

clk <= '1'; --	 Cycle No: 193

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 576 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 577 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 578 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MIN_POS cases for ADD
-- * --------------------------
-- *
-- * Test Case #194
---------- 1940 ns -----------

clk <= '1'; --	 Cycle No: 194

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 579 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 580 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 581 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #195
---------- 1950 ns -----------

clk <= '1'; --	 Cycle No: 195

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 582 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 583 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 584 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #196
---------- 1960 ns -----------

clk <= '1'; --	 Cycle No: 196

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 585 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 586 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 587 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #197
---------- 1970 ns -----------

clk <= '1'; --	 Cycle No: 197

operation <= add;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 588 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 589 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 590 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #198
---------- 1980 ns -----------

clk <= '1'; --	 Cycle No: 198

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 591 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 592 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 593 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #199
---------- 1990 ns -----------

clk <= '1'; --	 Cycle No: 199

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 594 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 595 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 596 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #200
---------- 2000 ns -----------

clk <= '1'; --	 Cycle No: 200

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 597 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 598 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 599 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #201
---------- 2010 ns -----------

clk <= '1'; --	 Cycle No: 201

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 600 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 601 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 602 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #202
---------- 2020 ns -----------

clk <= '1'; --	 Cycle No: 202

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 603 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 604 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 605 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #203
---------- 2030 ns -----------

clk <= '1'; --	 Cycle No: 203

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 606 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 607 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 608 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #204
---------- 2040 ns -----------

clk <= '1'; --	 Cycle No: 204

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 609 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 610 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 611 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #205
---------- 2050 ns -----------

clk <= '1'; --	 Cycle No: 205

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 612 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 613 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 614 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #206
---------- 2060 ns -----------

clk <= '1'; --	 Cycle No: 206

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 615 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 616 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 617 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #207
---------- 2070 ns -----------

clk <= '1'; --	 Cycle No: 207

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 618 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 619 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 620 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #208	
---------- 2080 ns -----------

clk <= '1'; --	 Cycle No: 208

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 621 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 622 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 623 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #209
---------- 2090 ns -----------

clk <= '1'; --	 Cycle No: 209

operation <= add;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "10101010101010101010101";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 624 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 625 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "10101010101010101010101") REPORT "Assert 626 : < res_mant /= 10101010101010101010101 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MIN_POS cases for SUBTRACT
-- * -------------------------------
-- *
-- * Test Case #210
---------- 2100 ns -----------

clk <= '1'; --	 Cycle No: 210

operation <= subtract;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 627 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 628 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 629 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #211
---------- 2110 ns -----------

clk <= '1'; --	 Cycle No: 211

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 630 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 631 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 632 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #212
---------- 2120 ns -----------

clk <= '1'; --	 Cycle No: 212

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 633 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 634 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 635 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #213
---------- 2130 ns -----------

clk <= '1'; --	 Cycle No: 213

operation <= subtract;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 636 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 637 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 638 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #214 
---------- 2140 ns -----------

clk <= '1'; --	 Cycle No: 214

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 639 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 640 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 641 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #215
---------- 2150 ns -----------

clk <= '1'; --	 Cycle No: 215

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 642 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 643 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 644 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #216
---------- 2160 ns -----------

clk <= '1'; --	 Cycle No: 216

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 645 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 646 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 647 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #217
---------- 2170 ns -----------

clk <= '1'; --	 Cycle No: 217

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 648 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 649 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 650 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #218
---------- 2180 ns -----------

clk <= '1'; --	 Cycle No: 218

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 651 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 652 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 653 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #219
---------- 2190 ns -----------

clk <= '1'; --	 Cycle No: 219

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 654 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 655 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 656 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #220
---------- 2200 ns -----------

clk <= '1'; --	 Cycle No: 220

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 657 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 658 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 659 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #221
---------- 2210 ns -----------

clk <= '1'; --	 Cycle No: 221

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 660 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 661 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 662 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #222
---------- 2220 ns -----------

clk <= '1'; --	 Cycle No: 222

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 663 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 664 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 665 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #223
---------- 2230 ns -----------

clk <= '1'; --	 Cycle No: 223

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 666 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 667 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 668 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #224
---------- 2240 ns -----------

clk <= '1'; --	 Cycle No: 224

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 669 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 670 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 671 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #225
---------- 2250 ns -----------

clk <= '1'; --	 Cycle No: 225

operation <= subtract;
op1_sign <= '0';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 672 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 673 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 674 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MIN_NEG cases for ADD
-- * --------------------------
-- *
-- * Test Case #226
---------- 2260 ns -----------

clk <= '1'; --	 Cycle No: 226

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 675 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 676 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 677 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #227
---------- 2270 ns -----------

clk <= '1'; --	 Cycle No: 227

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 678 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 679 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 680 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #228
---------- 2280 ns -----------

clk <= '1'; --	 Cycle No: 228

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 681 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 682 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 683 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #229
---------- 2290 ns -----------

clk <= '1'; --	 Cycle No: 229

operation <= add;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 684 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 685 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 686 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #230
---------- 2300 ns -----------

clk <= '1'; --	 Cycle No: 230

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 687 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 688 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 689 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #231
---------- 2310 ns -----------

clk <= '1'; --	 Cycle No: 231

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 690 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 691 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 692 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #232
---------- 2320 ns -----------

clk <= '1'; --	 Cycle No: 232

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 693 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 694 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 695 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #233
---------- 2330 ns -----------

clk <= '1'; --	 Cycle No: 233

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 696 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 697 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 698 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #234
---------- 2340 ns -----------

clk <= '1'; --	 Cycle No: 234

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 699 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 700 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 701 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #235
---------- 2350 ns -----------

clk <= '1'; --	 Cycle No: 235

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 702 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 703 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 704 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #236
---------- 2360 ns -----------

clk <= '1'; --	 Cycle No: 236

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 705 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 706 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 707 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #237
---------- 2370 ns -----------

clk <= '1'; --	 Cycle No: 237

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 708 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 709 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 710 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #238
---------- 2380 ns -----------

clk <= '1'; --	 Cycle No: 238

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 711 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 712 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 713 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #239
---------- 2390 ns -----------

clk <= '1'; --	 Cycle No: 239

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 714 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 715 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 716 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #240	
---------- 2400 ns -----------

clk <= '1'; --	 Cycle No: 240

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 717 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 718 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 719 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #241
---------- 2410 ns -----------

clk <= '1'; --	 Cycle No: 241

operation <= add;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 720 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 721 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 722 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MIN_NEG cases for SUBTRACT
-- * -------------------------------
-- *
-- * Test Case #242
---------- 2420 ns -----------

clk <= '1'; --	 Cycle No: 242

operation <= subtract;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 723 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 724 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 725 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #243
---------- 2430 ns -----------

clk <= '1'; --	 Cycle No: 243

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 726 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 727 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 728 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #244
---------- 2440 ns -----------

clk <= '1'; --	 Cycle No: 244

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 729 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 730 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 731 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #245
---------- 2450 ns -----------

clk <= '1'; --	 Cycle No: 245

operation <= subtract;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 732 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 733 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 734 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #246
---------- 2460 ns -----------

clk <= '1'; --	 Cycle No: 246

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 735 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  125 ) REPORT "Assert 736 : < res_exp /= 125 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 737 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #247
---------- 2470 ns -----------

clk <= '1'; --	 Cycle No: 247

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 738 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  128 ) REPORT "Assert 739 : < res_exp /= 128 >"
	SEVERITY warning;
ASSERT (res_mant = "01010000000000000000000") REPORT "Assert 740 : < res_mant /= 01010000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #248
---------- 2480 ns -----------

clk <= '1'; --	 Cycle No: 248

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 741 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  126 ) REPORT "Assert 742 : < res_exp /= 126 >"
	SEVERITY warning;
ASSERT (res_mant = "10100000000000000000000") REPORT "Assert 743 : < res_mant /= 10100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #249
---------- 2490 ns -----------

clk <= '1'; --	 Cycle No: 249

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 744 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  129 ) REPORT "Assert 745 : < res_exp /= 129 >"
	SEVERITY warning;
ASSERT (res_mant = "11100000000000000000000") REPORT "Assert 746 : < res_mant /= 11100000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #250
---------- 2500 ns -----------

clk <= '1'; --	 Cycle No: 250

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 747 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 748 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 749 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #251
---------- 2510 ns -----------

clk <= '1'; --	 Cycle No: 251

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 750 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  1 ) REPORT "Assert 751 : < res_exp /= 1 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000001") REPORT "Assert 752 : < res_mant /= 00000000000000000000001 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #252
---------- 2520 ns -----------

clk <= '1'; --	 Cycle No: 252

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 753 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 754 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 755 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #253
---------- 2530 ns -----------

clk <= '1'; --	 Cycle No: 253

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 756 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 757 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 758 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #254
---------- 2540 ns -----------

clk <= '1'; --	 Cycle No: 254

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 759 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 760 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 761 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #255
---------- 255 ns -----------

clk <= '1'; --	 Cycle No: 255

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 762 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 763 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 764 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #256
---------- 2560 ns -----------

clk <= '1'; --	 Cycle No: 256

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 765 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 766 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 767 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #257
---------- 2570 ns -----------

clk <= '1'; --	 Cycle No: 257

operation <= subtract;
op1_sign <= '1';
op1_exp <=  0 ;
op1_mant <= "00000000000000000000001";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 768 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 769 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 770 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MAX_POS cases for ADD
-- * --------------------------
-- *
-- * Test Case #258
---------- 2580 ns -----------

clk <= '1'; --	 Cycle No: 258

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 771 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 772 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 773 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #259
---------- 2590 ns -----------

clk <= '1'; --	 Cycle No: 259

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 774 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 775 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 776 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #260
---------- 2600 ns -----------

clk <= '1'; --	 Cycle No: 260

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 777 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 778 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 779 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #261
---------- 2610 ns -----------

clk <= '1'; --	 Cycle No: 261

operation <= add;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 780 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 781 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 782 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #262
---------- 2620 ns -----------

clk <= '1'; --	 Cycle No: 262

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 783 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 784 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 785 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #263 
---------- 2630 ns -----------

clk <= '1'; --	 Cycle No: 263

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 786 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 787 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 788 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #264
---------- 2640 ns -----------

clk <= '1'; --	 Cycle No: 264

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 789 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 790 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 791 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #265
---------- 2650 ns -----------

clk <= '1'; --	 Cycle No: 265

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 792 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 793 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 794 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #266
---------- 2660 ns -----------

clk <= '1'; --	 Cycle No: 266

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 795 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 796 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 797 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #267
---------- 2670 ns -----------

clk <= '1'; --	 Cycle No: 267

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 798 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 799 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 800 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #268
---------- 2680 ns -----------

clk <= '1'; --	 Cycle No: 268

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 801 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 802 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 803 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #269
---------- 2690 ns -----------

clk <= '1'; --	 Cycle No: 269

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 804 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 805 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 806 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #270
---------- 2700 ns -----------

clk <= '1'; --	 Cycle No: 270

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 807 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 808 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 809 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #271
---------- 2710 ns -----------

clk <= '1'; --	 Cycle No: 271

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 810 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 811 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 812 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #272
---------- 2720 ns -----------

clk <= '1'; --	 Cycle No: 272

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 813 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 814 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 815 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #273
---------- 2730 ns -----------

clk <= '1'; --	 Cycle No: 273

operation <= add;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 816 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 817 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 818 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MAX_POS cases for SUBTRACT
-- * -------------------------------
-- *
-- * Test Case #274
---------- 2740 ns -----------

clk <= '1'; --	 Cycle No: 274

operation <= subtract;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 819 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 820 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 821 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #275
---------- 2750 ns -----------

clk <= '1'; --	 Cycle No: 275

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 822 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 823 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 824 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #276
---------- 2760 ns -----------

clk <= '1'; --	 Cycle No: 276

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 825 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 826 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 827 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #277
---------- 2770 ns -----------

clk <= '1'; --	 Cycle No: 277

operation <= subtract;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 828 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 829 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 830 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #278
---------- 2780 ns -----------

clk <= '1'; --	 Cycle No: 278

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 831 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 832 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 833 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #279
---------- 2790 ns -----------

clk <= '1'; --	 Cycle No: 279

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 834 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 835 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 836 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #280
---------- 2800 ns -----------

clk <= '1'; --	 Cycle No: 280

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 837 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 838 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 839 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #281
---------- 2810 ns -----------

clk <= '1'; --	 Cycle No: 281

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 840 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 841 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 842 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #282
---------- 2820 ns -----------

clk <= '1'; --	 Cycle No: 282

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 843 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 844 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 845 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #283
---------- 2830 ns -----------

clk <= '1'; --	 Cycle No: 283

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 846 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 847 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 848 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #284
---------- 2840 ns -----------

clk <= '1'; --	 Cycle No: 284

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 849 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 850 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 851 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #285
---------- 2850 ns -----------

clk <= '1'; --	 Cycle No: 285

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 852 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 853 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 854 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #286 
---------- 2860 ns -----------

clk <= '1'; --	 Cycle No: 286

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 855 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 856 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 857 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #287
---------- 2870 ns -----------

clk <= '1'; --	 Cycle No: 287

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 858 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 859 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 860 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #288
---------- 2880 ns -----------

clk <= '1'; --	 Cycle No: 288

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 861 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 862 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 863 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #289
---------- 2890 ns -----------

clk <= '1'; --	 Cycle No: 289

operation <= subtract;
op1_sign <= '0';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 864 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 865 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 866 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MAX_NEG cases for ADD
-- * --------------------------
-- *
-- * Test Case #290
---------- 2900 ns -----------

clk <= '1'; --	 Cycle No: 290

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 867 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 868 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 869 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #291
---------- 2910 ns -----------

clk <= '1'; --	 Cycle No: 291

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 870 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 871 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 872 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #292
---------- 2920 ns -----------

clk <= '1'; --	 Cycle No: 292

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 873 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 874 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 875 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #293
---------- 2930 ns -----------

clk <= '1'; --	 Cycle No: 293

operation <= add;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 876 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 877 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 878 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #294
---------- 2940 ns -----------

clk <= '1'; --	 Cycle No: 294

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 879 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 880 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 881 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #295
---------- 2950 ns -----------

clk <= '1'; --	 Cycle No: 295

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 882 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 883 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 884 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #296
---------- 2960 ns -----------

clk <= '1'; --	 Cycle No: 296

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 885 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 886 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 887 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #297
---------- 2970 ns -----------

clk <= '1'; --	 Cycle No: 297

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 888 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 889 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 890 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #298
---------- 2980 ns -----------

clk <= '1'; --	 Cycle No: 298

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 891 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 892 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 893 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #299
---------- 2990 ns -----------

clk <= '1'; --	 Cycle No: 299

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 894 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 895 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 896 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #300
---------- 3000 ns -----------

clk <= '1'; --	 Cycle No: 300

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 897 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 898 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 899 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #301
---------- 3010 ns -----------

clk <= '1'; --	 Cycle No: 301

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 900 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 901 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 902 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #302	
---------- 3020 ns -----------

clk <= '1'; --	 Cycle No: 302

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 903 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 904 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 905 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #303
---------- 3030 ns -----------

clk <= '1'; --	 Cycle No: 303

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 906 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 907 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 908 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #304
---------- 3040 ns -----------

clk <= '1'; --	 Cycle No: 304

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 909 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 910 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 911 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #305
---------- 3050 ns -----------

clk <= '1'; --	 Cycle No: 305

operation <= add;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 912 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 913 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 914 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test MAX_NEG cases for SUBTRACT
-- * -------------------------------
-- *
-- * Test Case #306 
---------- 3060 ns -----------

clk <= '1'; --	 Cycle No: 306

operation <= subtract;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 915 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 916 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 917 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #307 
---------- 3070 ns -----------

clk <= '1'; --	 Cycle No: 307

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 918 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 919 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 920 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #308
---------- 308 ns -----------

clk <= '1'; --	 Cycle No: 308

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 921 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 922 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 923 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #309
---------- 3090 ns -----------

clk <= '1'; --	 Cycle No: 309

operation <= subtract;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 924 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 925 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 926 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #310
---------- 3100 ns -----------

clk <= '1'; --	 Cycle No: 310

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 927 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 928 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 929 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #311
---------- 3110 ns -----------

clk <= '1'; --	 Cycle No: 311

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 930 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 931 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 932 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #312
---------- 3120 ns -----------

clk <= '1'; --	 Cycle No: 312

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 933 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 934 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 935 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #313
---------- 3130 ns -----------

clk <= '1'; --	 Cycle No: 313

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 936 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 937 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 938 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #314
---------- 3140 ns -----------

clk <= '1'; --	 Cycle No: 314

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 939 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 940 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 941 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #315
---------- 3150 ns -----------

clk <= '1'; --	 Cycle No: 315

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 942 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 943 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 944 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #316
---------- 3160 ns -----------

clk <= '1'; --	 Cycle No: 316

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 945 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  254 ) REPORT "Assert 946 : < res_exp /= 254 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111111") REPORT "Assert 947 : < res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #317
---------- 3170 ns -----------

clk <= '1'; --	 Cycle No: 317

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 948 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 949 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 950 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #318
---------- 3180 ns -----------

clk <= '1'; --	 Cycle No: 318

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 951 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 952 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 953 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #319
---------- 3190 ns -----------

clk <= '1'; --	 Cycle No: 319

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 954 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 955 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 956 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #320
---------- 3200 ns -----------

clk <= '1'; --	 Cycle No: 320

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 957 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 958 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 959 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #321
---------- 3210 ns -----------

clk <= '1'; --	 Cycle No: 321

operation <= subtract;
op1_sign <= '1';
op1_exp <=  254 ;
op1_mant <= "11111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 960 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 961 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "10000000000000000000000") REPORT "Assert 962 : < res_mant /= 10000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test POS_INF cases for ADD
-- * --------------------------
-- *
-- * Test Case #322
---------- 3220 ns -----------

clk <= '1'; --	 Cycle No: 322

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 963 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 964 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 965 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #323	
---------- 3230	 ns -----------

clk <= '1'; --	 Cycle No: 323	

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 966 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 967 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 968 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #324
---------- 3240 ns -----------

clk <= '1'; --	 Cycle No: 324

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 969 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 970 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 971 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #325
---------- 3250 ns -----------

clk <= '1'; --	 Cycle No: 325

operation <= add;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 972 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 973 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 974 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #326
---------- 3260 ns -----------

clk <= '1'; --	 Cycle No: 326

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 975 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 976 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 977 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #327
---------- 3270 ns -----------

clk <= '1'; --	 Cycle No: 327

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 978 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 979 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 980 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #328
---------- 3280 ns -----------

clk <= '1'; --	 Cycle No: 328

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 981 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 982 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 983 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #329
---------- 3290 ns -----------

clk <= '1'; --	 Cycle No: 329

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 984 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 985 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 986 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #330
---------- 3300 ns -----------

clk <= '1'; --	 Cycle No: 330

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 987 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 988 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 989 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #331
---------- 3310 ns -----------

clk <= '1'; --	 Cycle No: 331

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 990 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 991 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 992 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #332
---------- 3320 ns -----------

clk <= '1'; --	 Cycle No: 332

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 993 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 994 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 995 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #333
---------- 3330 ns -----------

clk <= '1'; --	 Cycle No: 333

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 996 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 997 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 998 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #334
---------- 3340 ns -----------

clk <= '1'; --	 Cycle No: 334

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 999 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1000 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1001 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #335
---------- 3350 ns -----------

clk <= '1'; --	 Cycle No: 335

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1002 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1003 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant ="000"&X"00000") REPORT "Assert 1004 :< res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #336
---------- 3360 ns -----------

clk <= '1'; --	 Cycle No: 336

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1005 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 1006 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant ="000"&X"00000") REPORT "Assert 1007 :< res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #337
---------- 3370 ns -----------

clk <= '1'; --	 Cycle No: 337

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1008 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1009 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant ="111"&X"fffff") REPORT "Assert 1010 :< res_mant /= 11111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test POS_INF cases for SUBTRACT
-- * -------------------------------
-- *
-- * Test Case #338 
---------- 3380 ns -----------

clk <= '1'; --	 Cycle No: 338

operation <= subtract;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1011 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1012 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1013 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #339 
---------- 3390 ns -----------

clk <= '1'; --	 Cycle No: 339

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1014 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1015 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1016 : < res_mant /= 00000000000000000000000 >"
	 SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #340
---------- 3400 ns -----------

clk <= '1'; --	 Cycle No: 340

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1017 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1018 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1019 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #341
---------- 3410 ns -----------

clk <= '1'; --	 Cycle No: 341

operation <= subtract;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1020 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1021 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1022 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #342
---------- 3420 ns -----------

clk <= '1'; --	 Cycle No: 342

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1023 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1024 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1025 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #343
---------- 3430 ns -----------

clk <= '1'; --	 Cycle No: 343

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1026 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1027 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1028 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #344
---------- 3440 ns -----------

clk <= '1'; --	 Cycle No: 344

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1029 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1030 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1031 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #345
---------- 3450 ns -----------

clk <= '1'; --	 Cycle No: 345

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1032 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1033 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1034 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #346
---------- 3460 ns -----------

clk <= '1'; --	 Cycle No: 346

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1035 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1036 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1037 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #347
---------- 3470 ns -----------

clk <= '1'; --	 Cycle No: 347

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1038 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1039 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1040 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #348
---------- 3480 ns -----------

clk <= '1'; --	 Cycle No: 348

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1041 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1042 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1043 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #349
---------- 3490 ns -----------

clk <= '1'; --	 Cycle No: 349

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1044 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1045 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1046 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #350
---------- 3500 ns -----------

clk <= '1'; --	 Cycle No: 350

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1047 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1048 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1049 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #351
---------- 3510 ns -----------

clk <= '1'; --	 Cycle No: 351

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1050 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 1051 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1052 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #352
---------- 3520 ns -----------

clk <= '1'; --	 Cycle No: 352

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1053 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1054 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1055 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #353
---------- 3530 ns -----------

clk <= '1'; --	 Cycle No: 353

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111100";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1056 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1057 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111100") REPORT "Assert 1058 : < res_mant /= 11111111111111111111100 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test NEG_INF cases for ADD
-- * --------------------------
-- *
-- * Test Case #354
---------- 3540 ns -----------

clk <= '1'; --	 Cycle No: 354

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1059 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1060 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1061 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #355
---------- 3550 ns -----------

clk <= '1'; --	 Cycle No: 355

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1062 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1063 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1064 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #356
---------- 3560 ns -----------

clk <= '1'; --	 Cycle No: 356

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1065 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1066 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1067 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #357
---------- 3570 ns -----------

clk <= '1'; --	 Cycle No: 357

operation <= add;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1068 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1069 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1070 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #358
---------- 3580 ns -----------

clk <= '1'; --	 Cycle No: 358

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1071 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1072 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1073 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #359
---------- 3590 ns -----------

clk <= '1'; --	 Cycle No: 359

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1074 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1075 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1076 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #360
---------- 3600 ns -----------

clk <= '1'; --	 Cycle No: 360

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1077 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1078 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1079 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #361
---------- 3610 ns -----------

clk <= '1'; --	 Cycle No: 361

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1080 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1081 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1082 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #362
---------- 3620 ns -----------

clk <= '1'; --	 Cycle No: 362

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1083 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1084 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1085 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #363
---------- 3630 ns -----------

clk <= '1'; --	 Cycle No: 363

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1086 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1087 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1088 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case 364
---------- 3640 ns -----------

clk <= '1'; --	 Cycle No: 364

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1089 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1090 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1091 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #365
---------- 3650 ns -----------

clk <= '1'; --	 Cycle No: 365

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1092 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1093 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1094 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #366
---------- 3660 ns -----------

clk <= '1'; --	 Cycle No: 366

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1095 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1096 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1097 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #367
---------- 3670 ns -----------

clk <= '1'; --	 Cycle No: 367

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1098 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 1099 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1100 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #368
---------- 3680 ns -----------

clk <= '1'; --	 Cycle No: 368

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1101 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1102 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1103 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #369
---------- 3690 ns -----------

clk <= '1'; --	 Cycle No: 369

operation <= add;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111100";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1104 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1105 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111100") REPORT "Assert 1106 : < res_mant /= 11111111111111111111100 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test NEG_INF cases for SUBTRACT
-- * -------------------------------
-- *
-- * Test Case #370 
---------- 3700 ns -----------

clk <= '1'; --	 Cycle No: 370

operation <= subtract;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1107 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1108 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1109 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #371 
---------- 3710 ns -----------

clk <= '1'; --	 Cycle No: 371

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1110 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1111 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1112 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #372
---------- 3720 ns -----------

clk <= '1'; --	 Cycle No: 372

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1113 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1114 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1115 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #373
---------- 3730 ns -----------

clk <= '1'; --	 Cycle No: 373

operation <= subtract;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1116 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1117 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1118 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #374
---------- 3740 ns -----------

clk <= '1'; --	 Cycle No: 374

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1119 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1120 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1121 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #375
---------- 3750 ns -----------

clk <= '1'; --	 Cycle No: 375

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1122 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1123 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1124 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #376
---------- 3760 ns -----------

clk <= '1'; --	 Cycle No: 376

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1125 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1126 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1127 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #377
---------- 3770 ns -----------

clk <= '1'; --	 Cycle No: 377

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1128 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1129 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1130 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #378
---------- 3780 ns -----------

clk <= '1'; --	 Cycle No: 378

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1131 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1132 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1133 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #379
---------- 3790 ns -----------

clk <= '1'; --	 Cycle No: 379

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1134 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1135 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1136 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #380
---------- 3800 ns -----------

clk <= '1'; --	 Cycle No: 380

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1137 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1138 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1139 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #381
---------- 3810 ns -----------

clk <= '1'; --	 Cycle No: 381

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1140 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1141 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1142 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #382
---------- 3820 ns -----------

clk <= '1'; --	 Cycle No: 382

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1143 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1144 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1145 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #383
---------- 3830 ns -----------

clk <= '1'; --	 Cycle No: 383

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '1') REPORT "Assert 1146 : < res_sign /= 1 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1147 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1148 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #384
---------- 3840 ns -----------

clk <= '1'; --	 Cycle No: 384

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1149 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  0 ) REPORT "Assert 1150 : < res_exp /= 0 >"
	SEVERITY warning;
ASSERT (res_mant = "00000000000000000000000") REPORT "Assert 1151 : < res_mant /= 00000000000000000000000 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * (NEG_INF - NaN = NaN) -- Test Case #385
---------- 3850 ns -----------

clk <= '1'; --	 Cycle No: 385

operation <= subtract;
op1_sign <= '1';
op1_exp <=  255 ;
op1_mant <= "00000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111100";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1152 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1153 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111100") REPORT "Assert 1154 : < res_mant /= 11111111111111111111100 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test NaN cases for ADD
-- * --------------------------
-- *
-- * Test Case #386
---------- 3860 ns -----------

clk <= '1'; --	 Cycle No: 386

operation <= add;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1155 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1156 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1157 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #387
---------- 3870 ns -----------

clk <= '1'; --	 Cycle No: 387

operation <= add;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1158 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1159 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1160 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #388
---------- 3880 ns -----------

clk <= '1'; --	 Cycle No: 388

operation <= add;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1161 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1162 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1163 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #389
---------- 3890 ns -----------

clk <= '1'; --	 Cycle No: 389

operation <= add;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1164 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1165 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1166 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #390
---------- 3900 ns -----------

clk <= '1'; --	 Cycle No: 390

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1167 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1168 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1169 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #391
---------- 3910 ns -----------

clk <= '1'; --	 Cycle No: 391

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1170 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1171 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1172 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #392
---------- 3920 ns -----------

clk <= '1'; --	 Cycle No: 392

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1173 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1174 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1175 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #393
---------- 3930 ns -----------

clk <= '1'; --	 Cycle No: 393

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1176 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1177 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1178 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #394
---------- 3940 ns -----------

clk <= '1'; --	 Cycle No: 394

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1179 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1180 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1181 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #395
---------- 3950 ns -----------

clk <= '1'; --	 Cycle No: 395

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1182 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1183 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1184 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #396
---------- 3960 ns -----------

clk <= '1'; --	 Cycle No: 396

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1185 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1186 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1187 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #397
---------- 3970 ns -----------

clk <= '1'; --	 Cycle No: 397

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1188 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1189 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1190 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #398
---------- 3980 ns -----------

clk <= '1'; --	 Cycle No: 398

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '1';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1191 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1192 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1193 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #399
---------- 3990 ns -----------

clk <= '1'; --	 Cycle No: 399

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1194 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1195 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1196 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #400
---------- 4000 ns -----------

clk <= '1'; --	 Cycle No: 400

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '1';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1197 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1198 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1199 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #401
---------- 4010 ns -----------

clk <= '1'; --	 Cycle No: 401

operation <= add;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111100";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111100";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1200 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1201 < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111100") REPORT "Assert 1202 : < res_mant /= 11111111111111111111100 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- *
-- * test NaN cases for SUBTRACT
-- * -------------------------------
-- *
-- * Test Case #402 
---------- 4020 ns -----------

clk <= '1'; --	 Cycle No: 402

operation <= subtract;
op1_sign <= '1';
op1_exp <=  125 ;
op1_mant <= "10000000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1203 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1204 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1205 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #403 
---------- 4030 ns -----------

clk <= '1'; --	 Cycle No: 403

operation <= subtract;
op1_sign <= '1';
op1_exp <=  128 ;
op1_mant <= "01010000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1206 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1207 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1208 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #404
---------- 4040 ns -----------

clk <= '1'; --	 Cycle No: 404

operation <= subtract;
op1_sign <= '0';
op1_exp <=  126 ;
op1_mant <= "10100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1209 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1210 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1211 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #405
---------- 4050 ns -----------

clk <= '1'; --	 Cycle No: 405

operation <= subtract;
op1_sign <= '0';
op1_exp <=  129 ;
op1_mant <= "11100000000000000000000";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "01111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1212 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1213 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1214 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #406
---------- 4060 ns -----------

clk <= '1'; --	 Cycle No: 406

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '1';
op2_exp <=  125 ;
op2_mant <= "10000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1215 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1216 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1217 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #407
---------- 4070 ns -----------

clk <= '1'; --	 Cycle No: 407

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '1';
op2_exp <=  128 ;
op2_mant <= "01010000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1218 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1219 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1220 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #408
---------- 4080 ns -----------

clk <= '1'; --	 Cycle No: 408

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  126 ;
op2_mant <= "10100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1221 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1222 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1223 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #409
---------- 4090 ns -----------

clk <= '1'; --	 Cycle No: 409

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  129 ;
op2_mant <= "11100000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1224 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1225 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1226 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #410
---------- 4100 ns -----------

clk <= '1'; --	 Cycle No: 410

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1227 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1228 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1229 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #411
---------- 4110 ns -----------

clk <= '1'; --	 Cycle No: 411

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1230 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1231 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1232 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #412
---------- 4120 ns -----------

clk <= '1'; --	 Cycle No: 412

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '1';
op2_exp <=  0 ;
op2_mant <= "00000000000000000000001";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1233 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1234 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1235 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #413
---------- 4130 ns -----------

clk <= '1'; --	 Cycle No: 413

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1236 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1237 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1238 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #414
---------- 4140 ns -----------

clk <= '1'; --	 Cycle No: 414

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  254 ;
op2_mant <= "11111111111111111111111";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1239 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1240 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1241 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #415
---------- 4150 ns -----------

clk <= '1'; --	 Cycle No: 415

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1242 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1243 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1244 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #416
---------- 4160 ns -----------

clk <= '1'; --	 Cycle No: 416

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "01111111111111111111111";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "00000000000000000000000";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1245 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1246 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "01111111111111111111111") REPORT "Assert 1247 : < res_mant /= 01111111111111111111111 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;

-- * Test Case #417
---------- 4170 ns -----------

clk <= '1'; --	 Cycle No: 417

operation <= subtract;
op1_sign <= '0';
op1_exp <=  255 ;
op1_mant <= "11111111111111111111100";
op2_sign <= '0';
op2_exp <=  255 ;
op2_mant <= "11111111111111111111100";

wait for 5 ns;
ASSERT (res_sign = '0') REPORT "Assert 1248 : < res_sign /= 0 >"
	SEVERITY warning;
ASSERT (res_exp =  255 ) REPORT "Assert 1249 : < res_exp /= 255 >"
	SEVERITY warning;
ASSERT (res_mant = "11111111111111111111100") REPORT "Assert 1250 : < res_mant /= 11111111111111111111100 >"
	SEVERITY warning;
clk <= '0';
wait for 5 ns;


end process;
end test1;
