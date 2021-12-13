vlib work
#globals
vcom -reportprogress 300 -work work ./000-globals.vhd

vcom -reportprogress 300 -work work ./InstructionMemory.vhd
#Data memory
vcom -reportprogress 300 -work work ./DataMemory.vhd
#RISCV
vlog -work ./work ../netlist/riscv.v
#Test Bench
vcom -93 -work ./work ./clk_gen.vhd
#vcom -reportprogress 300 -work work ./TB_RISCV.vhd
vlog -work ./work ./TB_RISCV.v


vsim -L /software/dk/nangate45/verilog/msim6.2g work.TB_RISCV

vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /TB_RISCV/UUT=../netlist/riscv.sdf work.TB_RISCV

#vsim -t ps -novopt work.tb_RISCV(test)


#add wave sim:/tb_riscv/iram_i/*
#add wave sim:/tb_riscv/dram_d/*


vcd file ./vcd/RISCV_syn.vcd
vcd add /TB_RISCV/UUT/*



#run 150 ns
