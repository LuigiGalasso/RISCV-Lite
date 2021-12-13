library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.globals.all;

entity executeUnit is
 port(

         --*INPUTS*--
  							clock : in std_logic;
  							reset : in std_logic;


         ----INPUTS FROM CONTROL WORD--------- 
  		 en3: in std_logic;--execute enable         
         Mux1Sel:in std_logic;
         Mux2Sel:in std_logic;
         ALUCODE: in std_logic_vector(3 downto 0);
         
        -----INPUT FROM PREVIOUS STAGE-----------
        OUT1RF:in std_logic_vector(63 downto 0);
        OUT2RF:in std_logic_vector(63 downto 0);
        IMMEDIATE:in std_logic_vector(63 downto 0);
        PCFromDecode:in std_logic_vector(63 downto 0); 
        AddressWfromDecode:in std_logic_vector(63 downto 0); 

		PreviousALUout:in std_logic_vector(63 downto 0);
		WBout:in std_logic_vector(63 downto 0);
		ForwardA,ForwardB:in std_logic_vector(1 downto 0);
        
        -----OUTPUTS-----------
                        
        ALUtoMEMORY: out std_logic_vector(63 downto 0);      
        OUT2RFtoMEMORY: out std_logic_vector(63 downto 0); 
       
        AddressWtoMEMORY:out std_logic_vector(63 downto 0)

 );
end executeUnit;

architecture structural of executeUnit is


component reg64 is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(63 downto 0);
		o : out std_logic_vector(63 downto 0)
	);
end component;

component Mux21 is
	port(
		a   : in std_logic_vector(63 downto 0);
		b   : in std_logic_vector(63 downto 0);
		sel : in std_logic;
		y   : out std_logic_vector(63 downto 0)
		);
end component;
component Mux31 is
	port(
		a   : in std_logic_vector(63 downto 0);
		b   : in std_logic_vector(63 downto 0);
		c   : in std_logic_vector(63 downto 0);
		sel : in std_logic_vector(1 downto 0);
		y   : out std_logic_vector(63 downto 0)
		);
end component;

component ALU is
  port 	 ( CODE: IN std_logic_vector(3 downto 0);
           DATA1, DATA2: IN std_logic_vector(63 downto 0);
           OUTALU: OUT std_logic_vector(63 downto 0));
end component;

signal MUX1out:      std_logic_vector(63 downto 0);
signal MUX2out:      std_logic_vector(63 downto 0);
signal MUXPCout:    std_logic_vector(63 downto 0);
signal MUXWITH4out:  std_logic_vector(63 downto 0);
signal MUXIMMout:    std_logic_vector(63 downto 0);

signal ALUout :      std_logic_vector(63 downto 0);
constant JAL4   :      std_logic_vector(63 downto 0):= (2 => '1', others=>'0'); --Number four used to add with PC for the JAL INSTRUCTION


begin 
MUX21_1:mux21 port map(OUT1RF,PCFromDecode,Mux1Sel,MUXPCout);
MUX31_1:Mux31 port map(MUXPCout,WBout,PreviousALUout,ForwardA,MUX1out);

MUXWITH4:mux21 port map(OUT2RF,JAL4,Mux1Sel,MUXWITH4out);
MUX21_2:mux21 port map(MUXWITH4out,IMMEDIATE,Mux2Sel,MUXIMMout);
MUX31_2:Mux31 port map(MUXIMMout,WBout,PreviousALUout,ForwardB,MUX2out);



ALUset:ALU port map(ALUCODE,MUX1out,MUX2out,ALUout);

--Pipeline registers
ALUout_reg: reg64 port map(clock,reset,en3,ALUout,ALUtoMEMORY);    -- ALU output register    
RFout2_reg: reg64 port map(clock,reset,en3,MUXWITH4out,OUT2RFtoMEMORY); -- register File's output 2 register
AddressW_reg: reg64  port map(clock,reset,en3,AddressWfromDecode,AddressWtoMEMORY);--Addresses register



  
end structural;

configuration CFG_executeUnit of executeUnit is
  for structural
  end for;
end CFG_executeUnit;

configuration CFG_executeUnit of executeUnit is
  for structural	
	     for all: ALU
 	     use configuration WORK.CFG_ALU_STRUCTURAL;
      end for;		
      for all : reg64
       use configuration WORK.CFG_reg64;
      end for;		 		      
      for all : Mux21
       use configuration WORK.CFG_Mux21;
      end for;	
	  for all : Mux31
       use configuration WORK.CFG_Mux31;
      end for;	
  end for;
end CFG_executeUnit;
