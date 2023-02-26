CODE  SEGMENT
      ASSUME  CS:CODE
START:MOV  DX,0646H
      MOV  AL,90H
      OUT  DX,AL
	  
L1:	  MOV DX,0640H
	  IN  AL,DX
	  
	  MOV DX,0642H
	  OUT DX,AL
	  
	  JMP L1
	  
CODE   ENDS
       END START