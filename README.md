# Simplified-RISC-Processor

Designed a reduced-instruction-set processor where it features a streamlined architecture with a 3-bit opcode 
and a 5-bit operand resulting in a list of 8 instructions and an addressable space of 32 locations, the processor operates 
based on a clock and a reset signal, it outputs a halt signal to indicate the end of execution.

# Risc Processor Diagram

<div align="center">
  <img src="https://github.com/KareemAtefEECE/Simplified-RISC-Processor/blob/main/images/RISC processor.png" alt=" RISC Diagram">
</div>
<br>

This processor was designed to execute 8 different instructions upon its corresponding opcode which is clarified in this table:

| Opcode/Instruction  | Opcode Encoding | Operation | Output                  |
|-------------------- |-----------------|-----------|-------------------------|
| HALT                | 000             | PASS AC   | ac_out = alu_out       |
| SKZ                 | 001             | PASS AC    | ac_out = alu_out         |
| ADD                 | 010             | ADD       | ac_out + data = alu_out  |
| AND                 | 011             | AND       | ac_out & data = alu_out  |
| XOR                 | 100             | XOR       | ac_out ^ data => alu_out  |
| LDA                 | 101             | PASS Data   | data => alu_out         |
| STO                 | 110             | PASS AC   | ac_out => alu_out         |
| JMP                 | 111             | PASS AC   | ac_out => alu_out         |

<br>

Where each instruction is executed through a set of micro-instructions each one in a one-clock cycle and the phase generator does that as clear through this state diagram:

 ```mermaid
graph LR
    INST_ADDR --> INST_FETCH
    INST_FETCH --> INST_LOAD
    INST_LOAD --> IDLE
    IDLE --> OP_ADDR
    OP_ADDR --> OP_FETCH
    OP_FETCH --> ALU_OP
    ALU_OP --> STORE
    STORE --> INST_ADDR
    INST_ADDR -->|rst| INST_ADDR
```
<br>

At executing each phase(micro-instructions) control unit begins to release the control signals required to execute this micro-instruction correctly as clear in the table below:

| Outputs | INST_ADDR | INST_FETCH | INST_LOAD | IDLE | OP_ADDR | OP_FETCH | ALU_OP | STORE |
|---------|-----------|------------|-----------|------|---------|----------|--------|-------|
| sel     | 1         | 1          | 1         | 1    | 0       | 0        | 0      | 0     |   
| rd      | 0         | 1          | 1         | 1    | 0       | ALUOP    | ALUOP  | ALUOP |   
| ld_ir   | 0         | 0          | 1         | 1    | 0       | 0        | 0      | 0     |      
| halt    | 0         | 0          | 0         | 0    | HALT    | 0        | 0      | 0     |     
| inc_pc  | 0         | 0          | 0         | 0    | 1       | 0        | SKZ && zero | 0 |  
| ld_ac   | 0         | 0          | 0         | 0    | 0       | 0        |  0     | ALUOP |
| ld_pc   | 0         | 0          | 0         | 0    | 0       | 0        | JMP   | JMP   |
| wr      | 0         | 0          | 0         | 0    | 0       | 0        | 0      | STO   |
| data_e  | 0         | 0          | 0         | 0    | 0       | 0        | STO   | STO   |



