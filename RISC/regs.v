module regs(
input clk,
input rst,
input[4:0]reg1_raddr_i,
input[4:0]reg2_raddr_i,

output  reg[31:0] reg1_rdata_o,
output  reg[31:0] reg2_rdata_o,

input	  [4:0]reg_waddr_i,
input	  [31:0]reg_wdata_i,

input reg_write_en

);
	reg[31:0] regs[0:31];

	integer i;
	initial
	begin 
		regs[0]=5'h0;
		regs[1]=5'h4;
		regs[2]=5'h5;
		regs[3]=5'h6;
	end
always @(*)begin
	if(~rst)
		reg1_rdata_o<=32'b0;
	else if(reg1_raddr_i ==5'b0)
		reg1_rdata_o <= 32'b0;
	else if(reg_write_en&& reg1_raddr_i==reg_waddr_i)
		reg1_rdata_o<=reg_wdata_i;//如果写的地址等于读的地址 就直接把写的数据给读
	else 
		reg1_rdata_o<=regs[reg1_raddr_i];
end

always @(*)begin
	if(~rst)
		reg2_rdata_o<=32'b0;
	else if(reg2_raddr_i ==5'b0)
		reg2_rdata_o <= 32'b0;
	else if(reg_write_en&& reg2_raddr_i==reg_waddr_i)
		reg2_rdata_o<=reg_wdata_i;//如果写的地址等于读的地址 就直接把写的数据给读
	else
		reg2_rdata_o<=regs[reg2_raddr_i];
end
always @(posedge clk)begin
	if(~rst)
		begin
			for(i=0;i<31;i=i+1)
				begin
					regs[i]<=32'b0;
				end
		end
	else if(reg_write_en&&reg_waddr_i!=0)
		begin
			regs[reg_waddr_i]<=reg_wdata_i;
		end

		
	
end


endmodule