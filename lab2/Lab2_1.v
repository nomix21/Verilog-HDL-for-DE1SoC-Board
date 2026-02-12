module lab2(
 input CLOCK_50,
 input [3:0] KEY,
 output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
 output [9:0] LEDR
);
	 parameter [2:0] BLINKING = 2'b000, WAIT = 2'b001, CHEAT1 = 2'b010, CHEAT2 = 2'b011, CHEAT3 = 2'b100, GAME = 2'b101;
	 reg [2:0] current_state = BLINKING, next_state = BLINKING;
	
    wire [3:0] d0, d1, d2, d3, d4, d5; 
    reg [3:0] digit0, digit1, digit2, digit3, digit4, digit5; 
    wire clk_ms;
	 
	 wire [19:0] ms, display_ms;
	 reg counter_reset;
	 wire [13:0] random_wait_time;
	 reg [13:0] wait_time;
	 wire rnd_ready;
	 
	 
	 lfsr random(clk_ms, KEY[1], KEY[2], random_wait_time, rnd_ready);

    clock_divider clock_divider(.clk(CLOCK_50), .reset_n(KEY[1]), .clk_ms(clk_ms));
	 counter (.clk(clk_ms), .reset_n(KEY[1]), .resume_n(counter_reset), .enable(1), .ms_count(ms));
	 
	blink b1(clk_ms, KEY[1], d0, d1, d2, d3, d4,d5);
	
    
    seven_seg_decoder decoder0(digit0, HEX0);
    seven_seg_decoder decoder1(digit1, HEX1);
    seven_seg_decoder decoder2(digit2, HEX2);
    seven_seg_decoder decoder3(digit3, HEX3);
    seven_seg_decoder decoder4(digit4, HEX4);
    seven_seg_decoder decoder5(digit5, HEX5);
	 
	 always @(posedge CLOCK_50 or negedge KEY[1]) begin
    if (!KEY[1]) begin
        current_state <= BLINKING;   // reset state
		  wait_time <= 0;
    end
    else begin
        current_state <= next_state;
         if (current_state == BLINKING && next_state == WAIT)
            wait_time <= random_wait_time;
    end
end

	 
	 
	 // Next state logic
    always @(*) begin
        case (current_state)
            BLINKING: begin
                if (ms>=5000)
                    next_state = WAIT;
                else
                    next_state = BLINKING;
            end
            
            WAIT: begin
					
                if (!KEY[0] & KEY[3])
                    next_state = CHEAT1;
                else if (!KEY[3] & KEY[0])
                    next_state = CHEAT2;
					else if (!KEY[0] & !KEY[3])
						next_state = CHEAT3;
					else if (ms >= wait_time)
						next_state = GAME;
					else 
						next_state = WAIT;
            end
            
            CHEAT1: begin
                if (!KEY[2])
                    next_state = WAIT;
                else
                    next_state = CHEAT1;
            end
            
            CHEAT2: begin
                if (!KEY[2])
                    next_state = WAIT;
                else
                    next_state = CHEAT2;
            end
				
				CHEAT3: begin
                if (!KEY[2])
                    next_state = WAIT;
                else
                    next_state = CHEAT3;
            end
				
				GAME: begin
                if (!KEY[2])
                    next_state = WAIT;
                else
                    next_state = GAME;
            end
            
            default: next_state = WAIT;
				
        endcase
    end
	 
	 always@(*) begin
	
        case (current_state)
				BLINKING:  begin
				counter_reset = 1;
								digit0 = d0;
							  digit1 = d1;
							  digit2 = d2;
							  digit3 = d3;
							  digit4 = d4;
							  digit5 = d5;
				end 
            WAIT:     begin
				counter_reset = 1;
				digit0 = 4'b1111;
							 digit1 = 4'b1111;
							 digit2 = 4'b1111;
							 digit3 = 4'b1111;
							 digit4 = 4'b1111;
							 digit5 = 4'b1111;
							 end
            CHEAT1:  begin
				 counter_reset = 0;
				digit0 = 4'b0001;
							 digit1 = 4'b0001;
							 digit2 = 4'b0001;
							 digit3 = 4'b0001;
							 digit4 = 4'b0001;
							 digit5 = 4'b0001;
							 end
            CHEAT2:  begin
				 counter_reset = 0;
				digit0 = 4'b0010;
							 digit1 = 4'b0010;
							 digit2 = 4'b0010;
							 digit3 = 4'b0010;
							 digit4 = 4'b0010;
							 digit5 = 4'b0010;
							 end
            CHEAT3:  begin
				 counter_reset = 0;
				digit0 = 4'b1000;
							 digit1 = 4'b1000;
							 digit2 = 4'b1000;
							 digit3 = 4'b1000;
							 digit4 = 4'b1000;
							 digit5 = 4'b1000;
							end
            GAME: begin
				counter_reset = 1;
				digit0 = 4'b0011;
							 digit1 = 4'b0011;
							 digit2 = 4'b0011;
							 digit3 = 4'b0011;
							 digit4 = 4'b0011;
							 digit5 = 4'b0011;
							 end
        endcase
    end
	 
endmodule