`timescale 1ns / 1ps

module fir_filter_with_N (
    input clk,
    input reset,
    input [15:0] input_sample1,
    output reg [15:0] output_sample1 
);

parameter N = 65; // Default number of FIR taps

reg [15:0] carry[N-1:0]; // Delay line to hold previous N input samples
reg signed [15:0] finsummations[N-1:0];  // scaled
reg signed [31:0] finsummation;          // scaled, 32bit for overflow
reg signed [15:0] coeffs[N-1:0];  

wire signed [31:0] result[N-1:0]; // Multiplication results (16bit * 16bit = 32)

integer x, z; 

initial begin
	coeff[0]= -3778;
	coeff[1]= -2;
	coeff[2]= 2889;
	coeff[3]= -4;
	coeff[4]= -3571;
	coeff[5]= -4;
	coeff[6]= 4044;
	coeff[7]= -2;
	coeff[8]= 28564;
	coeff[9]= -2;
	coeff[10]= 4044;
	coeff[11]= -4;
	coeff[12]= -3571;
	coeff[13]= -4;
	coeff[14]= 2889;
	coeff[15]= -2;
	coeff[16]= -3778;
	coeff[17]= -3778;
	coeff[18]= -2;
	coeff[19]= 2889;
	coeff[20]= -4;
	coeff[21]= -3571;
	coeff[22]= -4;
	coeff[23]= 4044;
	coeff[24]= -2;
	coeff[25]= 28564;
	coeff[26]= -2;
	coeff[27]= 4044;
	coeff[28]= -4;
	coeff[29]= -3571;
	coeff[30]= -4;
end

genvar i;
generate
	for (i=0; i<N; i=i+1) begin: gen_mult
		 multiplier mult(.dataa(coeffs[i]),.datab(carry[i]),.result(result[i]));
	end
endgenerate

// FIR Filtering 
always @(posedge clk or posedge reset)
begin
    if (reset) begin
        output_sample1 <= 0;               
        for (z=0; z<N; z=z+1) begin
            carry[z] <= 0;           
        end
    end
    else begin
        for (z=N-1; z>0; z=z-1) begin
            carry[z] <= carry[z-1]; //  shift delay line
        end
        carry[0] <= input_sample1;       

        /*for (z=0; z<N; z=z+1) begin
            // OG line (problem because skips bit 30):
            // finsummations[z] = {result[z][31], result[z][29:15]};

            // possible solution:
            // finsummations[z] = result[z] >>> 15;  // for signed arithmetic shift
        end */

        finsummation = 0;   // accumulator
        for (z=0; z<N; z=z+1) begin
            finsummation = finsummation + finsummations[z];  // accumulates 32-bit to avoid overflow
        end

        output_sample1 <= finsummation[15:0]; // truncates to 16-bit
    end
end

endmodule