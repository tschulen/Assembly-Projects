
;=================================
;MACROS
;=================================

Draw2 macro height, width, location, name, color
local hght0
local wdth20
local skip
	mov dh, height
	mov dl, width 
	mov ax,00h
	mov si, offset name ;-------------- this is the location of the bytes that write across the screen
	mov di, location ;------------------- this is the pixel location on the screen
hght0:
	mov cl, dl
wdth20:
	lodsb ;---returns al
	cmp al,00
	je skip
	add al,color
skip:   
	stosb ;---uses al to print
	sub cl,1
	jnz wdth20
incrow
stepback width
sub dh,1
jnz hght0
endm

cursor macro row, column
 mov ah,02
 mov bh,00
 mov dh, row
 mov dl, column
 int 10h
 endm

display macro input
 mov ah,09
 mov dx, offset input
 int 21h
 endm

incrow macro
 add di, 320
 endm

stepback macro width
 sub di, width
 endm

.model small
.stack 200

;=================================
;DATA SEGMENT
;=================================
.DATA
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                     TEXT MODE STRINGS
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
promp db 'He is being chased. Hes scared and alone. Will he escape?','$'

nter db 'Press enter to start animation then any key to exit when it finishes','$'

wrk db 'Fin','$'
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;			VARIABLE STRINGS
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

oldvideo db ?

heights dw ?
widths dw ?

lane1 dw ?
lane2 dw ?
lane3 dw ?
lane4 dw ?
lane5 dw ?
lane6 dw ?
lane7 dw ?
lane8 dw ?
lane9 dw ?

names dw ?

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;			GRAPHICS MODE STRINGS
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

peopleCount db ?

yellow db 13
lblue db 2
pink db 8
purple db 4
red db 10
random1 db 1
random2 db 15
random3 db 11
random4 db 7

blank	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	db 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0 
	
ghost1	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,0,0, 01Fh,01Fh,01Fh,01Fh,01Fh,0,0, 01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,0,0, 01Fh,01Fh,01Fh,01Fh,01Fh,0,0, 01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,0,01Fh,01Fh,0,01Fh,01Fh,01Fh,0,01Fh,01Fh,0,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

ghost2	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,0,0, 01Fh,01Fh,01Fh,01Fh,01Fh,0,0, 01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,0,0, 01Fh,01Fh,01Fh,01Fh,01Fh,0,0, 01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,01Fh,01Fh,0,0,0,01Fh,0,01Fh,0,0,0,01FH,01Fh,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

pac1 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0
db 0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0
db 0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,01fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0
db 0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0
db 0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0
db 0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0
db 0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0
db 0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0
db 0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0
db 0,0,0,0,0,0,0, 01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0

pac2 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0
db 0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0
db 0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0
db 0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0,0,0
db 0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0,0
db 0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0, 01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,01Fh,0,0,0,0,0,0,0,0,0






;===================================
;CODE SEGMENT
;===================================

.CODE

dillay proc
;-----------------save registers
push ax
push bx
push cx
push dx

mov aX,00
MOV BX,00
MOV CX,00
MOV DX,00

int 1Ah

mov bx,dx
add bx,7

dil1:
mov ah,0
int 1Ah
cmp bx,dx
JE DONE
jMP dil1

DONE:
pop dx
pop cx
pop bx
pop ax

ret
dillay endp

;======================================
;		ANIMATE FUNCTION
;======================================

draw proc
push ax
push bx
push cx
push dx

mov ch,35 ; ------------------HOWMANY TIMES ANIMATION LOOP LOOPS
mov lane1, 22400
mov lane2, 12800
mov lane3, 32000
mov lane4, 32000
mov lane5, 16000
mov lane6, 32000
mov lane7, 12800
mov lane8, 23400
mov lane9, 22400

mov peopleCount, 00
delayLoop:

inc peopleCount

Draw2 15,30,lane1, blank, yellow

add lane1,04

cmp peopleCount,3
jb nostart
add lane2,05

cmp peopleCount,5
jb nostart
add lane3,05

cmp peopleCount,9
jb nostart
add lane5,05

cmp peopleCount,11
jb nostart
add lane6,05

cmp peopleCount,13
jb nostart
add lane7,05

cmp peopleCount,15
jb nostart
add lane8,05

cmp peopleCount,16
jb nostart
add lane9,05

nostart:

;=====================Pacman=================;
Draw2 15,30,lane1, pac1, yellow

;=====================Ghosts================:
cmp peopleCount,3
jb out0
start00:	Draw2 15,30,lane2, ghost1, purple

cmp peopleCount,5
jb out0
start10:	Draw2 15,30,lane3, ghost2, random1

cmp peopleCount,9
jb out0
start30:	Draw2 15,30,lane5, ghost1, random3

cmp peopleCount,11
jb out0
start40:	Draw2 15,30,lane6, ghost2, random2	

cmp peopleCount,13
jb out0
start50:	Draw2 15,30,lane7, ghost1, pink

cmp peopleCount, 15
jb out0
start60:	Draw2 15,30,lane8, ghost2, lblue	

cmp peopleCount, 16
jb out0
start70:	Draw2 15,30,lane9, ghost1, red	

out0:	
	

;~~~~~~~~~~~~~~DELAY~~~~~~~~~~~~~~~~~~~
call dillay

 Draw2 15,30,lane1, blank, yellow
 
add lane1,04
;================PacMan=================;
Draw2 15,30,lane1, pac2, yellow
;================Ghosts================:
cmp peopleCount,3
jb out1
start01:	Draw2 15,30,lane2, ghost2, purple

cmp peopleCount,5
jb out1
start11:	Draw2 15,30,lane3, ghost1, random1

cmp peopleCount,9
jb out1
start31:	Draw2 15,30,lane5, ghost2, random3

cmp peopleCount,11
jb out1
start41:	Draw2 15,30,lane6, ghost1, random2	

cmp peopleCount,13
jb out1
start51:	Draw2 15,30,lane7, ghost2, pink

cmp peopleCount,15
jb out1
start61:	Draw2 15,30,lane8, ghost1, lblue	

cmp peopleCount, 16
jb out1
start71:	Draw2 15,30,lane9, ghost2, red	

out1:	
	
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DELAY~~~~~~~~~~~~~~~~~~~
call dillay

sub ch,1
jnz delayLoop

pop dx
pop cx
pop bx
pop ax
ret 
draw endp


;=====================================================
;MAIN FUNCTION
;=====================================================

main proc far
restart:
 mov ax,@data
 mov ds,ax
 mov di,0000h
;----------------------------------SAVE OLD VIDEO MODE
       mov     ah, 0Fh
       int     10h
       mov     OldVideo, al
;----------------------------------Clear  screen
 mov ax,0600h
 mov bh,07h
 mov ch,00
 mov cl,00
 mov dh,50 
 mov dl,50
 int 10h

prompt:
	cursor 3,3
	display promp
	cursor 4,3
	display nter
;---------------Compare For Enter to Start working 
	mov ah,00
	int 16h

;=====================================================
;GRAPHICS MODE CHANGE TO VGA mode
;=====================================================

       mov     ah, 0
       mov     al, 13h ;---------switch to VGA
       int     10h


; Setup VGA color palette

        mov     ah, 10h               ; color functions
		mov     al,13                 ;
        mov     bx, 00                ; bl 0 sub function (paging mode) bh 0 selects 4 blocks of 64
        mov     cx, 0006h             ; space to reserve for colors counting up from bx
        int     10h
		mov ax, 0a000h		 
		mov es, ax

call draw

mov ah,01h
int 21h

;=====================================================
;BACK TO OLD VIDEO MODE 
;=====================================================

error:

mov ah, 0
mov al, oldvideo
int 10h
	cursor 10, 10 
	display wrk
;-----------------------------------------------wait for keystroke
mov ah,01h
int 21h

mov ah,4ch
int 21h
main endp
end main
