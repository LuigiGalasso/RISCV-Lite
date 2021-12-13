library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.globals.all;
--to be inserted in the control unit--



entity ForwardingUnit is
  port 	 ( EX_MEM_Register_Rd,MEM_WB_Register_Rd,Rs1,Rs2: IN std_logic_vector(4 downto 0);
		   WBControl_stageMEM,WBControl_stageWB: in std_logic;--required to know if you are actually write on regiters
           ForwardA,ForwardB: OUT std_logic_vector(1 downto 0));
end ForwardingUnit;

architecture behavioral of ForwardingUnit is

begin
P_ForwardingUnit:process
(EX_MEM_Register_Rd,MEM_WB_Register_Rd,Rs1,Rs2,WBControl_stageMEM,WBControl_stageWB)
  begin
--WBControl_stageWB and WBControl_stageMEM have to be connected to proper control words--
--in particular cw4 and cw5--
			if(WBControl_stageMEM='1' and EX_MEM_Register_Rd=Rs1 AND EX_MEM_Register_Rd/= "00000") then
			ForwardA <= "10";
			elsif(WBControl_stageWB='1' and MEM_WB_Register_Rd=Rs1 AND MEM_WB_Register_Rd/= "00000") then
			ForwardA <= "01";
			else
			ForwardA <= "00";
			end if;

			if(WBControl_stageMEM='1' and EX_MEM_Register_Rd=Rs2 AND EX_MEM_Register_Rd/= "00000") then
			ForwardB <= "10";
			elsif(WBControl_stageWB='1' and MEM_WB_Register_Rd=Rs2 AND MEM_WB_Register_Rd/= "00000") then
			ForwardB <= "01";
			else
			ForwardB <= "00";
			end if;

  end process P_ForwardingUnit;




end behavioral;

configuration CFG_ForwardingUnit of ForwardingUnit is
  for behavioral
  end for;
end CFG_ForwardingUnit;

 	


