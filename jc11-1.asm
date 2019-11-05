assume cs:codesg
codesg segment
start:  sub al,al        
	    mov al,1            
        push ax             
		pop bx               
		add al,bl            
		add al,10            
		mul al
		
		mov ax,4c00h
		int 21h
codesg ends
end start




;sub al,al            ZF=1     PF=1    SF=0
;mov al,1             ZF=1     PF=1    SF=0
;push ax              ZF=1     PF=1    SF=0
;pop bx               ZF=1     PF=1    SF=0
;add al,bl            ZF=0     PF=0    SF=0
;add al,10            ZF=0     PF=1    SF=0
;mul al               ZF=0     PF=1    SF=0  
;最后一个SF=0 存疑，实测确实为0