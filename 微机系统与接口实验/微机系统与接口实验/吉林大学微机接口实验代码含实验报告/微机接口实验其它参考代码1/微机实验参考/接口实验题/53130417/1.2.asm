CODE  SEGMENT
      ASSUME  CS:CODE
START:MOV  DX,0646H
      MOV  AL,90H
      OUT  DX,AL
	  
L1:	  MOV DX,0640H
	  IN  AL,DX
	  AND AL,01H
	  CMP AL,00H
	  JE  L2
	  CMP AL,01H
	  JE  L3
	  
L2:   MOV AL,0FH
	  MOV DX,0642H
	  OUT DX,AL  
	  JMP L1
	  
L3:   MOV AL,0F0H
	  MOV DX,0642H
	  OUT DX,AL 
	  JMP L1	  	  
	  
CODE   ENDS
       END START