DATA SEGMENT
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:	MOV AX,0000H
		MOV DS,AX	
		;8254通道2 方式3
		MOV AL,0B7H    ;控制字
		MOV DX,06C6H
		OUT DX,AL
		MOV AX,12   ;计数值
		MOV DX,06C4H
		OUT DX,AL
		MOV AL,AH
		OUT DX,AL			
		MOV AL, 00H				
		MOV DX, 0602H
		OUT DX, AL
		CALL DELAY
	
		MOV AL, 40H   
		OUT DX, AL
		CALL DELAY
  		MOV SI,3000H
		MOV DI,4000H	
		MOV CX,000AH	
		MOV AL,7EH   ;方式控制字
		MOV DX,0602H
		OUT DX,AL	
		CALL DELAY
		MOV AL,37H    ;命令字
		MOV DX,0602H
		OUT DX,AL
		CALL DELAY		
L1:		CMP CX,0
		JZ  LL4       ;传送结束，转到LL4
		MOV AL,[SI]
		MOV DX,0600H 
		OUT DX,AL     ;输出
	 	INC SI		
LL1:    
		MOV DX,0602H
		IN  AL,DX     ;读状态字
		AND AL,01H   ;检测发送就绪
	 	JZ  LL1       ;未就绪，循环等待	
LL2: 	
		MOV DX,0602H
		IN  AL,DX     ;读状态字
  		AND AL,02H   ;检测接收就绪
		JZ  LL2      ;未就绪，循环等待
		MOV DX,0600H 
        IN  AL,DX     ;输入
		MOV [DI],AL   
		INC DI
		MOV DX,0602H
		IN  AL,DX     ;读状态字
		AND AL,38H    ;检测有无帧错、溢出错、奇偶错
		JNZ LL3       ;出错，转LL3
		LOOP L1       ;传送下一字符
LL3:	DEC SI
    	DEC DI
		JMP L1			
LL4:	MOV AH,CH
		INT 21H 			
DELAY:	PUSH CX
		MOV CX,3000H
A1:		PUSH AX
		POP AX
		LOOP A1
		POP CX
		RET						
CODE ENDS
END START