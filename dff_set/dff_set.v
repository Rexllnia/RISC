module dff_set(clk,reset,d,q,qb);
input  clk,reset;
input[31:0] d;
output[31:0]  q,qb;
reg[31:0] q,qb;
always @(posedge clk or negedge reset)
		begin if(!reset) begin
			q<=0;
			qb<=1;
		end
		else 
		begin
			q<=d;
			qb<=~d;
		end 
	end
endmodule