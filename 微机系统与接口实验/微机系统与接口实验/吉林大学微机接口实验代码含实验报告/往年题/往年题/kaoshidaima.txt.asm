;���ݿ���k0k1k2��ɵ���λ��000~111�����������ʾ����ʼ���ҵ�������ȶ���123456��
;��λ����ֵΪ0��7ʱ��Ȼ���ҵ�������ȶ���123456��
;��λ����ֵΪ1-6ʱ���ҵ��������123456�������Ӧλ������Ϊ1���������1λ����ʾ��
A8255_A    EQU 0600H
A8255_B    EQU 0602H
A8255_C    EQU 0604H
A8255_CON  EQU 0606H

SSTACK SEGMENT STACK
	DB 16 DUP(?)
SSTACK ENDS

DATA SEGMENT
		LEDMTAB DB 3FH,06H,5BH,4FH,66H,6DH,7DH	;0~6
		NUMBER DB 1H,2H,3H,4H,5H,6H
		NUM DB 00H						;����λ��ֵ
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
		IN    AL,DX       	;��c�ڶ���

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
		MOV BL,0DFH			;�����ұ߿�ʼ��ʾ1101 1111
		MOV CX,6H			;��ʾ6λ 
AGAIN:
		MOV AL,BL
		MOV DX,A8255_A
		OUT DX,AL
		MOV AL,[SI]
		CMP AL,NUM			;����0-7������0��7�������
		JNZ NORMOL			
		MOV AL,00H			;NUM���������   ��
		JMP OUTD
NORMOL:				
		LEA DI,LEDMTAB
		ADD DI,AX
		MOV AL,[DI]
OUTD:		
		MOV DX,A8255_B 
		OUT DX,AL 
		CALL DELAY1
		CALL CLEAR		;��Ӱ����
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