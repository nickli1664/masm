assume ds:datasg,cs:codesg,ss:stacksg
datasg segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'
	
	;以上是表示21年的21个字符串
	
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	
	;以上是表示21年公司总收入的21个dword型数据
	
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
	
	;以上是表示21年公司雇员人数的21个word型数据
	
datasg ends

table segment
	db 21 dup ('year summ ne ?? ')
table ends

stacksg segment
	dw 0,0,0,0,0,0,0,0
stacksg ends

codesg segment
start:	mov ax,stacksg
		mov ss,ax
		mov sp,16

		mov ax,datasg
		mov ds,ax
			
		mov ax,table
		mov es,ax
	
	
		mov bx,0
		mov bp,0
		
		mov cx,21										;最外层21年循环
	s2: push cx											;保护最外层循环次数
		mov si,0
		mov cx,4
	sy:	mov al,ds:[bp+si]								;4次循环移动年份的4个字节
		mov es:[bx+si],al
		
		mov al,ds:[bp+si+84]
		mov es:[bx+si+5],al
				
		inc si
		loop sy
		
		add bx,16
		add bp,4
		
		pop cx
		
		loop s2
		
		
		mov ax,4c00h
		int 21h

codesg ends
end start

