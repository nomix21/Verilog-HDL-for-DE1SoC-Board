module datapath (input clk, reset_n,
				// Control signals
				input write_reg_file, result_mux_select,
				input [1:0] op1_mux_select, op2_mux_select,
				input start_delay_counter, enable_delay_counter,
				input commit_branch, increment_pc,
				input alu_add_sub, alu_set_low, alu_set_high,
				input load_temp, increment_temp, decrement_temp,
				input [1:0] select_immediate,
				input [1:0] select_write_address,
				// Status outputs
				output br, brz, addi, subi, sr0, srh0, clr, mov, mova, movr, movrhs, pause,
				output delay_done,
				output temp_is_positive, temp_is_negative, temp_is_zero,
				output register0_is_zero,
				// Motor control outputs
				output [3:0] stepper_signals
);
// The comment /*synthesis keep*/ after the declaration of a wire
// prevents Quartus from optimizing it, so that it can be observed in simulation
// It is important that the comment appear before the semicolon
wire [7:0] w_position /*synthesis keep*/;
wire [7:0] w_delay /*synthesis keep*/;
wire [7:0] w_register0 /*synthesis keep*/;
wire [7:0] w_pc /*synthesis keep*/;
wire [7:0] w_alu_out /*synthesis keep*/;
wire [7:0] w_instruction_out /*synthesis keep*/;
wire [1:0] w_write_address_out /*synthesis keep*/;
wire [7:0] w_selected0 /*synthesis keep*/;
wire [7:0] w_selected1 /*synthesis keep*/;
wire [7:0] w_operanda /*synthesis keep*/;
wire [7:0] w_operandb /*synthesis keep*/;
wire [7:0] w_immediate_out /*synthesis keep*/;
wire [3:0] stepper_out /*synthesis keep*/;
wire [7:0] result_out /*synthesis keep*/;
decoder the_decoder (
	// Inputs
	.instruction (instruction_out[7:2]),
	// Outputs
	.br (br),
	.brz (brz),
	.addi (addi),
	.subi (subi),
	.sr0 (sr0),
	.srh0 (srh0),
	.clr (clr),
	.mov (mov),
	.mova (mova),
	.movr (movr),
	.movrhs (movrhs),
	.pause (pause)
);
regfile the_regfile(
	// Inputs
	.clk (clk),
	.reset_n (reset_n),
	.write (write_reg_file),
	.data (w_result_out), 
	.select0 (instruction_out[1:0]),
	.select1 (instruction_out[3:2]),
	.wr_select (w_write_address_out),
	// Outputs
	.selected0 (w_selected0),
	.selected1 (w_selected1),
	.delay (w_delay),
	.position (w_position),
	.register0 (w_register0)
);

op1_mux the_op1_mux(
	// Inputs
	.select (op1_mux_select),
	.pc (w_pc),
	.register (w_selected0),
	.register0 (w_register0),
	.position (w_position),
	// Outputs
	.result(w_operanda)
);

op2_mux the_op2_mux(
	// Inputs
	.select (op2_mux_select),
	.register (w_selected1),
	.immediate (w_immediate_out),
	// Outputs
	.result (w_operandb)
);

delay_counter the_delay_counter(
	// Inputs
	.clk(clk),
	.reset_n (reset_n),
	.start (start_delay_counter),
	.enable (enable_delay_counter),
	.delay (w_delay),
	// Outputs
	.done (delay_done)
);

stepper_rom the_stepper_rom(
	// Inputs
	.address (w_position[2:0]),
	.clock (clk),
	// Outputs
	.q (stepper_signals)
);

pc the_pc(
	// Inputs
	.clk (clk),
	.reset_n (reset_n),
	.branch (commit_branch),
	.increment (increment_pc),
	.newpc (w_alu_out),
	// Outputs
	.pc (w_pc)
);

instruction_rom the_instruction_rom(
	// Inputs
	.address (w_pc),
	.clock (clk),
	// Outputs
	.q (w_instruction_out)
);

alu the_alu(
	// Inputs
	.add_sub (alu_add_sub),
	.set_low (alu_set_low),
	.set_high (alu_set_high),
	.operanda (w_operanda),
	.operandb (w_operandb),
	// Outputs
	.result (w_alu_out)
);

temp_register the_temp_register(
	// Inputs
	.clk (clk),
	.reset_n (reset_n),
	.load (load_temp),
	.increment (increment_temp),
	.decrement (decrement_temp),
	.data (w_selected0),
	// Outputs
	.negative (temp_is_negative),
	.positive (temp_is_positive),
	.zero (temp_is_zero)
);

immediate_extractor the_immediate_extractor(
	// Inputs
	.instruction (w_instruction_out),
	.select (select_immediate),
	// Outputs
	.immediate (w_immediate_out)
);

write_address_select the_write_address_select(
	// Inputs
	.select (select_write_address),
	.reg_field0 (instruction_out[1:0]),
	.reg_field1 (instruction_out[3:2]),
	// Outputs
	.write_address(w_write_address_out)
);

result_mux the_result_mux (
	.select_result (result_mux_select),
	.alu_result (w_alu_out),
	.result (w_result_out)
);

branch_logic the_branch_logic(
	// Inputs
	.register0 (w_register0),
	// Outputs
	.branch (register0_is_zero)
);

endmodule