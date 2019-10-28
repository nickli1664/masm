assume cs:codesg
codesg segment
        mov ax,4c00h
		int 21h
start:  mov ax,0

	s:  nop
	    nop
		
		mov di,offset s               
		mov si,offset s2
		mov ax,cs:[si]
		mov cs:[di],ax
		
	s0: jmp short s                        
    	
	s1: mov ax,0
	    int 21h
		mov ax,0
		
    s2: jmp short s1
	    nop
		
codesg ends
end start


;答案是可以正常结束正常返回的。
;这道题可以加深对jmp 的理解。短转移转移的是相对位移，编译后再对转移指令进行复制，就不能达到原来语义所表达的效果了。
;具体来说，s2标识编译出的结果是向前跳转10 Byte，复制到s标识后，仍为“向前跳转10 Byte”，执行后即为IP=00
;另外再要特别注意jmp 的跳转计算方法，即jmp下一条指令的开头向前跳转10 Byte，这里正好跳转到mov ax,4c00h (IP=00)
