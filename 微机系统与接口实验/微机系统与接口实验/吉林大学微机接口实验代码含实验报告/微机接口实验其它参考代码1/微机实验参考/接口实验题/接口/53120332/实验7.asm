DATA SEGMENT
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:	MOV AX,0000H
		MOV DS,AX	
		;8254ͨ��2 ��ʽ3
		MOV AL,0B7H    ;������
		MOV DX,06C6H
		OUT DX,AL
		MOV AX,12   ;����ֵ
		MOV DX,06C4H
		OUT DX,AL
		MOV AL,AH
		OUT DX,AL			
		MOV AL, 00H				
		MOV DX, 0602H
		OUT DX, AL
		CALL DELAY
	
		MOV AL, 40H   
		OUT DX, AL
		CALL DELAY
  		MOV SI,3000H
		MOV DI,4000H	
		MOV CX,000AH	
		MOV AL,7EH   ;��ʽ������
		MOV DX,0602H
		OUT DX,AL	
		CALL DELAY
		MOV AL,37H    ;������
		MOV DX,0602H
		OUT DX,AL
		CALL DELAY		
L1:		CMP CX,0
		JZ  LL4       ;���ͽ�����ת��LL4
		MOV AL,[SI]
		MOV DX,0600H 
		OUT DX,AL     ;���
	 	INC SI		
LL1:    
		MOV DX,0602H
		IN  AL,DX     ;��״̬��
		AND AL,01H   ;��ⷢ�;���
	 	JZ  LL1       ;δ������ѭ���ȴ�	
LL2: 	
		MOV DX,0602H
		IN  AL,DX     ;��״̬��
  		AND AL,02H   ;�����վ���
		JZ  LL2      ;δ������ѭ���ȴ�
		MOV DX,0600H 
        IN  AL,DX     ;����
		MOV [DI],AL   
		INC DI
		MOV DX,0602H
		IN  AL,DX     ;��״̬��
		AND AL,38H    ;�������֡���������ż��
		JNZ LL3       ;����תLL3
		LOOP L1       ;������һ�ַ�
LL3:	DEC SI
    	DEC DI
		JMP L1			
LL4:	MOV AH,CH
		INT 21H 			
DELAY:	PUSH CX
		MOV CX,3000H
A1:		PUSH AX
		POP AX
		LOOP A1
		POP CX
		RET						
CODE ENDS
END START