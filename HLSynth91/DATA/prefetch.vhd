
use work.vvectors.all;

entity prefetch is
  port (clock          : in bit;
        branchpc, ibus : in bit32;
        branch, ire    : in bit;
        pct, irt, ia   : out bit32);
end prefetch;

architecture behavior of prefetch is 
begin

  process 
   variable ir,pc,oldpc : bit32 := 0;

  begin

   -- 
   -- wait for rising edge of clock
   -- 
    wait until (clock = '1');

   --
   -- output current state
   --
    pct <= oldpc;
    ia  <= pc;
    irt <= ir;

   --
   -- determine next state
   --
    if (branch = '1')
     then
      pc := branchpc;
      ia <= pc;
    end if;

   --
   -- wait for instruction enable
   --
    wait until (ire = '1');

   --
   -- update state
   --
    ir := ibus;
    oldpc := pc;
    pc := pc + 4;

  end process;  

end behavior;

