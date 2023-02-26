stack	segment
		dw 128 dup(?)
stack	ends

code	segment
	assume	cs:code
start:	mov		ax,0
		mov		ds,ax
		mov		dx,0606h
		mov		al,90h
		out		dx,al
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
		mov		dx,0640h
		out		dx,al
tt:		nop
		jmp		tt
		int		03h
		
mir7	proc
		push	dx
		push	ax
		mov		dx,0640h
		in		al,dx
		mov		dx,0602h
		out		dx,al
		mov		al,20h
		out		20h,al
		mov		dx,0640h
		out		dx,al
		pop		ax
		pop		dx
		iret
mir7	endp
code	ends
	end		start