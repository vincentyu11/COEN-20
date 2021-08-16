.syntax	unified
.cpu	cortex-m4
.text

.global	DecodeMessage
.thumb_func
.align 
DecodeMessage:
PUSH		{R4,R5,R6,R7,R8,LR}		//Push registers R4-R8
MOV			R5,R0					//*msg in R5
MOV 		R6,R1					//array[] in R6
LDR			R8,=0					//bitnum

Start:
LDR			R4,=0					//k

Top:
MOV 		R0,R5					//R0=*msg
MOV 		R1,R8					//R1=bitnum
BL			GetBit					//branch to GetBit function
LSL			R4,R4,1					//k=k*2
ADD			R4,R4,1					//k=k*1
ADD			R4,R4,R0				//k=k+bit
LDRB		R7,[R6,R4]				//R7 = array[k]
ADD			R8,R8,1					//bitnum+=1
CMP			R7,0					//compare byte to 0
BEQ			Top						//if equal to 0, Top
CMP			R7,'$'					//compare byte to $
BEQ			Done					//if equal to $, Done
MOV			R0,R7					//R0=byte
BL			putchar					//branch to putchar function
B			Start					//back to start

Done:
POP			{R4,R5,R6,R7,R8,LR}		//Pop registers R4-R8
BX			LR						//Return function


.global	GetBit
.thumb_func
.align 
GetBit:

//bit-shifting
.if 1
LDR 		R3,=0					//R3=0
BFI			R3,R1,0,3				//R3=bits 0,1,2 of bitnum
LSR 		R1,3					//bitnum/8
LDRB		R2,[R0,R1]				//R2=byte
LSR 		R2,R2,R3				//shift right R3 bits to get R3rd bit in byte
BFC 		R2,1,7					//clear bits 1-7 to isolate LSB
MOV 		R0,R2					//move R2 to R0 for return
BX			LR						//Return function

//bit-banding
.else	
SUB			R0,R0,0x20000000		//Bit-band region offset
LSLS.N		R0,R0,5					//32*bit-band region offset
ADD			R0,R0,R1,LSL 2			//R0 += 4*bitnum
ADD			R0,R0,0x22000000		//R0 += 0x22000000 for alias address
LDR			R0,[R0]					//Load value from alias address
BX			LR
.endif


.end

