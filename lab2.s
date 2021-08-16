.syntax	unified
.cpu	cortex-m4
.text

.global	Ten32
.thumb_func
.align 
Ten32: LDR R0,=10
BX LR

.global Ten64
.thumb_func
.align
Ten64:
LDR R0,=10
LDR R1,=0
BX LR

.global Incr
.thumb_func
.align
Incr: 
ADD R0,R0,1
BX LR

.global Nested1
.thumb_func
.align
Nested1: PUSH {LR}
BL rand
ADD R0,R0,1
POP {PC}

.global Nested2
.thumb_func
.align
Nested2:
PUSH {R4,LR}
BL rand
MOV R4,R0
BL rand
ADD R0,R0,R4
POP {R4,PC}

.global PrintTwo
.thumb_func
.align
PrintTwo:
PUSH {R4,R5,LR}
MOV R4,R0
MOV R5,R1
BL printf
ADD R1,R5,1
MOV R0,R4
BL printf
POP {R4,R5,PC}

