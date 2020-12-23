.model small
.stack 200h 
.data

    fh_in         dw 0
    fh_out        dw 0 
    file_in       db 16, 0, 16 dup(0)
    file_out      db 16, 0, 16 dup(0)
    klaida_isv    db 13, 10, "Ivyko klaida$"
    bufferis      db 200h dup(?) 
    skaicius      dw ?
    atmintis      db 0
    bool          db 0
    daugiklis     db ? 
     
   
.code
start: 
    mov dx, @data
    mov ds, dx 
    
;---------------        
    mov cl, es:[80h]
	dec cl
	xor ch, ch
	mov	bx, 0081h
	pagalba:
	cmp	es:[bx], '?/'							
	je klaida3			
	inc bx			
	loop pagalba
	mov cl, es:[80h]
	dec cl
    xor ch, ch
	mov si, 0000h
		inputas:
	mov al, es:[82h + si]
	cmp al, ' '
	je dauginamasis
	mov [file_in + si], al
	inc si
	loop inputas
	
	Dauginamasis:
	
	inc si
	dec cl
	mov dl, es:[82h + si] 
	mov daugiklis, dl
	add si, 2
	sub cl, 2
	
	mov ax, 0
	outputas: 
	mov bl, es:[82h + si]
	push si
	mov si, ax
	mov [file_out + si], bl
	inc ax
	pop si
	inc si
	loop outputas
	
	jmp praleidimas3
	klaida3:
	jmp klaida 
	praleidimas3:
    
    mov al, daugiklis 
      
    call konvertavimas
    
    mov daugiklis, al
    
    
    mov ax, 3d00h
    mov dx, offset file_in
    int 21h
    jc klaida
    mov fh_in, ax
    
    mov ax, 3c00h
    xor cx, cx
    mov dx, offset file_out
    int 21h
    jc klaida
    mov fh_out, ax 
    
    
nuskaitymas:
    mov ah, 3fh
    mov bx, fh_in
    mov cx, 1ffh
    mov dx, offset bufferis
    int 21h
    
    mov cx, ax
    mov bx, offset bufferis
    
    ;---------------------
    
    jmp praleidimas
    klaida:
    jmp klaida1
    praleidimas:
     
;----------------------    
    
    mov skaicius, cx 
    apsukimas:
    mov al, [bx]
    call konvertavimas
    mov [bx], al
    
    inc bx
    loop apsukimas
    
;--------------------- 
    mov cx, skaicius
    dauginimas:
    dec bx
    mov al, [bx]
    mul daugiklis
    add al, atmintis
    mov atmintis, 0h
    cmp al, 10h
    jb gerai
    mov dl, 10h
    div dl
    add atmintis, al
    mov al, ah
    gerai:
    push ax
    loop dauginimas
    
    ;-----------------------
    
    jmp praleidimas1
    klaida_atvira:
    jmp klaida_atvira1
    praleidimas1:
    jmp praleidimas2
    klaida1:
    jmp klaida2
    praleidimas2:
    
    ;-----------------------
    
    cmp atmintis, 0h
    je iprastas
    cmp atmintis, 9h
    jbe skaitmuo
    add atmintis, 37h
    jmp toliau
    skaitmuo:
    add atmintis, 30h
    toliau: 
    mov al, atmintis
    mov [bx], al
    inc bx
    mov cx, skaicius
    inc skaicius
    jmp isvedimas
    
    iprastas:
    mov cx, skaicius
    isvedimas:    
    pop ax
    cmp al, 9h
    jbe skaitmuo1
    add al, 37h
    jmp toliau1
    skaitmuo1:
    add al, 30h
    toliau1:
    mov [bx], al 
    inc bx
    loop isvedimas
        
    
    
    mov dx, offset bufferis
    mov ah, 40h
    mov bx, fh_out
    mov cx, skaicius
    int 21h       
    
    
    jmp uzdarymai
    
klaida_atvira1:
    mov bool, 1         
    
uzdarymai:
    mov ah, 3eh
    mov bx, fh_out
    int 21h
    mov ah, 3eh
    mov bx, fh_in
    int 21h 
    cmp bool, 0
    jne klaida2
    jmp pabaiga 
    
    
klaida2:
    mov ah, 09h
    mov dx, offset klaida_isv
    int 21h 
    
    
pabaiga:
    mov ax, 4c00h
    int 21h
    
    
konvertavimas:
    cmp al, '0'
    jb klaida2
    cmp al, 'f'
    ja klaida2
    cmp al, '9'
    jbe sekantis
    cmp al, 'A'
    jb klaida2
    cmp al, 'F'
    jbe didzioji
    cmp al, 'a'
    jb klaida2
    sub al, 57h
    jmp skip
    sekantis:
    sub al, 30h
    jmp skip
    didzioji:
    sub al, 37h
    skip:
    ret
     

  

   end start