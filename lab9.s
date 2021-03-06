.syntax	unified
.cpu	cortex-m4
.text

.global	SIMD_USatAdd
.thumb_func
.align 
SIMD_USatAdd:
PUSH {R4-R11}
BFI R2,R2,8,8
BFI R2,R2,16,16
.align
loop: CMP R1,40
BLT cleanup
LDMIA R0,{R3-R12}
UQADD8 R3,R3,R2
UQADD8 R4,R4,R2
UQADD8 R5,R5,R2
UQADD8 R6,R6,R2
UQADD8 R7,R7,R2
UQADD8 R8,R8,R2
UQADD8 R9,R9,R2
UQADD8 R10,R10,R2
UQADD8 R11,R11,R2
UQADD8 R12,R12,R2
STMIA R0!,{R3-R12}
SUBS R1,R1,40
B loop
cleanup: CBZ R1,finish 
LDR R3,[R0]
UQADD8 R3,R3,R2
STR R3,[R0],4
SUBS R1,R1,4
B cleanup
finish:
POP {R4-R11}
BX LR

.global	SIMD_USatSub
.thumb_func
.align 
SIMD_USatSub:
PUSH {R4-R11}
BFI R2,R2,8,8
BFI R2,R2,16,16
.align
loop1: CMP R1,40
BLT cleanup1
LDMIA R0,{R3-R12}
UQSUB8 R3,R3,R2
UQSUB8 R4,R4,R2
UQSUB8 R5,R5,R2
UQSUB8 R6,R6,R2
UQSUB8 R7,R7,R2
UQSUB8 R8,R8,R2
UQSUB8 R9,R9,R2
UQSUB8 R10,R10,R2
UQSUB8 R11,R11,R2
UQSUB8 R12,R12,R2
STMIA R0!,{R3-R12}
SUBS R1,R1,40
B loop1
cleanup1: 
CBZ R1,finish1
LDR R3,[R0]
UQSUB8 R3,R3,R2
STR R3,[R0],4
SUBS R1,R1,4
B cleanup1
finish1:
POP {R4-R11}
BX LR