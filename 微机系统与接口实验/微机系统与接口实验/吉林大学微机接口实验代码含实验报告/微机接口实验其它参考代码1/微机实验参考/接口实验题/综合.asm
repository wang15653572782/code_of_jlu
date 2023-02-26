IO8255_C	equ 0606h
IO8255_PA	equ 0600h
IO8255_PB	equ 0602h
IO8255_PC	equ 0604h

stack	segment
		dw 128 dup(?)
stack	ends

data	segment
	num		db	3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,6fh
	zm		db	77h,7ch,39h,5eh,79h,71h
			;行(out)-列(in)
	table	db	11101110b;0
			db	11011110b;1
			db	10111110b;2
			db	01111110b;3
			db	11101101b;4
			db	11011101b;5
			db	10111101b;6
			db	01111101b;7
			db	11101011b;8
			db	11011011b;9
			db	10111011b;a
			db	01111011b;b
			db	11100111b;c
			db	11010111b;d
			db	10110111b;e
			db	01110111b;f
	stro	db	4 dup(0)
	begin	db	4 dup(0)
data	ends

code	segment
	assume	cs:code,ds:data
start:	mov		ax,data
		mov		ds,ax
		mov		dx,IO8255_C
		mov		al,81h
		out		dx,al
		
		mov		bx,offset stro
		
		cli
		mov		ax,offset mir7
		mov		si,3ch
		mov		[si],ax
		mov		ax,cs
		mov		si,3eh
		mov		[si],ax
		mov		al,11h
		out		20h,al
		mov		al,08h
		out		21h,al
		mov		al,04h
		out		21h,al
		mov		al,05h
		out		21h,al
		mov		al,7fh
		out		21h,al
		sti
				
x1:		call	outp
		mov		dx,IO8255_PA
		mov		al,0
		out		dx,al
		mov		IO8255_PC
		in		al,dx
		and		al,0fh
		cmp		al,0fh
		jz		x1
		mov		cx,0fa0h
y1:		call	outp
		loop	y1
		mov		dx,IO8255_PA
		mov		al,00h
		out		dx,al
		mov		dx,IO8255_PC
		in		al,dx
		and		al,0fh
		cmp		al,0fh
		jz		x1
		
tt:		call	key
		cmp		ah,0ffh
		jnz		y2
		call	er
		jmp		x1
		
y2:		cmp		ah,0ah
		ja		;;;;;;;;;;;;;;;
		mov		al,ah
		mov		ah,0
		mov		si,offset num
		mov		di,offset 
		add		si,ax
		mov		al,[si]
		mov		[bx],al
		inc		bx
		cmp		bx,di
		jnz		x1
		sub		bx,6
		jmp		x1

		int		03h
	
mir7	proc
		push	ax
		;s-1
		mov		al,20h
		out		20h,al
		pop		ax
		iret
mir7	endp

key		proc	;ah为返回键值
		push	dx
		push	cx
		push	bx
		mov		ah,0feh
		mov		cx,4
x2:		mov		dx,IO8255_PA
		mov		al,ah
		out		dx,al
		mov		dx,IO8255_PC
		and		al,0fh
		cmp		al,0fh
		jnz		x3
		rol		ah,1
		loop	x2
		mov		ah,80h
		jmp		xend
x3:		mov		cl,4
		shl		ah,cl
		or		al,ah
		lea		bx,table
		mov		cl,0
x4:		cmp		al,[bx]
		jz		x5
		inc		cl
		inc		bx
		cmp		al,10h
		jnz		x4
		mov		ah,0ffh
		jmp		xend
x5:		mov		ah,cl
xend:	pop		bx
		pop		cx
		pop		dx
		ret
key		endp

outp	proc
		push	ax
		push	si
		push	dx
		push	cx
		push	bx
		push	di
		mov		ah,0
		mov		si,offset stro
		mov		bx,offset num
		mov		cl,4
		mov		ch,0dfh
to:		mov		dx,IO8255_PA
		mov		al,ch
		out		dx,al
		mov		dx,IO8255_PB
		mov		al,[si]
		mov		di,ax
		mov		al,[bx+di]
		out		dx,al
		inc		si
		ror		ch
		dec		cl
		cmp		cl,0
		jnz		to
		pop		di
		pop		bx
		pop		cx
		pop		dx
		pop		si
		pop		ax
		ret
outp	endp

er		proc		
		push	dx
		push	ax
		push	cx
		mov		cx,400h
e1:		mov		ah,0ffh
e2:		mov		dx,IO8255_PA
		mov		al,0
		out		dx,al
		mov		dx,IO8255_PB
		mov		al,0ffh
		out		dx,al
		dec		ah
		jz		e2
		loop	e1
		pop		cx
		pop		ax
		pop		dx
		ret
er		endp
code	ends
	end	start