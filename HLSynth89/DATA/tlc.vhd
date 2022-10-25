
package traffic_light is
  subtype Light is BIT_VECTOR(0 to 1);
  constant Red    : Light := B"00";
  constant Green  : Light := B"01";
  constant Yellow : Light := B"10";
end traffic_light;

use std.simulator_standard.all;
use work.traffic_light.all;

entity tlc is
  port (hicar, sidecar : in bit;
        hili           : out Light := Green;
        sideli         : out Light := Red);

end tlc;

architecture behavior of tlc is
begin

  process
  begin

    --
    -- highway is green, sidestreet is red
    --
    wait on hicar,sidecar until (sidecar = '1');
    if (hicar = '1')
      then wait until (hicar = '0') for 20sec;
    end if;
    hili <= Yellow;

    --
    -- highway is yellow, sidestreet is red
    --
    if (hicar = '1')
      then wait until (hicar = '0') for 5sec;
    end if;
    hili <= Red;
    sideli <= Green;

    --
    -- highway is red, sidestreet is green
    --
    wait on hicar,sidecar until (hicar = '1');
    if (sidecar = '1')
      then wait until (sidecar = '0') for 10sec;
    end if;
    sideli <= Yellow;

    --
    -- highway is red, sidestreet is yellow
    --
    if (sidecar = '1')
      then wait until (sidecar = '0') for 5sec;
    end if;
    sideli <= Red;
    hili <= Green;
  end process;

end behavior;



