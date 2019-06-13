module clock(clkin,clkout);
	output clkout;
	reg clk;
	input clkin;
	always repeat(4) @(posedge clkin) clk = ~clk;
	assign clkout=clk;	
endmodule
