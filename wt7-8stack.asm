assume ds:datasg,cs:codesg,ss:stacksg
datasg segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
datasg ends

stacksg segment
	dw 0,0,0,0,0,0,0,0          ;定义一个栈段,容量为16个字节
stacksg ends

codesg segment
start:	mov ax,stacksg
		mov ss,ax
		mov sp,16				;准备栈（注意栈基地址和sp的初始化方法，别忘了）
		mov ax,datasg
		mov ds,ax
		mov bx,0
		mov cx,4
	sw: push cx                 ;两层循环写法的关键，先暂存外层循环的cx。这里将外层循环的值压入栈
		mov si,0
		mov cx,3
	s:	mov al,[bx+si]
		and al,11011111b
		mov [bx+si],al
		inc si
		loop s
		
		add bx,16
		
		pop cx                ;两层循环写法的关键，再把外层循环的cx恢复
		
		loop sw
		
		mov ax,4c00h
		int 21h

codesg ends
end start

;使用栈存放循环次数