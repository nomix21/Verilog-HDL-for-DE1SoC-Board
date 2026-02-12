module seven_seg_decoder(input [3:0] digit, output [6:0] HEX);
    reg [6:0] reg_LEDs;
    //assign HEX[6:0]=reg_LEDs[6:0];
    assign HEX = reg_LEDs;
    always @(*) begin
        case (digit)
            4'b0000: reg_LEDs[6:0]=7'b1000000; // decimal 0
            4'b0001: reg_LEDs[6:0]=7'b1111001; // decimal 1
            4'b0010: reg_LEDs[6:0]=7'b0100100; // decimal 2
            4'b0011: reg_LEDs[6:0]=7'b0110000; // decimal 3
            4'b0100: reg_LEDs[6:0]=7'b0011001; // decimal 4
            4'b0101: reg_LEDs[6:0]=7'b0010010; // decimal 5
            4'b0110: reg_LEDs[6:0]=7'b0000010; // decimal 6
            4'b0111: reg_LEDs[6:0]=7'b1111000; // decimal 7
            4'b1000: reg_LEDs[6:0]=7'b0000000; // decimal 8
            4'b1001: reg_LEDs[6:0]=7'b0010000; // decimal 9
            4'b1111: reg_LEDs[6:0]=7'b1111111; // decimal Off
            default: reg_LEDs[6:0]=7'b1111111; // for input greater than 1111
        endcase
    end
endmodule