library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity fetchUnit is

	


 port(  

  					clock : in std_logic;
  					reset : in std_logic;
  							--------INPUTS FROM CONTROL WORD-------------  
  					en1: in std_logic;--Fetch registers enable  
  							
  					BranchPC: in std_logic_vector(63 downto 0);--Program Counter value if Branch is taken
  					BRANCHfromDECODE:in std_logic;-- selection bit of Program Counter Multiplexer
  					Instruction: in std_logic_vector(31 downto 0);--Instruction from Instruction Memory
  							PCtoIM  : out std_logic_vector(63 downto 0);--Program counter value sent to the Instruction Memory
  							IRtoDecode: out std_logic_vector(31 downto 0);--Instruction to be decoded stored in the Instruction Register
         PCtoDecode  : out std_logic_vector(63 downto 0)--Next Program counter value sent to the next pipe stage

 );
end fetchUnit;

architecture structural of fetchUnit is

component Adder is
	 port ( 
		A: in std_logic_vector(63 downto 0); 
		B: in std_logic_vector(63 downto 0); 
    	reset:in std_logic;
		O: out std_logic_vector(63 downto 0)
	);
end component;

component reg64 is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(63 downto 0);
		o : out std_logic_vector(63 downto 0)
	);
end component;

component IR is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(31 downto 0);
		o : out std_logic_vector(31 downto 0)
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
--signal four:       std_logic_vector(63 downto 0):=(2=>'1', others=>'0');
signal AddertoMux: std_logic_vector(63 downto 0);
signal MuxtoPc:    std_logic_vector(63 downto 0); 
signal PctoAdder:  std_logic_vector(63 downto 0);
signal LOAD :std_logic;
	constant FOUR :std_logic_vector(63 downto 0):=(2=>'1', others=>'0');
begin 





LOAD<=reset OR (BRANCHfromDECODE);

nxpc : Adder port map(PctoAdder,FOUR,reset,AddertoMux);--computation of next program counter
pcmux: Mux21 port map(AddertoMux,BranchPc,BRANCHfromDECODE,MuxtoPc);--mux for selecting the next program counter

InstrReg   : IR port map(clock,LOAD,en1,Instruction,IRtoDecode);--Instruction Register
PC   : reg64 port map(clock,reset,en1,MuxtoPc,PctoAdder);--Program Counter
RegPCtoDecode  : reg64 port map(clock,reset,en1,PctoAdder,PCtoDecode);--Program Counter


PCtoIm<=PctoAdder;--Instruction Memory 

end structural;

configuration CFG_FETCHUNIT of fetchUnit is
  for structural
  end for;
end CFG_FETCHUNIT;

configuration CFG_FETCHUNIT of fetchUnit is
  for structural 	
  	for all: reg64
	     use configuration WORK.CFG_reg64;
   end for;
   for all: IR
	     use configuration WORK.CFG_IR;
   end for;		
   for all : Mux21
      use configuration WORK.CFG_Mux21;
   end for;	
	 for all : Adder
      use configuration WORK.CFG_Adder;
   end for;	
  end for;
end CFG_FETCHUNIT;




