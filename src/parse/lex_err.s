%define LEX_ERROR 0xa, "[LEX_ERROR] "

section .data
    EEXPECT: db LEX_ERROR, "expected: ", 0
    EUNDEFINED: db LEX_ERROR, "undefined: ", 0

section .text
    extern putstr
    extern putendl
    extern exit
    extern print_token_type

global lex_eundefined
lex_eundefined:     ; (rdi: tok_val*)
    push rdi
    mov rdi, EUNDEFINED
    call putstr
    pop rdi
    call putendl
    mov rdi, 1
    call exit

global lex_eexpect
lex_eexpect:      ; (rdi: tok_type)
    push rdi
    mov rdi, EEXPECT
    call putstr
    pop rdi
    call print_token_type
    mov rdi, 1
    call exit
