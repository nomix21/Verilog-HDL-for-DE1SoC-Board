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
