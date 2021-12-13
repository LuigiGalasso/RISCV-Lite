library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.globals.all;

entity ImmidiateSignExtender is
	port(
		Instruction: in std_logic_vector(31 downto 0);
		y : out std_logic_vector(63 downto 0)
		);
end ImmidiateSignExtender;

architecture Behavioral of ImmidiateSignExtender is
signal immidiate_Itype,immidiate_Stype,immidiate_SBtype,immidiate_UJtype,immidiate_Utype : STD_LOGIC_VECTOR (63 downto 0);
signal opcode: std_logic_vector (6 downto 0);

begin
opcode<=Instruction(6 downto 0);

immidiate_Itype(11 downto 0)<= Instruction(31 downto 20);
immidiate_Itype(63 downto 12)<=(others=>Instruction(31));
immidiate_Stype(11 downto 0)<= Instruction(31 downto 25)&Instruction(11 downto 7);
immidiate_Stype(63 downto 12)<=(others=>Instruction(31));
immidiate_SBtype(12 downto 0)<= Instruction(31)&Instruction(7)&Instruction(30 downto 25)&Instruction(11 downto 8)&'0';
immidiate_SBtype(63 downto 13)<=(others=>Instruction(31));
immidiate_UJtype(20 downto 0)<= Instruction(31)&Instruction(19 downto 12)&Instruction(20)&Instruction(30 downto 21)&'0';
immidiate_UJtype(63 downto 21)<=(others=>Instruction(31));
immidiate_Utype(31 downto 0)<= Instruction(31 downto 12)& "000000000000";
immidiate_Utype(63 downto 32)<=(others=>Instruction(31));

	process(immidiate_Itype,immidiate_Stype,immidiate_SBtype,immidiate_UJtype,immidiate_Utype)
	begin
  case opcode is
  when ITYPE 	=>y<=immidiate_Itype ;
  when OPCODE_LW =>y<=immidiate_Itype ;
  when STYPE 	=>y<=immidiate_Stype ;
  when SBTYPE 	=>y<=immidiate_SBtype ;
  when UJTYPE 	=>y<=immidiate_UJtype ;
  when UTYPE	=>y<=immidiate_Utype ;
  when OPCODE_AUIPC  =>y<=immidiate_Utype ;
  when others=>y<=(OTHERS=>'0');
  end case;
	end process;
end Behavioral;

configuration CFG_ImmidiateSignExtender of ImmidiateSignExtender is
  for Behavioral
  end for;
end CFG_ImmidiateSignExtender;
