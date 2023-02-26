CODE SEGMENT
     ASSUME CS:CODE
START: MOV AX,8000H
      MOV DS,AX
      MOV BX,0000H
      MOV [BX],00H
      ADD BX,2
      MOV DX,0100H
      MOV CX,15

A:   MOV [BX],DX
     ADD BX,2
     INC DH
     LOOP A
      
      MOV [BX],00H
      
      MOV AH,4CH
      INT 21H
      ENDS
END   START