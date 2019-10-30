assume cs:code,ss:stack
data segment
    dw 8 dup (0)
data ends

code segment
start:  mov ax,data
        mov ss,ax
		mov sp,16
		mov word ptr ss:[0],offset s    
		mov ss:[2],cs
		call dword ptr ss:[0]
		nop
	s:  mov ax,offset s                 ;ax= offset s (IP)
	    sub ax,ss:[0CH]                 ;ax=1
		mov bx,cs                       ;bx=cs
		sub bx,ss:[0EH]                 ;bx=0
		
		
		mov ax,4c00h
		int 21h
code ends
end start

;这种题实在想不出来就在草稿纸上画个栈的图