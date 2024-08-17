`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2024 07:16:10 PM
// Design Name: 
// Module Name: riscv_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Risc Test


module riscv_tb();

reg clk,rst;
wire halt;

// opcode instructions

localparam[2:0] HALT=0,SKZ=1,ADD=2,AND=3,XOR=4,LDA=5,STO=6,JMP=7;

parameter CLK_PERIOD=10;

riscv DUT(clk,rst,halt);

task cmp_halt(input halt_exp);
	if(halt!=halt_exp) $display("time=%0d : Test Failed!",$time);
	else $display("time=%0d : Test Passed!",$time);
endtask

initial begin
	clk=0;
	forever
	#(CLK_PERIOD/2) clk=~clk;
end

initial begin

    $readmemh("risc_memory.mem",DUT.mem.memory);

	$display("Testing reset");
	DUT.mem.memory[0]={HALT,5'bx};
	rst=1;
	cmp_halt(0);

	$display("Testing HALT instruction");
	DUT.mem.memory[0]={HALT,5'bx};
	#(CLK_PERIOD);
	rst=0;
	#(CLK_PERIOD*5);
    cmp_halt(1);
    
    $display("Testing JUMP instruction");
     // consider mem location 1 has JMP instruction to mem location 2 which has a HALT instruction
     DUT.mem.memory[0]={JMP,5'd2};
     DUT.mem.memory[2]={HALT,5'bx};
     rst=1;
     #(CLK_PERIOD);
     rst=0;
     #(CLK_PERIOD*13);
     cmp_halt(1);
     
     $display("Testing SKZ instruction");
     //consider inst[0] has SKZ if acc=0(zero flag up) so it should skip inst[1] and go to inst[2]
     DUT.mem.memory[0]={SKZ,5'bx};
     DUT.mem.memory[1]={JMP,5'd4};
     DUT.mem.memory[2]={HALT,5'bx};
     rst=1;
     #(CLK_PERIOD);
     rst=0;
     #(CLK_PERIOD*13);
     cmp_halt(1);
     
     $display("Testing LDA instruction");
     DUT.mem.memory[0]={LDA,5'd5};
     DUT.mem.memory[1]={JMP,5'd3};
     DUT.mem.memory[2]={HALT,5'bx};
     DUT.mem.memory[3]={JMP,5'd6};
     DUT.mem.memory[4]={HALT,5'd3};
     DUT.mem.memory[5]=8'b11111111;
     DUT.mem.memory[6]={HALT,5'bx};
     rst=1;
     #(CLK_PERIOD);
     rst=0;
     #(CLK_PERIOD*29);
     cmp_halt(1);
     
     $display("Testing STO instruction");
         DUT.mem.memory[0] ={LDA,5'd7};
         DUT.mem.memory[1] ={STO,5'd8};
         DUT.mem.memory[2] ={LDA,5'd9};
         DUT.mem.memory[3] ={SKZ,5'bx};
         DUT.mem.memory[4] ={HALT,5'd4};
         DUT.mem.memory[5] ={HALT,5'bx};
         DUT.mem.memory[7] =8'h7f;
         DUT.mem.memory[8] =8'd0;
         DUT.mem.memory[9] =8'd0;
         rst=1;
         #(CLK_PERIOD);
         rst=0;
         #(CLK_PERIOD*45);
         cmp_halt(1);
         
         $display("Testing AND instruction");
             DUT.mem.memory[0] ={LDA,5'd7};
             DUT.mem.memory[1] ={AND,5'd8};
             DUT.mem.memory[2] ={STO,5'd8};
             DUT.mem.memory[3] ={AND,5'd9};
             DUT.mem.memory[4] ={SKZ,5'bx};
             DUT.mem.memory[5] ={JMP,5'd0};
             DUT.mem.memory[6] ={HALT,5'bx};
             DUT.mem.memory[7] =8'h7d;
             DUT.mem.memory[8] =8'h9e;
             DUT.mem.memory[9] =8'd0;
             rst=1;
             #(CLK_PERIOD);
             rst=0;
             #(CLK_PERIOD*45);
             cmp_halt(1);
         
             $display("Testing ADD instruction");
             DUT.mem.memory[0] ={LDA,5'd7};
             DUT.mem.memory[1] ={ADD,5'd8};
             DUT.mem.memory[2] ={STO,5'd8};
             DUT.mem.memory[3] ={AND,5'd9};
             DUT.mem.memory[4] ={SKZ,5'bx};
             DUT.mem.memory[5] ={JMP,5'd0};
             DUT.mem.memory[6] ={HALT,5'bx};
             DUT.mem.memory[7] =8'h92;
             DUT.mem.memory[8] =8'h57;
             DUT.mem.memory[9] =8'd0;
             rst=1;
             #(CLK_PERIOD);
             rst=0;
             #(CLK_PERIOD*45);
             cmp_halt(1);
         
             $display("Testing XOR instruction");
             DUT.mem.memory[0] ={LDA,5'd7};
             DUT.mem.memory[1] ={XOR,5'd8};
             DUT.mem.memory[2] ={STO,5'd8};
             DUT.mem.memory[3] ={XOR,5'd8};
             DUT.mem.memory[4] ={SKZ,5'bx};
             DUT.mem.memory[5] ={JMP,5'd0};
             DUT.mem.memory[6] ={HALT,5'bx};
             DUT.mem.memory[7] =8'h92;
             DUT.mem.memory[8] =8'h87;
             DUT.mem.memory[9] =8'd0;
             rst=1;
             #(CLK_PERIOD);
             rst=0;
             #(CLK_PERIOD*45);
             cmp_halt(1);
             
             #50
             $stop;

end

endmodule
