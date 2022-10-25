--**VHDL*************************************************************
--
-- SRC-MODULE : TESTBENCH
-- NAME       : fancy_stim.vhdl
-- VERSION    : 1.0
--
-- PURPOSE    : Testbench for fancy Benchmark
--
-- LAST UPDATE: Wed May 19 13:05:05 MET DST 1993
--
--*******************************************************************
--
-- Simulation Bench
--

USE work.types.all;
    
ENTITY fancy_stim IS  END  fancy_stim ; 

ARCHITECTURE  stimulation OF fancy_stim IS 

COMPONENT fancy_comp
PORT(reset    : IN bit;          -- Global reset
     clk      : IN bit;          -- Global clock
     startinp : IN boolean;
     ainp     : IN nat8;
     binp     : IN nat8;   
     cinp     : IN nat8;
     eoc      : OUT boolean; 
     f        : OUT nat8);                
END COMPONENT;
                            
    SIGNAL  reset      : bit;                 -- Global reset
    SIGNAL  clk        : bit;                 -- Global clock
    SIGNAL  startinp   : boolean;
    SIGNAL  ainp       : nat8;
    SIGNAL  binp       : nat8;   
    SIGNAL  cinp       : nat8;
    SIGNAL  eoc        : boolean; 
    SIGNAL  f          : nat8;                

BEGIN
  comp1 : fancy_comp  PORT MAP (reset, clk, startinp, ainp, binp, cinp, eoc, f);

  fancy_stim: PROCESS
  BEGIN

    startinp <= true;
    ainp     <= 13;
    binp     <= 4;
    cinp     <= 32;

    WAIT UNTIL clk = '1';
    reset    <= '1';
    WAIT UNTIL clk = '1';
    reset    <= '0';
    WAIT UNTIL clk = '1';

    while (eoc = false) LOOP
      WAIT UNTIL clk = '1';
    END LOOP;

    startinp <= false;
    ainp     <= 13;
    binp     <= 4;
    cinp     <= 32;
    WAIT UNTIL clk = '1';

    while (eoc = false) LOOP
      WAIT UNTIL clk = '1';
    END LOOP;

    startinp <= false;
    ainp     <= 13;
    binp     <= 33;
    cinp     <= 32;
    WAIT UNTIL clk = '1';

    while (eoc = false) LOOP
      WAIT UNTIL clk = '1';
    END LOOP;

    startinp <= false;
    ainp     <= 13;
    binp     <= 32;
    cinp     <= 64;
    WAIT UNTIL clk = '1';

    while (eoc = false) LOOP
      WAIT UNTIL clk = '1';
    END LOOP;

    WAIT UNTIL clk = '1';
    while (eoc = false) LOOP
      WAIT UNTIL clk = '1';
    END LOOP;
    WAIT UNTIL clk = '1';

    ASSERT false REPORT "End of Simulation" SEVERITY error;
 
  END PROCESS;


  fancy_clk: PROCESS
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

END stimulation;   
         

configuration fancy_stim_conf of  fancy_stim is  
  for stimulation
    for comp1 : fancy_comp use entity work.fancy(algorithm);
    end for;  
  end for;  
end fancy_stim_conf; 
