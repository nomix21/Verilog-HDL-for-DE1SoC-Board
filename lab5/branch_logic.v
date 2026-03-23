module branch_logic (input [7:0] register0, output branch);

/*output 1 when register R0 is 0*/
/*else output 0*/
    assign branch = (register0 == 8'b00000000) ? 1 : 0; //if register0 is 0 then branch is 1 else branch is 0
endmodule
