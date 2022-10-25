--------------------------------------------------------------------------------
--
--   Intel 8251 Benchmark -- Main -- test vectors
--
-- Source:  Intel Data Book
--
-- VHDL Benchmark author Indraneel Ghosh
--                       University Of California, Irvine, CA 92717
--
-- Developed on April 23, 92
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes   Champaka Ramachandran  Sept 18, 92    ZYCAD
--  Functionality     yes   Champaka Ramachandran  Sept 18, 92    ZYCAD
--------------------------------------------------------------------------------

use work.types.all;
use work.MVL7_functions.all;	--some binary functions
use work.synthesis_types.all;	--hints for synthesis

entity E is
end;

architecture A of E is
	 component I_8251
	  port (
	CLK 	 	 : in clock;
	RESET 	 	 : in MVL7;
	CS_BAR 	 	 : in MVL7;
	C_D_BAR  	 : in MVL7;
	RD_BAR 	 	 : in MVL7;
	WR_BAR 	 	 : in MVL7;
	DSR_BAR   	 : in MVL7;
	CTS_BAR   	 : in MVL7;
       Rx_buffer   	 : in MVL7_VECTOR(7 downto 0);
	D_0	 	 : inout MVL7;
	D_1	 	 : inout MVL7;
	D_2	 	 : inout MVL7;
	D_3	  	 : inout MVL7;
	D_4	 	 : inout MVL7;
	D_5	 	 : inout MVL7;
	D_6	  	 : inout MVL7;
	D_7	 	 : inout MVL7;
	SYNDET_BD 	 : inout MVL7;
	RxRDY     	 : out MVL7;
	DTR_BAR   	 : out MVL7;
	RTS_BAR   	 : out MVL7;
       Tx_wr_while_cts  : out MVL7;
       mode	    	 : out MVL7_VECTOR(7 downto 0);
       command	         : out MVL7_VECTOR(7 downto 0);
       SYNC1	    	 : out MVL7_VECTOR(7 downto 0);
       SYNC2	    	 : out MVL7_VECTOR(7 downto 0);
       SYNC_mask	 : out MVL7_VECTOR(7 downto 0);
       Tx_buffer   	 : out MVL7_VECTOR(7 downto 0);
       status   	 : out MVL7_VECTOR(7 downto 0);
       baud_clocks	 : out MVL7_VECTOR(7 downto 0);
       stop_clocks	 : out MVL7_VECTOR(7 downto 0);
       brk_clocks	 : out MVL7_VECTOR(10 downto 0);
       chars            : out MVL7_VECTOR(3 downto 0)
	  );
	 end component;

signal	CLK 	 	 : clock;
signal	RESET 	 	 : MVL7;
signal	CS_BAR 	 	 : MVL7;
signal	C_D_BAR  	 : MVL7;
signal	RD_BAR 	 	 : MVL7;
signal	WR_BAR 	 	 : MVL7;
signal	DSR_BAR   	 : MVL7;
signal	CTS_BAR   	 : MVL7;
signal Rx_buffer        : MVL7_VECTOR(7 downto 0);
signal	D_0	 	 : WiredOne MVL7;
signal	D_1	 	 : WiredOne MVL7;
signal	D_2	 	 : WiredOne MVL7;
signal	D_3	  	 : WiredOne MVL7;
signal	D_4	 	 : WiredOne MVL7;
signal	D_5	 	 : WiredOne MVL7;
signal	D_6	  	 : WiredOne MVL7;
signal	D_7	 	 : WiredOne MVL7;
signal	SYNDET_BD 	 : WiredOne MVL7;
signal	RxRDY     	 : MVL7;
signal	DTR_BAR   	 : MVL7;
signal	RTS_BAR   	 : MVL7;
signal Tx_wr_while_cts  : MVL7;
signal mode	    	 : MVL7_VECTOR(7 downto 0);
signal command	         : MVL7_VECTOR(7 downto 0);
signal SYNC1	    	 : MVL7_VECTOR(7 downto 0);
signal SYNC2	    	 : MVL7_VECTOR(7 downto 0);
signal SYNC_mask	 : MVL7_VECTOR(7 downto 0);
signal Tx_buffer   	 : MVL7_VECTOR(7 downto 0);
signal status  	 : MVL7_VECTOR(7 downto 0);
signal baud_clocks	 : MVL7_VECTOR(7 downto 0);
signal stop_clocks	 : MVL7_VECTOR(7 downto 0);
signal brk_clocks	 : MVL7_VECTOR(10 downto 0);
signal chars            : MVL7_VECTOR(3 downto 0);

for all : I_8251 use entity work.Intel_8251(USART);

begin

I1 : I_8251 port map(
	CLK		,
	RESET		,
	CS_BAR		,
	C_D_BAR	        ,
	RD_BAR		,
	WR_BAR		,
	DSR_BAR	        ,
	CTS_BAR        	,
       Rx_buffer       ,
	D_0		,
	D_1		,
	D_2		,
	D_3		,
	D_4		,
	D_5		,
	D_6		,
	D_7		,
	SYNDET_BD	,
	RxRDY    	,
	DTR_BAR 	,
	RTS_BAR 	,
       Tx_wr_while_cts ,
       mode		,
       command 	,
       SYNC1		,
       SYNC2		,
       SYNC_mask	,
       Tx_buffer	,
       status  	,
       baud_clocks	,
       stop_clocks	,
       brk_clocks	,
       chars            
           );

process

begin

-- *R:CS:CD:RD:WR:CTS:DSR:Rxbuffer:D7:D6:D5:D4:D3:D2:D1:D0:SY:D7:D6:D5:D4:D3:D2:D1:D0:SY:RxR:mode    :baudclks:stopclks:          brek_clocks:char:SYNCmask:SYNC1   :SYNC2   :command :Txbuffer:TxCTS:status  :DTR:RTS:
-- *#############*
-- *             *
-- * SYNC MODE   *
-- *	      *
-- *#############*
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Double sync  *
-- *	      5 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 0

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 0 : < command /= 00000000 >" -- 	Vector No: 0
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 2 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 3 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 4 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (00000000) 
--------------------------

clk <= '0'; --	 Cycle No: 1

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "00000000")
report
"Assert 5 : < mode /= 00000000 >" -- 	Vector No: 1
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 6 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 7 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 8 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (11100)
--------------------------

clk <= '0'; --	 Cycle No: 2

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "00011111")
report
"Assert 9 : < SYNC_mask /= 00011111 >" -- 	Vector No: 2
severity warning;

assert (SYNC1 = "00011100")
report
"Assert 10 : < SYNC1 /= 00011100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC2 (00011)
--------------------------

clk <= '0'; --	 Cycle No: 3

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC2 = "00000011")
report
"Assert 11 : < SYNC2 /= 00000011 >" -- 	Vector No: 3
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 4

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 12 : < command /= 10111111 >" -- 	Vector No: 4
severity warning;

assert (DTR_BAR = '0')
report
"Assert 13 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 14 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (11111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 5

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00011111")
report
"Assert 15 : < Tx_buffer /= 00011111 >" -- 	Vector No: 5
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 16 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 17 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (00000000) -- CHECK COMPLIMENT VALUE OF "COMMAND"
--------------------------

clk <= '0'; --	 Cycle No: 6

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 18 : < command /= 00000000 >" -- 	Vector No: 6
severity warning;

assert (DTR_BAR = '1')
report
"Assert 19 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 20 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (01000000) -- INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 7

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (DTR_BAR = '1')
report
"Assert 21 : < DTR_BAR /= 1 >" -- 	Vector No: 7
severity warning;

assert (RTS_BAR = '1')
report
"Assert 22 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** CHECK INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 8

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 23 : < command /= 00000000 >" -- 	Vector No: 8
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 24 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 25 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 26 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 27 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Double sync  *
-- *	      5 characters *
-- *			   *
-- ****************************
-- ** COMPLEMENTED SYNC CHAR, DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 9

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 28 : < command /= 00000000 >" -- 	Vector No: 9
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 29 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 30 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 31 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 32 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (00110000) 
--------------------------

clk <= '0'; --	 Cycle No: 10

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "00110000")
report
"Assert 33 : < mode /= 00110000 >" -- 	Vector No: 10
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 34 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 35 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 36 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (00011)
--------------------------

clk <= '0'; --	 Cycle No: 11

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "00011111")
report
"Assert 37 : < SYNC_mask /= 00011111 >" -- 	Vector No: 11
severity warning;

assert (SYNC1 = "00000011")
report
"Assert 38 : < SYNC1 /= 00000011 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC2 (11100)
--------------------------

clk <= '0'; --	 Cycle No: 12

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC2 = "00011100")
report
"Assert 39 : < SYNC2 /= 00011100 >" -- 	Vector No: 12
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 13

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 40 : < command /= 10111111 >" -- 	Vector No: 13
severity warning;

assert (DTR_BAR = '0')
report
"Assert 41 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 42 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 14

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 43 : < Tx_buffer /= 00000000 >" -- 	Vector No: 14
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 44 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 45 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Single sync  *
-- *	      5 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 15

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 46 : < command /= 00000000 >" -- 	Vector No: 15
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 47 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 48 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 49 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 50 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10000000) 
--------------------------

clk <= '0'; --	 Cycle No: 16

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10000000")
report
"Assert 51 : < mode /= 10000000 >" -- 	Vector No: 16
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 52 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 53 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 54 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (11100)
--------------------------

clk <= '0'; --	 Cycle No: 17

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "00011111")
report
"Assert 55 : < SYNC_mask /= 00011111 >" -- 	Vector No: 17
severity warning;

assert (SYNC1 = "00011100")
report
"Assert 56 : < SYNC1 /= 00011100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 18

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 57 : < command /= 10111111 >" -- 	Vector No: 18
severity warning;

assert (DTR_BAR = '0')
report
"Assert 58 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 59 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 19

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 60 : < Tx_buffer /= 00000000 >" -- 	Vector No: 19
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 61 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 62 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Single sync  *
-- *	      5 characters *
-- *			   *
-- ****************************
-- ** COMPLEMENTED SYNC CHAR, DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 20

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 63 : < command /= 00000000 >" -- 	Vector No: 20
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 64 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 65 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 66 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 67 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10110000) 
--------------------------

clk <= '0'; --	 Cycle No: 21

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10110000")
report
"Assert 68 : < mode /= 10110000 >" -- 	Vector No: 21
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 69 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 70 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 71 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (00011)
--------------------------

clk <= '0'; --	 Cycle No: 22

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "00011111")
report
"Assert 72 : < SYNC_mask /= 00011111 >" -- 	Vector No: 22
severity warning;

assert (SYNC1 = "00000011")
report
"Assert 73 : < SYNC1 /= 00000011 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 23

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 74 : < command /= 10111111 >" -- 	Vector No: 23
severity warning;

assert (DTR_BAR = '0')
report
"Assert 75 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 76 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (11111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 24

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00011111")
report
"Assert 77 : < Tx_buffer /= 00011111 >" -- 	Vector No: 24
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 78 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 79 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Double sync  *
-- *	      6 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 25

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 80 : < command /= 00000000 >" -- 	Vector No: 25
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 81 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 82 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 83 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 84 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (00000100) 
--------------------------

clk <= '0'; --	 Cycle No: 26

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "00000100")
report
"Assert 85 : < mode /= 00000100 >" -- 	Vector No: 26
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 86 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 87 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 88 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (111100)
--------------------------

clk <= '0'; --	 Cycle No: 27

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "00111111")
report
"Assert 89 : < SYNC_mask /= 00111111 >" -- 	Vector No: 27
severity warning;

assert (SYNC1 = "00111100")
report
"Assert 90 : < SYNC1 /= 00111100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC2 (000011)
--------------------------

clk <= '0'; --	 Cycle No: 28

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC2 = "00000011")
report
"Assert 91 : < SYNC2 /= 00000011 >" -- 	Vector No: 28
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 29

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 92 : < command /= 10111111 >" -- 	Vector No: 29
severity warning;

assert (DTR_BAR = '0')
report
"Assert 93 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 94 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (111111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 30

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00111111")
report
"Assert 95 : < Tx_buffer /= 00111111 >" -- 	Vector No: 30
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 96 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 97 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (00000000) -- CHECK COMPLIMENT VALUE OF "COMMAND"
--------------------------

clk <= '0'; --	 Cycle No: 31

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 98 : < command /= 00000000 >" -- 	Vector No: 31
severity warning;

assert (DTR_BAR = '1')
report
"Assert 99 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 100 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (01000000) -- INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 32

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (DTR_BAR = '1')
report
"Assert 101 : < DTR_BAR /= 1 >" -- 	Vector No: 32
severity warning;

assert (RTS_BAR = '1')
report
"Assert 102 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** CHECK INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 33

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 103 : < command /= 00000000 >" -- 	Vector No: 33
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 104 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 105 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 106 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 107 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Double sync  *
-- *	      6 characters *
-- *			   *
-- ****************************
-- ** COMPLEMENTED SYNC CHAR, DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 34

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 108 : < command /= 00000000 >" -- 	Vector No: 34
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 109 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 110 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 111 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 112 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (00110100) 
--------------------------

clk <= '0'; --	 Cycle No: 35

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '0';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "00110100")
report
"Assert 113 : < mode /= 00110100 >" -- 	Vector No: 35
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 114 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 115 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 116 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (000011)
--------------------------

clk <= '0'; --	 Cycle No: 36

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "00111111")
report
"Assert 117 : < SYNC_mask /= 00111111 >" -- 	Vector No: 36
severity warning;

assert (SYNC1 = "00000011")
report
"Assert 118 : < SYNC1 /= 00000011 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC2 (111100)
--------------------------

clk <= '0'; --	 Cycle No: 37

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC2 = "00111100")
report
"Assert 119 : < SYNC2 /= 00111100 >" -- 	Vector No: 37
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 38

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 120 : < command /= 10111111 >" -- 	Vector No: 38
severity warning;

assert (DTR_BAR = '0')
report
"Assert 121 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 122 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 39

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 123 : < Tx_buffer /= 00000000 >" -- 	Vector No: 39
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 124 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 125 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Single sync  *
-- *	      6 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 40

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 126 : < command /= 00000000 >" -- 	Vector No: 40
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 127 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 128 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 129 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 130 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10000100) 
--------------------------

clk <= '0'; --	 Cycle No: 41

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10000100")
report
"Assert 131 : < mode /= 10000100 >" -- 	Vector No: 41
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 132 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 133 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 134 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (111100)
--------------------------

clk <= '0'; --	 Cycle No: 42

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "00111111")
report
"Assert 135 : < SYNC_mask /= 00111111 >" -- 	Vector No: 42
severity warning;

assert (SYNC1 = "00111100")
report
"Assert 136 : < SYNC1 /= 00111100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 43

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 137 : < command /= 10111111 >" -- 	Vector No: 43
severity warning;

assert (DTR_BAR = '0')
report
"Assert 138 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 139 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 44

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 140 : < Tx_buffer /= 00000000 >" -- 	Vector No: 44
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 141 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 142 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Single sync  *
-- *	      6 characters *
-- *			   *
-- ****************************
-- ** COMPLEMENTED SYNC CHAR, DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 45

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 143 : < command /= 00000000 >" -- 	Vector No: 45
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 144 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 145 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 146 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 147 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10110100) 
--------------------------

clk <= '0'; --	 Cycle No: 46

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '0';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10110100")
report
"Assert 148 : < mode /= 10110100 >" -- 	Vector No: 46
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 149 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 150 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 151 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (000011)
--------------------------

clk <= '0'; --	 Cycle No: 47

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "00111111")
report
"Assert 152 : < SYNC_mask /= 00111111 >" -- 	Vector No: 47
severity warning;

assert (SYNC1 = "00000011")
report
"Assert 153 : < SYNC1 /= 00000011 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 48

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 154 : < command /= 10111111 >" -- 	Vector No: 48
severity warning;

assert (DTR_BAR = '0')
report
"Assert 155 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 156 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (111111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 49

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00111111")
report
"Assert 157 : < Tx_buffer /= 00111111 >" -- 	Vector No: 49
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 158 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 159 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Double sync  *
-- *	      7 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 50

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 160 : < command /= 00000000 >" -- 	Vector No: 50
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 161 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 162 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 163 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 164 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (00001000) 
--------------------------

clk <= '0'; --	 Cycle No: 51

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "00001000")
report
"Assert 165 : < mode /= 00001000 >" -- 	Vector No: 51
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 166 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 167 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 168 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (1111100)
--------------------------

clk <= '0'; --	 Cycle No: 52

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "01111111")
report
"Assert 169 : < SYNC_mask /= 01111111 >" -- 	Vector No: 52
severity warning;

assert (SYNC1 = "01111100")
report
"Assert 170 : < SYNC1 /= 01111100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC2 (0000011)
--------------------------

clk <= '0'; --	 Cycle No: 53

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC2 = "00000011")
report
"Assert 171 : < SYNC2 /= 00000011 >" -- 	Vector No: 53
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 54

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 172 : < command /= 10111111 >" -- 	Vector No: 54
severity warning;

assert (DTR_BAR = '0')
report
"Assert 173 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 174 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (1111111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 55

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "01111111")
report
"Assert 175 : < Tx_buffer /= 01111111 >" -- 	Vector No: 55
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 176 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 177 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (00000000) -- CHECK COMPLIMENT VALUE OF "COMMAND"
--------------------------

clk <= '0'; --	 Cycle No: 56

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 178 : < command /= 00000000 >" -- 	Vector No: 56
severity warning;

assert (DTR_BAR = '1')
report
"Assert 179 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 180 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (01000000) -- INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 57

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (DTR_BAR = '1')
report
"Assert 181 : < DTR_BAR /= 1 >" -- 	Vector No: 57
severity warning;

assert (RTS_BAR = '1')
report
"Assert 182 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** CHECK INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 58

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 183 : < command /= 00000000 >" -- 	Vector No: 58
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 184 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 185 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 186 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 187 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Double sync  *
-- *	      7 characters *
-- *			   *
-- ****************************
-- ** COMPLEMENTED SYNC CHAR, DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 59

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 188 : < command /= 00000000 >" -- 	Vector No: 59
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 189 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 190 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 191 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 192 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (00111000) 
--------------------------

clk <= '0'; --	 Cycle No: 60

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "00111000")
report
"Assert 193 : < mode /= 00111000 >" -- 	Vector No: 60
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 194 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 195 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 196 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (0000011)
--------------------------

clk <= '0'; --	 Cycle No: 61

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "01111111")
report
"Assert 197 : < SYNC_mask /= 01111111 >" -- 	Vector No: 61
severity warning;

assert (SYNC1 = "00000011")
report
"Assert 198 : < SYNC1 /= 00000011 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC2 (1111100)
--------------------------

clk <= '0'; --	 Cycle No: 62

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC2 = "01111100")
report
"Assert 199 : < SYNC2 /= 01111100 >" -- 	Vector No: 62
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 63

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 200 : < command /= 10111111 >" -- 	Vector No: 63
severity warning;

assert (DTR_BAR = '0')
report
"Assert 201 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 202 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 64

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 203 : < Tx_buffer /= 00000000 >" -- 	Vector No: 64
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 204 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 205 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Single sync  *
-- *	      7 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 65

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 206 : < command /= 00000000 >" -- 	Vector No: 65
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 207 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 208 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 209 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 210 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10001000) 
--------------------------

clk <= '0'; --	 Cycle No: 66

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10001000")
report
"Assert 211 : < mode /= 10001000 >" -- 	Vector No: 66
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 212 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 213 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 214 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (1111100)
--------------------------

clk <= '0'; --	 Cycle No: 67

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "01111111")
report
"Assert 215 : < SYNC_mask /= 01111111 >" -- 	Vector No: 67
severity warning;

assert (SYNC1 = "01111100")
report
"Assert 216 : < SYNC1 /= 01111100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 68

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 217 : < command /= 10111111 >" -- 	Vector No: 68
severity warning;

assert (DTR_BAR = '0')
report
"Assert 218 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 219 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 69

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 220 : < Tx_buffer /= 00000000 >" -- 	Vector No: 69
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 221 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 222 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Single sync  *
-- *	      7 characters *
-- *			   *
-- ****************************
-- ** COMPLEMENTED SYNC CHAR, DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 70

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 223 : < command /= 00000000 >" -- 	Vector No: 70
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 224 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 225 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 226 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 227 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10111000) 
--------------------------

clk <= '0'; --	 Cycle No: 71

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10111000")
report
"Assert 228 : < mode /= 10111000 >" -- 	Vector No: 71
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 229 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 230 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 231 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (0000011)
--------------------------

clk <= '0'; --	 Cycle No: 72

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "01111111")
report
"Assert 232 : < SYNC_mask /= 01111111 >" -- 	Vector No: 72
severity warning;

assert (SYNC1 = "00000011")
report
"Assert 233 : < SYNC1 /= 00000011 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 73

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 234 : < command /= 10111111 >" -- 	Vector No: 73
severity warning;

assert (DTR_BAR = '0')
report
"Assert 235 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 236 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (1111111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 74

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "01111111")
report
"Assert 237 : < Tx_buffer /= 01111111 >" -- 	Vector No: 74
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 238 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 239 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Double sync  *
-- *	      8 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 75

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 240 : < command /= 00000000 >" -- 	Vector No: 75
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 241 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 242 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 243 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 244 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (00001100) 
--------------------------

clk <= '0'; --	 Cycle No: 76

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "00001100")
report
"Assert 245 : < mode /= 00001100 >" -- 	Vector No: 76
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 246 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 247 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 248 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (11111100)
--------------------------

clk <= '0'; --	 Cycle No: 77

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "11111111")
report
"Assert 249 : < SYNC_mask /= 11111111 >" -- 	Vector No: 77
severity warning;

assert (SYNC1 = "11111100")
report
"Assert 250 : < SYNC1 /= 11111100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC2 (00000011)
--------------------------

clk <= '0'; --	 Cycle No: 78

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC2 = "00000011")
report
"Assert 251 : < SYNC2 /= 00000011 >" -- 	Vector No: 78
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 79

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 252 : < command /= 10111111 >" -- 	Vector No: 79
severity warning;

assert (DTR_BAR = '0')
report
"Assert 253 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 254 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (11111111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 80

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "11111111")
report
"Assert 255 : < Tx_buffer /= 11111111 >" -- 	Vector No: 80
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 256 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 257 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (00000000) -- CHECK COMPLIMENT VALUE OF "COMMAND"
--------------------------

clk <= '0'; --	 Cycle No: 81

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 258 : < command /= 00000000 >" -- 	Vector No: 81
severity warning;

assert (DTR_BAR = '1')
report
"Assert 259 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 260 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (01000000) -- INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 82

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (DTR_BAR = '1')
report
"Assert 261 : < DTR_BAR /= 1 >" -- 	Vector No: 82
severity warning;

assert (RTS_BAR = '1')
report
"Assert 262 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** CHECK INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 83

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 263 : < command /= 00000000 >" -- 	Vector No: 83
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 264 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 265 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 266 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 267 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Double sync  *
-- *	      8 characters *
-- *			   *
-- ****************************
-- ** COMPLEMENTED SYNC CHAR, DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 84

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 268 : < command /= 00000000 >" -- 	Vector No: 84
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 269 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 270 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 271 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 272 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (00111100) 
--------------------------

clk <= '0'; --	 Cycle No: 85

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "00111100")
report
"Assert 273 : < mode /= 00111100 >" -- 	Vector No: 85
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 274 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 275 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 276 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (00000011)
--------------------------

clk <= '0'; --	 Cycle No: 86

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "11111111")
report
"Assert 277 : < SYNC_mask /= 11111111 >" -- 	Vector No: 86
severity warning;

assert (SYNC1 = "00000011")
report
"Assert 278 : < SYNC1 /= 00000011 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC2 (11111100)
--------------------------

clk <= '0'; --	 Cycle No: 87

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC2 = "11111100")
report
"Assert 279 : < SYNC2 /= 11111100 >" -- 	Vector No: 87
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 88

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 280 : < command /= 10111111 >" -- 	Vector No: 88
severity warning;

assert (DTR_BAR = '0')
report
"Assert 281 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 282 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 89

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 283 : < Tx_buffer /= 00000000 >" -- 	Vector No: 89
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 284 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 285 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Single sync  *
-- *	      8 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 90

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 286 : < command /= 00000000 >" -- 	Vector No: 90
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 287 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 288 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 289 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 290 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10001100) 
--------------------------

clk <= '0'; --	 Cycle No: 91

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10001100")
report
"Assert 291 : < mode /= 10001100 >" -- 	Vector No: 91
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 292 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 293 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 294 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (11111100)
--------------------------

clk <= '0'; --	 Cycle No: 92

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "11111111")
report
"Assert 295 : < SYNC_mask /= 11111111 >" -- 	Vector No: 92
severity warning;

assert (SYNC1 = "11111100")
report
"Assert 296 : < SYNC1 /= 11111100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 93

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 297 : < command /= 10111111 >" -- 	Vector No: 93
severity warning;

assert (DTR_BAR = '0')
report
"Assert 298 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 299 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 94

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 300 : < Tx_buffer /= 00000000 >" -- 	Vector No: 94
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 301 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 302 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Sync mode : Int sync     *
-- * 	      Single sync  *
-- *	      8 characters *
-- *			   *
-- ****************************
-- ** COMPLEMENTED SYNC CHAR, DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 95

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 303 : < command /= 00000000 >" -- 	Vector No: 95
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 304 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 305 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 306 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 307 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10111100) 
--------------------------

clk <= '0'; --	 Cycle No: 96

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10111100")
report
"Assert 308 : < mode /= 10111100 >" -- 	Vector No: 96
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 309 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000000")
report
"Assert 310 : < stop_clocks /= 00000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 311 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE SYNC1 (00000011)
--------------------------

clk <= '0'; --	 Cycle No: 97

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (SYNC_mask = "11111111")
report
"Assert 312 : < SYNC_mask /= 11111111 >" -- 	Vector No: 97
severity warning;

assert (SYNC1 = "00000011")
report
"Assert 313 : < SYNC1 /= 00000011 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 98

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 314 : < command /= 10111111 >" -- 	Vector No: 98
severity warning;

assert (DTR_BAR = '0')
report
"Assert 315 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 316 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (11111111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 99

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "11111111")
report
"Assert 317 : < Tx_buffer /= 11111111 >" -- 	Vector No: 99
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 318 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 319 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *#############*
-- *             *
-- * ASYNC MODE  *
-- *	      *
-- *#############*
-- ****************************
-- *			   *
-- * Async mode : 1 stop bit  *
-- *             baud rate 1X *
-- *             even parity  *
-- *	      5 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 100

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 320 : < command /= 00000000 >" -- 	Vector No: 100
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 321 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 322 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 323 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 324 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0110001) 
--------------------------

clk <= '0'; --	 Cycle No: 101

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01110001")
report
"Assert 325 : < mode /= 01110001 >" -- 	Vector No: 101
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 326 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 327 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010000")
report
"Assert 328 : < brk_clocks /= 00000010000 >"
severity warning;

assert (chars = "0101")
report
"Assert 329 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 102

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 330 : < command /= 10111111 >" -- 	Vector No: 102
severity warning;

assert (DTR_BAR = '0')
report
"Assert 331 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 332 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (11111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 103

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00011111")
report
"Assert 333 : < Tx_buffer /= 00011111 >" -- 	Vector No: 103
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 334 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 335 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (00000000) -- CHECK COMPLIMENT VALUE OF "COMMAND"
--------------------------

clk <= '0'; --	 Cycle No: 104

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 336 : < command /= 00000000 >" -- 	Vector No: 104
severity warning;

assert (DTR_BAR = '1')
report
"Assert 337 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 338 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (01000000) -- INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 105

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (DTR_BAR = '1')
report
"Assert 339 : < DTR_BAR /= 1 >" -- 	Vector No: 105
severity warning;

assert (RTS_BAR = '1')
report
"Assert 340 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** CHECK INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 106

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 341 : < command /= 00000000 >" -- 	Vector No: 106
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 342 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 343 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 344 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 345 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *******************************
-- *			      *
-- * Async mode : 1.5 stop bits  *
-- *              baud rate 1X   *
-- *              odd parity     *
-- *	       5 characters   *
-- *			      *
-- *******************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 107

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 346 : < command /= 00000000 >" -- 	Vector No: 107
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 347 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 348 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 349 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 350 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10010001) 
--------------------------

clk <= '0'; --	 Cycle No: 108

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10010001")
report
"Assert 351 : < mode /= 10010001 >" -- 	Vector No: 108
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 352 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 353 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010000")
report
"Assert 354 : < brk_clocks /= 00000010000 >"
severity warning;

assert (chars = "0101")
report
"Assert 355 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 109

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 356 : < command /= 10111111 >" -- 	Vector No: 109
severity warning;

assert (DTR_BAR = '0')
report
"Assert 357 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 358 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 110

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 359 : < Tx_buffer /= 00000000 >" -- 	Vector No: 110
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 360 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 361 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 2 stop bits  *
-- *	       baud rate 1X *
-- *              odd parity   *
-- *	       5 characters *
-- *		 	    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 111

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 362 : < command /= 00000000 >" -- 	Vector No: 111
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 363 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 364 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 365 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 366 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11010001) 
--------------------------

clk <= '0'; --	 Cycle No: 112

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11010001")
report
"Assert 367 : < mode /= 11010001 >" -- 	Vector No: 112
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 368 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000010")
report
"Assert 369 : < stop_clocks /= 00000010 >"
severity warning;

assert (brk_clocks = "00000010010")
report
"Assert 370 : < brk_clocks /= 00000010010 >"
severity warning;

assert (chars = "0101")
report
"Assert 371 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 113

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 372 : < command /= 10111111 >" -- 	Vector No: 113
severity warning;

assert (DTR_BAR = '0')
report
"Assert 373 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 374 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 114

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 375 : < Tx_buffer /= 00000000 >" -- 	Vector No: 114
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 376 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 377 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Async mode : 1 stop bit  *
-- *             baud rate 1X *
-- *              no parity   *
-- *	      5 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 115

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 378 : < command /= 00000000 >" -- 	Vector No: 115
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 379 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 380 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 381 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 382 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0100001) 
--------------------------

clk <= '0'; --	 Cycle No: 116

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01000001")
report
"Assert 383 : < mode /= 01000001 >" -- 	Vector No: 116
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 384 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 385 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000001110")
report
"Assert 386 : < brk_clocks /= 00000001110 >"
severity warning;

assert (chars = "0101")
report
"Assert 387 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 117

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 388 : < command /= 10111111 >" -- 	Vector No: 117
severity warning;

assert (DTR_BAR = '0')
report
"Assert 389 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 390 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 118

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 391 : < Tx_buffer /= 00000000 >" -- 	Vector No: 118
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 392 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 393 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *******************************
-- *			      *
-- * Async mode : 1.5 stop bits  *
-- *              baud rate 1X   *
-- *               no parity     *
-- *	       5 characters   *
-- *			      *
-- *******************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 119

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 394 : < command /= 00000000 >" -- 	Vector No: 119
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 395 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 396 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 397 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 398 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10000001) 
--------------------------

clk <= '0'; --	 Cycle No: 120

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10000001")
report
"Assert 399 : < mode /= 10000001 >" -- 	Vector No: 120
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 400 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 401 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000001110")
report
"Assert 402 : < brk_clocks /= 00000001110 >"
severity warning;

assert (chars = "0101")
report
"Assert 403 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 121

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 404 : < command /= 10111111 >" -- 	Vector No: 121
severity warning;

assert (DTR_BAR = '0')
report
"Assert 405 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 406 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 122

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 407 : < Tx_buffer /= 00000000 >" -- 	Vector No: 122
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 408 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 409 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 2 stop bits  *
-- *	       baud rate 1X *
-- *               no parity   *
-- *	       5 characters *
-- *		 	    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 123

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 410 : < command /= 00000000 >" -- 	Vector No: 123
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 411 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 412 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 413 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 414 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11000001) 
--------------------------

clk <= '0'; --	 Cycle No: 124

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11000001")
report
"Assert 415 : < mode /= 11000001 >" -- 	Vector No: 124
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 416 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000010")
report
"Assert 417 : < stop_clocks /= 00000010 >"
severity warning;

assert (brk_clocks = "00000010000")
report
"Assert 418 : < brk_clocks /= 00000010000 >"
severity warning;

assert (chars = "0101")
report
"Assert 419 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 125

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 420 : < command /= 10111111 >" -- 	Vector No: 125
severity warning;

assert (DTR_BAR = '0')
report
"Assert 421 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 422 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 126

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 423 : < Tx_buffer /= 00000000 >" -- 	Vector No: 126
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 424 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 425 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 16X *
-- *             even parity   *
-- *	      5 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 127

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 426 : < command /= 00000000 >" -- 	Vector No: 127
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 427 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 428 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 429 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 430 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0110010) 
--------------------------

clk <= '0'; --	 Cycle No: 128

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01110010")
report
"Assert 431 : < mode /= 01110010 >" -- 	Vector No: 128
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 432 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00010000")
report
"Assert 433 : < stop_clocks /= 00010000 >"
severity warning;

assert (brk_clocks = "00100000000")
report
"Assert 434 : < brk_clocks /= 00100000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 435 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 129

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 436 : < command /= 10111111 >" -- 	Vector No: 129
severity warning;

assert (DTR_BAR = '0')
report
"Assert 437 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 438 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 130

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 439 : < Tx_buffer /= 00000000 >" -- 	Vector No: 130
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 440 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 441 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 16X   *
-- *              odd parity      *
-- *	       5 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 131

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 442 : < command /= 00000000 >" -- 	Vector No: 131
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 443 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 444 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 445 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 446 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10010010) 
--------------------------

clk <= '0'; --	 Cycle No: 132

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10010010")
report
"Assert 447 : < mode /= 10010010 >" -- 	Vector No: 132
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 448 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00011000")
report
"Assert 449 : < stop_clocks /= 00011000 >"
severity warning;

assert (brk_clocks = "00100010000")
report
"Assert 450 : < brk_clocks /= 00100010000 >"
severity warning;

assert (chars = "0101")
report
"Assert 451 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 133

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 452 : < command /= 10111111 >" -- 	Vector No: 133
severity warning;

assert (DTR_BAR = '0')
report
"Assert 453 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 454 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 134

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 455 : < Tx_buffer /= 00000000 >" -- 	Vector No: 134
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 456 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 457 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 16X *
-- *              odd parity    *
-- *	       5 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 135

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 458 : < command /= 00000000 >" -- 	Vector No: 135
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 459 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 460 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 461 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 462 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11010010) 
--------------------------

clk <= '0'; --	 Cycle No: 136

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11010010")
report
"Assert 463 : < mode /= 11010010 >" -- 	Vector No: 136
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 464 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00100000")
report
"Assert 465 : < stop_clocks /= 00100000 >"
severity warning;

assert (brk_clocks = "00100100000")
report
"Assert 466 : < brk_clocks /= 00100100000 >"
severity warning;

assert (chars = "0101")
report
"Assert 467 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 137

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 468 : < command /= 10111111 >" -- 	Vector No: 137
severity warning;

assert (DTR_BAR = '0')
report
"Assert 469 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 470 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 138

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 471 : < Tx_buffer /= 00000000 >" -- 	Vector No: 138
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 472 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 473 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 16X *
-- *              no parity    *
-- *	      5 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 139

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 474 : < command /= 00000000 >" -- 	Vector No: 139
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 475 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 476 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 477 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 478 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0100010) 
--------------------------

clk <= '0'; --	 Cycle No: 140

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01000010")
report
"Assert 479 : < mode /= 01000010 >" -- 	Vector No: 140
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 480 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00010000")
report
"Assert 481 : < stop_clocks /= 00010000 >"
severity warning;

assert (brk_clocks = "00011100000")
report
"Assert 482 : < brk_clocks /= 00011100000 >"
severity warning;

assert (chars = "0101")
report
"Assert 483 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 141

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 484 : < command /= 10111111 >" -- 	Vector No: 141
severity warning;

assert (DTR_BAR = '0')
report
"Assert 485 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 486 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 142

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 487 : < Tx_buffer /= 00000000 >" -- 	Vector No: 142
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 488 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 489 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 16X   *
-- *               no parity      *
-- *	       5 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 143

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 490 : < command /= 00000000 >" -- 	Vector No: 143
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 491 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 492 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 493 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 494 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10000010) 
--------------------------

clk <= '0'; --	 Cycle No: 144

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10000010")
report
"Assert 495 : < mode /= 10000010 >" -- 	Vector No: 144
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 496 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00011000")
report
"Assert 497 : < stop_clocks /= 00011000 >"
severity warning;

assert (brk_clocks = "00011110000")
report
"Assert 498 : < brk_clocks /= 00011110000 >"
severity warning;

assert (chars = "0101")
report
"Assert 499 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 145

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 500 : < command /= 10111111 >" -- 	Vector No: 145
severity warning;

assert (DTR_BAR = '0')
report
"Assert 501 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 502 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 146

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 503 : < Tx_buffer /= 00000000 >" -- 	Vector No: 146
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 504 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 505 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 16X *
-- *               no parity    *
-- *	       5 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 147

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 506 : < command /= 00000000 >" -- 	Vector No: 147
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 507 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 508 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 509 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 510 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11000010) 
--------------------------

clk <= '0'; --	 Cycle No: 148

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11000010")
report
"Assert 511 : < mode /= 11000010 >" -- 	Vector No: 148
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 512 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00100000")
report
"Assert 513 : < stop_clocks /= 00100000 >"
severity warning;

assert (brk_clocks = "00100000000")
report
"Assert 514 : < brk_clocks /= 00100000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 515 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 149

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 516 : < command /= 10111111 >" -- 	Vector No: 149
severity warning;

assert (DTR_BAR = '0')
report
"Assert 517 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 518 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 150

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 519 : < Tx_buffer /= 00000000 >" -- 	Vector No: 150
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 520 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 521 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 64X *
-- *             even parity   *
-- *	      5 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 151

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 522 : < command /= 00000000 >" -- 	Vector No: 151
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 523 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 524 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 525 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 526 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0110011) 
--------------------------

clk <= '0'; --	 Cycle No: 152

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01110011")
report
"Assert 527 : < mode /= 01110011 >" -- 	Vector No: 152
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 528 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01000000")
report
"Assert 529 : < stop_clocks /= 01000000 >"
severity warning;

assert (brk_clocks = "10000000000")
report
"Assert 530 : < brk_clocks /= 10000000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 531 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 153

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 532 : < command /= 10111111 >" -- 	Vector No: 153
severity warning;

assert (DTR_BAR = '0')
report
"Assert 533 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 534 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 154

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 535 : < Tx_buffer /= 00000000 >" -- 	Vector No: 154
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 536 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 537 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 64X   *
-- *              odd parity      *
-- *	       5 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 155

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 538 : < command /= 00000000 >" -- 	Vector No: 155
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 539 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 540 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 541 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 542 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10010011) 
--------------------------

clk <= '0'; --	 Cycle No: 156

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10010011")
report
"Assert 543 : < mode /= 10010011 >" -- 	Vector No: 156
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 544 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01100000")
report
"Assert 545 : < stop_clocks /= 01100000 >"
severity warning;

assert (brk_clocks = "10001000000")
report
"Assert 546 : < brk_clocks /= 10001000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 547 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 157

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 548 : < command /= 10111111 >" -- 	Vector No: 157
severity warning;

assert (DTR_BAR = '0')
report
"Assert 549 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 550 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 158

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 551 : < Tx_buffer /= 00000000 >" -- 	Vector No: 158
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 552 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 553 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 64X *
-- *              odd parity    *
-- *	       5 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 159

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 554 : < command /= 00000000 >" -- 	Vector No: 159
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 555 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 556 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 557 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 558 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11010011) 
--------------------------

clk <= '0'; --	 Cycle No: 160

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11010011")
report
"Assert 559 : < mode /= 11010011 >" -- 	Vector No: 160
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 560 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "10000000")
report
"Assert 561 : < stop_clocks /= 10000000 >"
severity warning;

assert (brk_clocks = "10010000000")
report
"Assert 562 : < brk_clocks /= 10010000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 563 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 161

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 564 : < command /= 10111111 >" -- 	Vector No: 161
severity warning;

assert (DTR_BAR = '0')
report
"Assert 565 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 566 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 162

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 567 : < Tx_buffer /= 00000000 >" -- 	Vector No: 162
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 568 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 569 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 64X *
-- *              no parity    *
-- *	      5 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 163

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 570 : < command /= 00000000 >" -- 	Vector No: 163
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 571 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 572 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 573 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 574 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0100011) 
--------------------------

clk <= '0'; --	 Cycle No: 164

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01000011")
report
"Assert 575 : < mode /= 01000011 >" -- 	Vector No: 164
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 576 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01000000")
report
"Assert 577 : < stop_clocks /= 01000000 >"
severity warning;

assert (brk_clocks = "01110000000")
report
"Assert 578 : < brk_clocks /= 01110000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 579 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 165

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 580 : < command /= 10111111 >" -- 	Vector No: 165
severity warning;

assert (DTR_BAR = '0')
report
"Assert 581 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 582 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 166

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 583 : < Tx_buffer /= 00000000 >" -- 	Vector No: 166
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 584 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 585 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 64X   *
-- *               no parity      *
-- *	       5 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 167

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 586 : < command /= 00000000 >" -- 	Vector No: 167
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 587 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 588 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 589 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 590 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10000011) 
--------------------------

clk <= '0'; --	 Cycle No: 168

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10000011")
report
"Assert 591 : < mode /= 10000011 >" -- 	Vector No: 168
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 592 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01100000")
report
"Assert 593 : < stop_clocks /= 01100000 >"
severity warning;

assert (brk_clocks = "01111000000")
report
"Assert 594 : < brk_clocks /= 01111000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 595 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 169

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 596 : < command /= 10111111 >" -- 	Vector No: 169
severity warning;

assert (DTR_BAR = '0')
report
"Assert 597 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 598 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 170

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 599 : < Tx_buffer /= 00000000 >" -- 	Vector No: 170
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 600 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 601 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 64X *
-- *               no parity    *
-- *	       5 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 171

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 602 : < command /= 00000000 >" -- 	Vector No: 171
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 603 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 604 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 605 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 606 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11000011) 
--------------------------

clk <= '0'; --	 Cycle No: 172

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11000011")
report
"Assert 607 : < mode /= 11000011 >" -- 	Vector No: 172
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 608 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "10000000")
report
"Assert 609 : < stop_clocks /= 10000000 >"
severity warning;

assert (brk_clocks = "10000000000")
report
"Assert 610 : < brk_clocks /= 10000000000 >"
severity warning;

assert (chars = "0101")
report
"Assert 611 : < chars /= 0101 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 173

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 612 : < command /= 10111111 >" -- 	Vector No: 173
severity warning;

assert (DTR_BAR = '0')
report
"Assert 613 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 614 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 174

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 615 : < Tx_buffer /= 00000000 >" -- 	Vector No: 174
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 616 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 617 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Async mode : 1 stop bit  *
-- *             baud rate 1X *
-- *             even parity  *
-- *	      6 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 175

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 618 : < command /= 00000000 >" -- 	Vector No: 175
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 619 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 620 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 621 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 622 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0110101) 
--------------------------

clk <= '0'; --	 Cycle No: 176

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '0';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01110101")
report
"Assert 623 : < mode /= 01110101 >" -- 	Vector No: 176
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 624 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 625 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010010")
report
"Assert 626 : < brk_clocks /= 00000010010 >"
severity warning;

assert (chars = "0110")
report
"Assert 627 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 177

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 628 : < command /= 10111111 >" -- 	Vector No: 177
severity warning;

assert (DTR_BAR = '0')
report
"Assert 629 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 630 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (111111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 178

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00111111")
report
"Assert 631 : < Tx_buffer /= 00111111 >" -- 	Vector No: 178
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 632 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 633 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (00000000) -- CHECK COMPLIMENT VALUE OF "COMMAND"
--------------------------

clk <= '0'; --	 Cycle No: 179

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 634 : < command /= 00000000 >" -- 	Vector No: 179
severity warning;

assert (DTR_BAR = '1')
report
"Assert 635 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 636 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (01000000) -- INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 180

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (DTR_BAR = '1')
report
"Assert 637 : < DTR_BAR /= 1 >" -- 	Vector No: 180
severity warning;

assert (RTS_BAR = '1')
report
"Assert 638 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** CHECK INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 181

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 639 : < command /= 00000000 >" -- 	Vector No: 181
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 640 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 641 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 642 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 643 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *******************************
-- *			      *
-- * Async mode : 1.5 stop bits  *
-- *              baud rate 1X   *
-- *              odd parity     *
-- *	       6 characters   *
-- *			      *
-- *******************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 182

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 644 : < command /= 00000000 >" -- 	Vector No: 182
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 645 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 646 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 647 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 648 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10010101) 
--------------------------

clk <= '0'; --	 Cycle No: 183

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10010101")
report
"Assert 649 : < mode /= 10010101 >" -- 	Vector No: 183
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 650 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 651 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010010")
report
"Assert 652 : < brk_clocks /= 00000010010 >"
severity warning;

assert (chars = "0110")
report
"Assert 653 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 184

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 654 : < command /= 10111111 >" -- 	Vector No: 184
severity warning;

assert (DTR_BAR = '0')
report
"Assert 655 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 656 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 185

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 657 : < Tx_buffer /= 00000000 >" -- 	Vector No: 185
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 658 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 659 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 2 stop bits  *
-- *	       baud rate 1X *
-- *              odd parity   *
-- *	       6 characters *
-- *		 	    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 186

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 660 : < command /= 00000000 >" -- 	Vector No: 186
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 661 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 662 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 663 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 664 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11010101) 
--------------------------

clk <= '0'; --	 Cycle No: 187

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11010101")
report
"Assert 665 : < mode /= 11010101 >" -- 	Vector No: 187
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 666 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000010")
report
"Assert 667 : < stop_clocks /= 00000010 >"
severity warning;

assert (brk_clocks = "00000010100")
report
"Assert 668 : < brk_clocks /= 00000010100 >"
severity warning;

assert (chars = "0110")
report
"Assert 669 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 188

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 670 : < command /= 10111111 >" -- 	Vector No: 188
severity warning;

assert (DTR_BAR = '0')
report
"Assert 671 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 672 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 189

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 673 : < Tx_buffer /= 00000000 >" -- 	Vector No: 189
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 674 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 675 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Async mode : 1 stop bit  *
-- *             baud rate 1X *
-- *              no parity   *
-- *	      6 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 190

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 676 : < command /= 00000000 >" -- 	Vector No: 190
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 677 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 678 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 679 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 680 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0100101) 
--------------------------

clk <= '0'; --	 Cycle No: 191

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01000101")
report
"Assert 681 : < mode /= 01000101 >" -- 	Vector No: 191
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 682 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 683 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010000")
report
"Assert 684 : < brk_clocks /= 00000010000 >"
severity warning;

assert (chars = "0110")
report
"Assert 685 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 192

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 686 : < command /= 10111111 >" -- 	Vector No: 192
severity warning;

assert (DTR_BAR = '0')
report
"Assert 687 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 688 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 193

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 689 : < Tx_buffer /= 00000000 >" -- 	Vector No: 193
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 690 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 691 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *******************************
-- *			      *
-- * Async mode : 1.5 stop bits  *
-- *              baud rate 1X   *
-- *               no parity     *
-- *	       6 characters   *
-- *			      *
-- *******************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 194

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 692 : < command /= 00000000 >" -- 	Vector No: 194
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 693 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 694 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 695 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 696 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10000101) 
--------------------------

clk <= '0'; --	 Cycle No: 195

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10000101")
report
"Assert 697 : < mode /= 10000101 >" -- 	Vector No: 195
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 698 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 699 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010000")
report
"Assert 700 : < brk_clocks /= 00000010000 >"
severity warning;

assert (chars = "0110")
report
"Assert 701 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 196

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 702 : < command /= 10111111 >" -- 	Vector No: 196
severity warning;

assert (DTR_BAR = '0')
report
"Assert 703 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 704 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 197

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 705 : < Tx_buffer /= 00000000 >" -- 	Vector No: 197
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 706 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 707 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 2 stop bits  *
-- *	       baud rate 1X *
-- *               no parity   *
-- *	       6 characters *
-- *		 	    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 198

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 708 : < command /= 00000000 >" -- 	Vector No: 198
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 709 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 710 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 711 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 712 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11000101) 
--------------------------

clk <= '0'; --	 Cycle No: 199

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11000101")
report
"Assert 713 : < mode /= 11000101 >" -- 	Vector No: 199
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 714 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000010")
report
"Assert 715 : < stop_clocks /= 00000010 >"
severity warning;

assert (brk_clocks = "00000010010")
report
"Assert 716 : < brk_clocks /= 00000010010 >"
severity warning;

assert (chars = "0110")
report
"Assert 717 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 200

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 718 : < command /= 10111111 >" -- 	Vector No: 200
severity warning;

assert (DTR_BAR = '0')
report
"Assert 719 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 720 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 201

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 721 : < Tx_buffer /= 00000000 >" -- 	Vector No: 201
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 722 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 723 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 16X *
-- *             even parity   *
-- *	      6 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 202

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 724 : < command /= 00000000 >" -- 	Vector No: 202
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 725 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 726 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 727 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 728 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (01110110) 
--------------------------

clk <= '0'; --	 Cycle No: 203

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01110110")
report
"Assert 729 : < mode /= 01110110 >" -- 	Vector No: 203
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 730 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00010000")
report
"Assert 731 : < stop_clocks /= 00010000 >"
severity warning;

assert (brk_clocks = "00100100000")
report
"Assert 732 : < brk_clocks /= 00100100000 >"
severity warning;

assert (chars = "0110")
report
"Assert 733 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 204

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 734 : < command /= 10111111 >" -- 	Vector No: 204
severity warning;

assert (DTR_BAR = '0')
report
"Assert 735 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 736 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 205

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 737 : < Tx_buffer /= 00000000 >" -- 	Vector No: 205
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 738 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 739 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 16X   *
-- *              odd parity      *
-- *	       6 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 206

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 740 : < command /= 00000000 >" -- 	Vector No: 206
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 741 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 742 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 743 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 744 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10010110) 
--------------------------

clk <= '0'; --	 Cycle No: 207

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10010110")
report
"Assert 745 : < mode /= 10010110 >" -- 	Vector No: 207
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 746 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00011000")
report
"Assert 747 : < stop_clocks /= 00011000 >"
severity warning;

assert (brk_clocks = "00100110000")
report
"Assert 748 : < brk_clocks /= 00100110000 >"
severity warning;

assert (chars = "0110")
report
"Assert 749 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 208

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 750 : < command /= 10111111 >" -- 	Vector No: 208
severity warning;

assert (DTR_BAR = '0')
report
"Assert 751 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 752 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 209

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 753 : < Tx_buffer /= 00000000 >" -- 	Vector No: 209
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 754 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 755 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 16X *
-- *              odd parity    *
-- *	       6 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 210

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 756 : < command /= 00000000 >" -- 	Vector No: 210
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 757 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 758 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 759 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 760 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11010110) 
--------------------------

clk <= '0'; --	 Cycle No: 211

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11010110")
report
"Assert 761 : < mode /= 11010110 >" -- 	Vector No: 211
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 762 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00100000")
report
"Assert 763 : < stop_clocks /= 00100000 >"
severity warning;

assert (brk_clocks = "00101000000")
report
"Assert 764 : < brk_clocks /= 00101000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 765 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 212

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 766 : < command /= 10111111 >" -- 	Vector No: 212
severity warning;

assert (DTR_BAR = '0')
report
"Assert 767 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 768 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 213

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 769 : < Tx_buffer /= 00000000 >" -- 	Vector No: 213
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 770 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 771 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 16X *
-- *              no parity    *
-- *	      6 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 214

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 772 : < command /= 00000000 >" -- 	Vector No: 214
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 773 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 774 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 775 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 776 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0100110) 
--------------------------

clk <= '0'; --	 Cycle No: 215

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01000110")
report
"Assert 777 : < mode /= 01000110 >" -- 	Vector No: 215
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 778 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00010000")
report
"Assert 779 : < stop_clocks /= 00010000 >"
severity warning;

assert (brk_clocks = "00100000000")
report
"Assert 780 : < brk_clocks /= 00100000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 781 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 216

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 782 : < command /= 10111111 >" -- 	Vector No: 216
severity warning;

assert (DTR_BAR = '0')
report
"Assert 783 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 784 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 217

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 785 : < Tx_buffer /= 00000000 >" -- 	Vector No: 217
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 786 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 787 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 16X   *
-- *               no parity      *
-- *	       6 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 218

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 788 : < command /= 00000000 >" -- 	Vector No: 218
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 789 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 790 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 791 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 792 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10000110) 
--------------------------

clk <= '0'; --	 Cycle No: 219

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10000110")
report
"Assert 793 : < mode /= 10000110 >" -- 	Vector No: 219
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 794 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00011000")
report
"Assert 795 : < stop_clocks /= 00011000 >"
severity warning;

assert (brk_clocks = "00100010000")
report
"Assert 796 : < brk_clocks /= 00100010000 >"
severity warning;

assert (chars = "0110")
report
"Assert 797 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 220

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 798 : < command /= 10111111 >" -- 	Vector No: 220
severity warning;

assert (DTR_BAR = '0')
report
"Assert 799 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 800 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 221

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 801 : < Tx_buffer /= 00000000 >" -- 	Vector No: 221
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 802 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 803 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 16X *
-- *               no parity    *
-- *	       6 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 222

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 804 : < command /= 00000000 >" -- 	Vector No: 222
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 805 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 806 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 807 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 808 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11000110)   
--------------------------

clk <= '0'; --	 Cycle No: 223

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11000110")
report
"Assert 809 : < mode /= 11000110 >" -- 	Vector No: 223
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 810 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00100000")
report
"Assert 811 : < stop_clocks /= 00100000 >"
severity warning;

assert (brk_clocks = "00100100000")
report
"Assert 812 : < brk_clocks /= 00100100000 >"
severity warning;

assert (chars = "0110")
report
"Assert 813 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 224

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 814 : < command /= 10111111 >" -- 	Vector No: 224
severity warning;

assert (DTR_BAR = '0')
report
"Assert 815 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 816 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 225

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 817 : < Tx_buffer /= 00000000 >" -- 	Vector No: 225
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 818 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 819 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 64X *
-- *             even parity   *
-- *	      6 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 226

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 820 : < command /= 00000000 >" -- 	Vector No: 226
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 821 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 822 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 823 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 824 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (01110111) 
--------------------------

clk <= '0'; --	 Cycle No: 227

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01110111")
report
"Assert 825 : < mode /= 01110111 >" -- 	Vector No: 227
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 826 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01000000")
report
"Assert 827 : < stop_clocks /= 01000000 >"
severity warning;

assert (brk_clocks = "10010000000")
report
"Assert 828 : < brk_clocks /= 10010000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 829 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 228

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 830 : < command /= 10111111 >" -- 	Vector No: 228
severity warning;

assert (DTR_BAR = '0')
report
"Assert 831 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 832 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 229

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 833 : < Tx_buffer /= 00000000 >" -- 	Vector No: 229
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 834 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 835 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 64X   *
-- *              odd parity      *
-- *	       6 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 230

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 836 : < command /= 00000000 >" -- 	Vector No: 230
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 837 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 838 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 839 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 840 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10010111) 
--------------------------

clk <= '0'; --	 Cycle No: 231

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10010111")
report
"Assert 841 : < mode /= 10010111 >" -- 	Vector No: 231
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 842 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01100000")
report
"Assert 843 : < stop_clocks /= 01100000 >"
severity warning;

assert (brk_clocks = "10011000000")
report
"Assert 844 : < brk_clocks /= 10011000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 845 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 232

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 846 : < command /= 10111111 >" -- 	Vector No: 232
severity warning;

assert (DTR_BAR = '0')
report
"Assert 847 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 848 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 233

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 849 : < Tx_buffer /= 00000000 >" -- 	Vector No: 233
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 850 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 851 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 64X *
-- *              odd parity    *
-- *	       6 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 234

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 852 : < command /= 00000000 >" -- 	Vector No: 234
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 853 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 854 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 855 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 856 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11010111) 
--------------------------

clk <= '0'; --	 Cycle No: 235

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11010111")
report
"Assert 857 : < mode /= 11010111 >" -- 	Vector No: 235
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 858 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "10000000")
report
"Assert 859 : < stop_clocks /= 10000000 >"
severity warning;

assert (brk_clocks = "10100000000")
report
"Assert 860 : < brk_clocks /= 10100000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 861 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 236

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 862 : < command /= 10111111 >" -- 	Vector No: 236
severity warning;

assert (DTR_BAR = '0')
report
"Assert 863 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 864 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 237

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 865 : < Tx_buffer /= 00000000 >" -- 	Vector No: 237
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 866 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 867 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 64X *
-- *              no parity    *
-- *	      6 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 238

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 868 : < command /= 00000000 >" -- 	Vector No: 238
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 869 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 870 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 871 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 872 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0100111) 
--------------------------

clk <= '0'; --	 Cycle No: 239

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01000111")
report
"Assert 873 : < mode /= 01000111 >" -- 	Vector No: 239
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 874 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01000000")
report
"Assert 875 : < stop_clocks /= 01000000 >"
severity warning;

assert (brk_clocks = "10000000000")
report
"Assert 876 : < brk_clocks /= 10000000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 877 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 240

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 878 : < command /= 10111111 >" -- 	Vector No: 240
severity warning;

assert (DTR_BAR = '0')
report
"Assert 879 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 880 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 241

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 881 : < Tx_buffer /= 00000000 >" -- 	Vector No: 241
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 882 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 883 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 64X   *
-- *               no parity      *
-- *	       6 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 242

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 884 : < command /= 00000000 >" -- 	Vector No: 242
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 885 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 886 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 887 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 888 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10000111) 
--------------------------

clk <= '0'; --	 Cycle No: 243

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10000111")
report
"Assert 889 : < mode /= 10000111 >" -- 	Vector No: 243
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 890 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01100000")
report
"Assert 891 : < stop_clocks /= 01100000 >"
severity warning;

assert (brk_clocks = "10001000000")
report
"Assert 892 : < brk_clocks /= 10001000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 893 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 244

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 894 : < command /= 10111111 >" -- 	Vector No: 244
severity warning;

assert (DTR_BAR = '0')
report
"Assert 895 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 896 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 245

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 897 : < Tx_buffer /= 00000000 >" -- 	Vector No: 245
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 898 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 899 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 64X *
-- *               no parity    *
-- *	       6 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 246

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 900 : < command /= 00000000 >" -- 	Vector No: 246
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 901 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 902 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 903 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 904 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11000111)  
--------------------------

clk <= '0'; --	 Cycle No: 247

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11000111")
report
"Assert 905 : < mode /= 11000111 >" -- 	Vector No: 247
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 906 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "10000000")
report
"Assert 907 : < stop_clocks /= 10000000 >"
severity warning;

assert (brk_clocks = "10010000000")
report
"Assert 908 : < brk_clocks /= 10010000000 >"
severity warning;

assert (chars = "0110")
report
"Assert 909 : < chars /= 0110 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 248

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 910 : < command /= 10111111 >" -- 	Vector No: 248
severity warning;

assert (DTR_BAR = '0')
report
"Assert 911 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 912 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 249

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 913 : < Tx_buffer /= 00000000 >" -- 	Vector No: 249
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 914 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 915 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Async mode : 1 stop bit  *
-- *             baud rate 1X *
-- *             even parity  *
-- *	      7 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 250

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 916 : < command /= 00000000 >" -- 	Vector No: 250
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 917 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 918 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 919 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 920 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0111001) 
--------------------------

clk <= '0'; --	 Cycle No: 251

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01111001")
report
"Assert 921 : < mode /= 01111001 >" -- 	Vector No: 251
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 922 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 923 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010100")
report
"Assert 924 : < brk_clocks /= 00000010100 >"
severity warning;

assert (chars = "0111")
report
"Assert 925 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 252

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 926 : < command /= 10111111 >" -- 	Vector No: 252
severity warning;

assert (DTR_BAR = '0')
report
"Assert 927 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 928 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (1111111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 253

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "01111111")
report
"Assert 929 : < Tx_buffer /= 01111111 >" -- 	Vector No: 253
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 930 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 931 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (00000000) -- CHECK COMPLIMENT VALUE OF "COMMAND"
--------------------------

clk <= '0'; --	 Cycle No: 254

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 932 : < command /= 00000000 >" -- 	Vector No: 254
severity warning;

assert (DTR_BAR = '1')
report
"Assert 933 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 934 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (01000000) -- INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 255

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (DTR_BAR = '1')
report
"Assert 935 : < DTR_BAR /= 1 >" -- 	Vector No: 255
severity warning;

assert (RTS_BAR = '1')
report
"Assert 936 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** CHECK INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 256

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 937 : < command /= 00000000 >" -- 	Vector No: 256
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 938 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 939 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 940 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 941 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *******************************
-- *			      *
-- * Async mode : 1.5 stop bits  *
-- *              baud rate 1X   *
-- *              odd parity     *
-- *	       7 characters   *
-- *			      *
-- *******************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 257

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 942 : < command /= 00000000 >" -- 	Vector No: 257
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 943 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 944 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 945 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 946 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10011001) 
--------------------------

clk <= '0'; --	 Cycle No: 258

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10011001")
report
"Assert 947 : < mode /= 10011001 >" -- 	Vector No: 258
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 948 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 949 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010100")
report
"Assert 950 : < brk_clocks /= 00000010100 >"
severity warning;

assert (chars = "0111")
report
"Assert 951 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 259

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 952 : < command /= 10111111 >" -- 	Vector No: 259
severity warning;

assert (DTR_BAR = '0')
report
"Assert 953 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 954 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 260

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 955 : < Tx_buffer /= 00000000 >" -- 	Vector No: 260
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 956 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 957 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 2 stop bits  *
-- *	       baud rate 1X *
-- *              odd parity   *
-- *	       7 characters *
-- *		 	    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 261

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 958 : < command /= 00000000 >" -- 	Vector No: 261
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 959 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 960 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 961 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 962 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11011001) 
--------------------------

clk <= '0'; --	 Cycle No: 262

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11011001")
report
"Assert 963 : < mode /= 11011001 >" -- 	Vector No: 262
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 964 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000010")
report
"Assert 965 : < stop_clocks /= 00000010 >"
severity warning;

assert (brk_clocks = "00000010110")
report
"Assert 966 : < brk_clocks /= 00000010110 >"
severity warning;

assert (chars = "0111")
report
"Assert 967 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 263

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 968 : < command /= 10111111 >" -- 	Vector No: 263
severity warning;

assert (DTR_BAR = '0')
report
"Assert 969 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 970 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 264

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 971 : < Tx_buffer /= 00000000 >" -- 	Vector No: 264
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 972 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 973 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Async mode : 1 stop bit  *
-- *             baud rate 1X *
-- *              no parity   *
-- *	      7 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 265

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 974 : < command /= 00000000 >" -- 	Vector No: 265
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 975 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 976 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 977 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 978 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0101001) 
--------------------------

clk <= '0'; --	 Cycle No: 266

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01001001")
report
"Assert 979 : < mode /= 01001001 >" -- 	Vector No: 266
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 980 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 981 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010010")
report
"Assert 982 : < brk_clocks /= 00000010010 >"
severity warning;

assert (chars = "0111")
report
"Assert 983 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 267

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 984 : < command /= 10111111 >" -- 	Vector No: 267
severity warning;

assert (DTR_BAR = '0')
report
"Assert 985 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 986 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 268

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 987 : < Tx_buffer /= 00000000 >" -- 	Vector No: 268
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 988 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 989 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *******************************
-- *			      *
-- * Async mode : 1.5 stop bits  *
-- *              baud rate 1X   *
-- *               no parity     *
-- *	       7 characters   *
-- *			      *
-- *******************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 269

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 990 : < command /= 00000000 >" -- 	Vector No: 269
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 991 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 992 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 993 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 994 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10001001) 
--------------------------

clk <= '0'; --	 Cycle No: 270

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10001001")
report
"Assert 995 : < mode /= 10001001 >" -- 	Vector No: 270
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 996 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 997 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010010")
report
"Assert 998 : < brk_clocks /= 00000010010 >"
severity warning;

assert (chars = "0111")
report
"Assert 999 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 271

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1000 : < command /= 10111111 >" -- 	Vector No: 271
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1001 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1002 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 272

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1003 : < Tx_buffer /= 00000000 >" -- 	Vector No: 272
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1004 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1005 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 2 stop bits  *
-- *	       baud rate 1X *
-- *               no parity   *
-- *	       7 characters *
-- *		 	    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 273

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1006 : < command /= 00000000 >" -- 	Vector No: 273
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1007 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1008 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1009 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1010 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11001001) 
--------------------------

clk <= '0'; --	 Cycle No: 274

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '0';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11001001")
report
"Assert 1011 : < mode /= 11001001 >" -- 	Vector No: 274
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 1012 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000010")
report
"Assert 1013 : < stop_clocks /= 00000010 >"
severity warning;

assert (brk_clocks = "00000010100")
report
"Assert 1014 : < brk_clocks /= 00000010100 >"
severity warning;

assert (chars = "0111")
report
"Assert 1015 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 275

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1016 : < command /= 10111111 >" -- 	Vector No: 275
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1017 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1018 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 276

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1019 : < Tx_buffer /= 00000000 >" -- 	Vector No: 276
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1020 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1021 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 16X *
-- *             even parity   *
-- *	      7 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 277

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1022 : < command /= 00000000 >" -- 	Vector No: 277
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1023 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1024 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1025 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1026 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (01111010) 
--------------------------

clk <= '0'; --	 Cycle No: 278

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01111010")
report
"Assert 1027 : < mode /= 01111010 >" -- 	Vector No: 278
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1028 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00010000")
report
"Assert 1029 : < stop_clocks /= 00010000 >"
severity warning;

assert (brk_clocks = "00101000000")
report
"Assert 1030 : < brk_clocks /= 00101000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1031 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 279

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1032 : < command /= 10111111 >" -- 	Vector No: 279
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1033 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1034 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 280

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1035 : < Tx_buffer /= 00000000 >" -- 	Vector No: 280
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1036 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1037 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 16X   *
-- *              odd parity      *
-- *	       7 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 281

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1038 : < command /= 00000000 >" -- 	Vector No: 281
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1039 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1040 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1041 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1042 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10011010) 
--------------------------

clk <= '0'; --	 Cycle No: 282

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10011010")
report
"Assert 1043 : < mode /= 10011010 >" -- 	Vector No: 282
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1044 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00011000")
report
"Assert 1045 : < stop_clocks /= 00011000 >"
severity warning;

assert (brk_clocks = "00101010000")
report
"Assert 1046 : < brk_clocks /= 00101010000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1047 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 283

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1048 : < command /= 10111111 >" -- 	Vector No: 283
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1049 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1050 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 284

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1051 : < Tx_buffer /= 00000000 >" -- 	Vector No: 284
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1052 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1053 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 16X *
-- *              odd parity    *
-- *	       7 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 285

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1054 : < command /= 00000000 >" -- 	Vector No: 285
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1055 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1056 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1057 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1058 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11011010) 
--------------------------

clk <= '0'; --	 Cycle No: 286

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11011010")
report
"Assert 1059 : < mode /= 11011010 >" -- 	Vector No: 286
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1060 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00100000")
report
"Assert 1061 : < stop_clocks /= 00100000 >"
severity warning;

assert (brk_clocks = "00101100000")
report
"Assert 1062 : < brk_clocks /= 00101100000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1063 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 287

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1064 : < command /= 10111111 >" -- 	Vector No: 287
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1065 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1066 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 288

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1067 : < Tx_buffer /= 00000000 >" -- 	Vector No: 288
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1068 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1069 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 16X *
-- *              no parity    *
-- *	      7 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 289

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1070 : < command /= 00000000 >" -- 	Vector No: 289
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1071 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1072 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1073 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1074 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0101010) 
--------------------------

clk <= '0'; --	 Cycle No: 290

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01001010")
report
"Assert 1075 : < mode /= 01001010 >" -- 	Vector No: 290
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1076 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00010000")
report
"Assert 1077 : < stop_clocks /= 00010000 >"
severity warning;

assert (brk_clocks = "00100100000")
report
"Assert 1078 : < brk_clocks /= 00100100000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1079 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 291

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1080 : < command /= 10111111 >" -- 	Vector No: 291
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1081 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1082 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 292

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1083 : < Tx_buffer /= 00000000 >" -- 	Vector No: 292
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1084 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1085 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 16X   *
-- *               no parity      *
-- *	       7 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 293

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1086 : < command /= 00000000 >" -- 	Vector No: 293
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1087 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1088 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1089 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1090 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10001010) 
--------------------------

clk <= '0'; --	 Cycle No: 294

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10001010")
report
"Assert 1091 : < mode /= 10001010 >" -- 	Vector No: 294
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1092 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00011000")
report
"Assert 1093 : < stop_clocks /= 00011000 >"
severity warning;

assert (brk_clocks = "00100110000")
report
"Assert 1094 : < brk_clocks /= 00100110000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1095 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 295

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1096 : < command /= 10111111 >" -- 	Vector No: 295
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1097 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1098 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 296

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1099 : < Tx_buffer /= 00000000 >" -- 	Vector No: 296
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1100 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1101 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 16X *
-- *               no parity    *
-- *	       7 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 297

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1102 : < command /= 00000000 >" -- 	Vector No: 297
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1103 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1104 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1105 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1106 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11001010)   
--------------------------

clk <= '0'; --	 Cycle No: 298

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11001010")
report
"Assert 1107 : < mode /= 11001010 >" -- 	Vector No: 298
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1108 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00100000")
report
"Assert 1109 : < stop_clocks /= 00100000 >"
severity warning;

assert (brk_clocks = "00101000000")
report
"Assert 1110 : < brk_clocks /= 00101000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1111 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 299

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1112 : < command /= 10111111 >" -- 	Vector No: 299
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1113 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1114 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 300

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1115 : < Tx_buffer /= 00000000 >" -- 	Vector No: 300
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1116 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1117 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 64X *
-- *             even parity   *
-- *	      7 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 301

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1118 : < command /= 00000000 >" -- 	Vector No: 301
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1119 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1120 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1121 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1122 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (01111011) 
--------------------------

clk <= '0'; --	 Cycle No: 302

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01111011")
report
"Assert 1123 : < mode /= 01111011 >" -- 	Vector No: 302
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1124 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01000000")
report
"Assert 1125 : < stop_clocks /= 01000000 >"
severity warning;

assert (brk_clocks = "10100000000")
report
"Assert 1126 : < brk_clocks /= 10100000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1127 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 303

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1128 : < command /= 10111111 >" -- 	Vector No: 303
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1129 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1130 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 304

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1131 : < Tx_buffer /= 00000000 >" -- 	Vector No: 304
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1132 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1133 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 64X   *
-- *              odd parity      *
-- *	       7 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 305

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1134 : < command /= 00000000 >" -- 	Vector No: 305
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1135 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1136 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1137 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1138 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10011011) 
--------------------------

clk <= '0'; --	 Cycle No: 306

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10011011")
report
"Assert 1139 : < mode /= 10011011 >" -- 	Vector No: 306
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1140 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01100000")
report
"Assert 1141 : < stop_clocks /= 01100000 >"
severity warning;

assert (brk_clocks = "10101000000")
report
"Assert 1142 : < brk_clocks /= 10101000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1143 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 307

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1144 : < command /= 10111111 >" -- 	Vector No: 307
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1145 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1146 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 308

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1147 : < Tx_buffer /= 00000000 >" -- 	Vector No: 308
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1148 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1149 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 64X *
-- *              odd parity    *
-- *	       7 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 309

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1150 : < command /= 00000000 >" -- 	Vector No: 309
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1151 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1152 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1153 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1154 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11011011) 
--------------------------

clk <= '0'; --	 Cycle No: 310

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11011011")
report
"Assert 1155 : < mode /= 11011011 >" -- 	Vector No: 310
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1156 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "10000000")
report
"Assert 1157 : < stop_clocks /= 10000000 >"
severity warning;

assert (brk_clocks = "10110000000")
report
"Assert 1158 : < brk_clocks /= 10110000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1159 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 311

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1160 : < command /= 10111111 >" -- 	Vector No: 311
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1161 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1162 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 312

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1163 : < Tx_buffer /= 00000000 >" -- 	Vector No: 312
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1164 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1165 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 64X *
-- *              no parity    *
-- *	      7 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 313

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1166 : < command /= 00000000 >" -- 	Vector No: 313
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1167 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1168 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1169 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1170 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0101011) 
--------------------------

clk <= '0'; --	 Cycle No: 314

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01001011")
report
"Assert 1171 : < mode /= 01001011 >" -- 	Vector No: 314
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1172 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01000000")
report
"Assert 1173 : < stop_clocks /= 01000000 >"
severity warning;

assert (brk_clocks = "10010000000")
report
"Assert 1174 : < brk_clocks /= 10010000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1175 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 315

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1176 : < command /= 10111111 >" -- 	Vector No: 315
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1177 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1178 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 316

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1179 : < Tx_buffer /= 00000000 >" -- 	Vector No: 316
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1180 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1181 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 64X   *
-- *               no parity      *
-- *	       7 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 317

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1182 : < command /= 00000000 >" -- 	Vector No: 317
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1183 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1184 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1185 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1186 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10001011) 
--------------------------

clk <= '0'; --	 Cycle No: 318

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10001011")
report
"Assert 1187 : < mode /= 10001011 >" -- 	Vector No: 318
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1188 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01100000")
report
"Assert 1189 : < stop_clocks /= 01100000 >"
severity warning;

assert (brk_clocks = "10011000000")
report
"Assert 1190 : < brk_clocks /= 10011000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1191 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 319

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1192 : < command /= 10111111 >" -- 	Vector No: 319
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1193 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1194 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 320

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1195 : < Tx_buffer /= 00000000 >" -- 	Vector No: 320
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1196 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1197 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 64X *
-- *               no parity    *
-- *	       7 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 321

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1198 : < command /= 00000000 >" -- 	Vector No: 321
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1199 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1200 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1201 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1202 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11001011)  
--------------------------

clk <= '0'; --	 Cycle No: 322

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '0';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11001011")
report
"Assert 1203 : < mode /= 11001011 >" -- 	Vector No: 322
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1204 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "10000000")
report
"Assert 1205 : < stop_clocks /= 10000000 >"
severity warning;

assert (brk_clocks = "10100000000")
report
"Assert 1206 : < brk_clocks /= 10100000000 >"
severity warning;

assert (chars = "0111")
report
"Assert 1207 : < chars /= 0111 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 323

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1208 : < command /= 10111111 >" -- 	Vector No: 323
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1209 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1210 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (0000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 324

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1211 : < Tx_buffer /= 00000000 >" -- 	Vector No: 324
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1212 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1213 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Async mode : 1 stop bit  *
-- *             baud rate 1X *
-- *             even parity  *
-- *	      8 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 325

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1214 : < command /= 00000000 >" -- 	Vector No: 325
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1215 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1216 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1217 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1218 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0111101) 
--------------------------

clk <= '0'; --	 Cycle No: 326

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01111101")
report
"Assert 1219 : < mode /= 01111101 >" -- 	Vector No: 326
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 1220 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 1221 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010110")
report
"Assert 1222 : < brk_clocks /= 00000010110 >"
severity warning;

assert (chars = "1000")
report
"Assert 1223 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 327

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1224 : < command /= 10111111 >" -- 	Vector No: 327
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1225 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1226 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (11111111) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 328

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "11111111")
report
"Assert 1227 : < Tx_buffer /= 11111111 >" -- 	Vector No: 328
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1228 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1229 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (00000000) -- CHECK COMPLIMENT VALUE OF "COMMAND"
--------------------------

clk <= '0'; --	 Cycle No: 329

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1230 : < command /= 00000000 >" -- 	Vector No: 329
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1231 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1232 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (01000000) -- INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 330

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (DTR_BAR = '1')
report
"Assert 1233 : < DTR_BAR /= 1 >" -- 	Vector No: 330
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1234 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** CHECK INTERNAL RESET
--------------------------

clk <= '0'; --	 Cycle No: 331

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1235 : < command /= 00000000 >" -- 	Vector No: 331
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1236 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1237 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1238 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1239 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *******************************
-- *			      *
-- * Async mode : 1.5 stop bits  *
-- *              baud rate 1X   *
-- *              odd parity     *
-- *	       8 characters   *
-- *			      *
-- *******************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 332

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1240 : < command /= 00000000 >" -- 	Vector No: 332
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1241 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1242 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1243 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1244 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10011101) 
--------------------------

clk <= '0'; --	 Cycle No: 333

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10011101")
report
"Assert 1245 : < mode /= 10011101 >" -- 	Vector No: 333
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 1246 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 1247 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010110")
report
"Assert 1248 : < brk_clocks /= 00000010110 >"
severity warning;

assert (chars = "1000")
report
"Assert 1249 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 334

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1250 : < command /= 10111111 >" -- 	Vector No: 334
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1251 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1252 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 335

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1253 : < Tx_buffer /= 00000000 >" -- 	Vector No: 335
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1254 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1255 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 2 stop bits  *
-- *	       baud rate 1X *
-- *              odd parity   *
-- *	       8 characters *
-- *		 	    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 336

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1256 : < command /= 00000000 >" -- 	Vector No: 336
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1257 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1258 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1259 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1260 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11011101) 
--------------------------

clk <= '0'; --	 Cycle No: 337

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11011101")
report
"Assert 1261 : < mode /= 11011101 >" -- 	Vector No: 337
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 1262 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000010")
report
"Assert 1263 : < stop_clocks /= 00000010 >"
severity warning;

assert (brk_clocks = "00000011000")
report
"Assert 1264 : < brk_clocks /= 00000011000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1265 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 338

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1266 : < command /= 10111111 >" -- 	Vector No: 338
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1267 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1268 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 339

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1269 : < Tx_buffer /= 00000000 >" -- 	Vector No: 339
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1270 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1271 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ****************************
-- *			   *
-- * Async mode : 1 stop bit  *
-- *             baud rate 1X *
-- *              no parity   *
-- *	      8 characters *
-- *			   *
-- ****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 340

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1272 : < command /= 00000000 >" -- 	Vector No: 340
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1273 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1274 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1275 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1276 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0101101) 
--------------------------

clk <= '0'; --	 Cycle No: 341

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01001101")
report
"Assert 1277 : < mode /= 01001101 >" -- 	Vector No: 341
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 1278 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 1279 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010100")
report
"Assert 1280 : < brk_clocks /= 00000010100 >"
severity warning;

assert (chars = "1000")
report
"Assert 1281 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 342

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1282 : < command /= 10111111 >" -- 	Vector No: 342
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1283 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1284 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 343

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1285 : < Tx_buffer /= 00000000 >" -- 	Vector No: 343
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1286 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1287 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *******************************
-- *			      *
-- * Async mode : 1.5 stop bits  *
-- *              baud rate 1X   *
-- *               no parity     *
-- *	       8 characters   *
-- *			      *
-- *******************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 344

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1288 : < command /= 00000000 >" -- 	Vector No: 344
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1289 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1290 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1291 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1292 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10001101) 
--------------------------

clk <= '0'; --	 Cycle No: 345

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10001101")
report
"Assert 1293 : < mode /= 10001101 >" -- 	Vector No: 345
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 1294 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000001")
report
"Assert 1295 : < stop_clocks /= 00000001 >"
severity warning;

assert (brk_clocks = "00000010100")
report
"Assert 1296 : < brk_clocks /= 00000010100 >"
severity warning;

assert (chars = "1000")
report
"Assert 1297 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 346

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1298 : < command /= 10111111 >" -- 	Vector No: 346
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1299 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1300 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 347

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1301 : < Tx_buffer /= 00000000 >" -- 	Vector No: 347
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1302 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1303 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 2 stop bits  *
-- *	       baud rate 1X *
-- *               no parity   *
-- *	       8 characters *
-- *		 	    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 348

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1304 : < command /= 00000000 >" -- 	Vector No: 348
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1305 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1306 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1307 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1308 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11001101)          
--------------------------

clk <= '0'; --	 Cycle No: 349

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '0';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11001101")
report
"Assert 1309 : < mode /= 11001101 >" -- 	Vector No: 349
severity warning;

assert (baud_clocks = "00000001")
report
"Assert 1310 : < baud_clocks /= 00000001 >"
severity warning;

assert (stop_clocks = "00000010")
report
"Assert 1311 : < stop_clocks /= 00000010 >"
severity warning;

assert (brk_clocks = "00000010110")
report
"Assert 1312 : < brk_clocks /= 00000010110 >"
severity warning;

assert (chars = "1000")
report
"Assert 1313 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 350

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1314 : < command /= 10111111 >" -- 	Vector No: 350
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1315 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1316 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 351

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1317 : < Tx_buffer /= 00000000 >" -- 	Vector No: 351
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1318 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1319 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 16X *
-- *             even parity   *
-- *	      8 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 352

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1320 : < command /= 00000000 >" -- 	Vector No: 352
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1321 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1322 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1323 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1324 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (01111110) 
--------------------------

clk <= '0'; --	 Cycle No: 353

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01111110")
report
"Assert 1325 : < mode /= 01111110 >" -- 	Vector No: 353
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1326 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00010000")
report
"Assert 1327 : < stop_clocks /= 00010000 >"
severity warning;

assert (brk_clocks = "00101100000")
report
"Assert 1328 : < brk_clocks /= 00101100000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1329 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 354

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1330 : < command /= 10111111 >" -- 	Vector No: 354
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1331 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1332 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 355

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1333 : < Tx_buffer /= 00000000 >" -- 	Vector No: 355
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1334 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1335 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 16X   *
-- *              odd parity      *
-- *	       8 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 356

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1336 : < command /= 00000000 >" -- 	Vector No: 356
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1337 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1338 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1339 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1340 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10011110) 
--------------------------

clk <= '0'; --	 Cycle No: 357

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10011110")
report
"Assert 1341 : < mode /= 10011110 >" -- 	Vector No: 357
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1342 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00011000")
report
"Assert 1343 : < stop_clocks /= 00011000 >"
severity warning;

assert (brk_clocks = "00101110000")
report
"Assert 1344 : < brk_clocks /= 00101110000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1345 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 358

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1346 : < command /= 10111111 >" -- 	Vector No: 358
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1347 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1348 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 359

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1349 : < Tx_buffer /= 00000000 >" -- 	Vector No: 359
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1350 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1351 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 16X *
-- *              odd parity    *
-- *	       8 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 360

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1352 : < command /= 00000000 >" -- 	Vector No: 360
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1353 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1354 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1355 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1356 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11011110) 
--------------------------

clk <= '0'; --	 Cycle No: 361

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11011110")
report
"Assert 1357 : < mode /= 11011110 >" -- 	Vector No: 361
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1358 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00100000")
report
"Assert 1359 : < stop_clocks /= 00100000 >"
severity warning;

assert (brk_clocks = "00110000000")
report
"Assert 1360 : < brk_clocks /= 00110000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1361 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 362

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1362 : < command /= 10111111 >" -- 	Vector No: 362
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1363 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1364 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 363

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1365 : < Tx_buffer /= 00000000 >" -- 	Vector No: 363
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1366 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1367 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 16X *
-- *              no parity    *
-- *	      8 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 364

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1368 : < command /= 00000000 >" -- 	Vector No: 364
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1369 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1370 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1371 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1372 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (01001110) 
--------------------------

clk <= '0'; --	 Cycle No: 365

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01001110")
report
"Assert 1373 : < mode /= 01001110 >" -- 	Vector No: 365
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1374 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00010000")
report
"Assert 1375 : < stop_clocks /= 00010000 >"
severity warning;

assert (brk_clocks = "00101000000")
report
"Assert 1376 : < brk_clocks /= 00101000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1377 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 366

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1378 : < command /= 10111111 >" -- 	Vector No: 366
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1379 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1380 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 367

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1381 : < Tx_buffer /= 00000000 >" -- 	Vector No: 367
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1382 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1383 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 16X   *
-- *               no parity      *
-- *	       8 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 368

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1384 : < command /= 00000000 >" -- 	Vector No: 368
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1385 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1386 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1387 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1388 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10001110) 
--------------------------

clk <= '0'; --	 Cycle No: 369

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10001110")
report
"Assert 1389 : < mode /= 10001110 >" -- 	Vector No: 369
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1390 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00011000")
report
"Assert 1391 : < stop_clocks /= 00011000 >"
severity warning;

assert (brk_clocks = "00101010000")
report
"Assert 1392 : < brk_clocks /= 00101010000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1393 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 370

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1394 : < command /= 10111111 >" -- 	Vector No: 370
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1395 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1396 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 371

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1397 : < Tx_buffer /= 00000000 >" -- 	Vector No: 371
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1398 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1399 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 16X *
-- *               no parity    *
-- *	       8 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 372

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1400 : < command /= 00000000 >" -- 	Vector No: 372
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1401 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1402 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1403 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1404 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11001110)            
--------------------------

clk <= '0'; --	 Cycle No: 373

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11001110")
report
"Assert 1405 : < mode /= 11001110 >" -- 	Vector No: 373
severity warning;

assert (baud_clocks = "00010000")
report
"Assert 1406 : < baud_clocks /= 00010000 >"
severity warning;

assert (stop_clocks = "00100000")
report
"Assert 1407 : < stop_clocks /= 00100000 >"
severity warning;

assert (brk_clocks = "00101100000")
report
"Assert 1408 : < brk_clocks /= 00101100000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1409 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 374

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1410 : < command /= 10111111 >" -- 	Vector No: 374
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1411 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1412 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 375

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1413 : < Tx_buffer /= 00000000 >" -- 	Vector No: 375
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1414 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1415 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 64X *
-- *             even parity   *
-- *	      8 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 376

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1416 : < command /= 00000000 >" -- 	Vector No: 376
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1417 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1418 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1419 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1420 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (01111111) 
--------------------------

clk <= '0'; --	 Cycle No: 377

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01111111")
report
"Assert 1421 : < mode /= 01111111 >" -- 	Vector No: 377
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1422 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01000000")
report
"Assert 1423 : < stop_clocks /= 01000000 >"
severity warning;

assert (brk_clocks = "10110000000")
report
"Assert 1424 : < brk_clocks /= 10110000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1425 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 378

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1426 : < command /= 10111111 >" -- 	Vector No: 378
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1427 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1428 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 379

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1429 : < Tx_buffer /= 00000000 >" -- 	Vector No: 379
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1430 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1431 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 64X   *
-- *              odd parity      *
-- *	       8 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 380

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1432 : < command /= 00000000 >" -- 	Vector No: 380
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1433 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1434 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1435 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1436 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10011111) 
--------------------------

clk <= '0'; --	 Cycle No: 381

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10011111")
report
"Assert 1437 : < mode /= 10011111 >" -- 	Vector No: 381
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1438 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01100000")
report
"Assert 1439 : < stop_clocks /= 01100000 >"
severity warning;

assert (brk_clocks = "10111000000")
report
"Assert 1440 : < brk_clocks /= 10111000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1441 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 382

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1442 : < command /= 10111111 >" -- 	Vector No: 382
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1443 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1444 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 383

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1445 : < Tx_buffer /= 00000000 >" -- 	Vector No: 383
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1446 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1447 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 64X *
-- *              odd parity    *
-- *	       8 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 384

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1448 : < command /= 00000000 >" -- 	Vector No: 384
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1449 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1450 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1451 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1452 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11011111) 
--------------------------

clk <= '0'; --	 Cycle No: 385

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11011111")
report
"Assert 1453 : < mode /= 11011111 >" -- 	Vector No: 385
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1454 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "10000000")
report
"Assert 1455 : < stop_clocks /= 10000000 >"
severity warning;

assert (brk_clocks = "11000000000")
report
"Assert 1456 : < brk_clocks /= 11000000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1457 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 386

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1458 : < command /= 10111111 >" -- 	Vector No: 386
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1459 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1460 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 387

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1461 : < Tx_buffer /= 00000000 >" -- 	Vector No: 387
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1462 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1463 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *****************************
-- *			    *
-- * Async mode : 1 stop bit   *
-- *             baud rate 64X *
-- *              no parity    *
-- *	      8 characters  *
-- *			    *
-- *****************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 388

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1464 : < command /= 00000000 >" -- 	Vector No: 388
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1465 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1466 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1467 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1468 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (0101111) 
--------------------------

clk <= '0'; --	 Cycle No: 389

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "01001111")
report
"Assert 1469 : < mode /= 01001111 >" -- 	Vector No: 389
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1470 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01000000")
report
"Assert 1471 : < stop_clocks /= 01000000 >"
severity warning;

assert (brk_clocks = "10100000000")
report
"Assert 1472 : < brk_clocks /= 10100000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1473 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 390

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1474 : < command /= 10111111 >" -- 	Vector No: 390
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1475 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1476 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 391

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1477 : < Tx_buffer /= 00000000 >" -- 	Vector No: 391
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1478 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1479 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ********************************
-- *			       *
-- * Async mode : 1.5 stop bits   *
-- *              baud rate 64X   *
-- *               no parity      *
-- *	       8 characters    *
-- *			       *
-- ********************************
-- ** COMPLEMENTED DATA CHAR, PARITY BITS 
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 392

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1480 : < command /= 00000000 >" -- 	Vector No: 392
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1481 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1482 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1483 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1484 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (10001111) 
--------------------------

clk <= '0'; --	 Cycle No: 393

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "10001111")
report
"Assert 1485 : < mode /= 10001111 >" -- 	Vector No: 393
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1486 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "01100000")
report
"Assert 1487 : < stop_clocks /= 01100000 >"
severity warning;

assert (brk_clocks = "10101000000")
report
"Assert 1488 : < brk_clocks /= 10101000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1489 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 394

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1490 : < command /= 10111111 >" -- 	Vector No: 394
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1491 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1492 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 395

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1493 : < Tx_buffer /= 00000000 >" -- 	Vector No: 395
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1494 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1495 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- ******************************
-- *			     *
-- * Async mode : 2 stop bits   *
-- *	       baud rate 64X *
-- *               no parity    *
-- *	       8 characters  *
-- *		 	     *
-- ******************************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 396

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1496 : < command /= 00000000 >" -- 	Vector No: 396
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1497 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1498 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1499 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1500 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11001111)            
--------------------------

clk <= '0'; --	 Cycle No: 397

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11001111")
report
"Assert 1501 : < mode /= 11001111 >" -- 	Vector No: 397
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1502 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "10000000")
report
"Assert 1503 : < stop_clocks /= 10000000 >"
severity warning;

assert (brk_clocks = "10110000000")
report
"Assert 1504 : < brk_clocks /= 10110000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1505 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 398

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1506 : < command /= 10111111 >" -- 	Vector No: 398
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1507 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1508 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE DATA (00000000) -- CHECK TxRDY status bit, Tx_wr_while_cts
--------------------------

clk <= '0'; --	 Cycle No: 399

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '0';
DSR_BAR <= '1';
D_7 <= '0';
D_6 <= '0';
D_5 <= '0';
D_4 <= '0';
D_3 <= '0';
D_2 <= '0';
D_1 <= '0';
D_0 <= '0';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (Tx_buffer = "00000000")
report
"Assert 1509 : < Tx_buffer /= 00000000 >" -- 	Vector No: 399
severity warning;

assert (Tx_wr_while_cts = '1')
report
"Assert 1510 : < Tx_wr_while_cts /= 1 >"
severity warning;

assert (status = "00000100")
report
"Assert 1511 : < status /= 00000100 >"
severity warning;

wait for 1 ns;

-- ******************************************************************************************************************************
-- *************
-- *	    *
-- * READ DATA *
-- *	    *
-- *************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 400

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1512 : < command /= 00000000 >" -- 	Vector No: 400
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1513 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1514 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1515 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1516 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11001111)            
--------------------------

clk <= '0'; --	 Cycle No: 401

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11001111")
report
"Assert 1517 : < mode /= 11001111 >" -- 	Vector No: 401
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1518 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "10000000")
report
"Assert 1519 : < stop_clocks /= 10000000 >"
severity warning;

assert (brk_clocks = "10110000000")
report
"Assert 1520 : < brk_clocks /= 10110000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1521 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 402

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1522 : < command /= 10111111 >" -- 	Vector No: 402
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1523 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1524 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** READ DATA (00000000) 
--------------------------

clk <= '0'; --	 Cycle No: 403

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '0';
WR_BAR <= '1';
CTS_BAR <= '0';
DSR_BAR <= '1';
Rx_buffer <= "00000000";
D_7 <= 'Z';
D_6 <= 'Z';
D_5 <= 'Z';
D_4 <= 'Z';
D_3 <= 'Z';
D_2 <= 'Z';
D_1 <= 'Z';
D_0 <= 'Z';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (D_7 = '0')
report
"Assert 1525 : < D_7 /= 0 >" -- 	Vector No: 403
severity warning;

assert (D_6 = '0')
report
"Assert 1526 : < D_6 /= 0 >"
severity warning;

assert (D_5 = '0')
report
"Assert 1527 : < D_5 /= 0 >"
severity warning;

assert (D_4 = '0')
report
"Assert 1528 : < D_4 /= 0 >"
severity warning;

assert (D_3 = '0')
report
"Assert 1529 : < D_3 /= 0 >"
severity warning;

assert (D_2 = '0')
report
"Assert 1530 : < D_2 /= 0 >"
severity warning;

assert (D_1 = '0')
report
"Assert 1531 : < D_1 /= 0 >"
severity warning;

assert (D_0 = '0')
report
"Assert 1532 : < D_0 /= 0 >"
severity warning;

assert (Tx_buffer = "00000000")
report
"Assert 1533 : < Tx_buffer /= 00000000 >"
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1534 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1535 : < status /= 00000101 >"
severity warning;

wait for 1 ns;

-- ******************************************************************************************************************************
-- *R:CS:CD:RD:WR:CTS:DSR:Rxbuffer:D7:D6:D5:D4:D3:D2:D1:D0:SY:D7:D6:D5:D4:D3:D2:D1:D0:SY:RxR:mode    :baudclks:stopclks:          brek_clocks:char:SYNCmask:SYNC1   :SYNC2   :command :Txbuffer:TxCTS:status  :DTR:RTS:
-- *************
-- *	    *
-- * READ DATA *
-- *	    *
-- *************
-- *** RESET
--------------------------

clk <= '0'; --	 Cycle No: 404

wait for 1 ns;

RESET <= '1';
CS_BAR <= '0';
RD_BAR <= '1';
WR_BAR <= '1';
CTS_BAR <= '1';
DSR_BAR <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "00000000")
report
"Assert 1536 : < command /= 00000000 >" -- 	Vector No: 404
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1537 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1538 : < status /= 00000101 >"
severity warning;

assert (DTR_BAR = '1')
report
"Assert 1539 : < DTR_BAR /= 1 >"
severity warning;

assert (RTS_BAR = '1')
report
"Assert 1540 : < RTS_BAR /= 1 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE MODE (11001111)            
--------------------------

clk <= '0'; --	 Cycle No: 405

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '1';
D_5 <= '0';
D_4 <= '0';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (mode = "11001111")
report
"Assert 1541 : < mode /= 11001111 >" -- 	Vector No: 405
severity warning;

assert (baud_clocks = "01000000")
report
"Assert 1542 : < baud_clocks /= 01000000 >"
severity warning;

assert (stop_clocks = "10000000")
report
"Assert 1543 : < stop_clocks /= 10000000 >"
severity warning;

assert (brk_clocks = "10110000000")
report
"Assert 1544 : < brk_clocks /= 10110000000 >"
severity warning;

assert (chars = "1000")
report
"Assert 1545 : < chars /= 1000 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** WRITE COMMAND (10111111) -- CHECK RTS_BAR, DTR_BAR
--------------------------

clk <= '0'; --	 Cycle No: 406

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '1';
RD_BAR <= '1';
WR_BAR <= '0';
CTS_BAR <= '1';
DSR_BAR <= '1';
D_7 <= '1';
D_6 <= '0';
D_5 <= '1';
D_4 <= '1';
D_3 <= '1';
D_2 <= '1';
D_1 <= '1';
D_0 <= '1';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (command = "10111111")
report
"Assert 1546 : < command /= 10111111 >" -- 	Vector No: 406
severity warning;

assert (DTR_BAR = '0')
report
"Assert 1547 : < DTR_BAR /= 0 >"
severity warning;

assert (RTS_BAR = '0')
report
"Assert 1548 : < RTS_BAR /= 0 >"
severity warning;

wait for 1 ns;

-- *****************************************************************************************************************************
-- *** READ DATA (11111111) 
--------------------------

clk <= '0'; --	 Cycle No: 407

wait for 1 ns;

RESET <= '0';
CS_BAR <= '0';
C_D_BAR <= '0';
RD_BAR <= '0';
WR_BAR <= '1';
CTS_BAR <= '0';
DSR_BAR <= '1';
Rx_buffer <= "11111111";
D_7 <= 'Z';
D_6 <= 'Z';
D_5 <= 'Z';
D_4 <= 'Z';
D_3 <= 'Z';
D_2 <= 'Z';
D_1 <= 'Z';
D_0 <= 'Z';
SYNDET_BD <= 'Z';

wait for 4 ns;

clk <= '1';

wait for 4 ns;

assert (D_7 = '1')
report
"Assert 1549 : < D_7 /= 1 >" -- 	Vector No: 407
severity warning;

assert (D_6 = '1')
report
"Assert 1550 : < D_6 /= 1 >"
severity warning;

assert (D_5 = '1')
report
"Assert 1551 : < D_5 /= 1 >"
severity warning;

assert (D_4 = '1')
report
"Assert 1552 : < D_4 /= 1 >"
severity warning;

assert (D_3 = '1')
report
"Assert 1553 : < D_3 /= 1 >"
severity warning;

assert (D_2 = '1')
report
"Assert 1554 : < D_2 /= 1 >"
severity warning;

assert (D_1 = '1')
report
"Assert 1555 : < D_1 /= 1 >"
severity warning;

assert (D_0 = '1')
report
"Assert 1556 : < D_0 /= 1 >"
severity warning;

assert (Tx_buffer = "00000000")
report
"Assert 1557 : < Tx_buffer /= 00000000 >"
severity warning;

assert (Tx_wr_while_cts = '0')
report
"Assert 1558 : < Tx_wr_while_cts /= 0 >"
severity warning;

assert (status = "00000101")
report
"Assert 1559 : < status /= 00000101 >"
severity warning;

wait for 1 ns;

-- ******************************************************************************************************************************--------------------------

end process;

end A;
