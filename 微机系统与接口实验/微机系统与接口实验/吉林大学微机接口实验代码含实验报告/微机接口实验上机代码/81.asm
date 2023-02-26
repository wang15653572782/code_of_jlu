
A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H
A8255_CON EQU 0606H

DATA SEGMENT
	NUMTAB DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX
    
	LEA SI,NUMTAB
    
	MOV DX,A8255_CON
	MOV AL,81H
	OUT DX,AL
    
DISP:    
	MOV CX,06H			;数字移动循环次数
	MOV BX,1H		;偏移量
	MOV AL,11111110B	;位码
DISP1: 
	MOV DX,A8255_A
	OUT DX,AL
	ROL AL,1			;循环左移
	PUSH AX
	
	MOV AL,[SI+BX]
	MOV DX,A8255_B
	OUT DX,AL
	
	POP AX
	CALL DELAY
	
	INC BX
	LOOP DISP1
	JMP DISP
    
    
DELAY:
    PUSH CX
    MOV CX,00FFH
D1:
    LOOP D1
    POP CX
    RET
    
CODE ENDS
     END START

