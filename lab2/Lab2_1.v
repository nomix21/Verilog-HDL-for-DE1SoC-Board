module Lab2_1(
 input CLOCK_50,
 input [3:0] KEY,
 output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
 wire [3:0] d0, d1, d2, d3, d4, d5
);

	blink b1(CLOCK_50, KEY[1], d0, d1, d2, d3, d4,d5);
    seven_seg_decoder decoder0(d0, HEX0);
    seven_seg_decoder decoder1(d1, HEX1);
    seven_seg_decoder decoder2(d2, HEX2);
    seven_seg_decoder decoder3(d3, HEX3);
    seven_seg_decoder decoder4(d4, HEX4);
    seven_seg_decoder decoder5(d5, HEX5);
endmodule