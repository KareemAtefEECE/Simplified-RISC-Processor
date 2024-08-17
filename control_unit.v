
// Control Unit Module

module control_unit(zero,phase,rst,opcode,rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel);

input zero,rst;
input[2:0] phase,opcode;
output reg rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel;

reg HALT,ALUOP,SKZ,JMP,STO;

always @(*) begin
	HALT = (opcode==0)?1:0;
	SKZ = (opcode==1)?1:0;
	JMP = (opcode==7)?1:0;
	STO = (opcode==6)?1:0;
	ALUOP = (opcode==2 || opcode==3 || opcode==4 || opcode==5)?1:0;
end

always @(*) begin
	if(rst) {rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel}=9'b000000001;
	else begin
		case(phase)
		0:{rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel}=9'b000000001;
		1:{rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel}=9'b100000001;
		2:{rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel}=9'b101000001;
		3:{rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel}=9'b101000001;
		4:{rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel}={5'b00000,1'b1,HALT,2'b00};
		5:{rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel}={ALUOP,8'h00};
		6:{rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel}={ALUOP,3'b000,JMP,(SKZ&&zero),1'b0,STO,1'b0};
		7:{rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_en,sel}={ALUOP,STO,1'b0,ALUOP,JMP,2'b00,STO,1'b0};
                endcase
	end
end

endmodule
