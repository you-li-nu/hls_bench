
use work.vvectors.all;
use std.simulator_standard.all;

entity pf_control is end;

architecture struct of pf_control is 

 component prefetch
   port (clock          : in bit;
         branchpc, ibus : in bit32;
         branch, ire    : in bit;
         pct, irt, ia   : out bit32);
 end component;

  signal clk           : bit   := '0';
  signal bpc, ib       : bit32 :=  0 ;
  signal bflg, ird     : bit   := '0';
  signal pc, ins, iad  : bit32 :=  0 ;

  for only : prefetch use entity work.prefetch(behavior);

  begin

    only: prefetch
     port map (clk,bpc,ib,bflg,ird,pc,ins,iad);

    --
    -- Waveforms for inputs
    --
    bpc <= 500 after 10sec;
    ib <= (ib + 1) after 2sec;
    ird <= '1' after 1sec, '0' after 2sec when ((clk = '1') and (ib > 1))
      else '0';
    bflg <= '1' after 11sec, '0' after 12sec;

    --
    -- The Clock
    --
    myclock:
     clk <= '1' after 1sec when clk = '0' else
            '0' after 1sec;

    --
    -- Termination
    --
    stopper:
      process begin
        wait for 50sec;
        std.simulator_standard.terminate;
      end process;

  end struct;
               



