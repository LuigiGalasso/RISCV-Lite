library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use WORK.all;



entity specialUnit is
	port(	A:		 in std_logic_vector(63 downto 0);
			OUTPUT: out std_logic_vector(63 downto 0)
	);

end entity specialUnit;

architecture BEHAVIORAL of specialUnit is
	signal temp : std_logic_vector(63 downto 0);
	signal one  : std_logic_vector(63 downto 0):=(0=>'1',others=>'0');
begin
	AbsoluteValue: process (A) is
	begin 
		if(A(63)='1') then--negative
		one(0)<='1';
		for i in 0 to 63 loop
		temp(i) <= A(i) XOR '1';	
		end loop;
		else--positive
		temp <= A;
		one(0)<='0';
		end if;
	end process;
OUTPUT<=temp + one;
end architecture BEHAVIORAL;

configuration CFG_specialUnit of specialUnit is
  for BEHAVIORAL
  end for;
end CFG_specialUnit;


