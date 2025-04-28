%include "./src/inc/expression.s"

section .data
    header: db 0xa, "---------", 0xa, "Expr ", 0xa, "---------", 0
    type:   db 0xa, "type: ", 0
section .text
    extern print_tokens
    extern putendl

global print_expression
print_expression:  ; (rdi: expr*)
    push r12
    push rbx

    push rdi
    mov rdi, header
    call putendl
    pop rdi

    mov rsi, [rdi + EXPR_TOK_CNT]
    mov r12, [rdi + EXPR_TOK]          ; r12 = tok*
    mov rdi, r12
    call print_tokens

    pop rbx
    pop r12
    ret
