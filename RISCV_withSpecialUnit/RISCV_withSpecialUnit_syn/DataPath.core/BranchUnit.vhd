library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.globals.all;


entity BranchUnit is
	port(
		stall:in std_logic;
		a : in std_logic_vector(63 downto 0);
		b : in std_logic_vector(63 downto 0);
		y : out std_logic
		);
end BranchUnit;

architecture Behavioral of BranchUnit is
begin
	process(stall,a,b)
	begin
 if(stall='0') then		
    if(a = b) then	--Branch equal 
        y<='1';--Branch equal taken 
    else   
		y <= '0';--Branch equal not taken
    end if;
 else
	  	y <= '0';--Branch equal not taken
    end if;
	end process;
end Behavioral;

configuration CFG_BranchUnit of BranchUnit is
  for Behavioral
  end for;
end CFG_BranchUnit;
