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

X1:	  CALL  DISPLAY	;显示  

X7:   MOV   AL,00H
      MOV   DX,MY8255_A
      OUT   DX,AL
      MOV   DX,MY8255_C
      IN    AL,DX       ;从c口读入
      AND   AL,0FH      ;屏蔽C口高四位
      CMP   AL,0FH
      JZ    X1		;无键按下，继续查询

      CALL  DELAY	;延时消抖
      CALL  DELAY
      CALL  DELAY
	  LEA   BX,TAG
	  MOV   AL,CS:[BX]
	  INC   AL
	  MOV   CS:[BX],AL
      MOV   BX,0	;BX记录键号
      MOV   AH,0FEH	;1111 1110逐列扫描
X2:   MOV   AL,AH
      MOV   DX,MY8255_A 
      OUT   DX,AL
      MOV   DX,0604H
      IN    AL,DX
      AND   AL,0FH
      CMP   AL,0FH
      JNZ   X3		;找到按键所在列,此时BX中为按键的列号
      ROL   AH,1	;按键不在此列，扫描下一列
      INC   BX		;列号加一
      CMP   AH,0EFH  ;1110 1111
      JNZ   X2		;未扫描完4列
      JMP   X7		;重新扫描

X3:   CMP   AL,0EH      ;第0行按下故低电平
      JZ    X4		    ;按键在第0行
      ADD   BX,4	    ;按键在第1行
      CMP   AL,0DH      ;第1行按下故低电平
      JZ    X4		    ;按键在第1行
      ADD   BX,4	    ;按键在第2行
      CMP   AL,0BH      ;第2行按下故低电平
      JZ    X4		    ;按键在第2行
      ADD   BX,4	    ;按键在第3行
      CMP   AL,07H      ;第3行按下故低电平
      JZ    X4	    	;按键在第3行
      

;------------------------
;向后移动一位
;-----------------------
X4:   MOV   DX,BX
	  LEA   BX,TAG
	  MOV   AL,CS:[BX]
	  CMP   AL,0
	  JZ    XX
	  MOV   BP,7
X5:   MOV   AL,CS:[SI+BP-1];将按键存入NUMBER内存区，新按键在小地址
      MOV   CS:[SI+BP],AL
      DEC   BP
      JNZ   X5

XX:   MOV   BX,DX
      MOV   AL,CS:[DI+BX]
      MOV   CS:[SI],AL	;将新按键存入小地址
;----------------------

X6:   CALL  DISPLAY	;显示

       MOV   AL,0           ;按键时间略长时不视为新数，而显示旧数
       MOV   DX,MY8255_A
       OUT   DX,AL
       MOV   DX,MY8255_C
       IN    AL,DX
       AND   AL,0FH
       CMP   AL,0FH
       JNZ   X6
       JMP   X7

;---------子程序------------
DISPLAY  PROC
      PUSH  AX
      PUSH  BX
      PUSH  CX

      MOV   BX,0
      MOV   AH,0DFH ;1111 0111B   
Z1:   MOV   AL,AH
      MOV   DX,MY8255_A
      OUT   DX,AL 
           
  	  MOV   AL,CS:[SI+BX]	   ;取数的段码
      MOV   DX,0602H
      OUT   DX,AL	   ;送段选码，b口
      ROR   AH,1 
      INC   BX
 
      MOV   CX,30H
Z2:
      LOOP  Z2
      MOV   AL,00H
      MOV   DX,MY8255_B 
      OUT   DX,AL          ;消影
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
LEDTAB:DB  3FH	;0的段码
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