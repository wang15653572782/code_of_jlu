stack	segment
		dw 128 dup(?)
stack	ends

code	segment
	assume	cs:code
start:	mov		dx,0606h
		mov		al,90h
		out		dx,al
tt:		mov		dx,0640h
		out		dx,al
		call	delay
		in		al,dx
		mov		dx,0602h
		out		dx,al
		jmp		tt
		int		03h
		
delay	proc
		push	cx
		push	bx
		mov 	cx,0ffh
ll2: 	mov 	bx,0fffh
ll1:	dec 	bx
		jnz 	ll1
		loop 	ll2
		pop 	bx
		pop 	cx
		ret
delay	endp
code	ends
	end		start