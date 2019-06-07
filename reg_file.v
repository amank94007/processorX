
module reg_file(result,Sal,reg_out,reg_addr,clkout);
	input [4:0] reg_addr;
	input [31:0] result;
	input Sal,clkout;
	output reg [31:0] reg_din=0;
	reg [31:0] reg_arr [31:0];
	
	always @(posedge clkout)
			
			case(Sal)
				1'b0:
					begin
					reg_din <= reg_arr[reg_addr];
							
					end
				1'b1:
					begin
						reg_arr[reg_addr] <= result;
					end
			endcase
	
endmodule
