module regfile (input clk, reset_n, write, 
	input [7:0] data, 
	input [1:0] select0, select1, wr_select,
	output reg [7:0] selected0, selected1, 
	output [7:0] delay, position, register0
);

// The comment /* synthesis preserve */ after the declaration of a register
// prevents Quartus from optimizing it, so that it can be observed in simulation
// It is important that the comment appear before the semicolon
reg [7:0] reg0 /* synthesis preserve */;
reg [7:0] reg1 /* synthesis preserve */;
reg [7:0] reg2 /* synthesis preserve */;
reg [7:0] reg3 /* synthesis preserve */;

always @ (posedge clk) begin
		
		if (!reset_n) begin
				reg0 <= 8'b00000000;
				reg1 <= 8'b00000000;
				reg2 <= 8'b00000000;
				reg3 <= 8'b00000000;
		end else if (write) begin 
			// Data input can be written to any of the four registers when the write reg file control signal is asserted. 
			// Which register gets written depends on the value of the write select input
			case (wr_select) 	
				2'b00: reg0 <= data;
				2'b01: reg1 <= data;
				2'b10: reg2 <= data;
				2'b11: reg3 <= data;
			endcase
		end
end

// Which register is actually output depends on the 2-bit select signals (select0, select1)
// 2 outputs (selected0 and selected1). Each of these can output the value stored in any of the four registers. 
always @(*) begin
	case (select0)
		2'b00: selected0 = reg0;
		2'b01: selected0 = reg1;
		2'b10: selected0 = reg2;
		2'b11: selected0 = reg3;
	endcase

	case (select1)
		2'b00: selected1 = reg0;
		2'b01: selected1 = reg1;
		2'b10: selected1 = reg2;
		2'b11: selected1 = reg3;
	endcase
end

// Register file CONSTANTLY outputs the values in the registers R0, R2 and R3. 
assign register0 = reg0;
assign delay = reg2;
assign positon = reg3;

endmodule
