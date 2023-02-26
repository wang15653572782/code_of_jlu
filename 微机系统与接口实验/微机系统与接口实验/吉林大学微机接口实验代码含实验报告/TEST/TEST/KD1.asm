;8255的A口低四位是作为行扫描的接口，同时也是数码管的位选线
;8255的C口低四位是作为列输入的
;8255接IOY0
DATA SEGMENT
    LIST DB 3FH ,06H, 5BH, 4FH, 66H ,6DH, 7DH, 07H, 7FH, 6FH,77H,7CH,39H,5EH,79H,71H
    TABLE :
    	DB  0EEH,0DEH,0BEH,7EH
        DB  0EDH,0DDH,0BDH,7DH
        DB  0EBH,0DBH,0BBH,7BH
        DB  0E7H,0D7H,0B7H,77H     
      
    SHUMA DB 00H,00H,00H,00H,00H,00H;用于存放数码管将要显示的值     
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX
    MOV DX,0606H
    MOV AL,89H
    OUT DX,AL;设置8255控制字，使得A,B口和C口第四位进行输入
    MOV DX,0600H
    MOV AL,00H
    OUT DX,AL
    MOV DX,0602H
    MOV AL,00H
    OUT DX,AL;开始时数码管不显示 
L1: 
    CALL SHOW
    MOV DX,0600H
    MOV AL,00H
    OUT DX,AL
    MOV DX,0604H
    IN AL,DX
    AND AL,0FH
    CMP AL,0FH
    JZ L1;按键全部为高电平，没有键按下
    CALL DELAY;消除前沿抖动
    MOV DX,0600H
    MOV AL,00H
    OUT DX,AL
    MOV DX,0604H
    IN AL,DX
    AND AL,0FH
    CMP AL,0FH
    JZ L1;消抖前的按键是由于干扰
    ;到此说明有按键输入
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
    JNZ L2;L2是行扫描成功，确定了行数
    ROL AH,1
    LOOP L3
    JMP L1;行扫描没成功的处理------------------------------
L2:
    MOV CL,4
    SHL AH,CL;AH的高四位是行数
    OR AL,AH;此时AL的高四位为行数，低四位为列数
    LEA SI,TABLE
    MOV BL,00H 
    MOV BH,00H
L5: CMP AL,[SI+BX]
    JZ L4;确定了AL代表的是哪个键码，值在BL中，进行数码管显示
    INC BL
    CMP BL,10H
    JNZ L5;键码已经小于16个
    JMP L1;键码值已经大于16个了，但还是没找到，放弃本次显示，重新按键输入
    
L4:;此时键码的偏移量已经在BL中了
    MOV BH,00H
    LEA  SI,LIST
    MOV AL,[SI+BX]
    CALL FMOVE;准备写之前将SHUMA里的数前移
    LEA SI,SHUMA
    MOV [SI+5],AL
    CALL SHOW;进行显示

L8:    
	MOV DX,0600H
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
    
SHOW: 
    PUSH AX
    PUSH SI
    PUSH CX
    PUSH DX
    MOV AL,11011111B
 
    LEA SI,SHUMA
    ADD SI,5;从最后一位开始读
    MOV CX,6
L7:    
    MOV DX,0600H
    OUT DX,AL;选通数码管6，显示最新的数
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
    PUSH CX                  ;延时子程序
    MOV CX,00FFH
L9:    
    LOOP L9
    POP CX
    RET





FMOVE: 
    PUSH CX
    PUSH SI
    PUSH AX
    MOV CX,5
    LEA SI,SHUMA
L6: INC SI
    MOV AL,[SI]
    MOV [SI-1],AL
    LOOP L6
    POP AX
    POP SI
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