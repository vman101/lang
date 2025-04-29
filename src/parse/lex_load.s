%include "./src/inc/lexer.s"
%include "./src/inc/expression.s"
%include "./src/inc/token.s"
%include "./src/inc/regs.s"

section .text
    extern malloc
    extern err_malloc
    extern exit
    extern putstr
    extern create_expressions
    extern strcmp
    extern VAL_OP_LOAD
    extern VAL_OP_ADD
    extern VAL_VAR
    extern VAL_CONST
    extern putchar
    extern putnumber
    extern putendl
    extern get_vars
    extern insert_var
    extern insert_mov
    extern load_var_rax
    extern load_rax_var
    extern op_const_rax
    extern op_var_rax
    extern xor_reg
    extern look_up_var

    extern lex_eexpect
    extern lex_eundefined


    global lex_load

; look_up_var:      ; rax: OFF_S (rdi: vars*, rsi: name*, rdx: n)
process_var:        ; (rdi: lex*, rsi: name*, rdx: tok_op)
    push rbp
    mov rbp, rsp
    sub rsp, 16

    push rdx
    push rdi

    ; !!! will exit if var not defined
    call look_up_var
    pop rdi
    pop rdx

    mov rdi, rax
    mov rsi, rdx
    call op_var_rax

    mov rsp, rbp
    pop rbp
    ret

process_token:      ; rax: new_last_tok_type (rdi: lex*, rsi: *tok, rdx: last_tok_type)
    cmp rdx, TOK_VAR
    je .expect_operator
    cmp rdx, TOK_CONST
    je .expect_operator
    cmp rdx, TOK_ADD
    je .expect_value
    cmp rdx, TOK_SUB
    je .expect_value

.expect_value:
    cmp qword [rsi + TOK_TYPE], TOK_VAR
    je .process_var
    cmp qword [rsi + TOK_TYPE], TOK_CONST
    je .process_const
    mov rdi, VAL_VAR
    call lex_eexpect

.process_var:
    mov rsi, [rsi + TOK_VALUE]
    call process_var
    mov rax, TOK_VAR
    jmp .done

.process_const:
    mov rsi, [rsi + TOK_VALUE]
    mov rsi, rdx
    call op_const_rax
    mov rax, TOK_CONST
    jmp .done

.expect_operator:
    cmp qword [rsi + TOK_TYPE], TOK_ADD
    je .process_add
    cmp qword [rsi + TOK_TYPE], TOK_SUB
    je .process_sub
    mov rdi, VAL_OP_ADD
    call lex_eexpect

.process_add:
    mov rax, TOK_ADD
    jmp .done
.process_sub:
    mov rax, TOK_SUB

.done:
    ret

is_assignment:    ; rax: OFF_S (rdi: expr*)
    xor rax, rax

    mov rcx, [rdi + EXPR_TOK_CNT]
    mov rdx, [rdi + EXPR_TOK]

    cmp qword [rdx + TOK_TYPE], TOK_VAR
    jne .done

    cmp qword [rdx + TOK_TYPE + SIZE_TOK], TOK_LOAD
    jne .done

    mov rax, 1

.done:
    ret

lex_load:     ; (rdi: lex*)
    push rbp
    mov rbp, rsp
    sub rsp, 48

    ; store lexer
    mov [rbp - 8], rdi

    ; store expression based on lexer expression index
    mov rsi, [rdi + LEX_EXPR]
    mov rax, [rdi + LEX_EXPR_IDX]
    imul rax, EXPR_SIZE
    lea rsi, [rsi + rax]
    mov [rbp - 16], rsi

    ; store tok_cnt
    mov rsi, [rsi + EXPR_TOK_CNT]
    mov [rbp - 24], rsi

    ; local var store last token type
    mov qword [rbp - 32], -1

    mov rdi, [rbp - 16]
    push rdi
    call is_assignment
    test rax, rax
    jz .done_false

    mov rdi, [rbp - 8]
    mov rsi, [rbp - 16]
    mov rsi, [rsi + EXPR_TOK]
    mov rsi, [rsi + TOK_VALUE]

    call look_up_var
    mov [rbp - 40], rax

    mov rdi, [rbp - 16]
    mov rdi, [rdi + EXPR_TOK]
    mov rdi, [rdi + TOK_VALUE]

    mov rdi, REG_RAX
    call xor_reg

    pop rdi

    ; advance token ptr
    mov rsi, [rdi + EXPR_TOK]

    xor rcx, rcx
    add rcx, 2
    lea rsi, [rsi + SIZE_TOK * 2]

.loop_tokens:
    cmp rcx, [rbp - 24]
    je .done_true

    push rcx
    push rsi

    mov rdx, [rbp - 32]
    mov rdi, [rbp - 8]
    call process_token

    pop rsi
    mov [rbp - 32], rax
    add rsi, SIZE_TOK

    pop rcx
    inc rcx
    jmp .loop_tokens

.done_true:
    mov rdi, [rbp - 40]
    call load_rax_var
    mov rax, 1
.done_false:
    mov rsp, rbp
    pop rbp
    ret
