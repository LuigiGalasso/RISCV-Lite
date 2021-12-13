library IEEE;
use WORK.globals.all;
use IEEE.std_logic_1164.all;
use WORK.all;

entity tb_riscv is

end tb_riscv;

architecture TEST of tb_riscv is


 
    signal Clk: std_logic := '0';
    signal Rst: std_logic := '1';


	signal DRAMout: std_logic_vector(31 downto 0);
	signal Instruction: std_logic_vector(31 downto 0);

    signal PCtoIM  :  std_logic_vector(63 downto 0);--Program counter value sent to the Instruction Memory
    signal ALUtoMEMORY: std_logic_vector(63 downto 0);      
    signal OUT2RFtoMEMORY:  std_logic_vector(63 downto 0);

    signal memoryEnable: std_logic;
    signal ReadNotWrite:  std_logic;--1 for reading, 0 for writing







    component riscv 

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
    end component;


  component IRAM
    port (
      Rst  : in  std_logic;
      Addr : in  std_logic_vector(31 downto 0);
      Dout : out std_logic_vector(31 downto 0));
  end component;

  -- Data Ram 
 component DRAM is
   port (
     Clk :          in std_logic;
     Rst :          in std_logic;
     MemoryEnable:  in std_logic;
     ReadNotWrite:  in std_logic;
    DRAMadd:       in std_logic_vector(31  downto 0);
    DRAMin:        in std_logic_vector(31 downto 0);
    DRAMout:       out std_logic_vector(31 downto 0)
 );
 end component;

begin


        -- instance of riscv
	U1: riscv
	Port Map (

    Clk =>Clk,
    Rst => Rst,
	DRAMout => DRAMout,
	Instruction => Instruction,

    PCtoIM  => PCtoIM,
    ALUtoMEMORY => ALUtoMEMORY,     
    OUT2RFtoMEMORY => OUT2RFtoMEMORY,

    memoryEnable => memoryEnable,
    ReadNotWrite => ReadNotWrite

	);


 IRAM_I: IRAM
   port map (
         Rst  => Rst,
         Addr => PCtoIM(31 downto 0),
        Dout => Instruction);
    -- Data Memory port map   
    DRAM_D: DRAM
     port map (
      Clk           => Clk ,        
      Rst           => Rst,        
      MemoryEnable  => MemoryEnable,
      ReadNotWrite  => ReadNotWrite,
      DRAMadd       => ALUtoMEMORY(31 downto 0),
      DRAMin        => OUT2RFtoMEMORY(31 downto 0),
      DRAMout       => DRAMout  
);





	

  PCLOCK : process(Clk)
	begin
		Clk <= not(Clk) after 0.5 ns;	
	end process;
	
	Rst <= '0', '1' after 0.5 ns,'0' after 1.5 ns;
       

end TEST;

-------------------------------

configuration CFG_TB of tb_riscv  is
	for TEST
	end for;
end CFG_TB;

configuration  CFG_TB of tb_riscv is
  for TEST	
  	for all: riscv
	    use configuration WORK.CFG_riscv;
   end for;	
   for all: DRAM	
      use configuration WORK.CFG_DRAM;
   end for;
   for all: IRAM	
      use configuration WORK.CFG_IRAM;
   end for;	
  end for;
end CFG_TB ;

