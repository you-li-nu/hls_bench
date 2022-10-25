--**VHDL*************************************************************
--
-- SRC-MODULE : TESTBENCH
-- NAME       : display_stim.vhdl
-- VERSION    : 1.0
--
-- PURPOSE    : Testbench for display Benchmark
--
-- LAST UPDATE: Mon May 24 09:38:55 MET DST 1993
--
--*******************************************************************
--
-- Simulation Bench
--

ENTITY display_stim IS  END  display_stim ; 

ARCHITECTURE  stimulation OF display_stim IS 

COMPONENT display_comp
PORT(reset    : IN bit;          -- Global reset
     clk      : IN bit;          -- Global clock
     en       : IN boolean;
     unit0    : OUT bit_vector(6 DOWNTO 0);
     unit1    : OUT bit_vector(6 DOWNTO 0);
     unit2    : OUT bit_vector(6 DOWNTO 0);
     unit3    : OUT bit_vector(6 DOWNTO 0));
END COMPONENT;
                            
    SIGNAL  reset      : bit;                 -- Global reset
    SIGNAL  clk        : bit;                 -- Global clock
    SIGNAL  en         : boolean;
    SIGNAL  unit0      : bit_vector(6 DOWNTO 0);
    SIGNAL  unit1      : bit_vector(6 DOWNTO 0);
    SIGNAL  unit2      : bit_vector(6 DOWNTO 0);
    SIGNAL  unit3      : bit_vector(6 DOWNTO 0);

BEGIN
  comp1 : display_comp  PORT MAP (reset, clk, en, unit0, unit1, unit2, unit3);

  display_stim: PROCESS
  BEGIN

    en    <= false;

    WAIT UNTIL clk = '1';
    reset    <= '1';
    WAIT UNTIL clk = '1';
    reset    <= '0';
    WAIT UNTIL clk = '1';

    en    <= true;

    FOR i IN 0 to 2400 LOOP
      WAIT UNTIL clk = '1';
    END LOOP;                            --  i

    ASSERT false REPORT "End of Simulation" SEVERITY error;
 
  END PROCESS;


  display_clk: PROCESS
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
         

configuration display_stim_conf of  display_stim is  
  for stimulation
    for comp1 : display_comp use entity work.display(algorithm);
    end for;  
  end for;  
end display_stim_conf; 
