
module memory(reg_out_1,op_reg,mem_addr1,mem_addr2,wr,reg_din,clkout);
	defparam adr_size=5;
	defparam size=32;
	defparam no_arrays=32;
	input [adr_size-1:0] mem_addr1,mem_addr2;
	input [data_size-1:0] reg_din;
	input wr,clkout;
	output reg [31:0] reg_out_1=0,op_reg=0;
	reg [size-1:0] mem [no_arrays-1:0];
	
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
