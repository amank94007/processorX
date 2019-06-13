module pc(inst_addr,Pc_Rst,Pc_Ld,Pc_addr_in,clkout);
	defparam size=32;
	output [size-1:0] inst_addr;
	input clk,Pc_Rst,Pc_Ld;
	input [size-1:0] Pc_addr_in;
	reg [size-1:0] addr=0;

	assign inst_addr = addr;

	always @(posedge clkout or negedge Pc_Rst)
			if(Pc_Rst == 1'b0)
				addr <= 32'd0;
			else if(Pc_Ld == 1'b1)
				addr <= Pc_addr_in;
	
endmodule
