--**VHDL*************************************************************
--
-- SRC-MODULE : GCD
-- NAME       : gcd.vhdl
-- VERSION    : 1.0
--
-- PURPOSE    : Architecture of GCD benchmark
--
-- LAST UPDATE: Wed May 19 13:03:48 MET DST 1993
--
--*******************************************************************
--
-- Architecture of GCD
--
PACKAGE types IS
  SUBTYPE nat8 is integer RANGE 255 DOWNTO 0;
END types;

USE work.types.all;

ENTITY gcd IS
PORT(reset : IN bit;          -- Global reset
     clk   : IN bit;          -- Global clock
     rst   : IN boolean;
     xin   : IN nat8;    
     yin   : IN nat8;   
     rdy   : OUT boolean;   
     oup   : OUT nat8);  
END gcd;

ARCHITECTURE algorithm OF gcd IS
BEGIN
  gcd: PROCESS
    VARIABLE   x  : nat8;
    VARIABLE   y  : nat8;
    VARIABLE   h  : nat8;
  BEGIN 

    rdy <= true;
    oup <= 0;
    
  RESET_LOOP : LOOP 

    WAIT UNTIL clk = '1'; EXIT RESET_LOOP WHEN reset = '1';
    
    WHILE (rst = true) LOOP
        x := xin;
        y := yin;
        WAIT UNTIL clk = '1'; EXIT RESET_LOOP WHEN reset = '1';
    END LOOP;

    rdy <= false;
    oup <= 0;

    IF (x /= 0) AND (y /= 0) THEN
        WHILE (y /= 0) LOOP
            WHILE (x >= y) LOOP
                WAIT UNTIL clk = '1'; EXIT RESET_LOOP WHEN reset = '1';
                x := x - y;
            END LOOP;
            h := x; x := y; y := h;
        END LOOP;
    END IF;

    rdy <= true;   
    oup <= x;

  END LOOP RESET_LOOP;

  END PROCESS gcd;
END algorithm;
