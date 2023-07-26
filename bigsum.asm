;nasm -f elf64 bigsum.asm
;ld -s -o bigsum bigsum.o
read     equ     0x3
write    equ     0x4
exit     equ     0x1
stdin   equ     0x0
stdout  equ     0x1

section .data
    msg1    db  "Enter num1: ", 0xa
    len1    equ     $-msg1
    msg2    db  "Enter num2: ", 0xa
    len2    equ     $-msg2
    msg3    db  "SUM of 2 numbers is: "
    len3    equ     $-msg3
section .bss
    buf_num     resq      0xb
    num1    resq    0xb
    num2    resq    0xb
    sum     resq    0xb
section .text
    global _start

_start:
    ; SYS_write msg1
    lea rdx, len1
    mov rcx, msg1
    mov rax, write
    mov rbx, 0x1
    int 0x80      
    ; Input data
    ;SYS_read to read data
    mov rdx, 0xb
    mov rcx, num1
    mov rbx, stdin
    mov rax, read
    int 0x80
    ; Check condition (> 0)
    cmp rax, 0x1
    jl _start
    cmp rax, 0xb
    jg _start
    cmp byte [num1] , 0x2d
    je _start
;###########################
    ; SYS_write msg2
    lea rdx, len2
    mov rcx, msg2
    mov rax, write
    mov rbx, 0x1
    int 0x80      
    ; Input data
    ;SYS_read to read data
    mov rdx, 0xb
    mov rcx, num2
    mov rbx, stdin
    mov rax, read
    int 0x80
    ; Check condition (> 0)
    cmp rax, 0x1
    jl _start
    cmp rax, 0xb
    jg _start
    cmp byte [num2] , 0x2d
    je _start
;Calculate TOTAL
    mov rdi, [num1]
    mov rsi, [num1+8]
    add rdi, [num2]
    add rsi, [num2+8] 
    mov [sum], rdi
    mov [sum+8], rsi
    
; Process Sum | b*0x4010e4
    mov rcx, rax; n = 0xb
    mov rsi, rcx
    dec rcx
    dec rcx
    dec rsi
    dec rsi
    l1: 
        push rcx
        cmp byte [sum+rsi], 0x6a
        jge numgreat72
        sub byte [sum+rsi], 0x30
        jmp _exit
        numgreat72:
            sub byte [sum+rsi], 0x3a
            add byte [sum+rsi-1], 0x1
        _exit:
        dec rsi
        pop rcx 

    loop l1

    cmp byte [sum + rsi], 0x6a
    jge Add_a_Digit
    sub byte [sum+rsi], 0x30
    jmp continue

    Add_a_Digit:
        inc rsi
        shl qword[sum], 0x8
        sub byte [sum+rsi], 0x3a
        add byte[sum + rsi - 1], 0x31
    

    ; ;edit the last byte to 0xa
    ; cmp rax, 0xb
    ; jne continue
    ; mov byte[sum+rax-1], 0xa
    continue:
    mov byte[sum+rax-1] , 0xa 
    ;Print sum of 2 number
    lea rdx, len3
    lea rcx, msg3
    mov rbx, stdout
    mov rax, write
    int 0x80

    lea rdx, 0xb
    lea rcx, sum
    mov rbx, stdout
    mov rax, write
    int 0x80
; EXIT
    mov rax, exit
    int 0x80
