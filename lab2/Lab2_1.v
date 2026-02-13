module lab2(
 input CLOCK_50,
 input [3:0] KEY,
 output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
 output [9:0] LEDR
);
	 parameter [2:0] RESET = 3'b000, BLINKING = 3'b001, WAIT = 3'b010, GAME	= 3'b011, WINNER_TIME_DISPLAY = 3'b100, CHEAT = 3'b101;
	 reg [2:0] current_state = RESET, next_state = RESET;
	
  wire [3:0] digit0, digit1, digit2, digit3, digit4, digit5; // out of mux
	 wire [3:0] blink0, blink11, blink2, blink3, blink4, blink5; // blinking
		wire [3:0] bcd0, bcd1, bcd2, bcd3, bcd4, bcd5; // time
		reg [3:0] set_all; // 1,2,8, off SET ALL

  wire clk_ms;
	 wire [19:0] ms, display_ms;
		
	 wire w_counter_enable;
		reg counter_enable;
		assign w_counter_enable = counter_enable;

		wire [1:0] w_mux; 
		reg [1:0] mux;
		assign w_mux = mux;

		reg [4:0] player1 = 5'b00000, player2 = 5'b00000;
		reg player1_win, player2_win;
		reg [19:0] winner_timer = 20'b00000000000000000000;
		wire [19:0] wire_winner_timer;
		assign wire_winner_timer = winner_timer;
		assign LEDR[4:0]	= player1;
		assign	LEDR[9:5] = player2;
		reg p1_pushed, p2_pushed;
		reg p1_cheating, p2_cheating;

	 wire [13:0] w_wait_time;
	 wire rnd_ready;
	 
	 lfsr random(clk_ms, KEY[1], KEY[2], w_wait_time, rnd_ready);

  clock_divider clock_divider(.clk(CLOCK_50), .reset_n(KEY[1]), .clk_ms(clk_ms));

	 counter (.clk(clk_ms), .reset_n(KEY[1]), .resume_n(KEY[2]), .enable(1), .ms_count(ms)); // global time
		counter (.clk(clk_ms), .reset_n(KEY[1]), .resume_n(KEY[2]), .enable(w_counter_enable), .ms_count(display_ms));  // reaction time
	 
	blink b1(clk_ms, KEY[1], blink0, blink1, blink2, blink3, blink4, blink5);
	hex_to_bcd_converter bcd(clk_ms, KEY[1], display_ms, bcd0, bcd1, bcd2, bcd3, bcd4, bcd5);

	mux m0(w_mux, blink0, set_all, bcd0, bcd0, digit0);
	mux m1(w_mux, blink1, set_all, bcd1, bcd1, digit1);
	mux m2(w_mux, blink2, set_all, bcd2, bcd2, digit2);
	mux m3(w_mux, blink3, set_all, bcd3, bcd3, digit3);
	mux m4(w_mux, blink4, set_all, bcd4, bcd4, digit4);
	mux m5(w_mux, blink5, set_all, bcd5, bcd5, digit5);

    seven_seg_decoder decoder0(digit0, HEX0);
    seven_seg_decoder decoder1(digit1, HEX1);
    seven_seg_decoder decoder2(digit2, HEX2);
    seven_seg_decoder decoder3(digit3, HEX3);
    seven_seg_decoder decoder4(digit4, HEX4);
    seven_seg_decoder decoder5(digit5, HEX5);
	 
always @(posedge CLOCK_50, negedge KEY[1], negedge KEY[2]) begin
    if (!KEY[1]) begin
        current_state <= RESET;   // reset state
				end else if (!KEY[2]) begin
					current_state <= WAIT;    // reset to wait state when player presses button
				end 
    else begin
        current_state <= next_state;
    end
end

always @(posedge CLOCK_50) begin
	p1_pushed = KEY[0];
	p2_pushed = KEY[3];
end

	always @(posedge CLOCK_50, negedge KEY[1] )    //for solving the inferred latch problem caused by win1 and win2.
	begin 
		if (!KEY[1]) begin
			player1<=5'b00000;
			player2<=5'b00000;
		end			
		else if (player1_win==1)
				player1<=(player1<<1) | 5'b00001;
		else if (player2_win==1)
				player2<=(player2<<1) | 5'b00001;
	end

	always @(*) begin
			next_state = current_state;
			player1_win = 0;
			player2_win = 0;
			counter_enable = 0;

			case(current_state)
			RESET:	begin
				counter_enable = 0;
				winner_timer = 0;
				mux = 2'b00; // blink
				next_state = BLINKING;
			end
			BLINKING: begin
				mux = 2'b00;
				counter_enable=0;
				winner_timer=0;

				if (ms >= 5000)begin
						mux = 2'b01; // Off
						next_state = WAIT;
				end else
				next_state = BLINKING;
			end
			
			WAIT:begin
					set_all = 4'b1111; // all OFF
					mux = 2'b01; // set all

					if (ms	>= 5000+w_wait_time) begin
						counter_enable = 0;
						next_state = GAME;
					end

					if (p1_pushed == 0) begin
						p1_cheating = 1'b1;
					end else begin
					p1_cheating	= 1'b0;
					end

					if (p2_pushed == 0) begin
						p2_cheating = 1'b1;
					end else begin
					p2_cheating	= 1'b0;
					end					
			end
			GAME:	begin
				set_all = 4'b1000;
				counter_enable = 1;
				mux = 2'b10; // time

				if ((p1_cheating == 1 && p2_cheating == 1)||(p1_pushed == 0 && p2_pushed == 0)) begin
						set_all = 4'b1000;
						next_state = CHEAT;
				end else if (p1_cheating == 1) begin
					set_all = 4'b0001; // all 1s
					next_state = CHEAT;
				end else if (p2_cheating == 1) begin
					set_all = 4'b0010; // all 2s
					next_state = CHEAT;
				end else if (p1_pushed == 0) begin
						counter_enable = 0;
						player1_win = 1;
						winner_timer = display_ms;
						next_state = WINNER_TIME_DISPLAY;
				end else if (p2_pushed == 0) begin
						counter_enable = 0;
						player2_win = 1;
						winner_timer = display_ms;
						next_state = WINNER_TIME_DISPLAY;
				end
			end
			
			WINNER_TIME_DISPLAY: begin
				mux = 2'b10;	// winner time
				winner_timer = winner_timer;
			end
			
			CHEAT:	begin
				mux	= 2'b01; // set all
			end

			default: begin
			next_state = RESET;
			end
			
			endcase

	end

	endmodule