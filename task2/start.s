section .data
msg db "Hello, Infected File", 10
msg_len equ $ - msg


global code_start
global code_end
global system_call
global _start
global infection
global infector


extern main

section .text
_start:
    pop    dword ecx    ; ecx = argc
    mov    esi,esp      ; esi = argv
    ;; lea eax, [esi+4*ecx+4] ; eax = envp = (4*ecx)+esi+4
    mov     eax,ecx     ; put the number of arguments into eax
    shl     eax,2       ; compute the size of argv in bytes
    add     eax,esi     ; add the size to the address of argv 
    add     eax,4       ; skip NULL at the end of argv
    push    dword eax   ; char *envp[]
    push    dword esi   ; char* argv[]
    push    dword ecx   ; int argc

    call    main        ; int main( int argc, char *argv[], char *envp[] )

    mov     ebx,eax
    mov     eax,1
    int     0x80
    nop

system_call:
    push    ebp             ; Save caller state
    mov     ebp, esp
    sub     esp, 4          ; Leave space for local var on stack
    pushad                  ; Save some more caller state

    mov     eax, [ebp+8]    ; Copy function args to registers: leftmost...        
    mov     ebx, [ebp+12]   ; Next argument...
    mov     ecx, [ebp+16]   ; Next argument...
    mov     edx, [ebp+20]   ; Next argument...
    int     0x80            ; Transfer control to operating system
    mov     [ebp-4], eax    ; Save returned value...
    popad                   ; Restore caller state (registers)
    mov     eax, [ebp-4]    ; place returned value where caller can see it
    add     esp, 4          ; Restore caller state
    pop     ebp             ; Restore caller state
    ret                     ; Back to caller


code_start:
  

infection:
    mov eax, 4        ; write syscall
    mov ebx, 1        ; stdout
    mov ecx, hello_msg
    mov edx, hello_len
    int 0x80

    mov     ebx,eax
    mov     eax,1
    int     0x80


hello_msg:
    db "Hello, Infected File", 10
hello_len equ $ - hello_msg



code_end:

infector:
    push    ebp             ; Save caller state
    mov     ebp, esp
    pushad                  ; Save some more caller state
    
    mov ebx, [ebp + 8]       ; get the char* filename

    mov eax, 5               ; syscall number: open 
    mov ecx, 1025            ; O_WRONLY (1) | O_APPEND (1024)
    int 0x80
    
    mov esi, eax             ; save file descriptor
  

    mov eax, 4               ; syscall number: write
    mov ebx, esi             ; fd
    mov ecx, code_start      ; buffer to write
    mov edx, code_end - code_start   ; number of bytes
    int 0x80

    mov eax, 6               ; syscall number: close
    mov ebx, esi             ; fd
    int 0x80

    popad                   ; Restore caller state (registers)
    mov esp,ebp
    pop     ebp             ; Restore caller state
    ret
