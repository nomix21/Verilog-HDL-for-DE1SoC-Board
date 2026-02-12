module Lab2_1(
 input CLOCK_50,
 input [3:0] KEY,
 output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
 output [9:0] LEDR
);

    wire [3:0] d0, d1, d2, d3, d4, d5; 
    wire [3:0] digit0, digit1, digit2, digit3, digit4, digit5; 
    wire clk_ms;

    clock_divider clock_divider(.clk(CLOCK_50), .reset_n(KEY[0]), .clk_ms(clk_ms));

	blink b1(CLOCK_50, KEY[1], d0, d1, d2, d3, d4,d5);
    assign digit0 = d0;
    assign digit1 = d1;
    assign digit2 = d2;
    assign digit3 = d3;
    assign digit4 = d4;
    assign digit5 = d5;
    seven_seg_decoder decoder0(digit0, HEX0);
    seven_seg_decoder decoder1(digit1, HEX1);
    seven_seg_decoder decoder2(digit2, HEX2);
    seven_seg_decoder decoder3(digit3, HEX3);
    seven_seg_decoder decoder4(digit4, HEX4);
    seven_seg_decoder decoder5(digit5, HEX5);

endmodule