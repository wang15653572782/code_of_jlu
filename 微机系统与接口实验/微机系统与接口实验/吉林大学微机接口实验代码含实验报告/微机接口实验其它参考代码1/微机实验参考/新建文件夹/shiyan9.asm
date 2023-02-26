MY8255_A    EQU 0600H
MY8255_B    EQU 0602H
MY8255_C    EQU 0604H
MY8255_CON  EQU 0606H
CODE  SEGMENT
      ASSUME CS:CODE
START:
      MOV   AL,81H   ;10000001B
      MOV   DX,MY8255_CON
      OUT   DX,AL
      LEA   SI,NUMBER
      LEA   DI,LEDTAB

X1:	  CALL  DISPLAY	;��ʾ  

X7:   MOV   AL,00H
      MOV   DX,MY8255_A
      OUT   DX,AL
      MOV   DX,MY8255_C
      IN    AL,DX       ;��c�ڶ���
      AND   AL,0FH      ;����C�ڸ���λ
      CMP   AL,0FH
      JZ    X1		;�޼����£�������ѯ

      CALL  DELAY	;��ʱ����
      CALL  DELAY
      CALL  DELAY
	  LEA   BX,TAG
	  MOV   AL,CS:[BX]
	  INC   AL
	  MOV   CS:[BX],AL
      MOV   BX,0	;BX��¼����
      MOV   AH,0FEH	;1111 1110����ɨ��
X2:   MOV   AL,AH
      MOV   DX,MY8255_A 
      OUT   DX,AL
      MOV   DX,0604H
      IN    AL,DX
      AND   AL,0FH
      CMP   AL,0FH
      JNZ   X3		;�ҵ�����������,��ʱBX��Ϊ�������к�
      ROL   AH,1	;�������ڴ��У�ɨ����һ��
      INC   BX		;�кż�һ
      CMP   AH,0EFH  ;1110 1111
      JNZ   X2		;δɨ����4��
      JMP   X7		;����ɨ��

X3:   CMP   AL,0EH      ;��0�а��¹ʵ͵�ƽ
      JZ    X4		    ;�����ڵ�0��
      ADD   BX,4	    ;�����ڵ�1��
      CMP   AL,0DH      ;��1�а��¹ʵ͵�ƽ
      JZ    X4		    ;�����ڵ�1��
      ADD   BX,4	    ;�����ڵ�2��
      CMP   AL,0BH      ;��2�а��¹ʵ͵�ƽ
      JZ    X4		    ;�����ڵ�2��
      ADD   BX,4	    ;�����ڵ�3��
      CMP   AL,07H      ;��3�а��¹ʵ͵�ƽ
      JZ    X4	    	;�����ڵ�3��
      

;------------------------
;����ƶ�һλ
;-----------------------
X4:   MOV   DX,BX
	  LEA   BX,TAG
	  MOV   AL,CS:[BX]
	  CMP   AL,0
	  JZ    XX
	  MOV   BP,7
X5:   MOV   AL,CS:[SI+BP-1];����������NUMBER�ڴ������°�����С��ַ
      MOV   CS:[SI+BP],AL
      DEC   BP
      JNZ   X5

XX:   MOV   BX,DX
      MOV   AL,CS:[DI+BX]
      MOV   CS:[SI],AL	;���°�������С��ַ
;----------------------

X6:   CALL  DISPLAY	;��ʾ

       MOV   AL,0           ;����ʱ���Գ�ʱ����Ϊ����������ʾ����
       MOV   DX,MY8255_A
       OUT   DX,AL
       MOV   DX,MY8255_C
       IN    AL,DX
       AND   AL,0FH
       CMP   AL,0FH
       JNZ   X6
       JMP   X7

;---------�ӳ���------------
DISPLAY  PROC
      PUSH  AX
      PUSH  BX
      PUSH  CX

      MOV   BX,0
      MOV   AH,0DFH ;1111 0111B   
Z1:   MOV   AL,AH
      MOV   DX,MY8255_A
      OUT   DX,AL 
           
  	  MOV   AL,CS:[SI+BX]	   ;ȡ���Ķ���
      MOV   DX,0602H
      OUT   DX,AL	   ;�Ͷ�ѡ�룬b��
      ROR   AH,1 
      INC   BX
 
      MOV   CX,30H
Z2:
      LOOP  Z2
      MOV   AL,00H
      MOV   DX,MY8255_B 
      OUT   DX,AL          ;��Ӱ
      CMP   AH,07FH         ;  01111111B
      JNZ   Z1
      ;MOV   CL,6
      ;ROL   AH,CL

      POP   CX
      POP   BX
      POP   AX
      RET

DISPLAY  ENDP

DELAY PROC
      PUSH CX
      MOV  CX,0FF8H
      LOOP $
      POP  CX
      RET
DELAY ENDP

NUMBER DB  3FH,00H,00H,00H,00H,00H,00H,00H;8 DUP (0)
TAG    DB  0FFH
LEDTAB:DB  3FH	;0�Ķ���
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

CODE  ENDS
	END START                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           