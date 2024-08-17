
// Program Counter

module pc(clk,rst,ld_pc,inc_pc,ir_addr,pc_addr);

input clk,rst,ld_pc,inc_pc;
input[4:0] ir_addr;
output[4:0] pc_addr;
reg[4:0] counter;

always @(posedge clk or posedge rst) begin
	if (rst) counter<=0;
	else begin
		if(ld_pc) counter<=ir_addr;
		else if(inc_pc) counter<=counter+1;
	end
end

assign pc_addr = counter;

endmodule