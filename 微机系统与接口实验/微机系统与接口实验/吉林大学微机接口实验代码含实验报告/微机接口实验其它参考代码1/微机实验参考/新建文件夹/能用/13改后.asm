assume cs:code, ds:data
data segment
	p_8255_a		equ	0600h
	p_8255_b		equ	0602h
	p_8255_c		equ	0604h
	p_8255_con		equ	0606h
	p_8254_0		equ	0640h
	p_8254_1		equ	0642h
	p_8254_2		equ	0644h
	p_8254_con		equ	0646h
	
	led_table	db  03fh,006h,05bh,04fh,066h,06dh,07dh,007h,07fh,06fh    ;0~9
				db 	077h,07ch,039h,05eh,079h,071h         ;a~f
				db 	00h, 80h                              ;16黑 、 17点


	key_table 	db	11101110b, 11011110b, 10111110b, 01111110b
				db	11101101b, 11011101b, 10111101b, 01111101b
				db	11101011b, 11011011b, 10111011b, 01111011b
				db	11100111b, 11010111b, 10110111b, 01110111b
				
	show_pos	db 11111110b  ;第一列起始

	buffer		db 10h,10h,10h,10h,10h,10h

	;even

	total_count	dw	?

	state			db		00h   
	init_state		equ 	00h       ;初始
	running_state	equ		01h       ;运行
	pause_state		equ		02h       ;暂停
	blink_state		equ		03h     ;结束
	exit_state		equ		04h      ;退出
	a_state         equ     05h    
			
data ends

code segment
start: 

	push ds
	mov ax, 0000h
	mov ds, ax
	
	mov ax, offset mir6
	mov si, 0038h
	mov [si], ax
	mov ax, cs
	mov si, 003ah
	mov [si], ax
	pop ds
		
	;初始化8259
	cli
	mov al, 00010001b;11h		;icw1
	out 20h, al       
	
	mov al, 00001000b;08h		;icw2
	out 21h, al        
	
	mov al, 00001100b;0ch		;icw3
	out 21h, al        
	
	mov al, 00000111b;07h		;icw4
	out 21h, al        
	
	mov al, 11101111b;0efh     	;ocw1
	out 21h, al
	sti						;开中断
		
	mov	ax, data
	mov	ds, ax
	
	lea	si, led_table      
	
	;初始化8254
	mov	al,	00110110b;36h					
	
	mov	dx, p_8254_con    ;计数器0，方式3-方波，二进制计数,初值03E8(1000),clk0 = 1mhz
	out	dx, al
	
	mov	al, 0e8h
	mov	dx, p_8254_0
	out	dx, al
	mov	al, 03h
	out	dx, al
	
	mov	al, 01110110b;76h					
	mov	dx, p_8254_con;计数器1，方式3-方波，二进制计数03E8(1000)
	out	dx, al
	
	mov	al, 0e8h
	mov	dx, p_8254_1
	out	dx, al
	mov	al, 03h
	out	dx, al
	
	;初始化8255
	mov dx, p_8255_con
	mov al, 10001001b;89h
	out dx, al   
	
main_loop:
	push ax
	push dx
	mov al,0
	mov dx, p_8255_b
	out dx, al
	pop dx
	pop ax
		
	mov	ch, state
	cmp ch, blink_state
	jne	not_finish
	;;call close_tr6
	call blink_3_times	   ;闪烁三次并回到初始状态
	mov	state, init_state	;进入初始状态
	call init_buffer      ;初始全黑
	
not_finish:	
	
	xor bx, bx  ;清零bx
	call show     ;显示
	;************键盘处理,读取的按键内容存在ah
a1:	mov	dx, p_8255_a
	mov	al, 00h
	out	dx, al
	
	mov	dx, p_8255_c
	in	al, dx
	and	al, 0fh
	cmp	al, 0fh
	je	main_loop    
	
	call delay_20ms	;延时	
	
	mov	dx, p_8255_a
	mov	al, 00h
	out	dx, al
	
	mov	dx, p_8255_c
	in	al, dx
	and	al, 0fh
	
	cmp	al, 0fh
	je	main_loop
	
	mov	ah, 11111110b  ;列扫描  从最左边开始
	mov	cx, 4   
find_key_pos:	
	mov	dx, p_8255_a
	mov	al, ah
	out	dx, al
	mov	dx, p_8255_c
	in	al, dx
	and	al, 0fh
	cmp	al, 0fh
	jne	found_key_pos
	rol	ah, 1
	loop find_key_pos
	
	mov	ah,80h    ;四列扫描完,发现没有键按下
	jmp	key_error
	
found_key_pos:	
	;mov	cl, 4
	;shl	ah, cl
	shl ah, 1
	shl ah, 1
	shl ah, 1
	shl ah, 1    ;ah算数左移4位则其高位为列号
	
	or 	al, ah    ;al为键盘码
	lea	bx, key_table
	mov	cl, 0
find_key:	
	cmp al, [bx]
	jz	found_key
	inc	cl
	inc	bx
	cmp	cl, 10h
	jnz	find_key
	
	mov	ah,0ffh  ;;CL = 10,说明没有找到对应键的位置码
	jmp	key_error
	
found_key:	
	mov	ah, cl
	;************AH里存着键值
	push ax
	push dx
	key_pushing:   	
	call  show	

	mov   al, 0           ;鎸夐敭鏃堕棿鐣ラ暱鏃朵笉瑙嗕负鏂版暟锛岃�屾樉绀烘棫鏁?
	mov   dx, p_8255_a
	out   dx, al
	mov   dx, p_8255_c
	in    al, dx
	and   al, 0fh
	cmp   al, 0fh
	jne   key_pushing
		
	pop dx
	pop ax
	
	
	
	
	
key_error:
	cmp	ah, 80h
	je	b1
;	je main_loop
	cmp	ah, 0ffh
	je  b1
;	je main_loop
	jmp b2
	
b1:	jmp main_loop

b2:
	mov	ch, state
	cmp ah, 0ah
	jae	gt_9   ;大于等于10转移
	
	cmp	ch, init_state
	jne	return0
;	jne main_loop
	
	lea	di, buffer
	mov	cl, [di+3]
	mov	[di+2], cl
	mov	[di+3], ah
	
	
	
	
	
return0:
	jmp main_loop
	
gt_9:
	cmp	ah, 0ah
	jne	not_a
	
	;; key A pushed, start counting
	cmp ch,a_state
    jz ll1
    jmp ll2
ll1:
	mov state,init_state
	
ll2:cmp ch, init_state
	jne back_to_init_state
	
	mov	state, running_state  	; A key pushed trap in running state
	lea	di, buffer               ;将第二第三个放到第一第二个   即分钟数从三四放到一二
	mov	cl, [di+2]
	mov	[di], cl
	mov	cl, [di+3]
	mov	[di+1], cl         
	mov	al, [di]
	mov	byte ptr [di+2], 10h
	mov	byte ptr [di+3], 10h
	mov	byte ptr [di+4], 10h
	mov	byte ptr [di+5], 10h
	
	;shl al,   1
	;mov bl,   al
	;shl al,   3
	;add al,   bl
	
	mov	bl, 0ah
	mul	bl 		;al*10 ->ax
	add	al, cl
	sub ah, ah
	mov	bl, 3ch
	mul	bl			;al*60->ax    得到秒数
	mov	total_count, ax
	call open_tr6	; start counting   开中断	
	jmp main_loop
	
back_to_init_state:	
	call close_tr6
	mov	state, init_state	
	call init_buffer
	jmp main_loop
	
not_a:
	cmp	ah, 0bh
	jne	not_b
	
	cmp ch, running_state
	jne no_run
	call close_tr6
	mov	state, pause_state
	jmp main_loop
no_run:
	cmp ch, pause_state
	jne no_effect
	;jne main_loop
	call open_tr6
	mov	state, running_state
no_effect:
	jmp main_loop

not_b:
	cmp	ah, 0ch
	jnz	return
;	jne main_loop
	call close_tr6
	;mov	state, exit_state	;退出
	mov	state, a_state	
	call init_buffer
	jmp main_loop
	
	mov	al, [si+10h]
	mov	dx, p_8255_b
	out	dx, al

	mov	al, 00h
	mov	dx, p_8255_a
	out	dx, al
 	
	mov ax, 4c00h
	int 21h 
		
return:
	jmp main_loop
	
	
show:

	push ax
	push bx
	push cx
	push dx
	push di
	xor bx, bx  ;清零bx
	mov	ah, show_pos   ;1111 1110b
	mov	cx, 4
	lea	di, buffer   ;缓冲区
;	sub bx, bx
	
show_loop:	
	mov	bl, [di]
	mov	al, [si+bx]
	mov	dx, p_8255_b
	out	dx, al

	mov	al, ah
	mov	dx, p_8255_a
	out	dx, al
	
	rol ah, 1h
	inc	di
	call delay
	
	mov	al, [si+10h]   ;消隐
	mov	dx, p_8255_b
	out	dx, al
	
	loop show_loop
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
	 	
mir6:  			;;8254一秒一个中断;上升沿脉冲
	sti         ;开中断
	
	dec	total_count
	jnz timer_not_finish
	
	mov	state, blink_state
	iret
timer_not_finish:
	push ax
	mov	ax, total_count
			
	lea	di, buffer
	mov	bl, 3ch   ;60
	div	bl		;秒数/60,AL=商,AH=余数
	push ax
	
	sub	ah, ah     
	mov	bl, 0ah
	div	bl        ;商再除以10   AL=分钟数的十位  ah=分钟数的个位
	
	mov	[di], al
	mov	[di+1], ah
	
	pop ax
	mov	al, ah
	sub	ah, ah
	
	mov	bl, 0ah
	div	bl        ;余数再除以10    al=秒数的十位    ah=秒数的个位
	mov	[di+2], al
	mov	[di+3], ah
	pop	ax
	
	iret
		

delay_20ms:	;proc	far
	push cx
	push bx
	mov	bx, 02h
	
d_20_1:	
	mov cx, 04ca0h	
d_20_0:    
	nop
	loop d_20_0
	
	dec bx
	jnz	d_20_1
	pop bx
	pop cx
	ret

blink_3_times:	 
	call close_tr6
	mov	cx, 3
d1:	
	mov	al, [si]
	mov	dx, p_8255_b
	out	dx, al

	mov	al, 00h
	mov	dx, p_8255_a
	out	dx, al
	
	call delay_longer
	
	mov	al, 0ffh
	mov	dx, p_8255_a
	out	dx, al
	
	call delay_longer
	loop d1 
	
	ret
	
close_tr6:
	mov al, 0efh     				;ocw1,11101111关闭ir6
	out 21h,  al
	ret
	
open_tr6:
	mov al, 0afh     ;ocw1,10101111  开ir6
	out 21h,  al
	ret
	
	
init_buffer:
	lea	di, buffer           ;初始全黑
	mov	byte ptr [di], 10h
	mov	byte ptr [di+1], 10h
	mov	byte ptr [di+2], 10h
	mov	byte ptr [di+3], 10h
	mov	byte ptr [di+4], 10h
	mov	byte ptr [di+5], 10h
	ret
	
	
delay:  
	push cx
	mov cx,  08fh	
aa0:    
	nop
	loop aa0
	pop cx
	ret
	
delay_longer:  
	push cx
	mov cx,  0ffffh	
aa1:    
	nop
	loop aa1
	pop cx
	ret
	
	
code    ends
end start	







	
	
	
	
				