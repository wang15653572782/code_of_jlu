;8255��A�ڵ���λ����Ϊ��ɨ��Ľӿڣ�ͬʱҲ������ܵ�λѡ��
;8255��C�ڵ���λ����Ϊ�������
;8255��IOY0
DATA SEGMENT
    LIST DB 3FH ,06H, 5BH, 4FH, 66H ,6DH, 7DH, 07H, 7FH, 6FH,77H,7CH,39H,5EH,79H,71H
    TABLE1 :
    	DB  0EEH,0DEH,0BEH,7EH
        DB  0EDH,0DDH,0BDH,7DH
        DB  0EBH,0DBH,0BBH,7BH
        DB  0E7H,0D7H,0B7H,77H     
      
    SHUMA DB 00H,00H,00H,00H,00H,00H;���ڴ������ܽ�Ҫ��ʾ��ֵ     
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX
    MOV DX,0606H
    MOV AL,89H
    OUT DX,AL;����8255�����֣�ʹ��A,B�ں�C�ڵ���λ��������
    MOV DX,0600H
    MOV AL,00H
    OUT DX,AL
    MOV DX,0602H
    MOV AL,00H
    OUT DX,AL;��ʼʱ����ܲ���ʾ 
    mov cx,0
    push cx
L1:
    CALL SHOW
    MOV DX,0600H
    MOV AL,00H
    OUT DX,AL
    MOV DX,0604H
    IN AL,DX
    AND AL,0FH
    CMP AL,0FH
    JZ L1;����ȫ��Ϊ�ߵ�ƽ��û�м�����
    CALL DELAY;����ǰ�ض���
    MOV DX,0600H
    MOV AL,00H
    OUT DX,AL
    MOV DX,0604H
    IN AL,DX
    AND AL,0FH
    CMP AL,0FH
    JZ L1;����ǰ�İ��������ڸ���
    ;����˵���а�������
    MOV AH,11111110B
    MOV DX,0600H
    MOV CX,04H
L3: 
    MOV AL,AH
    MOV DX,0600H
    OUT DX,AL
    MOV DX,0604H
    IN AL,DX
    AND AL,0FH
    CMP AL,0FH
    JNZ L2;L2����ɨ��ɹ���ȷ��������
    ROL AH,1
    LOOP L3
    JMP L1;��ɨ��û�ɹ��Ĵ���------------------------------
L2:
    MOV CL,4
    SHL AH,CL;AH�ĸ���λ������
    OR AL,AH;��ʱAL�ĸ���λΪ����������λΪ����
    LEA SI,TABLE1
    MOV BL,00H 
    MOV BH,00H
L5: CMP AL,[SI+BX]
    JZ L4;ȷ����AL��������ĸ����룬ֵ��BL�У������������ʾ
    INC BL
    CMP BL,10H
    JNZ L5;�����Ѿ�С��16��
    JMP L1;����ֵ�Ѿ�����16���ˣ�������û�ҵ�������������ʾ�����°�������
    
L4:;��BL��
    CMP BL,0FH
    JZ  L19    ;f��������
    MOV BH,00H
    LEA  SI,LIST
    MOV AL,[SI+BX]
    pop cx    
    inc cx
    cmp cx,13
    jnz L13
    sub cx,6
L13:push cx
    cmp cx,6
    ja L11 ;����6ʱѭ������
    LEA SI,SHUMA
    cmp cx,1
    jz  L111
    sub si,cx
    MOV [SI+7],00h    
L111:LEA SI,SHUMA
     sub si,cx
     mov [si+6],al
     CALL SHOW
     jmp L8      


L11:  
    LEA SI,SHUMA
    add si,cx
    mov [si-7],al
    call show
    
    
L8: MOV DX,0600H
    MOV AL,00H
    OUT DX,AL
    MOV DX,0604H
    IN AL,DX
    AND AL,0FH
    CMP AL,0FH
    JE BACK
    CALL SHOW
    JMP L8
BACK:  
	JMP L1 
	
L19:MOV AH,4CH
    INT 21H	    

SHOW: 
    PUSH AX
    PUSH SI
    PUSH CX
    PUSH DX
    MOV AL,11011111B
 
    LEA SI,SHUMA
    ADD SI,5;�����һλ��ʼ��
    MOV CX,6
L7:    
    MOV DX,0600H
    OUT DX,AL;ѡͨ�����6����ʾ���µ���
    PUSH AX
    MOV DX,0602H
    MOV AL,[SI]
    OUT DX,AL
	CALL DELAY
	CALL CLEAR
    DEC SI
    POP AX
    ROR AL,1
    LOOP L7 
    POP DX
    POP CX
    POP SI
    POP AX
    RET
    



DELAY:
    PUSH CX                  ;��ʱ�ӳ���
    MOV CX,00FFH
L9:    
    LOOP L9
    POP CX
    RET


CLEAR:
	PUSH AX
	PUSH DX
	MOV DX,0600H
	MOV AL,0FFH
	OUT DX,AL
	MOV DX,0602H
	MOV AL,00H
	OUT DX,AL
	POP DX
	POP AX
	RET   


CODE ENDS
    END START
    