module clock(clkin,clkout);
	output reg clkout;
	input clkin;
	always repeat(4) @(posedge clkin) clkout = ~clkout;
		
endmodule
