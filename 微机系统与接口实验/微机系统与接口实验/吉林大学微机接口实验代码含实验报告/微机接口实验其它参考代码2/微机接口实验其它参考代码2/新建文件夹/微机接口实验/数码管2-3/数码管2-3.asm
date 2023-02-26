A8255_CON EQU 0606H
A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H

DATA SEGMENT
TABLE1:
    DB 6DH
    DB 06H
    DB 7FH
    DB 5BH
    DB 07H
    DB 06H   
FLAG   DB   
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    ;获取开关状态
    
    MOV DX,A8255_CON
    ;MOV AL,81H
    MOV AL,89H  ;89H=10001001,A口方式0输出，B口方式0输出，C口方式0输入
    OUT DX,AL
    
    LEA SI,TABLE1

    MOV DX,A8255_B
    MOV AL,00H
    OUT DX,AL

    MOV DX,A8255_A
    MOV AL,00H
    OUT DX,AL
    
X2:    
    MOV CX,06H
    MOV BX,0000H
    
    MOV AL,11011111B
X1:        
    PUSH BX
    
    PUSH AX
    PUSH DX
    
    ;MOV AL,99H
	;MOV DX,A8255_CON
	;OUT DX,AL
	
	MOV DX,A8255_C
	IN AL,DX
	MOV FLAG,AL
	
	POP DX
	POP AX
	
    MOV BL,[FLAG]
    ;MOV BL,0F0H
    MOV BH,AL
    XOR BH,0FFH
    TEST BH,BL
    POP BX
    JZ   L   
    
    MOV DX,A8255_A
    OUT DX,AL
    ;CALL DELAY

    ROR AL,1
    PUSH AX

    MOV AL,[BX+SI]
    MOV DX,A8255_B
    OUT DX,AL

    POP AX
    CALL DELAY
    
    INC BX
    LOOP X1    
    JMP X2
L:  
	MOV DX,A8255_A
	PUSH AX
	MOV AL,0FFH
	OUT DX,AL
	CALL DELAY
	POP AX
    ROR AL,1
    INC BX
    LOOP X1
    JMP X2
        
DELAY:
    PUSH CX
    MOV CX,02FFH
X4:
    LOOP X4
    POP CX
    RET
CODE ENDS
     END START

