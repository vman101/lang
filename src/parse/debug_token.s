%include "./src/inc/token.s"

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
    extern VAL_CONST
    extern VAL_VAR
    extern VAL_OP_ADD
    extern VAL_OP_SUB
    extern VAL_OP_LOAD
    extern VAL_FUNC

global print_token_type
print_token_type:   ; (rdi: int)
    cmp rdi, TOK_LOAD
    je .tok_load
    cmp rdi, TOK_ADD
    je .tok_add
    cmp rdi, TOK_SUB
    je .tok_sub
    cmp rdi, TOK_CONST
    je .tok_const
    cmp rdi, TOK_VAR
    je .tok_var
    cmp rdi, TOK_FUNC
    je .tok_func

.tok_load:
    mov rdi, VAL_OP_LOAD
    jmp .print

.tok_add:
    mov rdi, VAL_OP_ADD
    jmp .print

.tok_sub:
    mov rdi, VAL_OP_SUB
    jmp .print

.tok_const:
    mov rdi, VAL_CONST
    jmp .print

.tok_var:
    mov rdi, VAL_VAR
    jmp .print

.tok_func:
    mov rdi, VAL_FUNC
    jmp .print

.print:
    call putendl
    ret

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
    mov rdi, [r13 + TOK_TYPE]
    push rax
    call print_token_type

    mov rdi, value
    call putstr
    pop rax

    mov rbx, [rbp - 8]
    lea r13, [rbx + rax]
    mov rdi, [r13 + TOK_VALUE]

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
