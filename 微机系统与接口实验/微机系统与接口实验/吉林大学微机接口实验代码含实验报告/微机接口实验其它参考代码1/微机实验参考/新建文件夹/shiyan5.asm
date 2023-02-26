CODE SEGMENT
ASSUME CS:CODE
MAIN PROC FAR 

     M:CALL FANGBO      
       CALL JUCHI      
       CALL SANJIAO
       JMP M
 	   MOV AH,4CH
       INT 21H
       
FANGBO PROC NEAR
    
    MOV AL,00H
    MOV DX,0600H
    OUT DX,AL
    MOV CX,0FFFFH
F1: LOOP F1
    MOV AL,0FFH
    MOV DX,0600H
    OUT DX,AL
    MOV CX,0FFFFH
F3: LOOP F3
    
RET   
FANGBO ENDP
	 
JUCHI PROC NEAR
	  
	  MOV AL,00H
   Y1:MOV DX,0600H ;锯齿
      OUT DX,AL
      INC AL
      MOV CX,0FFH
   Y2:LOOP Y2    
      JNZ  Y1
      RET     
JUCHI ENDP     

SANJIAO PROC NEAR
      
      MOV AL,00H
   S1:MOV DX,0600H
      OUT DX,AL
      INC AL
      MOV CX,0FFH
   S2:LOOP S2
      JNZ S1
      DEC AL
      DEC AL       ;消除平角 最大
   S4:MOV DX,0600H
      OUT DX,AL
      DEC AL
      MOV CX,0FFH
   S5:LOOP S5
      JNZ S4      ;变小      
RET
SANJIAO ENDP

MAIN ENDP     
CODE ENDS
   END     
