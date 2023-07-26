SYS_write   equ     0x4
SYS_read    equ     0x3
SYS_exit    equ     0x1

section .data
    msg1    db  "Enter strings: ", 0xa
    len_msg1    equ     $-msg1

    msg2    db  "Enter sub-strings: ", 0xa
    len_msg2    equ     $-msg2
    
    msg3    db  "Location: "
    len_msg3    equ     $-msg3
    
    newline db  "",0xa
    
    msg4    db  "Location: [none]"
    len_msg4    equ     $-msg4
    
    msg5    db  "Location: "
    len_msg5    equ     $-msg5

section .bss
    str resb 0x10
    sub_str     resb    0x10
    strlen_buf  resd    0x3
    strlen_sub_buf  resd    0x3
    store   resd    0x3
section .text
    global _start

exit_func:
    mov eax, SYS_exit
    int 0x80

printf_ent_str:
    mov eax, SYS_write
    mov ebx, 0x1
    mov ecx, msg1
    mov edx, len_msg1
    int 0x80
    ret

printf_ent_sub_str:
    mov eax, SYS_write
    mov ebx, 0x1
    mov ecx, msg2
    mov edx, len_msg2
    int 0x80
    ret

location:
    mov eax, SYS_write
    mov ebx, 0x1
    mov ecx, msg5
    mov edx, len_msg5
    int 0x80
    ret

un_location:
    mov eax, SYS_write
    mov ebx, 0x1
    mov ecx, msg4
    mov edx, len_msg4
    int 0x80
    ret

_start:
    call printf_ent_str
    ; input string
    mov eax, SYS_read
    mov ebx, 0x0
    mov ecx, str
    mov edx, 0x10
    int 0x80
    ;store eax --> strlen(str)
    dec eax
    mov dword [strlen_buf], eax
    call printf_ent_sub_str
    ;input sub_string 
    mov eax, SYS_read
    mov ebx, 0x0
    mov ecx, sub_str
    mov edx, 0x10
    int 0x80
    ;store eax --> strlen(sub_str)
    dec eax
    mov dword [strlen_sub_buf], eax

    mov esi, dword [strlen_sub_buf] ;k = strlen(sub_buf) - 1
    mov edi, dword [strlen_buf] ; i = strlen(buffer) - 1
    mov ebx, 0x0 ;count
    mov edx, 0x0 ;store
    mov ecx, edi ;loop initialization with parameter i
    inc ecx
while:
    push rcx
    cmp byte[str+edi], byte[str+esi]
    je OKE
    mov ebx, 0x0 ;count = 0;
    jmp continue
    OKE:
        inc ebx ;count++;
        cmp ebx, dword [strlen_sub_buf]
        jne decrease_k
        dec ecx
        mov edx, ecx  ;store = i 
        jmp break
        decrease_k:
            dec esi
    continue:
    pop rcx
loop while
    break:
    mov dword [store], store
    cmp ebx, dword [strlen_sub_buf] ;  if(count == strlen(sub_buf)){
    je Location
    jne Nope
    Location:
    call location  ; printf("Location: [%d]", store);
    mov eax, SYS_read
    mov ebx, 0x1
    mov ecx, store
    mov edx, 0x3
    int 0x80

    mov eax, SYS_write
    mov ebx, 0x1
    mov ecx, newline
    mov edx, 0x1
    int 0x80

    jmp exit
    Nope:
    call un_location
    jmp exit
    exit:
    call exit_func