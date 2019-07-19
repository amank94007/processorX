
module reg_file(result,Sal,reg_out,reg_addr,clkout);
	defparam size=32;
	defparam no_arrays=32;
	input [4:0] reg_addr;
	input [size-1:0] result;
	input Sal,clkout;
	output reg [31:0] reg_din=0;
	reg [size-1:0] reg_arr [no_arrays-1:0];
	
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
