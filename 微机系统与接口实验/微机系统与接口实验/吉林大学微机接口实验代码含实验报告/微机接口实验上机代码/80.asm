;8255�ӿڳ�ʼ������CS���ӵ�IOY�˿ھ�����
A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H
A8255_CON EQU 0606H

;����ܵ����ݱ��ֱ��ʾ0-9
DATA SEGMENT
	NUMTAB DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX  ;ָ������ʼ��ַ
    
	LEA SI,NUMTAB;Դ��ַ�Ĵ���
	MOV DX,A8255_CON
	MOV AL,81H  ;81H=1 00 0 0 0 0 1B��A�鷽ʽ0��A�������C�ڸ���λ�����B�鷽ʽ0��B�������C�ڵ���λ����
	OUT DX,AL
    
	MOV CX,0AH		;����ѭ��10��
	MOV BX,0000H	;λ��ƫ����
    
DISP: 
	PUSH CX
	MOV CX,06H		;�����ѭ��6��
	MOV AL,11011111B
DISP1:
	MOV DX,A8255_A
	OUT DX,AL		;λ�����
	ROR AL,1		;ѭ������һλ����������һλ
	PUSH AX
	
	MOV AL,[SI+BX]	;����BX���ַ��������AL
	MOV DX,A8255_B
	OUT DX,AL		;����ַ�
	
	POP AX
	CALL DELAY
	LOOP DISP1
	
	POP CX
	INC BX			;λ��ƫ������һ
	LOOP DISP
    
	JMP START
    
    
DELAY:
	PUSH CX
	MOV CX,0FFFFH
D1:
	LOOP D1

	MOV CX,0FFFH
	
D2:
	LOOP D2
	
	POP CX
	RET

CODE ENDS
     END START