///have to change opcode only

module alu(result,flags,A,B,opcode,clkout,cin,val,fl);
	defparam data_size=32;
	defparam MSB=data_size-1;
	///////////  OPCODE  /////////////////////////
	defparam ADD=6'b001_001;
	defparam ADI=6'b010_001;
	defparam ACA=6'b110_001;
	defparam ACI=6'b100_001;
	defparam SUB=6'b001_010;
	defparam SCI=6'b010_010;
	defparam SBI=6'b001_010;
	defparam SCA=6'b010_010;
	defparam XNR=6'b001_110;
	defparam XNI=6'b010_110;
	defparam XOR=6'b001_011;
	defparam XRI=6'b010_011;
	defparam AND=6'b001_100;
	defparam ANI=6'b010_100;
	defparam ORA=6'b001_101;
	defparam ORI=6'b010_101;
	defparam NOT=6'b011_001;
	defparam NEG=6'b011_000;
	defparam SRL=6'b011_010;
	defparam SLL=6'b011_011;
	defparam ASR=6'b011_110;
	defparam ASL=6'b011_110;
	defparam SRC=6'b011_010;
	defparam SLC=6'b011_011;
	defparam ROR=6'b011_110;
	defparam ROL=6'b011_110;
	defparam RRC=6'b011_010;
	defparam RLC=6'b011_011;
	defparam CLR=6'b011_111;
	defparam INC=6'b011_101;
	defparam DEC=6'b011_100;
	defparam POP=1;
	defparam PSH=1;
	defparam MVS=1;
	defparam STS=1;
	defparam CCP=1;
	defparam JCP=1;
	defparam CCD=1;
	defparam JCD=1;
	defparam RTC=1;
	defparam JCA=1;
	defparam MVP=1;
	defparam RTU=1;
	defparam CUA=1;
	defparam STA=1;
	defparam CLA=1;
	defparam MVR=1;
	defparam JUA=1;
	defparam CUP=1;
	defparam JUP=1;
	defparam CUD=1;
	defparam JUD=1;
	defparam NOP=1;
	
	
	//////////////////////////////////////////////
	defparam ssize=32;
	defparam sptr_size=4;
	reg [ssize-1:0] stack[(sptr_size**2)-1:0];			//stack memory
	reg [sptr_size-1:0] sptr=(sptr_size**2);
	reg stack_V=0,stack_U=0;
	/////////////////////////////////////////////
	defparam msize=32;
	defparam mptr_size=4;
	reg [msize-1:0] mem[(mptr_size**2)-1:0];	  			//data memory 
	reg [mptr_size-1:0] mptr=0;
	/////////////////////////////////////////////
	defparam isize=32;
	defparam iptr_size=4;
	reg [isize-1:0] inst_reg[(iptr_size**2)-1:0];		//instruction memory 
	reg [iptr_size-1:0] pc=0;
	/////////////////////////////////////////////
	input cin,fl;
	input clkout;
	input [7:0] opcode;
	output reg [data_size-1:0] result;
	output reg [4:0] flag=0;//[ZCSPV] Zero Carry Sign Parity oVerflow	

	always @(*)
		begin
		case(opcode)
			
			///Stack and PC operations initally at top then decrement and insert data push operation
			POP: //POP in stack
				begin
				 if(str==(sptr_size**2))
				 stack_U=1;//stack underflow
				 else begin
				 result=stack[sptr];
				 sptr=sptr+1;
				end
				end
			PSH: //PUSH in stack
				begin
				 if(str==0)	
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
				A=sptr;
				end
			CCP:
				begin
				if(fl==1)begin
				sptr=sptr-1;
				sptr=pc;
				pc=pc+val;end
				end
			JCP:
				begin
				if(fl==1)
				pc=pc+val;
				end
			CCD:
				begin
				if(fl==1)begin
				sptr=sptr-1;
				sptr=pc;
				pc=val;end
				end
			JCD:
				begin
				if(fl==1)
				pc=val;
				end
			RTC:
				begin
				if(fl==1)begin
				sptr=pc;
				sptr=sptr+1;end
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
			NOP: @(posedge clk) result=result;
			
			STA: //store into memory
				begin
				 mem[mptr]=result;
				 mptr=mptr+1;
				end
			LDA:	//Load from memory address is given
				begin
				 A=mem[mptr];
				end
			MVR:
				begin
				A=val;
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
				A[0]<=A[MSB];
				end
			ROR: //rotate rt without carry
				begin
				result <= @(posedge clkout)  A >> 1;
				A[MSB]<=A[0];
				end
			RLC: //Rotate left with carry
				begin
				result <= @(posedge clkout)  A << 1;
				A[0]<=flags[3];	//carry
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
