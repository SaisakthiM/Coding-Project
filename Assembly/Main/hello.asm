; hello.asm - Linux x86 32-bit
section .data
    msg db "Hello, World!", 10
    len equ $-msg

section .text
    global _start

_start:
    mov eax, 4      ; sys_write
    mov ebx, 1      ; stdout
    mov ecx, msg    ; pointer to string
    mov edx, len    ; length
    int 0x80        ; syscall

    mov eax, 1      ; sys_exit
    xor ebx, ebx    ; exit code 0
    int 0x80
