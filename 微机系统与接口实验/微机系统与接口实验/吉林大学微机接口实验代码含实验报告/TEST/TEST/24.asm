CODE SEGMENT 'CODE'
     ASSUME CS:CODE
START:MOV DX,0646H
      MOV AL,90H
      
      OUT DX,AL
A:    MOV DX,0640H
      IN  AL,DX
      AND AL,01H
      CMP AL,01H
      JZ B
      MOV AL,0FH
      MOV DX,0642H
      OUT DX,AL
      JMP A
B:    MOV AL,0F0H
      MOV DX,0642H
      OUT DX,AL
      JMP A

      MOV AH,4CH
      INT 21H
CODE ENDS
     END START