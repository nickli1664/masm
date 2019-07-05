assume cs:code
code segment
	mov ax,0ffffh
	mov ds,ax
	
	mov ss,ax
	mov sp,0
	
	mov bx,0
	
	mov dx,0
	
	mov cx,6
	
s:  pop ax
	mov bl,ah
	add ax,bx
	add dx,ax
	
	loop s
	
	mov ax,4c00h
	int 21h
code ends
end