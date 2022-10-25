Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_vhdl is
    port (   clk    : in std_logic := '0';
             rst    : in std_logic := '0';
             a      : in std_logic_vector(15 downto 0):= (others => '0');
             b      : in std_logic_vector(15 downto 0):= (others => '0');
             sum    : out std_logic_vector(15 downto 0) := (others => '0')
         );
end adder_vhdl;

architecture behav of adder_vhdl is
begin
    process(clk, rst) begin
        if(rst = '1') then
            sum <= (others => '0');
        elsif rising_edge(clk) then
            sum <= std_logic_vector(unsigned(a) + unsigned(b));
        end if;
    end process;
end behav;


