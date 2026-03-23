module immediate_extractor (input [4:0] instruction, input [1:0] select, output reg [7:0] immediate);
//3 bit immediate operand
    //extract bit 4 through 2 of instruction and pads the remaining bits with 0
//4 bit immediate operand
    //extract bit 3 through 0 of instruction and pads the remaining bits with 0
//5 bit immediate operand
    //extract bit 4 through 0 of instruction and pads the remaining bits with replicates of bit 4 (sign extension)
    always @(*) begin
        case (select)
            2'b00: immediate = {{instruction[4:2]},{5'b00000}}; 
            2'b01: immediate = {{instruction[3:0]},{4'b0000}};
            2'b10: immediate = {{3{instruction[4]}},{instruction[4:0]}};
            default: immediate = 8'b00000000; //default case
        endcase
    end
endmodule
