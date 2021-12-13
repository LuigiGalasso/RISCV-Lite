

//timescale 1ns

module TB_RISCV ();

    wire Clk_i;
   	wire Rst_i;


	wire [31:0] DRAMout_i;
	wire [31:0] Instruction_i;

    wire [63:0] PCtoIM_i;
    wire [63:0] ALUtoMEMORY_i;      
    wire [63:0] OUT2RFtoMEMORY_i;

    wire memoryenable_i;
    wire ReadNotWrite_i;
         

   clk_gen CG(   
  	               .Clk(Clk_i),
	                .Rst(Rst_i));



   RISCV UUT(       .Clk(Clk_i),
	                .Rst(Rst_i),
                  .DRAMout(DRAMout_i),
                  .Instruction(Instruction_i),
                  .PCtoIM(PCtoIM_i),
                  .ALUtoMEMORY(ALUtoMEMORY_i),
                  .OUT2RFtoMEMORY(OUT2RFtoMEMORY_i),
                  .memoryEnable(memoryenable_i),
                  .ReadNotWrite(ReadNotWrite_i));
 
	IRAM  IRAM_I(
        .Rst   (Rst_i),
         .Addr  (PCtoIM_i[31:0]),
         .Dout (Instruction_i));
     
     DRAM DRAM_D(
      .Clk(Clk_i) ,        
      .Rst(Rst_i),        
      .MemoryEnable(memoryenable_i),
      .ReadNotWrite(ReadNotWrite_i),
      .DRAMadd(ALUtoMEMORY_i[31:0]),
      .DRAMin(OUT2RFtoMEMORY_i[31:0]),
      .DRAMout(DRAMout_i));

endmodule


