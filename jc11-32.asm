assume cs:codesg
codesg segment
start:  mov ax,0f000h
        mov ds,ax
		
		mov bx,0
		mov dx,0
		mov cx,32
		
	s:  mov al,[bx]
	    cmp al,32
		jna s0
		cmp al,128
		jnb s0
		inc dx
   s0:  inc bx
        loop s   

        mov ax,4c00h
		int 21h
		


codesg ends
end start