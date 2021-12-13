library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux41 is
	port(
		a : in std_logic_vector(63 downto 0);
		b : in std_logic_vector(63 downto 0);
		c : in std_logic_vector(63 downto 0);
		d : in std_logic_vector(63 downto 0);
		sel : in std_logic_vector(1 downto 0);
		y : out std_logic_vector(63 downto 0)
		);
end Mux41;

architecture Behavioral of Mux41 is

begin
	process(a,b,c,d,sel)
	begin
		if(sel = "00")then
			y <= a;
		elsif(sel = "01")then 
		    y <= b;
		elsif(sel = "10")then 
		    y <= c;
		elsif(sel = "11")then 
		    y <= d;	
		else
			y<=(others=>'0');
		end if;
	end process;
end Behavioral;

configuration CFG_Mux41 of Mux41 is
  for Behavioral
  end for;
end CFG_Mux41;
