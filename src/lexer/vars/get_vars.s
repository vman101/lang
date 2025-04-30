%include "./src/inc/token.s"
%include "./src/inc/lexer.s"
%include "./src/inc/expression.s"

section .text
    extern malloc
    extern err_malloc
    extern strcmp

    global count_vars
    global get_vars


got_var:             ; rax: bool (rdi: lex*, rsi: name*)
    push r12
    push r13

    mov r12, [rdi + LEX_VAR]
    lea r13, [rdi + LEX_VAR_CNT]
    xor rcx, rcx

.loop_vars:
    cmp ecx, [r13d]
    je .doesnt_have
    mov rdi, [r12 + VAR_NAME]
    push rcx
    call strcmp
    pop rcx
    cmp rax, 0
    je .does_have
    inc rcx
    add r12, VAR_SIZE
    jmp .loop_vars

.does_have:
    mov rax, 1
    jmp .done

.doesnt_have:
    xor rax, rax
    inc dword [r13d]

.done:
    pop r13
    pop r12
    ret

count_vars:         ; rdi: lex*
    push rbp
    mov rbp, rsp
    sub rsp, 16
    push rbx
    push r12
    xor r12, r12

    mov rbx, [rdi + LEX_EXPR]

    xor rcx, rcx
    push rcx
.loop_expr:
    pop rcx
    cmp ecx, dword [rdi + LEX_EXPR_CNT]
    je .done
    mov rax, EXPR_SIZE
    mul rcx
    lea rax, [rbx + rax]
    mov rdx, [rax + EXPR_TOK_CNT]
    inc rcx
    push rcx
    xor rcx, rcx
    mov rax, [rax + EXPR_TOK]
.loop_toks:
    cmp rcx, rdx
    je .loop_expr
    cmp qword [rax + TOK_TYPE], TOK_VAR
    jne .no_var
    inc r12
.no_var:
    inc rcx
    add rax, SIZE_TOK
    jmp .loop_toks

.done:
    mov dword [rdi + LEX_VAR_CNT], r12d
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

get_vars:           ; (rdi: lex*)
    push rbp
    mov rbp, rsp
    sub rsp, 32
    push rbx
    push r12
    xor r12, r12
    xor r9, r9

    call count_vars

    mov [rbp - 24], rdi     ; store lex
    mov eax, dword [rdi + LEX_VAR_CNT]
    mov [rbp - 32], rax

    mov dword [rdi + LEX_VAR_CNT], 0

    mov rdi, VAR_SIZE
    mul rdi
    mov rdi, rax
    call malloc
    cmp rax, 0
    je err_malloc

    mov rdi, [rbp - 24]
    mov [rdi + LEX_VAR], rax

    mov eax, dword [rdi + LEX_EXPR_CNT]
    mov [rbp - 8], eax
    mov rax, [rdi + LEX_EXPR]
    mov [rbp - 16], rax         ; store expr*

    xor rcx, rcx
    push rcx
.loop_expr:
    pop rcx
    cmp ecx, dword [rdi + LEX_EXPR_CNT]
    je .done
    mov rax, EXPR_SIZE
    mul rcx
    mov rbx, [rbp - 16]
    lea rax, [rbx + rax]
    mov rdx, [rax + EXPR_TOK_CNT]
    inc rcx
    push rcx
    xor rcx, rcx
    mov rax, [rax + EXPR_TOK]

.loop_toks:
    cmp rcx, rdx
    je .loop_expr
    push rdx
    cmp qword [rax + TOK_TYPE], TOK_VAR
    jne .skip_alloc
    mov rbx, [rbp - 24]         ; load lex
    mov rbx, [rbx + LEX_VAR]
    mov r8, rax
    push rax
    push rdi
    push rcx
    mov rdi, [rbp - 24]
    mov rsi, [rax + TOK_VALUE]
    push r9
    call got_var
    pop r9
    pop rcx
    pop rdi
    cmp rax, 1
    je .skip_alloc
    mov rax, VAR_SIZE
    mul r9
    lea rbx, [rbx + rax]
    pop rax
    mov r8, [rax + TOK_VALUE]
    mov [rbx + VAR_NAME], r8
    mov r8, rax
    inc r9
    mov rax, 8
    mul r9
    mov [rbx + VAR_OFFS], rax

.skip_alloc:
    mov rax, r8
    add rax, SIZE_TOK
    inc rcx
    pop rdx
    jmp .loop_toks

.done:
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

