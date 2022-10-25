
use work.vvectors.all;
use std.simulator_standard.all;

entity gcd_control is end;

architecture struct of gcd_control is 

 component gcd
   port (xi, yi : in bit16;
         rst    : in bit;
         ou     : out bit16);
 end component;

  signal first,second : bit16;
  signal clk : bit;
  signal answer : bit16;

  for only : gcd use entity work.gcd(behavior);

  begin

    only: gcd
     port map (first, second, clk, answer);

    --
    -- Waveforms for inputs
    --
    first <= 20 after 10sec, 7 after 15sec, 8 after 20sec;
    second <= 15 after 10sec, 490 after 15sec, 63 after 20sec;

    --
    -- The Clock
    --
    myclock:
     clk <= '1' after 300ms when clk = '0' else
            '0' after 300ms;

    --
    -- Termination
    --
    stopper:
      process begin
        wait for 50sec;
        std.simulator_standard.terminate;
      end process;

  end struct;
               



