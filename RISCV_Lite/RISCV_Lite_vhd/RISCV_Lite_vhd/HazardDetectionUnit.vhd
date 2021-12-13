library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.globals.all;
--to be inserted in the control unit--
entity HazardDetectionUnit is
  port 	 (

		ID_EX_MEMRead:in std_logic;--cw bit to enable the read from memory 
		ID_EX_BranchEnable:in std_logic;--cw bit to enable the read from memory 
		ID_EX_Register_Rd: in std_logic_vector(4 downto 0);
        IF_ID_Register_Rs1,IF_ID_Register_Rs2: IN std_logic_vector(4 downto 0);
        bubble:out std_logic;
		stall :out std_logic
		);
end HazardDetectionUnit;

architecture behavioral of HazardDetectionUnit is

begin
P_HazardDetectionUnit:process
(ID_EX_MEMRead,ID_EX_Register_Rd,IF_ID_Register_Rs1,IF_ID_Register_Rs2,ID_EX_BranchEnable)
  begin

			if(ID_EX_MEMRead='1' and ((ID_EX_Register_Rd=IF_ID_Register_Rs1)OR(ID_EX_Register_Rd=IF_ID_Register_Rs2))) then
			bubble<='1';
			else
			bubble<='0';
			end if;
			
			if(ID_EX_BranchEnable='1' and ((ID_EX_Register_Rd=IF_ID_Register_Rs1)OR(ID_EX_Register_Rd=IF_ID_Register_Rs2))) then
			stall<='1';
			else
			stall<='0';
			end if;

  end process P_HazardDetectionUnit;




end behavioral;

configuration CFG_HazardDetectionUnit of HazardDetectionUnit is
  for behavioral
  end for;
end CFG_HazardDetectionUnit;

 	


