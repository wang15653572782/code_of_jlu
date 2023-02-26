CODE SEGMENT
    ASSUME  CS:CODE
START:
 	CALL DELAY1
    MOV CX, 04H      
JUCHI:
    MOV DX, 0600H     
    MOV AL, 00H      
JC1: 
    OUT DX, AL        
    CALL DELAY1     
    CMP AL ,0FFH
    JE JC2
    INC AL       
    JMP JC1
JC2:
    LOOP JUCHI

 
    MOV CX, 05H       
JUXING:
    MOV DX, 0600H
    MOV AL, 00H       
    OUT DX, AL
    CALL DELAY2      
    MOV AL, 0FFH     
    OUT DX, AL
    CALL DELAY2      
    LOOP JUXING

    MOV CX, 04H     
SANJIAO:
SJ1:
    MOV DX, 0600H
    OUT DX, AL
    CALL DELAY1      
    CMP AL, 0FFH
    JE SJ2           
    INC AL           
    JMP SJ1
SJ2:
    MOV DX, 0600H
    OUT DX, AL
    CALL DELAY1      
    CMP AL, 00H
    JE SJ3
    DEC AL        
    JMP SJ2
SJ3:
    LOOP SANJIAO


    MOV CX, 0004H    
    MOV AX, 0FEH       
    MOV BL,05H       
    DIV BL            
    MOV BL, AL         
    MOV BH, 00H       
JIETI:
    MOV AX,0000H      
JT1:
    MOV DX, 0600H
    OUT DX, AL
    CMP AL, 0FEH     
    JE JT2           
    CALL DELAY2      
    ADD AX, BX         
    JMP JT1
JT2:    
    LOOP JIETI	


	JMP START

DELAY1:                ;∂Ã—” ±
    PUSH CX
    MOV CX, 01FFH
D1: 
    PUSH AX
    POP AX
    LOOP D1
    POP CX
    RET

DELAY2:               ;≥§—” ±
    PUSH CX
    MOV CX, 0FFFFH
D2: 
    PUSH AX
    POP AX
    LOOP D2
    POP CX
    RET
CODE ENDS
    END START
