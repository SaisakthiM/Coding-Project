section .data
    hello db 'Hello, World!',0

section .text
    global main

main:
    mov eax, 4
    mov ebx, 1
    mov ecx, hello
    mov edx, 13
    int 0x80
    mov eax, 1
    int 0x80

