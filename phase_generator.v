
// Phase Generator

module phase_generator(clk,rst,phase);

input clk,rst;
output reg[2:0] phase;
reg[2:0] counter_up;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		phase<=0;
		counter_up<=0;
	end
	else begin
		counter_up<=counter_up+1;
		phase<=counter_up;
	end
end

endmodule