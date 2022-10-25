--**VHDL*************************************************************
--
-- SRC-MODULE : QRS
-- NAME       : qrs.vhdl
-- VERSION    : 1.1
--
-- PURPOSE    : Entity of QRS Chip
--
-- LAST UPDATE: Thu Feb 11 09:44:45 1993
--
--*******************************************************************
--
-- Entity of QRS
--
USE work.qrs_types.all;

ENTITY qrs IS
PORT (reset  : IN     bit;                 -- Global reset
      clk    : IN     bit;                 -- Global clock
      data   : IN     int16;               -- Data bus (input only, 16 pins)
      we     : IN     boolean;             -- Write-Enable, indicating valid data on Data 15-0
      rc     : IN     boolean;             -- Restart Command
      rdy    : OUT    boolean;             -- Ready to read data
      fl3o   : OUT    nat2;
      RRpeak : OUT    boolean;             -- Peak signal
      RRo    : OUT    int16);              -- Number of cycles between peaks
END qrs;
