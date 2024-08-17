
//Von Neumen Memory

module memory(clk,wr,rd,addr,data);

input clk,wr,rd;
input[4:0] addr;
inout[7:0] data;

reg[7:0] memory[31:0];

always @(posedge clk) begin
	if(wr) memory[addr]<=data;
end

assign data = rd?memory[addr]:8'bz;

endmodule
