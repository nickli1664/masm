assume cs:codesg
codesg segment
start:  mov ax,2000h
	    mov ds,ax
		mov bx,0
	s:  mov ch,0
		mov cl,ds:[bx]                ;这道题，感觉s标识可以放在这里，逻辑也没有问题。
		inc cl
		inc bx
		loop s
	ok: dec bx                        ;dec 指令的功能和inc相反，dec bx进行的操作为： (bx)=(bx)-1
		mov dx,bx
		
		mov ax,4c00h
		int 21h

codesg ends
end start