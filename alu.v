///have to change opcode 

module alu(result,flags,A,B,opcode,clkout,cin,val,fl);
	
	///////////////////////////////////////////////
	
	parameter data_size = 32;
	parameter MSB=data_size-1;
	
	///////////  PORTS  //////////////////////////
	input cin,fl;						//fl is for masking ; cin is carry in
	input clkout;
	input [data_size-1:0] A,B,val;//val is direct value eg MOV A,5 // val is 5 here
	input [7:0] opcode;
	output reg [data_size-1:0] result; //accumulator
	output reg [4:0] flags=0;//[ZCSPV] Zero Carry Sign Parity oVerflow	
	

	///////////  OPCODE  /////////////////////////
	parameter ADD=1;
	parameter ADI=2;
	parameter ACA=3;
	parameter ACI=4;
	parameter SUB=5;
	parameter SCI=6;
	parameter SBI=7;
	parameter SCA=7;
	parameter XNR=9;
	parameter XNI=10;
	parameter XOR=11;
	parameter XRI=12;
	parameter AND=13;
	parameter ANI=14;
	parameter ORA=15;
	parameter ORI=16;
	parameter NOT=17;
	parameter NEG=18;
	parameter SRL=19;
	parameter SLL=20;
	parameter ASR=21;
	parameter ASL=22;
	parameter SRC=23;
	parameter SLC=24;
	parameter ROR=25;
	parameter ROL=26;
	parameter RRC=27;
	parameter RLC=28;
	parameter CLR=29;
	parameter INC=30;
	parameter DEC=31;
	parameter POP=32;
	parameter PSH=33;
	parameter MVS=34;
	parameter STS=35;
	parameter CCP=36;
	parameter JCP=37;
	parameter CCD=38;
	parameter JCD=39;
	parameter RTC=40;
	parameter JCA=41;
	parameter MVP=42;
	parameter RTU=43;
	parameter CUA=44;
	parameter STA=45;
	parameter CLA=46;
	parameter MVR=47;
	parameter JUA=48;
	parameter CUP=49;
	parameter JUP=50;
	parameter CUD=51;
	parameter JUD=52;
	parameter NOP=53;
	
	
	//////////////////////////////////////////////
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
		result=A;
		case(opcode)
			
			///Stack and PC operations initally at top then decrement and insert data push operation
			POP: //POP in stack
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
			ADD: //ADD
				begin
				 {flags[0],flags[3],result} = A+B;
				end		
			ADI: //ADD immediate 
				begin
				 {flags[0],flags[3],result} = A+val;
				end		
			ACA: //ADD with carry
				begin
				 {flags[0],flags[3],result} = A+B+cin;
				end
			ACI: //Add with immediate and carry
				begin
				 {flags[0],flags[3],result} = A+val+cin;
				end
				
			SUB: //SUB
				begin
				result=A-B;
				end
			SBI: //SUB immediate
				begin
				result=A-val;
				end
			SCI: //SUB immediate with carry
				begin
				result=A-val-cin;
				end
			SCA: //SUB immediate
				begin
				result=A-B-cin;
				end	
				
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
			ANI: //AND immediate
				begin
					result = A & val;	
				end
			AND: //AND
				begin
					result = A & B;	
				end
			ORI: //OR immediate
				begin
					result = A | val;	
				end	
			ORA: //OR
				begin
					result = A | B;	
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
		endcase
	end
					
	always @(result) //flag register few bits
		begin
				if(result<0) //ZS Zero Sign check
					{flags[4],flags[2]}=2'b01;
				else if (result>0)	
					{flags[4],flags[2]}=2'b00;
				else if (result==0)
					{flags[4],flags[2]}=2'b10;
				else 
					{flags[4],flags[2]}=2'b00;
				flags[1]=^result;// Parity check
		end	
		
	
endmodule
