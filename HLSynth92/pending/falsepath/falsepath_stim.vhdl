--**VHDL*************************************************************
--
-- SRC-MODULE : TESTBENCH
-- NAME       : falsepath_stim.vhdl
-- VERSION    : 1.0
--
-- PURPOSE    : Testbench for falsepath Benchmark
--
-- LAST UPDATE: Wed May 19 12:36:05 MET DST 1993
--
--*******************************************************************
--
-- Simulation Bench
--

USE work.types.all;
    
ENTITY falsepath_stim IS  END  falsepath_stim ; 

ARCHITECTURE  stimulation OF falsepath_stim IS 

COMPONENT falsepath_comp
PORT(reset      : IN bit;          -- Global reset
     clk        : IN bit;          -- Global clock
     stackinp   : IN nat16;
     datainp    : IN nat16;
     offset1inp : IN nat16;
     offset2inp : IN nat16;
     maddr      : OUT nat16);
END COMPONENT;
                            
    SIGNAL  reset      :  bit;                 -- Global reset
    SIGNAL  clk        :  bit;                 -- Global clock
    SIGNAL  stackinp   :  nat16;
    SIGNAL  datainp    :  nat16;
    SIGNAL  offset1inp :  nat16;   
    SIGNAL  offset2inp :  nat16;
    SIGNAL  maddr      :  nat16;

BEGIN
  comp1 : falsepath_comp  PORT MAP (reset, clk, stackinp, datainp,
                                     offset1inp, offset2inp, maddr);

  falsepath_stim: PROCESS
  BEGIN

    stackinp <= 4;
    offset1inp <= 8;
    offset2inp <= 2;
    datainp <= 3;
    WAIT UNTIL clk'event AND clk = '1';
    reset <= '1';
    WAIT UNTIL clk'event AND clk = '1';

    reset <= '0';
    WAIT UNTIL clk'event AND clk = '1';

    datainp <= 0;
    WAIT UNTIL clk'event AND clk = '1';
    WAIT UNTIL clk'event AND clk = '1';
    ASSERT (maddr = 12)
        REPORT "ERROR: Signal maddr should be 12"
          SEVERITY ERROR;

    datainp <= 1;
    WAIT UNTIL clk'event AND clk = '1';
    WAIT UNTIL clk'event AND clk = '1';
    ASSERT (maddr = 10)
        REPORT "ERROR: Signal maddr should be 10"
          SEVERITY ERROR;

    datainp <= 2;
    WAIT UNTIL clk'event AND clk = '1';
    WAIT UNTIL clk'event AND clk = '1';
    ASSERT (maddr = 5)
        REPORT "ERROR: Signal maddr should be 5"
          SEVERITY ERROR;

    WAIT UNTIL clk'event AND clk = '1';
    WAIT UNTIL clk'event AND clk = '1';
    ASSERT (maddr = 2)
        REPORT "ERROR: Signal maddr should be 2"
          SEVERITY ERROR;

    ASSERT false REPORT "End of Simulation" SEVERITY error;
 
END PROCESS falsepath_stim;


  falsepath_clk: PROCESS
    VARIABLE i     : integer;

  BEGIN
    clk   <= '0';

    WHILE TRUE LOOP
        clk <= '1';
        WAIT FOR 50 ns;
        clk <= '0';                
        WAIT FOR 50 ns;
    END LOOP;
  END PROCESS falsepath_clk;

END stimulation;   
         

configuration falsepath_stim_conf of  falsepath_stim is  
  for stimulation
    for comp1 : falsepath_comp use entity work.falsepath(algorithm);
    end for;  
  end for;  
end falsepath_stim_conf; 
