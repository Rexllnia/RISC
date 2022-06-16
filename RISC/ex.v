module ex(
input [31:0] inst_i,
input [31:0] inst_addr_i,
input [31:0] op1_i,
input [31:0] op2_i,
input [4:0]  rd_addr_i,
output reg[4:0] rd_addr_o,
output reg[31:0] rd_data_o,
output reg rd_write_en,


output reg[31:0] jump_addr_o,
output reg jump_en_o,
output reg hold_flag_o

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
	//Branch
	wire[31:0] jump_imm={20'b0,inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
	wire  op1_i_equal_op2_i;
	assign op1_i_equal_op2_i=(op1_i==op2_i)?1'b1:1'b0;
	
	
	always @(*)begin
		case(opcode)
			7'b0110011://R type
				begin
				jump_addr_o=32'b0;
				jump_en_o = 1'b0;
				hold_flag_o=1'b0;
					case(func3)
						3'b000: //ADD SUB
							begin
								case(func7)
									7'b0000000://ADD
										begin
											rd_data_o=op1_i+op2_i;
											rd_addr_o=rd_addr_i;
											rd_write_en=1'b1;
										end
									7'b0100000://SUB
										begin
											rd_data_o=op1_i-op2_i;
											rd_addr_o=rd_addr_i;
											rd_write_en=1'b1;
										end
								default:
									begin
										rd_data_o=0;
										rd_addr_o=0;
										rd_write_en=0;
									end
								endcase
							end
						default:
							begin
								rd_data_o=0;
								rd_addr_o=0;
								rd_write_en=0;
							end
					endcase
				end
			7'b0010011://I type
				begin
				jump_addr_o=32'b0;
				jump_en_o = 1'b0;
				hold_flag_o=1'b0;
					case(func3)
						3'b000: //ADDI
							begin
								rd_data_o=op1_i+op2_i;
								rd_addr_o=rd_addr_i;
								rd_write_en=1'b1;
							end
						default:
							begin
								rd_data_o=0;
								rd_addr_o=0;
								rd_write_en=0;
							end
					endcase
				end
			7'b1100011://B type
				begin
					case(func3)
						3'b000://BEQ
							begin
								jump_addr_o=inst_addr_i+jump_imm;
								jump_en_o  = op1_i_equal_op2_i;
								hold_flag_o=0;
							end
						3'b001://BNE
							begin
								jump_addr_o=inst_addr_i+jump_imm;
								jump_en_o  = ~op1_i_equal_op2_i;
								hold_flag_o=0;
							end
						
						default:
							begin
								rd_data_o=0;
								rd_addr_o=0;
								rd_write_en=0;
								jump_addr_o=0;
								jump_en_o=0;
								hold_flag_o=0;
							end
					endcase
				end
			7'b0110111://U type
				begin
					case(func3)
						3'b000:
							begin
							end
						default:
							begin
							end
					endcase
				end
			default:
				begin
					rd_data_o=0;
					rd_addr_o=0;
					rd_write_en=0;
					jump_addr_o=0;
					jump_en_o=0;
					hold_flag_o=0;
				end
				
		endcase
	end


endmodule
