section .data
    token: db 0xa, "Token ", 0
    type: db "type = ", 0
    value: db "value = ", 0

section .text
    global print_tokens
    extern putstr
    extern putendl
    extern putchar
    extern putnumberendl
    extern get_split_count



;   struct token
;       .type   0
;       .value  +8

print_tokens:       ; (rdi: tok*, rsi: tok_count)
    push rbp
    mov rbp, rsp

    sub rsp, 16

    push r12
    push r13
    push r14
    push rbx

    mov r14, rsi

    mov [rbp - 8], rdi

    mov rbx, rdi
    xor rcx, rcx
.loop:
    cmp rcx, r14
    je .done
    mov r12, rcx
    mov rdi, token
    call putstr
    mov rdi, r12
    call putnumberendl

    mov rdi, type
    call putstr
    mov rax, 16
    mul r12
    mov rbx, [rbp - 8]
    lea r13, [rbx + rax]
    mov rdi, [r13]
    push rax
    call putnumberendl

    mov rdi, value
    call putstr
    pop rax

    mov rbx, [rbp - 8]
    lea r13, [rbx + rax]
    mov rdi, [r13 + 8]

    call putendl
    mov rcx, r12
    inc rcx
    jmp .loop

.done:
    pop rbx
    pop r14
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret
