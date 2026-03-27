/* Decoder is a combinational logic block that analyzes the instruction currently being output by the
instruction memory and asserts one of the signals on its output, depending on the instruction actually
being read from memory. */

module decoder (input [7:2] instruction,
				output br, brz, addi, subi, sr0, srh0, clr, mov, mova, movr, movrhs, pause
);

assign br = (instruction[7:5] == 3'b100); 								//100
assign brz = (instruction[7:5] == 3'b101); 							//101
assign addi = (instruction[7:5] == 3'b000); 						//000
assign subi = (instruction[7:5] == 3'b001); 						//001
assign sr0 = (instruction[7:4] == 4'b0100); 						//0100
assign srh0 = (instruction[7:4] == 4'b0101); 					//0101
assign clr = (instruction[7:2] == 6'b011000); 				//011000
assign mov = (instruction[7:4] == 4'b0111); 						//0111
assign mova = (instruction[7:2] == 6'b110000); 			//110000
assign movr = (instruction[7:2] == 6'b110001); 			//110001
assign movrhs = (instruction[7:2] == 6'b110010); 	//110010
assign pause = (instruction[7:2] == 8'b111111); //11111111

endmodule
