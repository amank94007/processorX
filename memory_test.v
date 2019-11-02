module memory_test;
	defparam adr_size=5;
	defparam size=32;
	defparam no_arrays=32;
	reg[adr_size-1:0] mem_addr1,mem_addr2;
	reg [data_size-1:0] reg_din;
	reg wr,clkout;
	wire [31:0] reg_out_1=0,op_reg=0;
memory mem1(reg_out_1,op_reg,mem_addr1,mem_addr2,wr,reg_din,clkout);
always #1.2 clkout=~clkout;
initial begin
	clkout=0;
	wr=0;
	
end
endmodule

