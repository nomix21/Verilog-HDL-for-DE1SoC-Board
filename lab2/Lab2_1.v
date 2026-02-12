module Lab2_1(
 input CLOCK_50,
 input [3:0] KEY,
 output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
	blink b1(CLOCK_50, KEY[1], HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
endmodule