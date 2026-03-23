module op1_mux (input [1:0] select, input [7:0] pc, register, register0, position,
				output reg [7:0] result);
/*multiplexer*/
/*select 1 of 4 input for operanda for ALU*/
	always @(*) begin
		case (select)
			2'b00: result = pc; //if select is 00 then result is pc
			2'b01: result = register; //if select is 01 then result is register
			2'b10: result = register0; //if select is 10 then result is register0`
			2'b11: result = position; //if select is 11 then result is register2 (position)
			default: result = 8'b00000000; //default case
		endcase
	end				
endmodule
