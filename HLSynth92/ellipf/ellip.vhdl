----------------------------------------------------------------------------
--
--
--                   Elliptical Wave Filter Benchmark
--
--
-- VHDL Benchmark author: D. Sreenivasa Rao   
--                        University Of California, Irvine, CA 92717
--                        dsr@balboa.eng.uci.edu, (714)856-5106 
--                 
-- Developed on 12 September, 1992 
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes         DSR              09/12/92       ZYCAD
--  Functionality     yes         DSR              09/12/92       ZYCAD
-------------------------------------------------------------------------------

--use std.std_logic.all;
use work.bit_functions.all;

entity ellipf is 
    port ( inp : in BIT_VECTOR(15 downto 0);
           outp : out BIT_VECTOR(15 downto 0);
           sv2, sv13, sv18, sv26, sv33, sv38, sv39 :
                 in BIT_VECTOR(15 downto 0);
           sv2_o, sv13_o, sv18_o, sv26_o, sv33_o, sv38_o, sv39_o : 
                 out bit_vector(15 downto 0)); 
end ellipf;

architecture ellipf of ellipf is 

begin 

process (inp, sv2, sv13, sv18, sv26, sv33, sv38, sv39)

--  constant m1, m2, m3, m4, m5, m6, m7, m8 : integer := (1,1,1,1,1,1,1,1);  
    variable n1, n2, n3, n4, n5, n6, n7 : BIT_VECTOR(15 downto 0);
    variable n8, n9, n10, n11, n12, n13 : BIT_VECTOR(15 downto 0);
    variable n14, n15, n16, n17, n18, n19 : BIT_VECTOR(15 downto 0);
    variable n20, n21, n22, n23, n24, n25 : BIT_VECTOR(15 downto 0);
    variable n26, n27, n28, n29 : BIT_VECTOR(15 downto 0); 
--    constant i : integer := (1);  

 begin
--  while (i = 1) LOOP 
    n1 := inp + sv2;
    n2 := sv33 + sv39;
    n3 := n1 + sv13;
    n4 := n3 + sv26;
    n5 := n4 + n2;
    n6 := n5 ;
    n7 := n5 ;
    n8 := n3 + n6;
    n9 := n7 + n2;
    n10 := n3 + n8; 
    n11 := n8 + n5;
    n12 := n2 + n9;
    n13 := n10 ;
    n14 := n12 ;
    n15 := n1 + n13;
    n16 := n14 + sv39;
    n17 := n1 + n15;
    n18 := n15 + n8;
    n19 := n9 + n16;
    n20 := n16 + sv39;
    n21 := n17 ; 
    n22 := n18 + sv18;
    n23 := sv38 + n19;
    n24 := n20 ;
    n25 := inp + n21;
    n26 := n22 ;
    n27 := n23 ;
    n28 := n26 + sv18;
    n29 := n27 + sv38; 
    sv2_o <= n25 + n15;
    sv13_o <= n17 + n28;
    sv18_o <= n28;
    sv26_o <= n9 + n11; 
    sv38_o <= n29;
    sv33_o <= n19 + n29;
    sv39_o <= n16 + n24;
    outp <= n24;
--   end LOOP; 
 end process;

end ellipf;

--configuration ellipcon of ellipf is
--  for ellip_beh
--  end for;
--end ellipcon;



