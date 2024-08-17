

// Accumulator

module accumelator(clk,rst,ld_ac,alu_out,ac_out);

input clk,rst,ld_ac;
input[7:0] alu_out;
output reg[7:0] ac_out;

always @(posedge clk or posedge rst) begin
	if (rst) ac_out<=0;
	else if (ld_ac) ac_out<=alu_out;
end

endmodule