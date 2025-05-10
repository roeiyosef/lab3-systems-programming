global _start
extern strlen       ; from util.c

section .data
newline db 10

section .bss
Infile  resd 1
Outfile resd 1
buffer  resb 1

section .text
_start:
    mov dword [Infile], 0
    mov dword [Outfile], 1

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

    
    call read_char

    mov     ebx,eax
    mov     eax,1
    int     0x80
    nop

main: 
 push ebp
 mov ebp, esp

 mov ecx, [ebp+8] ; Get first argument ac
 mov edi, ecx     ; Save argc into edi
 mov edx, [ebp+12] ; Get 2nd argument av


Next:
    
    mov eax, [edx]        ; eax = argv[i]
    push eax              ; save for printing later
    mov ebx, eax          ; ebx = argv[i] for flag check

    cmp word [ebx], 0x692D    ; "-i"
    je open_input

    cmp word [ebx], 0x6F2D    ; "-o"
    je open_output




print:
    pop eax               ; restore argv[i] for printing
    pushad

    push eax     ; push argv[i] as arg to strlen
    call strlen
    pop ebx              ; get back argv[i]
    mov edx, eax         ; len
    mov ecx, ebx         ; buffer
    mov ebx,2           
    mov eax, 4           ; syscall: write
    int 0x80


    ; print newline
    mov eax, 4
    mov ebx, 2
    mov ecx, newline
    mov edx, 1
    int 0x80

    
    popad

    add edx, 4           ; next argv[i]
    dec edi
    jnz Next
    
    mov esp, ebp
    pop ebp
    ret

open_input:
    pushad
    add eax, 2              ; skip "-i"
    mov ebx, eax            ; filename
    mov eax, 5              ; syscall: open
    mov ecx, 0              ; flags: read-only
    int 0x80
    mov [Infile], eax
    popad

    jmp print

open_output:
    pushad
    add eax, 2              ; skip "-o"
    mov ebx, eax            ; filename
    mov eax, 5              ; syscall: open
    mov ecx, 577            ; O_WRONLY | O_CREAT | O_TRUNC
    mov edx, 0777           ; file permissions
    int 0x80
    mov [Outfile], eax

    popad
    jmp print


read_char:
      push ebp
      mov ebp, esp

loop:

    mov eax, 3              ; syscall: read
    mov ebx, [Infile]
    mov ecx, buffer
    mov edx, 1
    int 0x80

    cmp eax, 0              ; check EOF or error
    jle done

    ; Encode the byte
    mov al, [buffer]
    call encode
    mov [buffer], al

    ; Write 1 byte to outfile
    mov eax, 4
    mov ebx, [Outfile]
    mov ecx, buffer
    mov edx, 1
    int 0x80

    jmp loop



done:
    mov esp, ebp
    pop ebp
    ret

encode:
    cmp al, 'A'
    jl not_enough
    cmp al, 'Z'
    jg not_enough
    sub al, 1

not_enough:
    ret