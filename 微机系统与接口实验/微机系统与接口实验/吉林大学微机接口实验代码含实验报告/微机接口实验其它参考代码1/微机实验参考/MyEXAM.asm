;-----------------------------
;根据开关k0k1k2组成的三位数000~111决定数码管显示，初始从右到左输出稳定的123456：
;三位数的值为0或7时依然从右到左输出稳定的123456，
;三位数的值为1-6时从右到左输出的123456中灭掉相应位，比如为1则数码管上1位置显示空
;----------------------------

A8255_A    EQU 0600H
A8255_B    EQU 0602H
A8255_C    EQU 0604H
A8255_CON  EQU 0606H

SSTACK SEGMENT STACK
	DB 16 DUP(?)
SSTACK ENDS

DATA SEGMENT
		LEDTAB DB 3FH,06H,5BH,4FH,66H,6DH,7DH	;0~6
		NUMBER DB 1H,2H,3H,4H,5H,6H
		NUM DB 00H						;低三位的值
DATA ENDS

CODE  SEGMENT
      ASSUME CS:CODE,DS:DATA
START:
		MOV AX,DATA
		MOV DS,AX

		;8255
		MOV   AL,89H   ;10000001B
		MOV   DX,A8255_CON
		OUT   DX,AL
		
BEGIN:	
		MOV NUM,0H
		MOV   DX,A8255_C
		IN    AL,DX       	;从c口读入

		AND AL,07H
		MOV NUM,AL
		CALL DIS

		JMP BEGIN

DIS PROC
		PUSH AX
		PUSH BX
		PUSH CX
		LEA SI,NUMBER
		MOV AH,00H
		MOV BL,0DFH			;从最右边开始显示
		MOV CX,6H			;显示6位 
AGAIN:
		MOV AL,BL
		MOV DX,A8255_A
		OUT DX,AL
		MOV AL,[SI]
		CMP AL,NUM			;处理0-7，其中0和7不会相等
		JNZ NORMOL			
		MOV AL,00H			;NUM处输出‘空’
		JMP OUTD
NORMAL:				
		LEA DI,LEDTAB
		ADD DI,AX
		MOV AL,[DI]
OUTD:		
		MOV DX,A8255_B 
		OUT DX,AL 
		CALL DELAY1
		CALL CLEAR		;消影处理
		INC SI
		ROR BL,1
		LOOP AGAIN

		POP CX
		POP BX
		POP AX
		RET
DIS ENDP

CLEAR PROC
		PUSH AX
		MOV AL,00H
		MOV DX,A8255_B
		OUT DX,AL
		POP AX
		RET
CLEAR ENDP

DELAY1 PROC
		PUSH CX
		MOV  CX,0FFH
		LOOP $
		POP  CX
		RET
DELAY1 ENDP	

CODE  ENDS
	END START