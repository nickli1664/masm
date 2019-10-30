assume cs:code,ss:stack
stack segment
    db 16 dup (0)
stack ends

code segment
start:  mov ax,0
		call s
		inc ax
	s:  pop ax
		
		mov ax,4c00h
		int 21h
code ends
end start

;ax=6