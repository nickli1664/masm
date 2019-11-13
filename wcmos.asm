assume cs:code
code segment
start:  
		mov al,7               ;日
		out 70h,al
		mov al,11h
		out 71h,al
		
		
		
		
		
		;mov ah,al
		;mov cl,4
		;shr ah,cl              ;移位4位，保留后四位数据
		;and al,00001111b
		;add al,30h
		;add ah,30h
		;mov ds:[si+2],ah
		;mov ds:[si+3],al
		
		mov ax,4c00h
		int 21h
code ends
end start