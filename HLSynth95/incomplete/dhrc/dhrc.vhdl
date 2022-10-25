-- VHDL description of Differential Heat Release Computation
--
-- Author: Loganathan Ramchandran, University of California, Irvine
--		Translated from Silage description [CaSv93]
--
-- Last Modified: 27 Jan 95  By Preeti R. Panda 
--				(removed VSS specific constructs)
--
-- Verification Information:
--
--                  Verified     By whom?           Date        Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Preeti R. Panda      27 Jan 95    Synopsys
--  Functionality     No

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity DHRC is 
        port (
                a0_in  : in UNSIGNED(15 downto 0);
                a1_in  : in UNSIGNED(15 downto 0);
                a2_in  : in UNSIGNED(15 downto 0);
                p339_in  : in UNSIGNED(15 downto 0);
                p340_in  : in UNSIGNED(15 downto 0);
                p_in  : in UNSIGNED(15 downto 0);
                HOST_OUT : out UNSIGNED(15 downto 0)
               );
end DHRC;

--VSS: design_style FUNCTIONAL

architecture aDHRC of DHRC is 

begin

process
        type Memory is array (integer range <>) of UNSIGNED(15 downto 0);


        variable V    : Memory(468 downto 0);        
        variable P    : Memory(468 downto 0);        
        variable DV   : Memory(468 downto 0);        
        variable BV1 : Memory(468 downto 0);        

        variable A0 : UNSIGNED(15 downto 0); 
        variable A1 : UNSIGNED(15 downto 0); 
        variable A2 : UNSIGNED(15 downto 0); 

        variable H1 : UNSIGNED(31 downto 0); 
        variable H2 : UNSIGNED(15 downto 0); 
        variable H3 : UNSIGNED(15 downto 0); 
        variable H4 : UNSIGNED(31 downto 0); 
        variable H5 : UNSIGNED(15 downto 0); 
        variable H6 : UNSIGNED(15 downto 0); 
        variable H7 : UNSIGNED(15 downto 0); 
        variable H8 : UNSIGNED(31 downto 0); 
        variable H9 : UNSIGNED(15 downto 0); 

        variable S : UNSIGNED(31 downto 0); 
        variable S1 : UNSIGNED(31 downto 0); 
        variable S2 : UNSIGNED(31 downto 0); 


        variable CV : UNSIGNED(15 downto 0); 
        variable DP : UNSIGNED(15 downto 0); 

        variable D  : UNSIGNED(15 downto 0); 
        variable I  : integer;
        variable J  : integer; 
        variable K  : integer;



begin

wait on         a0_in,
                a1_in ,
                a2_in ,
                p339_in, 
                p340_in , 
                p_in ;

      a0 := a0_in;
      a1 := a1_in;
      a2 := a2_in;
      p(339) := p339_in ;
      p(340) := p340_in ;
      s := CONV_UNSIGNED (0, s'length);
      cv := CONV_UNSIGNED (0, cv'length);
      h7 := CONV_UNSIGNED (0, h7'length);
      h6 := CONV_UNSIGNED (0, h6'length);
      h4 := CONV_UNSIGNED (0, h4'length);
      dp := CONV_UNSIGNED (0, dp'length);
      i := 340;
      while (i < 468) loop
        j := i + 1;
        k := i - 1;
        p(j) := P_IN;
        d  := p(j)  - p (k);
        dp := SHR (d, CONV_UNSIGNED (2, 2)); 
        h1 := a0 * V(i);
        h2 := SHR (h1, CONV_UNSIGNED (14, 4));
        h3 := a1+ h2;
        h4 := h3 * P(i); 
        s2 := dp * v(i);
        h7 := SHR (s2,  CONV_UNSIGNED (12, 4));
        h5 := SHR (h4,  CONV_UNSIGNED (12, 4));
        cv := h5 + a2;
        s1 := p(i) * dv(i);
        h6 := SHR (s1,  CONV_UNSIGNED (12, 4));
        s  := h6 + h7;
        h8 := s * cv;
        h9 := SHR (h8,  CONV_UNSIGNED (11, 4));
        bv1(i) := h9 + h6;
        host_out <= bv1(i);
	i := i + 1;
    end loop;

end process;

end aDHRC  ;
