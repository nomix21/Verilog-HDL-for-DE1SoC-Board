module demo (
    input CLOCK_50,
    input [0:0] KEY,
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    wire [11:0] random;
	 reg [11:0] selected_random;
	 
    wire rnd_ready;
	 wire clk_ms;
	 
	 wire [3:0] bcd0, bcd1, bcd2, bcd3, bcd4, bcd5;
	
	 clock_divider cd(.clk(CLOCK_50), .reset_n(KEY[0]), .clk_ms(clk_ms));
    lfsr rnd(.clk(clk_ms), .reset_n(KEY[0]), .resume_n(1'b1), .random(random), .rnd_ready(rnd_ready));
    hex_to_bcd_converter h2b(.clk(clk_ms), .hex_number(selected_random), .bcd_digit_0(bcd0), .bcd_digit_1(bcd1), .bcd_digit_2(bcd2), .bcd_digit_3(bcd3), .bcd_digit_4(bcd4), .bcd_digit_5(bcd5));
	 
	 seven_seg_decoder ssd0(.digit(bcd0), .HEX(HEX0));
    seven_seg_decoder ssd1(.digit(bcd1), .HEX(HEX1));
    seven_seg_decoder ssd2(.digit(bcd2), .HEX(HEX2));
    seven_seg_decoder ssd3(.digit(bcd3), .HEX(HEX3));
    seven_seg_decoder ssd4(.digit(bcd4), .HEX(HEX4));
    seven_seg_decoder ssd5(.digit(bcd5), .HEX(HEX5));
	 
	 always @ (posedge clk_ms) begin
		 if (!KEY[0]) begin
			selected_random <= random;    
		 end
	 end
	 
endmodule