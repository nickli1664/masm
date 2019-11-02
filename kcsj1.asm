assume ds:datasg,cs:codesg,ss:stacksg
datasg segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'
	
	;以上是表示21年的21个字符串
	
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	
	;以上是表示21年公司总收入的21个dword型数据
	
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
	
	;以上是表示21年公司雇员人数的21个word型数据
	
datasg ends

table segment
	db 21 dup ('year summ ne ?? ')
table ends

output segment
    db 1640 dup (0)
output ends

stacksg segment
	dw 16 dup (0)
stacksg ends

codesg segment
start:	mov ax,stacksg
		mov ss,ax
		mov sp,16

		mov ax,datasg
		mov ds,ax
			
		mov ax,table
		mov es,ax
	
	
		mov bx,0
		mov bp,0
		
		mov cx,21										;最外层21年循环
   sw1: push cx											;保护最外层循环次数
		mov si,0
		mov cx,4
	sy:	mov al,ds:[bp+si]								;4次循环移动年份的4个字节
		mov es:[bx+si],al
		
		mov al,ds:[bp+si+84]							;4次循环移动收入的4个字节,这里注意偏移量使用立即数
		mov es:[bx+si+5],al
				
		inc si
		loop sy
					
		add bx,16										;目标结构体数组的偏移量
		add bp,4										;原数组的偏移量
		
		pop cx
		loop sw1
		
		
		
		mov bx,0
		mov bp,0
		
		mov cx,21									;最外层21年循环
   sw2: push cx										;保护最外层循环次数
		mov si,0
		mov cx,2
	sg:	mov al,ds:[bp+si+168]						;2次循环移动雇员数的2个字节
		mov es:[bx+si+10],al
		
		inc si
		loop sg
		
		mov ax,es:[bx+5]							;准备被除数低位的2个字节
		mov dx,es:[bx+7]							;准备被除数高位的2个字节
		div word ptr es:[bx+10]						;做除法
		mov es:[bx+13],ax							;写入商
		
					
		add bx,16									;目标结构体数组的偏移量
		add bp,2									;原数组的偏移量
		
		pop cx
		loop sw2
		
		
		
		mov ax,output
		mov ds,ax
		mov bx,0
		mov bp,0
		mov si,0
		mov di,0
		
		mov cx,21
 soput: push cx
        mov cx,4	
   syo:	mov al,es:[bx+di]                              ;一行总共40个字符，先处理前10个字符
		mov ds:[bp+di],al
		inc di
		loop syo
		
		mov di,0
		pop cx
		
		
		;mov bx,0
		mov ax,es:[bx+5]                            ;处理总收入数据
		mov dx,es:[bx+7]
		add si,10
		call dtoc
		
		
		mov ax,es:[bx+10]                           ;处理雇员数数据
		mov dx,0
		add si,10
		call dtoc
		
		mov ax,es:[bx+13]                           ;处理人均收入数据
		mov dx,0
		add si,10
		call dtoc
		
		add si,50                                   ;下一行
		add bx,16
		add bp,80                                   ;下一行
		
		loop soput
		
		
		mov dh,4
        mov dl,10
		mov cl,2
		
		mov si,0
		
		call show_str                                ;这里需要修改一下，改成无脑显示1640个字节
	
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
		;mov bx,0                        ;这个地方的算法还是有问题，要优化
		pop bx
		push bx
		
		
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
		  
		  mov cx,1640
	  s:  mov al,ds:[si]  
	      mov es:[bx],al            ;把字符值写入显存
		  		  
		  mov bp,sp
		  mov al,[bp]
		  mov es:[bx+1],al          ;把字符属性写入显存
		  		  
		  inc si
		  add bx,2
		  loop s
		  
     ok:  pop cx
	      pop bp
	      pop si
		  pop es
		  pop dx
		  pop bx
		  pop ax
		  
	      ret 
codesg ends
end start

