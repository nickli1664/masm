assume cs:code

code segment
start:  mov ax,6
		call ax                  ;stack: IP=5
		inc ax                   ;不执行
	    mov bp,sp                
	    add ax,[bp]              ;这里要特别注意，bp默认段地址为ss（我之前竟然不知道...），ax=0bh   （6+5）

		mov ax,4c00h
		int 21h
code ends
end start