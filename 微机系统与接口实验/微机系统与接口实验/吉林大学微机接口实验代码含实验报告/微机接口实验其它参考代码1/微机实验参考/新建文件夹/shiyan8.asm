CODE	SEGMENT
ASSUME CS:CODE
LEDTAB:	DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH	;0--9�Ķ���
START:	MOV AL,80H  	;Ҫ��1
		MOV DX,0606H	;��8255������
		OUT DX,AL		
	
		MOV BX,0       ;LEDTAB����,��ֵΪ0    
		LEA SI,LEDTAB	;LEDTAB��Ч��ַ
	
BBB1:   MOV AH,0DFH  	;λѡ��ֵ�������Ҷ˿�ʼ     	
        CMP BX,9
        JNA BBB10
        MOV BX,0
        
BBB10:  MOV CX,6		;ѭ��һȦ
BBB11:  MOV AL,AH		;��λѡ��A��
		MOV DX,0600H
        OUT DX,AL 		
        MOV AL,[SI+BX]	;�Ͷ��뵽B��
        MOV DX,0602H
        OUT DX,AL		
        CALL DELAY     					             
        ROR AH,1  		;ѭ��һȦ
        LOOP BBB11
        
BBB12:  ADD BX,1
        JMP BBB1
        
DELAY:  PUSH CX
		PUSH AX
        MOV CX,0FFFH
D1:     MOV AX,018H
D2:     DEC AX
		JNZ D2
	    LOOP D1		;�ӳ�����ʾ
	    POP AX       
        POP CX  
RET
      
CODE	ENDS
END	START