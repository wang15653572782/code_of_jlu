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
    ;��D7�㣬D6-D0Ϩ��
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
    ;����ʵ����ͬ���ִ˴�����׸��
    ;�����AA1��AA2�൱�����������򣬿��ƵƵ����ƺ�����
AA0:MOV DX, 0642H
    MOV AL, 80H
    OUT DX, AL
    JMP AA0
AA1: 
    MOV DX, 0642H
    IN AL,DX
    ;���뵱ǰ�Ƶ�״̬
    CMP AL,01H
    JE AA1
    ;�жϵ��Ƿ������Ҳ�����������򲻱䣬����������ƶ�
    ROR AL,1
    ;��ALѭ������1λ
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
    ;��ʱ
    OUT DX,AL
    ;��8255B��������ƺ�ĵƵ�״̬
    JMP AA1
 
AA2: 
    MOV DX, 0642H
    IN AL,DX
    CMP AL,80H
    JE AA2
    ;�жϵ��Ƿ������������������򲻱䣬����������ƶ�
    ROL AL,1
    ;��ALѭ������1λ
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
    ;��ʱ
    OUT DX,AL
    ;��8255B��������ƺ�ĵƵ�״̬
    JMP AA2
 
MIR6:
    STI
    MOV AL,20H
    OUT 20H,AL
    JMP AA1
    ;����KK1+�������ƣ���ת��AA1
    IRET
 
MIR7:  
    STI
    MOV AL,20H
    OUT 20H,AL
    JMP AA2
    ;����KK2+�������ƣ���ת��AA2
    IRET
 
CODE ENDS
    END START