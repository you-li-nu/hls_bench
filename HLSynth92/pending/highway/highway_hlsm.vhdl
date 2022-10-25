--**VHDL*************************************************************
--
-- SRC-MODULE : HIGHWAY
-- NAME       : highway_hlsm.vhdl
-- VERSION    : 1.0
--
-- PURPOSE    : Architecture of HIGHWAY benchmark
--               (high level state machine description)
--
-- LAST UPDATE: Mon May 24 10:42:32 MET DST 1993
--
--*******************************************************************
--
-- Architecture of HIGHWAY
--

ARCHITECTURE hlsm OF highway IS

  SUBTYPE nat3  IS integer RANGE 7 DOWNTO 0;
  TYPE    phase IS (green, hyy, red, fay);    -- green is the reset state!

BEGIN
  highway: PROCESS
    CONSTANT   false : bit  := '0';  
    CONSTANT   true  : bit  := '1';
    CONSTANT   long  : nat3 := 7;   -- delay for long time
    CONSTANT   short : nat3 := 4;   -- delay for short time
    VARIABLE   i     : nat3;        -- counter 
    VARIABLE   hwph  : phase;       -- contains traffic light phase
  BEGIN 

    hwph := green;
    HYGL <= '1'; HYRL <= '0'; HYYL <= '0';
    FGL  <= '0'; FRL  <= '1'; FYL  <= '0';

  RESET_LOOP : LOOP 

    -- Decode outputs for the traffic lights from
    -- the hwph variable
    CASE hwph IS
        WHEN green  => HYGL <= '1';
                       HYRL <= '0';
                       HYYL <= '0';
                       FGL  <= '0';
                       FRL  <= '1';
                       FYL  <= '0';
        WHEN hyy    => HYGL <= '0';
                       HYRL <= '0';
                       HYYL <= '1';
                       FGL  <= '0';
                       FRL  <= '1';
                       FYL  <= '0';
        WHEN fay    => HYGL <= '0';
                       HYRL <= '1';
                       HYYL <= '0';
                       FGL  <= '0';
                       FRL  <= '0';
                       FYL  <= '1';
        WHEN red    => HYGL <= '0';
                       HYRL <= '1';
                       HYYL <= '0';
                       FGL  <= '1';
                       FRL  <= '0';
                       FYL  <= '0';
    END CASE;  

    WAIT UNTIL clk = '1'; EXIT RESET_LOOP WHEN (reset = '1');

    IF ((hwph = green) AND (cars = true) AND (i = long)) THEN 
        i := 0; hwph := hyy;

    ELSIF ((hwph = hyy) AND (i >= 4)) THEN
        i := 0; hwph := red;

    ELSIF ((hwph = fay) AND (i >= 4)) THEN
        i := 0; hwph := green;

    ELSIF ((hwph = red) AND ((cars = false) OR (i = long))) THEN
        i := 0; hwph := fay;

    ELSIF i /= long THEN
        i := i + 1;
    END IF;

  END LOOP RESET_LOOP;

  END PROCESS;
END hlsm;
