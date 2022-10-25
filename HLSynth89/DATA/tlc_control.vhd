
use work.traffic_light.all;
use std.simulator_standard.all;

entity tlc_control is end;

architecture struct of tlc_control is 

  component tlc 
    port (hicar, sidecar : in bit;
          hili           : out Light := Green;
          sideli         : out Light := Red);

  end component;

  signal highway, sideway : bit;
  signal hlight,  slight  : Light;

  for only : tlc use entity work.tlc(behavior);

  begin

    only: tlc
     port map (highway, sideway,
               hlight, slight);

    highway <= '1' after 2sec when (hlight = Red) else
	       '0' after 20sec;

    sideway <= '1' after 10sec when (slight = Red) else
	       '0' after 10sec;

    stopper: 
      process begin
	wait for 500sec;
        std.simulator_standard.terminate;
      end process;

  end struct;
               


