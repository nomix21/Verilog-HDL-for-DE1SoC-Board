module random (
	input clk,
	input reset_n,
	input resume_n,
	output reg [13:0] random,
	output reg rnd_ready
);
	// 14-bit Linear Feedback Shift Register (LFSR)
	// Taps: 14, 5, 3, 1
	reg [13:0] reg_values;
	reg enable = 1;

	always @(posedge clk or negedge reset_n or negedge resume_n) begin
		if (!reset_n) begin
			// The LFSR cannot be all 0 at beginning.
			reg_values <= 14'b11111111111111;
			enable <= 1;
			rnd_ready <= 0;
		end else if (!resume_n) begin
			enable <= 1;
			rnd_ready <= 0;
			reg_values <= reg_values;
		end else begin
			if (enable) begin
				reg_values[13] <= reg_values[0];
				reg_values[12:5] <= reg_values[13:6];
				// Tap 5 of the diagram from the lab manual
				reg_values[4] <= reg_values[0] ^ reg_values[5];
				reg_values[3] <= reg_values[4];
				// Tap 3 of the diagram from the lab manual
				reg_values[2] <= reg_values[0] ^ reg_values[3];
				reg_values[1] <= reg_values[2];
				// Tap 1 of the diagram from the lab manual
				reg_values[0] <= reg_values[0] ^ reg_values[1];

                // Output the random number
				/* fill your code here to make sure the random 
				 number is between 0 and 5000 and the number must be a full number */
				random <= (reg_values * 32'd5000) / 32'd16383;// Scale to 0-5000
                if (random >= 0 && random <= 5000) 
                begin 
                    rnd_ready <= 1;
                end else begin
                    rnd_ready <= 0;
                end
			end // end of enable.
		end
	end
endmodule