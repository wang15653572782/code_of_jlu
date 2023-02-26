DATA SEGMENT

NUMBER DB 3FH,00H,00H,00H,00H,00H

LEDTAB DB  3FH	;0的段码
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

X1:   CALL  MDISPLAY   	;显示

X7:   MOV   AL,00H
      MOV   DX,0600H
      OUT   DX,AL
      MOV   DX,0604H
      IN    AL,DX       ;从c口读入
      AND   AL,0FH      ;屏蔽C口高四位
      CMP   AL,0FH
      JZ    X1		  ;无键按下，继续查询

      MOV   BX,0       ;列号
      MOV   AH,0FEH	   ;11111110逐列扫描
X2:   MOV   AL,AH
      MOV   DX,0600H 
      OUT   DX,AL
      MOV   DX,0604H
      IN    AL,DX
      AND   AL,0FH
      CMP   AL,0FH
      JNZ   X3		 ;找到按键所在列,此时BX中为按键的列号
      ROL   AH,1	 ;按键不在此列，扫描下一列
      INC   BX	     ;列号加一
      CMP   AH,0EFH   ;11101111
      JNZ   X2		 ;未扫描完4列
      JMP   X7		 ;重新扫描

X3:   CMP   AL,0EH      ;按键在第0行
      JZ    X4		    
      ADD   BX,4	    
      CMP   AL,0DH      ;按键在第1行
      JZ    X4		    
      ADD   BX,4	    
      CMP   AL,0BH      ;按键在第2行
      JZ    X4		
      ADD   BX,4	    
      CMP   AL,07H      ;按键在第3行
      JZ    X4	    	
      
X4:   MOV   BP,5
X5:   MOV   AL,DS:[SI+BP-1]    ;将按键存入NUMBER内存区，新按键在小地址
      MOV   DS:[SI+BP],AL
      DEC   BP
      JNZ   X5

      MOV   AL,DS:[DI+BX]      ;将新按键存入小地址
      MOV   DS:[SI],AL	       

X6:   CALL  MDISPLAY	       ;显示

      MOV   AL,0               ;防止按键时间过长
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
           
  	  MOV   AL,DS:[SI+BX]	   ;取数的段码,BX为相对于段码起始地址的偏移
      MOV   DX,0602H
      OUT   DX,AL	           ;送段选码，b口
      ROR   AH,1 
      INC   BX
 
      MOV   CX,30H
Z2:
      LOOP  Z2
      MOV   AL,00H
      MOV   DX,0602H 
      OUT   DX,AL            ;消影
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