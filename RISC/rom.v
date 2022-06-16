module rom(
input[31:0] ins_i,
output reg[31:0] ins_o
);
reg [31:0] memory[0:1023];


initial begin
memory[1]=32'h00308293;
memory[2]=32'h00208313;
memory[3]=32'h00908513;
memory[4]=32'h00629463;
end

always@(*)
	begin 
		ins_o=memory[ins_i[11:2]];
	end

endmodule