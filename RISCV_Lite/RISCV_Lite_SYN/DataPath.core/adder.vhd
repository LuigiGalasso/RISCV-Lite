library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;


entity Adder is
	 port ( 
		A: in std_logic_vector(63 downto 0); 
		B: in std_logic_vector(63 downto 0); 
     	reset:in std_logic;
		O: out std_logic_vector(63 downto 0)
	);
end Adder;

architecture Behavioral of Adder is

begin
	process(A,B,reset)

	begin
   if(reset = '0') then
		O <= A + B ;

  else
   		O <= (others=>'0') ;
   end if;

	end process;

end Behavioral;

configuration CFG_Adder of Adder is
  for Behavioral
  end for;
end CFG_Adder;

