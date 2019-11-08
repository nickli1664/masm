assume cs:code
code segment
start:     jmp short show
         table dw ag0,ag30,ag60,ag90,ag120,ag150,ag180
		 ag0   db '0',0
		 ag30  db '0.5',0
		 ag60  db '0.866',0
		 ag90  db '1',0
		 ag120  db '0.866',0
		 ag150  db '0.5',0
		 ag180  db '0',0
show:      mov bx,0b800h
		   mov es,bx
		   
		   mov ax,60
		   
		   mov ah,0
		   mov bl,30
		   div bl
		   mov bl,al
		   mov bh,0
		   add bx,bx
		   mov bx,table[bx]
		  
		  
		   
		   
		   mov ax,4c00h
		   int 21h
code ends
end start
		   
		  