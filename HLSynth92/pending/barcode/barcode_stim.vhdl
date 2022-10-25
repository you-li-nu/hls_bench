--**VHDL*************************************************************
--
-- SRC-MODULE : TESTBENCH
-- NAME       : barcode_stim.vhdl
-- VERSION    : 1.1
--
-- PURPOSE    : Testbench for barcode Benchmark
--
-- LAST UPDATE: Mon May 24 12:39:15 MET DST 1993
--
--*******************************************************************
--
-- Simulation Bench
--

USE work.barcode_types.all;
    
ENTITY barcode_stim IS  END  barcode_stim ; 

ARCHITECTURE  pre OF barcode_stim IS 

COMPONENT barcode_comp
PORT(reset : IN bit;          -- Global reset
     clk   : IN bit;          -- Global clock
     scan  : IN boolean;
     video : IN bit;
     start : IN boolean;
     num   : IN nat8;
     eoc   : OUT boolean; 
     memw  : OUT boolean;
     data  : OUT nat8;
     addr  : OUT nat8);
END COMPONENT;
                            
    SIGNAL  reset      : bit;                 -- Global reset
    SIGNAL  clk        : bit;                 -- Global clock
    SIGNAL  scan       : boolean;
    SIGNAL  video      : bit;
    SIGNAL  start      : boolean;
    SIGNAL  num        : nat8;
    SIGNAL  eoc        : boolean;
    SIGNAL  memw       : boolean;
    SIGNAL  data       : nat8;
    SIGNAL  addr       : nat8;

BEGIN
  comp1 : barcode_comp  PORT MAP (reset, clk, scan, video,
                                  start, num, eoc, memw, data, addr);

  barcode_stim: PROCESS
    CONSTANT   wh     : bit := '0';  
    CONSTANT   bl     : bit := '1';
  BEGIN 

    start <= false;
    scan  <= false;
    num   <= 6;
    video <= wh;
    reset <= '1';

    WAIT until clk='1';
    reset <= '0';
    WAIT until clk='1';
    scan <= true;
    start <= true;
    WAIT until clk='1';
    WAIT until clk='1';
    WAIT until clk='1';

    video <= bl;
    WAIT until clk='1';
    WAIT until clk='1';
    WAIT until clk='1';
    WAIT until clk='1';
    video <= wh;
    for i in 0 to 258 loop
	WAIT until clk='1';
    end loop;
    video <= bl;
    WAIT until clk='1';
    WAIT until clk='1';
    video <= wh;
    WAIT until clk='1';
    WAIT until clk='1';
    WAIT until clk='1';
    WAIT until clk='1';
    video <= bl;
    WAIT until clk='1';
    WAIT until clk='1';
    WAIT until clk='1';
    WAIT until clk='1';
    WAIT until clk='1';
    WAIT until clk='1';
    video <= wh;
    WAIT until clk='1';
    WAIT until clk='1';
    video <= bl;
    WAIT until clk='1';
    WAIT until clk='1';
    WAIT until clk='1';
    WAIT until clk='1';
    video <= wh;
    for i in 0 to 255 loop
	WAIT until clk='1';
    end loop;

    start <= false;
    while (eoc = false) LOOP
        WAIT until clk='1';
    END LOOP;

    ASSERT false REPORT "End of Simulation" SEVERITY error;
 
  END PROCESS;


  barcode_clk: PROCESS
    VARIABLE i     : integer;

  BEGIN
    clk   <= '0';

    WHILE TRUE LOOP
        clk <= '1';
        WAIT FOR 50 ns;
        clk <= '0';                
        WAIT FOR 50 ns;
    END LOOP;

  END PROCESS;

END pre;   
         

configuration barcode_stim_conf of  barcode_stim is  
  for pre
    for comp1 : barcode_comp use entity work.barcode(algorithm);
    end for;  
  end for;  
end barcode_stim_conf; 
