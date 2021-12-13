library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----instruction register-----------
entity IR is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(31 downto 0);
		o : out std_logic_vector(31 downto 0)
	);
end IR;

architecture behavioral of IR is
	signal temp : std_logic_vector(31 downto 0);

begin
	process (clock)
	begin
		if(clock = '1' and clock'event)then
			if(reset = '1')then 
   temp <= "00000000000000000000000000010011";		-- add x0 x0 x0
			elsif(reset = '0'  and load = '1')then
				temp <= i;
			end if;
		end if;
	end process;

	o <= temp;
	
end behavioral;


configuration CFG_IR of IR is
  for behavioral
  end for;
end CFG_IR;
