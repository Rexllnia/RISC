module mux_pc(
	input ena,
	input	jump,
	input	[31:0]	jump_addr_i,
	input	[31:0]	curr_pc,
	output reg[31:0]	next_pc
);
always @(*) begin
	if(~ena)
		next_pc = curr_pc;
	else if(jump)
		next_pc=jump_addr_i;
	else
		next_pc=curr_pc+32'h4;
end
endmodule
