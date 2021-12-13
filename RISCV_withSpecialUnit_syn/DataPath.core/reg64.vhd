library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----simple register-----------
entity reg64 is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(63 downto 0);
		o : out std_logic_vector(63 downto 0)
	);
end reg64;

architecture behavioral of reg64 is
	signal temp : std_logic_vector(63 downto 0);

begin
	process (clock)
	begin
		if(clock = '1' and clock'event)then
			if(reset = '1')then
				temp <= (others=>'0');	
			elsif(reset = '0'  and load = '1')then
				temp <= i;
			end if;
		end if;
	end process;

	o <= temp;
	
end behavioral;


configuration CFG_reg64 of reg64 is
  for behavioral
  end for;
end CFG_reg64;
