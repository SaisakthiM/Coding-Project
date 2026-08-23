
section .data
; -----
; Define constants
EXIT_SUCCESS equ 0 ; successful operation
SYS_exit equ 60 ; call code for terminate
; -----
; Byte (8-bit) variable declarations
bVar1 db 17
bVar2 db 9
bResult db 0
; -----
; Word (16-bit) variable declarations
wVar1 dw 17000
wVar2 dw 9000
wResult dw 0
; -----
; Double-word (32-bit) variable declarations
dVar1 dd 17000000
dVar2 dd 9000000
dResult dd 0

; -----
; quadword (64-bit) variable declarations
qVar1 dq 170000000
qVar2 dq 90000000
qResult dq 0
; ************************************************************
; Code Section
section .text
global _start
_start:
    ; Byte example 
    ; bResult = bVar1 + bVar2

    mov al, byte [bVar1]
    add al, byte [bVar2]
    mov byte [bResult], al

    ; wResult = dVar1 + dVar2

    mov ax, word [qVar1]
    add ax, word [qVar2]
    mov word [qResult], ax

    ; dResult = dVar1 + dVar2

    mov eax, dword [dVar1]
    add eax, dword [dVar2]
    mov dword [dResult], eax

    ; qResult = dVar1 + dVar2

    mov rax, qword [qVar1]
    add rax, qword [qVar2]
    mov qword [qResult], rax

    mov rax, 1
    mov rdi, 1
    mov rsi, bVar1
    mov rdx, 8
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, dVar1
    mov rdx, 16
    syscall



last:
mov rax, SYS_exit ; Call code for exit
mov rdi, EXIT_SUCCESS ; Exit program with success
syscall



