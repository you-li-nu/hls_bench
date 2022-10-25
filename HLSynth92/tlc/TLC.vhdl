--------------------------------------------------------------------------------
--
-- Traffic Light Controller (TLC)
--
-- Source:  Hardware C version  written by David Ku on June 8, 1988 at Stanford
--
-- VHDL Benchmark author Champaka Ramachandran
--                       University Of California, Irvine, CA 92717
--                       champaka@balboa.eng.uci.edu
--                 
-- Developed on Aug 11, 1992
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes    Champaka Ramachandran  Aug 11, 92    ZYCAD
--  Functionality     yes    Champaka Ramachandran  Aug 11, 92    ZYCAD
--------------------------------------------------------------------------------

entity TLC is 
	port (
               Cars : in  BIT;
               TimeoutL : in  BIT;
               TimeoutS : in  BIT;
               StartTimer : out  BIT;
               HiWay : out  BIT_VECTOR(2 downto 0);
               FarmL : out  BIT_VECTOR(2 downto 0);
               state : out  BIT_VECTOR(2 downto 0) := "111"
             );
end TLC;

architecture TLC of TLC is 


begin

-------------------------------------------------------------------
traffic:process

  variable newstate, current_state : BIT_VECTOR(2 downto 0) := "111";
  variable newHL, newFL : BIT_VECTOR(2 downto 0 );
  variable newST : BIT;

begin

   current_state := newstate;


-- combinational logic to determine nextstate 

   case current_state is 

     when "000" =>  newHL := "100";  newFL := "110";
                          if (Cars = '1') and (TimeoutL = '1') then  
                          newstate := "100"; newST := '1';
                          else 
                            newstate := "000"; newST := '0';
                          end if;

     when "100" =>  newHL := "010"; newFL := "110";
                           if (TimeoutS = '1') then
                             newstate := "010"; newST := '1';
                           else
                             newstate := "110"; newST := '0';
                           end if;

     when "010" =>    newHL := "110"; newFL := "100";
                           if (Cars = '0') or (TimeoutL = '1') then
         		     newstate :="110"; newST := '1';
             	           else 
                             newstate := "010"; newST := '0';
                           end if;

     when "110" =>   newHL := "110"; newFL := "010";
                           if (TimeoutS = '1') then
                             newstate := "000"; newST := '1';
            	           else 
                             newstate := "110"; newST := '0';
                           end if;

     when "111" => 
                           newstate := "000";
                           newHL := "000";
                           newFL := "000";
                           newST := '0';
     when others =>

     end case;

  state <= newstate;
  HiWay <= newHL;
  FarmL <= newFL;
  StartTimer <= newST;
  wait for 10 ns;

end process traffic ;
-------------------------------------------------------------------
end TLC;









