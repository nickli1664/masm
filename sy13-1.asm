assume cs:code
code segment
start:  mov ax,cs
		mov ds,ax
		mov si,offset do7c		
		mov ax,0
		mov es,ax
		mov di,200h		
		mov cx,offset do7cend-offset do7c
		cld
		rep movsb 
		
		mov ax,0
		mov ds,ax
		mov word ptr ds:[4*7ch],200h
		mov word ptr ds:[4*7ch+2],0
		
        mov ax,4c00h
		int 21h

  do7c: push es
        push ax
		push bx
		push cx
		push si
          
        mov ax,0b800h
        mov es,ax
		mov bx,0
		mov al,160
		mul dh
		add bx,ax
		mov al,2
		mul dl
		add bx,ax
		mov al,cl
		
   s1:	mov ch,0
        mov cl,ds:[si]
		jcxz fin
        mov es:[bx],cl
		mov es:[bx+1],al
		
		inc si
		add bx,2
		jmp s1
		
  fin:  pop si
        pop cx
		pop bx
		pop ax
		pop es
        iret
do7cend: nop

code ends
end start	