/* 
This is a multiplexer that selects one of the four possible register addresses to be written. 

The register to be written can be either register 0 (i.e., R0), which is useful for the SR0 and SRH0 instructions;
register 2, which is useful for the MOVR and MOVRHS instructions; or it can be one of the registers
specified by the instruction itself. The last two choices are labelled as reg field0 and reg field1.

reg field0 refers to the lowest two bits of the instruction (i.e., bits 1 and 0), while reg field1 refers to the next two bits (i.e., bits 3 and 2).

reg field0 is used for writing results of instructions with only one operand, while reg field1 is used for writing results of the MOV instruction. The
behaviour of this multiplexer is controlled by the select write address 2-bit control signal.
*/

module write_address_select (input [1:0] select, input [1:0] reg_field0, reg_field1, output reg [1:0] write_address);

always @(*) begin
 case (select)
  2'b00: write_address <= 2'b00;
  2'b01: write_address <= reg_field0;
  2'b10: write_address <= reg_field1;
 endcase
end

endmodule
