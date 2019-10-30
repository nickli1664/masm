assume cs:code,ss:stack
stack segment
    db 16 dup (0)
stack ends

code segment
start:  mov ax,0
		call far ptr s         ;CS=1000h  IP=8
		inc ax
	s:  pop ax                 ;ax=8
	    add ax,ax              ;ax=16
		pop bx                 ;bx=1000h
		add ax,bx              ;ax=1010h
		
		mov ax,4c00h
		int 21h
code ends
end start