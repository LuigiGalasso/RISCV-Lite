library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;


-- Instruction memory for RISCV
-- Memory filled by a process which reads from a file
entity IRAM is
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(31 downto 0);
    Dout : out std_logic_vector(31 downto 0)
    );

end IRAM;

architecture IRam_Bhe of IRAM is

  type RAMtype is array (0 to 1023) of integer;

  signal IRAM_mem : RAMtype;

begin  -- IRam_Bhe

  Dout <= conv_std_logic_vector(IRAM_mem(conv_integer(unsigned(Addr))),32);

  -- purpose: This process is in charge of filling the Instruction RAM with the firmware
  -- type   : combinational
  -- inputs : Rst
  -- outputs: IRAM_mem
  FILL_MEM_P: process (Rst)
    file mem_fp: text;
    variable file_line : line;
    variable index : integer := 0;
    variable tmp_data_u : std_logic_vector(31 downto 0);
  begin  -- process FILL_MEM_P
    if (Rst = '1') then
      file_open(mem_fp,"test_special.asm.mem",READ_MODE);
      while (not endfile(mem_fp)) loop
        readline(mem_fp,file_line);
        hread(file_line,tmp_data_u);
        IRAM_mem(index) <= conv_integer(unsigned(tmp_data_u));       
        index := index + 4;
      end loop;
    end if;
  end process FILL_MEM_P;

end IRam_Bhe;


configuration CFG_IRAM of IRAM is
  for IRam_Bhe
  end for;
end CFG_IRAM;
