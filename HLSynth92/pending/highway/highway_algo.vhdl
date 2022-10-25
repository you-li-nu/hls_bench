--**VHDL*************************************************************
--
-- SRC-MODULE : HIGHWAY
-- NAME       : highway_algo.vhdl
-- VERSION    : 1.0
--
-- PURPOSE    : Architecture of HIGHWAY benchmark
--                 (algorithmic description)
--
-- LAST UPDATE: Mon May 24 10:38:11 MET DST 1993
--
--*******************************************************************
--
-- Architecture of HIGHWAY
--

ARCHITECTURE algorithm OF highway IS

  SUBTYPE nat3  IS integer RANGE 7 DOWNTO 0;

BEGIN
  highway: PROCESS
    CONSTANT   false : bit := '0';  
    CONSTANT   true  : bit := '1';
    CONSTANT   long  : nat3 := 7;    -- delay for long time
    CONSTANT   short : nat3 := 4;    -- delay for short time
    VARIABLE   i     : nat3;         -- counter 
  BEGIN 

  RESET_LOOP : LOOP 

    -- Green phase for highway --

    HYGL <= true;  HYYL <= false; HYRL <= false;
    FGL  <= false; FYL  <= false; FRL  <= true;
    i := 0;
    LOOP
        WAIT UNTIL clk = '1'; EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN (cars = true) AND (i = long);
        IF i /= long THEN
            i := i + 1;
        END IF;
    END LOOP;

    -- Yellow phase for highway --

    HYGL <= false; HYYL <= true;  HYRL <= false;
    FGL  <= false; FYL  <= false; FRL  <= true;
    i := 0;
    LOOP
        WAIT UNTIL clk = '1'; EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN (i >= 4);
        i := i + 1;
    END LOOP;

    -- Red phase for highway --

    HYGL <= false; HYYL <= false; HYRL <= true;
    FGL  <= true;  FYL  <= false; FRL  <= false;
    i := 0;
    LOOP
        WAIT UNTIL clk = '1'; EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN (cars /= true) OR (i = long);
        IF i /= long THEN
            i := i + 1;
        END IF;
    END LOOP;

    -- Yellow phase for farmroad --
     
    HYGL <= false; HYYL <= false; HYRL <= true;
    FGL  <= false; FYL  <= true;  FRL  <= false;
    i := 0;
    LOOP
        WAIT UNTIL clk = '1'; EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN (i >= 4);
        i := i + 1;
    END LOOP;
   
  END LOOP RESET_LOOP;

  END PROCESS highway;
END algorithm;
