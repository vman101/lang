%include "./src/inc/c_alignment.s"
%include "./src/inc/lexer.s"
%include "./src/inc/token.s"
%include "./src/inc/expression.s"

section .data
    prologue: db "section .text", 0xa, 0
    program_entry: db "global _start", 0xa, "_start:", 0xa, 0
    extern_str: db "extern %s", 0x0a, 0


section .text
    extern putendl
    extern putstr
    extern fd_out
    extern ft_fprintf

    global program_prologue

print_program_entry:
    mov rdi, [fd_out]
    mov rsi, program_entry
    c_call ft_fprintf
    ret

print_section_text:
    mov rdi, [fd_out]
    mov rsi, prologue
    c_call ft_fprintf
    ret

declare_extern:         ; (rdi: func_name*)
    push rdi
    mov rdi, [fd_out]
    mov rsi, extern_str
    pop rdx
    c_call ft_fprintf
    ret

declare_extern_func:    ;(rdi: lex*)
    push rbp
    mov rbp, rsp

    sub rsp, 16

    push rbx
    xor rcx, rcx

    mov rax, [rdi + LEX_EXPR]
    mov [rbp - 8], rax
    mov eax, dword [rdi + LEX_EXPR_CNT]
    mov [rbp - 12], eax
.loop:
    cmp ecx, [rbp - 12]
    je .loop_end
    mov rbx, [rbp - 8]
    mov rax, EXPR_SIZE
    imul rax, rcx
    lea rbx, [rbx + rax]
    mov r8, [rbx + EXPR_TOK_CNT]
    mov rbx, [rbx + EXPR_TOK]
    push rcx
    xor rcx, rcx
.loop_tokens:
    cmp rcx, r8
    je .loop_tokens_end
    mov rax, SIZE_TOK
    imul rax, rcx
    lea rax, [rbx + rax]
    mov rdx, TOK_FUNC
    cmp rdx, qword [rax + TOK_TYPE]
    jne .dont_print
    mov rdi, [rax + TOK_VALUE]
    push rcx
    push r8
    call declare_extern
    pop r8
    pop rcx
.dont_print:
    inc rcx
    jmp .loop_tokens
.loop_tokens_end:
    pop rcx
    inc rcx
    jmp .loop

.loop_end:
    pop rbx

    mov rsp, rbp
    pop rbp
    ret

program_prologue:   ;(rdi: lex*)
    push rdi
    call print_section_text
    pop rdi
    call declare_extern_func
    call print_program_entry
    ret
