CODE SEGMENT
     ASSUME CS:CODE
START: MOV AX,2000H
       MOV DS,AX
       SUB BX,BX
       SUB DX,DX
       MOV CX,16
       
A:     MOV [BX],DX
       INC DX
       MOV [BX+1],DX
       ADD BX,2
       INC DX
       LOOP A
       
       MOV AH,4CH
       INT 21H
CODE   ENDS
       END START