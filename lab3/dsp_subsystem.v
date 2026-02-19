module dsp_subsystem (input sample_clock,  input reset, input [1:0] selector, input [15:0] input_sample, output reg [15:0] output_sample);

wire [15:0] w_out_sample;
wire [15:0] w_echo_out;

assign w_output_sample = input_sample;

shiftregister (
	// input
	.clock(sample_clock),
	.shiftin(w_out_sample),
	// output
	.shiftout(w_echo_out),
	.taps()
);

always@(*) begin
	case(selector)
		2'b00 : output_sample = input_sample;
		2'b01 : output_sample = input_sample; // UPDATE
		2'b10 : output_sample = input_sample + (w_echo_out >> 2); 
      default: output_sample = input_sample;
   endcase
end

endmodule
