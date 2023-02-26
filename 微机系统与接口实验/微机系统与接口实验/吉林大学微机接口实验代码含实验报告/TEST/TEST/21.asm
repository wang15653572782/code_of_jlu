CODE SEGMENT
     ASSUME CS:CODE
START: MOV AX,2000H
       MOV DS,AX
       MOV BX,0000H
       MOV DX,0000H
       MOV CX,16
       
A:     MOV [BX],DX
       ADD BX,2
       INC DX
       LOOP A
       
       MOV AH,4CH
       INT 21H

CODE   ENDS
       END START