--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Connection Model between memory model and
--                         Prawn CPU Behavioral Model for simulation
--
-- Derived from
--           Parwan : a reduced processor
--           from Chapter 9 of NAVABI : "VHDL: Analysis and Modeling of
--           Digital Systems" MacGraw-Hill,Inc. 1993
--
-- Author: Tadatoshi Ishii
--         Information and Computer Science,
--         University Of California, Irvine, CA 92717
--
-- Developed on Nov 1, 1992
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Tadatoshi Ishii      01 Nov 92    Synopsys
--  Functionality     yes     Tadatoshi Ishii	   01 Nov 92    Synopsys
--------------------------------------------------------------------------------

library work;
use work.TYPES.all;
use work.LIB.all;

entity SIM is
end;

architecture INPUT_OUTPUT of SIM is
  component PRAWN
    port (
	  clk 		      : in    MVL7;
	  rst	 	      : in    MVL7;
	  read_mem, write_mem : out   MVL7;
	  databus 	      : inout WIRED_BYTE;
	  adbus 	      : out   TWELVE;
	  interrupt	      : in    MVL7;
	  inta		      : out   MVL7
    );
  end component;

  component PLANKTON
    port (
	  read_mem, write_mem : in    MVL7;
	  databus	      : inout WIRED_BYTE;
	  adbus		      : in TWELVE;
	  interrupt	      : out    MVL7;
	  inta		      : in   MVL7
    );
  end component;

  for cpu : PRAWN use entity WORK.CPU(BEHAVIORAL);
  for mem : PLANKTON use entity WORK.MEM(BEHAVIORAL);
--
  signal clock                  : MVL7 := '0';
  signal read, write            : MVL7;   
  signal interrupt, inta        : MVL7;
  signal rst                  	: MVL7 := '1';
  signal data                   : WIRED_BYTE;
  signal address                : TWELVE;
--
begin
  int : rst <= '1', '0' after 2100 ns;
  clk : clock <= not clock after 100 ns;
  cpu : PRAWN port map (clock, rst, read, write, data, address, interrupt, inta);
  mem : PLANKTON port map (read, write, data, address, interrupt, inta);
end INPUT_OUTPUT;
