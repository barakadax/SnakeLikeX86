dseg segment
    monitor DD 0B8000000H
    something DB 219, 63  
dseg ends

sseg segment stack
    dw 100h dup(?)
sseg ends

cseg segment
assume  ds:dseg, cs:cseg, ss:sseg
start:   
    mov ax, dseg
    mov ds, ax
    ;----------------------------- 
	mov ax, word ptr something
	mov dh, 0
	push ds
	lds si, monitor     ;start colour white, 25 rows 80 coloumns
	mov ch, 25
	L0: 
		mov cl, 80
	L1:
		mov word ptr [si], ax   ;white on screen
		add si, 2
		dec cl
	jnz L1
		dec ch
	jnz L0
    ;-----------------------------
    mov ax, 0
    mov bp, 'r'
    mov si, 1760    ;start in middle row
    mov bx, 80      ;start in middle coloumn
	L2:
        mov ah, 0bh
        int 21h
        cmp al, 0                        ;if nothing changed
        je nothingChanged:
        mov ah, 7
        int 21h
        cmp al, 'd'
        jne notR
        mov bp, 'r'
    notR:
        cmp al, 'a'
        jne notL
        mov bp, 'l'
    notL:
        cmp al, 'w'
        jne notU
        mov bp, 'u'
    notU:
        cmp al, 's'
        jne notD
        mov bp, 'd'
    notD:
        cmp al, 27
        jne nothingChanged
        mov bp, 'x'
    nothingChanged:
        mov al, 88
        mov ah, 112
		mov word ptr [si + bx], ax       ;show X on screen
		mov byte ptr [si + bx], 219      ;delete the x
        inc bx
		mov byte ptr [si + bx], 127    ;colour white
        dec bx
        cmp bp, 'r'
        jne mightBeL
        add bx, 2
        cmp bx, 160
        jne L2
        mov bx, 0
    mightBeL:
        cmp bp, 'l'
        jne mightBeuU
        sub bx, 2
        jnz L2
        add bx, 160
    mightBeuU:
        cmp bp, 'u'
        jne mightBeD
        sub si, 160
        cmp si, 4000
        jbe L2
        mov si, 3840
    mightBeD:
        cmp bp, 'd'
        jne mightBeDone
        add si, 160
        cmp si, 3840
        jbe L2
        sub si, 4000
    mightBeDone:
        cmp bp, 'x'
        je EOC
	jmp L2
    EOC:
    ;-----------------------------	
    mov ah, 4ch
    int 21h
cseg ends
end start
