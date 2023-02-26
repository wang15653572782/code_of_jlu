CODE SEGMENT
	ASSUME CS:CODE
START:  
	MOV AL,80H
	MOV DX,0646H
	OUT DX,AL

	CLI

	MOV AL,1BH          ;ICW1
	MOV DX,0020H
	OUT DX,AL

	MOV AL,08H          ;ICW2
	MOV DX,0021H
	OUT DX,AL

	MOV AL,07H          ;ICW4
	MOV DX,0021H
	OUT DX,AL

	MOV AL,2FH          ;OCW1
	MOV DX,0021H
	OUT DX,AL

	STI
;	MOV AL,00H
;	OUT 20H,AL
;	MOV AL,0CH
;	OUT 20H,AL
	CLI
	MOV AX,0                  ;置中断向量
	MOV ES,AX
	MOV DI,38H
	MOV AX,OFFSET INTOE
	CLD
	STOSW
	MOV AX,SEG INTOE
	STOSW 
	STI

	CLI
	MOV AX,0
	MOV ES,AX
	MOV DI,3CH
	MOV AX,OFFSET INTOF
	CLD
	STOSW
	MOV AX,SEG INTOF
	STOSW
	STI
LL2:    MOV AL,0FFH              ;所有灯亮
	MOV DX,0642H
	OUT DX,AL
	JMP LL2
	MOV AH,4CH
	INT 21H
INTOE PROC
	PUSH AX
	PUSH DX
	MOV AL,0FH
	MOV DX,0642H
	OUT DX,AL
	CALL DELAY
	POP DX
	POP AX
	IRET
INTOE ENDP
INTOF PROC
	PUSH AX
	PUSH DX
	MOV AL,0F0H
	MOV DX,0642H
	OUT DX,AL
	CALL DELAY
	POP DX
	POP AX
	IRET
INTOF ENDP
DELAY PROC
	PUSH CX
	PUSH BX
	MOV CX,0FFH
LL5: MOV BX,0FFFH
LL1:	DEC BX
	JNZ LL1
	LOOP LL5
	POP BX
	POP CX
	RET
DELAY ENDP
	CODE ENDS
END START