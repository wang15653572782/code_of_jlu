CON8254 EQU  0646H ;TIMER CONTROL  IOY1
A8254 EQU    0640H ;TIMER 0
B8254 EQU    0642H ;TIMER 1

DATA SEGMENT
TAB  DB  3FH;0
	 DB	 06H;1
	 DB  5BH;2
	 DB  4FH;3
	 DB  66H;4
	 DB  6DH;5
	 DB  7DH;6
	 DB  07H;7
	 DB  7FH;8
	 DB  6FH;9
	 DB  77H;A
	 DB  7CH;B
	 DB  39H;C
	 DB  5EH;D
	 DB  79H;E
	 DB  71H;F
	 DB  80H;.
	 DB  00H;熄灭
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:  MOV AX,DATA
		MOV DS,AX
		
		MOV AL,81H;8255初始化
		MOV DX,0606H
		OUT DX,AL
		
    	CALL INIT8254 ;
        CALL INIT8259;
    
		LEA SI,TAB;取断码表首地址
        MOV BX,0;
X2:		MOV AH,0c0H;位选码
		
X1:		MOV AL,[SI+1];送段码
		MOV DX,0602H
		OUT DX,AL
		CALL DELAY1
		
		MOV AL,AH;送位选码
		MOV DX,0600H
		OUT DX,AL
		CMP BX,0
		JZ L0
		CMP BX,1
		JZ L1
		CMP BX,2
		JZ L2
		CMP BX,3
		JZ L3
		CMP BX,4
		JZ L4
		CMP BX,5
		JZ L5
		CMP BX,6
		JZ L6
		L0:
		   MOV AH,0C0H
		   JMP FIN
		L1:
		   MOV AH,0E0H
		   JMP FIN
		L2:
		   MOV AH,0F0H
		   JMP FIN
		L3:
		   MOV AH,0F8H
		   JMP FIN
		L4:
		   MOV AH,0FCH
		   JMP FIN
		L5:
		   MOV AH,0FEH
		   JMP FIN
		L6:
		   MOV AH,0FFH
		   JMP FIN  
		    
		FIN:JMP X1
			
		
		
		
		
		
		MOV AH,4CH
		INT 21H
		


		

INT6 proc FAR
	INC BX;
	IRET
INT6 ENDP


		
DELAY1 PROC
		 PUSH CX
		 PUSH AX
		 
         MOV CX,01FFH
D11:     MOV AX,08FH
D12:     DEC AX
         CMP AX,0
         JNZ D12    
         LOOP D11
         
         POP AX 
         POP CX
         RET
DELAY1 ENDP	


DELAY2 PROC
		 PUSH CX
         MOV CX,01FFH
D21:     LOOP D21   
         POP CX
         RET
DELAY2 ENDP	
	
INIT8259 PROC ;-------< 8259 INIT 中断向量设置 >------
	CLI				
	PUSH AX
	PUSH DI
	MOV AL,13H ;ICW1
	OUT 20h,AL
	MOV AL,0EH ;ICW2
	OUT 21H,AL
	MOV AL,03H ;ICW4
	OUT 21H,AL
	MOV AX,0
	MOV ES,AX
	MOV DI,38H
	MOV AX,OFFSET INT6
	CLD
	STOSW
	MOV AX,SEG INT6
	STOSW
	POP DI
	POP AX
	STI
	RET
INIT8259 ENDP ;	






INIT8254 PROC ;-------< 8254 INIT >------
	PUSH AX
	PUSH DX
    MOV AL,36H;37  ;INIT TIMER ZERO
	MOV DX,CON8254;
	OUT DX,AL;
	MOV AX,1000
	MOV DX,A8254;
	OUT DX,AL;
	MOV AL,AH;
	OUT DX,AL;

	MOV AL,76H;77 ;INTI TIMER ONE
	MOV DX,CON8254;
	OUT DX,AL;
	MOV AX,1000 ;1000
	MOV DX,B8254;
	OUT DX,AL;
	MOV AL,AH;
	OUT DX,AL;
	POP DX
	POP AX
	RET ;---------< TIMER INIT OVER />-------------

INIT8254 ENDP ;-------< 8254 INIT />------	
		
CODE ENDS
END START