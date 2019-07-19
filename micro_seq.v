
module micro_seq(opcode,flag_fl,Efl,Rms,clkout);
input [7:0] opcode;
input [2:0] flag_fl;
input clkout;
always @(posedge clkout,negedge Rms)
if(!Rms)begin
//reset micro sequencer
end
if(Efl)begin
//run if enable
end
endmodule
