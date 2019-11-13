assume cs:code
data segment
	db '1) reset pc          ',0dh,0ah,'$'
	db '2) start system(todo)',0dh,0ah,'$'
	db '3) clock             ',0dh,0ah,'$'
	db '4) set clock         ',0dh,0ah,'$'
	db 'Please enter new date&time.(Format: 0000/00/00 00:00:00)(Press ESC to cancel.)',0dh,0ah,'$'
data ends

clock segment
    db '0000/00/00 00:00:00','$'
clock ends

setclock segment
	db '0000/00/00 00:00:00'
	db 60 dup (0)
setclock ends

datacolor segment
	db 1
datacolor ends

code segment
start:  
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
		cmp al,'2'
		je exit
		cmp al,'3'
		je showclock
		cmp al,'4'
		je cclockmid
		jmp waitin
		
exit:   
		mov ax,setclock
		mov ds,ax
		
		mov ax,4c00h
		int 21h
		
cclockmid:
		jmp changeclock

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
		push ds
		push es
		push ax
		push bx
		push cx
		push dx
		push si
		
kdelay:	
		in al,60h
		cmp al,0bbh
		jne kdelay
		
		mov ah,0ch                                          ;清空键盘缓冲区
		mov al,0
		int 21h
		
        mov ax,0B800h
		mov es,ax
		mov ax,datacolor
		mov ds,ax
		mov si,1
		mov cx,20
		
		
		mov al,dh
		mov ah,160
		mul ah
		mov bx,ax
		
		sti
		mov dl,ds:[0] 
		and dl,00000111b
		inc dl
		and dl,00000111b
		mov ds:[0],dl
		
		cmp dl,0
		jne scc 
		inc dl
		mov ds:[0],dl
		
		
  scc:	mov byte ptr es:[bx+si],dl
        add si,2
		loop scc
		
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop ds
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

changeclock: 
		
		mov ax,data
		mov ds,ax
    	mov dx,96
        mov ah,9
		int 21h
		
		mov ax,setclock                    ;把要写入的字符串指定位置
		mov ds,ax
		mov si,0
		

		mov bh,0                           ;记录当前行号,行号存储在dh中
		mov ah,3
		int 10h
		
		mov dl,0
		
		call getstr
		
		call sub4


		
		jmp tostart
		
getstr:     push ax
getstrs:    mov ah,0
			int 16h
			cmp al,20h
			jb nochar                       ;ascii码小于20h，说明不是字符
			mov ah,0
			call charstack                  ;字符入栈
		    mov ah,2
			call charstack                  ;显示
			jmp getstrs
			
	nochar: cmp ah,01h
			je tostart2
			cmp ah,0eh                      ;退格键的扫描码
			je backspace
			cmp ah,1ch                      ;Enter键的扫描码
			je enter1
			jmp getstrs
			
  tostart2: jmp tostart			
			
backspace:  mov ah,1
			call charstack                  ;字符出栈
			mov ah,2
			call charstack                  ;重新显示
			jmp getstrs
			
	enter1: mov al,0
			mov ah,0
			call charstack					;0入栈
			mov ah,2
			call charstack                  ;显示
			
			call nys
			
			pop ax
			ret


charstack:  jmp short charstart
table 	    dw charpush,charpop,charshow
top         dw 0

charstart:  push bx
		    push dx
			push di
			push es
			
			cmp ah,2
			ja sret
			mov bl,ah
			add bx,bx
			jmp word ptr table[bx]

charpush:   mov bx,top
			mov [bx+si],al
			inc top
			jmp sret
			
charpop:    cmp top,0
			je sret
			dec top
			mov bx,top
			mov al,[bx+si]
			jmp sret
			
charshow:   mov bx,0b800h
			mov es,bx
			mov al,160
			mov ah,0
			mul dh
			mov di,ax
			add dl,dl
			mov dh,0
			add di,dx
			
			mov bx,0
			
charshows:  cmp bx,top
			jne noempty
			mov byte ptr es:[di],' '
			jmp sret
noempty:    mov al,[bx+si]
			mov es:[di],al
			mov byte ptr es:[di+2],' '
			inc bx
			add di,2
			jmp charshows
			
sret:       pop es
			pop di
			pop dx
			pop bx
			ret

nys:		
			push ds
			push ax
			push cx
			
			mov ax,setclock
			mov ds,ax
			
			mov ah,ds:[0]                      ;世纪
			mov al,ds:[1]
			sub ah,30h
			sub al,30h
			mov cl,4
			shl ah,cl
			add ah,al
			
			mov al,32h
			out 70h,al
			mov al,ah
			out 71h,al
			
			mov ah,ds:[2]                      ;年
			mov al,ds:[3]
			sub ah,30h
			sub al,30h
			mov cl,4
			shl ah,cl
			add ah,al
			
			mov al,9h
			out 70h,al
			mov al,ah
			out 71h,al
			
			mov ah,ds:[5]                      ;月
			mov al,ds:[6]
			sub ah,30h
			sub al,30h
			mov cl,4
			shl ah,cl
			add ah,al
			
			mov al,8h
			out 70h,al
			mov al,ah
			out 71h,al
			
			mov ah,ds:[8]                      ;日
			mov al,ds:[9]
			sub ah,30h
			sub al,30h
			mov cl,4
			shl ah,cl
			add ah,al
			
			mov al,7h
			out 70h,al
			mov al,ah
			out 71h,al
			
			mov ah,ds:[11]                      ;时
			mov al,ds:[12]
			sub ah,30h
			sub al,30h
			mov cl,4
			shl ah,cl
			add ah,al
			
			mov al,4h
			out 70h,al
			mov al,ah
			out 71h,al
			
			mov ah,ds:[14]                      ;分
			mov al,ds:[15]
			sub ah,30h
			sub al,30h
			mov cl,4
			shl ah,cl
			add ah,al
			
			mov al,2h
			out 70h,al
			mov al,ah
			out 71h,al
			
			mov ah,ds:[17]                      ;秒
			mov al,ds:[18]
			sub ah,30h
			sub al,30h
			mov cl,4
			shl ah,cl
			add ah,al
			
			mov al,0h
			out 70h,al
			mov al,ah
			out 71h,al
			
			pop cx
			pop ax
			pop ds
			ret


code ends
end start