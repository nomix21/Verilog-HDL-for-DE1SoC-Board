module op2_mux (input [1:0] select, input [7:0] register, immediate,
				output reg [7:0] result);
				
/*multiplexer*/
/*select 1 of 4 input for operandb for ALU*/
	always @(*) begin
		case (select)
			2'b00: result = register; //if select is 00 then result is register
			2'b01: result = immediate; //if select is 01 then result is immediate oprand specified by instruction
			2'b10: result = 8'b00000001; //if select is 10 then result is 1
			2'b11: result = 8'b00000010; //if select is 11 then result is 2
			default: result = 8'b00000000; //default case
		endcase
	end
				
endmodule
