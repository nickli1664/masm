assume ds:datasg,cs:codesg
datasg segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
datasg ends
codesg segment
start:	mov ax,datasg
		mov ds,ax
		mov bx,0
		mov cx,64
	s:	mov al,[bx]
		and al,11011111b
		mov [bx],al
		add bx,1
		loop s
		
		mov ax,4c00h
		int 21h

codesg ends
end start
