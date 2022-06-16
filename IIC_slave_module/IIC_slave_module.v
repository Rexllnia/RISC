module IIC_slave_module(
inout SDA,
input	SCL,
output reg incycle,
output reg[3:0] bitcnt,
output reg data_phase,
output reg adr_match,op_read,got_ACK,
output reg [7:0] mem,//8位寄存器
output reg SDAr

);

parameter I2C_ADR=7'b1111111;

wire SDA_shadow;/*synthesis keep=1*/
wire start_or_stop;/*synthesis keep=1*/
assign SDA_shadow=(~SCL|start_or_stop)?SDA:SDA_shadow;
/*
如果SCL高电平 或者不是起始信号 则保持
如果SCL是低电平 或者是起始信号 则赋值当前SDA
*/

assign start_or_stop=~SCL ? 1'b0 : (SDA ^ SDA_shadow);
/*
起始信号 如果 SCL不是高电平 则不是起始信号
如果 SCL在高电平 则开始判断
SDA如果和之前的SDA不一样则 说明是起始信号 否则不是
*/
always @(negedge SCL or posedge start_or_stop)
	if(start_or_stop) incycle<=1'b0; 
	else if(~SDA) incycle<=1'b1; //进入
	//incycle 保持

	
	

wire bit_DATA = ~bitcnt[3];//000
wire bit_ACK = bitcnt[3];//应答信号等于最后一位111

always @(negedge SCL or negedge incycle) 
if(~incycle)//
begin
	bitcnt <=4'h7;
	data_phase<=0;
end
else
begin
	if(bit_ACK)//
	begin
		bitcnt <= 7;
	end
	else
		bitcnt<=bitcnt-1;
end

wire adr_phase = ~ data_phase;

always @(posedge SCL)SDAr<=SDA;
wire op_write = ~op_read;
always @(negedge SCL or negedge incycle)
if(~incycle)
begin
	got_ACK<=0;
	adr_match<=1;
	op_read<=0;
end
else
begin
	if(adr_phase&bitcnt==7&SDAr!=I2C_ADR[6]) adr_match<=0;//则不匹配
	if(adr_phase&bitcnt==6&SDAr!=I2C_ADR[5]) adr_match<=0;
	if(adr_phase&bitcnt==5&SDAr!=I2C_ADR[4]) adr_match<=0;
	if(adr_phase&bitcnt==4&SDAr!=I2C_ADR[3]) adr_match<=0;
	if(adr_phase&bitcnt==3&SDAr!=I2C_ADR[2]) adr_match<=0;
	if(adr_phase&bitcnt==2&SDAr!=I2C_ADR[1]) adr_match<=0;
	if(adr_phase&bitcnt==1&SDAr!=I2C_ADR[0]) adr_match<=0;
	if(adr_phase&bitcnt==0) op_read<=SDAr;
	if(bit_ACK)got_ACK<=~SDAr;
	if(adr_match&bit_DATA&data_phase&op_write)mem[bitcnt]<=SDAr;//都匹配则把SDAr写寄存器
end

wire mem_bit_low=~mem[bitcnt[2:0]];
wire SDA_assert_low=adr_match & bit_DATA & data_phase & op_read &mem_bit_low&got_ACK;
wire SDA_assert_ACK=adr_match& bit_ACK&(adr_phase|op_write);
wire SDA_low=SDA_assert_low | SDA_assert_ACK;
assign SDA=SDA_low?1'b0:1'bz;
endmodule
