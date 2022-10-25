
use work.vvectors.all;

entity gcd is 
 port (xi, yi : in bit16;
       rst    : in bit;
       ou     : out bit16);
end gcd;

architecture behavior of gcd is 
begin 

  process
   variable x,y: integer;

  begin
    wait until (rst = '0');

    x := xi;
    y := yi;

    while (x /= y) loop
      if (x < y)
        then y:=y-x;
        else x:=x-y;
      end if;
    end loop;
    
    ou <= x;
  end process;

end behavior;


