
library ieee;
use ieee.std_logic_1164.all;

package globals is
   constant Address    		 : integer := 5;
   constant DoubleWordSize   : integer := 64;		
  -- CW size
  constant CW_SIZE : integer := 17;
  -- ALU Operation
  constant ALUOP_SIZE : integer := 4;
  -- OPCODE
  constant OPCODE_SIZE : integer := 7;
  -- FUNCTION3 FIELD SIZE
  constant FUNC3_SIZE : integer := 3;
  -- FUNCTION7 FIELD SIZE
  constant FUNC7_SIZE : integer := 7;

--following the hennessy-patterson green card opcodes and functions were assigned, but not all the ITYPE instructions have the same opcode

--add,addi,auipc,lui,beq,lw,srai,andi,xor,slt,jal,sw
--ITYPE
constant OPCODE_LW  : std_logic_vector(OPCODE_SIZE-1 downto 0):="0000011";
constant OPCODE_ADDI: std_logic_vector(OPCODE_SIZE-1 downto 0):="0010011";
constant OPCODE_ANDI: std_logic_vector(OPCODE_SIZE-1 downto 0):="0010011";
constant OPCODE_SRAI: std_logic_vector(OPCODE_SIZE-1 downto 0):="0010011";
CONSTANT ITYPE		: std_logic_vector(OPCODE_SIZE-1 downto 0):="0010011";
--STYPE
constant OPCODE_SW: std_logic_vector(OPCODE_SIZE-1 downto 0):="0100011";
CONSTANT STYPE: std_logic_vector(OPCODE_SIZE-1 downto 0):="0100011";
--RTYPE
constant OPCODE_ADD: std_logic_vector(OPCODE_SIZE-1 downto 0):="0110011";
constant OPCODE_SLT: std_logic_vector(OPCODE_SIZE-1 downto 0):="0110011";
constant OPCODE_XOR: std_logic_vector(OPCODE_SIZE-1 downto 0):="0110011";
CONSTANT RTYPE: std_logic_vector(OPCODE_SIZE-1 downto 0):="0110011";
--SBTYPE
constant OPCODE_BEQ: std_logic_vector(OPCODE_SIZE-1 downto 0):="1100011";
CONSTANT SBTYPE: std_logic_vector(OPCODE_SIZE-1 downto 0):="1100011";
--UJTYPE
constant OPCODE_JAL: std_logic_vector(OPCODE_SIZE-1 downto 0):="1101111";
CONSTANT UJTYPE: std_logic_vector(OPCODE_SIZE-1 downto 0):="1101111";
--UTYPE
constant OPCODE_LUI: std_logic_vector(OPCODE_SIZE-1 downto 0):="0110111";
constant OPCODE_AUIPC: std_logic_vector(OPCODE_SIZE-1 downto 0):="0010111";
CONSTANT UTYPE: std_logic_vector(OPCODE_SIZE-1 downto 0):="0110111";
--functions
--ITYPE
constant FUNC3_LW: std_logic_vector(FUNC3_SIZE-1 downto 0):="010";
constant FUNC3_ADDI: std_logic_vector(FUNC3_SIZE-1 downto 0):="000";
constant FUNC3_ANDI: std_logic_vector(FUNC3_SIZE-1 downto 0):="111";
constant FUNC3_SRAI: std_logic_vector(FUNC3_SIZE-1 downto 0):="101";
constant FUNC7_SRAI: std_logic_vector(FUNC7_SIZE-1 downto 0):="0100000";
--STYPE
constant FUNC3_SW: std_logic_vector(FUNC3_SIZE-1 downto 0):="010";
--RTYPE
constant FUNC3_ADD: std_logic_vector(FUNC3_SIZE-1 downto 0):="000";
constant FUNC7_ADD: std_logic_vector(FUNC7_SIZE-1 downto 0):="0000000";
constant FUNC3_SLT: std_logic_vector(FUNC3_SIZE-1 downto 0):="010";
constant FUNC7_SLT: std_logic_vector(FUNC7_SIZE-1 downto 0):="0000000";
constant FUNC3_XOR: std_logic_vector(FUNC3_SIZE-1 downto 0):="100";
constant FUNC7_XOR: std_logic_vector(FUNC7_SIZE-1 downto 0):="0000000";
--SBTYPE
constant FUNC3_BEQ: std_logic_vector(FUNC3_SIZE-1 downto 0):="000";





  -- ALU OPERATION

  constant ALUOP_SRA      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0010";
  constant ALUOP_ADD      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0011";

  constant ALUOP_AND      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0101";

  constant ALUOP_XOR      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0111";
  constant ALUOP_SLT     : std_logic_vector(ALUOP_SIZE-1 downto 0) := "1000";
  constant ALUOP_NOP      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0000";



end globals;
