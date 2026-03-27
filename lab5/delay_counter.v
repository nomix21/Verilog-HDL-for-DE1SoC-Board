module delay_counter (
    input clk, reset_n, start, enable,
    input [7:0] delay,
    output reg done
);

parameter BASIC_PERIOD = 20'd5; // smaller for simulation

reg [7:0] delay_counter;
reg [19:0] inner_couter;

always @(posedge clk) begin
    
    if (!reset_n) begin
        inner_couter <= 0;
        delay_counter <= 0;
        done <= 0;



assign done = done_reg; //assign done to the least significant bit of done_reg


    always @(posedge clk) begin
        if(!reset_n) begin
            first_counter <= 0; //if reset_n is 0 then reset first_counter to 0
            second_counter <= 0; //if reset_n is 0 then reset second_counter to 0
            internal_delay <= 0; //if reset_n is 0 then reset internal_delay to 0
            done_reg <= 0; //if reset_n is 0 then reset done_reg to 0
        end

        else if (start) begin
            internal_delay <= delay; //if start is 1 then load delay into internal_delay
            done_reg <= 0; //if start is 1 then reset done_reg to 0
        end


        else if (enable) begin
          if (first_counter < BASIC_PERIOD) begin
            first_counter <= first_counter + 1; //time counter
            done_reg <= 0;
          end 
          else if(second_counter < internal_delay && first_counter == BASIC_PERIOD) begin
              second_counter <= second_counter + 1; 
              first_counter <= 0;
              done_reg <= 0;
          end
          else if (second_counter == internal_delay)  begin
            done_reg <= 1;
            second_counter <= 0;
            first_counter <= 0;
          end 
          else done_reg <= 0;
        end

        else done_reg <= 8'b00000000; //default case
    end
    else if (start) begin
        inner_couter <= 0;
        delay_counter <= delay;
        done <= 0;
    end
    
    else if (enable) begin
        if (inner_couter < BASIC_PERIOD-1)
         inner_couter <= inner_couter + 1;
        else begin
			inner_couter <= 0;
			if (delay_counter == 1) begin
				 delay_counter <= 0;
				 done <= 1;
			end else begin
				 delay_counter <= delay_counter - 1;
			end
        end
    end
end

endmodule
