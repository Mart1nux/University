.MODEL small
.STACK 100h
.DATA 
 
ats                 dw ?
ciklas              dw 0 
sk                  dw 1
daliklis            dw 10 
atsakymas           db '            $'
vienetai            db ?
desimtys            db ?
simtai              db ?
tukstanciai         db ?
desimtys_tukstanciu db ?

.CODE
strt:
mov ax,@data
mov ds,ax   
  
  
;------------------------------------------   


mov cx, 16 

pradzia:
   
mov ah, 1 

int 21h

cmp al, '0'

jl pradzia

cmp al, '1'

ja pradzia 

mov ah, 0

sub al, 48 

push ax 

loop pradzia 
 

;---------- 


mov cx, 16

nauja_pradzia:

pop ax

mul sk

add ats, ax

mov ax, sk

add sk, ax 

loop nauja_pradzia

mov ax, ats

            
;--------------  
    
       
mov ah, 2
 
mov dl, ' '

int 21h 

mov dl, 0      

mov ax, ats

mov cx, 5

Skaiciavimas:

mov si, cx

dec si                             

div daliklis

mov atsakymas[si], dl

mov dl, 0 

add atsakymas[si], 48

loop Skaiciavimas     


;-------------- 


mov ah, 9

mov dx, offset atsakymas

int 21h


;----------------

 
mov ax,4C00h
int 21h
end strt   