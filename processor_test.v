module processor_test;
processor pr1(Rst,clkin);
always #1.5 clkin = ~clkin;
initial begin
	clkin=0;
	Rst=0;
	#10 Rst=1;
end
endmodule



