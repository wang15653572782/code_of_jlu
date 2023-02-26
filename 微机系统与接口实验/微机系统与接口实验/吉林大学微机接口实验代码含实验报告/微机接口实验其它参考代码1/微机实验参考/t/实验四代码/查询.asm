code	segment
	assume	cs:code
start:	mov		dx,0606h
		mov		al,90h
		out		dx,al
tt:		mov		dx,0640h
		out		dx,al
		mov		dx,0600h
ta:		in		al,dx
		cmp		al,01h
		jne		ta
		mov		dx,0640h
		in		al,dx
		mov		dx,0602h
		out		dx,al
		jmp		tt
		int		03h
code	ends
	end		start