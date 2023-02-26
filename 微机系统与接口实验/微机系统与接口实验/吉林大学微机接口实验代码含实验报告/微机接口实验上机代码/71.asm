M8251_DATA EQU 0600H
M8251_CON EQU 0602H
M8254_2 EQU 06C4H
M8254_CON EQU 06C6H

SSTACK SEGMENT STACK
	DW 64 DUP(?)
SSTACK ENDS

CODE SEGMENT
	ASSUME CS:CODE
START:
	MOV AX,0000H
	MOV DS,AX	;���ݶε�ַΪ0000H
	
	MOV AL,0B6H			;076H=0111 0110,������1���ȵͺ�ߣ���ʽ3����������
	MOV DX,M8254_CON
	OUT DX,AL
	MOV AL,0CH
	MOV DX,M8254_2
	OUT DX,AL
	MOV AL,00H			;000CH=0...0 1100,
	OUT DX,AL
	
	MOV DX,M8251_CON
	MOV AL,00H			;00H=0000 0000,��˫ͬ������У�飬5λ�ַ�����
	OUT DX,AL
	CALL DELAY	;��ʱ
	
	MOV AL,40H			;40H=0100 0000,��˫ͬ������У�飬5λ�ַ�����
	OUT DX,AL
	CALL DELAY
	
	MOV AL,7EH			;7EH=0111 1110,1λ�첽��������ϵ��Ϊ16��żУ�飬�ַ�����Ϊ8λ
	OUT DX,AL
	CALL DELAY
	
	MOV AL,34H			;34H=0011 0100,��˫ͬ����żУ�飬6λ�ַ�����
	OUT DX,AL
	CALL DELAY
	
	MOV DI,4000H
	MOV SI,3000H
	MOV CX,000AH	;ѭ������10
	


A1:
	MOV AL,37H			;37H=0011 0111,�첽�������첽λ��żУ�飬6λ�ַ�����
	MOV DX,M8251_CON
	OUT DX,AL
	
	MOV AL,[SI]	;���SI��ַ������
	MOV DX,M8251_DATA
	OUT DX,AL	;�������ݸ�8251����
	

A2:
	MOV DX,M8251_CON
	IN AL,DX	;��ÿ�����
	AND AL,01H	;�жϷ��ͻ����Ƿ�Ϊ��
	JZ A2
	CALL DELAY	;��ʱ
	
A3:
	MOV DX,M8251_CON
	IN AL,DX	;��ÿ�����
	AND AL,02H	;�ж��Ƿ���յ�����
	JZ A3
	CALL DELAY	;��ʱ
	
	MOV DX,M8251_DATA
	IN AL,DX	;��8251���ڻ������
	MOV [DI],AL	;����������Ŀ���ַ
	INC DI
	INC SI		;Դ��Ŀ���ַ����
	LOOP A1		;ѭ��10��
	
	MOV AH,4CH
	INT 21H	;������ֹ
	
DELAY:	;��ʱ�ӳ���
	PUSH CX
	MOV CX,3000H
A4: 
    PUSH AX
    POP AX
    LOOP A4
    POP CX
    RET
	
	
CODE ENDS
	END START