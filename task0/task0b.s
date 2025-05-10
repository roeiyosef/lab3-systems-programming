section .data
    msg db "hello world", 10     ; 10 = ASCII '\n'
    len equ $ - msg              ; compute length at compile time

section .text
    global _start

_start:
    mov eax, 4          ; syscall: write
    mov ebx, 1          ; fd = stdout
    mov ecx, msg        ; buffer
    mov edx, len        ; length
    int 0x80            ; perform syscall

    mov eax, 1          ; syscall: exit
    mov ebx, 0        ; exit code 0
    int 0x80
