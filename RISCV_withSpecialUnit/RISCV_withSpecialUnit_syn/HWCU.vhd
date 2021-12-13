library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.globals.all;
use work.all;

entity Cu is
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
    end Cu;

architecture structural of Cu is

component HazardDetectionUnit is
  port 	 (

		ID_EX_MEMRead:in std_logic;--cw bit to enable the read from memory 
		ID_EX_BranchEnable:in std_logic;--cw bit to enable the read from memory 
		ID_EX_Register_Rd: in std_logic_vector(4 downto 0);
        IF_ID_Register_Rs1,IF_ID_Register_Rs2: in std_logic_vector(4 downto 0);
        bubble:out std_logic;
	    stall:out std_logic

		);
end component;
                                
  signal IR_opcode : std_logic_vector(6 downto 0);  -- OpCode part of IR
  signal IR_func3 : std_logic_vector(2 downto 0);   -- Func3 part of IR 
  signal aluOpcode  : std_logic_vector (3 downto 0) := (others =>'0');--NOPaluOpcode;

  -- control word is shifted to the correct stage
  signal cw2 : std_logic_vector(12  downto 0); -- second stage--13 bit   
  signal cw3 : std_logic_vector(7   downto 0); -- third stage -- 8 bit         
  signal cw4 : std_logic_vector(4   downto 0); -- fourth stage-- 5 bit 
  signal cw5 : std_logic_vector(1   downto 0); -- fifth stage -- 3 bit

  signal aluOpcode3 : std_logic_vector (3 downto 0) := (others =>'0');--AluOpcode for Execution stage
  
  signal bubble,internal_stall:  std_logic;--coming from the hazard detection unit
  signal ID_EX_MEMRead: std_logic;	
  


begin

  IR_opcode <=IR_IN(6  downto  0);
  IR_func3  <=IR_IN(14 downto 12);
  ID_EX_MEMRead<=(cw3(3) AND cw3(2));

LoadHazard:HazardDetectionUnit port map (

		ID_EX_MEMRead=>ID_EX_MEMRead,
		ID_EX_BranchEnable=>  cw2(8),
		ID_EX_Register_Rd=>ID_EX_Register_Rd,
        IF_ID_Register_Rs1=>IF_ID_Register_Rs1,
		IF_ID_Register_Rs2=>IF_ID_Register_Rs1,
        bubble=>bubble,
	    stall=>internal_stall
		);

--en1    --en2,RD1,RD2,JMP,BRANCHenable  --en3,mux1Sel,mux2Sel  --en4,memoryEnable,ReadNotWrite,FWselwb--   selwb,WR--
-- stage one control signals
  en1  <= (Rst NOR (bubble OR internal_stall));
-- stage two control signals
  en2  <=            cw2(12);
  RD1  <=            cw2(11);
  RD2   <=           cw2(10);
  JmP   <=           cw2(9);   
  BRANCHenable <=    cw2(8);


  ALUCODE<=aluOpcode3;
-- stage three control signals
  en3   <=           cw3(7);
  mux1Sel  <=        cw3(6); 
  mux2Sel <=         cw3(5);
-- stage four control signals  
  en4   <=           cw4(4);
  memoryEnable  <=   cw4(3); 
  ReadNotWrite<=     cw4(2); 
  FWselwb        <=  cw4(0); 
-- stage five control signals  
  selwb  <=          cw5(1);
  WR  <=             cw5(0);

stall<=internal_stall;
 -- process to pipeline control words and aluCode
  CW_PIPE: process (Clk,Rst,bubble,internal_stall)
  begin  -- process Clk
     if Clk'event and Clk = '1' then     -- rising clock edge
    if (Rst = '1' ) then   -- Rst (active high)
     cw3 <= (others => '0');
     cw4 <= (others => '0');
     cw5 <= (others => '0');


   else 
     cw3 <= cw2(7 downto 0);			
	 cw4 <= cw3(4 downto 0);
     cw5 <= cw4(1 downto 0);	
   
     aluOpcode3 <= aluOpcode;--small pipeline for ALUOPCODE-> just 2 stages from Decode to Execute
	
	   end if;
    end if;
  end process CW_PIPE;

      

-- process to compute the correct ALU code and Contro Word
ALU_OP_CODE_P : process (IR_opcode, IR_func3,Rst,bubble,internal_stall)
   begin  
   if (Rst = '1' OR bubble='1') then 
   cw2 <= (others => '0');
   aluOpcode <=  (others =>'0');
   else
-- case of R type and I type instructions require the analysis of FUNC3 field for what concern the other instructions they require the analysis of the only opcode 
--We used the same configuration defined on the globals file for this selection
--en2,RD1,RD2,JMP,BRANCHenable  --en3,mux1Sel,mux2Sel  --en4,memoryEnable,ReadNotWrite--   selwb,WR--
	case conv_integer(unsigned(IR_opcode)) is
		when 51 =>cw2<="1110010010011";--R type
			case conv_integer(unsigned(IR_func3)) is     
				when 0 => aluOpcode <=  ALUOP_ADD; -- ADD
				when 1 => aluOpcode <=  ALUOP_ABS; -- ABS
				when 2 => aluOpcode <=  ALUOP_SLT; -- SLT
				when 4 => aluOpcode <=  ALUOP_XOR; -- XOR

				when others => aluOpcode <=  (others =>'0');--NOPaluOpcode;
			end case;
		when 19 =>cw2<="1110010110011";--I type
			case conv_integer(unsigned(IR_func3)) is    
				when 0 => aluOpcode <=  ALUOP_ADD; -- ADDI
				when 7 => aluOpcode <=  ALUOP_AND; -- ANDI
				when 5 => aluOpcode <=  ALUOP_SRA; -- SRAI
				when others => aluOpcode <=  (others =>'0');--NOPaluOpcode;
			end case;
   --en2,RD1,RD2,JMP,BRANCHenable  --en3,mux1Sel,mux2Sel  --en4,memoryEnable,ReadNotWrite--   selwb,WR--					
		when 3    => aluOpcode  <=  ALUOP_ADD ;cw2<= "1100010111101";  --LW    
		when 35   => aluOpcode  <=  ALUOP_ADD ;cw2<= "1110010111010";  --SW   
		when 99   => aluOpcode  <=  ALUOP_ADD ;cw2<= "1110110010010";  --BEQ  
		when 111  => aluOpcode  <=  ALUOP_ADD ;cw2<= "1001011010011";  --JAL  
		when 55   => aluOpcode  <=  ALUOP_ADD ;cw2<= "1000010110011";  --LUI  --chosen to not use x0 nevere so Nop corresponds to x0<=x0 ADD x0
		when 23   => aluOpcode  <=  ALUOP_ADD ;cw2<= "1000011110011";  --AUIPC
		when others => aluOpcode <=  (others =>'0');--NOPaluOpcode;
	 end case;
  end if;
	end process ALU_OP_CODE_P;


end structural;

configuration CFG_CU_RTL of Cu is
  for structural
	  for all: HazardDetectionUnit
       use configuration WORK.CFG_HazardDetectionUnit;
      end for;
  end for;
	
end configuration;
