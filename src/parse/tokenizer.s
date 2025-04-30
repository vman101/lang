section .text

is_space:           ; rax: bool (rdi: c)
    cmp c, 8
    jl .false
    cmp c, 13
    je .false
.true:
    mov rax, 1
    ret
.false:
    xor rax, rax
    ret

tokenize:           ; (rdi: char *)
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov [rbp - 8], rdi
    xor rcx, rcx
    mov rsi, rdi


.loop_char:
    mov rdi, [rsi + rcx]
    call is_space
    test rax, rax
    jnz .end_tok


.end_tok:
    jmp .loop_char
