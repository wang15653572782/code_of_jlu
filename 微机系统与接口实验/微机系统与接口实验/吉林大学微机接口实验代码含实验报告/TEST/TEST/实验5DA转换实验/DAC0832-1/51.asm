STACK0 SEGMENT STACK
  DW 32 DUP(?)
STACK0 ENDS

CODE SEGMENT
ASSUME  CS:CODE, SS:STACK0

START:

;产生平波
     MOV CX, 10H       ;周期数
PING:
     MOV DX, 0600H		;DAC0832接IOY0,0600H为控制端口地址
     MOV AL, 07FH		;AL为数字量
P1: 
     OUT DX, AL			;转换为模拟量
     CALL DELAY2		;延时
     JMP P2
P2: 
     DEC CX				;CX递减直到为0
     CMP CX,00H
     JNE P1
     
     
     
     
;产生锯齿波
     MOV CX, 05H		;周期数
JUCHI:
     MOV DX, 0600H			;DAC0832接IOY0,0600H为控制端口地址
     MOV AL, 00H		;AL为数字量
JC1: 
     OUT DX, AL				;转换为模拟量
     CALL DELAY1			;延时，此为短延时
     CMP AL,0FFH
     JE JC2
     INC AL					;AL步加1，直到等于0FFH
     JMP JC1
JC2: 
     DEC CX					;CX递减直到为0
     CMP CX,00H
     JNE JUCHI



;产生矩形波
     MOV CX, 05H		;周期数
JUXING:
     MOV DX, 0600H
     MOV AL, 00H       ;先输出00H的波形
     OUT DX, AL
     CALL DELAY2       ;长延时
     MOV AL,0FFH      ;再输出0FFH的波形
     OUT DX, AL
     CALL DELAY2       ;长延时
     LOOP JUXING



;产生三角波
     MOV CX, 05H		;周期数
SANJIAO:
     MOV AL,00H
SJ1:
     MOV DX, 0600H
     OUT DX, AL
     CALL DELAY1       ;短延时
     CMP AL, 0FFH
     JE SJ2           
     INC AL            ;将AL从00H步加0FFH
     JMP SJ1
SJ2:
     MOV DX, 0600H
     OUT DX, AL
     CALL DELAY1       ;短延时
     CMP AL, 00H
     JE SJ3
     DEC AL            ;将AL从0FFH步减至00H
     JMP SJ2
SJ3:
     LOOP SANJIAO


;产生阶梯波
     MOV CX, 05H		;周期数
     MOV AX, 0FEH			;考虑到8086的DIV除法可能会出现余数为负导致加起来之后的最大值大于0FFH，故使用0FEH作最大值
     MOV BL,08H			;阶梯波中的阶梯数
     DIV BL					;最大振幅除以阶梯数，得每个台阶的高度
     MOV BL, AL
     MOV BH, 00H			;BH置0
JIETI:
     MOV AX,0000H		;AX初始化0000H
JT1:
     MOV DX, 0600H
     OUT DX, AL
     CMP AX, 00FFH		;判断AX是否达到幅度上线
     JAE JT2			;达到上限，表示一次阶梯波完整生成，开始新一次生成
     CALL DELAY2		;长延时
     ADD AX, BX			;用当前解体高度加上每个阶梯的高度得到下一阶梯的高度
     JMP JT1
JT2:    
LOOP JIETI



DELAY1:                ;短延时
     PUSH CX
     MOV CX, 0300H
D1: 
     PUSH AX
     POP AX
     LOOP D1
     POP CX
     RET


DELAY2:               ;长延时
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
