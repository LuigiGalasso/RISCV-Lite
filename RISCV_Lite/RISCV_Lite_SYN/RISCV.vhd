library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use WORK.globals.all;
use work.all;

entity RISCV is
  port (
    Clk : in std_logic;
    Rst : in std_logic;
	DRAMout:in std_logic_vector(31 downto 0);
	Instruction: in std_logic_vector(31 downto 0);

    PCtoIM  : out std_logic_vector(63 downto 0);--Program counter value sent to the Instruction Memory
    ALUtoMEMORY: out std_logic_vector(63 downto 0);      
    OUT2RFtoMEMORY: out std_logic_vector(63 downto 0);

    memoryEnable:  out std_logic;
    ReadNotWrite:  out std_logic--1 for reading, 0 for writing 

);                -- Active High
end RISCV;

architecture RISCV_rtl of RISCV is

 --------------------------------------------------------------------
 -- Components Declaration
 --------------------------------------------------------------------
  


  -- Datapath 
  component dataPath 
 port(
		 clock : in std_logic;
		 reset : in std_logic;
   -------INPUT CONTROL SIGNAL-------------
    -- Instruction Register
         Instruction: in std_logic_vector(31 downto 0);--Instruction from Instruction Memory
    -- IF Control Signal
         en1: in std_logic;--Fetch registers enable                                          
    -- ID Control Signals
  		 en2: in std_logic;--Decode registers enable
		 RD1: 				IN std_logic;
		 RD2: 				IN std_logic;
		 WR: 					IN std_logic;
         JMP: in std_logic; 
         BRANCHenable: in std_logic;
		 		 stall:in std_logic;
    -- EX Control Signals
  		 en3: in std_logic;--execute enable
         Mux1Sel: in std_logic;
         Mux2Sel:in std_logic;
         ALUCODE: in std_logic_vector(3 downto 0);

    -- MEM Control Signals
  		 en4: in std_logic;--memory stage enable
         FWselwb: in std_logic;--selwb signal from the memory stage
    -- Data Memory Input
         DRAMout:in std_logic_vector(31 downto 0);

    -- WB Control signals
  		 selwb: in std_logic;--bit selection for Mux

    -------OUTPUTS-------------
         PCtoIM  : out std_logic_vector(63 downto 0);--Program counter value sent to the Instruction Memory
         ALUtoMEMORY: out std_logic_vector(63 downto 0);      
         OUT2RFtoMEMORY: out std_logic_vector(63 downto 0);

    -------OUTPUTS to CU-------------

         InstructionToCU: out std_logic_vector(31 downto 0);
		 IF_ID_Register_Rs1,IF_ID_Register_Rs2: OUT std_logic_vector(4 downto 0);	
		 ID_EX_Register_Rd: out std_logic_vector(4 downto 0)  

    );
        
end component;
  -- Control Unit
  component Cu
       port (
            -- INPUTS         
            Clk : in std_logic;
            Rst : in std_logic; -- Active HIGH
			---HAZARD DETECTION UNIT Inputs
			ID_EX_Register_Rd: in std_logic_vector(4 downto 0);
       	    IF_ID_Register_Rs1,IF_ID_Register_Rs2: IN std_logic_vector(4 downto 0);
            -- Instruction Register
            IR_IN:         in  std_logic_vector(31 downto 0);
            -- IF Control Signal
            en1:           out std_logic;--Fetch stage registers enable          
              -- ID Control Signals
       		en2:           out std_logic;--Decode stage registers enable  
			RD1: 		   out std_logic;--Register File Read Port 1 enable 
			RD2: 		   out std_logic;--Register File Read Port 2 enable 
            JmP:           out std_logic;--JUMP enable
            BRANCHenable:  out std_logic;--Branch enable
					 stall:out std_logic;
              -- EX Control Signals
  			en3:           out std_logic;--Execute stage registers enable
       		mux1Sel:       out std_logic;--selection bit for the multiplexer      
       		mux2Sel:       out std_logic;--selection bit for the multiplexer              
            ALUCODE:       out std_logic_vector(3 downto 0);
              -- Mem Control Signals
  			en4:           out std_logic;--memory stage registers enable
			FWselwb:       out std_logic;--selwb signal from the memory stage
              --Data memory--
            memoryEnable:  out std_logic;
            ReadNotWrite:  out std_logic;--1 for reading, 0 for writing  

              -- WB Control signals
       		selwb:         out std_logic;--bit selection for mux
            WR: 		   out std_logic--enable the write on the Register file 
);             
    
  end component;


  ----------------------------------------------------------------
  -- Signals Declaration
  ---------------------------------------------------------------- 

       -- Control Unit Bus signals
       signal en1,en2,RD1,RD2,JMP,BRANCHenable,en3,Mux1Sel,Mux2Sel,en4,FWselwb,selwb,WR,stall: std_logic;
       signal ALUCODE: std_logic_vector(3 downto 0);
		
	   signal ID_EX_Register_Rd: std_logic_vector(4 downto 0);
       signal IF_ID_Register_Rs1,IF_ID_Register_Rs2: std_logic_vector(4 downto 0);
       --Instruction Memory signal
       signal InstructionToCU : std_logic_vector(31 downto 0);

    


  begin  -- RISCV


    -- Control Unit port map
    CU_I: Cu
      port map (
          -- INPUTS         
              Clk=>Clk, 
              Rst=>Rst,
			  ID_EX_Register_Rd=>ID_EX_Register_Rd,    
			  IF_ID_Register_Rs1=>IF_ID_Register_Rs1,
			  IF_ID_Register_Rs2=>IF_ID_Register_Rs2,
              IR_IN=>InstructionToCU,
              en1=>en1,
       		  en2=>en2,
			  RD1=>RD1,
			  RD2=>RD2,
              JMP=>JMP,
              BRANCHenable=>BRANCHenable,
			  stall=>stall,   
			  en3=>en3,
       		  Mux1Sel=>Mux1Sel,
       		  Mux2Sel=>Mux2Sel,
              ALUCODE=>ALUCODE,
  			  en4=>en4,
			  FWselwb=>FWselwb,
              MemoryEnable=>MemoryEnable,
              ReadNotWrite=>ReadNotWrite,
       		  selwb=>selwb,
              WR=>WR
              );



    -- DataPath port map 
     DP:dataPath  port map(
         Clock=>Clk,
         Reset=>Rst, 
		 ID_EX_Register_Rd=>ID_EX_Register_Rd,    
		 IF_ID_Register_Rs1=>IF_ID_Register_Rs1,
		 IF_ID_Register_Rs2=>IF_ID_Register_Rs2, 
         Instruction=>  Instruction,
         en1=>en1,                                            
  		 en2=>en2,
		 RD1=>RD1,
		 RD2=>RD2,
		 WR=>WR,
         JMP=>JMP, 
         BRANCHenable=>BRANCHenable,
	     stall=>stall, 
  		 en3=>en3,
         Mux1Sel=>Mux1Sel,
  		 Mux2Sel=>Mux2Sel,
         ALUCODE=>ALUCODE,
  		 en4=>en4,
		 FWselwb=>FWselwb,
		 DRAMout=>DRAMout,
  		 selwb=>selwb,
         PCtoIM=>PCtoIM,
         ALUtoMEMORY=>ALUtoMEMORY, 
         OUT2RFtoMEMORY=>OUT2RFtoMEMORY,
         InstructionToCU=>InstructionToCU
);
end RISCV_rtl;


configuration CFG_RISCV of RISCV is
  for RISCV_rtl
  end for;
end CFG_RISCV;

configuration  CFG_RISCV of RISCV is
  for RISCV_rtl 	
  	for all: dataPath
	     use configuration WORK.CFG_dataPath ;
   end for;		
   for all :Cu
      use configuration WORK.CFG_CU_RTL;
   end for;

  end for;
end CFG_RISCV ;

