CODE SEGMENT
     ASSUME CS:CODE
START: MOV AX,8000H;设置起始地址
       MOV DS,AX
       SUB BX,BX   ;清零，用于地址计数
       SUB DX,DX   ;清零，用于形成数字
       MOV CX,16
       
A:     MOV [BX],DX
       ADD BX,2
       INC DX
       LOOP A
       
       MOV AH,4CH
       INT 21H
CODE   ENDS
       END START