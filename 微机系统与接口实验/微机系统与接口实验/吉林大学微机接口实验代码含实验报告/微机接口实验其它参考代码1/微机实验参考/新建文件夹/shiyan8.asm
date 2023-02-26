CODE	SEGMENT
ASSUME CS:CODE
LEDTAB:	DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH	;0--9的段码
START:	MOV AL,80H  	;要求1
		MOV DX,0606H	;送8255控制字
		OUT DX,AL		
	
		MOV BX,0       ;LEDTAB索引,初值为0    
		LEA SI,LEDTAB	;LEDTAB有效地址
	
BBB1:   MOV AH,0DFH  	;位选初值，从最右端开始     	
        CMP BX,9
        JNA BBB10
        MOV BX,0
        
BBB10:  MOV CX,6		;循回一圈
BBB11:  MOV AL,AH		;送位选到A口
		MOV DX,0600H
        OUT DX,AL 		
        MOV AL,[SI+BX]	;送段码到B口
        MOV DX,0602H
        OUT DX,AL		
        CALL DELAY     					             
        ROR AH,1  		;循回一圈
        LOOP BBB11
        
BBB12:  ADD BX,1
        JMP BBB1
        
DELAY:  PUSH CX
		PUSH AX
        MOV CX,0FFFH
D1:     MOV AX,018H
D2:     DEC AX
		JNZ D2
	    LOOP D1		;延迟以显示
	    POP AX       
        POP CX  
RET
      
CODE	ENDS
END	START