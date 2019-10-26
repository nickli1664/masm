assume cs:code
data segment
	db 0,0,0                            ;这里需要注意，因为访问的是word，需要前3个字节都为0
data ends
code segment
 start:	mov ax,data				
		mov ds,ax
		mov bx,0
		jmp word ptr [bx+1]
code ends
end start