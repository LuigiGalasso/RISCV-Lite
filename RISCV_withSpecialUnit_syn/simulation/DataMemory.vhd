library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;

--Data memory--
entity DRAM is
  port (
    Clk :          in std_logic;
    Rst :          in std_logic;
    MemoryEnable:  in std_logic;
    ReadNotWrite:  in std_logic;
    DRAMadd:       in std_logic_vector(31  downto 0);
    DRAMin:        in std_logic_vector(31 downto 0);
    DRAMout:       out std_logic_vector(31 downto 0)
);               
end DRAM;


 architecture behavioral of DRAM is

	type DRAM_type is array (0 to 10000) of integer;  --Matrix of #Adresses x WordSize
	signal DRAM : DRAM_type :=(others=>0);
	
	
begin
	



--clockwise write 
	MEM_WRITE: process(Clk,RST) is
	file mem_fp: text;
    variable file_line : line;
    variable index : integer := 8192;
    variable tmp_data_u : std_logic_vector(31 downto 0);
	begin
	 if (Rst = '1') then
       file_open(mem_fp,"data.mem",READ_MODE);
        while (not endfile(mem_fp)) loop
        readline(mem_fp,file_line);
        hread(file_line,tmp_data_u);
        DRAM(index) <= conv_integer(unsigned(tmp_data_u));       
        index := index + 4;
        end loop;
    end if;
			    if (Clk'event and  Clk= '1') then
		      if MemoryEnable = '1' then
			       if ReadNotWrite = '0' then
				        DRAM (conv_integer(unsigned(DRAMadd))) <= conv_integer(unsigned(DRAMin));
		        
		        end if;--if read/write
		    end if;-- if enable
   end if;


 
	end process;
--asynchronous read
MEM_READ: process(DRAM,ReadNotWrite,DRAMadd) is
begin
if(ReadNotWrite='1') then
DRAMOut <= conv_std_logic_vector(DRAM(conv_integer(unsigned(DRAMadd))),32);
else
DRAMOut <= (others=>'0');
end if;
end process;

end behavioral;

configuration CFG_DRAM of DRAM is
  for behavioral
  end for;
end CFG_DRAM;
