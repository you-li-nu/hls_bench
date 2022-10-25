--------------------------------------------------------------------------------
--
-- GCD factorization Benchmark
--
-- Source:  "Algorithmics by Brassard and Bradley "
--
-- VHDL Benchmark author: Champaka Ramachandran on Sept 11 1992 
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes   Champaka Ramachandran  11th Sept 92    ZYCAD
--  Functionality     yes   Champaka Ramachandran  11th Sept 92    ZYCAD
--------------------------------------------------------------------------------

use work.BIT_FUNCTIONS.all;

entity GCD is 
 port (X, Y           : in bit_vector(7 downto 0);
       Reset          : in bit;
       gcd_output     : out bit_vector(7 downto 0));
end GCD;

architecture GCD of GCD is 
begin 

process(X, Y, Reset)

variable xvar,yvar :  bit_vector (7 downto 0);
variable resetvar  :  bit;
variable compare_var : bit_vector (1 downto 0);

begin
  
  xvar := X;
  yvar := Y;
  resetvar := Reset;

  if (xvar = "00000000") then
    gcd_output <= "00000000";
  end if;

  if (yvar = "00000000") then
    gcd_output <= "00000000";
  end if;

-- The GCD factorization takes place only if Reset = 0

  if (resetvar = '0') and (xvar /= "00000000") and (yvar /= "00000000") then

    compare_var := COMPARE(xvar, yvar);

-- If compare returns 11 then inputs are equal
-- If compare returns 10 then xvar > yvar
-- If compare returns 01 then xvar < yvar

    while (compare_var /= "11") loop

-- Loop till the numbers are equal

      if (compare_var = "01") then 
        yvar := yvar - xvar;
      else 
        xvar := xvar - yvar;
      end if;

      compare_var := COMPARE(xvar, yvar);
    end loop;
    
    gcd_output <= xvar;

  else
    gcd_output <= "00000000";
  end if;

end process;

end GCD;


