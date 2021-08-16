.syntax	unified
.cpu	cortex-m4
.text

.global	HWFlPtPoly
.thumb_func
.align 
HWFlPtPoly:
	//S0 = x, R0 = a[], R1 = n
	
	VMOV		S3,1.0					//S3 = 1.0
	VSUB.F32 	S1,S1,S1				//result = 0
	
	Loop:
	CBZ 		R1,Done					//if R1 = 0, done
	VLDMIA 		R0!,{S2}				//load a[] into S2, incrementing
	VMUL.F32	S2,S2,S3				//a * x^*
	VADD.F32	S1,S1,S2				//result = result + S2
	VMUL.F32	S3,S3,S0				//increment x exponent
	SUB			R1,R1,1					//subtract 1 from R1 for loop condition
	B 			Loop					//repeat loop
	
	Done:
	VMOV		S0,S1					//move S1 to S0 for return
	
	BX			LR						//return function
	

.global	SWFlPtPoly
.thumb_func
.align 
SWFlPtPoly:
	//R0 = x, R1 = a[], R2 = n	

	PUSH		{R4,R5,R6,R7,R8,LR}		//Push registers
	VMOV		S0,1.0					//S0 = 1.0
	VMOV		R4,S0					//R4 = 1.0
	LDR			R6,=0					//result = 0
	MOV			R5,R0					//R5 = x
	MOV			R7,R1					//R7 = a[]
	MOV 		R8,R2					//R8 = n
	
	Loop1:
	CMP 		R8,0					//compare n to 0
	BLE			Done1					//if n <= 0, done1
	LDMIA		R7!,{R0}				//load a[] into R0. incrementing
	MOV 		R1,R4					//R1 = current x
	BL			MulFloats				//R0 * R1
	MOV			R1,R6					//R1 = result
	BL			AddFloats				//result = result + R0
	MOV			R6,R0					//move result back to R6
	MOV			R0,R4					//R0 = current x
	MOV			R1,R5					//R1 = x
	BL			MulFloats				//increment x exponent
	MOV			R4,R0					//move next x back to R4
	SUB			R8,R8,1					//subtract 1 from R8 for loop condition
	B			Loop1					//repeat loop
	
	Done1:
	MOV 		R0,R6					//move result to R0
	POP			{R4,R5,R6,R7,R8,LR}		//Pop registers
	
	BX			LR						//return function
	
	
.global	Q16FxdPoly
.thumb_func
.align 
Q16FxdPoly:
	//R0 = x, R1 = a[], R2 = n
	
	PUSH 		{R4,R5,R6,R7,R8}			//Push registers
	LDR			R4,=1					//R4 = 1
	LSL			R4,R4,16				//change 1 into Q16
	LDR			R5,=0					//result = 0
	
	Loop2:
	CBZ 		R2,Done2				//if n = 0, done2
	LDMIA		R1!,{R6}				//load a[] into R6
	SMULL		R6,R7,R6,R4				//R6 * R4
	LSR			R6,R6,16				//shift R6 right to get 16 MSB into 0-15
	BFI			R6,R7,16,16				//insert 16 LSB of R7 into 16-31 of R6
	ADD			R5,R5,R6				//result = result + R6
	SMULL		R6,R7,R4,R0				//next x = current x * x
	LSR			R6,R6,16				//shift R6 right to get 16 MSB into 0-15
	BFI			R6,R7,16,16				//insert 16 LSB of R7 into 16-31 of R6
	MOV			R4,R6					//R4 = next x
	SUB			R2,R2,1					//subtract 1 from R2 for loop condition
	B 			Loop2					//repeat loop
	
	Done2:
	MOV			R0,R5					//move result to R0
	POP			{R4,R5,R6,R7,R8}		//Pop registers
	BX			LR						//return function
	
.end
