vlib work
#globals
vcom -reportprogress 300 -work work ./000-globals.vhd
#Fetch
vcom -reportprogress 300 -work work ./DataPath.core/reg64.vhd
vcom -reportprogress 300 -work work ./DataPath.core/adder.vhd
vcom -reportprogress 300 -work work ./DataPath.core/InstructionRegister.vhd
vcom -reportprogress 300 -work work ./DataPath.core/mux21.vhd


#Decode
vcom -reportprogress 300 -work work ./DataPath.core/BranchUnit.vhd
vcom -reportprogress 300 -work work ./DataPath.core/ImmidiateSignExtender.vhd
vcom -reportprogress 300 -work work ./DataPath.core/registerfile.vhd  
#Execute

vcom -reportprogress 300 -work work ./DataPath.core/comparator.vhd
vcom -reportprogress 300 -work work ./DataPath.core/specialUnit.vhd
vcom -reportprogress 300 -work work ./DataPath.core/mux31.vhd
vcom -reportprogress 300 -work work ./DataPath.core/mux41.vhd
vcom -reportprogress 300 -work work ./DataPath.core/alu.vhd

#Memory Unit
#WB Unit

#DATAPATH
vcom -reportprogress 300 -work work ./DataPath.core/fetchUnit.vhd
vcom -reportprogress 300 -work work ./DataPath.core/DecodeUnit.vhd
vcom -reportprogress 300 -work work ./DataPath.core/executeUnit.vhd
vcom -reportprogress 300 -work work ./DataPath.core/memoryUnit.vhd
vcom -reportprogress 300 -work work ./DataPath.core/WBunit.vhd
vcom -reportprogress 300 -work work ./DataPath.core/ForwardingUnit.vhd
vcom -reportprogress 300 -work work ./DataPath.core/BranchForwardingUnit.vhd
vcom -reportprogress 300 -work work ./dataPath.vhd

#Control Unit
vcom -reportprogress 300 -work work ./HazardDetectionUnit.vhd
vcom -reportprogress 300 -work work ./HWCU.vhd
#Instruction memory
vcom -reportprogress 300 -work work ./InstructionMemory.vhd
#Data memory
vcom -reportprogress 300 -work work ./DataMemory.vhd
#DLX
vcom -reportprogress 300 -work work ./RISCV.vhd
#Test Bench
vcom -reportprogress 300 -work work ./TB_RISCV.vhd

vsim -t ps -novopt work.tb_RISCV(test)

add wave sim:/tb_riscv/u1/*
add wave sim:/tb_riscv/u1/dp/fu/*
add wave sim:/tb_riscv/u1/dp/du/*
add wave sim:/tb_riscv/u1/dp/du/rf/*
add wave sim:/tb_riscv/u1/dp/bfwu/*
add wave sim:/tb_riscv/u1/dp/fwu/*
add wave sim:/tb_riscv/u1/dp/eu/*
add wave sim:/tb_riscv/u1/cu_i/*
add wave sim:/tb_riscv/iram_i/*
add wave sim:/tb_riscv/dram_d/*



run 110 ns
