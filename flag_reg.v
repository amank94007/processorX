
module flag_reg(opcode,flags,flag_fl,clkout);
defparam size=32;
input [7:0] opcode;
input clkout;
reg[size-1:0] reg_flag;
output reg[2:0] flag_fl;
input [size-1:0] flags;
always @(posedge clkout) begin
reg_flag <= flags;
flag_fl<=opcode[2:0];
end
endmodule
