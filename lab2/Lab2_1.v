module lab2(
	input CLOCK_50,
	input [3:0] KEY,
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output [9:0] LEDR
);
<<<<<<< HEAD
	// State parameters
	parameter [2:0] BLINKING = 2'b000, WAIT = 2'b001, CHEAT1 = 2'b010, CHEAT2 = 2'b011, CHEAT3 = 2'b100, GAME = 2'b101;

	// State registers
	reg [2:0] current_state = BLINKING, next_state = BLINKING;

	// Display wires and registers
	wire [3:0] d0, d1, d2, d3, d4, d5;
	reg [3:0] digit0, digit1, digit2, digit3, digit4, digit5;

	// Clock divider
	wire clk_ms;

	// Counter signals
	wire [19:0] ms, display_ms;
	reg counter_reset;

	// Random number signals
	wire [13:0] random_wait_time;
	reg [13:0] wait_time;
	wire rnd_ready;

	// Module instantiations
	lfsr random(clk_ms, KEY[1], KEY[2], random_wait_time, rnd_ready);
	clock_divider clock_divider(.clk(CLOCK_50), .reset_n(KEY[1]), .clk_ms(clk_ms));
	counter counter(.clk(clk_ms), .reset_n(KEY[1]), .resume_n(counter_reset), .enable(1), .ms_count(ms));
	blink b1(clk_ms, KEY[1], d0, d1, d2, d3, d4, d5);

	// Seven segment decoders
	seven_seg_decoder decoder0(digit0, HEX0);
	seven_seg_decoder decoder1(digit1, HEX1);
	seven_seg_decoder decoder2(digit2, HEX2);
	seven_seg_decoder decoder3(digit3, HEX3);
	seven_seg_decoder decoder4(digit4, HEX4);
	seven_seg_decoder decoder5(digit5, HEX5);

	// State register update logic
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
				if (ms >= 5000)
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

	// Output logic
	always @(*) begin
		case (current_state)
			BLINKING: begin
				counter_reset = 1;
				digit0 = d0;
				digit1 = d1;
				digit2 = d2;
				digit3 = d3;
				digit4 = d4;
				digit5 = d5;
			end

			WAIT: begin
				counter_reset = 1;
				digit0 = 4'b1111;
				digit1 = 4'b1111;
				digit2 = 4'b1111;
				digit3 = 4'b1111;
				digit4 = 4'b1111;
				digit5 = 4'b1111;
			end

			CHEAT1: begin
				counter_reset = 0;
				digit0 = 4'b0001;
				digit1 = 4'b0001;
				digit2 = 4'b0001;
				digit3 = 4'b0001;
				digit4 = 4'b0001;
				digit5 = 4'b0001;
			end

			CHEAT2: begin
				counter_reset = 0;
				digit0 = 4'b0010;
				digit1 = 4'b0010;
				digit2 = 4'b0010;
				digit3 = 4'b0010;
				digit4 = 4'b0010;
				digit5 = 4'b0010;
			end

			CHEAT3: begin
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





module blink(input ms_clk, Reset_n, output reg [3:0] d0, d1, d2, d3, d4,d5);
	//to make HEX LEDs display 0s and to be off alternatively.
	parameter factor=1000; // frequency 
	reg [11:0] countQ;    //2's power of 12 is 4096, well enough in ms to blink LED
	always @ (posedge ms_clk, negedge Reset_n)
	begin
		if (!Reset_n) begin
				countQ<=0;
				d0<=4'b1000;
				d1<=4'b1000;
				d2<=4'b1000;
				d3<=4'b1000;
				d4<=4'b1000;
				d5<=4'b1000;
			end 
		else 	begin 
				if (countQ<factor/2) 
					begin
						countQ<=countQ+1;
						d0<=4'b1000;
						d1<=4'b1000;
						d2<=4'b1000;
						d3<=4'b1000;
						d4<=4'b1000;
						d5<=4'b1000;
					end
				else if (countQ<factor)
					begin
						countQ<=countQ+1;
						d0<=4'b1111;
						d1<=4'b1111;
						d2<=4'b1111;
						d3<=4'b1111;
						d4<=4'b1111;
						d5<=4'b1111;
					end
				else	//countQ==factor					
					begin 
						countQ<=0;
						d0<=4'b1000;
						d1<=4'b1000;
						d2<=4'b1000;
						d3<=4'b1000;
						d4<=4'b1000;
						d5<=4'b1000;
					end		
		end  //end else 
	end  //alwas	
endmodule

module clock_divider(
    input clk, 
    input reset_n, 
    output reg clk_ms
);
    parameter factor = 50000;
    reg [31:0] countQ;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            countQ <= 32'd0;
            clk_ms <= 1'b0;         // Fixed: 1-bit
        end
        else begin
            // Increment and wrap counter
            if (countQ == factor - 1) begin
                countQ <= 32'd0;
            end
            else begin
                countQ <= countQ + 1;
            end
            
            // Set output based on counter
            if (countQ < factor / 2) begin
                clk_ms <= 1'b0;     // Fixed: 1-bit
            end
            else begin
                clk_ms <= 1'b1;     // Fixed: 1-bit
            end
        end
    end endmodule


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


module seven_seg_decoder(input [3:0] digit, output [6:0] HEX);
    reg [6:0] reg_LEDs;
    //assign HEX[6:0]=reg_LEDs[6:0];
    assign HEX = reg_LEDs;
    always @(*) begin
        case (digit)
            4'b0000: reg_LEDs[6:0]=7'b1000000; // decimal 0
            4'b0001: reg_LEDs[6:0]=7'b1111001; // decimal 1
            4'b0010: reg_LEDs[6:0]=7'b0100100; // decimal 2
            4'b0011: reg_LEDs[6:0]=7'b0110000; // decimal 3
            4'b0100: reg_LEDs[6:0]=7'b0011001; // decimal 4
            4'b0101: reg_LEDs[6:0]=7'b0010010; // decimal 5
            4'b0110: reg_LEDs[6:0]=7'b0000010; // decimal 6
            4'b0111: reg_LEDs[6:0]=7'b1111000; // decimal 7
            4'b1000: reg_LEDs[6:0]=7'b0000000; // decimal 8
            4'b1001: reg_LEDs[6:0]=7'b0010000; // decimal 9
            4'b1111: reg_LEDs[6:0]=7'b1111111; // decimal Off
            default: reg_LEDs[6:0]=7'b1111111; // for input greater than 1111
        endcase
    end
endmodule


module counter(
    input clk, 
    input reset_n, 
    input start_n,   // start counting
    input stop_n,    // pause counting
    output reg [WIDTH-1:0] ms_count
);
    parameter WIDTH = 19;
	 reg flag = 0;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ms_count <= {WIDTH{1'b0}};   // reset counter
			end else if (!start_n) begin
				flag = 1;
			end else if (!stop_n) begin
				flag = 0;
			end else if (flag == 1) begin
            ms_count <= ms_count + 1'b1; // increment only when started and not stopped
        end 
	
        // else hold value (pause)
    end
endmodule

=======
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
>>>>>>> c44927b3a651a6d7312b705af6a1d533154fdba3
