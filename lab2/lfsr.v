module lfsr (input clk, input reset_n, input resume_n, output reg [11:0] random, output reg rnd_ready);
    // 14-bit Linear Feedback Shift Register (LFSR)
    // Taps: 14, 5, 3, 1
	 
	 wire feedback;
    reg [11:0] reg_values;
    reg enable = 1;

	 assign feedback = reg_values[0] ^ reg_values[2] ^ reg_values[4] ^ reg_values[11];
	 initial begin
		 reg_values=12'b111111111111;
			enable=1;
			rnd_ready=0;
		end
		
    always @(posedge clk or negedge reset_n or negedge resume_n) begin
        if (!reset_n) 
		  begin
            // The LFSR cannot be all 0 at beginning.
            reg_values <= 12'b11111111111111;
            enable <= 1;
            rnd_ready <= 0;
        end else if (!resume_n) begin
            enable <= 1;
            rnd_ready <= 0;
            //reg_values <= reg_values;
        end else begin
            if (enable) begin
                reg_values[11] <= reg_values[0];
                reg_values[10:5] <= reg_values[11:6];
					 
                // Tap 5 of the diagram from the lab manual
                reg_values[4] <= reg_values[0] ^ reg_values[5];
                reg_values[3] <= reg_values[4];
					 
                // Tap 3 of the diagram from the lab manual
                reg_values[2] <= reg_values[0] ^ reg_values[3];
                reg_values[1] <= reg_values[2];
					 
                // Tap 1 of the diagram from the lab manual
                reg_values[0] <= reg_values[0] ^ reg_values[1];

                // Output the random number
                random = {reg_values[11:1], feedback} + 12'd2000; // Scale to 0-5000
                
					 /*if (random >= 0 && random <= 5000) 
						 begin 
							  rnd_ready <= 1;
						 end else begin
							  rnd_ready <= 0;
						 end
					*/
            end // end of enable.
        end
    end
endmodule