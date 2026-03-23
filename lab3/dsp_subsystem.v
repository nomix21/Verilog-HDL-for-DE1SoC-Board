module dsp_subsystem (input sample_clock,  input reset, input [1:0] selector, input [15:0] input_sample, output reg [15:0] output_sample);

wire [15:0] w_out_sample;
wire [15:0] w_echo_out, w_fir_out;

assign w_out_sample = input_sample;

shiftregister (.clock(sample_clock),.shiftin(w_out_sample),.shiftout(w_echo_out),.taps());
fir_filter (.clk(sample_clock), .input_sample(w_out_sample), .taps(), .output_sample(w_fir_out));

always@(*) begin
	case(selector)
		2'b00 : output_sample = input_sample;
		2'b01 : output_sample = w_fir_out >> 15; 
		2'b10 : output_sample = input_sample + (w_echo_out >> 2); 
      default: output_sample = input_sample;
   endcase
end

endmodule
