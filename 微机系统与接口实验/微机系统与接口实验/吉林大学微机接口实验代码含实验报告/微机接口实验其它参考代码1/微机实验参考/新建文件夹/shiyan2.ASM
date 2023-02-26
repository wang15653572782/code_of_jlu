CODE SEGMENT
	ASSUME CS:CODE
START:
		MOV AX,8000H
		MOV DS,AX
 	    MOV CX,16
 	    MOV BX,0
 	    MOV AX,0
 	  X:MOV [BX],AX
 	  	INC AX
 	  	ADD BX,2
 	  	LOOP X
 	  	HLT
CODE    ENDS
      END START