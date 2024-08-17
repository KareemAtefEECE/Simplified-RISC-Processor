
// Risc Module

module riscv(clk,rst,halt);

input clk,rst;
output halt;

wire zero,rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel;
wire[2:0] opcode,phase;
wire[4:0] pc_addr,ir_addr,addr;
wire[7:0] data,alu_out,ac_out;

control_unit cu(zero,phase,rst,opcode,rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel);
memory mem(clk,wr,rd,addr,data);
alu alu(ac_out,data,opcode,alu_out,zero);
pc pc(clk,rst,ld_pc,inc_pc,ir_addr,pc_addr);
phase_generator phase_gen(clk,rst,phase);
accumelator ac(clk,rst,ld_ac,alu_out,ac_out);
instruction_reg ir(clk,rst,ld_ir,data,ir_addr,opcode);
mux m(ir_addr,pc_addr,sel,addr);
driver tribuff(alu_out,data_en,data);

endmodule