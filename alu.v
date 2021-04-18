// Code your design here
// Code your design here
///have to change opcode 

module alu(result,flags,A,B,opcode,clkout,cin,val,fl);
	
	/////////////////////////////////////////////
	`include "parameter_opcode.vh"
	parameter data_size = 32;
	parameter MSB=data_size-1;
	
	///////////  PORTS  /////////////////////////
	input cin,fl;						//fl is for masking ; cin is carry in aka C
	input clkout;
  	//input [data_size-1:0] A,B,val;// A is R0; B is <rn>; val is <xx>
    input signed [data_size-1:0] A,B,val;// A is R0; B is <rn>; val is <xx>
    input [7:0] opcode;
  	reg signed [data_size-1:0]  A_reg = A;
  	reg signed[data_size-1:0] B_reg = B;
  	output reg signed [data_size-1:0] result; //accumulator
	output reg [4:0] flags=0;//[ZCSPV] Zero Carry Sign Parity oVerflow	
		
	/////////////////////////////////////////////
	parameter ssize=32;
	parameter sptr_size=4;
	reg [ssize-1:0] stack[(sptr_size**2)-1:0];			//stack memory
	reg [sptr_size-1:0] sptr=(sptr_size**2);
	reg stack_V=0,stack_U=0;
	/////////////////////////////////////////////
	parameter msize=32;
	parameter mptr_size=4;
	reg [msize-1:0] mem[(mptr_size**2)-1:0];	  			//data memory 
	reg [mptr_size-1:0] mptr=0;
	/////////////////////////////////////////////
	parameter isize=32;
	parameter iptr_size=4;
	reg [isize-1:0] inst_reg[(iptr_size**2)-1:0];		//instruction memory 
	reg [iptr_size-1:0] pc=0;
	/////////////////////////////////////////////
	
	always @(*)
		begin
		//result<=0;
        //A_reg<=A;
        //B_reg<=B;
		case(opcode)
			
			///Stack and PC operations initally at top then decrement and insert data push operation
			/*POP: //POP in stack
				begin
				 if(sptr==(sptr_size**2))
				 stack_U=1;//stack underflow
				 else begin
				 result=stack[sptr];
				 sptr=sptr+1;
				end
				end
			PSH: //PUSH in stack
				begin
				 if(sptr==0)	
				 stack_V=1;//overflow stack
				 else begin
				 sptr=sptr-1;
				 stack[sptr]=val;
				end
				end
			MVS: //value is copied into stack pointer
				begin
				sptr=val;
				end
			STS:
				begin
				result=sptr;
				end
			CCP:
				begin
				if(fl==1)
				begin
				sptr=sptr-1;
				sptr=pc;
				pc=pc+val;
				end
				end
			JCP:
				begin
				if(fl==1)
				pc=pc+val;
				end
			CCD:
				begin
				if(fl==1)
				begin
				sptr=sptr-1;
				sptr=pc;
				pc=val;
				end
				end
			JCD:
				begin
				if(fl==1)
				pc=val;
				end
			RTC:
				begin
				if(fl==1)
				begin
				sptr=pc;
				sptr=sptr+1;
				end
				end
			JCA:
				begin
				if(fl==1)
				pc=result;
				end		
			MVP:
				begin
				pc=val;
				end
			RTU:
				begin
				pc=sptr;
				sptr=sptr+1;
				end
			CUA:
				begin
				sptr=sptr-1;
				sptr=pc;
				pc=A;
				end
			JUA:
				begin
				pc=A;
				end
			CUP:
				begin
				sptr=sptr-1;
				sptr=pc;
				pc=pc+val;
				end
			JUP:
				begin
				pc=pc+val;
				end
			CUD:
				begin
				sptr=sptr-1;
				sptr=pc;
				pc=val;
				end
			JUD:
				begin
				pc=val;
				end
			
			/////////////////////////////////////////
			
			NOP: @(posedge clkout) result=result;
			
			STA: //store into memory
				begin
				 mem[mptr]=result;
				 mptr=mptr+1;
				end
			LDA:	//Load from memory address is given
				begin
				result=mem[mptr];
				end
			MVR:
				begin
				result=val;
				end
                */
			ADA: //ADD 29
				begin
                	{flags[0],flags[3],result} <= A+B;
                	A_reg<=result;
				end		
			ADI: //ADD immediate 30
				begin
                	{flags[0],flags[3],result} <= B+val;
                	B_reg<=result;
				end	
          	SBA: //SUB 31
				begin
                	{flags[0],flags[3],result} <= A-B;
                	A_reg<=result;
				end
          	SBI: //SUB immediate 32
				begin
                	{flags[0],flags[3],result} <= B-val;
                	B_reg<=result;
				end
			ACA: //ADD with carry 33
				begin
                	{flags[0],flags[3],result} <= A+B+cin;
                	A_reg<=result;
				end
			ACI: //Add with immediate and carry 34
				begin
                	{flags[0],flags[3],result} <= B+val+cin;
                	B_reg<=result;
				end
			SCA: //SUB immediate 35
				begin
                  	{flags[0],flags[3],result} <= A-B-cin;
                	A_reg<=result;
				end	
          	SCI: //SUB immediate with carry 36
				begin
                  	{flags[0],flags[3],result} <= B-val-cin;
                  	B_reg<=result;
				end
			ANA: //AND immediate 37
				begin
					result <= A & B;
                	A_reg<=result;
				end	
          	ANI: //AND immediate 38
				begin
					result <= B & val;
                	B_reg<=result;
				end
          	ORA: //OR immediate 39
				begin
					result <= A | B;
                	A_reg<=result;
				end	
			ORI: //OR 40
				begin
					result <= B | val;
                	B_reg<=result;
                end
          	XRA: //XOR 41
				begin
					result <= A ^ B;
                  	A_reg<=result;
				end
			XRI: //XOR immediate 42
				begin
					result <= B ^ val;
                  	B_reg<=result;
				end
          	XNA: //XOR 43
				begin
					result <= A ^~ B;
                  	A_reg<=result;
				end
			XNI: //XOR immediate 44
				begin
					result <= B ^~ val;
                  	A_reg<=result;
				end
          
			/*
			XOR: //XOR
				begin
					result = A ^ B;
				end
			XRI: //XOR immediate
				begin
					result = A ^ val;
				end
			XNR: //XNOR
				begin
					result = A ~^ B;
				end
			XNI: //XNOR immediate
				begin
					result = A ~^ val;
				end	
			
			AND: //AND
				begin
					result = A & B;	
				end
			
			NOT: //INVERT
				begin
					result = ~A;
				end
			NEG: //NEG
				begin
					{flags[0],flags[3],result} = ~A + 1'b1;
				end
			SRL: //SRL without carry 
				begin
					result <= @(posedge clkout) A >> val;
				end
			SRC: //SRL with carry 
				begin
					result <= @(posedge clkout) {flags[3],A} >> val;
				end
			SLL: //SRL without carry 
				begin
					result <= @(posedge clkout) A << val;
				end	
			SLC: //SLL with carry
				begin
					{flags[3],result} <= @(posedge clkout)  A << val;
				end
			ASR: //ASR without carry
				begin
					result <= @(posedge clkout) A >>> val;
				end
			ASL: //ASR without carry
				begin
					result <= @(posedge clkout) A <<< val;
				end
				
			ROL: //Rotate left without carry
				begin
				result <= @(posedge clkout)  A << 1;
				result[0]<=result[MSB];
				end
			ROR: //rotate rt without carry
				begin
				result <= @(posedge clkout)  A >> 1;
				result[MSB]<=result[0];
				end
			RLC: //Rotate left with carry
				begin
				result <= @(posedge clkout)  A << 1;
				result[0]<=flags[3];	//carry
				end
			RRC: //Rotate rt with carry
				begin
				result <= @(posedge clkout)  {flags[3],A} >> 1;
				flags[3]<=A[0];	//carry	
				end
			CLR: //CLR
				begin
					result = 0;
				end
			INC: //INC
				begin
				{flags[0],flags[3],result} = A+1;
				end
			DEC: //DEC
				begin
				result = A-1;
				end
                */ 
		endcase
	end
					
	always @(result) //flag register few bits
		begin
          if((A[MSB]||B[MSB]) && result[MSB])//ZS Zero Sign check ADD
					{flags[4],flags[2]}=2'b01;
				else if (result==0)
					{flags[4],flags[2]}=2'b10;
				else 
					{flags[4],flags[2]}=2'b00;
          flags[1]=^result;// Odd parity check
		end
	
endmodule
