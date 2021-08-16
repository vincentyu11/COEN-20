.syntax	unified
.cpu	cortex-m4
.text

.global	PutNibble
.thumb_func
.align
PutNibble:
	LDR R0,=0
	BX LR
	
	//bfi
	
.global	GetNibble
.thumb_func
.align
GetNibble:
	//R0 - starting address of array
	//R1 - which

	ADD R2,R1,1	//R2 = which +1
	ASR R1,R1,1	//arithmetic shift right for which
	ADD R0,R0,R1 //start position  + nibble position
	CBZ R2,Even
	LDR R3,[R0]
	ADD R0,R3,240
	ASR R0,R0,4
	BX LR
	
Even:
	LDR R3,[R0]
	ADD R0,R3,15
	BX LR
	
	

	
//nibble = 4 bits 
.end