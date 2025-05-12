%include "./src/inc/lexer.s"
%include "./src/inc/expression.s"
%include "./src/inc/function_table.s"
%include "./src/inc/token.s"

%define FUNC_ERR    "[FUNC_ERROR]"

section .data
    err_func_args_message: db FUNC_ERR, "invalid argument", 0
    extern func_call
    extern func_call_prologue
    extern func_call_epilogue
    extern REG_RDI

section .text
    global lex_func_call
    extern ftable
    extern strcmp
    extern lex_eundefined
    extern putstr
    extern putendl
    extern putnumberendl
    extern exit
    extern look_up_var
    extern insert_mov
    extern load_var_reg
    extern load_const_reg

insert_func_with_const:    ; (rdi: name*, rsi: arg*)
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov [rbp - 8], rdi  ; store name
    mov [rbp - 16], rsi ; store arg

    mov rdi, func_call_prologue
    call putendl

    mov rdi, [rbp - 16]
    mov rsi, REG_RDI
    call load_const_reg
    mov rdi, func_call
    call putstr
    mov rdi, [rbp - 8]
    call putendl
    mov rdi, func_call_epilogue
    call putendl

    mov rsp, rbp
    pop rbp
    ret

insert_func_with_var:    ; (rdi: name*, rsi: arg*)
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov [rbp - 8], rdi  ; store name
    mov [rbp - 16], rsi ; store arg

    mov rdi, func_call_prologue
    call putendl

    mov rdi, [rbp - 16]
    mov rsi, REG_RDI
    call load_var_reg
    mov rdi, func_call
    call putstr
    mov rdi, [rbp - 8]
    call putendl
    mov rdi, func_call_epilogue
    call putendl

    mov rsp, rbp
    pop rbp
    ret

err_func_args:
    mov rdi, err_func_args_message
    call putendl
    mov rdi, 1
    call exit

; does not change rdi
global look_up_func
look_up_func:           ; (rdi: name*)
    push rbx
    mov rbx, FTABLE_COUNT
    xor rcx, rcx

.search_func:
    cmp rcx, rbx
    je .done_false

    ; rdi still contains name
    push rcx
    mov rax, FTABLE_SYM
    inc rcx
    imul rax, rcx
    mov rsi, [ftable + rax]
    call strcmp
    test rax, rax
    pop rcx
    jz .done_true

    inc rcx

    jmp .search_func

.done_true:
    mov rax, 1
    jmp .done

.done_false:
    xor rax, rax

.done:
    pop rbx
    ret

lex_func_call:           ;   rax: bool (rdi :lex *)
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov [rbp - 8], rdi      ; store lex

    ; store expression based on lexer expression index
    mov rsi, [rdi + LEX_EXPR]
    mov rax, [rdi + LEX_EXPR_IDX]
    imul rax, EXPR_SIZE
    lea rsi, [rsi + rax]
    mov [rbp - 16], rsi

    mov rdi, [rsi + EXPR_TOK_CNT]
    mov rax, [rsi + EXPR_TOK]

    cmp qword [rax + TOK_TYPE], TOK_FUNC
    jne .done
    cmp rdi, 2
    jne err_func_args

    mov rdi, [rax + TOK_VALUE]
    push rdi

    call look_up_func
    test rax, rax
    pop rdi
    jz lex_eundefined

    mov [rbp - 24], rdi

    mov rdi, [rbp - 16]
    mov rsi, [rdi + EXPR_TOK]
    lea rsi, [rsi + SIZE_TOK]

    cmp qword [rsi + TOK_TYPE], TOK_CONST
    je .arg_const
    cmp qword [rsi + TOK_TYPE], TOK_VAR
    je .arg_var

    call err_func_args

.arg_const:
    mov rdi, [rbp - 24]
    mov rsi, [rsi + TOK_VALUE]
    call insert_func_with_const
    jmp .done

.arg_var:
    mov rdi, [rbp - 8]
    mov rsi, [rsi + TOK_VALUE]
    call look_up_var
    mov rsi, rax
    mov rdi, [rbp - 24]
    call insert_func_with_var


.done:
    mov rsp, rbp
    pop rbp
    ret


