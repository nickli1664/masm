assume cs:codesg,ds:datasg,ss:stacksg
datasg segment
        db 'welcome to masm!'
		db 16 dup (2h)
		db 16 dup (24h)
		db 16 dup (71h) 
datasg ends
stacksg segment
        db 8 dup (0)
stacksg ends
codesg segment        
start:	mov ax,datasg
		mov ds,ax
		
		mov ax,0B800h
		mov es,ax
		
		mov ax,stacksg
		mov ss,ax
		
		mov bx,0
		mov bp,0
		mov si,0
		mov di,0
		
		mov cx,3
		
	sw: push cx
	    
		mov bx,0
		mov bp,0
        mov cx,16	
	s:  mov al,	ds:[bx]                                         ;注意这里单字节复制要用al，我第一次粗心用了ax，导致句尾乱码了：）
		mov es:[bp+si+1824],al                                  ;这里数数会很麻烦，11*160+2*32
		
		mov al,ds:[bx+di+16]
		mov es:[bp+si+1825],al
		
		inc bx
		add bp,2
		
		loop s
		
		add si,160
		add di,16
		
		pop cx
		
		loop sw
		
		mov ax,4c00h
		int 21h
codesg ends
end start