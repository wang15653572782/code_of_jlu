;8255接IOY0
;8255的A口位码接口，低四位是键盘行线
;8255的B口段码接口
;8255的C口低四位是键盘列线

A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H
A8255_CON EQU 0606H

DATA SEGMENT
	NUMB DB 3FH ,06H, 5BH, 4FH, 66H ,6DH, 7DH, 07H, 7FH, 6FH,77H,7CH,39H,5EH,79H,71H;数字键码值
	KEY:;按顺序存放键码的行列值
		DB  0EEH,0DEH,0BEH,7EH
		DB  0EDH,0DDH,0BDH,7DH
		DB  0EBH,0DBH,0BBH,7BH
		DB  0E7H,0D7H,0B7H,77H
	DISP DB 00H,00H,00H,00H,00H,00H ;存放数码管将要显示的值，位置由低到高(数码管由左到右)
DATA ENDS


CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX

	MOV DX,A8255_CON
	MOV AL,89H
	OUT DX,AL  ;89H=1000 1001B，设置8255控制字，A组方式0，A口输出；B组方式0，B口输出，C口低四位输入
	CALL CLEAR ;开始时数码管不显示 
PRESS1:
	CALL SHOW
	
	MOV DX,A8255_A
	MOV AL,00H
	OUT DX,AL
    
    MOV DX,A8255_C
    IN AL,DX
    
    AND AL,0FH ;高位清零，低位按位与
    CMP AL,0FH ;低四位和1111比较
    JZ PRESS1  ;全部为1：按键高电平，没有键按下
	
    CALL DELAY  ;延时
	
    ;有按键输入
    MOV AH,11111110B
    MOV CX,04H ;扫描循环次数
SCAN:
	MOV AL,AH
	MOV DX,A8255_A
	OUT DX,AL
	
	MOV DX,A8255_C
	IN AL,DX ;A口输入，C口输出进行扫描
    
    AND AL,0FH
    CMP AL,0FH
    JNZ RES  ;扫描成功
    
    ROL AH,1 ;扫描下一列
    LOOP SCAN
    JMP PRESS1 ;扫描没成功的处理
	
RES:;处理键码对应的行列值
	MOV CL,4
	SHL AH,CL  ;AH的高四位是行数，低四位为0
	OR AL,AH  ;此时AL的高四位为行数，低四位为列数
	LEA SI,KEY
	MOV BX,0H
FINDKEY:;查找键码
	CMP AL,[SI+BX]
	JZ FINDNUM  ;确定了AL对应键码，序号值在BL中
	INC BL
	CMP BL,10H
	JNZ FINDKEY ;小于16个，继续查找
	JMP PRESS1 ;大于16个但没找到，放弃本次显示，重新按键输入
    
FINDNUM:  ;查找数字，此时键码偏移量在BL中了
	MOV BH,0H
	LEA SI,NUMB
	MOV AL,[SI+BX]
	CALL MOVE ;写之前将DISP中的数全部左移
	LEA SI,DISP
	MOV [SI+5],AL
	CALL SHOW ;进行显示

PRESS2:
	MOV DX,A8255_A
	MOV AL,00H
	OUT DX,AL
	
	MOV DX,A8255_C
	IN AL,DX
	AND AL,0FH
	CMP AL,0FH
	JZ PRESS1
	CALL SHOW
	JMP PRESS2

    
SHOW:;数码管显示子程序
    PUSH AX
    PUSH SI
    PUSH CX
    PUSH DX
    
    MOV AL,11111110B
    LEA SI,DISP
    MOV CX,6
SHOW1:
    MOV DX,A8255_A
    OUT DX,AL;输入位码选通数码管
    PUSH AX
    MOV DX,A8255_B
    MOV AL,[SI]
    OUT DX,AL;输入段码
	CALL DELAY
	CALL CLEAR
    INC SI
    POP AX
    ROL AL,1
    LOOP SHOW1

    POP DX
    POP CX
    POP SI
    POP AX
    RET
    

MOVE:	;数码管数值移动子程序
	PUSH CX
	PUSH SI
	PUSH AX
	MOV CX,5
	LEA SI,DISP
M1:
	INC SI
	MOV AL,[SI]
	MOV [SI-1],AL
	LOOP M1
	POP AX
	POP SI
	POP CX
	RET

CLEAR:;清除显示数码管子程序
	PUSH AX
	PUSH DX
 
	MOV DX,A8255_A
	MOV AL,0FFH
	OUT DX,AL

	MOV DX,A8255_B
	MOV AL,00H
	OUT DX,AL
 
 POP DX
 POP AX
 RET   

DELAY: ;延时子程序
    PUSH CX
    MOV CX,0FFH
D1:
    LOOP D1
    POP CX
    RET

CODE ENDS
    END START