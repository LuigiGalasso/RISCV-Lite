library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity WBUnit is
 port(  
        ----INPUTS FROM CONTROL WORD---------    
  						selwb: in std_logic;--bit selection for Mux
 
        -----INPUT FROM PREVIOUS STAGE-----------
        ALUin :in std_logic_vector(63 downto 0);
        LOADDATA: in std_logic_vector(63 downto 0); --LMD register output
        AddressWfromMemory:in std_logic_vector(63 downto 0); 
        -----OUTPUTS-----------
        MUXtoRF : out std_logic_vector(63 downto 0);
        AddressWtoDECODE: out std_logic_vector(63 downto 0)
 );
end WBUnit;

architecture structural of WBUnit is

component Mux21 is
	port(
		a   : in std_logic_vector(63 downto 0);
		b   : in std_logic_vector(63 downto 0);
		sel : in std_logic;
		y   : out std_logic_vector(63 downto 0)
		);
end component;

begin

wbmux: Mux21 port map(LOADDATA,ALUin,selwb,MUXtoRF); --mux for selecting what to write
AddressWtoDECODE<=AddressWfromMemory;


end structural;

configuration CFG_WBUnit of WBUnit is
  for structural
  end for;
end CFG_WBUnit;

configuration CFG_WBUnit of WBUnit is
  for structural	
      for all : Mux21
       use configuration WORK.CFG_Mux21;
      end for;	
  end for;
end CFG_WBUnit;
