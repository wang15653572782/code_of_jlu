CODE SEGMENT
	ASSUME CS:CODE
START: 
;	CALL FANGSHI0
	CALL FANGSHI1
;	CALL FANGSHI3
	MOV AH,4CH
	INT 21H
FANGSHI0 PROC
	PUSH AX
	PUSH DX	
	MOV AL,34H
	MOV DX,0606H
	OUT DX,AL	
	MOV AX,1000
	MOV DX,0600H
	OUT DX,AL
	MOV AL,AH
	OUT DX,AL	
 	MOV AL,70H
	MOV DX,0606H
	OUT DX,AL
	MOV AX,5000
	MOV DX,0602H
	OUT DX,AL
	MOV AL,AH
	OUT DX,AL
	POP DX
	POP AX
	RET
FANGSHI0 ENDP
FANGSHI1 PROC	
PUSH AX
	PUSH DX 
 	MOV AL,34H                   ;OƬ
	MOV DX,0606H
	OUT DX,AL
	MOV AX,1000
	MOV DX,0600H
	OUT DX,AL                  ;�Ͱ�λ
	MOV AL,AH
	OUT DX,AL                   ;�߰�λ
	MOV AL,72H             ;1Ƭ
	MOV DX,0606H
	OUT DX,AL
	MOV AX,1000
	MOV DX,0602H
	OUT DX,AL                    ;�Ͱ�λ
	MOV AL,AH
	OUT DX,AL                    ;�߰�λ
	POP DX
	POP AX
	RET
FANGSHI1 ENDP
FANGSHI3 PROC
	PUSH AX
	PUSH DX
 	MOV AL,34H                   ;OƬ
	MOV DX,0606H
	OUT DX,AL
	MOV DX,0600H
	MOV AX,1000
	OUT DX,AL                  ;�Ͱ�λ
	MOV AL,AH
	OUT DX,AL                   ;�߰�λ
	MOV AL,76H                ;1Ƭ
	MOV DX,0606H
	OUT DX,AL
	MOV DX,0602H
	MOV AX,1000
	OUT DX,AL                    ;�Ͱ�λ
	MOV AL,AH
	OUT DX,AL                    ;�߰�λ
	POP DX
	POP AX
	RET
FANGSHI3 ENDP
	CODE ENDS
END START                           ;��ʽ0
