
module memory(reg_out_1,op_reg,mem_addr1,mem_addr2,wr,reg_din,clkout);
	input [4:0] mem_addr1,mem_addr2;
	input [31:0] reg_din;
	input wr,clkout;
	output reg [31:0] reg_out_1=0,op_reg=0;
	reg [31:0] mem [31:0];
	
	always @(posedge clkout)
			
			case(wr)
				1'b0:
					begin
						
						reg_out_1 <= mem[mem_addr1];
						op_reg <= mem[mem_addr2];
							
					end
				1'b1:
					begin
						mem[mem_addr1] <= reg_din;
					end
			endcase
	
endmodule
