--**VHDL*************************************************************
--
-- SRC-MODULE : QRS_TPYES
-- NAME       : qrs_types.vhdl
-- VERSION    : 1.1
--
-- PURPOSE    : Package with type declaration for QRS Chip
--
-- LAST UPDATE: Thu Feb 11 09:11:15 1993
--
--*******************************************************************
--
-- PackageEntity qrs_types
--

PACKAGE qrs_types IS
    SUBTYPE int16 IS integer RANGE  32767 DOWNTO -32768; --  16 bit integer
    SUBTYPE nat4  IS integer RANGE     15 DOWNTO 0;      --  4 bit unsigned int
    SUBTYPE nat2  IS integer RANGE      3 DOWNTO 0;      --  2 bit unsigned int
END qrs_types;
