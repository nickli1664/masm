assume cs:code

code segment
start:  mov ax,4240h
        mov dx,000Fh
		mov cx,0Ah
		call divdw
		
		mov ax,4c00h
		int 21h
		
divdw:  push bx                         ;保护原来的bx
        push ax
		
		mov ax,dx                       ;把H放到低位
		mov dx,0                        ;高位补0凑够32位数
		
		
		div cx                          ;这里仍然要进行32位除法。我这里卡了很久，参考了网上的答案，实际上是把H挪到低位，高位补0即可。
		                                ;这一步执行int(H/N)，然后自动生成了rem(H/N)*65536
										
		mov bx,ax                       ;想办法保存公式的前半部分，即最后的dx
		
		pop ax                          ;把低位取出来，即+L
		
		div cx                          ;除第二次，即 [rem(H/N)*65536 + L]/N
		  
		mov cx,dx                       ;准备返回值的余数
		
		mov dx,bx                       ;准备返回值的高位
		
		pop bx
		  
		  
	    ret 
code ends
end start


;子程序：divdw
;功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型。
;参数：(ax)=dword型数据的低16位，(dx)=dword型数据的高16位，(cx)=除数。
;返回：(ax)=结果的低16位，(dx)=结果的高16位，(cx)=余数。
;这个算法要用到以下公式
; X: 被除数，范围：[0,FFFFFFFF]
; N: 除数，范围：[0,FFFF]
; H: X高16位，范围：[0,FFFF]
; L: X低16位，范围：[0,FFFF]
; int(): 取商，比如，int(38/10)=3
; rem(): 取余，比如，int(38/10)=8
; 公式：X/N=int(H/N)*65536 + [rem(H/N)*65536 + L]/N
;等号右边的所有除法运算可以直接用div，肯定不会除法溢出，书后有公式推导。（没看懂=_=）

