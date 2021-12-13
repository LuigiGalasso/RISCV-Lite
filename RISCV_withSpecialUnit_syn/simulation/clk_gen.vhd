library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk_gen is
  port (
    Clk    : out std_logic;
    Rst   : out std_logic);
end clk_gen;

architecture beh of clk_gen is

    signal Clk_i: std_logic := '0';
    signal Rst_i: std_logic := '0';
  
begin  -- beh

  PCLOCK : process(Clk_i)
	begin
		Clk_i <= not(Clk_i) after 10 ns;	
	end process;
	Clk<=Clk_i;
	Rst_i <= '1', '0' after 20 ns;
	Rst<=Rst_i;

end beh;
