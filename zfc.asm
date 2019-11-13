assume cs:code
code segment
start:  
		mov bh,0                           ;记录当前行号,行号存储在dh中
		mov ah,3
		int 10h
		
		mov dl,0
		
		call getstr
		
		
		mov ax,4c00h
		int 21h
		
getstr:     push ax
getstrs:    mov ah,0
			int 16h
			cmp al,20
			jb nochar                       ;ascii码小于20h，说明不是字符
			mov ah,0
			call charstack                  ;字符入栈
		    mov ah,2
			call charstack                  ;显示
			jmp getstrs
			
	nochar: cmp ah,0eh                      ;退格键的扫描码
			je backspace
			cmp ah,1ch                      ;Enter键的扫描码
			je enter1
			jmp getstrs
			
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

code ends
end start

;子程序：字符串的入栈、出栈和显示。
;参数说明：(ah)=功能号，0表示入栈，1表示出栈，2表示显示；
;  ds:si指向字符栈空间
;  对于0号功能：(al)=入栈字符
;  对于1号功能：(al)=返回的字符
;  对于2号功能：(dh)、(dl)=字符串在屏幕上显示的行、列位置。

