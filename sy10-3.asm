assume cs:code
data segment
    db 10 dup (0)
data ends

code segment
start:  mov ax,12666
        mov dx,0
        mov bx,data
		mov ds,bx
		mov si,0

		call dtoc
		
		mov dh,8
        mov dl,3
		mov cl,2
		
		call show_str
		
		mov ax,4c00h
		int 21h

dtoc:   push ax
		push bx
		push cx
        push dx
        push si
        				
    sc: mov cx,0Ah
		
        call divdw
		
		push cx
		mov cx,dx                       ;判断商的高位是否为0
		jcxz sp1
		pop cx
		
		;mov bl,cl                       ;把余数放进数据段
		;add bl,30h
		;mov [si],bl
		add cl,30h
		mov [si],cl
		inc si
		
		jmp sc
		 
  sp1:	mov cx,ax                       ;判断商的低位是否为0
        jcxz zyok
		pop cx
		
		;mov bl,cl
		;add bl,30h
		;mov [si],bl
  		add cl,30h                       ;把余数放进数据段
		mov [si],cl                     
        inc si
		    
		jmp sc

  zyok: pop cx

        ;mov bl,cl                       ;处理最后一个余数
		;add bl,30h
        ;mov [si],bl
		add cl,30h
		mov [si],cl
        inc si
		
		mov bl,0
		mov [si],bl                     ;以0结尾，这条可酌情考虑增减
		
		
    	dec si 	                        ;这里可能是我之前的数据处理算法有问题，还需要在这里把字符串倒过来。
		;mov bx,0               ;这个地方的算法还是有问题，要优化
		pop bx                  ;把初始化时候的si取出来，放进bx
		push bx                 ;再把si放进去（有点啰嗦了）
		
	sd:	mov cx,si
						
		sub cx,bx
		jcxz allok

				
		mov al,ds:[bx]
		mov ah,ds:[si]
		mov ds:[si],al
		mov ds:[bx],ah
		
		dec cx
		jcxz allok
		
		dec si
		inc bx
		
		jmp sd
			
		
  allok:  pop si
		  pop dx
		  pop cx
          pop bx
          pop ax 		
		  ret
		
divdw:  push bx                         ;保护原来的bx
        push ax
		
		mov ax,dx                       ;把H放到低位
		mov dx,0                        ;高位补0凑够32位数
		
		
		div cx                          ;这里仍然要进行32位除法。我这里卡了很久，参考了网上的答案，实际上是把H挪到低位，高位补0即可。
		                                ;这一步执行int(H/N)，然后自动生成了rem(H/N)*65536
										
		mov bx,ax                       ;想办法保存公式的前半部分，即最后的dx
		
		pop ax                          ;把低位取出来，即+L
		
		div cx                          ;除第二次，即 [rem(H/N)*65536 + L]/N
		  
		mov cx,dx                       ;准备返回值的余数
		
		mov dx,bx                       ;准备返回值的高位
		
		pop bx	  
	    ret 
	
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


;子程序：dtoc
;功能：将word型数据转变为表示十进制数的字符串，字符串以0为结尾符。
;参数：(ax)=word型数据， ds:si指向字符串的首地址。
;返回：无

;子程序：divdw
;功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型。
;参数：(ax)=dword型数据的低16位，(dx)=dword型数据的高16位，(cx)=除数。
;返回：(ax)=结果的低16位，(dx)=结果的高16位，(cx)=余数。

;显示字符串子程序：show_str
;功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串
;参数(dh)=行号(取值范围0~24)，(dl)=列号(取值范围0~79)，(cl)=颜色，ds:si指向字符串的首地址
;返回：无


