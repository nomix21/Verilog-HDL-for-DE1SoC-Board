module pc (input clk, reset_n, branch, increment, input [7:0] newpc,
			output reg [7:0] pc);
parameter RESET_LOCATION = 8'h00;

/*PC is a register that contains the program counter. It contains the memory address of the instruction
currently being executed. The PC can be incremented by asserting the increment pc control signal.
The PC can also be loaded with a new value (on branch) by asserting the commit branch control
signal*/
			
endmodule
