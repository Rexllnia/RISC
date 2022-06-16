module pc_reg(
input clk,
input rst,
output reg ena,
input  [31:0] next_pc,
output reg [31:0] curr_pc
);
always @(posedge clk or negedge rst)
	begin
		if(~rst)
			ena<=1'b0;
		else
			ena<=1'b1;
end

always @(posedge clk or negedge rst)
	begin
		if(~rst)
			curr_pc<=32'b0;
		else
			curr_pc<=next_pc;
end


endmodule