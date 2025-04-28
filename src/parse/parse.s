%define SIZE_TOK 16
%define TOK_ASSIGN 0
%define TOK_ADD 1
%define TOK_PRINT 2
%define TOK_VAR 3
%define TOK_CONST 4

section .data
    OP_ASSIGN: db "=", 0
    OP_ADD: db "+", 0
    OP_PRINT: db "print", 0

section .text
    global parse
    extern strcmp
    extern malloc
    extern err_malloc
    extern is_num_str
    extern putendl
    extern putnumberendl
    extern get_split_count


;   struct token
;       .type   0
;       .value  +8


token_alloc:    ; rax: tok* (rdi: int cnt)
    mov rax, rdi
    mov rdi, SIZE_TOK
    mul rdi
    mov rdi, rax
    call malloc
    cmp rax, 0
    je err_malloc
    ret

parse:          ; rax: tok* (rdi: char**)
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi

    push r12
    push rbx
    call get_split_count
    mov r12, rax
    mov rdi, rax

    call token_alloc
    mov [rbp - 16], rax         ; store token array in stack

    xor rcx, rcx
.loop:
    push rcx
    mov rdi, [rbp - 8]
    mov rdi, [rdi + rcx * 8]
    cmp qword rdi, 0
    je .done

    mov rsi, OP_ASSIGN
    call strcmp
    cmp rax, 0
    je .is_assign
    mov rsi, OP_ADD
    call strcmp
    cmp rax, 0
    je .is_add
    mov rsi, OP_PRINT
    call strcmp
    cmp rax, 0
    je .is_print
    push rdi
    call is_num_str
    pop rdi
    cmp rax, 1
    je .is_const
    jmp .is_var

.is_assign:
    pop rcx
    push rdi
    mov rdi, TOK_ASSIGN
    jmp .set_token

.is_add:
    pop rcx
    push rdi
    mov rdi, TOK_ADD
    jmp .set_token

.is_print:
    pop rcx
    push rdi
    mov rdi, TOK_PRINT
    jmp .set_token

.is_const:
    pop rcx
    push rdi
    mov rdi, TOK_CONST
    jmp .set_token

.is_var:
    pop rcx
    push rdi
    mov rdi, TOK_VAR
    jmp .set_token

.set_token:
    mov r8, [rbp - 16]
    mov rax, SIZE_TOK
    mul rcx
    mov [r8 + rax], rdi
    pop rdi
    mov [r8 + rax + 8], rdi
    inc rcx
    jmp .loop

.done:
    pop rcx
    mov rax, [rbp - 16]
    pop rbx
    pop r12
    mov rsp, rbp
    pop rbp
    ret

