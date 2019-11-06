assume cs:code
code segment
start:  mov ax,cs
        mov ds,ax
		mov si,offset do7c                           ;设置ds:si指向源地址
		mov ax,0
		mov es,ax
		mov di,200h
		mov cx,offset do7cend-offset do7c
		cld 
		rep movsb
		
		mov ax,0                                    ;设置中断向量表
		mov ds,ax
		mov word ptr ds:[4*7ch],200h                    ;注意这里低位是偏移地址
		mov word ptr ds:[4*7ch+2],0
		
		mov ax,4c00h
		int 21h
		
 do7c:      
            push bp
			mov bp,sp
			dec cx
			jcxz lpret
			add [bp+2],bx
	lpret:  pop bp
			iret
 do7cend:   nop
code ends
end start
		
		