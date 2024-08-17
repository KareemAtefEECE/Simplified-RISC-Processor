

// Multiplexer

module mux(in0,in1,sel,mux_out);

input[4:0] in0,in1;
input sel;
output[4:0] mux_out;

assign mux_out = sel?in1:in0;

endmodule