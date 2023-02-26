
A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H
A8255_CON EQU 0606H

DATA SEGMENT
TABLE1:
	NUMTAB DB 66H,5BH,06H,06H,7FH,06H,06H,5BH
    FLAG DB ?
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV DX,A8255_CON
    MOV AL,89H  ;89H=1 00 0 1 0 0 1,A�鷽ʽ0,A�����C�ڸ���λ���룻B�鷽ʽ0��B�������C�ڵ���λ����
    OUT DX,AL
    
    LEA SI,NUMTAB
    
DISP:
    MOV CX,06H
    MOV BX,0000H
    MOV AL,11011111B
DISP1:
    PUSH BX
    
    PUSH AX
    PUSH DX
	
	MOV DX,A8255_C
	IN AL,DX
	MOV FLAG,AL
	
	POP DX
	POP AX
	
    MOV BL,[FLAG]
    MOV BH,AL
    XOR BH,0FFH
    TEST BH,BL
    
    POP BX
    JZ	L
    
    MOV DX,A8255_A
    OUT DX,AL
	
    ROR AL,1
    PUSH AX

    MOV AL,[SI+BX]
    MOV DX,A8255_B
    OUT DX,AL

    POP AX
    CALL DELAY
    
    INC BX
    LOOP DISP1
    JMP DISP
L:  
	MOV DX,A8255_A
	PUSH AX
	MOV AL,0FFH
	OUT DX,AL
	
	CALL DELAY
	
	POP AX
    ROR AL,1
    
    INC BX
    LOOP DISP1
    JMP DISP


DELAY:
    PUSH CX
    MOV CX,0300H
D1:
    LOOP D1
    POP CX
    RET
    
CODE ENDS
     END START

