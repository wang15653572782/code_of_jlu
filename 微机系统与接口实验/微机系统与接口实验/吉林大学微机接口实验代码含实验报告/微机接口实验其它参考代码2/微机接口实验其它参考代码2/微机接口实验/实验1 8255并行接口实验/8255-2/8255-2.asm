CODE SEGMENT 'CODE'
     ASSUME CS:CODE
START: MOV AL,90H
      MOV DX,0646H
      OUT DX,AL
A:    MOV DX,0640H
      IN  AL,DX
      CMP AL,0FFH
      JZ  B
      MOV DX,0642H
      OUT DX,AL
      JMP A
B:    MOV DX,0642H
      MOV AL,00H
      OUT DX,AL
      MOV AH,4CH
      INT 21H
CODE ENDS
     END START