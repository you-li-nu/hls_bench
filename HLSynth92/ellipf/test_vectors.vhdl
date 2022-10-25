----------------------------------------------------------------------------
--
--
--         Elliptical Wave Filter Benchmark : Test Patterns
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


Entity E is
end;

--use work.ellip.all;   

architecture A of E is
       Component ellipf 
       port (
                       inp : in  BIT_VECTOR(15 downto 0);
                       outp : out  Bit_Vector(15 Downto 0);
                       sv2 : in  bit_vector(15 downto 0); 
                       sv13 : in  Bit_Vector(15 Downto 0);
                       sv18 : in  Bit_Vector(15 Downto 0);
                       sv26 : in  Bit_Vector(15 Downto 0);
                       sv33 : in  Bit_Vector(15 Downto 0);
                       sv38 : in  Bit_Vector(15 Downto 0);
                       sv39 : in  Bit_Vector(15 Downto 0);
                        sv2_o : out  bit_vector(15 downto 0);
                       sv13_o : out Bit_Vector(15 Downto 0);
                       sv18_o : out  Bit_Vector(15 Downto 0);
                       sv26_o : out  Bit_Vector(15 Downto 0);
                       sv33_o : out  Bit_Vector(15 Downto 0);
                       sv38_o : out  Bit_Vector(15 Downto 0);
                       sv39_o : out  Bit_Vector(15 Downto 0)

       );
       end component ;


                     signal inp : BIT_VECTOR(15 downto 0);
                     signal outp : Bit_Vector(15 Downto 0);
                     signal sv2 : bit_vector(15 downto 0); 
                     signal sv13 : Bit_Vector(15 Downto 0);
                     signal sv18 : Bit_Vector(15 Downto 0);
                     signal sv26 : Bit_Vector(15 Downto 0);
                     signal sv33 : Bit_Vector(15 Downto 0);
                     signal sv38 : Bit_Vector(15 Downto 0);
                     signal sv39 : Bit_Vector(15 Downto 0); 
                     signal sv2_o : bit_vector(15 downto 0);
                     signal sv13_o : Bit_Vector(15 Downto 0);
                     signal sv18_o : Bit_Vector(15 Downto 0);
                     signal sv26_o : Bit_Vector(15 Downto 0);
                     signal sv33_o : Bit_Vector(15 Downto 0);
                     signal sv38_o : Bit_Vector(15 Downto 0);
                     signal sv39_o : Bit_Vector(15 Downto 0);


for all : ellipf use entity work.ellipf(ellipf) ;

begin

INST1 : ellipf port map (
                       inp,
                       outp,
                       sv2,
                       sv13,
                       sv18,
                       sv26,
                       sv33,
                       sv38,
                       sv39,
                       sv2_o, sv13_o, sv18_o, sv26_o, sv33_o,
                       sv38_o, sv39_o
                    );

process
begin

-- ****************************************** 
-- *                                        * 
-- *           TEST VECTORS                 * 
-- *                                        * 
-- ****************************************** 
--
wait for 90 ns;
--
-- Pattern #0
inp <= "0000000000000010";
sv2 <= "0000000000000001";
sv13 <= "0000000000000010";
sv18 <= "0000000000000001";
sv26 <= "0000000000000010";
sv33 <= "0000000000000001";
sv38 <= "0000000000000010";
sv39 <= "0000000000000001";
wait for 100 ns;

assert (outp = "0000000000001111")
report
"Assert 0 : < outp /= 0000000000001111 >"
severity warning;

assert (sv2_o = "0000000000110001")
report
"Assert 0 : < sv2_o /= 0000000000110001 >"
severity warning;

Assert (sv13_o = "0000000000111111")
report
"Assert 0 : < sv13 /= 0000000000111111 >"
severity warning;

assert (sv18_o = "0000000000100110")
report
"Assert 0 : < sv18 /= 0000000000100110 >"
severity warning;

assert (sv26_o = "0000000000100010")
report
"Assert 0 : < sv26 /= 0000000000100010 >"
severity warning;
 
assert (sv33_o = "0000000000110110")
report
"Assert 0 : < sv33 /= 0000000000110110 >"
severity warning;

assert (sv38_o = "0000000000011101")
report 
"Assert 0 : < sv38 /= 0000000000011101 >"
severity warning; 
  
Assert (sv39_o = "0000000000011101") 
report 
"Assert 0 : < sv39 /= 0000000000011101 >" 
severity warning;

--
-- Pattern #1
inp <= "0000000000000001";
sv2 <= "0000000000000000";
sv13 <= "0000000000000000";
sv18 <= "0000000000000000";
sv26 <= "0000000000000000";
sv33 <= "0000000000000000";
sv38 <= "0000000000000000";
sv39 <= "0000000000000000";
wait for 100 ns;

assert (outp = "0000000000000001")
report
"Assert 1 : < outp /= 0000000000000001 >"
severity warning;

assert (sv2_o = "0000000000001010")
report
"Assert 1 : < sv2 /= 0000000000001010 >"
severity warning;

assert (sv13_o = "0000000000001011")
report
"Assert 1 : < sv13 /= 0000000000001011 >"
severity warning;

assert (sv18_o = "0000000000000110")
report
"Assert 1 : < sv18 /= 0000000000000110 >"
severity warning;

assert (sv26_o = "0000000000000100")
report
"Assert 1 : < sv26 /= 0000000000000100 >"
severity warning;
 
assert (sv33_o = "0000000000000100")
report
"Assert 1 : < sv33 /= 0000000000000100 >"
severity warning;
 
assert (sv38_o = "0000000000000010")
report
"Assert 1 : < sv38 /= 0000000000000010 >"
severity warning;

assert (sv39_o = "0000000000000010") 
report 
"Assert 1 : < sv39 /= 0000000000000010 >" 
severity warning;

--
-- Pattern #2
inp <= "0000000000000000";
sv2 <= "0000000000000001";
sv13 <= "0000000000000001";
sv18 <= "0000000000000001";
sv26 <= "0000000000000001";
sv33 <= "0000000000000001";
sv38 <= "0000000000000001";
sv39 <= "0000000000000001";
wait for 100 ns;

assert (outp = "0000000000001011")
report
"Assert 2 : < outp /= 0000000000001011 >"
severity warning;

assert (sv2_o = "0000000000010101")
report
"Assert 2 : < sv2 /= 0000000000010101 >"
severity warning;

assert (sv13_o = "0000000000011110")
report
"Assert 2 : < sv13 /= 0000000000011110 >"
severity warning;

assert (sv18_o = "0000000000010011")
report
"Assert 2 : < sv18 /= 0000000000010011 >"
severity warning;

assert (sv26_o = "0000000000010011")
report
"Assert 2 : < state /= 0000000000010011 >"
severity warning;

assert (sv33_o = "0000000000100100")
report
"Assert 2 : < sv33 /= 0000000000100100 >"
severity warning;
 
assert (sv38_o = "0000000000010011")
report
"Assert 2 : < sv38 /= 0000000000010011 >"
severity warning;
 
assert (sv39_o = "0000000000010101")
report
"Assert 2 : < sv39 /= 0000000000010101 >"
severity warning;

--
-- Pattern #3
inp <= "0000000000000000";
sv2 <= "0000000000001010";
sv13 <= "0000000000001100";
sv18 <= "0000000000000110";
sv26 <= "0000000000001000";
sv33 <= "0000000000001000";
sv38 <= "0000000000000010";
sv39 <= "0000000000000010";
wait for 100 ns;

assert (outp = "0000000001000000")
report
"Assert 3 : < outp /= 0000000001000000 >"
severity warning;

assert (sv2_o = "0000000011000110")
report
"Assert 3 : < sv2 /= 0000000011000110 >"
severity warning;

assert (sv13_o = "0000000100010000")
report
"Assert 3 : < sv13 /= 0000000100010000 >"
severity warning;

assert (sv18_o = "0000000010101000")
report
"Assert 3 : < sv18 /= 0000000010101000 >"
severity warning;

assert (sv26_o = "0000000010011000")
report
"Assert 3 : < sv26 /= 0000000010011000 >"
severity warning;
 
assert (sv33_o = "0000000011100100")
report
"Assert 3 : < sv33 /= 0000000011100100 >"
severity warning;
 
assert (sv38_o = "0000000001110100")
report
"Assert 3 : < sv38 /= 0000000001110100 >"
severity warning;

assert (sv39_o = "0000000001111110")
report 
"Assert 3 : < sv39 /= 0000000001111110 >" 
severity warning;

--
-- Pattern #4
inp <= "0000000000000000";
sv2 <= "0000000000010101";
sv13 <= "0000000000011010";
sv18 <= "0000000000010011";
sv26 <= "0000000000010011";
sv33 <= "0000000000011010";
sv38 <= "0000000000010011";
sv39 <= "0000000000010101";
wait for 100 ns;


assert (outp = "0000000011111001")
report
"Assert 4 : < outp /= 0000000011111001 >"
severity warning;

assert (sv2_o = "0000000111011101")
report
"Assert 4 : < sv2 /= 0000000111011101 >"
severity warning;

assert (sv13_o = "0000001010100011")
report
"Assert 4 : < sv13 /= 0000001010100011 >"
severity warning;

assert (sv18_o = "0000000110101010")
report
"Assert 4 : < sv18 /= 0000000110101010 >"
severity warning;

assert (sv26_o = "0000000110110001")
report
"Assert 4 : < sv26 /= 0000000110110001 >"
severity warning;

assert (sv33_o = "0000001100101110")
report
"Assert 4 : < sv33 /= 0000001100101110 >"
severity warning;

assert (sv38_o = "0000000110101010")
report
"Assert 4 : < sv38 /= 0000000110101010 >"
severity warning;

assert (sv39_o = "0000000111011101")
report
"Assert 4 : < sv39 /= 0000000111011101 >"
severity warning;

--
-- Pattern #6
inp <= "0000000000000010";
sv2 <= "0000000000001000";
sv13 <= "0000000000010000";
sv18 <= "0000000000001000";
sv26 <= "0000000000010000";
sv33 <= "0000000000001000";
sv38 <= "0000000000010000";
sv39 <= "0000000000001000";
wait for 100 ns;

assert (outp = "0000000001101010")
report
"Assert 6 : < outp /= 0000000001101010 >"
severity warning;

assert (sv2_o = "0000000011111100")
report
"Assert 6 : < sv2 /= 0000000011111100 >"
severity warning;

assert (sv13_o = "0000000101011110")
report
"Assert 6 : < sv13 /= 0000000101011110 >"
severity warning;

assert (sv18_o = "0000000011011100")
report
"Assert 6 : < sv18 /= 0000000011011100 >"
severity warning;

assert (sv26_o = "0000000011011000")
report
"Assert 6 : < sv26 /= 0000000011011000 >"
severity warning;

assert (sv33_o = "0000000101111000")
report
"Assert 6 : < sv33 /= 0000000101111000 >"
severity warning;

assert (sv38_o = "0000000011001100")
report
"Assert 6 : < sv38 /= 0000000011001100 >"
severity warning;

assert (sv39_o = "0000000011001100")
report
"Assert 6 : < sv39 /= 0000000011001100 >"
severity warning;

--
end process;

end; 
 
