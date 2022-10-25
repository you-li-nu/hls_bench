--**VHDL*************************************************************
--
-- SRC-MODULE : BARCODE
-- NAME       : barcode.vhdl
-- VERSION    : 1.1
--
-- PURPOSE    : Architecture of BARCODE benchmark
--
-- LAST UPDATE: Mon May 24 12:36:10 MET DST 1993
--
--*******************************************************************
--
-- Architecture of BARCODE

PACKAGE barcode_types IS
  SUBTYPE nat8 is integer RANGE 255 DOWNTO 0;
END barcode_types;

USE work.barcode_types.all;

ENTITY barcode IS
PORT(reset : IN  bit;         -- Global reset
     clk   : IN  bit;         -- Global clock
     scan  : IN  boolean;     -- The scan signal of a ccd or laser scanner
     video : IN  bit;         -- The video signal   "     "     "     "   
     start : IN  boolean;     -- Start of converion signal of a microproc.
     num   : IN  nat8;        -- Given number of black-white transitions  
     eoc   : OUT boolean;     -- End of conversion signal to a microproc. 
     memw  : OUT boolean;     -- Write signal for a memory                
     data  : OUT nat8;        -- Data which should be written to a memory 
     addr  : OUT nat8);       -- Address signals for a memory             
END barcode;

ARCHITECTURE algorithm OF barcode IS
BEGIN
  barcode: PROCESS
    VARIABLE   white  : nat8;    -- Counts the width of white bars
    VARIABLE   black  : nat8;    -- Counts the width of black bars
    VARIABLE   actnum : nat8;    -- Counts the number of bl-wh transitions  
    VARIABLE   flag   : bit;     -- Flag for recognizing a bl-wh transition 
    CONSTANT   wh     : bit := '0';  
    CONSTANT   bl     : bit := '1';
  BEGIN 
    eoc <= false; memw <= false;
    data <= 0; addr <= 0;

  RESET_LOOP: LOOP

    LOOP
      WAIT UNTIL clk='1'; EXIT RESET_LOOP WHEN (reset = '1');
      EXIT WHEN start;
    END LOOP;

    LOOP
      LOOP
        WAIT UNTIL clk='1'; EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN scan;
      END LOOP;
      flag := wh; actnum := 0; white := 0; black := 0;
      eoc <= false;
      LOOP
        IF video = wh THEN
          WAIT UNTIL clk='1'; EXIT RESET_LOOP WHEN (reset = '1');
          white := white + 1;
          IF flag = bl THEN
            actnum := actnum + 1;
            memw   <= false;
          ELSE
            memw   <= true;
          END IF;
          black := 0;
          flag := wh;
          data <= white;
        ELSE
          WAIT UNTIL clk='1'; EXIT RESET_LOOP WHEN (reset = '1');
          black := black + 1;
          IF flag = wh THEN
            actnum := actnum + 1;
            memw   <= false;
          ELSE
            memw   <= true;
          END IF;
          flag := bl;
          white := 0;
          data <= black;
        END IF;

        addr <= actnum;
      EXIT WHEN (white = 255) OR (black = 255); END LOOP;
    EXIT WHEN (actnum = num) AND (white = 255); END LOOP;
    memw <= false; eoc <= true;
    LOOP
      WAIT UNTIL clk='1'; EXIT RESET_LOOP WHEN (reset = '1');
      EXIT WHEN start = false;
    END LOOP;

  END LOOP RESET_LOOP;

  END PROCESS;
END algorithm;
