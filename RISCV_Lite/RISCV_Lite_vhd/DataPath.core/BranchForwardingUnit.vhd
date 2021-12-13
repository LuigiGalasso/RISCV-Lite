library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.globals.all;
--to be inserted in the control unit--



entity BranchForwardingUnit is
  port 	 ( EX_MEM_Register_Rd,MEM_WB_Register_Rd,B_Rs1,B_Rs2: IN std_logic_vector(4 downto 0);
		   WBControl_stageMEM,WBControl_stageWB: in std_logic;--required to know if you are actually write on regiters
           Forward_Branch_A: OUT std_logic_vector(1 downto 0);
		   Forward_Branch_B: OUT std_logic_vector(1 downto 0));
end BranchForwardingUnit;

architecture behavioral of BranchForwardingUnit is

begin
P_BranchForwardingUnit:process
(EX_MEM_Register_Rd,MEM_WB_Register_Rd,B_Rs1,B_Rs2,WBControl_stageMEM,WBControl_stageWB)
  begin
--WBControl_stageWB and WBControl_stageMEM have to be connected to proper control words--
--in particular cw4 and cw5--
			if   (WBControl_stageMEM='1' and EX_MEM_Register_Rd=B_Rs1 AND EX_MEM_Register_Rd/= "00000") then
			Forward_Branch_A <= "01";
			elsif(WBControl_stageWB='1' and MEM_WB_Register_Rd=B_Rs1 AND MEM_WB_Register_Rd/= "00000") then
			Forward_Branch_A <= "10";
			else
			Forward_Branch_A <= "00";
			end if;			

			if(WBControl_stageMEM='1' and EX_MEM_Register_Rd=B_Rs2 AND EX_MEM_Register_Rd/= "00000") then
			Forward_Branch_B <= "01";
			elsif(WBControl_stageWB='1' and MEM_WB_Register_Rd=B_Rs2 AND MEM_WB_Register_Rd/= "00000") then
			Forward_Branch_B <= "10";
			else
			Forward_Branch_B <= "00";
			end if;

  end process P_BranchForwardingUnit;




end behavioral;

configuration CFG_BranchForwardingUnit of BranchForwardingUnit is
  for behavioral
  end for;
end CFG_BranchForwardingUnit;

 	


