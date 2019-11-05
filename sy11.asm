assume cs:codesg
datasg segment
    db "Beginner's All-purpose Symbolic Instruction Code.",0
datasg ends

codesg segment
start:  mov ax,datasg
        mov ds,ax
		mov si,0
		call letterc
		
		mov ax,4c00h
		int 21h
		
letterc:
		push cx
		push si
		
        mov cx,0
	bg:	mov cl,ds:[si]
		jcxz fin
		cmp cl,61h
		jb pass
		cmp cl,7ah
		ja pass
		sub cl,20h
		mov ds:[si],cl
		
  pass: inc si
		jmp bg
		
  fin:	pop si
        pop cx
		ret
		
codesg ends
end start


;名称：letterc
;功能：将以0结尾的字符串中的小写字母转变为大写字母
;参数：ds:si指向字符串首地址