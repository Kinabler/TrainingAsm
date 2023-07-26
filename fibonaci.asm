SYS_write    equ     0x4
SYS_read     equ     0x3
SYS_exit     equ     0x1
stdout       equ     0x1
stdin        equ     0x0
section .data
    msg1    db  "Enter n that you is number of display: "
    len1    equ $-msg1
    msg2    db  "Your fibonaci sequence: ", 0xa
    len2    equ $-msg2
    msg3    db  " "
    len3    equ $-msg3
    msg4    db  "",0xa
    len4    equ $-msg4
section .bss
    request     resd    0x3
    last_num    resd    0x8   
section .text
    global _start

; use convert string to number algorithms
_process_num:
    mov rcx, rax  ;move number of entered to rsi
    mov rbx, rax
    mov rdx, 0  ;where to save sum of number entered
    mov rdi, 0  ;i = 0
    dec rcx
    l1:
        push rcx
        cmp rdi, rbx ; compare (i & 4)
        jge exit_loop
        jl proc
        proc:
            mov rsi, rdx
            shl rdx, 3
            shl rsi, 1
            add rdx, rsi
            sub byte [request+rdi], 0x30
            add dl, byte [request+rdi]
            inc rcx
            inc rdi
        jmp exit_loop
        exit_loop:
        pop rcx
    loop l1
    mov qword [request], rdx
    ret

_printf:
    add byte[last_num], 0x30 ;convert to number
    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, last_num
    mov edx, 0x8
    int 0x80

    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, msg3
    mov edx, len3
    int 0x80
    ret

_start:
    ;printf("Enter n: ");
    mov rax, SYS_write
    mov rbx, stdout
    mov rcx, msg1
    mov rdx, len1
    int 0x80
    ;scanf("%d", &request)
    mov rax, SYS_read
    mov rbx, stdin
    mov rcx, request
    mov rdx, 0x3
    int 0x80
    ;############# CONVERT #############
    ;merge to a number(purpose is use for rcx): 
    ; Example: when you entered:12 --> \x31\x32
    call _process_num; (rsi, request)

    ;############# FIBONACI ############
    ; |rdx = n| rax = size |
    xor rbx, rbx
    xor rdi, rdi  ;num = 0
    xor rsi, rsi   ;num1 = 1
    inc rsi
    mov rcx, rdx  ;rcx = n
    xor rdx, rdx    ;last_num
    inc rcx
    l2:
        push rcx
        mov rdx, rsi    ;last_num = num1;
        add rsi, rdi    ;num1 += num; 
        mov rdi, rdx    ;num = last_num;
        mov qword [last_num], rdx
        push rdx
        push rsi
        push rdi
        push rax
        call _printf
        xor rbx, rbx
        xor rdi, rdi
        xor rsi, rsi
        xor rdx, rdx
        pop rax
        pop rdi
        pop rsi
        pop rdx
        pop rcx
    loop l2    

exit_start:
    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, msg4
    mov edx, len4
    int 0x80
    mov rax, SYS_exit
    int 0x80
