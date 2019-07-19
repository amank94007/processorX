
module ir(inst_addr,opcode,Lir,clkout);
defparam size=32;
output reg [7:0] opcode;
input [size-1:0] inst_addr;
input Lir,clkout;
reg [size-1:0] reg_ir;


	always @(posedge clkout)		
			case(Lir)
				1'b0:
					begin
					reg_ir <= inst_addr;
							
					end
				1'b1:
					begin
						//opcode <= 0;//generate opcode to give into instructions
					end
			endcase
endmodule
