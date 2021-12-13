library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.globals.all;


entity DecodeUnit is
 port(

         --*INPUTS*--
  							clock : in std_logic;
  							reset : in std_logic;
         
         JMP: in std_logic;--Jump signal from Control Word
		 en2: in std_logic;--Decode registers enable
         BRANCHenable: in std_logic;
		 stall:in std_logic;
  							--RF enables
									RD1: 				IN std_logic;
									RD2: 				IN std_logic;
									WR: 				IN std_logic;
     
  							Instruction: in std_logic_vector(31 downto 0);--Instruction from Instruction Memory 
     						Forward_Branch_A: in std_logic_vector(1 downto 0);
     						Forward_Branch_B: in std_logic_vector(1 downto 0);
							  --Data signals
  					ADD_WR: 	IN std_logic_vector(4 downto 0);
					DATAIN: 	IN std_logic_vector(63 downto 0);
   					PCfromIF: in std_logic_vector(63 downto 0);  -- PC sent by the IF stage
         			PreviousALUout:in std_logic_vector(63 downto 0);


         --*OUTPUTS*--
       
         OUT1: 		 OUT std_logic_vector(63 downto 0);
		 OUT2: 		 OUT std_logic_vector(63 downto 0);
         OUTPC: 		 OUT std_logic_vector(63 downto 0);
         OUTIMM: 		 OUT std_logic_vector(63 downto 0);

		 IF_ID_Register_Rs1,IF_ID_Register_Rs2: OUT std_logic_vector(4 downto 0);		
		
         PCtoEX:   OUT std_logic_vector(63 downto 0);
         AddressWtoEX:  OUT std_logic_vector(63 downto 0); 
		 Rs1,Rs2: OUT std_logic_vector(63 downto 0);
         BRANCHtoFetch: out std_logic
         

  

 );
end DecodeUnit;

architecture structural of DecodeUnit is

component register_file is
 port (  CLK:	IN std_logic;
         RESET: 		IN std_logic;
									ENABLE: 	IN std_logic;
									RD1: 				IN std_logic;
									RD2: 				IN std_logic;
									WR: 					IN std_logic;
									ADD_WR: 	IN std_logic_vector(4 downto 0);
									ADD_RD1: IN std_logic_vector(4 downto 0);
									ADD_RD2:	IN std_logic_vector(4 downto 0);
									DATAIN: 	IN std_logic_vector(63 downto 0);
        							 OUT1: 		 OUT std_logic_vector(63 downto 0);
									OUT2: 		 OUT std_logic_vector(63 downto 0));
end component;
component ImmidiateSignExtender is
	port(
		Instruction: in std_logic_vector(31 downto 0);
		y : out std_logic_vector(63 downto 0)
		);
end component;



component reg64 is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(63 downto 0);
		o : out std_logic_vector(63 downto 0)
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
component BranchUnit is
	      port(
			  stall: in std_logic;
		      a : in std_logic_vector(63 downto 0);
		      b : in std_logic_vector(63 downto 0);
		      y : out std_logic
		      );
end component;

signal EXTtoIMM:    std_logic_vector(63 downto 0);
signal RFOUT1:  std_logic_vector(63 downto 0);
signal RFOUT2:  std_logic_vector(63 downto 0); 

signal	ADD_RD1: std_logic_vector(4 downto 0);
signal	ADD_RD2: std_logic_vector(4 downto 0);

constant zero: std_logic_vector(58 downto 0):=(others=>'0');
constant x0Address:std_logic_vector(63 downto 0):=(others=>'0');

signal Address: std_logic_vector(63 downto 0);
signal ADDR_R31     :std_logic_vector(63 downto 0);
signal AddressW  :std_logic_vector(63 downto 0);
signal addressRs1,addressRs2:std_logic_vector(63 downto 0);
signal Selection :std_logic_vector(1 downto 0);
signal BranchTaken : std_logic;--high if branch is taken

signal Branch_A,Branch_B:std_logic_vector(63 downto 0);

begin 
----------Address multiplexer used to know which address use---------------- 
ADDR_R31 <=zero & "11111";--Address register 63 used to store di PC+4 (JAL instruction)
Address <=zero & Instruction(11 downto 7);--I_TYPE and R_TYPE REGISTER DESTINATION ADDRESS
Selection<=JMP &  BRANCHenable;
ADDRESS_MUX: Mux31     port map(Address,x0Address,ADDR_R31,Selection,AddressW);
----------Sign Exentsion for Immidiate----------------------------------------
SIGN_EXTENSION: ImmidiateSignExtender port map(Instruction,EXTtoIMM);


BRANCHtoFetch<=JMP OR  (BranchTaken AND BRANCHenable);


BRANCH_MUX_A: Mux31     port map(RFOUT1,PreviousALUout,DATAIN,Forward_Branch_A,Branch_A);
BRANCH_MUX_B: Mux31     port map(RFOUT2,PreviousALUout,DATAIN,Forward_Branch_B,Branch_B);
BRANCH:BranchUnit port map(stall,Branch_A,Branch_B,BranchTaken);



-----ADDER used to calculate the next pc-------------- 
OUTPC<=  ( PCfromIF + ( EXTtoIMM(63 downto 0) ))   ;

--Pipeline registers
IMM_REG: reg64 port map(clock,reset,en2,EXTtoIMM,OUTIMM); -- Immediate Register
OUT1_REG: reg64 port map(clock,reset,en2,RFOUT1,OUT1); -- Register File's output 1 register
OUT2_REG: reg64 port map(clock,reset,en2,RFOUT2,OUT2); -- Register File's output 2 register
PC_REG: reg64 port map(clock,reset,en2,PCfromIF,PCtoEX); -- Next program counter register
ADD_WR_REG: reg64 port map(clock,reset,en2,AddressW,AddressWtoEX); -- Address write resgister destination register
ADD_Rs1_REG: reg64 port map(clock,reset,en2,addressRs1,Rs1); --Address operand resgister 1
ADD_Rs2_REG: reg64 port map(clock,reset,en2,addressRs2,Rs2); --Address operand resgister 1
addressRs1<=zero & ADD_RD1;
addressRs2<=zero & ADD_RD2;
IF_ID_Register_Rs1<= ADD_RD1;
IF_ID_Register_Rs2<= ADD_RD2;
------REGISTER FILE----------------------
ADD_RD1<=Instruction(19 downto 15);
ADD_RD2<=Instruction(24 downto 20);
RF:register_file port map(clock,reset,'1',RD1,RD2,WR,ADD_WR,ADD_RD1,ADD_RD2,DATAIN,RFOUT1,RFOUT2);


  
end structural;

configuration CFG_DECODEUNIT of DecodeUnit is
  for structural
  end for;
end CFG_DECODEUNIT;

configuration CFG_DECODEUNIT of DecodeUnit is
  for structural 	

  	for all: reg64
	     use configuration WORK.CFG_reg64;
   end for;		
   for all : Mux31
      use configuration WORK.CFG_Mux31;
   end for;
	 for all : register_file
      use configuration WORK.CFG_register_file;
   end for;	
  for all: BranchUnit 
       use configuration WORK.CFG_BranchUnit;
      end for;
  for all: ImmidiateSignExtender 
       use configuration WORK.CFG_ImmidiateSignExtender;
      end for;
  end for;
end CFG_DECODEUNIT;
