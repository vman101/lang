%include "./src/inc/token.s"
%include "./src/inc/lexer.s"
%include "./src/inc/expression.s"
%include "./src/inc/asm_output.s"

%define LEX_ERROR 0xa, "[LEX_ERROR] "

section .data
    EEXPECT: db LEX_ERROR, "expected: ", 0

    MOV: db "mov ", 0
    OPEN_STACK_VAR: db "[rbp - ", 0
    CLOSE_STACK_VAR: db "], ", 0


section .text
    extern malloc
    extern err_malloc
    extern exit
    extern putstr
    extern create_expressions
    extern strcmp
    extern VAL_OP_LOAD
    extern putchar
    extern putnumber
    extern putendl

lex_eexpect:      ; (rdi: tok_type)
    push rdi
    mov rdi, EEXPECT
    call putstr
    pop rdi
    call putstr
    mov rdi, 1
    call exit


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
    mov [rbp - 16], rax

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
    cmp qword [rax + TOK_TYPE], TOK_VAR
    jne .skip_alloc
    mov rbx, [rbp - 24]
    mov rbx, [rbx + LEX_VAR]
    lea rbx, [rbx + r12]
    mov r8, [rax + TOK_VALUE]
    mov [rbx + VAR_NAME], r8
    inc r9
    mov rax, r8
    mov rax, 8
    push rdx
    mul r9
    pop rdx
    mov [rbx + VAR_OFFS], rax
    mov rax, r8

.skip_alloc:
    add rax, SIZE_TOK
    inc rcx
    jmp .loop_toks

.done:
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

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
    mov [rbp - 24], rax     ; store lex on stack

    lea rsi, [rbp - 16]     ; int* expr_cnt
    mov rdi, [rbp - 8]      ; restore file_content

    call create_expressions

    mov rdi, [rbp - 24]
    mov [rdi + LEX_EXPR], rax
    mov rax, [rbp - 16]
    mov [rdi + LEX_EXPR_CNT], rax

    call get_vars

    xor rcx, rcx

.process_expressions:
    mov rdi, [rbp - 24]
    mov esi, [rdi + LEX_EXPR_CNT]
    cmp ecx, esi
    je .done

    mov rbx, [rdi + LEX_EXPR]
    mov rax, EXPR_SIZE
    mul rcx
    push rcx
    mov rdi, [rbx + rax + EXPR_TOK]

    mov rdx, [rbp - 24]
    call lex_assignment
    pop rcx

    inc rcx

    jmp .process_expressions
.done:
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

lex_assignment:     ; (rdi: tok*, rsi: n, rdx: lex*)
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov [rbp - 16], rdi     ; store tok array
    mov rdi, [rdx + LEX_VAR_CNT]
    mov [rbp - 8], edi      ; var_cnt
    mov rdi, [rdx + LEX_VAR]
    mov [rbp - 24], rdi     ; vars

    ; check first token: if not TOK_VAR, cant be assign
    mov rdi, [rbp - 16]
    mov rdx, [rdi + TOK_TYPE]
    cmp rdx, TOK_VAR
    jne .done_false

    xor rcx, rcx

    push rdi

    mov rsi, [rdi + TOK_VALUE]
    mov rdi, [rbp - 24]
    mov rdx, [rbp - 8]

    call look_up_var
    push rax

    mov rdi, MOV
    call putstr
    mov rdi, OPEN_STACK_VAR
    call putstr
    pop rdi
    call putnumber
    mov rdi, CLOSE_STACK_VAR
    call putstr

    pop rdi

    add rdi, SIZE_TOK
    mov rdx, [rdi + TOK_TYPE]
    cmp rdx, TOK_LOAD
    jne .err_found

    add rdi, SIZE_TOK
    mov rdx, [rdi + TOK_TYPE]
    cmp rdx, TOK_CONST
    je .print_const
    cmp rdx, TOK_VAR
    je .done_true


.done_false:
    mov rax, 0
    ret

.done_true:
    mov rsp, rbp
    pop rbp
    cmp rcx, rsi
    jne .done_false
    mov rax, 1
    ret

.err_found:
    mov rdi, VAL_OP_LOAD
    call lex_eexpect

.print_const:
    mov rdi, [rdi + TOK_VALUE]
    call putendl
    jmp .done_true

look_up_var:        ; rax: bool (rdi: vars*, rsi: name*, rdx: n)
    push rbp
    mov rbp, rsp
    xor rax, rax

    xor rcx, rcx

.loop_vars:
    cmp rcx, rdx
    je .done
    cmp [rdi], rsi
    je .found
    inc rcx
    add rdi, VAR_SIZE
    jmp .loop_vars

.found:
    mov rax, [rdi + VAR_OFFS]
.done:
    mov rsp, rbp
    pop rbp
    ret
