module rom(
input[31:0] ins_i,
output reg[31:0] ins_o
);
reg [31:0] memory[0:1023];


initial begin
memory[0]=32'h12345678;
memory[0]=32'h89123121;
end

always@(*)
	begin 
		ins_o=memory[ins_i[11:2]];
	end

endmodule