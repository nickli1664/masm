assume cs:codesg,ds:datasg
datasg segment
	db 'welcome to masm!'
	db '................'
datasg ends
codesg segment
start:	mov ax,datasg
		mov ds,ax
		mov si,0
		mov cx,8               ;注意[si]一次取2个byte的值
	s:  mov ax,[si]
		mov [si+16],ax
		add si,2               ;注意[si]一次取2个byte的值
		loop s
		
		mov ax,4c00h
		int 21h
codesg ends
end start