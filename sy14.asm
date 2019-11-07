assume cs:code
data segment
    db '0000/00/00 00:00:00','$'
data ends

code segment
start:  mov ax,data
        mov ds,ax
		mov si,0
				
		mov al,32h             ;世纪
		out 70h,al
		in al,71h
		mov ah,al
		mov cl,4
		shr ah,cl              ;移位4位，保留后四位数据
		and al,00001111b
		add al,30h
		add ah,30h
		mov ds:[si],ah
		mov ds:[si+1],al
		
		mov al,9               ;年
		out 70h,al
		in al,71h
		mov ah,al
		mov cl,4
		shr ah,cl              ;移位4位，保留后四位数据
		and al,00001111b
		add al,30h
		add ah,30h
		mov ds:[si+2],ah
		mov ds:[si+3],al
		
		mov al,8               ;月
		out 70h,al
		in al,71h
		mov ah,al
		mov cl,4
		shr ah,cl              ;移位4位，保留后四位数据
		and al,00001111b
		add al,30h
		add ah,30h
		mov ds:[si+5],ah
		mov ds:[si+6],al
		
		mov al,7               ;日
		out 70h,al
		in al,71h
		mov ah,al
		mov cl,4
		shr ah,cl              ;移位4位，保留后四位数据
		and al,00001111b
		add al,30h
		add ah,30h
		mov ds:[si+8],ah
		mov ds:[si+9],al
		
		mov al,4               ;时
		out 70h,al
		in al,71h
		mov ah,al
		mov cl,4
		shr ah,cl              ;移位4位，保留后四位数据
		and al,00001111b
		add al,30h
		add ah,30h
		mov ds:[si+11],ah
		mov ds:[si+12],al
		
		mov al,2               ;分
		out 70h,al
		in al,71h
		mov ah,al
		mov cl,4
		shr ah,cl              ;移位4位，保留后四位数据
		and al,00001111b
		add al,30h
		add ah,30h
		mov ds:[si+14],ah
		mov ds:[si+15],al
		
		mov al,0               ;秒
		out 70h,al
		in al,71h
		mov ah,al
		mov cl,4
		shr ah,cl              ;移位4位，保留后四位数据
		and al,00001111b
		add al,30h
		add ah,30h
		mov ds:[si+17],ah
		mov ds:[si+18],al
		
		;mov bh,0
	    ;mov dh,10
		;mov dl,0
		;mov ah,2
		;int 10h
		 
		mov dx,0
		mov ah,9
		int 21h
			
		mov ax,4c00h
		int 21h
code ends
end start

