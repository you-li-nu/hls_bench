--**VHDL*************************************************************
--
-- SRC-MODULE : TESTBENCH
-- NAME       : qrs_stim.vhdl
-- VERSION    : 1.1
--
-- PURPOSE    : Testbench for QRS Chip
--
-- LAST UPDATE: Thu Feb 11 09:56:52 1993
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Preeti R. Panda      17 Jan 95    Synopsys
--  Functionality     yes     Manu Gulati          01 Dec 93    Synopsys
--*******************************************************************
--
-- Simulation Bench
--
LIBRARY std;
USE std.textio.all;

USE work.qrs_types.all;

ENTITY qrs_stim IS  END  qrs_stim ;
  
ARCHITECTURE stimulation of qrs_stim is

COMPONENT qrs_comp
PORT (reset  : IN     bit;                 -- Global reset
      clk    : IN     bit;                 -- Global clock
      data   : IN     int16;               -- Data bus (input only, 16 pins)
      we     : IN     boolean;             -- Write-Enable, indicating valid data on Data 15-0
      rc     : IN     boolean;             -- Restart Command
      rdy    : OUT    boolean;             -- Ready to read data
      fl3o   : OUT    nat2;
      RRpeak : OUT    boolean;             -- Peak signal
      RRo    : OUT    int16);              -- Number of cycles between peaks
END COMPONENT;
  

    SIGNAL  data	     : int16;
    SIGNAL  we      	     : boolean;
    SIGNAL  rdy	    	     : boolean;
    SIGNAL  fl1o	     : boolean;
    SIGNAL  fl2o	     : boolean;
    SIGNAL  fl3o	     : nat2;
    SIGNAL  RRpeak           : boolean;
    SIGNAL  RRo		     : int16;

    SIGNAL  rc               : boolean;
    SIGNAL  reset            : bit;
    SIGNAL  clk              : bit;

    FILE init_data : TEXT IS IN  "qrs_init.data";
    FILE sim_data  : TEXT IS IN  "qrs_sim.data";
    FILE rrpeak_out: TEXT IS OUT "qrs_sim.peak";

BEGIN
                               
   comp : qrs_comp  PORT MAP (reset, clk, data, we, rc,
                               rdy, fl3o, RRpeak, RRo);

  qrs_stim: PROCESS
 
    CONSTANT Active   : boolean := FALSE;  -- Low active inputs and outputs!
    CONSTANT Inactive : boolean := TRUE;   -- Low active inputs and outputs!
 
    VARIABLE l     : line;
    VARIABLE i     : integer;
    VARIABLE point : integer;
    VARIABLE b     : bit;
 
  BEGIN
    rc <= Inactive;
    point := 0;

    WAIT until clk'event AND clk = '1';
    reset <= '1';
    WAIT until clk'event AND clk = '1';
    reset <= '0';
 
    LOOP

        we <= Inactive;

        WAIT until rdy = Active;
        readline(init_data, l);
        read(l, i);
        data <= i;
        we <= Active;

        WAIT until rdy = Inactive;
        --   provide 1 clock cycle in order
        --   to make interface signals visible
        WAIT until clk'event AND clk = '1';
        write(l, point, left, 6);
        IF RRpeak = True THEN
            b := '1';
        ELSE
            b := '0';
        END IF;
        write(l, b, left, 3);
        i := RRo;
        write(l, i, left, 7);
        writeline(rrpeak_out, l);
        
        EXIT WHEN endfile(init_data);
    END LOOP;
 
    point := 1;
    LOOP

        we <= Inactive;

        WAIT until rdy = Active;
        readline(sim_data, l);
        read(l, i);
        data <= i;
        we <= Active;

        WAIT until rdy = Inactive;
        --   provide 1 clock cycle in order
        --   to make interface signals visible
        WAIT until clk'event AND clk = '1';
        write(l, point, left, 8);
        IF RRpeak = True THEN
            b := '1';
        ELSE
            b := '0';
        END IF;
        write(l, b, left, 3);
        i := RRo;
        write(l, i, left, 7);
        writeline(rrpeak_out, l);
        point := point + 1;
  
        EXIT WHEN endfile(sim_data);
    END LOOP;

    ASSERT false REPORT "End of Simulation" SEVERITY error;
      
  END PROCESS;
 
  qrs_clk: PROCESS
    VARIABLE i     : integer;
 
  BEGIN
    clk   <= '0';
 
    WHILE TRUE LOOP
        clk <= '1';
        WAIT FOR 25 ns;
        clk <= '0';
        WAIT FOR 25 ns;
    END LOOP;

  END PROCESS;

end stimulation;


configuration qrs_sys_conf of qrs_stim is  
  for stimulation
    for comp : qrs_comp use entity work.qrs(system);
    end for;  
   end for;  
end qrs_sys_conf; 
  
configuration qrs_algo_conf of qrs_stim is  
  for stimulation
    for comp : qrs_comp use entity work.qrs(algorithm);
    end for;  
  end for;  
end qrs_algo_conf; 
  
configuration qrs_hlsm_conf of qrs_stim is  
  for stimulation
    for comp : qrs_comp use entity work.qrs(hlsm);
    end for;  
  end for;  
end qrs_hlsm_conf; 

--
-- End of Simulation Bench
--


