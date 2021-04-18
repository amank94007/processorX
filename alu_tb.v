// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
module alu_tb;
  
	`include "parameter_opcode.vh"
	parameter data_size = 32;
	parameter MSB=data_size-1;
	
	///////////  PORTS  //////////////////////////
	reg cin,fl;						//fl is for masking cin is carry in
	reg clkout;
  reg signed [data_size-1:0] A=-2,B=2,val;//val is direct value eg MOV A,5 // val is 5 here
  //integer [data_size-1:0] A=-2,B=2,val;//val is direct value eg MOV A,5 // val is 5 here
  reg [7:0] opcode=ADA;
	wire signed [data_size-1:0] result; //accumulator
	wire [4:0] flags;//[ZCSPV] Zero Carry Sign Parity oVerflow	
  
  	alu u_alu(result,flags,A,B,opcode,clkout,cin,val,fl);
    initial begin
    // Dump wavesfgfg
    	$dumpfile("dump.vcd");
    	$dumpvars(1);
      $monitor("opcode=%b A=%b B=%b , status_reg[ZCSPV]=%b result=%b",opcode,A,B,flags,result);
      $monitor("opcode=%b A=%d B=%d , status_reg[ZCSPV]=%b result=%b",opcode,A,B,flags,result);
     // opcode=ADA;
      #1 A=-3;B=3;
      #1 A=4;B=-3;
      #1 A=2;B=-3;
      #1 A=-4;B=3;
      #1 A=-3;B=4;
      #1 A=-4;B=-3;
      #1 A=-2;B=-3;
      #1 A=-3;B=-3;
      #1 A=4;B=3;
      //#1 A=-1073741823;B=-2147483646;
      #1 A=-1073741823;B=-1073741824;
      //#1 A=-2147483648;B=-3;
      #1 A=-1073741824;B=-3;
      #1 A=-1073741823;B=1073741824;
      //#1 A=2147483647;B=-2147483648;
     //#1 opcode=ADA;//val=1;cin=0;
      //#2 $display("opcode=%b A=%d B=%d cin=%b val=%b result=%b",opcode,A,B,cin,val,result);
    //  #2 $monitor("opcode=%b A=%d B=%d cin=%b val=%b result=%b",opcode,A,B,cin,val,result);
     // #1 $display("status_reg[ZCSPV]=%b", flags);
     #30 $finish;
  end             
endmodule