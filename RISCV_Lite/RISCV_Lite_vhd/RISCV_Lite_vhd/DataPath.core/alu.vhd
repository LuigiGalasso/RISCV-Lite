library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.globals.all;

entity ALU is
  port 	 ( CODE: IN std_logic_vector(3 downto 0);
           DATA1, DATA2: IN std_logic_vector(63 downto 0);
           OUTALU: OUT std_logic_vector(63 downto 0));
end ALU;

architecture structural of ALU is



component COMPARATORless is

	port(	A: in std_logic_vector(63 downto 0);
			B: in std_logic_vector(63 downto 0);
			OUTPUT: out std_logic_vector(63 downto 0)
);

end component;

signal COMPARATORout    :std_logic_vector(63 downto 0);

 
begin



COMPOP:COMPARATORless Port Map(DATA1,DATA2,COMPARATORout);



  P_ALU: process (CODE,DATA1,DATA2,COMPARATORout)
  begin
  case conv_integer(CODE) is

		when 2 	=> OUTALU<=to_StdLogicVector((to_bitvector(DATA1)) sra (conv_integer(DATA2(31 downto 0))));
 		when 3 	=> OUTALU<=DATA1+DATA2;

		when 5 	=> OUTALU <= (DATA1 AND DATA2); 

		when 7 	=> OUTALU <= (DATA1 XOR DATA2);
		when 8 	=> OUTALU <= COMPARATORout;--SLT


		when others => OUTALU<=(others =>'0');
  end case; 
  end process P_ALU;




end structural;

configuration CFG_ALU_STRUCTURAL of ALU is
  for STRUCTURAL
  end for;
end CFG_ALU_STRUCTURAL;

configuration CFG_ALU_STRUCTURAL of ALU is
  for STRUCTURAL 	
		
      for all : COMPARATORless
        use configuration WORK.CFG_COMPARATORless;
      end for;	
		 	
 end for;
end CFG_ALU_STRUCTURAL;
 	


