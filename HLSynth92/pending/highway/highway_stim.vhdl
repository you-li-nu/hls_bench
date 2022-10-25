--**VHDL*************************************************************
--
-- SRC-MODULE : TESTBENCH
-- NAME       : highway_stim.vhdl
-- VERSION    : 1.0
--
-- PURPOSE    : Testbench for HIGHWAY Benchmark
--
-- LAST UPDATE: Mon May 24 10:51:18 MET DST 1993
--
--*******************************************************************
--
-- Simulation Bench
--

ENTITY highway_stim IS  END  highway_stim ;
  
ARCHITECTURE stimulation of highway_stim is

COMPONENT highway_comp
PORT (reset  : IN     bit;                 --     Global reset
      clk    : IN     bit;                 --     Global clock
      cars   : IN     bit;                 --     Car detector   
      HYGL   : OUT    bit;                 --     HYGreenLight
      HYRL   : OUT    bit;                 --     HYRedLight
      HYYL   : OUT    bit;                 --     HYYellowLight
      FGL    : OUT    bit;                 --     FarmGreenLight
      FRL    : OUT    bit;                 --     FarmRedLight
      FYL    : OUT    bit);                --     FarmYellowLight
END COMPONENT;
  

    SIGNAL  reset  :  bit;
    SIGNAL  clk    :  bit;
    SIGNAL  cars   :  bit;                    --     Car detector   
    SIGNAL  HYGL   :  bit;                    --     HYGreenLight
    SIGNAL  HYRL   :  bit;                    --     HYRedLight
    SIGNAL  HYYL   :  bit;                    --     HYYellowLight
    SIGNAL  FGL    :  bit;                    --     FarmGreenLight
    SIGNAL  FRL    :  bit;                    --     FarmRedLight
    SIGNAL  FYL    :  bit;                    --     FarmYellowLight


BEGIN
                               
   comp : highway_comp  PORT MAP (reset, clk, cars, HYGL, HYRL, HYYL,
                                                         FGL, FRL,FYL);

  highway_stim: PROCESS
 
  BEGIN


    WAIT UNTIL clk = '1';
    reset    <= '1';
    WAIT UNTIL clk = '1';
    reset    <= '0';
    cars     <= '0';

    FOR i IN 0 to 8 LOOP
      WAIT UNTIL clk = '1';
    END LOOP;                            --  i

    cars     <= '1';
    FOR i IN 0 to 31 LOOP
      WAIT UNTIL clk = '1';
    END LOOP;                            --  i
    
    ASSERT false REPORT "End of Simulation" SEVERITY error;
      
  END PROCESS;
 
  highway_clk: PROCESS
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

end stimulation;


configuration highway_algo_conf of highway_stim is  
  for stimulation
    for comp : highway_comp use entity work.highway(algorithm);
    end for;  
  end for;  
end highway_algo_conf; 
  
configuration highway_hlsm_conf of highway_stim is  
  for stimulation
    for comp : highway_comp use entity work.highway(hlsm);
    end for;  
  end for;  
end highway_hlsm_conf; 

--
-- End of Simulation Bench
--


