#fasm#  
 
cli    ;Clear Interrupt flag flag if = 0 block int

xor ax,ax
mov es,ax
mov bx,cs
mov ax,intProc

mov word[es:180h],ax
mov word[es:182h],bx

sti ; Set flag if - 1 UnBlock int
mov ax,cs
mov es,ax

mov bx,strSubA    ;Sub 
mov di,strSubALen
mov dx,strSubD
mov si,strSubDLen
mov al,6
int 60h
cmp ah,12
je errorFuncNotFound


mov bx,strSubA    ;Sub 
mov di,strSubALen
mov dx,strSubD
mov si,strSubDLen
mov al,2
int 60h
cmp ah,12
je errorFuncNotFound 

mov dx,msgOutSub 
xor ax,ax
mov ah,09h
int 21h
 
mov bx,msgSub
lea ax,[msgSubEnd- 1]
call to_str
mov dx,msgSub 
xor ax,ax
mov ah,09h
int 21h


mov dx,msgOutAdd 
xor ax,ax
mov ah,09h
int 21h

mov bx,strA       ; add
mov di,strALen
mov dx,strD
mov si,strDLen
mov al,1
int 60h
cmp ah,12
je errorFuncNotFound 

mov bx,msgAdd
lea ax,[msgAddEnd - 1]
call to_str
mov dx,msgAdd 
xor ax,ax
mov ah,09h
int 21h

mov dx,msgOutMul
xor ax,ax
mov ah,09h
int 21h

mov bx,strMulA    ; mul
mov di,strMulALen
mov dx,strMulD
mov si,strMulDLen
mov al,4
int 60h 
cmp ah,12
je errorFuncNotFound 

mov bx,msgMul
lea ax,[msgMulEnd- 1]
call to_str
mov dx,msgMul 
xor ax,ax
mov ah,09h
int 21h
 
mov dx,msgOutDiv 
xor ax,ax
mov ah,09h
int 21h
 
mov bx,strDivA    ;Div 
mov di,strDivALen
mov dx,strDivB
mov si,strDivBLen
mov al,3
int 60h
cmp ah,1
je errorFuncNotFound

mov bx,msgDiv
lea ax,[msgDivEnd- 1]
call to_str
mov dx,msgDiv 
xor ax,ax
mov ah,09h
int 21h


xor ax,ax
mov al,0
int 21h
 
errorFuncNotFound:
xor ax,ax
mov dx,errorMsgA
mov ah,09h
int 21h

xor ax,ax
mov al,0
int 21h





intProc:

cmp al,1
je addStr 

cmp al,2
je subStr

cmp al,3
je divStr 

cmp al,4
je mulStr

mov ah,12 ; Function not found
stc
ret

addStr:
mov bp,di
call str_to_num
mov cx,ax
mov bx,dx
mov bp,si
call str_to_num
add cx,ax
ret

subStr:
mov bp,di
call str_to_num
mov cx,ax
mov bx,dx
mov bp,si
call str_to_num
sub cx,ax
ret

divStr: 
mov bp,di
call str_to_num
mov cx,ax
mov bx,dx
mov bp,si
call str_to_num
div cl
mov cx,ax 
ret

mulStr:
mov bp,di
call str_to_num
mov cx,ax
mov bx,dx
mov bp,si
call str_to_num
mul cx
mov cx,ax
ret



str_to_num:
push dx ; param: bx - array offset bp - array len  
push cx
push si
push sp

mov dx,bp 
mov bp,sp
sub sp,4

xor si,si
mov WORD[bp - 2],0 

Loops:
mov cx,WORD[bx + si]
sub cx,30h
mov ax,WORD[bp - 2]

mov ah,al
mov al,cl 
aad  

mov [bp-2],ax
inc si
cmp si,dx
jne Loops 

mov ax,[bp-2]

add sp,4 

pop sp
pop si
pop cx
pop dx 

ret


to_str:
  push di
  std                   
  mov	di,ax
  mov	ax,cx     

  mov	cx,10          
  Repeata:
  xor	dx,dx         
  div	cx            
                                      
  xchg	ax,dx         
  add	al,'0'         
  stosb                 
  xchg	ax,dx      
  or	ax,ax        
  jne	Repeata
		
  mov ax,bx

  pop di
  ret

msgOutMul db " Mul str: ",'$'
msgMul db 5 dup(?), '$'
msgMulEnd = $-1 

msgOutAdd db " Add str: ",'$' 
msgAdd db 5 dup(?), '$'
msgAddEnd =  $-1 

msgOutDiv db " Div str: ",'$'  
msgDiv db 5 dup(?) , '$'
msgDivEnd =  $-1  

msgOutSub db " Sub str: ",'$'   
msgSub db 5 dup(?) , '$'
msgSubEnd =  $-1  
   

errorMsgA db "Error function not found ",'$'  
   
   
strA  db "2"
strALen = $ - strA
strD  db "144"
strDLen = $ - strD  


strMulA  db "144"
strMulALen = $ - strMulA
strMulD  db "2"
strMulDLen = $ - strMulD  


strDivA  db "2"
strDivALen = $ - strDivA
strDivB  db "4"
strDivBLen = $ - strDivB


strSubA  db "254"
strSubALen = $ - strSubA
strSubD  db "127"
strSubDLen = $ - strSubD