DATA SEGMENT

NUMBER DB 3FH,00H,00H,00H,00H,00H

LEDTAB DB  3FH	;0�Ķ���
       DB  06H	;1
       DB  5BH	;2
       DB  4FH	;3
       DB  66H	;4
       DB  6DH	;5
       DB  7DH	;6
       DB  07H	;7
       DB  7FH	;8
       DB  6FH	;9
       DB  77H	;A
       DB  7CH  ;B
       DB  39H	;C
       DB  5EH	;D
       DB  79H	;E
       DB  71H	;F
DATA ENDS
CODE  SEGMENT
      ASSUME CS:CODE,DS:DATA
START:
      MOV AX,DATA
      MOV DS,AX
      
      MOV   AL,81H       ;10000001B
      MOV   DX,0606H
      OUT   DX,AL
      LEA   SI,NUMBER
      LEA   DI,LEDTAB

X1:   CALL  MDISPLAY   	;��ʾ

X7:   MOV   AL,00H
      MOV   DX,0600H
      OUT   DX,AL
      MOV   DX,0604H
      IN    AL,DX       ;��c�ڶ���
      AND   AL,0FH      ;����C�ڸ���λ
      CMP   AL,0FH
      JZ    X1		  ;�޼����£�������ѯ

      MOV   BX,0       ;�к�
      MOV   AH,0FEH	   ;11111110����ɨ��
X2:   MOV   AL,AH
      MOV   DX,0600H 
      OUT   DX,AL
      MOV   DX,0604H
      IN    AL,DX
      AND   AL,0FH
      CMP   AL,0FH
      JNZ   X3		 ;�ҵ�����������,��ʱBX��Ϊ�������к�
      ROL   AH,1	 ;�������ڴ��У�ɨ����һ��
      INC   BX	     ;�кż�һ
      CMP   AH,0EFH   ;11101111
      JNZ   X2		 ;δɨ����4��
      JMP   X7		 ;����ɨ��

X3:   CMP   AL,0EH      ;�����ڵ�0��
      JZ    X4		    
      ADD   BX,4	    
      CMP   AL,0DH      ;�����ڵ�1��
      JZ    X4		    
      ADD   BX,4	    
      CMP   AL,0BH      ;�����ڵ�2��
      JZ    X4		
      ADD   BX,4	    
      CMP   AL,07H      ;�����ڵ�3��
      JZ    X4	    	
      
X4:   MOV   BP,5
X5:   MOV   AL,DS:[SI+BP-1]    ;����������NUMBER�ڴ������°�����С��ַ
      MOV   DS:[SI+BP],AL
      DEC   BP
      JNZ   X5

      MOV   AL,DS:[DI+BX]      ;���°�������С��ַ
      MOV   DS:[SI],AL	       

X6:   CALL  MDISPLAY	       ;��ʾ

      MOV   AL,0               ;��ֹ����ʱ�����
      MOV   DX,0600H
      OUT   DX,AL
      MOV   DX,0604H
      IN    AL,DX
      AND   AL,0FH
      CMP   AL,0FH
      JNZ   X6
      JMP   X7

MDISPLAY  PROC
      PUSH  AX
      PUSH  BX
      PUSH  CX

      MOV   BX,0
      MOV   AH,0DFH            ;1011 1111B   
Z1:   MOV   AL,AH
      MOV   DX,0600H
      OUT   DX,AL 
           
  	  MOV   AL,DS:[SI+BX]	   ;ȡ���Ķ���,BXΪ����ڶ�����ʼ��ַ��ƫ��
      MOV   DX,0602H
      OUT   DX,AL	           ;�Ͷ�ѡ�룬b��
      ROR   AH,1 
      INC   BX
 
      MOV   CX,30H
Z2:
      LOOP  Z2
      MOV   AL,00H
      MOV   DX,0602H 
      OUT   DX,AL            ;��Ӱ
      CMP   AH,07FH          ;  01111111B
      JNZ   Z1

      POP   CX
      POP   BX
      POP   AX
      RET

MDISPLAY  ENDP

DELAY PROC
      PUSH CX
      MOV  CX,0FF8H
LLL:  LOOP LLL
      POP  CX
      RET
DELAY ENDP

CODE  ENDS
	END START                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           