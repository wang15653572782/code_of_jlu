CODE  SEGMENT
      ASSUME  CS:CODE
START:MOV  DX,0646H
      MOV  AL,90H
      OUT  DX,AL
	  
L1:	  MOV DX,0640H
	  IN  AL,DX
	  CMP AL,0FFH
	  JE  L2
	  
	  MOV DX,0642H
	  OUT DX,AL
	  
	  JMP L1
	  
L2:	  MOV DX,0642H
	  MOV AL,00H
	  OUT DX,AL
	  HLT
	  
CODE   ENDS
       END START