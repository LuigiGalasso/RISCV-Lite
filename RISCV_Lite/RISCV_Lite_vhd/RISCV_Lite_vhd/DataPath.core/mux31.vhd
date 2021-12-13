library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux31 is
	port(
		a : in std_logic_vector(63 downto 0);
		b : in std_logic_vector(63 downto 0);
		c : in std_logic_vector(63 downto 0);
		sel : in std_logic_vector(1 downto 0);
		y : out std_logic_vector(63 downto 0)
		);
end Mux31;

architecture Behavioral of Mux31 is

begin
	process(a,b,c,sel)
	begin
		if(sel = "00")then
			y <= a;
		elsif(sel = "01")then 
		    y <= b;
		elsif(sel = "10")then 
		    y <= c;
		else
			y<=(others=>'0');
		end if;
	end process;
end Behavioral;

configuration CFG_Mux31 of Mux31 is
  for Behavioral
  end for;
end CFG_Mux31;
