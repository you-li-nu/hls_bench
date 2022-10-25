--**VHDL*************************************************************
--
-- SRC-MODULE : FANCY
-- NAME       : fancy.vhdl
-- VERSION    : 1.0
--
-- PURPOSE    : Architecture of FANCY benchmark
--
-- LAST UPDATE: Wed May 19 13:03:48 MET DST 1993
--
--*******************************************************************
--
-- Architecture of FANCY
--

PACKAGE types IS
  SUBTYPE nat8 is integer RANGE 0 TO 255;
END types;

USE work.types.all;

ENTITY fancy IS
PORT(reset    : IN bit;          -- Global reset
     clk      : IN bit;          -- Global clock
     startinp : IN boolean;
     ainp     : IN nat8;
     binp     : IN nat8;   
     cinp     : IN nat8;
     eoc      : OUT boolean; 
     f        : OUT nat8);                
END fancy;

ARCHITECTURE algorithm OF fancy IS
BEGIN
  fancy: PROCESS
    VARIABLE   temp1a, temp1b, temp3, temp4, temp6a : nat8;                
    VARIABLE   a, b, c, counter : nat8;
    VARIABLE   start            : boolean;
  BEGIN 

    eoc <= true;
    f <= 0;

  RESET_LOOP : LOOP 
    WAIT UNTIL clk = '1'; EXIT RESET_LOOP WHEN (reset = '1');
    a := ainp;
    b := binp;
    c := cinp;
    start := startinp;

    temp1a  := 0;
    counter := 0;
    eoc <= false;
    WHILE (counter < b) LOOP
        IF (a <= counter) THEN
            IF (a <= counter) THEN
                temp6a := b;
            ELSE
                temp6a := temp1a;
            END IF;
        ELSE
            temp6a := a;
        END IF;

        IF ((temp1a = 0) XOR (a > counter) XOR (a <= counter) XOR start) THEN
            temp1b := c;
        ELSE
            IF (a > b) THEN
                temp1b := a;
            ELSE
                temp1b := b;
            END IF;
        END IF;

        IF start THEN
            temp4 := temp1b;
        ELSE
            temp4 := temp6a;
        END IF;

        IF (start XOR (a > b)) THEN
            IF (b > c) THEN
                temp3 := c;
            ELSE
                temp3 := b;
            END IF;
        ELSE
            temp3 := temp1b;
        END IF;

        IF ((temp1a = 0) XOR (a > counter) XOR (a <= counter)) THEN
            temp1a := temp4 + temp3;
        ELSE
            IF ((a > b) XOR (b > c)) THEN
                temp1a := temp4 + temp1a;
            ELSE
                temp1a := temp4 + a;
            END IF;
        END IF;
        counter := counter + 1;

        WAIT UNTIL clk = '1'; EXIT RESET_LOOP WHEN (reset = '1');
    END LOOP;

    f   <= temp1a;
    eoc <= true;

  END LOOP RESET_LOOP;

  END PROCESS fancy;
END algorithm;




