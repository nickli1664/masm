assume ds:datasg,cs:codesg
datasg segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
	dw	0                         ;定义一个字，用来存放cx
datasg ends
codesg segment
start:	mov ax,datasg
		mov ds,ax
		mov bx,0
		mov cx,4
	sw: mov ds:[64],cx                 ;两层循环写法的关键，先暂存外层循环的cx。这里将外层循环存放到之前定义的dw中
		mov si,0
		mov cx,3
	s:	mov al,[bx+si]
		and al,11011111b
		mov [bx+si],al
		inc si
		loop s
		
		add bx,16
		
		mov cx,ds:[64]                 ;两层循环写法的关键，再把外层循环的cx恢复
		
		loop sw
		
		mov ax,4c00h
		int 21h

codesg ends
end start

;使用内存空间存放循环次数