
//The function of this starterkit:
//1. After compile and download the starter kit to DE1-SoC board, the HEX LEDs will blink.
//2. After 6 seconds, the LDER9 is on, indicating the player 2 wins one time.
//3. Each tinm the KEY2 is pressed, the player 2 will win one more time after 6 secconds.
//4. Press KEY1 will reset the project.




//The requirements for your project:

// 1.   	Key1 for reset, Key2 for resume, Key0 is player 1, Key3 is for player 2
// 2.   	If Key0 is pressed earlier than Key3, player 1 wins. If Key3 is pressed earlier, player2 wins.
// 3. 	If Key0 and Key3 pressed at the same time, no one wins. 
// 4. 	If player1 wins, one more LEDs of the LED0-4 will light up.If player2 wins, one more LEDs of the LED=9-5 will light up,  
// 5. 	After power up, or after reset, all of LEDs are off. the HEXs will blink for 5 seconds. then will be off for  2+randdom seconds.
			//Here the random ranges form 1 sec to 5 sec
// 6. 	The winner's reaction time will show by the HEXs.
//	7. 	If there is a cheating (press the KEY0 or KEY3 before the timer starts,(in program, (set that if the timer reading is less than 
			//80 ms, it is cheating)
			//the cheater's number, either 111111 or 222222 will show by HEXs. The program then stop for resumeing for next round.
//	8. 	if both player is cheating at the same time (or both player pressed at the same time, which is not likely to happen), display 888888 by HEXs and then wait to resume the game.



`default_nettype none
module lab2(input CLOCK_50,  input [3:0] KEY,  output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5, output [9:0] LEDR);
	parameter [2:0] RESET=3'b000, RESUME=3'b001, BLINKING=3'b010, OFF=3'b011, TIMER_DISPLAY=3'b100, WINNER_TIME_DISPLAY=3'b101,WIN1=3'b110, WIN2=3'b111;
	reg [2:0] ps=RESET, ns=RESET;
	wire clk_ms;
	wire [19:0] ms, display_ms; //milisecond counter for blinking and display timer
	wire [3:0] w_ms0,w_ms1,w_ms2,w_ms3, w_ms4,w_ms5; //wires after hex_to_bcd_converter.v for displayed time
	wire [3:0] w_blink0, w_blink1, w_blink2, w_blink3, w_blink4, w_blink5;  //wires afer  blinking 
	wire [3:0] winner_ms0,winner_ms1,winner_ms2,winner_ms3, winner_ms4,winner_ms5; //wires afer hex_to_bcd_converter.v for winner time
	wire [3:0] digit_0, digit_1, digit_2, digit_3, digit_4, digit_5;  //wires afer mux.v
	wire [13:0] random_wait_time;
	//MULTIPLEXER
	reg [1:0]  sel=2'b00;  //whether blinking or not
	wire [1:0] w_sel; 
	//DISPLAY
	reg display_counter_start;
	wire w_display_counter_start;
	reg p1_win, p2_win;   // if is 0, not win, if 1 win,
	reg[4:0] win1=5'b00000, win2=5'b00000;   // score for player 1 and 2.
	reg [19:0]temp;
	reg [19:0] winner_time=8888;
	wire [19:0] w_winner_time;
	wire conditioned_key0, conditioned_key3;
	//call other module for constant assignment
	clock_divider #(.factor(50000)) (.Clock(CLOCK_50), .Reset_n(KEY[1]), .Pulse_ms(clk_ms));
	counter (.clk(clk_ms), .reset_n(KEY[1]), .resume_n(KEY[2]), .enable(1), .ms_count(ms));
	counter (.clk(clk_ms), .reset_n(KEY[1]), .resume_n(KEY[2]), .enable(w_display_counter_start), .ms_count(display_ms));
	
	blinkHEX #(.factor(200) ) (.ms_clk(clk_ms), .Reset_n(KEY[1]), .d0(w_blink0), .d1(w_blink1), .d2(w_blink2), .d3(w_blink3), .d4(w_blink4),.d5(w_blink5));

	seven_seg_decoder  decoder0(digit_0, HEX0);
	seven_seg_decoder  decoder1(digit_1, HEX1);
	seven_seg_decoder  decoder2(digit_2, HEX2);
	seven_seg_decoder  decoder3(digit_3, HEX3);
	seven_seg_decoder  decoder4(digit_4, HEX4);
	seven_seg_decoder  decoder5(digit_5, HEX5);
	
	//constant assignment (output depend on the state)
	assign w_winner_time=winner_time;
	assign w_sel=sel;
	assign w_display_counter_start=display_counter_start; 
	assign LEDR[4:0]=win1;
	assign LEDR[9:5]={win2[0],win2[1],win2[2],win2[3],win2[4]} ;   
	assign digit_0=w_blink0;
	assign digit_1=w_blink1;
	assign digit_2=w_blink2;
	assign digit_3=w_blink3;
	assign digit_4=w_blink4;
	assign digit_5=w_blink5;
	assign random_wait_time=1000;
	
	//state transition
	always @ (posedge CLOCK_50, negedge KEY[1], negedge KEY[2])
	begin
		if (!KEY[1]) 		begin	ps<=RESET; 	end   // reset	
		else if (!KEY[2])   begin	ps<=RESUME;	end //start/resume
		else				begin	ps<=ns;	   	end
	end
	//
	always @(posedge CLOCK_50, negedge KEY[1] )    //for solving the inferred latch problem caused by win1 and win2.
	begin 
		if (!KEY[1]) 			 begin win1<=5'b00000;	win2<=5'b00000; end			
		else if (p1_win==1) begin win1<=(win1<<1) | 5'b00001; end
		else if (p2_win==1) begin win2<=(win2<<1) | 5'b00001; end
	end
	
		
	
	//Combinational logic for next state and output
	always @ (*) 
	begin
		ns=ps;   //default
		p1_win=0;
		p2_win=0;
		case (ps)
			RESET: 
				begin					
					display_counter_start=0; 	winner_time=0;		sel=2'b00; 	ns=BLINKING;			
				end
			RESUME:
				begin					
					display_counter_start=0;	winner_time=0; 		sel=2'b00;	ns=BLINKING;
				end
			BLINKING:
				begin //blink for  about 5 second	
					if (ms>=5000)	begin ns=OFF; end
					else 			begin ns=BLINKING; end
				end
			OFF:
				begin
					sel=2'b01;	//(7-5) seconds + random seconds)			
					if (ms>(7000+random_wait_time)) begin ns=TIMER_DISPLAY; end
				end
			TIMER_DISPLAY:
				begin
					 sel=2'b10;	display_counter_start=1; 
					if (display_ms>1000) begin p2_win=1; ns=WINNER_TIME_DISPLAY; end
				end
			WINNER_TIME_DISPLAY:
				begin
					sel=2'b11; winner_time=winner_time;
				end
			default: begin ns=RESET; end
		endcase	
	end
endmodule