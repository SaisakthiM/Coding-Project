org 0x7C00 
bits 16 

%define ENDL 0x0D,0x0A 

start:
  jmp main

puts:
  push si
  push ax

loop:
  lodsb
  or al,al
  jz done


  mov ah,0x0e
  mov bh,0 
  int 0x10

  jmp loop

done:
  pop ax
  pop si
  ret
main: 
  mov ax, 0 
  mov ds, ax 


  mov ss, ax
  mov sp, 0x7C00 

  mov bx, my_arr
  mov si, 9

  mov si, [bx+si]
  call puts

  hlt 

halt:
  jmp halt

msg_hello: db "moases", ENDL, 0
msg_other: db "kai", ENDL, 0 
msg_no: db "hi", ENDL, 0 

my_arr:
  dw msg_hello
  dw msg_no
  dw msg_other

times 510-($-$$) db 0
dw 0xAA55


