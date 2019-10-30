assume cs:code,ds:data
data segment
    db 'Welcome to masm!',0
data ends

code segment
start:  mov dh,8
        mov dl,3
		mov cl,2
		mov ax,data
		mov ds,ax
		mov si,0
		call show_str
		
		mov ax,4c00h
		int 21h
		
show_str: push ax
          push bx
		  push dx
          push es
		  push si
		  push bp
		  push cx
		  
		  mov ax,0B800h
		  mov es,ax
		  mov ch,0
		  dec dh
		  dec dl
		         
	      mov al,160                 ;根据参数计算行列偏移量
		  mul dh
		  mov bx,ax
		  mov al,2
		  mul dl
		  add bx,ax
		  
	  s:  mov cl,ds:[si]              
		  jcxz ok
		  mov es:[bx],cl            ;把字符值写入显存
		  
		  
		  
		  mov bp,sp
		  mov al,[bp]
		  mov es:[bx+1],al          ;把字符属性写入显存
		  
		  
		  
		  inc si
		  add bx,2
		  jmp short s
		  
     ok:  pop cx
	      pop bp
	      pop si
		  pop es
		  pop dx
		  pop bx
		  pop ax
		  
	      ret 
code ends
end start


;显示字符串子程序：show_str
;功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串
;参数(dh)=行号(取值范围0~24)，(dl)=列号(取值范围0~79)，(cl)=颜色，ds:si指向字符串的首地址
;返回：无

