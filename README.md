# Simplified-RISC-Processor

Designed a reduced-instruction-set processor where it features a streamlined architecture with a 3-bit opcode 
and a 5-bit operand resulting in a list of 8 instructions and an addressable space of 32 locations, the processor operates 
based on a clock and a reset signal, it outputs a halt signal to indicate the end of execution.

Instruction Format : 3 MS bits for opcode other 5 for the operand.

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

<br>

Testing this design was built upon testing the behavior of the processor upon executing each instruction:

# Testing HALT
it was done by a single instruction as resetting is done by executing from the first phase the instruction is stored in the first memory address like this: memory[0]={HALT,5'bx}.

<div align="center">
  <img src="https://github.com/KareemAtefEECE/Simplified-RISC-Processor/blob/main/images/HALT Test.png" alt=" HALT Test">
</div>
<br>

# Testing JMP 
   Was tested as mem location 0 has JMP instruction to mem location 2 which has a HALT instruction <br>

   memory[0]={JMP,5'd2}; <br>

   memory[2]={HALT,5'bx};

<div align="center">
  <img src="https://github.com/KareemAtefEECE/Simplified-RISC-Processor/blob/main/images/JMP Test.png" alt=" JMP Test">
</div>
<br>

# Testing SKZ 
Was tested within this set of instructions <br>
memory[0] has SKZ if acc=0(zero flag up) so it should skip memory[1] and go to memory[2] <br>
memory[0]={SKZ,5'bx}; <br>
memory[1]={JMP,5'd4}; <br>
memory[2]={HALT,5'bx};

<div align="center">
  <img src="https://github.com/KareemAtefEECE/Simplified-RISC-Processor/blob/main/images/SKZ Test.png" alt=" SKZ Test">
</div>
<br>

# Testing LDA 
Was tested within this set of instructions <br>
memory[0]={LDA,5'd5};
<br>
memory[1]={JMP,5'd3};
<br>
memory[2]={HALT,5'bx};
<br>
memory[3]={JMP,5'd6};
<br>
memory[4]={HALT,5'd3};
<br>
memory[5]=8'b11111111;
<br>
memory[6]={HALT,5'bx};

<div align="center">
  <img src="https://github.com/KareemAtefEECE/Simplified-RISC-Processor/blob/main/images/LDA Test.png" alt=" LDA Test">
</div>
<br>

# Testing STO
Was tested within this set of instructions <br>

memory[0] ={LDA,5'd7}; <br>
memory[1] ={STO,5'd8}; <br>
memory[2] ={LDA,5'd9}; <br> 
memory[3] ={SKZ,5'bx}; <br>
memory[4] ={HALT,5'd4}; <br>
memory[5] ={HALT,5'bx}; <br>
memory[7] =8'h7f; <br>
memory[8] =8'd0; <br>
memory[9] =8'd0; <br>

<div align="center">
  <img src="https://github.com/KareemAtefEECE/Simplified-RISC-Processor/blob/main/images/STO Test.png" alt=" STO Test">
</div>
<br>

# Testing AND

Was tested within this set of instructions <br>

memory[0] ={LDA,5'd7}; <br>
memory[1] ={AND,5'd8}; <br>
memory[2] ={STO,5'd8}; <br>
memory[3] ={AND,5'd9}; <br>
memory[4] ={SKZ,5'bx}; <br>
memory[5] ={JMP,5'd0}; <br>
memory[6] ={HALT,5'bx}; <br>
memory[7] =8'h7d; <br>
memory[8] =8'h9e; <br>
memory[9] =8'd0; <br>

<div align="center">
  <img src="https://github.com/KareemAtefEECE/Simplified-RISC-Processor/blob/main/images/AND Test.png" alt=" AND Test">
</div>
<br>

# Testing ADD

Was tested within this set of instructions <br>

memory[0] ={LDA,5'd7}; <br>
memory[1] ={ADD,5'd8}; <br>
memory[2] ={STO,5'd8}; <br>
memory[3] ={AND,5'd9}; <br>
memory[4] ={SKZ,5'bx}; <br>
memory[5] ={JMP,5'd0}; <br>
memory[6] ={HALT,5'bx}; <br>
memory[7] =8'h92; <br>
memory[8] =8'h57; <br>
memory[9] =8'd0; <br>


<div align="center">
  <img src="https://github.com/KareemAtefEECE/Simplified-RISC-Processor/blob/main/images/ADD Test.png" alt=" ADD Test">
</div>
<br>

# Testing XOR

Was tested within this set of instructions <br>

memory[0] ={LDA,5'd7}; <br>
memory[1] ={XOR,5'd8}; <br>
memory[2] ={STO,5'd8}; <br>
memory[3] ={XOR,5'd8}; <br>
memory[4] ={SKZ,5'bx}; <br>
memory[5] ={JMP,5'd0}; <br>
memory[6] ={HALT,5'bx}; <br>
memory[7] =8'h92; <br>
memory[8] =8'h87; <br>
memory[9] =8'd0; <br>

<div align="center">
  <img src="https://github.com/KareemAtefEECE/Simplified-RISC-Processor/blob/main/images/XOR Test.png" alt=" XOR Test">
</div>
<br>

I also used VIVADO to evaluate the RTL and the Synthesized design

<div align="center">
  <img src="https://github.com/KareemAtefEECE/Simplified-RISC-Processor/blob/main/images/Synthesized design.png" alt=" Synthesized design">
</div>
<br>
