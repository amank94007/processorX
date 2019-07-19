module processor(Rst,clkin);
	
input Rst;
	input clkin;
	clock clk_obj(clkin,clkout);
	//call address selector
	memory mem_obj(reg_out_1,op_reg,mem_addr1,mem_addr2,wr,reg_din,clkout);
	alu alu_obj(result,flags,A,B,opcode,clkout);
	reg_file reg_file_obj(result,Sal,reg_out,reg_addr1,clkout);
	pc pc_obj(inst_addr,Pc_Rst,Pc_Ld,Pc_addr_in,clkout);
	ir ir_obj(inst_addr,opcode,Lir,clkout);
	flag_reg flag_reg_obj(opcode,flags,flag_fl,clkout);
	micro_seq micro_seq_obj(opcode,flag_fl,Efl,Rms,clkout);
	stack_ptr stack_ptr_obj();
	addr_sel addr_sel_obj(Spc,Ssp);
endmodule
