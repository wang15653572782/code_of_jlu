 CODE SEGMENT
	ASSUME CS:CODE
START:

MOV AL,96H			;��ʽ3����ʼ��8254
MOV DX,06C6H
OUT DX,AL
MOV AL,12
MOV DX,06C4H
OUT DX,AL

MOV DX,0602H		;���ƿڣ���ʼ��8251
MOV AL,7EH			;8251A��ʽѡ�������
OUT DX,AL
MOV AL,35H			;8251A���������
OUT DX,AL

MOV	CX,26
MOV	SI,3000H
MOV	AL,'a'
P1:
MOV	[SI],AL
INC	SI
INC	AL
LOOP P1

MOV DI, 4000H		;Ŀ���ַ4000H
MOV SI, 3000H		;Դ��ַ  3000H

MOV CX,26			;����10���ֽ�
X1:MOV DX,0602H
IN AL,DX			;��״̬�֣�
AND AL,01H			;�ж�TXRDYλ���ж���һ�������Ƿ�����ɣ�δ�����ȴ�
JZ X1
MOV DX,0600H		;���ݿڵ�ַ
MOV AL,[SI]			;��ȡһ������
OUT DX,AL			;���
Y1:MOV DX,0602H
IN AL,DX
AND AL,02H			;�ж�RXRDY�Ƿ�Ϊ1���������ַ��Ƿ����
JZ Y1
MOV DX,0600H
IN AL,DX			;�������ȡ
MOV [DI],AL			;��ȡ֮��д��
INC SI
INC DI
LOOP X1
  
MOV AH,4CH
INT 21H
     
CODE ENDS
   END START    
