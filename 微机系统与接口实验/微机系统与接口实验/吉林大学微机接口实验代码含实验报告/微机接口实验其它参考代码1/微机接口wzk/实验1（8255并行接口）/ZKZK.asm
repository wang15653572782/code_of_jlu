CODE SEGMENT
	 ASSUME CS:CODE
START:MOV DX,0606H
	  MOV AL,90H
	  OUT DX,AL
L:	  MOV DX,0600H
	  IN AL,DX
	  MOV DX,0602H
	  OUT DX,AL
	  JMP L

CODE ENDS
	 END START



	  
	  