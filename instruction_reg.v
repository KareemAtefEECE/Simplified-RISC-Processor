
//Instruction Register

module instruction_reg(clk,rst,ld_ir,data_in,ir_addr,opcode);

input clk,rst,ld_ir;
input[7:0] data_in;
output reg[4:0] ir_addr;
output reg[2:0] opcode;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		ir_addr<=0;
		opcode<=0;
	end
	else if(ld_ir) begin
		ir_addr<=data_in[4:0];
		opcode<=data_in[7:5];
	end
end

endmodule