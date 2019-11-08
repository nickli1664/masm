assume cs:code
code segment
start:  mov ax,cs
        mov ds,ax
		mov si,offset setscreen                           ;设置ds:si指向源地址
		mov ax,0
		mov es,ax
		mov di,200h
		mov cx,offset setscreenend-offset setscreen
		cld 
		rep movsb
		
		mov ax,0                                    ;设置中断向量表
		mov ds,ax
		mov word ptr ds:[4*7ch],200h                    ;注意这里低位是偏移地址
		mov word ptr ds:[4*7ch+2],0
		
		mov ax,4c00h
		int 21h

setscreen: jmp short set                                    ;注意下面有个天坑！
  ;table dw sub1,sub2,sub3,sub4                             ;这里如果这样写，记录的还是装载程序076a时候的偏移量，偏移地址就乱掉了
  
 set:   ;push bx
        ;cmp ah,3
        ;ja sret

        cmp ah,0
        je run1

        cmp ah,1
        je run2

        cmp ah,2
        je run3

        cmp ah,3
        je run4
        ;mov bl,ah
        ;mov bh,0
        ;add bx,bx

        ;mov ax,table[bx]                                    ;同上，如果这里这样写，记录的还是076a时候的偏移量，同样偏移地址乱掉
        ;call ax
                                                             ;综合来看，这里使用直接定址表徒增烦恼，还不如穷举。
        ;call word ptr table[bx]
        ;call sub1
        
sret:   ;pop bx       
        iret

run1:   call sub1
        jmp sret
run2:   call sub2
        jmp sret
run3:   call sub3
        jmp sret
run4:   call sub4
        jmp sret


sub1:   push bx             ;清屏
        push cx
        push es
        mov bx,0b800h
        mov es,bx
        mov bx,0
        mov cx,2000
sub1s:  mov byte ptr es:[bx],' '
        add bx,2
        loop sub1s
        pop es
        pop cx
        pop bx
        ret

sub2:   push bx              ;设置前景色
        push cx
        push es
        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
sub2s:  and byte ptr es:[bx],11111000b
        or es:[bx],al
        add bx,2
        loop sub2s
        pop es
        pop cx
        pop bx
        ret

sub3:   push bx              ;设置背景色
        push cx
        push es
        mov cl,4
        shl al,cl
        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
sub3s:  and byte ptr es:[bx],10001111b
        or es:[bx],al
        add bx,2
        loop sub3s
        pop es
        pop cx
        pop bx
        ret

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
setscreenend: nop

code ends
end start

