module result_mux (
	input select_result,
	input [7:0] alu_result,
	output reg [7:0] result
);

/*multiplexer*/
/*select 1 of 2 input for result to write back to register file*/
	always @(*) begin
		case (select_result)
			1'b0: result = 8'b00000000; //if select_result is 0 then result is 0
			1'b1: result = alu_result; //if select_result is 1 then result is alu_result
			default: result = 8'b00000000; //default case
		endcase
	end	


endmodule
