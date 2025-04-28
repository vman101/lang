%include "./src/inc/token.s"

section .data
    global VAL_CONST
    VAL_CONST: db "const", 0

    global VAL_VAR
    VAL_VAR: db "variable", 0

    global VAL_OP_ADD
    VAL_OP_ADD: db "operator '+'", 0

    global VAL_OP_SUB
    VAL_OP_SUB: db "operator '-'", 0

    global VAL_OP_LOAD
    VAL_OP_LOAD: db "operator '='", 0

    global VAL_FUNC
    VAL_FUNC: db "function call", 0

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
    mov rdi, TOK_LOAD
    jmp .set_token

.is_add:
    pop rcx
    push rdi
    mov rdi, TOK_ADD
    jmp .set_token

.is_print:
    pop rcx
    push rdi
    mov rdi, TOK_FUNC
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

