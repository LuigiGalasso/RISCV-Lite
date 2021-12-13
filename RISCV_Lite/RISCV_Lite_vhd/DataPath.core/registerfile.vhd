library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.globals.all;
use WORK.all;

entity register_file is
 port ( CLK  : 		IN std_logic;
        RESET: 		IN std_logic;
		ENABLE: 	IN std_logic;
		RD1: 		IN std_logic;
		RD2: 		IN std_logic;
		WR: 		IN std_logic;
		ADD_WR: 	IN std_logic_vector(4 downto 0);
		ADD_RD1: IN std_logic_vector(4 downto 0);
		ADD_RD2:	IN std_logic_vector(4 downto 0);
		DATAIN: 	IN std_logic_vector(63 downto 0);
        OUT1: 		 OUT std_logic_vector(63 downto 0);
									OUT2: 		 OUT std_logic_vector(63 downto 0));
end register_file;

architecture A of register_file is

      
 subtype REG_ADDR is natural range 0 to 31; -- using natural type
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(63 downto 0); 
	signal REGISTERS : REG_ARRAY; 
	
	
begin 

	WRITE: process(CLK,RESET,WR,ADD_WR,DATAIN)
	begin
	
			if RESET ='1' then
				rstloop: for j in 0 to 31 loop
				REGISTERS(j)(63 downto 0)<=(others =>'0');
				end loop;
			elsif RESET ='0' and ENABLE ='1' then
			if (CLK'event and CLK= '1') then
				if WR ='1' then
				for i in 0 to 63 loop
				REGISTERS(to_integer(unsigned(ADD_WR)))(i) <= DATAIN(i);
				end loop;
				end if;
			 end if;
				end if;
				

	end process;


	READ: process(registers,ENABLE,RD1,RD2,ADD_RD1,ADD_RD2,WR)
	begin

				if RD1 ='1' then
					if (ADD_WR=ADD_RD1 AND WR='1') then
					 OUT1<=DATAIN;
					else
					for i in 0 to 63 loop
						OUT1(i) <= REGISTERS(to_integer(unsigned(ADD_RD1)))(i);
					end loop;
					end if;

				elsif RD1 ='0' then
    				for i in 0 to 63 loop
						OUT1(i) <= REGISTERS(0)(i);
					end loop;
				end if;
				
				if RD2 ='1' then
					if ( ADD_WR=ADD_RD2 AND WR='1') then
					OUT2<=DATAIN;
					else
					for i in 0 to 63 loop
						OUT2(i) <= REGISTERS(to_integer(unsigned(ADD_RD2)))(i);
					end loop;
					end if;
				elsif RD2 ='0' then
					for i in 0 to 63 loop
						OUT2(i) <= REGISTERS(0)(i);
					end loop;
				end if;
				


	end process;
end A;



configuration CFG_register_file of register_file is
  for A
  end for;
end configuration;
