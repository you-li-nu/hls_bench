
use work.vvectors.all;

entity counter is
 port (clock : in bit;
       countin   : in bit4;
       up, count : in bit;
       countout  : out bit4);
end counter;


architecture behavior of counter is 
begin

  process 
    variable i: bit4 := 0;
  begin
    wait until clock = '1';
    countout <= i;
    if (count = '1')
      then if (up = '1')
             then if (i = bit4'high)
                    then i := bit4'low;
                    else i := i+1;
                  end if;
             else if (i = bit4'low)
                    then i := bit4'high;
                    else i := i-1;
                  end if;
           end if;
      else i := countin;
    end if;
  end process;

end behavior;

