
use work.vvectors.all;
use std.simulator_standard.all;

entity count_control is end;

architecture struct of count_control is 

  component counter
    port (clock : in bit;
          countin   : in bit4;
          up, count : in bit;
          countout  : out bit4);
  end component;

  signal cin,cout : bit4;
  signal u,c : bit;
  signal clk : bit;

  for only : counter use entity work.counter(behavior);

  begin

    only: counter
     port map (clk, cin, u, c, cout);

    --
    -- Waveforms for inputs
    --
    cin <= 1 after 2sec, 10 after 100sec;

    u <= '1' after 2sec, '0' after 100sec;
   
    c <= '1' after 2sec, '0' after 150sec;

    --
    -- The Clock
    --
    myclock:
     clk <= '1' after 3sec when clk = '0' else
            '0' after 1sec;

    --
    -- Termination
    --
    stopper:
      process begin
        wait for 200sec;
        std.simulator_standard.terminate;
      end process;

  end struct;
               



