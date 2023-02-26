CODE SEGMENT 'CODE'
     ASSUME CS:CODE
START:MOV DX,0646H
      MOV AL,90H
      OUT DX,AL
A:    MOV DX,0640H
      IN  AL,DX
      AND AL,01H
      CMP AL,00H
      JZ B
      MOV DL,AL
      CMP AL,01H
      JZ C
      MOV AL,DL
      CMP AL,10H
      JZ D
      JMP E
      JMP A
B:       MOV AX,8000H;设置起始地址
       MOV DS,AX
       SUB BX,BX   ;清零，用于地址计数
       SUB DX,DX   ;清零，用于形成数字
       MOV CX,16
       
B0:    MOV [BX],DX
       ADD BX,2
       INC DX
       LOOP B0
      JMP A
C:MOV AX,8000H
      MOV DS,AX
      MOV BX,0000H
      MOV [BX],00H
      ADD BX,2
      MOV DX,0100H
      MOV CX,15

C0:   MOV [BX],DX
     ADD BX,2
     INC DH
     LOOP C0
    
      
      MOV [BX],00H
      JMP A
D: MOV AX,8000H
       MOV DS,AX
       SUB BX,BX
       SUB DX,DX
       MOV CX,16
       
D0:     MOV [BX],DX
       INC DX
       MOV [BX+1],DX
       ADD BX,2
       INC DX
       LOOP D0
       JMP A
E:      MOV AH,4CH
      INT 21H
CODE ENDS
     END START