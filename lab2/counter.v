// Counter logic to reset the counter, to stop (enable) the counter without resetting the current value, and to resume counting after being pause
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