module alu (input add_sub, set_low, set_high, input [7:0] operanda , operandb, output reg [7:0] result);
/*compute 1 of 4 operation*/
    	always @(*) begin
            if (set_low) result = {{operanda[7:4]}, {operandb[3:0]}}; //if set_low is 1 then set low bits of result to operandb and high bits to operanda
            else if (set_high) result = {{operandb[3:0]}, {operanda[3:0]}}; //if set_high is 1 then set high bits of result to operandb and low bits to operanda
            else begin
                if (add_sub) result = operanda - operandb; //if alu_add_sub is 1 then subtract
                else result = operanda + operandb; //if alu_add_sub is 0 then add
            end
	    end
endmodule
