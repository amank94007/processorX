///have to change opcode only
// have to add jump and immediate value operations
module alu(result,flags,A,B,opcode,clkout);
	defparam data_size=32;
	
	///////////  OPCODE  /////////////////////////
	defparam ADD=6'b001_001;
	defparam ADDi=6'b010_001;
	defparam MUL=6'b001_111;
	defparam SUB=6'b001_010;
	defparam SUBi=6'b010_010;
	defparam COMP=6'b001_110;
	defparam COMPi=6'b010_110;
	defparam XOR=6'b001_011;
	defparam XORi=6'b010_011;
	defparam AND=6'b001_100;
	defparam ANDi=6'b010_100;
	defparam OR=6'b001_101;
	defparam ORi=6'b010_101;
	defparam NOT=6'b011_001;
	defparam NEG=6'b011_000;
	defparam SRL=6'b011_010;
	defparam SLL=6'b011_011;
	defparam ASR=6'b011_110;
	defparam CLR=6'b011_111;
	defparam INC=6'b011_101;
	defparam DEC=6'b011_100;
	//////////////////////////////////////////////
	
	input [data_size-1:0] A,B;
	input clkout;
	input [7:4] opcode;
	reg [data_size-1:0] result_msb;
	output reg [data_size-1:0] result;
	output reg [4:0] flags=5'b0000;//[SZNVC]

	reg [data_size-1:0] temp;
	
	
	always @(posedge clkout)
		begin
		flags = 5'b00000; //[SZNVC]
		case(opcode)
			ADD,ADDi: //ADD, ADDi
				begin
					if(A[data_size-1] == 1'b0 && B[data_size-1] == 1'b0) //Addition of two positive numbers / or / two unsinged numbers
						begin
							result = A + B;		

							if(result[size-1] == 1'b1) //Overflow occured 
								flags[1] = 1'b1;
	
						end
					else if(A[data_size-1] == 1'b0 && B[data_size-1] == 1'b1) //Addition of positive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + B;
							flags[4] = result[size-1];
						end
					else if(A[data_size-1] == 1'b1 && B[data_size-1] == 1'b0) //Addition of positive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + B;
							flags[4] = result[size-1];
						end
					else if(A[data_size-1] == 1'b1 && B[data_size-1] == 1'b1) //Addition two negative numbers / or / two unsinged numbers
						begin
							{flags[0],result} = A + B;
							flags[4] = 1'b1;
							if(result[size-1] == 1'b0) //Overflow occured
								flags[1] = 1'b1;
	
						end
				end
		
			MUL: //MUL
				begin

					{flags[0],result_msb,result} = A * B;
				end
				
			SUB,SUBi,COMP,COMPi: //SUB, SUBi, COMP, COMPi
				begin
					temp = (~B + 1'b1);
					if(A[data_size-1] == 1'b0 && temp[data_size-1] == 1'b0) //Addition of two positive numbers / or / two unsinged numbers
						begin
							result = A + temp;		

							if(result[size-1] == 1'b1) //Overflow occured 
								flags[1] = 1'b1;
	
						end
					else if(A[data_size-1] == 1'b0 && temp[data_size-1] == 1'b1) //Addition of positive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + temp;
							flags[4] = result[size-1];
						end
					else if(A[data_size-1] == 1'b1 && temp[data_size-1] == 1'b0) //Addition of positive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + temp;
							flags[4] = result[size-1];
						end
					else if(A[data_size-1] == 1'b1 && temp[data_size-1] == 1'b1) //Addition two negative numbers / or / two unsinged numbers
						begin
							{flags[0],result} = A + temp;
							flags[4] = 1'b1;
							if(result[size-1] == 1'b0) //Overflow occured
								flags[1] = 1'b1;
	
						end


				end


			XOR,XORi: //XOR,XORi
				begin
					result = A ^ B;
					flags[4] = result[size-1];	
					
				end
			AND,ANDi: //AND,ANDi
				begin
					result = A & B;	
					flags[4] = result[size-1];	

				end
			OR,ORi: //OR,ORi
				begin
					result = A | B;	
					flags[4] = result[size-1];	
					
				end
			NOT: //IN VERT
				begin
					result = ~A;
					flags[4] = result[size-1];	


				end
			NEG: //NEG
				begin
					result = ~A + 1'b1;
					flags[4] = result[size-1];	

				end
			SRL: //SRL
				begin
					flags[0] = A[0];
					result = A >> 1;
					flags[4] = result[size-1];	

				end
			SLL: //SLL
				begin
					flags[0] = A[data_size-1];
					result = A << 1;
					flags[4] = result[size-1];	

				end
			ASR: //ASR
				begin
					result = A >>> 1;
					flags[4] = result[size-1];	
				end
			CLR: //CLR
				begin
					result = {64{1'b0}};
				end
			INC: //INC
				begin

					if(A[data_size-1] == 1'b0) //Addition of two positive numbers / or / two unsinged numbers
						begin
							result = A + 1;		

							if(result[size-1] == 1'b1) //Overflow occured 
								flags[1] = 1'b1;
	
						end
					else if(A[data_size-1] == 1'b1) //Addition of postive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + 1;
							flags[4] = result[size-1];
							if(result[size-1] == 1'b0) //Overflow occured
								flags[1] = 1'b1;
	
						end


				end
			6'b011_100: //DEC
				begin

					if(A[size-1] == 1'b0)  //Addition of postive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + {16{1'b1}};	
							flags[4] = result[size-1];	
	
						end
					else if(A[size-1] == 1'b1) //Addition of two negative numbers / or / two unsinged numbers
						begin
							{flags[0],result} = A + {16{1'b1}};
							flags[4] = 1'b1;
							if(result[size-1] == 1'b0) //Overflow occured
								flags[1] = 1'b1;
	
						end


				end
		endcase


					if(result == 0) //Check for zero flag
						flags[3] = 1'b1;
					if(result[size-1] == 1'b1) //Negative number check
						flags[2] = 1'b1;

		end	
	
endmodule
