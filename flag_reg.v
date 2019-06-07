
module flag_reg(opcode,flags,flag_fl,clkout);
input [7:0] opcode;
input clkout;
reg[31:0] reg_flag;
output reg[2:0] flag_fl;
input [31:0] flags;
always @(posedge clkout) begin
reg_flag <= flags;
flag_fl<=opcode[2:0];
end
endmodule
