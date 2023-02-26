CODE	SEGMENT
ASSUME CS:CODE
LEDTAB:	DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH	;0-9的段码
TAB:    DB 1,2,0,7,1,4
XUN:    DB 0
HUAN:   DB 100
START:	MOV AL,80H			;要求2
	    MOV DX,0606H
	    OUT DX,AL			;送8255控制字
	    LEA DI,TAB 
	    LEA SI,LEDTAB
     	     	
BBB09:	MOV CX,6		
		MOV AH,0FEH	
BBB10:  LEA BX,XUN
		MOV BL,CS:[BX]
		MOV BH,0
		MOV BL,CS:[DI+BX]	        ;从1开始显示
       	MOV BH,0
BBB11:  MOV AL,AH      
	    MOV DX,0600H
        OUT DX,AL      
        MOV AL,CS:[SI+BX]
        MOV DX,0602H
        OUT DX,AL      
        CALL DELAY                     
        ROL AH,1 
        PUSH   AX 
        LEA BX,XUN
		MOV BL,CS:[BX]
		MOV BH,0		    
        ADD BX,1
        MOV AX,BX
        MOV BL,6
        DIV BL
        LEA BX,XUN
        MOV CS:[BX],AH       
        POP AX
        LOOP BBB10 		
  		LEA BX,HUAN
  		MOV CL,CS:[BX]
  		DEC CL
  		MOV CS:[BX],CL
  		JNZ BBB09
  		
  		LEA BX,HUAN
  		MOV CS:[BX],100
        PUSH   AX 
        LEA BX,XUN
		MOV BL,CS:[BX]
		MOV BH,0		    
        ADD BX,1
        MOV AX,BX
        MOV BL,6
        DIV BL
        LEA BX,XUN
        MOV CS:[BX],AH       
        POP AX
        JMP BBB09
        
DELAY:  PUSH CX
        MOV CX,02FFH
Y:      LOOP Y
        XOR CX,CX
        POP CX 
        RET
              
		MOV AH,4CH
		INT 21H
CODE	ENDS
END	START
