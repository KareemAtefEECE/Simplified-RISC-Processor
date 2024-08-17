
// ALU

module alu(in_a,in_b,opcode,alu_out,a_is_zero);

input[7:0] in_a,in_b;
input[2:0] opcode;
output reg[7:0] alu_out;
output a_is_zero;

assign a_is_zero = (!in_a)?1:0;

always @(*) begin
	case(opcode)
	0,1,6,7:alu_out=in_a;
	2:alu_out=in_a+in_b;
	3:alu_out=in_a&in_b;
	4:alu_out=in_a^in_b;
	5:alu_out=in_b;
	default:alu_out=0;
	endcase
end

endmodule