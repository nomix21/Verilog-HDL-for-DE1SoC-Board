module fir_filter (input clk, input [15:0] input_sample, input [7:0] taps, output [15:0] output_sample);

reg signed [15:0] coeff [16:0]; // 17 16-bit coefficients
reg [15:0] carry [16:0];
wire [15:0] result [16:0];


assign coeff[0]= -3778;
assign coeff[1]= -2;
assign coeff[2]= 2889;
assign coeff[3]= -4;
assign coeff[4]= -3571;
assign coeff[5]= -4;
assign coeff[6]= 4044;
assign coeff[7]= -2;
assign coeff[8]= 28564;
assign coeff[9]= -2;
assign coeff[10]= 4044;
assign coeff[11]= -4;
assign coeff[12]= -3571;
assign coeff[13]= -4;
assign coeff[14]= 2889;
assign coeff[15]= -2;
assign coeff[16]= -3778;

assign output_sample = result[0] + result[1] + result[2] + result[3] + result[4] + result[5] + result[6] + result[7] + result[8] + result[9] + result[10] + result[11] + result[12] + result[13] + result[14] + result[15] + result[16];
genvar i;
generate
 for (i=0; i<17; i=i+1) begin : gen_mult
  multiplier mult (.dataa(carry[i]),.datab(coeff[i]), .result(result[i]));
 end
endgenerate

integer j;
always @(posedge clk)
begin
 carry[0] <= input_sample;
 for (j=1; j<17; j=j+1) begin
  carry[j] <= carry[j-1];
 end

end

endmodule 