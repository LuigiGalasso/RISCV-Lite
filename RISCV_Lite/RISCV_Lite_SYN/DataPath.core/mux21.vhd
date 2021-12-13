library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux21 is
	port(
		a : in std_logic_vector(63 downto 0);
		b : in std_logic_vector(63 downto 0);
		sel : in std_logic;
		y : out std_logic_vector(63 downto 0)
		);
end Mux21;

architecture Behavioral of Mux21 is

begin
	process(a,b,sel)
	begin
		if(sel = '0')then
			y <= a;
		else    y <= b;
		end if;
	end process;
end Behavioral;

configuration CFG_Mux21 of Mux21 is
  for Behavioral
  end for;
end CFG_Mux21;
