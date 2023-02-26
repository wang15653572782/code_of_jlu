CODE SEGMENT 
    ASSUME CS:CODE
START: 
    MOV AX, 0000H
    MOV DS, AX
 
    MOV DX, 0646H
    MOV AL, 90H
    OUT DX, AL
    MOV DX, 0642H
    MOV AL,80H
    OUT DX,AL
    ;将D7点，D6-D0熄灭
    MOV AX, OFFSET MIR6
    MOV SI, 0038H
    MOV [SI], AX
    MOV AX, CS
    MOV SI, 003AH
    MOV [SI], AX
 
    MOV AX, OFFSET MIR7
    MOV SI, 003CH
    MOV [SI], AX
    MOV AX, CS
    MOV SI, 003EH
    MOV [SI], AX
 
    CLI
    MOV AL, 11H
    OUT 20H, AL
    MOV AL, 08H
    OUT 21H, AL
    MOV AL, 04H
    OUT 21H, AL
    MOV AL, 01H
    OUT 21H, AL
    MOV AL, 3FH
    OUT 21H, AL
    STI
    ;与主实验相同部分此处不再赘述
    ;下面的AA1与AA2相当于两个主程序，控制灯的右移和左移
AA0:MOV DX, 0642H
    MOV AL, 80H
    OUT DX, AL
    JMP AA0
AA1: 
    MOV DX, 0642H
    IN AL,DX
    ;读入当前灯的状态
    CMP AL,01H
    JE AA1
    ;判断灯是否是最右侧亮，如果是则不变，不是则继续移动
    ROR AL,1
    ;将AL循环右移1位
    MOV CX,0FFFFH
L1:
    LOOP L1
    MOV CX,0FFFFH
L2:
    LOOP L2
    MOV CX,0FFFFH
L3:
    LOOP L3
    MOV CX,0FFFFH
L4:
    LOOP L4
    ;延时
    OUT DX,AL
    ;从8255B口输出右移后的灯的状态
    JMP AA1
 
AA2: 
    MOV DX, 0642H
    IN AL,DX
    CMP AL,80H
    JE AA2
    ;判断灯是否是最左侧亮，如果是则不变，不是则继续移动
    ROL AL,1
    ;将AL循环左移1位
    MOV CX,0FFFFH
L5:
    LOOP L5
    MOV CX,0FFFFH
L6:
    LOOP L6
    MOV CX,0FFFFH
L7:
    LOOP L7
    MOV CX,0FFFFH
L8:
    LOOP L8
    ;延时
    OUT DX,AL
    ;从8255B口输出右移后的灯的状态
    JMP AA2
 
MIR6:
    STI
    MOV AL,20H
    OUT 20H,AL
    JMP AA1
    ;按下KK1+，灯右移，跳转到AA1
    IRET
 
MIR7:  
    STI
    MOV AL,20H
    OUT 20H,AL
    JMP AA2
    ;按下KK2+，灯左移，跳转到AA2
    IRET
 
CODE ENDS
    END START