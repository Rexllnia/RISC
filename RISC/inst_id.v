module inst_id(
	input [31:0] inst_i,
	input	[31:0]	inst_addr_i,
	output reg[4:0] rs1_addr_o,
	output reg[4:0] rs2_addr_o,
	input	[31:0] rs1_data_i,
	input	[31:0] rs2_data_i,
	output reg[31:0] inst_o,
	output reg[31:0] inst_addr_o,
	output reg[31:0]	op1_o,
	output reg[31:0]	op2_o,
	output reg[4:0]	rd_addr_o,
	output reg rd_write_en
	
);
	wire[6:0] opcode;
	wire[4:0] rd;
	wire [2:0] func3;
	wire [4:0]	rs1;
	wire [4:0]	rs2;
	wire [11:0] imm;
	wire [6:0] func7;
	
	assign opcode= inst_i[6:0];
	assign rd	=inst_i[11:7];
	assign func3 =inst_i[14:12];
	assign rs1	=inst_i[19:15];
	assign rs2=inst_i[24:20];
	assign imm = inst_i[31:20];
	assign func7=inst_i[31:25];
	
	always @(*)begin
		inst_o=inst_i;
		inst_addr_o=inst_addr_i;
		case(opcode)
			7'b0110011://R type
				begin
					case(func3)
						3'b000: //ADD SUB
							begin
								case(func7)
									7'b0000000://ADD
										begin
											rs1_addr_o=rs1;//译rs1
											rs2_addr_o=rs2;//译rs2
											op1_o=rs1_data_i;//操作数1 去寄存器取出来的值
											op2_o=rs2_data_i;//操作数2
											rd_addr_o = rd;//结果存储位置
											rd_write_en = 1'b0;//不写使能
											
										end
									7'b0100000://SUB
										begin

										end
								default:
									begin
										rs1_addr_o = 5'b0;
										rs2_addr_o = 5'b0;
										op1_o = 32'b0;
										op2_o = 32'b0;
										rd_addr_o = 5'b0;
										rd_write_en = 1'b0;
									end
								endcase
							end
						default:
							begin
								rs1_addr_o = 5'b0;
								rs2_addr_o = 5'b0;
								op1_o = 32'b0;
								op2_o = 32'b0;
								rd_addr_o = 5'b0;
								rd_write_en = 1'b0;
							end
					endcase
				end
			7'b0010011:
				begin
					case(func3)
						3'b000: //INST_ADDI
							begin
								rs1_addr_o = rs1;
								rs2_addr_o = 5'b0;
								op1_o = rs1_data_i;
								op2_o = {{20{imm[11]}},imm};//最高位用符号位填充
								rd_addr_o = rd;
								rd_write_en = 1'b1;
							end
						default:
							begin
								rs1_addr_o = 5'b0;
								rs2_addr_o = 5'b0;
								op1_o = 32'b0;
								op2_o = 32'b0;
								rd_addr_o = 5'b0;
								rd_write_en = 1'b0;
							end
					endcase
				end
			7'b1100011:
				begin
					case(func3)
						3'b001://BNE
							begin
								rs1_addr_o=rs1;
								rs2_addr_o=rs2;//
								op1_o=rs1_data_i;//从寄存器取
								op2_o=rs2_data_i;//
								rd_addr_o=0;
								rd_write_en = 1'b0;
							end
						default:
							begin
								rs1_addr_o=0;
								rs2_addr_o=0;
								op1_o=0;
								op2_o=0;
								rd_addr_o=5'b0;
								rd_write_en = 1'b0;
							end
					endcase
				end
			default:
				begin
					rs1_addr_o = 5'b0;
					rs2_addr_o = 5'b0;
					op1_o = 32'b0;
					op2_o = 32'b0;
					rd_addr_o = 5'b0;
					rd_write_en = 1'b0;
				end
				
		endcase
	end	
endmodule
