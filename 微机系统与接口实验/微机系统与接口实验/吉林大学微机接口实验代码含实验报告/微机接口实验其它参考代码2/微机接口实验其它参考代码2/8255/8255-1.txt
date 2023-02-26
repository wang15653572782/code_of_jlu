CODE SEGMENT 'CODE'
     ASSUME CS:CODE
START: MOV AL,90H
       MOV DX,0646H
       OUT DX,AL  ;送方式字A
A:     MOV DX,0640H
       IN AL,DX   ;读A端口
       MOV DX,0642H
       OUT DX,AL  ;送B端口
       JMP A
       
       MOV AH,4CH  ;返回
       INT 21H
CODE   ENDS
       END START