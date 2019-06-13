///have to change opcode only
module alu(result,flags,A,B,opcode,clkout);
	defparam data_data_size=32;
	input [data_size-1:0] A,B;
	input clkout;
	input [7:4] opcode;
	output reg [2*data_size-1:0] result;//problem in multiplication
	output reg [4:0] flags=5'b0000;//[SZNVC]

	reg [data_size-1:0] temp;

	
	always @(posedge clkout)
		begin
		flags = 5'b00000; //[SZNVC]
		case(opcode)
			6'b001_001,6'b010_001: //ADD, ADDi
				begin
					if(A[data_size-1] == 1'b0 && B[data_size-1] == 1'b0) //Addition of two positive numbers / or / two unsinged numbers
						begin
							result = A + B;		

							if(result[2*data_size-1] == 1'b1) //Overflow occured 
								flags[1] = 1'b1;
	
						end
					else if(A[data_size-1] == 1'b0 && B[data_size-1] == 1'b1) //Addition of positive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + B;
							flags[4] = result[2*data_size-1];
						end
					else if(A[data_size-1] == 1'b1 && B[data_size-1] == 1'b0) //Addition of positive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + B;
							flags[4] = result[2*data_size-1];
						end
					else if(A[data_size-1] == 1'b1 && B[data_size-1] == 1'b1) //Addition two negative numbers / or / two unsinged numbers
						begin
							{flags[0],result} = A + B;
							flags[4] = 1'b1;
							if(result[2*data_size-1] == 1'b0) //Overflow occured
								flags[1] = 1'b1;
	
						end
				end
		
			6'b001_111: //MUL
				begin

					{flags[0],result} = A * B;
				end
				
			6'b001_010,6'b010_010,6'b001_110,6'b010_110: //SUB, SUBi, COMP, COMPi
				begin
					temp = (~B + 1'b1);
					if(A[data_size-1] == 1'b0 && temp[data_size-1] == 1'b0) //Addition of two positive numbers / or / two unsinged numbers
						begin
							result = A + temp;		

							if(result[2*data_size-1] == 1'b1) //Overflow occured 
								flags[1] = 1'b1;
	
						end
					else if(A[data_size-1] == 1'b0 && temp[data_size-1] == 1'b1) //Addition of positive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + temp;
							flags[4] = result[2*data_size-1];
						end
					else if(A[data_size-1] == 1'b1 && temp[data_size-1] == 1'b0) //Addition of positive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + temp;
							flags[4] = result[2*data_size-1];
						end
					else if(A[data_size-1] == 1'b1 && temp[data_size-1] == 1'b1) //Addition two negative numbers / or / two unsinged numbers
						begin
							{flags[0],result} = A + temp;
							flags[4] = 1'b1;
							if(result[2*data_size-1] == 1'b0) //Overflow occured
								flags[1] = 1'b1;
	
						end


				end


			6'b001_011,010_011: //XOR,XORi
				begin
					result = A ^ B;
					flags[4] = result[2*data_size-1];	
					
				end
			6'b001_100,010_100: //AND,ANDi
				begin
					result = A & B;	
					flags[4] = result[2*data_size-1];	

				end
			6'b001_101,010_101: //OR,ORi
				begin
					result = A | B;	
					flags[4] = result[2*data_size-1];	
					
				end
			6'b011_001: //COM
				begin
					result = ~A;
					flags[4] = result[2*data_size-1];	


				end
			6'b011_000: //NEG
				begin
					result = ~A + 1'b1;
					flags[4] = result[2*data_size-1];	

				end
			6'b011_010: //SRL
				begin
					flags[0] = A[0];
					result = A >> 1;
					flags[4] = result[2*data_size-1];	

				end
			6'b011_011: //SLL
				begin
					flags[0] = A[data_size-1];
					result = A << 1;
					flags[4] = result[2*data_size-1];	

				end
			6'b011_110: //ASR
				begin
					result = A >>> 1;
					flags[4] = result[2*data_size-1];	
				end
			6'b011_111: //CLR
				begin
					result = {64{1'b0}};
				end
			6'b011_101: //INC
				begin

					if(A[data_size-1] == 1'b0) //Addition of two positive numbers / or / two unsinged numbers
						begin
							result = A + 1;		

							if(result[2*data_size-1] == 1'b1) //Overflow occured 
								flags[1] = 1'b1;
	
						end
					else if(A[data_size-1] == 1'b1) //Addition of postive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + 1;
							flags[4] = result[2*data_size-1];
							if(result[2*data_size-1] == 1'b0) //Overflow occured
								flags[1] = 1'b1;
	
						end


				end
			6'b011_100: //DEC
				begin

					if(A[2*data_size-1] == 1'b0)  //Addition of postive and negative number / or / two unsinged numbers
						begin
							{flags[0],result} = A + {16{1'b1}};	
							flags[4] = result[2*data_size-1];	
	
						end
					else if(A[2*data_size-1] == 1'b1) //Addition of two negative numbers / or / two unsinged numbers
						begin
							{flags[0],result} = A + {16{1'b1}};
							flags[4] = 1'b1;
							if(result[2*data_size-1] == 1'b0) //Overflow occured
								flags[1] = 1'b1;
	
						end


				end
		endcase


					if(result == 0) //Check for zero flag
						flags[3] = 1'b1;
					if(result[2*data_size-1] == 1'b1) //Negative number check
						flags[2] = 1'b1;

		end	
	
endmodule
