/*
This is a simple register/counter which is used to facilitate implementation of the MOVR and
MOVRHS instructions.
*/

module temp_register (
	input clk, reset_n, load, increment, decrement, 
	input [7:0] data,
	output negative, positive, zero
	);

	// internal register/counter - number of half steps
	reg signed [7:0] counter /*synthesis keep*/; 

always @ (posedge clk) begin
		if (!reset_n)	counter <= 8'sd0;

		// When load temp control signal asserted, load 8-bit value on its input and stores it into an internal register. 
		else if (load) counter <= data;
		// When the increment temp control signal asserted, increments by 1 the internal counter.
		else if (increment) counter <= counter + 8'sd1;
		// When the decrement temp control signal asserted, decrements  by 1 the internal counter.
		else if (decrement) counter <= counter - 8'sd1;
end

// status outputs, signals are forwarded to the control unit for decision-making purposes
assign zero = (counter == 0);
assign positive = (counter > 0);
assign negative = (counter < 0);

endmodule
