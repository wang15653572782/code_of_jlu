;8255��IOY0
;8255��A��λ��ӿڣ�����λ�Ǽ�������
;8255��B�ڶ���ӿ�
;8255��C�ڵ���λ�Ǽ�������

A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H
A8255_CON EQU 0606H

DATA SEGMENT
	NUMB DB 3FH ,06H, 5BH, 4FH, 66H ,6DH, 7DH, 07H, 7FH, 6FH,77H,7CH,39H,5EH,79H,71H;���ּ���ֵ
	KEY:;��˳���ż��������ֵ
		DB  0EEH,0DEH,0BEH,7EH
		DB  0EDH,0DDH,0BDH,7DH
		DB  0EBH,0DBH,0BBH,7BH
		DB  0E7H,0D7H,0B7H,77H
	DISP DB 00H,00H,00H,00H,00H,00H ;�������ܽ�Ҫ��ʾ��ֵ��λ���ɵ͵���(�����������)
DATA ENDS


CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX

	MOV DX,A8255_CON
	MOV AL,89H
	OUT DX,AL  ;89H=1000 1001B������8255�����֣�A�鷽ʽ0��A�������B�鷽ʽ0��B�������C�ڵ���λ����
	CALL CLEAR ;��ʼʱ����ܲ���ʾ 
PRESS1:
	CALL SHOW
	
	MOV DX,A8255_A
	MOV AL,00H
	OUT DX,AL
    
    MOV DX,A8255_C
    IN AL,DX
    
    AND AL,0FH ;��λ���㣬��λ��λ��
    CMP AL,0FH ;����λ��1111�Ƚ�
    JZ PRESS1  ;ȫ��Ϊ1�������ߵ�ƽ��û�м�����
	
    CALL DELAY  ;��ʱ
	
    ;�а�������
    MOV AH,11111110B
    MOV CX,04H ;ɨ��ѭ������
SCAN:
	MOV AL,AH
	MOV DX,A8255_A
	OUT DX,AL
	
	MOV DX,A8255_C
	IN AL,DX ;A�����룬C���������ɨ��
    
    AND AL,0FH
    CMP AL,0FH
    JNZ RES  ;ɨ��ɹ�
    
    ROL AH,1 ;ɨ����һ��
    LOOP SCAN
    JMP PRESS1 ;ɨ��û�ɹ��Ĵ���
	
RES:;��������Ӧ������ֵ
	MOV CL,4
	SHL AH,CL  ;AH�ĸ���λ������������λΪ0
	OR AL,AH  ;��ʱAL�ĸ���λΪ����������λΪ����
	LEA SI,KEY
	MOV BX,0H
FINDKEY:;���Ҽ���
	CMP AL,[SI+BX]
	JZ FINDNUM  ;ȷ����AL��Ӧ���룬���ֵ��BL��
	INC BL
	CMP BL,10H
	JNZ FINDKEY ;С��16������������
	JMP PRESS1 ;����16����û�ҵ�������������ʾ�����°�������
    
FINDNUM:  ;�������֣���ʱ����ƫ������BL����
	MOV BH,0H
	LEA SI,NUMB
	MOV AL,[SI+BX]
	CALL MOVE ;д֮ǰ��DISP�е���ȫ������
	LEA SI,DISP
	MOV [SI+5],AL
	CALL SHOW ;������ʾ

PRESS2:
	MOV DX,A8255_A
	MOV AL,00H
	OUT DX,AL
	
	MOV DX,A8255_C
	IN AL,DX
	AND AL,0FH
	CMP AL,0FH
	JZ PRESS1
	CALL SHOW
	JMP PRESS2

    
SHOW:;�������ʾ�ӳ���
    PUSH AX
    PUSH SI
    PUSH CX
    PUSH DX
    
    MOV AL,11111110B
    LEA SI,DISP
    MOV CX,6
SHOW1:
    MOV DX,A8255_A
    OUT DX,AL;����λ��ѡͨ�����
    PUSH AX
    MOV DX,A8255_B
    MOV AL,[SI]
    OUT DX,AL;�������
	CALL DELAY
	CALL CLEAR
    INC SI
    POP AX
    ROL AL,1
    LOOP SHOW1

    POP DX
    POP CX
    POP SI
    POP AX
    RET
    

MOVE:	;�������ֵ�ƶ��ӳ���
	PUSH CX
	PUSH SI
	PUSH AX
	MOV CX,5
	LEA SI,DISP
M1:
	INC SI
	MOV AL,[SI]
	MOV [SI-1],AL
	LOOP M1
	POP AX
	POP SI
	POP CX
	RET

CLEAR:;�����ʾ������ӳ���
	PUSH AX
	PUSH DX
 
	MOV DX,A8255_A
	MOV AL,0FFH
	OUT DX,AL

	MOV DX,A8255_B
	MOV AL,00H
	OUT DX,AL
 
 POP DX
 POP AX
 RET   

DELAY: ;��ʱ�ӳ���
    PUSH CX
    MOV CX,0FFH
D1:
    LOOP D1
    POP CX
    RET

CODE ENDS
    END START