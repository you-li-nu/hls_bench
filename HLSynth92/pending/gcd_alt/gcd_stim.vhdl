--**VHDL*************************************************************
--
-- SRC-MODULE : TESTBENCH
-- NAME       : gcd_stim.vhdl
-- VERSION    : 1.0
--
-- PURPOSE    : Testbench for GCD Benchmark
--
-- LAST UPDATE: Mon May 24 13:08:48 MET DST 1993
--
--*******************************************************************
--
-- Simulation Bench
--

USE work.types.all;
    
ENTITY gcd_stim IS  END  gcd_stim ; 

ARCHITECTURE  stimulation OF gcd_stim IS 

COMPONENT gcd_comp
PORT(reset : IN bit;          -- Global reset
     clk   : IN bit;          -- Global clock
     rst   : IN boolean;
     xin   : IN nat8;    
     yin   : IN nat8;
     rdy   : OUT boolean;
     oup   : OUT nat8);  
END COMPONENT;
                            
    SIGNAL  reset  :  bit;                 -- Global reset
    SIGNAL  clk    :  bit;                 -- Global clock
    SIGNAL  rst    :  boolean;                     
    SIGNAL  xin    :  nat8;
    SIGNAL  yin    :  nat8;                                    
    SIGNAL  rdy    :  boolean;
    SIGNAL  oup    :  nat8;                                 

BEGIN
  comp1 : gcd_comp  PORT MAP (reset, clk, rst, xin, yin, rdy, oup);

  gcd_stim: PROCESS

    CONSTANT Active   : boolean := TRUE;  
    CONSTANT Inactive : boolean := FALSE; 

  BEGIN

    rst   <= Inactive;
    xin   <= 0;
    yin   <= 0;
    reset <= '1';
    WAIT UNTIL clk = '1';

    reset <= '0';
    rst   <= Active;
    WAIT UNTIL clk = '1';

    xin   <= 67;
    yin   <= 3;
    WAIT UNTIL clk = '1';
    rst   <= Inactive;
    while (rdy = true) LOOP
      WAIT UNTIL clk = '1';
    END LOOP;
    -- oup    = 1
    while (rdy = false) LOOP
      WAIT UNTIL clk = '1';
    END LOOP;

    xin   <= 21;
    yin   <= 14;
    rst   <= Active;
    WAIT UNTIL clk = '1';
    rst   <= Inactive;
    while (rdy = true) LOOP
      WAIT UNTIL clk = '1';
    END LOOP;
    -- oup    = 7
    while (rdy = false) LOOP
      WAIT UNTIL clk = '1';
    END LOOP;

    xin   <= 36;
    yin   <= 8;
    rst   <= Active;
    WAIT UNTIL clk = '1';
    rst   <= Inactive;
    while (rdy = true) LOOP
      WAIT UNTIL clk = '1';
    END LOOP;
    -- oup    = 4
    while (rdy = false) LOOP
      WAIT UNTIL clk = '1';
    END LOOP;

    WAIT UNTIL clk = '1';

    ASSERT false REPORT "End of Simulation" SEVERITY error;
 
  END PROCESS;


  gcd_clk: PROCESS

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
         

configuration gcd_stim_conf of  gcd_stim is  
  for stimulation
    for comp1 : gcd_comp use entity work.gcd(algorithm);
    end for;  
  end for;  
end gcd_stim_conf; 
