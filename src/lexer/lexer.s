%include "./src/inc/token.s"
%include "./src/inc/lexer.s"
%include "./src/inc/expression.s"
%include "./src/inc/asm_output.s"

section .text
    extern malloc
    extern err_malloc
    extern exit
    extern putstr
    extern putendl

    extern create_expressions
    extern strcmp
    extern get_vars
    extern lex_load
    extern lex_func_call
    extern lex_eundefined

    extern func_prologue
    extern func_epilogue
    extern memset

    extern program_prologue

global lex
lex:            ; rax: lex* (rdi: char *file_content)
    push rbp
    mov rbp, rsp
    sub rsp, 32
    push rbx

    mov [rbp - 8], rdi

    ; allocate lexer
    mov rdi, LEX_SIZE
    call malloc
    cmp rax, 0
    je err_malloc

    ; zero out lexer
    push rax
    mov rdi, rax
    mov rsi, 0
    mov rdx, LEX_SIZE
    call memset

    pop rax
    mov [rbp - 24], rax     ; store lex on stack

    lea rsi, [rbp - 16]     ; int* expr_cnt
    mov rdi, [rbp - 8]      ; restore file_content

    call create_expressions

    mov rdi, [rbp - 24]
    mov [rdi + LEX_EXPR], rax
    mov eax, dword [rbp - 16]
    mov dword [rdi + LEX_EXPR_CNT], eax

    call get_vars

    mov rdi, [rbp - 24]
    call program_prologue

    mov rdi, [rbp - 24]
    mov edi, dword [rdi + LEX_VAR_CNT]

    call func_prologue

    mov rax, [rbp - 24]
    lea rcx, [rax + LEX_EXPR_IDX]

.process_expressions:
    mov rdi, [rbp - 24]
    mov esi, [rdi + LEX_EXPR_CNT]
    cmp dword [rcx], esi
    je .done

    push rcx

    call lex_load
    test rax, rax
    jnz .loop_epilog
    mov rdi, [rbp - 24]
    call lex_func_call
    jnz .loop_epilog

.loop_epilog:
    pop rcx
    inc dword [rcx]

    jmp .process_expressions
.done:
    call func_epilogue
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

global look_up_var
look_up_var:        ; rax: bool (rdi: lex*, rsi: name*)
    push rbp
    mov rbp, rsp
    xor rax, rax

    xor rcx, rcx
    mov edx, dword [rdi + LEX_VAR_CNT]
    mov rdi, [rdi + LEX_VAR]

.loop_vars:
    cmp rcx, rdx
    je .not_found
    push rdi
    mov rdi, [rdi]
    call strcmp
    pop rdi
    cmp rax, 0
    je .found
    inc rcx
    add rdi, VAR_SIZE
    jmp .loop_vars

.not_found:
    mov rdi, rsi
    call lex_eundefined

.found:
    mov rax, [rdi + VAR_OFFS]
.done:
    mov rsp, rbp
    pop rbp
    ret
