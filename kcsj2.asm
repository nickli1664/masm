assume cs:code
data segment
	db '1) reset pc          ',0dh,0ah,'$'
	db '2) start system(todo)',0dh,0ah,'$'
	db '3) clock             ',0dh,0ah,'$'
	db '4) set clock         ',0dh,0ah,'$'
data ends

clock segment
    db '0000/00/00 00:00:00','$'
clock ends

setclock segment
	db '0000/00/00 00:00:00','$'
setclock ends

datacolor segment
	db 2
datacolor ends

code segment
start:  
		mov ax,datacolor
		mov ds,ax
		mov ax,0
		mov ds:[0],ax
		mov ax,data
		mov ds,ax
		mov cx,4
    	mov dx,0
  show:	mov ah,9
		int 21h
		add dx,24
		loop show
		
waitin:	mov ah,0
		int 16h
		cmp al,'1'
		je reset
		cmp al,'3'
		je showclock
		jmp waitin
		
		
reset:  
		mov word ptr ds:[0],0
		mov word ptr ds:[2],0FFFFh		
		jmp dword ptr ds:[0]
		
showclock:
		mov ax,clock
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
	
		mov dx,0
		mov ah,9
		int 21h
		
		mov bh,0                           ;记录当前行号,行号存储在dh中
	    ;mov dh,10
		;mov dl,0
		mov ah,3
		int 10h
		
		mov bh,0                           ;把光标移动到当前行的第一列
		mov dl,0
		mov ah,2
		int 10h
		
		;mov ah,0
		;int 16h
		in al,60h
		cmp al,1
		je tostart
		cmp al,3bh
		je changecolor
		
		
		jmp showclock

tostart: 
		call sub4
		mov ah,0ch                                          ;清空键盘缓冲区
		mov al,0
		int 21h
		jmp start
		
changecolor:
		push es
		push ax
		push bx
		push cx
		push dx
		push si
		
		mov ax,datacolor
		mov es,ax
		mov al,es:[0]
        ;cmp al,8
		;je roll
		mov dl,al
		;inc dl
		;mov byte ptr es:[0],dl
		;jmp normal
		
  ;roll: mov dl,1
		;mov byte ptr es:[0],dl

normal: mov ax,0B800h
		mov es,ax
		mov si,1
		mov cx,20
		
		mov al,dh
		mov ah,160
		mul ah
		mov bx,ax
		
  scc:	mov byte ptr es:[bx+si],dl
        add si,2
		loop scc
		
		
		add dl,50h
		mov byte ptr es:[bx+80],dl
		
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		jmp showclock
		
sub4:   push cx                  ;向上滚动一行
        push si
        push di
        push es
        push ds
        mov si,0b800h
        mov es,si
        mov ds,si                
        mov si,160               ;ds:si指向第n+1行
        mov di,0                 ;es:di指向第n行
        cld
        mov cx,24
sub4s:  push cx
        mov cx,160
        rep movsb                ;注意movsb会把si和di累加160
        pop cx
        loop sub4s
        mov cx,80                ;清空最后一行
        mov si,0
sub4s1: mov byte ptr [160*24+si],' '
        add si,2
        loop sub4s1
        pop ds
        pop es
        pop di
        pop si
        pop cx
        ret

code ends
end start