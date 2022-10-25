library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter_vhdl is
generic( bit_width:integer:=4);
port(
   count: out STD_LOGIC_VECTOR(bit_width -1 downto 0);
   reset: in STD_LOGIC := '0';
   enable: in STD_LOGIC := '1';
   clk: in STD_LOGIC);
end counter_vhdl;

architecture Behavioral of counter_vhdl is
signal count_tmp : STD_LOGIC_VECTOR(bit_width -1  downto 0) := (others => '0');
begin
count <= count_tmp;
process (clk, reset)
  begin
   if clk='1' and clk'event then
       if reset='1' then
	   count_tmp <= (others => '0');
       elsif enable='1' then
	   count_tmp <= count_tmp + 1;  
       end if;      
   end if;
end process;

end Behavioral;


