--------------------------------------------------------------------------------
--
-- Kalman Filter Benchmark
--
-- Source: Adapted from the paper
--        "A Synthesis Process applied to the Kalman Filter BEnchmark"
--         by Cleland.O.Newton, DRA Malvern, UK
--         HLSW-92
--
-- VHDL Benchmark author: Champaka Ramachandran on Aug 18th 1992 
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes   Champaka Ramachandran  18th Aug 92    ZYCAD
--  Functionality     yes   Champaka Ramachandran  18th Aug 92    ZYCAD
--------------------------------------------------------------------------------

use work.BIT_FUNCTIONS.all;

entity KALMAN is
   port (Input_Vector: in BIT_VECTOR (15 downto 0);
         Addr        : in integer;
         Cexec       : in BIT;
         Vector_type : in BIT_VECTOR (2 downto 0);
         Output_Vector0 : out BIT_VECTOR (15 downto 0);
         Output_Vector1 : out BIT_VECTOR (15 downto 0);
         Output_Vector2 : out BIT_VECTOR (15 downto 0);
         Output_Vector3 : out BIT_VECTOR (15 downto 0));
end KALMAN;

--VSS: design_style BEHAVIORAL

architecture KALMAN of KALMAN is

begin

P1 : process (Addr, Cexec)

type Memory is array (integer range <>) of BIT_VECTOR (15 downto 0);

   variable A, K :  Memory (255 downto 0);  -- Constant
   variable G : Memory (63 downto 0);       -- Constant
   variable Y : Memory (15 downto 0);   -- Input vector
   variable X : Memory (15 downto 0);       -- State vector
   variable V : Memory (3 downto 0);        -- output vector 
   variable i, j, index : integer ;
   variable temp : BIT_VECTOR (15 downto 0);

begin

--  Loading coefficient array A, G and K and input vector Y

  case Vector_type is 

--  Load A matrix which is 16x16 and is upper diagonal
     when "001" =>            A(Addr) := Input_Vector;
                          
--  Load K matrix which is 16x13 , but is padded with 0s to make it 16x16
     when "010" =>            K(Addr) := Input_Vector;

--  Load G matrix which is 4x16
     when "011" =>            G(Addr) := Input_Vector;

--  Load Y matrix which is 1x13 and is the input vector and is padded with 0s
--  to make it 1x16
     when "100" =>            Y(Addr) := Input_Vector;

     when others =>

  end case;


-- Initializing state Vector X 

  if (Cexec = '1') then
    i := 0;
    while (i < 16) loop
      X(i) := "0000000000000000";
      i := i + 1;
    end loop;
  end if;

  if (Cexec = '1') then
    i := 13;
    while (i < 16) loop
      Y(i) := "0000000000000000";
      i := i + 1;
    end loop;
  end if;

-- Computing state Vector X 

  if (Cexec = '1') then
    i := 0;
    while (i < 16) loop
      j := 0; 
      temp := "0000000000000000";

      while (j < 16) loop
        index := i * 16 + j;
        temp := A(index) * X(j) + K(index) * Y(j) + temp;
        j := j + 1;
      end loop;

      X(i) := temp;
      i := i + 1;
    end loop;
  end if;

-- Computing output Vector V

  if (Cexec = '1') then
    i := 0;
    while (i < 4) loop
      j := 0; 
      temp := "0000000000000000";

      while (j < 16) loop
        index := i * 16 + j;
        temp := G(index) * X(j) + temp;    
        j := j + 1;
      end loop;

      V(i) := temp * Y(i+1);
      i := i + 1;
    end loop;
  end if;


-- Output Vector V 

  if (Cexec = '1') then
    Output_Vector0 <= V(0);
    Output_Vector1 <= V(1);
    Output_Vector2 <= V(2);
    Output_Vector3 <= V(3);
  end if;  

end process P1;

end KALMAN;





