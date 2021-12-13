library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use WORK.all;



entity COMPARATORless is
	port(	A: in std_logic_vector(63 downto 0);
							B: in std_logic_vector(63 downto 0);
							OUTPUT: out std_logic_vector(63 downto 0)
	);

end entity COMPARATORless;

architecture BEHAVIORAL of COMPARATORless is
begin
	COMPARE: process (A, B) is
	begin

									if(A<B) then
									OUTPUT <= (0 =>'1',others =>'0');
									else
									OUTPUT <= (others =>'0');
									end if;
	end process;
end architecture BEHAVIORAL;

configuration CFG_COMPARATORless of COMPARATORless is
  for BEHAVIORAL
  end for;
end CFG_COMPARATORless;


