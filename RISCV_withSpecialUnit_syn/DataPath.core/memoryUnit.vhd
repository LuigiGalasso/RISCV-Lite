library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity memoryUnit is
 port(

         --*INPUTS*--
  							clock : in std_logic;
  							reset : in std_logic;

         ----INPUTS FROM CONTROL WORD---------          
  							en4: in std_logic;--memory stage enable
         
        -----INPUT FROM PREVIOUS STAGE-----------
        ALUout:in std_logic_vector(63 downto 0);

        DRAMout:in std_logic_vector(31 downto 0);

        AddressWfromEXECUTE:in std_logic_vector(63 downto 0); 

        -----OUTPUTS-----------
        LOADDATA: out std_logic_vector(63 downto 0); --LMD register output
        ALUtoWBMUX: out std_logic_vector(63 downto 0);      
        AddressWtoWB:out std_logic_vector(63 downto 0)

 );
end memoryUnit;

architecture structural of memoryUnit is

component reg64 is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(63 downto 0);
		o : out std_logic_vector(63 downto 0)
	);
end component;


signal         LDDATA64:           std_logic_vector(63 downto 0);
begin 
LDDATA64(31 downto 0)<=  DRAMout;
LDDATA64(63 downto 32)<= (others=>DRAMout(31));
LMD_REG : reg64 port map(clock,reset,en4,LDDATA64,LOADDATA); 
ALUout_REG: reg64 port map(clock,reset,en4,ALUout,ALUtoWBMUX);  -- ALU output register    
AddressW_REG: reg64 port map(clock,reset,en4,AddressWfromEXECUTE,AddressWtoWB); -- Addresses register real

  
end structural;

configuration CFG_memoryUnit of memoryUnit is
  for structural
  end for;
end CFG_memoryUnit;

configuration CFG_memoryUnit of memoryUnit is
  for structural	
      for all : reg64
       use configuration WORK.CFG_reg64;
      end for;	     
  end for;
end CFG_memoryUnit;

