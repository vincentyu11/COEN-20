.syntax	unified
.cpu	cortex-m4
.text


.global	FloatPoly
.thumb_func
.align 
FloatPoly:
VSUB.F32 S1,S1,S1 //sum = 0
VMOV S3,1.0
L1:CBZ R1,done
VLDMIA R0!,{S2}//getting value of array and incrementing
VMUL.F32 S2,S3,S2
VADD.F32 S1,S1,S2
VMUL.F32 S3,S3,S0
SUB R1,R1,1
B L1
done: VMOV S0,S1
BX LR

.global	FixedPoly
.thumb_func
.align 
FixedPoly:
PUSH {R4,R5,R6,R7}
LDR R4,=1
LSL R4,R4,16
LDR R5,=0 //sum
//MOV R6,R0 //R6 = x value
loop: CBZ R2,end
LDMIA R1!,{R6} //r7 = a value
//LDR R7,[R1],4
SMULL R6,R7,R6,R4
LSRS.N R6,R6,16
ORR R6,R6,R7,LSL 16 //a * x^n
ADD R5,R5,R6
SMULL R4,R7,R4,R0 //x^n
LSRS.N R4,R4,16
ORR R4,R4,R7,LSL 16
SUB R2,R2,1
B loop
end: MOV R0,R5
POP {R4,R5,R6,R7}
BX LR
